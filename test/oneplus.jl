using Statistics
using YAML

function test_oneplus_evo(evaluation::Function, n_fitness::Int64)
    cfg = YAML.load_file("cfg/oneplus.yaml")
    cfg["n_fitness"] = n_fitness
    e = Evolution(Darwin.FloatIndividual, cfg; logfile="test.log")
    e.mutation = x->Darwin.uniform_mutation(x; m_rate=cfg["m_rate"])
    e.evaluation = evaluation

    @test length(e.population) == cfg["n_population"]
    for i in e.population
        @test all(i.fitness .== -Inf)
    end

    Darwin.evaluate!(e)

    for i in e.population
        @test i.fitness == e.evaluation(i)
    end
    best = sort(e.population)[end]

    Darwin.populate!(e)
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
        @test i.fitness == e.evaluation(i)
    end
    new_best = sort(e.population)[end]
    @test !(new_best < best)
    @test e.gen == 2

    @timev step!(e)

    run!(e)
    @test length(e.population) == cfg["n_population"]
    for i in e.population
        @test i.fitness == e.evaluation(i)
    end
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
            [mean(i.genes), std(i.genes), minimum(i.genes)]
        end
        test_oneplus_evo(moo, 3)
    end
end
