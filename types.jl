type Edge
    sections::Int
    index::Int
    range::UnitRange{Int}
    node::Array{Edge,1}
    # 0 implies empty tail (the only time that a tail is
    # empty is when the edge is the root edge
    tail::Int
end

type Branch
    sections::Int
    node::Array{Int,1}
    tail::Array{Int,1}
end

