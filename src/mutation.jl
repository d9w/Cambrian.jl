export uniform_float_mutation

function uniform_float_mutation(parent::Individual; m_rate = 0.1)
    inds = rand(length(parent.genes)) .>= m_rate
    genes = rand(length(parent.genes))
    genes[inds] = parent.genes[inds]
    fitness = -Inf * ones(length(i1.fitness))
    Individual(genes, fitness)
end
