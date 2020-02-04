export Evolution
using YAML
using JSON

mutable struct Evolution
    id::String
    log::AbstractLogger
    population::Array{Individual}
    gen::Int64
    cfg::Dict
    populate::Function
    evaluate::Function
    generation::Function
    text::String
end

function get_best(e::Evolution)
    sort(e.population)[end]
end

no_genfunc(e::Evolution) = nothing

function Evolution(itype::Type, cfg::Dict;
                   id::String=string(UUIDs.uuid4()),
                   logfile::String=string("logs/", id, ".log"),
                   initialize::Function=default_initialize,
                   populate::Function=ga_populate!,
                   evaluate::Function=fitness_evaluate!,
                   generation::Function=no_genfunc)
    logger = DarwinLogger(logfile)
    population = initialize(itype, cfg)
    Evolution(id, logger, population, 0, cfg, populate, evaluate, generation, "")
end

function Evolution(itype::Type, cfg::String; kwargs...)
    Evolution(itype, YAML.load_file(cfg); kwargs...)
end

function oneplus(itype::Type, cfg::Dict, fitness::Function; kwargs...)
    evaluate = x::Evolution->Darwin.fitness_evaluate!(x; fitness=fitness)
    Evolution(itype, cfg; evaluate=evaluate, populate=oneplus_populate!)
end

function GA(itype::Type, cfg::Dict, fitness::Function; kwargs...)
    evaluate = x::Evolution->Darwin.fitness_evaluate!(x; fitness=fitness)
    Evolution(itype, cfg; evaluate=evaluate, populate=ga_populate!)
end
