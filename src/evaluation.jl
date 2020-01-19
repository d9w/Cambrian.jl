function null_evaluate(i::Individual)
    -Inf .* ones(i.fitness)
end

function random_evaluate(i::Individual)
    rand(length(i.fitness))
end

function fitness_evaluate!(e::Evolution; fitness::Function=null_evaluate)
    for i in eachindex(e.population)
        e.population[i].fitness[:] = fitness(e.population[i])[:]
    end
end

function distributed_evaluate!(e::Evolution; fitness::Function=null_evaluate)
    fits = SharedArrays.SharedArray{Float64}(e.cfg["d_fitness"],
                                             length(e.population))
    @sync @distributed for i in eachindex(e.population)
        fits[:, i] = fitness(e.population[i])
    end
    for i in eachindex(e.population)
        e.population[i].fitness .= fits[:, i]
    end
end

function mse_valid(h::AbstractArray, y::AbstractArray; margin::Float64=0.1)
    sum((h - y).^2) < margin
end

function classify_valid(h::AbstractArray, y::AbstractArray)
    argmax(h) == argmax(y)
end

"""
lexicase selection for data-based GP problems where each genome G in
e.population corresponds to a data-processing function F, where F =
interpret(G). X and Y are 2D arrays, and individuals are evaluated based on
valid(F(X[:, i]), Y[:, i]), where the valid function determines if individuals
should continue to be evaluated.
"""
function lexicase_evaluate!(e::Evolution, X::AbstractArray, Y::AbstractArray,
                            interpret::Function; valid::Function=classify_valid,
                            verify_best::Bool=true, seed::Int64=e.gen)
    Random.seed!(seed)
    npop = length(e.population)
    ndata = size(Y, 2)
    functions = Array{Function}(undef, npop)
    for i in 1:npop
        functions[i] = interpret(e.population[i])
    end
    data_inds = shuffle!(collect(1:ndata))
    fits = [e.population[i].fitness[1] for i in 1:npop]
    if verify_best
        is_valid = fits .== -Inf # do not re-evaluate expert
    else
        is_valid = trues(npop)
    end
    for i in 1:ndata
        x = X[:, data_inds[i]]
        y = Y[:, data_inds[i]]
        for j in 1:npop
            if is_valid[j]
                h = functions[j](x)
                if valid(h, y)
                    fits[j] = i
                else
                    fits[j] = i-1
                    is_valid[j] = false
                end
            end
        end
        if sum(is_valid) <= 1
            break
        end
    end
    if verify_best
        best = argmax(fits)
        if e.population[best] == -Inf
            # new best individual, re-evaluate
            fits[best] = 0.0
            for i in 1:ndata
                for j in 1:npop
                    if valid(functions[j](X[:, i]), Y[:, i])
                        fits[best] += 1.0
                    end
                end
            end
        end
    end
    for i in 1:npop
        e.population[i].fitness[1] = fits[i]
    end
end
