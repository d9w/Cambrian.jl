export Individual
using JSON
import Base.isless

"""
every Individual needs to implement:
Individual(cfg::Dict)

and have the fields
genes
fitness::Array
"""
abstract type Individual end

struct BoolIndividual <: Individual
    genes::BitArray
    fitness::Array{Float64}
end

struct FloatIndividual <: Individual
    genes::Array{Float64}
    fitness::Array{Float64}
end

function get_child(parent::Individual, genes::AbstractArray)
    typeof(parent)(genes, -Inf * ones(length(parent.fitness)))
end

function isless(i1::Individual, i2::Individual)
    all(i1.fitness .< i2.fitness)
end

function BoolIndividual(cfg::Dict)
    BoolIndividual(BitArray{rand(cfg["n_genes"])},
                   -Inf*ones(cfg["d_fitness"]))
end

function FloatIndividual(cfg::Dict)
    FloatIndividual(rand(cfg["n_genes"]),
                    -Inf*ones(cfg["d_fitness"]))
end

function FloatIndividual(genes::AbstractArray, fitness::AbstractArray)
    fitness[fitness .== nothing] .= -Inf
    fitness = Float64.(fitness)
    genes = Float64.(genes)
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
