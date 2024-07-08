import copy
import time
import matplotlib.pyplot as plt
from StudentStructures import *


def norm(vector: Vector) -> float:
    return sum([e ** 2 for e in vector]) ** 0.5


def Solve_Jacobi(A: Matrix, b: Vector, tol: float, max_iter: int) -> (Vector, int, float, list):
    x = Vector(init_type='zeros', size=b.get_size(), is_column=True)
    x_new = Vector(init_type='zeros', size=b.get_size(), is_column=True)
    res_table = []
    iterations = 0
    start_time = time.time()
    while iterations < max_iter:
        for i in range(b.get_size()):
            sum_val = b[i]
            for j in range(b.get_size()):
                if i != j:
                    sum_val -= A[i, j] * x[j]
            x_new[i] = sum_val / A[i, i]
        x = copy.deepcopy(x_new)
        res_table.append(norm(A * x - b))
        if res_table[-1] < tol:
            break
        iterations += 1
    end_time = time.time()
    total_time = end_time - start_time
    return x, iterations, total_time, res_table


def Solve_Gauss_Seidel(A: Matrix, b: Vector, tol: float, max_iter: int) -> (Vector, int, float, list):
    x = Vector(init_type='zeros', size=b.get_size(), is_column=True)
    x_new = Vector(init_type='zeros', size=b.get_size(), is_column=True)
    res_table = []
    iterations = 0
    start_time = time.time()
    while iterations < max_iter:
        for i in range(b.get_size()):
            sum_val = b[i]
            for j in range(i):
                sum_val -= A[i, j] * x_new[j]
            for j in range(i + 1, b.get_size()):
                sum_val -= A[i, j] * x[j]
            x_new[i] = sum_val / A[i, i]
        x = copy.deepcopy(x_new)
        res_table.append(norm(A * x - b))
        if res_table[-1] < tol:
            break
        iterations += 1
    end_time = time.time()
    total_time = end_time - start_time
    return x, iterations, total_time, res_table


def compare_Gauss_Seidel_and_Jacobi(A: Matrix, b: Vector, tol: float, max_iter: int, index: int):
    x_jacobi, iterations_jacobi, total_time_jacobi, res_table_jacobi = Solve_Jacobi(A, b, tol, max_iter)

    x_gauss_seidel, iterations_gauss_seidel, total_time_gauss_seidel, res_table_gauss_seidel = \
        Solve_Gauss_Seidel(A, b, tol, max_iter)
    print("Jacobi {0}:".format(index))
    print("Iterations:", iterations_jacobi)
    print("Total time:", total_time_jacobi)
    print("Gauss-Seidel {0}:".format(index))
    print("Iterations:", iterations_gauss_seidel)
    print("Total time:", total_time_gauss_seidel)
    plt.plot(res_table_jacobi, label="Jacobi")
    plt.plot(res_table_gauss_seidel, label="Gauss-Seidel")
    plt.yscale('log')
    plt.legend(["Jacobi", "Gauss-Seidel"])
    plt.ylabel("Residual error")
    plt.xlabel("Iterations")
    if index == 1:
        plt.savefig("Gauss_Jacobi_convergent.png")
    else:
        plt.savefig("Gauss_Seidel_Jacobi_divergent.png")
    plt.show()
    return


def LU_factorization(A: Matrix, b: Vector) -> (Vector, float, float):
    start_time = time.time()
    L, U = A.LU_decomposition()
    y = L.forward_substitution(b)
    x = U.backward_substitution(y)
    res_norm = norm(A * x - b)
    end_time = time.time()
    total_time = end_time - start_time
    return x, total_time, res_norm


def compare_all_methods(tol: float, max_iter: int):
    N = [100, 200, 300, 500, 1000]
    times_jacobi = []
    times_gauss_seidel = []
    times_lu = []

    for n in N:
        A = create_student_matrix(9, -1, -1, n)
        b = create_student_vector(n, 3)

        x_jacobi, iterations_jacobi, total_time_jacobi, res_table_jacobi = Solve_Jacobi(A, b, tol, max_iter)

        x_gauss_seidel, iterations_gauss_seidel, total_time_gauss_seidel, res_table_gauss_seidel = \
            Solve_Gauss_Seidel(A, b, tol, max_iter)

        x_lu, total_time_lu, res_norm_lu = LU_factorization(A, b)

        times_jacobi.append(total_time_jacobi)
        times_gauss_seidel.append(total_time_gauss_seidel)
        times_lu.append(total_time_lu)

    plt.plot(N, times_jacobi, label="Jacobi")
    plt.plot(N, times_gauss_seidel, label="Gauss-Seidel")
    plt.plot(N, times_lu, label="LU")
    plt.legend(["Jacobi", "Gauss-Seidel", "LU"])
    plt.ylabel("Time[s]")
    plt.xlabel("Matrix size")
    plt.savefig("Time_Comparison.png")
    plt.show()
    return
