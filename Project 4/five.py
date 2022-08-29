################################
#                              #
#   Author: Hamidreza Abooei   #
#           9733002            #
#      HW5 intro to BSP        #
#                              #
################################

import pandas as pd
import numpy as np
from sklearn.preprocessing import normalize
from sklearn.cluster import AgglomerativeClustering
from sklearn.cluster import KMeans



data_train = pd.read_csv('data_set_ALL_AML_train.csv')
data_validation = pd.read_csv('data_set_ALL_AML_independent.csv')

a = data_train[[str(i) for i in range (1,34)]]
b = data_validation[[str(i) for i in range (39,63)]]
print(a)
print(b)
c = pd.concat([a,b],axis = 1)
print(c)
c = pd.DataFrame(c).to_numpy()
c = normalize(c)
print(c)

c = c.T
clustering_Agg_single_2 = AgglomerativeClustering(n_clusters=2,linkage="single").fit(c)
print("Single linkage 2 clusters:")
print(clustering_Agg_single_2.labels_,end = "\n\n")

clustering_Agg_single_3 = AgglomerativeClustering(n_clusters=3,linkage="single").fit(c)
print("Single linkage 3 clusters:")
print(clustering_Agg_single_3.labels_,end = "\n\n")

clustering_Agg_complete_2 = AgglomerativeClustering(n_clusters=2,linkage="complete").fit(c)
print("Complete linkage 2 clusters:")
print(clustering_Agg_complete_2.labels_,end = "\n\n")

clustering_Agg_complete_3 = AgglomerativeClustering(n_clusters=3,linkage="complete").fit(c)
print("Complete linkage 3 clusters:")
print(clustering_Agg_complete_3.labels_,end = "\n\n")

clustering_Agg_average_2 = AgglomerativeClustering(n_clusters=2,linkage="average").fit(c)
print("Average linkage 2 clusters:")
print(clustering_Agg_average_2.labels_,end = "\n\n")

clustering_Agg_average_3 = AgglomerativeClustering(n_clusters=3,linkage="average").fit(c)
print("Average linkage 3 clusters:")
print(clustering_Agg_average_3.labels_,end = "\n\n")

kmeans_2 = KMeans(n_clusters=2,random_state=10).fit(c)
print("KMeans 2 clusters:")

print(kmeans_2.labels_,end = "\n")
print("KMeans 2 cluster centers:")
print(kmeans_2.cluster_centers_,end = "\n\n")

kmeans_3 = KMeans(n_clusters=3,random_state=10).fit(c)
print("KMeans 3 clusters:")
print(kmeans_3.labels_,end = "\n")
print("KMeans 3 cluster centers:")
print(kmeans_3.cluster_centers_,end = "\n\n")

