module Newton

export newton

function newton(f, x0)
    epsilon = 1e-12

    xnew = x0
    fx = f(xnew)

    iters = 0
    while abs(fx)>1e-10
        xold = xnew
        dfx = (f(xold + epsilon) - fx)/epsilon
        dx = -fx/dfx
        xnew = xold + dx
        fx = f(xnew)
        iters += 1
        println("\titer  ", iters, " ", abs(fx), " ", xnew)
    end

    println("it took ", iters, " iterations to attain error ", abs(fx), " ", xnew)

    return xnew, abs(fx)
end # function newton

end # module Newton
