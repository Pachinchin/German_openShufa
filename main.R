library(cluster)    # clustering algorithms
library(factoextra) # clustering visualization
library(dendextend) # dendogram library
library(dplyr)      # dataframe manupulation library

#import the data 
Data <- read.csv("german_credit_data.csv", sep=",", header=TRUE)

#Check the dimensions of the data 
dim(Data) 

#check the column names 
colnames(Data)
summary (Data)


#remove the unwanted columns,then view
credit<-Data[-1]
creditC<-credit[c(1,7,8)]
creditC



#Check misisng values then visualize 
a<-apply(is.na(creditC),2,sum)
a


#Check the corrolation coefficient 
cor(creditC)

#Explore the data
hist(creditC$Duration) 
hist(creditC$Age) 
hist(creditC$Credit.amount) 

#data using logrithm function.
creditP<-log(creditC+1)

#View again the Duration and Age
hist(creditP$Duration) 
hist(creditP$Age) 


#K-MEANS CLUSTERING
#Scaling up the data set
creditScaled<-scale(creditP)



#Method of finding the optimal number of clusters
#Silhouette
fviz_nbclust(creditScaled, kmeans, method = "silhouette")
#Elbow rule 
fviz_nbclust(creditScaled, kmeans, method = "wss")
#Gap stastics
fviz_nbclust(creditScaled, kmeans, method = "gap_stat")


#Clustering process
creditkmeans<-kmeans(creditScaled,3)
creditkmeans

#Kmeans clustering 
creditkmeans<-eclust(creditScaled, "kmeans", hc_metric="euclidean",k=3)

#Amount and Age
fviz_cluster(list(data=credit[c("Age","Credit.amount")], cluster=creditkmeans$cluster), ellipse.type="norm", geom="point",
             stand=FALSE, palette="jco", ggtheme=theme_classic())
#Amount and durtion 
fviz_cluster(list(data=credit[c("Duration","Credit.amount")], cluster=creditkmeans$cluster), ellipse.type="norm", geom="point",
             stand=FALSE, palette="jco", ggtheme=theme_classic())
#Age and duration 
fviz_cluster(list(data=credit[c("Duration","Age")], cluster=creditkmeans$cluster), ellipse.type="norm", geom="point",
             stand=FALSE, palette="jco", ggtheme=theme_classic())

# Hierarchical Cluster
#Select ten random values from credit tree

Sample <- sample_n(creditP, 10)
NewcreditScaled<-scale(Sample)


#Dendogram 
dendo <- hclust(dist(NewcreditScaled), method="ward.D2")
plot(dendo)

#viewing the clusters dendrogram
rect.hclust(dendo,k=3,border="red") 
