using Test
using Cambrian

cfg = get_config("test.yaml")

function test_individual(ind::Individual)
    ind2 = mutate(ind, 0.0)
    @test all(ind2.fitness[1] .== -Inf)
    @test all(ind.genes .== ind2.genes)

    ind2 = mutate(ind, 1.0)
    @test all(ind2.fitness[1] == -Inf)
    @test all(ind.genes .!= ind2.genes)

    ind3 = crossover(ind, ind2)
    @test all(ind3.fitness[1] == -Inf)
    @test all((ind3.genes .== ind.genes) .| (ind3.genes .== ind2.genes))
end

@testset "bool individual" begin
    b_ind = BoolIndividual(cfg)
    fval = rand()
    b_ind.fitness[1] = fval

    b_str = string(b_ind)
    @test typeof(b_str) == String

    b_ind2 = BoolIndividual(b_str)
    @test typeof(b_ind2) == BoolIndividual
    @test b_ind2.fitness[1] == fval
    @test all(b_ind.genes .== b_ind2.genes)

    test_individual(b_ind)
end

@testset "float individual" begin
    f_ind = FloatIndividual(cfg)
    @test f_ind.fitness[1] == -Inf

    f_str = string(f_ind)
    @test typeof(f_str) == String

    f_ind2 = FloatIndividual(f_str)
    @test typeof(f_ind2) == FloatIndividual
    @test f_ind2.fitness[1] == -Inf
    @test all(f_ind.genes .== f_ind2.genes)

    test_individual(f_ind)
end
