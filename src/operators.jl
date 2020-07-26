function uniform_crossover(parents::Vararg{Individual})
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

function uniform_bit_mutation(parent::Individual; m_rate=0.1)
    inds = rand(length(parent.genes)) .>= m_rate
    genes = BitArray(rand(Bool, length(parent.genes)))
    genes[inds] = parent.genes[inds]
    get_child(parent, genes)
end

function uniform_mutation(parent::Individual; m_rate=0.1)
    inds = rand(length(parent.genes)) .>= m_rate
    T = typeof(parent.genes[1])
    genes = rand(T, length(parent.genes))
    genes[inds] = parent.genes[inds]
    get_child(parent, genes)
end
