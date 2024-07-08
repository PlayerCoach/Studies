from MathStructures import Matrix, Vector
import math


def create_student_matrix(a1: int, a2: int, a3: int, N: int) -> Matrix:

    diagonal_matrix = Matrix(init_type='zeros', rows=N, cols=N)
    for i in range(N):
        for j in range(N):
            if i == j:
                diagonal_matrix[i, j] = a1
            elif i == j - 1 or i == j + 1:
                diagonal_matrix[i, j] = a2
            elif i == j - 2 or i == j + 2:
                diagonal_matrix[i, j] = a3

    return diagonal_matrix


def create_student_vector(N: int, f: int) -> Vector:
    sin_vector = Vector(init_type='zeros', size=N, is_column=True)
    for i in range(N):
        sin_vector[i] = math.sin(i * (f+1))
    return sin_vector
