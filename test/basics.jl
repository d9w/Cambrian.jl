using Darwin
import YAML

@testset "Random fitness" begin
    cfg = YAML.load_file("../cfg/oneplus.yaml")
    cfg["d_fitness"] = 1
    e = Darwin.Evolution(Darwin.FloatIndividual, cfg; id="test")
    e.evaluate = e::Darwin.Evolution->Darwin.fitness_evaluate!(
        e, fitness=Darwin.random_evaluate)
    e.populate = Darwin.oneplus_populate!

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
