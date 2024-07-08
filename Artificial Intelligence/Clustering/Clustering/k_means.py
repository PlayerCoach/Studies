import numpy as np


def initialize_centroids_forgy(data, k):
    centroid_indexes = np.random.choice(data.shape[0], k, replace=False)
    return data[centroid_indexes]


def initialize_centroids_kmeans_pp(data, k):
    centroid_indexes = np.random.choice(data.shape[0], 1, replace=False)
    centroids = data[centroid_indexes]

    for _ in range(k - 1):
        distances = np.sqrt(np.sum((data - centroids[:, np.newaxis]) ** 2, axis=2))
        min_distances = np.min(distances, axis=0)
        next_centroid_index = np.argmax(min_distances)
        centroids = np.vstack((centroids, data[next_centroid_index]))

    return centroids


def assign_to_cluster(data, centroids):
    assignments = np.empty(data.shape[0], dtype=int)

    for i in range(data.shape[0]):
        distances = np.sqrt(np.sum((data[i] - centroids) ** 2, axis=1))
        cluster = np.argmin(distances)
        assignments[i] = cluster
    return assignments


def update_centroids(data, assignments):
    centroids = np.zeros((len(np.unique(assignments)), data.shape[1]))
    for i, cluster in enumerate(np.unique(assignments)):
        centroids[i] = np.mean(data[assignments == cluster], axis=0)
    return centroids


def mean_intra_distance(data, assignments, centroids):
    return np.sqrt(np.sum((data - centroids[assignments, :]) ** 2))


def k_means(data, num_centroids, kmeansplusplus=False):  # data = features
    # centroids initialization
    if kmeansplusplus:
        centroids = initialize_centroids_kmeans_pp(data, num_centroids)
    else:
        centroids = initialize_centroids_forgy(data, num_centroids)

    assignments = assign_to_cluster(data, centroids)
    for i in range(100):  # max number of iteration = 100
        #  print(f"Intra distance after {i} iterations: {mean_intra_distance(data, assignments, centroids)}")
        centroids = update_centroids(data, assignments)
        new_assignments = assign_to_cluster(data, centroids)
        if np.all(new_assignments == assignments):  # stop if nothing changed
            break
        else:
            assignments = new_assignments

    return new_assignments, centroids, mean_intra_distance(data, new_assignments, centroids)
