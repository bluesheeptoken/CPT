def rindex(element, l):
    for i in range(len(l)-1, -1, -1):
        if l[i] == element:
            return i


def sum_dictionnaries(x, y):
    return {k: x.get(k, 0) + y.get(k, 0) for k in set(x) | set(y)}
