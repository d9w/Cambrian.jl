export Individual
using JSON
import Base.isless

abstract type Individual end

function get_child(parent::Individual, genes::AbstractArray)
    typeof(parent)(genes, -Inf * ones(length(parent.fitness)))
end

function isless(i1::Individual, i2::Individual)
    all(i1.fitness .< i2.fitness)
end

function default_initialize(itype::Type, cfg::Dict)
    population = Array{Individual}(undef, cfg["n_population"])
    for i in 1:cfg["n_population"]
        population[i] = itype(cfg)
    end
    population
end

struct BoolIndividual <: Individual
    genes::BitArray
    fitness::Array{Float64}
end

function BoolIndividual(cfg::Dict)
    BoolIndividual(BitArray{rand(cfg["n_genes"])},
                   -Inf*ones(cfg["d_fitness"]))
end

struct FloatIndividual <: Individual
    genes::Array{Float64}
    fitness::Array{Float64}
end

function FloatIndividual(cfg::Dict)
    FloatIndividual(rand(cfg["n_genes"]),
                    -Inf*ones(cfg["d_fitness"]))
end

function Individual(genes::AbstractArray, fitness::AbstractArray)
    fitness[fitness .== nothing] .= -Inf
    fitness = Float64.(fitness)
    genes = typeof(genes[1]).(genes)
    FloatIndividual(genes, fitness)
end

function Individual(filename::String)
    f = open(filename, "r")
    dict = JSON.Parser.parse(read(f, String))
    close(f)
    for i in 1:length(dict["fitness"])
        if dict["fitness"][i] == nothing
            dict["fitness"][i] = -Inf
        end
    end
    Individual(dict["genes"], dict["fitness"])
end

function String(ind::Individual)
    JSON.json(ind)
end
