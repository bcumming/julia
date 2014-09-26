function linearSearch{T}(v::Array{T}, value::T)

n = length(v)

pos = 0
i = 1
# pos is location of value in v[1..0]
while i<=n
    # pos is location of value in v[1..i-1]
    if v[i]==value
        pos = i
    end
    # pos is location of value in v[1..i]
    i += 1
end

return pos

end # function linearSearch
