from MathStructures import *
import matplotlib.pyplot as plt


def lagrange_interpolation(nodes: list[Point], x: float) -> float:
    result = 0
    for i in range(len(nodes)):
        temp = 1
        for j in range(len(nodes)):
            if i != j:
                temp *= (x - nodes[j].x) / (nodes[i].x - nodes[j].x)
        result += temp * nodes[i].y
    return result


def plot_lagrange_interpolation(original_values: list[Point], number_of_nodes: int, type_of_nodes_spacing: str, file_name: str):
    if type_of_nodes_spacing == 'line_space':
        nodes_indexes = line_space(0, len(original_values) - 1, number_of_nodes)
        nodes = [original_values[int(i)] for i in nodes_indexes]
    elif type_of_nodes_spacing == 'chebyshev':
        nodes_indexes = chebyshev(0, len(original_values) - 1, number_of_nodes)
        nodes = [original_values[int(i)] for i in nodes_indexes]
    else:
        raise ValueError("Wrong type of nodes spacing")

    x = [i for i in range(len(original_values))]
    y = [lagrange_interpolation(nodes, i) for i in x]

    plt.figure(figsize=(12, 8))
    plt.plot([node.x for node in original_values], [lagrange_interpolation(nodes, node.x) for node in original_values],
             color='blue', label="Wartości interpolowane")
    plt.scatter([node.x for node in nodes], [node.y for node in nodes], color='red', s=100, zorder=5, label="Interpolation Nodes")
    plt.plot([node.x for node in original_values], [node.y for node in original_values],  color='green', linewidth=2, label="Original Points")

    plt.xlabel('Dystans(m)')
    plt.ylabel('Wysokość(m)')
    file_name = file_name.split('.')[0]
    plt.suptitle(file_name)
    plt.title("Iterpolacja Lagrange'a" + f" - {type_of_nodes_spacing}" + f" - n = {number_of_nodes}")
    plt.legend()
    plt.grid(True)


def solve_cubic_spline(x, y):
    A, b, h = create_cubic_spline_matrix(x, y)
    coeffs, _ = LU_factorization(A, b)
    return coeffs, h


def spline_interpolation(nodes: list[Point], x: float) -> float:
    x_values = [node.x for node in nodes]
    y_values = [node.y for node in nodes]
    coeffs, h = solve_cubic_spline(x_values, y_values)

    n = len(x_values) - 1

    # Coefficients for cubic polynomials
    a = [y_values[i] for i in range(n)]
    b = [(y_values[i + 1] - y_values[i]) / h[i] - h[i] * (2 * coeffs[i] + coeffs[i + 1]) / 3 for i in range(n)]
    d = [(coeffs[i + 1] - coeffs[i]) / (3 * h[i]) for i in range(n)]

    for i in range(n):
        if x_values[i] <= x <= x_values[i + 1]:
            dx = x - x_values[i]
            return a[i] + b[i] * dx + coeffs[i] * dx ** 2 + d[i] * dx ** 3


def plot_spline_interpolation(original_values: list[Point], number_of_nodes: int, file_name: str):
    nodes_indexes = line_space(0, len(original_values) - 1, number_of_nodes)
    nodes = [original_values[int(i)] for i in nodes_indexes]

    x = [i for i in range(len(original_values))]
    y = [spline_interpolation(nodes, i) for i in x]

    plt.figure(figsize=(12, 8))
    plt.plot([node.x for node in original_values], [spline_interpolation(nodes, node.x) for node in original_values],
             color='blue', label="Interpolated Values")
    plt.scatter([node.x for node in nodes], [node.y for node in nodes], color='red', s=100, zorder=5,
                label="Interpolation Nodes")
    plt.plot([node.x for node in original_values], [node.y for node in original_values], color='green', linewidth=2,
             label="Original Points")

    plt.xlabel('Dystans(m)')
    plt.ylabel('Wysokość(m)')
    file_name = file_name.split('.')[0]
    plt.suptitle(file_name)
    plt.title("Iterpolacja Spline" + f" - n = {number_of_nodes}))")
    plt.legend()
    plt.grid(True)

