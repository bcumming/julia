include("newton.jl")
using Newton

f(x) = sin(x)

solution, err = newton(x -> sin(x), 0.1)
println("solution is ", solution, " and error is ", err)

solution, err = newton(x -> x*x, 0.1)
println("solution is ", solution, " and error is ", err)

