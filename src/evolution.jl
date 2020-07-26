export AbstractEvolution, Evolution

abstract type AbstractEvolution end

"""
Every AbstractEvolution subclass needs to have the following fields:
    log::CambrianLogger
    config::NamedTuple
    population::Array{<:Individual}
for config, see get_default_config

Evolution classes should implement the following methods:
    populate(e::Evolution)
    evaluate(e::Evolution)
    generation(e::Evolution)
see the default functions for reference
"""
mutable struct Evolution{T} <: AbstractEvolution
    config::NamedTuple
    logger::CambrianLogger
    population::Array{T}
    generation::Int
end

function get_best(e::AbstractEvolution)
    sort(e.population)[end]
end

function initialize(itype::Type, cfg::NamedTuple)
    population = Array{itype}(undef, e.cfg.n_population)
    for i in 1:cfg.n_population
        population[i] = itype(cfg)
    end
    population
end

function Evolution{T}(cfg::NamedTuple) where T
    logger = CambrianLogger(logfile)
    population = initialize(T, cfg)
    Evolution(cfg, logger, population, 0)
end

function Evolution{T}(cfg::String) where T
    Evolution{T}(get_config(cfg))
end
