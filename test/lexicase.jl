using Darwin
using Test
using RDatasets
using YAML
using Statistics

function data_setup()
    iris = dataset("datasets", "iris")
    X = convert(Matrix, iris[:, 1:4])'
    X = X ./ maximum(X; dims=2)
    r = iris[:, 5].refs
    Y = zeros(maximum(r), size(X, 2))
    for i in 1:length(r)
        Y[r[i], i] = 1.0
    end
    X, Y
end

function interpret(ind::Darwin.Individual)
    w = reshape(ind.genes, (4, 3))
    function F(x::Array{Float64})
        (x' * w)'
    end
end

@testset "Lexicase Selection" begin
    X, Y = data_setup()

    cfg = YAML.load_file("../cfg/oneplus.yaml")
    cfg["n_genes"] = size(X, 1) * size(Y, 1)
    e = Evolution(Darwin.FloatIndividual, cfg; id="test", populate=Darwin.oneplus_populate!)
    e.evaluate = x::Evolution->Darwin.lexicase_evaluate!(x, X, Y, interpret;
                                                         valid=Darwin.classify_valid,
                                                         verify_best=false)

    step!(e)

    print("lexicase step")
    @timev step!(e)
    for i in 1:length(e.population)
        @test e.population[i].fitness[1] >= 0
        @test e.population[i].fitness[1] <= size(X, 2)
    end
    best_fit = sort(e.population)[end].fitness[1]

    for i in 1:10
        step!(e)
        best = sort(e.population)[end]
        @test best.fitness[1] >= 0.0
        best_fit = best.fitness[1]
    end
end
