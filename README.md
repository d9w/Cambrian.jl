# Cambrian.jl

[![Build Status](https://travis-ci.org/d9w/Cambrian.jl.svg?branch=master)](https://travis-ci.org/d9w/Cambrian.jl) [![Coverage Status](https://coveralls.io/repos/d9w/Cambrian.jl/badge.svg?branch=master)](https://coveralls.io/r/d9w/Cambrian.jl?branch=master) [![codecov](https://codecov.io/gh/d9w/Cambrian.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/d9w/Cambrian.jl)

<img src="imgs/logo.png" width="800px" height="auto">

A functional Evolutionary Computation framework.

## Installation

Cambrian can be installed through the Julia package manager:

```julia
julia> ]
pkg> add Cambrian
pkg> test Cambrian
```

## Usage

Cambrian is intended as a common framework for evolutionary computation
algorithms in Julia. Algorithm implementations should define a subclass of the
`AbstractEvolution` type which must have the following fields:
```julia
config::NamedTuple
logger::CambrianLogger
population::Array{<:Individual}
```

Each subclass must also implement
```julia
populate(e::<:AbstractEvolution)
evaluate(e::<:AbstractEvolution)
generation(e::<:AbstractEvolution)
```

An example Genetic Algorithm and the `1+λ` algorithm are provided in `src/GA.jl`
and `src/oneplus.jl`, with usage examples in `test/ga.jl` and `test/oneplus.jl`.

Algorithms can also define new `Individual` types or use the provided
`FloatIndividual` and `BoolIndividual`. New `Individual` types should have the fields:
```julia
genes::<:AbstractArray
fitness::Array{Float64}
```

and implement the following methods:
```julia
mutate(i::<:Individual)
crossover(parents::Vararg{Individual})
```
or make use of the provided methods.

In Cambrian, individual `fitness` is always a vector of dimension `d_fitness`,
defined in the provided configuration file. For the case of single-objective
fitness, this adds slight overhead but is intended to make all methods flexible
to multi-objective optimization.

Individual algorithms are encouraged to be separated as new packages which
follow the Cambrian framework. Common functionality between multiple algorithms
should be integrated into Cambrian as needed.

## Ecosystem

Cambrian is used in the following packages:
+ [BERL.jl](https://github.com/d9w/BERL.jl)
+ [CartesianGeneticProgramming.jl](https://github.com/d9w/CartesianGeneticProgramming.jl)
+ [MTCGP.jl](https://github.com/d9w/MTCGP.jl)
+ [AGRN.jl](https://github.com/d9w/AGRN.jl)
+ [NeuroEvolution.jl](https://github.com/TemplierPaul/NeuroEvolution.jl)
+ [EvolutionaryStrategies.jl](https://github.com/d9w/EvolutionaryStrategies.jl)

There are other evolutionary computation packages in Julia:
+ [Evolutionary.jl](https://github.com/wildart/Evolutionary.jl)
+ [NSGA-II.jl](https://github.com/gsoleilhac/NSGAII.jl/)
+ [CMAEvolutionStrategy.jl](https://github.com/jbrea/CMAEvolutionStrategy.jl)
+ [NaturalES.jl](https://github.com/francescoalemanno/NaturalES.jl)

There are also excellent optimization libraries in Julia which use evolutionary and other approaches:
+ [BlackBoxOptim.jl](https://github.com/robertfeldt/BlackBoxOptim.jl)
+ [Optim.jl](https://github.com/JuliaNLSolvers/Optim.jl)

`Cambrian` takes inspiration from evolutionary frameworks in other languages, notably:
+ [MABE](https://github.com/Hintzelab/MABE)
+ [DAEP](https://github.com/DEAP/deap)
+ [GAGA](https://github.com/jdisset/gaga/)

`Cambrian` is also used in my course on [evolutionary computation](https://github.com/d9w/evolution).

## Development

Cambrian is still under development and the ecosystem is growing. Pull requests
of bug fixes or features which can be used across multiple algorithms are
greatly appreciated.

A non-exhaustive list of possible upcoming features:
+ better documentation using [Documenter](https://github.com/JuliaDocs/Documenter.jl)
+ ~~Abstract evolution type for multiple dispatch~~
+ Parallelization and test
+ ~~CMA-ES~~
+ NSGA-II
+ Novelty archive
+ co-evolution
+ genetic speciation
+ Island-based
