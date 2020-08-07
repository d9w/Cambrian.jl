# Cambrian.jl

[![Build Status](https://travis-ci.org/d9w/Cambrian.jl.svg?branch=master)](https://travis-ci.org/d9w/Cambrian.jl) [![Coverage Status](https://coveralls.io/repos/d9w/Cambrian.jl/badge.svg?branch=master)](https://coveralls.io/r/d9w/Cambrian.jl?branch=master) [![codecov](https://codecov.io/gh/d9w/Cambrian.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/d9w/Cambrian.jl)

<img src="imgs/logo.png" width="800px" height="auto">

An Evolutionary Computation framework, focused on genetic programming and neuroevolution

## Installation

Cambrian can be installed through the Julia package manager:

```julia
julia> Pkg.add("Cambrian")
```

## Ecosystem

Cambrian is used in the following packages:
+ [BERL.jl](https://github.com/d9w/BERL.jl)
+ [CartesianGeneticProgramming.jl](https://github.com/d9w/CartesianGeneticProgramming.jl)
+ [MTCGP.jl](https://github.com/d9w/MTCGP.jl)
+ [AGRN.jl](https://github.com/d9w/AGRN.jl)

There are other similar packages in Julia:
+ [Evolutionary.jl](https://github.com/wildart/Evolutionary.jl)
+ [NSGA-II.jl](https://github.com/gsoleilhac/NSGAII.jl/)

Some of the code in Cambrian is from or used in my course on [evolutionary computation](https://github.com/d9w/evolution).

## Development

Cambrian is still under heavy development, so expect breaking changes. Pull
requests are greatly appreciated.

A non-exhaustive list of possible upcoming features:
+ [Documentation](https://github.com/JuliaDocs/Documenter.jl)
+ Abstract evolution type for multiple dispatch
+ Test parallelization
+ CMA-ES
+ NSGA-II style multi-objective
+ Novelty archive
+ co-evolution
+ speciation
+ Island-based
+ JuMP-style API
