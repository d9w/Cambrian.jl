export step!, run!

function generation(e::AbstractEvolution)
    nothing
end

function step!(e::AbstractEvolution)
    e.gen += 1
    if e.gen > 1
        populate(e)
    end
    generation(e)
    evaluate(e)
    if ((e.config.log_gen > 0) && mod(e.gen, e.config.log_gen) == 0)
        log_gen(e)
    end
    if ((e.config.save_gen > 0) && mod(e.gen, e.config.save_gen) == 0)
        save_gen(e)
    end
end

function run!(e::AbstractEvolution)
    for i in (e.gen+1):e.config.n_gen
        step!(e)
    end
end
