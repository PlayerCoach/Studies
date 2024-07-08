from Solvers import *
N = 915
e = 4
f = 3


if __name__ == "__main__":
    A = create_student_matrix(9, -1, -1,  N)
    b = create_student_vector(915, f)
    compare_Gauss_Seidel_and_Jacobi(A, b, 1e-9, 1000, 1)
    A = create_student_matrix(3, -1, -1, N)
    compare_Gauss_Seidel_and_Jacobi(A, b, 1e-9, 100, 2)
    x, total_time, res_norm = LU_factorization(A, b)
    print("Total time:", total_time)
    print("Residual norm:", res_norm)
    compare_all_methods(1e-9, 100)
