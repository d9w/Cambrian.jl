export evaluate, random_evaluate, fitness_evaluate

"""
    evaluate(e::AbstractEvolution)

Default evaluate function. Sets each element of the fitness array of each
individual to -Inf.
"""
function evaluate(e::AbstractEvolution)
    for i in eachindex(e.population)
        for f in e.cfg.d_fitness
            e.population[i].fitness[d] = -Inf
        end
    end
end

"sets the fitness value of each individual to rand()"
function random_evaluate(e::AbstractEvolution)
    for i in eachindex(e.population)
        for f in e.cfg.d_fitness
            e.population[i].fitness[d] = rand()
        end
    end
end

function null_evaluate(i::Individual)
    i.fitness[:] .= -Inf
end

"""
    function fitness_evaluate(e::AbstractEvolution; fitness::Function=null_evaluate)

sets the fitness of each individual to the Array of values returned by fitness
"""
function fitness_evaluate(e::AbstractEvolution; fitness::Function=null_evaluate)
    for i in eachindex(e.population)
        e.population[i].fitness[:] = fitness(e.population[i])[:]
    end
end

# TODO: dependencies, test distributed
# function distributed_evaluate!(e::AbstractEvolution; fitness::Function=null_evaluate)
#     fits = SharedArrays.SharedArray{Float64}(e.cfg["d_fitness"],
#                                              length(e.population))
#     @sync @distributed for i in eachindex(e.population)
#         fits[:, i] = fitness(e.population[i])
#     end
#     for i in eachindex(e.population)
#         e.population[i].fitness .= fits[:, i]
#     end
# end
