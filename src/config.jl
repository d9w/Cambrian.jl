export get_base_config, get_config

function get_base_config()
    (seed = 0,           # evolution seed
     d_fitness = 1,      # fitness dimension
     n_population = 2,   # population size
     n_elite = 1,        # elites to carry over each generation
     n_gen = 10,         # number of generations
     log_gen = 1,        # log every x generations
     save_gen = 1        # save population every x generation
     )
end

function get_config(cfg_file::String)
    cfg = YAML.load_file(cfg)
    (; (Symbol(k) => v for (k,v) in cfg)...)
end
