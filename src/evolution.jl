export AbstractEvolution, Evolution

abstract type AbstractEvolution end

function get_best(e::AbstractEvolution)
    sort(e.population)[end]
end

function initialize(e::AbstractEvolution)
    population = Array{Individual}(undef, e.cfg["n_population"])
    for i in 1:cfg["n_population"]
        population[i] = itype(cfg)
    end
    population
end

"""
Every AbstractEvolution subclass needs to have the following fields:
    log::CambrianLogger
    config::Dict
    population::Array{<: Individual}

and has to implement the following methods:
    populate(e::Evolution)
    evaluate(e::Evolution)
    generation(e::Evolution)
"""
mutable struct Evolution{T} <: AbstractEvolution
    logger::CambrianLogger
    config::Dict
    population::Array{T}
    generation::Int
end

function Evolution(itype::Type, cfg::Dict;
                   id::String=string(UUIDs.uuid4()),
                   logfile::String=string("logs/", id, ".log"),
                   initialize::Function=default_initialize,
                   populate::Function=ga_populate!,
                   evaluate::Function=fitness_evaluate!,
                   generation::Function=no_genfunc)
    logger = CambrianLogger(logfile)
    population = initialize(itype, cfg)
    Evolution(id, logger, population, 0, cfg, populate, evaluate, generation, "")
end

function Evolution(itype::Type, cfg::String; kwargs...)
    Evolution(itype, YAML.load_file(cfg); kwargs...)
end

function oneplus(itype::Type, cfg::Dict, fitness::Function; kwargs...)
    evaluate = x::Evolution->Cambrian.fitness_evaluate!(x; fitness=fitness)
    Evolution(itype, cfg; evaluate=evaluate, populate=oneplus_populate!)
end

function GA(itype::Type, cfg::Dict, fitness::Function; kwargs...)
    evaluate = x::Evolution->Cambrian.fitness_evaluate!(x; fitness=fitness)
    Evolution(itype, cfg; evaluate=evaluate, populate=ga_populate!)
end
