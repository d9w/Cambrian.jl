using Cambrian
import YAML

test_filename = string(@__DIR__, "/test.yaml")
cfg = get_config(test_filename)

evaluate(e::Evolution) = random_evaluate(e)
populate(e::Evolution) = oneplus_populate(e)

function test_evolution(e::Evolution)
    @test length(e.population) == cfg.n_population
    for i in e.population
        @test all(i.fitness .== -Inf)
    end

    evaluate(e)
    fits = [i.fitness[1] for i in e.population]
    evaluate(e)
    # random fitness, all values should change
    for i in eachindex(e.population)
        @test fits[i] != e.population[i].fitness[1]
    end

    fits = copy([i.fitness[:] for i in e.population])
    step!(e)
    # random fitness, all values should change
    for i in eachindex(e.population)
        @test fits[i] != e.population[i].fitness[1]
    end
end

@testset "Random fitness" begin
    e = Evolution{FloatIndividual}(cfg)
    test_evolution(e)
end

struct MyFloatIndividual <: Individual
    genes::Array{Float64}
    fitness::Array{Float64}
    my_var::Int64
end

function my_init_function(cfg::NamedTuple)
    MyFloatIndividual(rand(cfg.n_genes), -Inf*ones(cfg.d_fitness), 33)
end

@testset "Evolution with custom init function" begin
    e = Evolution{MyFloatIndividual}(cfg; init_function=my_init_function)
    test_evolution(e)
end
