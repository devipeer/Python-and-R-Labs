import multiprocessing as mp
import numpy as np
import time
from functools import partial

def root(number, order):
    return number ** (1.0 / (order + 2))

def multiprocess(x, results, iterations, pool):
    with pool:
        res = pool.starmap(root, ((x, i) for i in range(iterations)))
    results[:] = res

def task(job_id: int, lock: mp.Lock):
    lock.acquire()
    try:
        print("Job id: %d" % job_id)
    finally:
        lock.release()

if __name__ == "__main__":
    # Task 5
    size = int(1e6)
    np.random.seed(222)
    x = np.random.uniform(1, 100)
    roots = np.empty(size)
    start = time.time()
    for i in range(size):
        roots[i] = root(x, i)
    end = time.time()
    print('Task 5 time = ', end - start)

    # Task 6
    pool = mp.Pool(mp.cpu_count())
    roots2 = np.empty(size)

    start1 = time.time()
    roots2 = multiprocess(x, roots2, size, pool)
    end1 = time.time()
    print('Task 6 time = ', end1 - start1)

    # Task 8
    lock = mp.Lock()
    processes = [mp.Process(target=task, args=(job, lock)) for job in range(10)]
    for process in processes:
        process.start()
    for process in processes:
        process.join()





