module Darwin

using Random
using Logging
using Distributed
using Statistics
import Formatting
import SharedArrays
import JSON
import UUIDs
import Dates

include("logger.jl")
include("individual.jl")
include("mutation.jl")
include("crossover.jl")
include("selection.jl")
include("evolution.jl")
include("populate.jl")
include("evaluation.jl")
include("util.jl")
include("step.jl")

end
