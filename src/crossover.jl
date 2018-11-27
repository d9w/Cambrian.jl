export uniform_crossover

function uniform_crossover(parents::Array{Individual})
    l = minimum(map(i->length(i.genes), parents))
    genes = deepcopy(parents[1].genes)
    inds = rand(1:length(parents), l)
    for i in eachindex(parents)
        pi = findall(inds .== i)
        genes[pi] = parents[i].genes[pi]
    end
    fitness = -Inf * ones(length(i1.fitness))
    Individual(genes, fitness)
end

function k_point_crossover(parents::Array{Individual})
    # TODO: k-1 points for k parents (single point for 2 parents)
    i1 = parents[1]; i2 = parents[2]
    cpoint = rand(2:(min(length(i1.genes), length(i2.genes)) - 1))
    genes = vcat(i1.genes[1:cpoint], i2.genes[(cpoint+1):end])
    fitness = -Inf * ones(length(i1.fitness))
    Individual(genes, fitness)
end

