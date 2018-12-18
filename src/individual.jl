export Individual
import Base.isless

abstract type Individual end

function get_child(parent::Individual, genes::AbstractArray)
    typeof(parent)(genes, -Inf * ones(length(parent.fitness)))
end

function isless(i1::Individual, i2::Individual)
    all(i1.fitness .< i2.fitness)
end

function null_evaluate(i::Individual)
    -Inf .* ones(i.fitness)
end

function random_evaluate(i::Individual)
    rand(length(i.fitness))
end

function default_populate(itype::Type, cfg::Dict)
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
                   -Inf*ones(cfg["n_fitness"]))
end

struct FloatIndividual <: Individual
    genes::Array{Float64}
    fitness::Array{Float64}
end

function FloatIndividual(cfg::Dict)
    FloatIndividual(rand(cfg["n_genes"]),
                    -Inf*ones(cfg["n_fitness"]))
end
