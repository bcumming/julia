is_terminal_edge = edge::Edge -> edge.tail==0 || isempty(edge.node)

function set_node(b::Branch)
    if isempty(b.node)
        b.node = b.tail
        b.tail = [];
    end
    # assert that at least one of left and right is non-empty
    @assert !isempty(b.node)
end

# ensure that branch i is a node of b
# swap the tail and node connectors if necesary
function set_node(b::Branch, i::Int)
    if in(i, b.tail)
        tmp = b.node
        b.node = b.tail
        b.tail = tmp;
    end
    # assert that it is actually in the node
    @assert in(i, b.node)
end

# ensure that branch i is a tail of b
# swap the tail and node connectors if necesary
function set_tail(b::Branch, i::Int)
    if i == 0
        set_node(b)
    elseif in(i, b.node)
        tmp = b.node
        b.node = b.tail
        b.tail = tmp;
    end
    # assert that it is actually in the tail
    @assert i==0 || in(i, b.tail)
end

is_terminal_branch = (b) -> isempty(b.tail)

type Tree
    root::Edge

    # construct from a list of branches
    function Tree(b::Array{Branch, 1}, root=0)
        # ensure that all branches that are terminal branches have
        # the tail mark as the empty end
        for i=1:length(b)
            set_node(b[i])
        end

        # find a suitable branch for the root
        # iterate through branches until a terminal branch is found
        if root<=0
            root = 1
            while root<length(b) && !is_terminal_branch(b[root])
                root += 1
            end
        else
            @assert is_terminal_branch(b[root])
        end

        println("root is ", root)

        # the 0 indicates that this is the root of the tree
        new(process_child_branch(0, root, b))
    end
end

Base.print(io::IO, b::Branch) =
    Base.print(io, "branch of length ", b.sections, ", node ", b.node, ", tail ", b.tail)
function Base.print(io::IO, t::Tree)
    Base.print(io, "tree with root ", t.root)
end

function process_child_branch(root::Int, index::Int, branches::Array{Branch,1})
    sections = branches[index].sections
    edge = Edge(sections, -1, 1:sections, Edge[], root)

    set_tail(branches[index], root)
    for child in branches[index].node
        push!( edge.node,
               process_child_branch(index, child, branches))
    end

    return edge
end

# numbering all of the edges and ranges in a tree to be consistent for Hines algorithm
function number_edges_and_ranges(edge::Edge)
    function number_edges_recursive(edge::Edge, index::(Int,Int))
        edge.index = index[1]
        range_end = index[2]+edge.sections-2
        edge.range = index[2]:range_end
        index = (index[1]+1, range_end+1)
        for e in edge.node
            index = number_edges_recursive(e, index)
        end
        return index
    end

    range_end = edge.sections
    edge.index = 1
    edge.range = 1:range_end
    index = (2, range_end+1)
    for e in edge.node
        index = number_edges_recursive(e, index)
    end
    return (index[1]-1, index[2]-1)
end

# print a tree in .dot file format
function print_edges(edge::Edge)
    s = ASCIIString[]
    function print_edges_recursive(edge::Edge)
        push!(s, @sprintf "  %d [label = \"%d [%d:%d]\"]" edge.index edge.index minimum(edge.range) maximum(edge.range) )
        for e in edge.node
            push!(s, @sprintf "  %d -> %d;" edge.index e.index)
            cat(1, s, print_edges_recursive(e))
        end

        return s
    end

    s = ["Digraph G{"]
    push!(s, "  node [fontname=Courier, color=Blue]")
    push!(s, "  edge [color=Blue]")
    cat(1, s, print_edges_recursive(edge))
    push!(s, "}")
    return s
end

range_min = e::Edge -> minimum(e.range)
range_max = e::Edge -> maximum(e.range)

function generate_section_connections(edge::Edge)

    function section_connections_recursive(edge::Edge)
        local connections = Array{Int64, 1}[]
        cons = isempty(edge.node) ? [] : [range_max(edge)]
        for e in edge.node
            # build list of the first section id in each neighbour
            push!(cons, range_min(e))
        end
        
        for e in edge.node
            neigh_cons = section_connections_recursive(e)
            # add connection to the node of this branch
            push!(neigh_cons[1], range_max(edge))
            sort!(neigh_cons[1])
            connections = cat(1, connections, neigh_cons)
        end
        # build local connections for this branch
        local_connections = Array{Int64, 1}[]
        # first is only connected to the second
        push!(local_connections, edge.range[1:2])
        for i=edge.range[2:end-1]
            # interior points are connected to those that come before and after
            push!(local_connections, i-1:i+1)
        end
        # last is connected to the one that comes before, and those from the child branches
        push!(local_connections, unique(cat(1, edge.range[end-1:end], cons)))

        return cat(1, local_connections, connections)
    end

    connections = section_connections_recursive(edge)

    I = Int64[]
    J = Int64[]
    for i=1:length(connections)
        J = cat(1, J, connections[i])
        I = cat(1, I, i*ones(Int64, length(connections[i])))
    end
    return (I, J)
end

####################################

# import sample branch circuits
include("circuits.jl")

tree = Tree(branches6, 6);
number_edges_and_ranges(tree.root)

edge_description = print_edges(tree.root)

# write graph description to dot file
fid = open("sample.dot", "w")
for s in edge_description
    println(fid, s)
end
close(fid)

println("generating connections...")
I, J = generate_section_connections(tree.root)
println(I')
println(J')

A = sparse(I, J, ones(length(I)))

using PyPlot

spy(A)

