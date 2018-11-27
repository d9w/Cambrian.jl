export Individual
import Base.isless

abstract type Individual end

struct BaseIndividual <: Individual
    genes::AbstractArray
    fitness::AbstractArray
end

function BaseIndividual(cfg::Dict)
    BaseIndividual(rand(cfg["n_genes"]), -Inf*ones(cfg["n_fitness"]))
end

function isless(i1::Individual, i2::Individual)
    all(i1.fitness .< i2.fitness)
end
