from numpy.random import randint, rand


def select(population, scores, n=3):
    """
    Natural selection
    :param population: population
    :param scores: scores labeled on individuals
    :param n: times of selections to be performed
    :return: the selected individual
    """
    selection = randint(len(population))
    for i in randint(0, len(population), n - 1):
        if scores[i] > scores[selection]:
            selection = i
    return population[selection]


def crossover(p1, p2, p):
    """
    Chromosome crossover
    :param p1: parent 1
    :param p2: parent 2
    :param p: crossover probability
    :return: twin created after crossover
    """
    c1, c2 = p1.copy(), p2.copy()
    if rand() < p:
        point = randint(1, len(p1) - 2)
        c1 = p1[:point] + p2[point:]
        c2 = p2[:point] + p1[point:]
    return c1, c2


def mutate(bitmap, p):
    """
    Chromosome mutation
    :param bitmap: the genetic sequence
    :param p: probability of mutation
    :return: None
    """
    for i in range(len(bitmap)):
        if rand() < p:
            bitmap[i] = 1 - bitmap[i]


def genetic(func, n_bits, n_iter, n_pop, p_cross, p_mut):
    population = [randint(0, 2, n_bits).tolist() for _ in range(n_pop)]
    best = 0
    best_score = func(population[0])
    pass
