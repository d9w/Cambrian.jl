function log_gen(e::Evolution)
    maxs = map(i->maximum(i.fitness), e.population)
    with_logger(e.log) do
        @info Formatting.format("{1} {2:04d} {3} {4:e} {5:e} {6:e}",
                                e.id, e.gen, e.text, maximum(maxs),
                                mean(maxs), std(maxs))
    end
    flush(e.log.stream)
end

function save_gen(e::Evolution)
    # save the entire population
    path = Formatting.format("gens/{1}/{2:04d}", e.id, e.gen)
    mkpath(path)
    sort!(e.population)
    for i in eachindex(e.population)
        f = open(Formatting.format("{1}/{2:04d}.dna", path, i), "w+")
        write(f, string(e.population[i]))
        close(f)
    end
end

function exchange_best!(e::Evolution; filename::String="best.ind")
    # TODO: finish
    best = get_best(e)
    if stat(filename) != 0
        file_best = Individual(filename)
        sort!(e.population)
        if (length(file_best.genes) == length(e.population[1].genes))
            copyto!(e.population[1].genes, file_best.genes)
            copyto!(e.population[1].fitness, file_best.fitness)
        end
        f = open(filename, "w+")
        write(f, string(e.population[end]))
        close(f)
    end
end
