export get_config

function get_base_config()
    (seed = 0,           # evolution seed
     d_fitness = 1,      # fitness dimension
     n_population = 2,   # population size
     n_elite = 1,        # elites to carry over each generation
     n_gen = 10,         # number of generations
     log_gen = 1,        # log every x generations
     save_gen = 1,       # save population every x generation
     id = string(Dates.now()) # run id
     )
end

"convert Dict to named tuple"
function get_config(cfg::Dict)
    (; (Symbol(k)=>v for (k, v) in cfg)...)
end

"combine YAML file and kwargs, make sure ID is specified"
function get_config(cfg_file::String; kwargs...)
    cfg = YAML.load_file(cfg_file)
    for (k, v) in kwargs
        cfg[String(k)] = v
    end
    # generate id, use date if no existing id
    if ~(:id in keys(cfg)) && ~("id" in keys(cfg))
        cfg["id"] = string(Dates.now())
    end
    get_config(cfg)
end
