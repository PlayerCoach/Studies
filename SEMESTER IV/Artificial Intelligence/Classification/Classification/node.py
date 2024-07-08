import copy

import numpy as np


class Node:
    def __init__(self):
        self.left_child = None
        self.right_child = None
        self.feature_index = None
        self.feature_value = None
        self.node_prediction = None

    @staticmethod
    def find_possible_splits(data: np.ndarray) -> list:
        num_of_rows = data.shape[0]
        possible_split_points = []
        for index in range(num_of_rows - 1):
            if data[index] != data[index + 1]:
                possible_split_points.append(index)
        return possible_split_points

    @staticmethod
    def gini_best_score(y: np.ndarray, possible_splits: list) -> tuple:
        best_gain: float = -np.inf
        best_index: int = 0

        def current_gini_score() -> float:
            left_size = len(left)
            right_size = len(right)
            left_positives = np.sum(left)
            right_positives = np.sum(right)
            left_negatives = left_size - left_positives
            right_negatives = right_size - right_positives
            left_gini = 1 - (left_positives / left_size) ** 2 - (left_negatives / left_size) ** 2
            right_gini = 1 - (right_positives / right_size) ** 2 - (right_negatives / right_size) ** 2
            gini_gain = 1 - (left_size / (left_size + right_size)) * left_gini - (right_size / (left_size + right_size)) * right_gini
            return gini_gain

        for idx in possible_splits:
            left = y[:idx + 1]
            right = y[idx + 1:]
            gini = current_gini_score()
            if gini > best_gain:
                best_gain = gini
                best_index = idx

        return best_index, best_gain

    @staticmethod
    def split_data(X, y, index, val):
        left_mask = X[:, index] < val  # left_mask is a boolean array
        return (X[left_mask], y[left_mask]), (X[~left_mask], y[~left_mask])

    def find_best_split(self, X, y, feature_subset):
        best_gain: float = -np.inf
        best_split = None

        # Check if a feature subset is provided, otherwise use all features
        if feature_subset is not None:
            # another element of bootstrapping choosing a random subset of features
            features_to_consider = np.random.choice(X.shape[1], feature_subset, replace=False)
        else:
            features_to_consider = list(range(X.shape[1]))

        for d in features_to_consider:  # iterate over specified features
            order: np.ndarray = np.argsort(X[:, d])  # order is the array of indexes of the sorted array
            y_sorted: np.ndarray = y[order]
            possible_splits = self.find_possible_splits(X[order, d])  # X[order, d] is the sorted column d
            index, value = self.gini_best_score(y_sorted, possible_splits)
            if value > best_gain:
                best_gain = value
                # index +1 if two rows are equal, we want to split between them
                best_split = (d, [index, index + 1])

        if best_split is None:
            return None, None

        best_value = np.mean(X[best_split[1], best_split[0]])

        return best_split[0], best_value

    def predict(self, x):
        if self.feature_index is None:
            return self.node_prediction
        if x[self.feature_index] < self.feature_value:
            return self.left_child.predict(x)
        else:
            return self.right_child.predict(x)

    def train(self, X, y, params):

        self.node_prediction = np.mean(y)
        if X.shape[0] == 1 or self.node_prediction == 0 or self.node_prediction == 1:
            return True

        self.feature_index, self.feature_value = self.find_best_split(X, y, params["feature_subset"])
        if self.feature_index is None:
            return True

        (X_left, y_left), (X_right, y_right) = self.split_data(X, y, self.feature_index, self.feature_value)

        if X_left.shape[0] == 0 or X_right.shape[0] == 0:
            self.feature_index = None
            return True

        # max tree depth
        if params["depth"] is not None:
            params["depth"] -= 1
        if params["depth"] == 0:
            self.feature_index = None
            return True

        # create new nodes
        self.left_child, self.right_child = Node(), Node()
        self.left_child.train(X_left, y_left, copy.deepcopy(params))
        self.right_child.train(X_right, y_right, copy.deepcopy(params))
