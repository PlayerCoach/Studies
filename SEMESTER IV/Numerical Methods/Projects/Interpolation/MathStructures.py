from math import cos, pi


class Matrix:
    def __init__(self, initial_content=None, init_type=None, rows=None, cols=None, size=None):
        if initial_content is None and (init_type is None and size is None) \
                and (init_type is None and rows is None and cols is None):
            raise ValueError("Invalid arguments")
        elif initial_content is not None:
            self._rows = len(initial_content)
            self._cols = len(initial_content[0])
            self._matrix = initial_content
        elif init_type is not None and ((rows is not None and cols is not None) or size is not None):
            if size is not None:
                rows = size
                cols = size
                self._rows = rows
                self._cols = cols
            else:
                self._rows = rows
                self._cols = cols
            self._matrix = self._create_matrix(init_type, rows, cols)

    @staticmethod
    def _create_matrix(init_type, rows, cols):
        if init_type == "zeros":
            return [[0 for _ in range(cols)] for _ in range(rows)]
        elif init_type == "identity":
            if rows != cols:
                raise ValueError("Identity matrix must be square")
            return [[1 if i == j else 0 for j in range(cols)] for i in range(rows)]
        elif init_type == "ones":
            return [[1 for _ in range(cols)] for _ in range(rows)]
        elif init_type == "lower_triangular":
            return [[0 if i < j else 1 for j in range(cols)] for i in range(rows)]
        elif init_type == "upper_triangular":
            return [[0 if i > j else 1 for j in range(cols)] for i in range(rows)]
        else:
            raise ValueError("Invalid init_type")

    def __str__(self) -> str:
        return "\n".join([" ".join([str(e) for e in row]) for row in self._matrix])

    def __getitem__(self, item) -> float:
        return self._matrix[item[0]][item[1]]

    def __setitem__(self, key, value) -> None:
        self._matrix[key[0]][key[1]] = value

    def get_rows(self) -> int:
        return self._rows

    def get_cols(self) -> int:
        return self._cols

    def get_matrix(self) -> list:
        return self._matrix

    def transpose(self) -> None:
        self._matrix = [[self._matrix[j][i] for j in range(self._rows)] for i in range(self._cols)]
        self._rows, self._cols = self._cols, self._rows

    def __add__(self, other) -> 'Matrix':
        if self.get_rows() != other.get_rows() or self.get_cols() != other.get_cols():
            raise ValueError("Invalid matrix sizes")
        return Matrix([[self[i, j] + other[i, j] for j in range(self.get_cols())] for i in range(self.get_rows())])

    def __sub__(self, other) -> 'Matrix':
        if self.get_rows() != other.get_rows() or self.get_cols() != other.get_cols():
            raise ValueError("Invalid matrix sizes")
        return Matrix([[self[i, j] - other[i, j] for j in range(self.get_cols())] for i in range(self.get_rows())])

    def matrix_times_scalar(self, scalar) -> 'Matrix':
        return Matrix([[scalar * e for e in row] for row in self._matrix])

    def matrix_times_matrix(self, other) -> 'Matrix':
        if self.get_cols() != other.get_rows():
            raise ValueError("Invalid matrix sizes")
        new_matrix = Matrix(init_type='zeros', rows=self.get_rows(), cols=other.get_cols())
        for i in range(self.get_rows()):
            for j in range(other.get_cols()):
                new_matrix[i, j] = sum(self[i, k] * other[k, j] for k in range(self.get_cols()))
        return new_matrix

    def matrix_times_vector(self, other) -> 'Vector':
        if other.is_column() and self.get_cols() != other.get_size():
            raise ValueError("Invalid matrix and vector sizes")
        elif not other.is_column() and self.get_cols() != 1:
            raise ValueError("Invalid matrix and vector sizes")

        if other.is_column():
            new_vector = Vector(init_type='zeros', size=self.get_rows(), is_column=True)
            for i in range(self.get_rows()):
                new_vector[i] = sum(self[i, j] * other[j] for j in range(self.get_cols()))
            return new_vector
        else:
            new_vector = Vector(init_type='zeros', size=self.get_cols(), is_column=False)
            for i in range(self.get_cols()):
                new_vector[i] = sum(self[j, i] * other[j] for j in range(self.get_rows()))
            return new_vector

    def __mul__(self, other) -> 'Matrix' or 'Vector':
        if isinstance(other, Matrix):
            return self.matrix_times_matrix(other)
        elif isinstance(other, float) or isinstance(other, int):
            return self.matrix_times_scalar(other)
        elif isinstance(other, Vector):
            return self.matrix_times_vector(other)
        else:
            raise ValueError("Invalid multiplication")

    def check_if_upper_triangular(self) -> bool:
        for i in range(self.get_rows()):
            for j in range(i):
                if self[i, j] != 0:
                    return False
        return True

    def check_if_lower_triangular(self) -> bool:
        for i in range(self.get_rows()):
            for j in range(i + 1, self.get_cols()):
                if self[i, j] != 0:
                    return False
        return True

    def forward_substitution(self, b) -> 'Vector':
        if not self.check_if_lower_triangular():
            raise ValueError("Matrix is not lower triangular")
        if self.get_rows() != b.get_size():
            raise ValueError("Invalid matrix and vector sizes")
        x = Vector(init_type='zeros', size=self.get_rows(), is_column=True)
        for i in range(self.get_rows()):
            x[i] = b[i]
            for j in range(i):
                x[i] -= self[i, j] * x[j]
            x[i] /= self[i, i]
        return x

    def backward_substitution(self, b) -> 'Vector':
        if not self.check_if_upper_triangular():
            raise ValueError("Matrix is not upper triangular")
        if self.get_rows() != b.get_size():
            raise ValueError("Invalid matrix and vector sizes")
        x = Vector(init_type='zeros', size=self.get_rows(), is_column=True)
        for i in range(self.get_rows() - 1, -1, -1):
            x[i] = b[i]
            for j in range(i + 1, self.get_rows()):
                x[i] -= self[i, j] * x[j]
            x[i] /= self[i, i]
        return x

    def LU_decomposition(self) -> ('Matrix', 'Matrix'):
        if self.get_rows() != self.get_cols():
            raise ValueError("Matrix is not square")
        L = Matrix(init_type='lower_triangular', size=self.get_rows())
        U = Matrix(init_type='upper_triangular', size=self.get_rows())
        for i in range(self.get_rows()):
            for j in range(i, self.get_cols()):
                U[i, j] = self[i, j] - sum(L[i, k] * U[k, j] for k in range(i))
            for j in range(i + 1, self.get_rows()):
                L[j, i] = (self[j, i] - sum(L[j, k] * U[k, i] for k in range(i))) / U[i, i]
        return L, U


class Vector:
    def __init__(self, initial_content=None, init_type=None, size=None, is_column=False):
        if initial_content is None and (init_type is None or size is None):
            raise ValueError("Invalid arguments")
        elif initial_content is not None:
            self._size = len(initial_content)
            self._vector = initial_content
            self._is_column = is_column
        elif init_type is not None and size is not None:
            self._size = size
            self._vector = self._create_vector(init_type, size)
            self._is_column = is_column

    @staticmethod
    def _create_vector(init_type, size):
        if init_type == "zeros":
            return [0 for _ in range(size)]
        elif init_type == "ones":
            return [1 for _ in range(size)]
        else:
            raise ValueError("Invalid init_type")

    def __str__(self):
        if self._is_column:
            return "\n".join([str(e) for e in self._vector])
        else:
            return " ".join([str(e) for e in self._vector])

    def __getitem__(self, item):
        return self._vector[item]

    def __setitem__(self, key, value):
        self._vector[key] = value

    def get_size(self):
        return self._size

    def get_vector(self):
        return self._vector

    def is_column(self):
        return self._is_column

    def transpose(self):
        self._is_column = not self._is_column

    def dot_product(self, other):
        if self.get_size() != other.get_size():
            raise ValueError("Invalid vector sizes")
        return sum(self[i] * other[i] for i in range(self.get_size()))

    def element_wise(self, other):
        if self.get_size() != other.get_size():
            raise ValueError("Vector sizes must be equal")
        elif self.is_column() and other.is_column():
            content = [self[i] * other[i] for i in range(self.get_size())]
            return Vector(initial_content=content, is_column=True)
        elif not self.is_column() and not other.is_column():
            content = [self[i] * other[i] for i in range(self.get_size())]
            return Vector(initial_content=content, is_column=False)
        else:
            return self.generate_multiplied_matrix(other)

    def __add__(self, other):
        if self.get_size() != other.get_size():
            raise ValueError("Invalid vector sizes")
        if self.is_column() != other.is_column():
            raise ValueError("One of the vectors must be a column vector and the other a row vector")
        return Vector([self[i] + other[i] for i in range(self.get_size())], is_column=self.is_column())

    def __sub__(self, other):
        if self.get_size() != other.get_size():
            raise ValueError("Invalid vector sizes")
        if self.is_column() != other.is_column():
            raise ValueError("One of the vectors must be a column vector and the other a row vector")
        return Vector([self[i] - other[i] for i in range(self.get_size())], is_column=self.is_column())

    def vector_times_scalar(self, scalar):
        return Vector([scalar * e for e in self._vector])

    def vector_times_vector(self, other):
        if self.is_column() == other.is_column():
            raise ValueError("One of the vectors must be a column vector and the other a row vector")
        elif not self.is_column() and other.is_column():
            if self.get_size() != other.get_size():
                raise ValueError("Invalid vector sizes")
            return self.dot_product(other)
        elif self.is_column() and not other.is_column():
            return self.generate_multiplied_matrix(other)

    def generate_multiplied_matrix(self, other) -> 'Matrix':
        new_matrix = Matrix(init_type='zeros', rows=self.get_size(), cols=other.get_size())
        for i in range(self.get_size()):
            for j in range(other.get_size()):
                new_matrix[i, j] = self[i] * other[j]
        return new_matrix

    def vector_times_matrix(self, other):
        if self.is_column() is False and other.get_rows() != self.get_size():
            raise ValueError("Invalid vector and matrix sizes")
        elif self.is_column() and other.get_rows() != 1:
            raise ValueError("Invalid vector and matrix sizes")
        if not self.is_column():
            new_vector = Vector(init_type='zeros', size=other.get_cols(), is_column=False)
            for i in range(other.get_cols()):
                new_vector[i] = sum(self[j] * other[j, i] for j in range(self.get_size()))
            return new_vector
        else:
            new_vector = Vector(init_type='zeros', size=other.get_rows(), is_column=True)
            for i in range(other.get_rows()):
                new_vector[i] = sum(self[j] * other[i, j] for j in range(self.get_size()))
            return new_vector

    def __mul__(self, other):
        if isinstance(other, Vector):
            return self.vector_times_vector(other)
        elif isinstance(other, Matrix):
            return self.vector_times_matrix(other)
        elif isinstance(other, float) or isinstance(other, int):
            return self.vector_times_scalar(other)
        else:
            raise ValueError("Invalid multiplication")

    def copy(self):
        return Vector(initial_content=self._vector, is_column=self._is_column)


class Point:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

    def __str__(self) -> str:
        return f"({self.x}, {self.y})"


def LU_factorization(A: Matrix, b: Vector) -> (Vector, float, float):
    L, U = A.LU_decomposition()
    y = L.forward_substitution(b)
    x = U.backward_substitution(y)
    res_norm = norm(A * x - b)
    return x, res_norm


def norm(vector: Vector) -> float:
    return sum([e ** 2 for e in vector]) ** 0.5


def line_space(start, stop, num) -> list[int]:
    return [round(start + i * (stop - start) / (num - 1)) for i in range(num)]


def chebyshev(start, stop, num) -> list[int]:
    return [round((start + stop) / 2 + (stop - start) / 2 * cos((2 * i + 1) * pi / (2 * num))) for i in range(num)]


def create_cubic_spline_matrix(x, y):
    n = len(x) - 1
    h = [x[i + 1] - x[i] for i in range(n)]
    A = Matrix(init_type='zeros', rows=len(x), cols=len(x))
    b = Vector(init_type='zeros', size=len(x), is_column=True)

    for i in range(1, n):
        A[i, i - 1] = h[i - 1]
        A[i, i] = 2 * (h[i - 1] + h[i])
        A[i, i + 1] = h[i]
        b[i] = 3 * ((y[i + 1] - y[i]) / h[i] - (y[i] - y[i - 1]) / h[i - 1])

    A[0, 0] = 1
    A[n, n] = 1

    return A, b, h


