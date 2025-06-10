from time import time
import numpy as np
from juliacall import Main as jl

# Let's create 500x500 matrixes with random values 
n = 200
A = np.random.rand(n, n)
B= np.random.rand(n, n)

# Julia implementation through JuliaCall
jl.seval("""
function mult_julia(A, B)
    n = size(A, 1)
    C = zeros(n, n)
         
    for i in 1:n
        for j in 1:n
            for k in 1:n
                C[i, j] += A[i, k] * B[k, j]
            end
        end
    end
         
    return C
end      
""")

# Python dummy implementation with "list"
def mult_python(A, B):
    n = len(A)
    C = [[09.0 for _ in range(n)] for _ in range(n)]
    for i in range(n):
        for j in range(n):
            for k in range(n):
                C[i][j] += A[i][k] * B[k][j]
    return C

# Multiplication with Python
start = time()
C_py = mult_python(A.tolist(), B.tolist()) # convert the Numpy array to lists
print(f"Python time: {round(time() - start, 3)} seconds")

# Multiplication with NumPy (imlemented in C)
start = time()
C_np = A @ B
print(f"Numpy time: {round(time() - start, 3)} seconds")

# Multiplication with Julia (first time, extra time for compiling)
start = time()
C_jl = jl.mult_julia(A, B)
print(f"Julia time (1st time): {round(time() - start, 3)} seconds")

# Multiplication with Julia (second time, already compiled)
start = time()
C_jl = jl.mult_julia(A, B)
print(f"Julia time (2nd time): {round(time() - start, 3)} seconds")
