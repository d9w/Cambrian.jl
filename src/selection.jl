export tournament_selection

function tournament_selection(inds::Array{Individual})
    sort(inds)[end]
end
