using Cambrian
import YAML

cfg = YAML.load_file("test.yaml")

@testset "Random fitness" begin
    cfg["d_fitness"] = 1
    e = Evolution{FloatIndividual}(cfg; id="test")

    evaluate(e::Evolution) = random_evaluate(e)
    populate(e::Evolution) = oneplus_populate(e)

    @test length(e.population) == cfg["n_population"]
    for i in e.population
        @test all(i.fitness .== -Inf)
    end

    e.evaluate(e)
    fits = [i.fitness[1] for i in e.population]
    e.evaluate(e)
    for i in eachindex(e.population)
        @test fits[i] != e.population[i].fitness[1]
    end

    fits = copy([i.fitness[:] for i in e.population])
    step!(e)
    for i in eachindex(e.population)
        @test fits[i] != e.population[i].fitness[1]
    end
end
