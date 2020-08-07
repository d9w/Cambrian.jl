export AbstractEvolution, Evolution, log_gen, save_gen, get_best

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
    gen::Int
end

function get_best(e::AbstractEvolution)
    sort(e.population)[end]
end

function log_gen(e::AbstractEvolution)
    # Todo: log each fitness dimension
    maxs = map(i->maximum(i.fitness), e.population)
    with_logger(e.log) do
        @info Formatting.format("{1:04d} {2:e} {3:e} {4:e}",
                                e.gen, maximum(maxs), mean(maxs), std(maxs))
    end
    flush(e.log.stream)
end

function save_gen(e::AbstractEvolution)
    # save the entire population
    path = Formatting.format("gens/{1}/{2:04d}", e.id, e.gen)
    mkpath(path)
    sort!(e.population)
    for i in eachindex(e.population)
        f = open(Formatting.format("{1}/{2:04d}.dna", path, i), "w+")
        write(f, string(e.population[i]))
        close(f)
    end
end

function initialize(itype::Type, cfg::NamedTuple)
    population = Array{itype}(undef, cfg.n_population)
    for i in 1:cfg.n_population
        population[i] = itype(cfg)
    end
    population
end

function Evolution{T}(cfg::NamedTuple;
                      logfile=string("logs/", cfg.id, ".csv")) where T
    logger = CambrianLogger(logfile)
    population = initialize(T, cfg)
    Evolution(cfg, logger, population, 0)
end

function Evolution{T}(cfg::String) where T
    Evolution{T}(get_config(cfg))
end
