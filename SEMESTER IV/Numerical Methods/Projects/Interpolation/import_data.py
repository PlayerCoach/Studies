import pandas as pd
import os
from MathStructures import Point


def import_data(file_name: str) -> list[Point]:
    extension = os.path.splitext(file_name)[1]
    if extension == ".csv":
        data = pd.read_csv("in/" + file_name)
        x = data["Dystans (m)"]
        y = data["Wysokość (m)"]
        x = x.tolist()
        y = y.tolist()
        return [Point(x[i], y[i]) for i in range(len(x))]
    elif extension == ".txt":
        data = pd.read_csv("in/" + file_name, header=None, sep=" ", names=["Dystans (m)", "Wysokość (m)"])
        x = data["Dystans (m)"]
        y = data["Wysokość (m)"]
        x = x.tolist()
        y = y.tolist()
        return [Point(x[i], y[i]) for i in range(len(x))]
    else:
        raise ValueError("Wrong file extension")

