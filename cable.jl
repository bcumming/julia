# TERMINILOGY
# section : an "branch" of a tree
# segment : a single finite difference discretization point (one or more in each section)

# a neuron graph is represented as a set of connections between nodes
# and weights for the connections
type network
    connections::Array{Array{Int64, 1}, 1}
    segments::Array{Array{Int64, 1}, 1}
    node_indexes::Array{Int64, 1}
    parent_indexes::Array{Int64, 1}
    function network()
        node_indexes = Int64[1]
        parent_indexes = Int64[0]
        new(Array[Int64[]], Array[Int64[]], node_indexes, parent_indexes)
    end
end

type tridiag
    b::Array{Float64,1}
    d::Array{Float64,1}
    a::Array{Float64,1}

    # construct as l,d,u
    function tridiag(l::Array{Float64,1}, d::Array{Float64,1}, u::Array{Float64,1})
        n = length(d)
        @assert length(l) == n-1
        @assert length(u) == n-1
        new( cat(1, [NaN], l),
             d,
             cat(1, [NaN], u)
           )
    end
end

Base.length(t::tridiag) = Base.length(t.a)
Base.size(t::tridiag) = (Base.length(t.a), Base.length(t.a))
Base.size(n::network) = (Base.length(n.parent_indexes), Base.length(n.parent_indexes))

function Base.print(io::IO, t::tridiag)
    Base.print(io, "tridiagonal matrix ", length(t), "*", length(t),
               "\n  U ", t.a,
               "\n  D ", t.d,
               "\n  L ", t.b)
end

number_of_nodes(n::network) = length(n.connections)
number_of_segments(n::network) = length(n.parent_indexes)

# add a node to a network n
# the value of node is the node in n to which we are connected
function add_node!(n::network, node::Int64, segments::Int64=1)
    node_index = number_of_nodes(n)+1
    @assert node < node_index

    # create empty connection set for the new node
    push!(n.connections, Int64[])
    push!(n.segments, Int64[])

    # list the new node as a child of it's parent, by inserting it into
    # its parent node's connections and segments lists
    push!(n.connections[node], node_index)
    push!(n.segments[node], segments)

    # get the number of segments in the network before this
    # section was added
    current_index = number_of_segments(n)
    parent_index = n.node_indexes[node]
    next_index = current_index + segments-1
    # add the index for the new node
    push!(n.node_indexes, next_index)
    # add parent indexes for all segments in the new section
    n.parent_indexes = cat(1, n.parent_indexes, [parent_index, current_index+1:next_index])

    return None
end

function generate_connectivity(n::network)
    N = number_of_segments(n)

    I = [1]
    J = [1]

    for i = 2:N
        k = n.parent_indexes[i]
        # [a_ik, a_ii, a_ki]
        I = cat(1, I, [i, i, k])
        J = cat(1, J, [k, i, i])
    end

    return (I, J)
end

function matrix(t::tridiag, net::network)
    @assert size(t) == size(net)

    n, m = size(t)
    A = zeros(Float64, n, n)

    A[1,1] = t.d[1]
    for i=2:n
        k = net.parent_indexes[i]
        A[i,k] = t.b[i]
        A[i,i] = t.d[i]
        A[k,i] = t.a[i]
    end
    return A
end

# solve pseudo-tridiagonal system using Hines' algorithm
# the solution is stored in the rhs vector on return
function solve!(A::tridiag, rhs, net::network)

    n = length(rhs)

    # eliminate upper triangle
    for i = n:-1:2
        k = net.parent_indexes[i]

        # divide row k by dii
        dii = A.d[i]
        A.b[i] /= dii
        rhs[i] /= dii

        # adjust row k
        aii = A.a[i]
        A.d[k] -= aii*A.b[i]
        rhs[k] -= aii*rhs[i]
    end

    # normalize d1
    dii = A.d[1]
    rhs[1] /= A.d[1]

    # forward substitution
    for i=2:n
        k = net.parent_indexes[i]
        rhs[i] -= A.b[i] * rhs[k]
    end

    return None
end

# solve pseudo-tridiagonal system using Hines' algorithm
# the solution is stored in the rhs vector on return
function solve2!(A::tridiag, rhs::Array{Float64,1}, net::network)

    n = length(rhs)

    # eliminate upper triangle
    for i = n:-1:2
        k = net.parent_indexes[i]

        # divide row k by dii
        p = A.a[i]/A.d[i]
        A.d[k] -= p*A.b[i]
        rhs[k] -= p*rhs[i]
    end

    # normalize d1
    rhs[1] /= A.d[1]

    # forward substitution
    for i=2:n
        k = net.parent_indexes[i]
        rhs[i] -= A.b[i] * rhs[k]
        rhs[i] /= A.d[i]
    end

    return None
end

function print_graph(net::network, fname="")
    s = ASCIIString[]
    s = ["Digraph G{"]
    push!(s, "  node [fontname=Courier, color=Blue]")
    push!(s, "  edge [color=Blue]")

    for i in 1:number_of_nodes(net)
        for neighbour in net.connections[i]
            push!(s, @sprintf("  %d -> %d;", i, neighbour))
        end
    end

    push!(s, "}")

    # output to file if user supplied filename
    if fname != ""
        fid = open("sample.dot", "w")
        for line in s
            println(fid, line)
        end
        close(fid)
    end

    return s
end

Base.print(io::IO, n::network) =
    Base.print(io, "network with ", number_of_nodes(n), " nodes and ",
                   number_of_segments(n), " segments",
                   "\n  connections ", n.connections,
                   "\n  segments ", n.segments,
                   "\n  node_indexes ", n.node_indexes,
                   "\n  parent_indexes ", n.parent_indexes,
              )

net = network()
compartments_per_section = 10
add_node!(net, 1, compartments_per_section)
add_node!(net, 1, compartments_per_section)
add_node!(net, 1, compartments_per_section)
add_node!(net, 4, compartments_per_section)
add_node!(net, 4, compartments_per_section)
add_node!(net, 3, compartments_per_section)
add_node!(net, 3, compartments_per_section)
add_node!(net, 3, compartments_per_section)
add_node!(net, 8, compartments_per_section)
add_node!(net, 1, compartments_per_section)
add_node!(net, 5, compartments_per_section)
add_node!(net, 7, compartments_per_section)
add_node!(net, 9, compartments_per_section)
add_node!(net, 9, compartments_per_section)
add_node!(net, 10, compartments_per_section)
add_node!(net, 9, compartments_per_section)
add_node!(net, 9, compartments_per_section)

print_graph(net::network, "sample.dot")

println("network has ", number_of_segments(net)," segments")

#println(net)

# generate the tridiagonal matrix
n, m = size(net)
T = tridiag(ones(n-1), -4*ones(n), ones(n-1))
rhs = ones(n)

# get a dense copy of A before factorization
A = matrix(T, net)

# solve using Hine's algorithm
@time solve2!(T, rhs, net)
@time solve2!(T, rhs, net)

# calculate the error
#r = rhs - A\ones(n)
#err = norm(r)
#tol = eps()*100.
#if err>tol
    #println("ERROR: failed to converge with error ", err)
    #println(r')
#else
    #println("SUCCESS: solution is accurate to tolerance ", tol)
#end

using PyPlot
(I, J) = generate_connectivity(net)
S = sparse(I, J, ones(length(I)))
spy(S)
