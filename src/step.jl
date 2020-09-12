export step!, run!

"""
update e.elites with the best individuals from the current population or
existing elites, based on fitness
does nothing if e.elites is not defined
"""
function generation(e::AbstractEvolution)
    if hasfield(typeof(e), :elites)
        pop = sort([e.population; e.elites])
        n_elites = length(e.elites)
        for i in 1:n_elites
            e.elites[i] = deepcopy(pop[length(e.population)+i])
        end
    end
end

"""
The generic iteration of an evolution. Calls populate, evaluate, and generation.
Also calls log_gen and save_gen based on the provided config values. Subclasses
of AbstractEvolution should override the populate, evaluate, or generation
functions rather than overriding this function.
"""
function step!(e::AbstractEvolution)
    e.gen += 1
    if e.gen > 1
        populate(e)
    end
    evaluate(e)
    generation(e)
    if ((e.config.log_gen > 0) && mod(e.gen, e.config.log_gen) == 0)
        log_gen(e)
    end
    if ((e.config.save_gen > 0) && mod(e.gen, e.config.save_gen) == 0)
        save_gen(e)
    end
end

"Call step!(e) e.config.n_gen times consecutively"
function run!(e::AbstractEvolution)
    for i in (e.gen+1):e.config.n_gen
        step!(e)
    end
end
