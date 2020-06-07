using Test
using Cambrian

cfg = get_config("test.yaml")

@testset "bool individual" begin
    b_ind = BoolIndividual(cfg::Dict)
    fval = rand()
    b_ind.fitness[1] = fval

    b_str = string(b_ind)
    @test typeof(b_str) == String

    b_ind2 = BoolIndividual(b_str)
    @test typeof(b_ind2) == BoolIndividual
    @test b_ind2.fitness[1] == fval
end

@testset "float individual" begin
    f_ind = FloatIndividual(cfg::Dict)
    @test f_ind.fitness[1] == -Inf

    f_str = string(f_ind)
    @test typeof(f_str) == String

    f_ind2 = FloatIndividual(f_str)
    @test typeof(f_ind2) == FloatIndividual
    @test f_ind2.fitness[1] == -Inf
end
