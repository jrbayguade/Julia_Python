# Well, this test favours Python a lot actually
using PyCall

# JULIA FUNCTIONS
function fib_bad_julia(n)
    if n <= 1
        return [n]  # Creates new array each call
    end
    return vcat(fib_bad_julia(n-1), fib_bad_julia(n-2))
end

function fib_good_julia(n, memo=Dict())
    if haskey(memo, n)
        return memo[n]
    end
    if n <= 1
        memo[n] = n
        return n
    end
    memo[n] = fib_good_julia(n-1, memo) + fib_good_julia(n-2, memo)
    return memo[n]
end

# PYTHON FUNCTIONS
py"""
import tracemalloc

def fib_bad_python(n):
    if n <= 1:
        return [n]
    return fib_bad_python(n-1) + fib_bad_python(n-2)

def fib_good_python(n, memo={}):
    if n in memo:
        return memo[n]
    if n <= 1:
        memo[n] = n
        return n
    memo[n] = fib_good_python(n-1, memo) + fib_good_python(n-2, memo)
    return memo[n]

def measure_memory(func, n):
    tracemalloc.start()
    result = func(n)
    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    return peak
"""

# TEST WITH SAME NUMBERS
test_n = 20  # Same size for all tests

println("=== MEMORY COMPARISON (n=$test_n) ===")

# Julia tests
println("\nJULIA:")
julia_bad_mem = @allocated fib_bad_julia(test_n)
julia_good_mem = @allocated fib_good_julia(test_n)
println("  Bad version:  $(julia_bad_mem) bytes")
println("  Good version: $(julia_good_mem) bytes") 
println("  Julia ratio:  $(round(julia_bad_mem/julia_good_mem, digits=1))x")

# Python tests
println("\nPYTHON:")
python_bad_mem = py"measure_memory(fib_bad_python, $test_n)"
python_good_mem = py"measure_memory(fib_good_python, $test_n)"
println("  Bad version:  $(Int(python_bad_mem)) bytes")
println("  Good version: $(Int(python_good_mem)) bytes")
println("  Python ratio: $(round(python_bad_mem/python_good_mem, digits=1))x")

# Direct comparison
println("\nDIRECT COMPARISON:")
println("  Bad versions:  Julia $(julia_bad_mem) vs Python $(Int(python_bad_mem))")
println("  Good versions: Julia $(julia_good_mem) vs Python $(Int(python_good_mem))")