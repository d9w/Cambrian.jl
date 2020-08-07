"return a winner individual from a tournament of size t_size from a population"
function tournament_selection(pop::Array{<:Individual}, t_size::Int)
    inds = shuffle!(collect(1:length(pop)))
    sort(pop[inds[1:t_size]])[end]
end

"return the best individual from a population"
function max_selection(pop::Array{<:Individual})
    sort(pop)[end]
end

"return a random individual from a population"
function random_selection(pop::Array{<:Individual})
    pop[rand(1:length(pop))]
end

selection(pop::Array{<:Individual}) = tournament_selection(pop, 3)
