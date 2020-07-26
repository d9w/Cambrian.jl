export Individual, BoolIndividual, FloatIndividual
import Base: isless, print

"""
every Individual subtype needs to implement:
Individual(cfg::Dict)
Individual(json::String)

and have the fields
genes
fitness::Array
"""
abstract type Individual end

function get_child(parent::Individual, genes::AbstractArray)
    typeof(parent)(genes, -Inf * ones(length(parent.fitness)))
end

function isless(i1::Individual, i2::Individual)
    all(i1.fitness .< i2.fitness)
end

function ind_parse(st::String)
    dict = JSON.Parser.parse(st)
    for i in 1:length(dict["fitness"])
        if dict["fitness"][i] == nothing
            dict["fitness"][i] = -Inf
        end
    end
    dict
end

function print(io::IO, ind::Individual)
    print(io, JSON.json(ind))
end

function String(ind::Individual)
    string(ind)
end

struct BoolIndividual <: Individual
    genes::BitArray
    fitness::Array{Float64}
end

function BoolIndividual(cfg::Dict)
    BoolIndividual(BitArray(rand(Bool, cfg["n_genes"])), -Inf*ones(cfg["d_fitness"]))
end

function BoolIndividual(st::String)
    dict = ind_parse(st)
    BoolIndividual(BitArray(dict["genes"]), Float64.(dict["fitness"]))
end

struct FloatIndividual <: Individual
    genes::Array{Float64}
    fitness::Array{Float64}
end

function FloatIndividual(cfg::Dict)
    FloatIndividual(rand(cfg["n_genes"]), -Inf*ones(cfg["d_fitness"]))
end

function FloatIndividual(st::String)
    dict = ind_parse(st)
    FloatIndividual(Float64.(dict["genes"]), Float64.(dict["fitness"]))
end
