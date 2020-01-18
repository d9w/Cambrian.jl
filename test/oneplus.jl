using YAML
using Distributed
using Darwin
import Statistics

function test_oneplus_evo(fitness::Function, d_fitness::Int64)
    cfg = YAML.load_file("../cfg/oneplus.yaml")
    cfg["d_fitness"] = d_fitness
    e = Darwin.oneplus(Darwin.FloatIndividual, cfg, fitness; id="test")

    @test length(e.population) == cfg["n_population"]
    for i in e.population
        @test all(i.fitness .== -Inf)
    end

    e.evaluate(e)

    for i in e.population
        @test i.fitness == fitness(i)
    end
    best = sort(e.population)[end]

    e.populate(e)
    new_best = sort(e.population)[end]
    @test !(new_best < best)
    max_count = 0
    for i in e.population
        if i.fitness == new_best.fitness
            max_count += 1
        else
            for f in i.fitness
                @test f == -Inf
            end
        end
    end
    @test max_count == 1
    e.gen += 1

    step!(e)
    @test length(e.population) == cfg["n_population"]
    for i in e.population
        @test i.fitness == fitness(i)
    end
    new_best = sort(e.population)[end]
    @test !(new_best < best)
    @test e.gen == 2

    print("1+λ step ", string(fitness))
    @timev step!(e)

    run!(e)
    @test length(e.population) == cfg["n_population"]
    for i in e.population
        @test i.fitness == fitness(i)
    end
    new_best = sort(e.population)[end]
    @test !(new_best < best)
    @test e.gen == cfg["n_gen"]
end

@testset "1+λ" begin
    @testset "Sum of genes" begin
        function sum_eval(i::Individual)
            [sum(i.genes)]
        end
        test_oneplus_evo(sum_eval, 1)
    end

    @testset "Rosenbrock" begin
        function rosenbrock(i::Individual)
            x = i.genes
            y = -(sum([(1.0 - x[i])^2 + 100.0 * (x[i+1] - x[i]^2)^2
                      for i in 1:(length(x)-1)]))
            [y]
        end
        test_oneplus_evo(rosenbrock, 1)
    end

    @testset "Multi-objective" begin
        function moo(i::Individual)
            [Statistics.mean(i.genes), Statistics.std(i.genes), minimum(i.genes)]
        end
        test_oneplus_evo(moo, 3)
    end
end
