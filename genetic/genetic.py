from numpy.random import randint


def select(population, scores, size=3):
    selection = randint(len(population))
    for i in randint(0, len(population), size-1):
        if scores[i] < scores[selection]:
            selection = i
    return population[selection]

def crossover(p1, p2, p):
    pass

def mutate(bitmap, p):
    pass

def genetic(func, n_bits, n_iter, n_pop, p_cross, p_mut):
    pass