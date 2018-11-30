module Darwin

using Random
using Logging
using Distributed
import Formatting
import SharedArrays
import JSON
import UUIDs

include("individual.jl")
include("mutation.jl")
include("crossover.jl")
include("selection.jl")
include("evolution.jl")

end
