export AbstractEvolution, Evolution, log_gen, save_gen, get_best

abstract type AbstractEvolution end

"""
Every AbstractEvolution subclass needs to have the following fields:
    config::NamedTuple
    logger::CambrianLogger
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

"log a generation, including max, mean, and std of each fitness dimension"
function log_gen(e::AbstractEvolution)
    for d in 1:e.config.d_fitness
        maxs = map(i->i.fitness[d], e.population)
        with_logger(e.logger) do
            @info Formatting.format("{1:04d},{2:e},{3:e},{4:e}",
                                    e.gen, maximum(maxs), mean(maxs), std(maxs))
        end
    end
    flush(e.logger.stream)
end

"save the population in gens/"
function save_gen(e::AbstractEvolution)
    path = Formatting.format("gens/{1}/{2:04d}", e.config.id, e.gen)
    mkpath(path)
    sort!(e.population)
    for i in eachindex(e.population)
        f = open(Formatting.format("{1}/{2:04d}.dna", path, i), "w+")
        write(f, string(e.population[i]))
        close(f)
    end
end

"create all members of the first generation"
function initialize(itype::Type, cfg::NamedTuple; kwargs...)
    population = Array{itype}(undef, cfg.n_population)
    kwargs_dict = Dict(kwargs)
    for i in 1:cfg.n_population
        if haskey(kwargs_dict, :init_function)
            population[i] = kwargs_dict[:init_function](cfg)
        else
            population[i] = itype(cfg)
        end
    end
    population
end

"""
    Evolution(cfg::NamedTuple; logfile::String="logs/id.csv")

create a base Evolution class. This is provided as an example class and for
tests. Intended usage of Cambrian is to subclass the AbstractEvolution type and
define the evolutionary methods which define the intended algorithm.
"""
function Evolution{T}(cfg::NamedTuple;
                      logfile=string("logs/", cfg.id, ".csv"), kwargs...) where T
    logger = CambrianLogger(logfile)
    population = initialize(T, cfg; kwargs...)
    Evolution(cfg, logger, population, 0)
end

function Evolution{T}(cfg::String) where T
    Evolution{T}(get_config(cfg))
end
