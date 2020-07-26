export log_gen, save_gen

function log_gen(e::AbstractEvolution)
    # Todo: log each fitness dimension
    maxs = map(i->maximum(i.fitness), e.population)
    with_logger(e.log) do
        @info Formatting.format("{1:04d} {2:e} {3:e} {4:e}",
                                e.gen, maximum(maxs), mean(maxs), std(maxs))
    end
    flush(e.log.stream)
end

function save_gen(e::AbstractEvolution)
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
