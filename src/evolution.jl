export Evolution

mutable struct Evolution
    id::String
    log::AbstractLogger
    population::Array{Individual}
    gen::Int64
    cfg::Dict
    mutation::Function
    crossover::Function
    selection::Function
    evaluation::Function
    generation::Function
end

no_genfunc(e::Evolution) = nothing

function Evolution(itype::Type, cfg::Dict;
                   id::String=string(UUIDs.uuid4()),
                   logfile::String=string("logs/", id, ".log"),
                   populate::Function=default_populate,
                   mutation::Function=uniform_mutation,
                   crossover::Function=uniform_crossover,
                   selection::Function=tournament_selection,
                   evaluation::Function=null_evaluate,
                   generation::Function=no_genfunc)
    logger = DarwinLogger(logfile)
    population = populate(itype, cfg)
    Evolution(id, logger, population, 0, cfg, mutation, crossover,
              selection, evaluation, no_genfunc)
end
