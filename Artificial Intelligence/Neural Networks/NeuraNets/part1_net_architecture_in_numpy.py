import numpy as np
from data import LinearlySeparableClasses, NonlinearlySeparableClasses
from visualization_utils import inspect_data, plot_data, x_data_from_grid, visualize_activation_function, \
    plot_two_layer_activations


def relu(logits):
    return np.maximum(logits, 0)


def sigmoid(logits):
    return np.exp(-np.logaddexp(0, -logits))


def hardlim(logits):
    return np.round(sigmoid(logits))


def linear(logits):
    return logits


def zad1_single_neuron(seed: int):
    gen = LinearlySeparableClasses()
    x, y = gen.generate_data(seed=seed)
    n_samples, n_features = x.shape

    # inspect_data(x, y)
    # plot_data(x, y, plot_xy_range=[-1, 2])

    class SingleNeuron:
        def __init__(self, n_in, f_act):
            self.W = 0.01 * np.random.randn(n_in, 1)  # size W: [n_in, 1]
            self.b = 0.01 * np.random.randn(1)  # size b: [1]
            self.f_act = f_act

        def forward(self, x_data: np.array) -> np.array:
            logits = x_data @ self.W + self.b
            return self.f_act(logits)

    #  neuron model initialized with random weights
    model = SingleNeuron(n_in=n_features, f_act=hardlim)
    model.W[:, 0] = [-1, -1]
    model.b[:] = [0.45]

    y_pred = model.forward(x)
    print(f'Accuracy = {np.mean(y == y_pred) * 100}%')

    x_grid = x_data_from_grid(min_xy=-1, max_xy=2, grid_size=1000)
    y_pred_grid = model.forward(x_grid)
    plot_data(x, y, plot_xy_range=[-1, 2], x_grid=x_grid, y_grid=y_pred_grid, title='Linia decyzyjna neuronu')


def zad2_two_layer_net(seed: int):
    gen = NonlinearlySeparableClasses()
    x, y = gen.generate_data(seed=seed)
    n_samples, n_features = x.shape

    inspect_data(x, y)
    plot_data(x, y, plot_xy_range=[-1, 2])

    class DenseLayer:
        def __init__(self, n_in, n_out, f_act):
            self.W = 0.01 * np.random.randn(n_in, n_out)
            self.b = 0.01 * np.random.randn(n_out)
            self.f_act = f_act

        def forward(self, x_data: np.array) -> np.array:
            logits = x_data @ self.W + self.b
            return self.f_act(logits)

    class SimpleTwoLayerNetwork:
        def __init__(self, n_in, n_hidden, n_out):
            self.hidden_layer = DenseLayer(n_in, n_hidden, relu)
            self.output_layer = DenseLayer(n_hidden, n_out, hardlim)

        def forward(self, x_data):
            h_data = self.hidden_layer.forward(x_data)
            return self.output_layer.forward(h_data)

    model = SimpleTwoLayerNetwork(n_in=n_features, n_hidden=2, n_out=1)

    model.hidden_layer.W[:, 0] = [-1.0, 0.9]  # wagi neuronu h1
    model.hidden_layer.W[:, 1] = [2.0,  -0.5]  # wagi neuronu h2
    model.hidden_layer.b[:] = [0.0, -1]  # biasy neuronów h1 i h2
    model.output_layer.W[:, 0] = [2, 1.33]  # wagi neuronu wyjściowego
    model.output_layer.b[:] = [-1.0]  # bias neuronu wyjściowego

    y_pred = model.forward(x)
    print(f'Accuracy = {np.mean(y == y_pred) * 100}%')

    plot_two_layer_activations(model, x, y)


if __name__ == '__main__':
    visualize_activation_function(relu)

    student_id = 193415

    zad1_single_neuron(student_id)
    zad2_two_layer_net(student_id)
