include("newton.jl")
using Newton

# list of times in seconds
#        second minute hour day month year century
times = [1.0 60 3600 3600*24 3600*24*30 3600*24*365.25 3600*24*365.25*100];
functions = [x->log2(x), x -> x^2, x -> x^3]
fnames    = ["lg(x)",    "x^2",    "x^3"   ]

println(times)
println(functions)
println(fnames)

nt = length(times)
nf = length(functions)

solution = newton(x -> functions[2](x)-100, 120)
println(solution[1], " with error ", solution[2])

for fi = 1:nf
    println("function ", fnames[fi])
    for ti = 1:nt
        solution = newton(x -> functions[fi](x)-1000*times[ti], 100)
        println("\tt = ", times[ti], "\t:\t", solution[1])
    end
end

