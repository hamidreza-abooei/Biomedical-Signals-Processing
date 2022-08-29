from matplotlib.pyplot import axis
from sklearn.cluster import AgglomerativeClustering
from sklearn.cluster import KMeans
import numpy as np

X = np.array([[1, 2, 3, 4], [1, 4, 5, 6], [1, 0, 7, 2], [4, 2 , 5, 8], [4, 4,8 ,3], [4, 0, 6, 4]])

# c = AgglomerativeClustering(linkage='single',n_clusters=3).fit(X)

# print(c.labels_)

kmeans = KMeans(n_clusters=2,random_state=0).fit(X)

print(kmeans.labels_)
print(kmeans.cluster_centers_)

