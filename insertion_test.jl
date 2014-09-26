include("insertionSort.jl")
include("linearSearch.jl")

v = [1 8 7 2 1 9];

println(v)
insertionSort!(v)
println(v)
insertionSort!(v, (x,y)->x>y)
println(v)

println("position of 8 is ", linearSearch(v, 8))
println("position of 10 is ", linearSearch(v, 10))
println("position of 1 is ", linearSearch(v, 1))

