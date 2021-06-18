using YAML
using Statistics
using Cambrian
import Cambrian.selection
import Cambrian.mutate

cfg = get_config("../cfg/ga.yaml")
selection(pop::Array{<:Individual}) = Cambrian.tournament_selection(pop, cfg.tournament_size)
mutate(i::Individual) = Cambrian.mutate(i, cfg.m_rate)

function test_ga_evo(fitness::Function, d_fitness::Int; test_improvement=true)
    cfg = get_config("../cfg/ga.yaml"; d_fitness=d_fitness, id="test")
    e = GAEvo{Cambrian.FloatIndividual}(cfg, fitness)

    step!(e)
    @test length(e.population) == cfg.n_population
    for i in e.population
        @test i.fitness == fitness(i)
    end
    best = sort(e.population)[end]
    @test e.gen == 1

    print("GA step ", string(fitness))
    @timev step!(e)

    run!(e)
    @test length(e.population) == cfg.n_population
    for i in e.population
        @test i.fitness == fitness(i)
    end
    new_best = sort(e.population)[end]
    if test_improvement
        @test !(new_best < best)
    else
        comparison = new_best < best  # for coverage
    end
    @test e.gen == cfg.n_gen
end

@testset "Genetic Algorithm" begin
    @testset "Sum of genes" begin
        function sum_eval(i::Individual)
            [sum(i.genes)]
        end
        test_ga_evo(sum_eval, 1)
    end

    @testset "Rosenbrock" begin
        function rosenbrock(i::Individual)
            x = i.genes
            y = -(sum([(1.0 - x[i])^2 + 100.0 * (x[i+1] - x[i]^2)^2
                      for i in 1:(length(x)-1)]))
            [y]
        end
        test_ga_evo(rosenbrock, 1)
    end

    @testset "Multi-objective" begin
        function moo(i::Individual)
            [mean(i.genes), std(i.genes), minimum(i.genes)]
        end
        test_ga_evo(moo, 3, test_improvement=false)
    end
end
