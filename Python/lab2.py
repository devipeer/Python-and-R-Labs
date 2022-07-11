import numpy as np

def getDistanceMatrix(array):
    N, D = np.shape(array)
    distanceMatrix = np.zeros([N,N])
    for i in range(N):
        for j in range(N):
            distanceMatrix[i,j] = np.linalg.norm(array[i] - array[j])
    return distanceMatrix

def eliminateDistances(f, Q):
    result = Q.copy()
    N, D = np.shape(Q)
    randArray = np.random.rand(N,D)
    result[randArray <= f] = np.inf
    return result

def calculateFloydWarshall(Q):
    A = Q
    N, D = np.shape(Q)
    for k in range(N):
        for i in range(N):
            for j in range(N):
                if A[i,j] > A[i,k] + A[k,j]:
                    A[i,k] = A[i,k] + A[k,j]
    return A

def Task4():
    points = np.random.randint(0,100,[100,3])
    print(np.sum(points))
    f = [0.5, 0.9, 0.99]
    for i in f:
        points = getDistanceMatrix(points)
        points = eliminateDistances(i, points)
        points = calculateFloydWarshall(points)
        print(np.sum(points))


if __name__ == "__main__":
    points = np.array([[2, 1], [4, 5], [6, 8]])
    dists = getDistanceMatrix(points)
    elm = eliminateDistances(0.2, dists)
    Task4()