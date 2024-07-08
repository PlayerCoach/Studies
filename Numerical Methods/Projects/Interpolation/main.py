import os
from os.path import isfile
from os.path import join

from import_data import import_data
from interpolation_solvers import *

NUMBER_OF_NODES = [5, 10, 20, 50]


def get_every_file_name_from_directory(directory: str) -> list[str]:
    return [f for f in os.listdir(directory) if isfile(join(directory, f))]


def plot_standard_data(_original_values: list[Point], _file_name: str):
    plt.figure(figsize=(12, 8))
    plt.plot([node.x for node in _original_values], [node.y for node in _original_values], color='green', linewidth=2,
             label="Original Points")

    plt.xlabel('Dystans(m)')
    plt.ylabel('Wysokość(m)')
    _file_name = _file_name.split('.')[0]
    plt.suptitle(_file_name)
    plt.title("Oryginalne wartości")
    plt.legend()
    plt.grid(True)


if __name__ == "__main__":
    file_names = get_every_file_name_from_directory("in")

    for file_name in file_names:
        original_values = import_data(file_name)
        plot_standard_data(original_values, file_name)
        plt.savefig("out/" + file_name.split('.')[0] + '_original.png')
        plt.close()
        for number_of_nodes in NUMBER_OF_NODES:
            new_file_name = file_name.split('.')[0] + '_lagrange_linespace_' + f'_n{number_of_nodes}.png'
            plot_lagrange_interpolation(original_values, number_of_nodes, 'line_space', file_name)
            plt.savefig("out/" + new_file_name)
            plt.close()

            new_file_name = file_name.split('.')[0] + '_lagrange_chebyshev_' + f'_n{number_of_nodes}.png'
            plot_lagrange_interpolation(original_values, number_of_nodes, 'chebyshev', file_name)
            plt.savefig("out/" + new_file_name)
            plt.close()

            new_file_name = file_name.split('.')[0] + '_spline_' + f'_n{number_of_nodes}.png'
            plot_spline_interpolation(original_values, number_of_nodes, file_name)
            plt.savefig("out/" + new_file_name)
            plt.close()
            print(f"File {file_name} with {number_of_nodes} nodes has been saved")
