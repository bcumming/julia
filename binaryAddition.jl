function binaryAddition(A::Array{Int}, B::Array{Int})
    n::Int64 = length(A)
    assert(n==length(B))

    C = zeros(Int64,1,n+1)

    carry::Int64 = 0
    for i=1:n
        s = carry + A[i] + B[i]
        C[i] = mod(s,2)
        carry = s>1 ? 1 : 0
    end

    C[n+1] = carry

    return C
end

function fromBinary(A::Array{Int})
    total::Int64 = 0
    n::Int64 = length(A)
    pot::Int64 = 1
    for i=1:n
        total += A[i] * pot
        pot *= 2
    end

    return total
end

function test(a, b)
    c = binaryAddition(a, b)
    A = fromBinary(a)
    B = fromBinary(b)
    C = fromBinary(c)
    println(A, " + ", B, " = ", C)
    correct::Bool = A+B == C
    if !correct
        println("   ", a, " + ", b, " = ", c)
    end

    return correct
end

test([1 1], [1 1])
test([0 1], [1 1])
test([1 0 1], [1 1 1])
test([0 1 1], [1 1 1])
test([0 1 0 0 1 0 0], [1 1 1 0 0 1 1])


