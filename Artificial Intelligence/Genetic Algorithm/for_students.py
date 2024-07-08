import math
from itertools import compress
import random
import time
import matplotlib.pyplot as plt

from data import *


def sort_population(_population, _items, _knapsack_max_capacity):
    # Calculate fitness for each individual
    population_fitness = [(individual, fitness(_items, _knapsack_max_capacity, individual)) for individual in
                          _population]

    # Sort individuals by fitness in descending order
    sorted_population = sorted(population_fitness, key=lambda x: x[1], reverse=True)

    # Extract individuals from the population_with_fitness list
    new_population = [individual for individual, _ in sorted_population]

    return new_population


def print_fitness_of_population(_items, _knapsack_max_capacity, _population):
    # Calculate fitness for each individual
    population_fitness = [(individual, fitness(_items, _knapsack_max_capacity, individual)) for individual in
                          _population]

    # Sort individuals by fitness in descending order
    sorted_population = sorted(population_fitness, key=lambda x: x[1], reverse= False)

    # Print the sorted individuals
    #print("Sorted individuals by fitness:", sorted_population)

    # Print fitness of each individual in the population in a single line
    for individual, individual_fitness in sorted_population:
        print("Fitness:", individual_fitness, end=" ")
    print()  # Print a new line after printing all fitness values


def initial_population(individual_size, _population_size):
    return [[random.choice([True, False]) for _ in range(individual_size)] for _ in range(_population_size)]


def fitness(_items, _knapsack_max_capacity, individual):  # fitness is the value of the solution
    total_weight = sum(compress(_items['Weight'], individual))
    if total_weight > _knapsack_max_capacity:
        return 0
    return sum(compress(_items['Value'], individual))


def change_weak_for_elite(_items, _knapsack_max_capacity, _population, _n_selection, _elites, _n_elite):
    # Create a list of tuples containing individuals and their fitness
    population_with_fitness = [(individual, fitness(_items, _knapsack_max_capacity, individual)) for individual in _population]

    # Sort the population by fitness in ascending order
    population_with_fitness.sort(key=lambda element: element[1], reverse=False)
    # Replace the weakest individuals with elite individuals if enough elite individuals are available
    _elites.sort(key=lambda element: fitness(_items, _knapsack_max_capacity, element), reverse=True)
    for i in range(_n_elite):
        population_with_fitness[i] = (_elites[i], fitness(_items, _knapsack_max_capacity, _elites[i]))

    # Extract individuals from the population_with_fitness list
    new_population = [individual for individual, _ in population_with_fitness]

    return new_population


def mutation(_population):
    for individual in _population:
        random_int = random.randint(0, len(individual) - 1)
        individual[random_int] = not individual[random_int]


def crossover(_selected, _crossover_rate, _population_size, _n_selection):
    _offspring = []
    # Calculate the number of crossover operations to perform
    num_crossovers = _population_size // _crossover_rate

    # Perform crossover operations
    for _ in range(num_crossovers):
        # Randomly select two different individuals from _selected
        parent1, parent2 = random.sample(_selected, k=2)

        # Apply crossover operation (e.g., single-point crossover)
        crossover_point = math.floor(len(parent1) / 2)
        child1 = parent1[:crossover_point] + parent2[crossover_point:]
        child2 = parent2[:crossover_point] + parent1[crossover_point:]

        # Add the offspring to the list
        _offspring.append(child1)
        _offspring.append(child2)

    return _offspring


def selection(_items, _knapsack_max_capacity, _population, _n_selection):
    _selected = []
    total_fitness = 0

    for element in _population:
        total_fitness += fitness(_items, _knapsack_max_capacity, element)

    for element in _population:
        _selected.append((element, fitness(_items, _knapsack_max_capacity, element)/total_fitness))

    selected_individuals = random.choices(_selected, weights=[prob for _, prob in _selected], k=_n_selection)

    return [individual for individual, _ in selected_individuals]


def elitism(_population, _n_elite, _items, _knapsack_max_capacity):
    temp_population = [(individual, fitness(_items, _knapsack_max_capacity, individual)) for individual in _population]
    temp_population.sort(key=lambda element: element[1], reverse=True)
    _elites = []
    for _ in range(_n_elite):
        elite = temp_population.pop(0)
        _elites.append(elite[0])
    temp_population.clear()
    return _elites


def population_best(_items, _knapsack_max_capacity, _population):
    _best_individual = None
    _best_individual_fitness = -1
    for individual in _population:
        individual_fitness = fitness(_items, _knapsack_max_capacity, individual)
        if individual_fitness > _best_individual_fitness:
            _best_individual = individual
            _best_individual_fitness = individual_fitness
    return _best_individual, _best_individual_fitness


items, knapsack_max_capacity = get_big()
# print(items)
population_size = 100  # how many combinations
generation_limit = 200  # how many generations // how many iterations of the algorithm
n_selection = 20  # how many individuals are selected for the next generation
n_elite = 1  # how many of the best individuals are kept for the next generation ( without process of selection)

start_time = time.time()
best_solution = None
best_fitness = 0
population_history = []
best_history = []
elites = []
population = initial_population(len(items), population_size)  # returns 100 elements of 4 boolean combinations

for _ in range(generation_limit):
    #  print_fitness_of_population(items, knapsack_max_capacity, population)
    population_history.append(population[:])
    elites = elitism(population, n_elite, items, knapsack_max_capacity)
    selected = selection(items, knapsack_max_capacity, population, n_selection)
    offspring = crossover(selected, 2, population_size, n_selection)
    population.clear()
    population.extend(offspring)
    mutation(population)

    population = change_weak_for_elite(items, knapsack_max_capacity, population, n_selection, elites, n_elite)
    #  print("after")
    #  print_fitness_of_population(items, knapsack_max_capacity, population)

    best_individual, best_individual_fitness = population_best(items, knapsack_max_capacity, population)
    if best_individual_fitness >= best_fitness:
        best_solution = best_individual
        best_fitness = best_individual_fitness
    best_history.append(best_fitness)
    elites.clear()


# PRINT FUNCTIONS FOR TESTING
end_time = time.time()
total_time = end_time - start_time
print('Best solution:', list(compress(items['Name'], best_solution)))
print('Best solution value:', best_fitness)
print('Time: ', total_time)

# plot generation_limit
x = []
y = []
top_best = 10
for i, population in enumerate(population_history):
    #  print_fitness_of_population(items, knapsack_max_capacity, population)
    plotted_individuals = min(len(population), top_best)
    x.extend([i] * plotted_individuals)
    population_fitnesses = [fitness(items, knapsack_max_capacity, individual) for individual in population]
    population_fitnesses.sort(reverse=True)
    y.extend(population_fitnesses[:plotted_individuals])
    #  print(y)
plt.scatter(x, y, marker='.')
plt.plot(best_history, 'r')
plt.xlabel('Generation')
plt.ylabel('Fitness')
plt.show()
