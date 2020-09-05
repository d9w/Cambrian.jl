export Individual, BoolIndividual, FloatIndividual, crossover, mutate
import Base: isless, show

"""
every Individual subtype needs to implement:
Individual(cfg::NamedTuple)
Individual(json::String)
mutate(ind::Individual)
crossover(parents::Vararg{Individual})

and have the fields
genes
fitness::Array

BoolIndvidiual and FloatIndividual are provided as Cambrian defaults
"""
abstract type Individual end

function get_child(parent::Individual, genes::AbstractArray)
    typeof(parent)(genes, -Inf * ones(length(parent.fitness)))
end

function isless(i1::Individual, i2::Individual)
    all(i1.fitness .< i2.fitness)
end

function ind_parse(st::String)
    d = JSON.Parser.parse(st)
    for i in 1:length(d["fitness"])
        if d["fitness"][i] == nothing
            d["fitness"][i] = -Inf
        end
    end
    d
end

function show(io::IO, ind::Individual)
    print(io, JSON.json(ind))
end

"default crossover method, using uniform crossover for N parents"
function crossover(parents::Vararg{Individual})
    l = minimum(map(i->length(i.genes), parents))
    genes = deepcopy(parents[1].genes)
    inds = rand(1:length(parents), l)
    for i in eachindex(parents)
        pi = findall(inds .== i)
        genes[pi] = parents[i].genes[pi]
    end
    get_child(parents[1], genes)
end

function k_point_crossover(parents::Vararg{Individual})
    # TODO: k-1 points for k parents (single point for 2 parents)
    i1 = parents[1]; i2 = parents[2]
    cpoint = rand(2:(min(length(i1.genes), length(i2.genes)) - 1))
    genes = vcat(i1.genes[1:cpoint], i2.genes[(cpoint+1):end])
    get_child(parents[1], genes)
end

"BoolIndividual : example Individual class using a binary string genotype"
struct BoolIndividual <: Individual
    genes::BitArray
    fitness::Array{Float64}
end

function BoolIndividual(cfg::NamedTuple)
    BoolIndividual(BitArray(rand(Bool, cfg.n_genes)), -Inf*ones(cfg.d_fitness))
end

function BoolIndividual(st::String)
    dict = ind_parse(st)
    BoolIndividual(BitArray(dict["genes"]), Float64.(dict["fitness"]))
end

"""
mutate(parent::BoolIndividual, m_rate::Float64). To use, define
    mutate(parent::BoolIndividual) = mutate(parent, m_rate) with configured m_rate
for a Boolean individual, this random flips the bits of the parent
"""
function mutate(parent::BoolIndividual, m_rate::Float64)
    inds = rand(length(parent.genes)) .<= m_rate
    genes = xor.(inds, parent.genes)
    get_child(parent, genes)
end

"FloatIndividual : example Individual class using a floating point genotype in [0, 1]"
struct FloatIndividual <: Individual
    genes::Array{Float64}
    fitness::Array{Float64}
end

function FloatIndividual(cfg::NamedTuple)
    FloatIndividual(rand(cfg.n_genes), -Inf*ones(cfg.d_fitness))
end

function FloatIndividual(st::String)
    dict = ind_parse(st)
    FloatIndividual(Float64.(dict["genes"]), Float64.(dict["fitness"]))
end

function mutate(parent::FloatIndividual, m_rate::Float64)
    inds = rand(length(parent.genes)) .> m_rate
    genes = rand(length(parent.genes))
    genes[inds] = parent.genes[inds]
    get_child(parent, genes)
end
