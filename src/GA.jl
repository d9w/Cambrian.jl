
function ga_populate!(e::AbstractEvolution;
                      mutation::Function=uniform_mutation,
                      crossover::Function=uniform_crossover,
                      selection::Function=x->tournament_selection(x, e.cfg["tournament_size"]))
    new_pop = Array{Individual}(undef, 0)
    if e.cfg["n_elite"] > 0
        sort!(e.population)
        append!(new_pop,
                e.population[(length(e.population)-e.cfg["n_elite"]+1):end])
    end
    for i in (e.cfg["n_elite"]+1):e.cfg["n_population"]
        p1 = selection(e.population)
        child = deepcopy(p1)
        if e.cfg["p_crossover"] > 0 && rand() < e.cfg["p_crossover"]
            parents = vcat(p1, [selection(e.population) for i in 2:e.cfg["n_parents"]])
            child = crossover(parents...)
        end
        if e.cfg["p_mutation"] > 0 && rand() < e.cfg["p_mutation"]
            child = mutation(child)
        end
        push!(new_pop, child)
    end
    e.population = new_pop
end
