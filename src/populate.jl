function tournament_selection(pop::Array{Individual}, t_size::Int64)
    inds = shuffle!(collect(1:length(pop)))
    sort(pop[inds[1:t_size]])[end]
end

function max_selection(pop::Array{Individual})
    sort(pop)[end]
end

function random_selection(pop::Array{Individual})
    pop[rand(1:length(pop))]
end

function oneplus_populate!(e::Evolution;
                           mutation::Function=uniform_mutation,
                           selection::Function=max_selection)
    p1 = copy(selection(e.population))
    empty!(e.population)
    push!(e.population, p1)
    for i in 2:e.cfg["n_population"]
        push!(e.population, mutation(p1))
    end
end

function ga_populate!(e::Evolution;
                      mutation::Function=uniform_mutation,
                      crossover::Function=uniform_crossover,
                      selection::Function=x->tournament_selection(x, e.cfg["tournament_size"]))
    new_pop = Array{Individual}(undef, 0)
    if e.cfg["n_elite"] > 0
        sort!(e.population)
        append!(new_pop,
                e.population[(length(e.population)-e.cfg["n_elite"]+1):end])
    end
    for i in (e.cfg["n_elite"]+1):e.cfg["n_population"]
        p1 = selection(e.population)
        child = deepcopy(p1)
        if e.cfg["p_crossover"] > 0 && rand() < e.cfg["p_crossover"]
            parents = vcat(p1, [selection(e.population) for i in 2:e.cfg["n_parents"]])
            child = crossover(parents...)
        end
        if e.cfg["p_mutation"] > 0 && rand() < e.cfg["p_mutation"]
            child = mutation(child)
        end
        push!(new_pop, child)
    end
    e.population = new_pop
end

function cmaes_populate!(e::Evolution)
    # TODO, rewrite cmaes.jl
end

function nsga2_populate!(e::Evolution)
    # TODO
end

