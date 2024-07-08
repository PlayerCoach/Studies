import numpy as np

from decision_tree import DecisionTree
from random_forest import RandomForest
from load_data import *


def main():
    np.random.seed(123)

    train_data, test_data = load_titanic()  # datas are tuples of X and y

    dt = DecisionTree({"depth": 14})
    dt.train(*train_data)
    dt.evaluate(*train_data)
    dt.evaluate(*test_data)

    rf = RandomForest({"number_of_trees": 10, "feature_subset": 2, "depth": 14})
    rf.train(*train_data)
    rf.evaluate(*train_data)
    rf.evaluate(*test_data)


if __name__ == "__main__":
    main()
