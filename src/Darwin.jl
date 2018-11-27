module Darwin

using Random
using Logging
using Formatting
using JSON
using YAML
using SharedArray

include("individual.jl")
include("mutation.jl")
include("crossover.jl")
include("selection.jl")
include("evolution.jl")

end
