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
