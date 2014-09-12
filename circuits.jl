branches6 = [
    Branch(5, [],      [2,3]),      # 1
    Branch(5, [],      [1,3]),      # 2
    Branch(5, [1, 2],  [4,5,6]),    # 3
    Branch(5, [],      [3,5,6]),    # 4
    Branch(5, [],      [3,4,6]),    # 5
    Branch(5, [3,4,5], [] ),        # 6
];

#           / 3
# 1    4   /
#----.----.
#          \
#           \ 2
branches4 = [
    Branch(5, [],  [4]),      # 1
    Branch(5, [],  [4,3]),    # 2
    Branch(5, [],  [4,2]),    # 3
    Branch(5, [1], [2,3]),    # 4
];

#      / 3
# 1   /
#----.
#     \
#      \ 2
branches3 = [
    Branch(5, [],  [2,3]),    # 1
    Branch(5, [],  [1,3]),    # 2
    Branch(5, [],  [1,2]),    # 3
];

# 1    2     3
#----.----.----
branches3straight = [
    Branch(5, [],  [2]),      # 1
    Branch(5, [3], [1]),      # 2
    Branch(5, [],  [2]),      # 2
];

# 1     2
#----.----
branches2 = [
    Branch(5, [],  [2]),      # 1
    Branch(5, [],  [1]),      # 2
];


branches1 = [
    Branch(5, [],  [])      # 1
];
