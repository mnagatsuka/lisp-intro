def quicksort(xs):
    if not xs:
        return []
    pivot, rest = xs[0], xs[1:]
    return (quicksort([x for x in rest if x < pivot])
            + [pivot]
            + quicksort([x for x in rest if x >= pivot]))


print(quicksort([3, 1, 4, 1, 5, 9, 2, 6]))
