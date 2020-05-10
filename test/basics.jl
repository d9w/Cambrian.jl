using Cambrian
import YAML

@testset "Random fitness" begin
    cfg = YAML.load_file("../cfg/oneplus.yaml")
    cfg["d_fitness"] = 1
    e = Cambrian.Evolution(Cambrian.FloatIndividual, cfg; id="test")
    e.evaluate = e::Cambrian.Evolution->Cambrian.fitness_evaluate!(
        e, fitness=Cambrian.random_evaluate)
    e.populate = Cambrian.oneplus_populate!

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
