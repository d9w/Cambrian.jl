export OnePlusEvo, evaluate, populate

"""

OnePlusEvo implements a 1+λ evolutionary algorithm. To do this, a new subtype of
AbstractEvolution is created, OnePlusEvo, and the following functions are
defined for this type:

evaluate
populate

the function generation can also be defined. Without specification, the default
generation function (which is void) is applied.
"""
mutable struct OnePlusEvo{T} <: AbstractEvolution
    config::NamedTuple
    logger::CambrianLogger
    population::Array{T}
    fitness::Function
    gen::Int
end

function OnePlusEvo{T}(cfg::NamedTuple, fitness::Function;
                      logfile=string("logs/", cfg.id, ".csv")) where T
    logger = CambrianLogger(logfile)
    population = initialize(T, cfg)
    OnePlusEvo(cfg, logger, population, fitness, 0)
end

evaluate(e::OnePlusEvo) = fitness_evaluate(e, e.fitness)

function populate(e::OnePlusEvo)
    p1 = max_selection(e.population)
    e.population[1] = p1
    for i in 2:e.config.n_population
        e.population[i] = mutate(p1)
    end
end
