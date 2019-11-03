export step!, run!

function step!(e::Evolution)
    e.gen += 1
    if e.gen > 1
        e.populate(e)
    end
    e.generation(e)
    e.evaluate(e)
    if ((e.cfg["log_gen"] > 0) && mod(e.gen, e.cfg["log_gen"]) == 0)
        log_gen(e)
    end
    if ((e.cfg["save_gen"] > 0) && mod(e.gen, e.cfg["save_gen"]) == 0)
        save_gen(e)
    end
end

function run!(e::Evolution)
    for i in (e.gen+1):e.cfg["n_gen"]
        step!(e)
    end
end
