using LinearAlgebra

# values that X, Y can take on with nonzero probability, i.e. their supports
X = [-1, 0, 1]; # [x_1, x_2, ..., x_m]
Y = [-1, 0, 1]; # [y_1, y_2, ..., y_n]

m = length(X); n = length(Y);

# joint probability mass function (PMF)
#
# p[i,j] = ℙ(X = x_i, Y = y_j)
p = [1/20 3/16 1/20; # for X = [-1, 0, 1] = Y and this choice of p,
     3/16 1/20 3/16  # cov(X,Y)=0 and X,Y are not independent
     1/20 3/16 1/20];

# (note: this is actually just p with the values in the corner entries perturbed)
p_alt1 = [0.06   0.1875 0.04;
          0.1875 0.05   0.1875 # for X = [-1, 0, 1] = Y and this choice of p, X and Y are not independent,
          0.04   0.1875 0.06]; # however cov(X,Y) is nonzero

p_alt2 = [1/9 1/9 1/9; # for X = [-1, 0, 1] = Y and this choice of p, it holds that cov(X,Y)=0,
          1/9 1/9 1/9; # however X, Y are independent
          1/9 1/9 1/9];

# verify that p has appropriate height/width given that |supp(X)| = m and |supp(Y)| = n
@assert size(p) == (m,n)
@assert isapprox(1, sum([p[i,j] for i=1:m, j=1:n])) # verify that entries of p sum to 1

# mapping from RV instantiation values to indices
I = Dict([X[i] => i for i = 1:m]);
J = Dict([Y[j] => j for j = 1:n]);

ℙ(; X, Y) = p[I[X], J[Y]]; # (uses keyword arguments)

# marginal PMFs
p_x(x) = sum([p[I[x], j] for j = 1:n]);
p_y(y) = sum([p[i, J[y]] for i = 1:m]);

# make sure X and Y are not independent
not_independent = !all([isapprox(ℙ(X=x,Y=y), p_x(x)*p_y(y)) for x ∈ X, y ∈ Y]);

# recall that cov(X, Y) = 0 ⟺ 𝔼[XY] = 𝔼[X] * 𝔼[Y]
𝔼_XY = sum([x*y*ℙ(X=x,Y=y) for x ∈ X, y ∈ Y]);
𝔼_X = sum([x*p_x(x) for x ∈ X]);
𝔼_Y = sum([y*p_y(y) for y ∈ Y]);

# need both to be true
(isapprox(𝔼_XY, 𝔼_X*𝔼_Y), not_independent)