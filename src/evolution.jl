export Evolution, step!, run!

mutable struct Evolution
    log::AbstractLogger
    population::Array{Individual}
    gen::Int64
    cfg::Dict
    mutation::Function
    crossover::Function
    selection::Function
    evaluation::Function
end

function Evolution(itype::Type, cfg::Dict;
                   id::String=string(UUIDs.uuid4()),
                   logfile::String=string("logs/", id, ".log"),
                   populate::Function=default_populate,
                   mutation::Function=uniform_mutation,
                   crossover::Function=uniform_crossover,
                   selection::Function=tournament_selection,
                   evaluation::Function=random_evaluate)
    io = open(logfile, "w+")
    logger = SimpleLogger(io)
    population = populate(itype, cfg)
    Evolution(logger, population, 0, cfg, mutation, crossover,
              selection, evaluation)
end

function select(e::Evolution)
    inds = shuffle!(collect(1:length(e.population)))
    e.selection(e.population[inds[1:e.cfg["n_selection"]]])
end

function evaluate!(e::Evolution)
    fits = SharedArrays.SharedArray{Float64}(e.cfg["n_fitness"],
                                             length(e.population))
    @sync @distributed for i in eachindex(e.population)
        fits[:, i] = e.evaluation(e.population[i])
    end
    for i in eachindex(e.population)
        e.population[i].fitness .= fits[:, i]
    end
end

function populate!(e::Evolution)
    new_pop = Array{Individual}(undef, 0)
    if e.cfg["n_elite"] > 0
        sort!(e.population)
        append!(new_pop,
                e.population[(length(e.population)-e.cfg["n_elite"]+1):end])
    end
    for i in (e.cfg["n_elite"]+1):e.cfg["n_population"]
        p1 = select(e)
        child = deepcopy(p1)
        if rand() < e.cfg["p_crossover"]
            parents = vcat(p1, [select(e) for i in 2:e.cfg["n_parents"]])
            child = e.crossover(parents)
        end
        if rand() < e.cfg["p_mutation"]
            child = e.mutation(child)
        end

        push!(new_pop, child)
    end
    e.population = new_pop
end

function log_gen(e::Evolution)
    maxs = map(i->maximum(i.fitness), e.population)
    with_logger(e.log) do
        @info ""
    end
    flush(e.log.stream)
end

function save_gen(e::Evolution)
    # save the entire population
    mkpath(Formatting.format("gens/{:04d}", e.gen))
    sort!(e.population)
    for i in eachindex(e.population)
        f = open(Formatting.format("{:04d}", i))
        write(f, JSON.json(e.population[i]))
        close(f)
    end
end

function step!(e::Evolution)
    e.gen += 1
    if e.gen > 1
        populate!(e)
    end
    evaluate!(e)
    if ((e.cfg["log_gen"] > 0) && mod(e.gen, e.cfg["log_gen"]) == 0)
        log_gen(e)
    end
    if ((e.cfg["save_gen"] > 0) && mod(e.gen, e.cfg["save_gen"]) == 0)
        save_gen(e)
    end
end

function run!(e::Evolution)
    for i in (e.gen+1):e.cfg["n_gen"]
        step!(e)
    end
end
