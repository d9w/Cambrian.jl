export GAEvo, evaluate, populate

"""

GAEvo implements a classic genetic algorithm. To do this, a new subtype of
AbstractEvolution is created, GAEvo, and the following functions are
defined for this type:

evaluate
populate

the function generation can also be defined. Without specification, the default
generation function (which is void) is applied.
"""
mutable struct GAEvo{T} <: AbstractEvolution
    config::NamedTuple
    logger::CambrianLogger
    population::Array{T}
    fitness::Function
    gen::Int
end

function GAEvo{T}(cfg::NamedTuple, fitness::Function;
                  logfile=string("logs/", cfg.id, ".csv")) where T
    logger = CambrianLogger(logfile)
    population = initialize(T, cfg)
    GAEvo(cfg, logger, population, fitness, 0)
end

evaluate(e::GAEvo) = fitness_evaluate(e, e.fitness)

"""
populate(e::GAEvo)
"""
function ga_populate(e::AbstractEvolution)
    new_pop = Array{Individual}(undef, 0)
    if e.config.n_elite > 0
        sort!(e.population)
        append!(new_pop,
                e.population[(length(e.population)-e.config.n_elite+1):end])
    end
    for i in (e.config.n_elite+1):e.config.n_population
        p1 = selection(e.population)
        child = deepcopy(p1)
        if e.config.p_crossover > 0 && rand() < e.config.p_crossover
            parents = vcat(p1, [selection(e.population) for i in 2:e.config.n_parents])
            child = crossover(parents...)
        end
        if e.config.p_mutation > 0 && rand() < e.config.p_mutation
            child = mutate(child)
        end
        push!(new_pop, child)
    end
    e.population = new_pop
end

function populate(e::GAEvo)
    ga_populate(e)
end
