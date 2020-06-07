using Test
using Cambrian
using YAML

cfg = YAML.load_file("test.yaml")

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
end
