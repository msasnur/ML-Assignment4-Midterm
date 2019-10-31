#Machine Learning - Midterm Assignment#
#Email: msasnur@kent.edu#
#Date:31/10/2019#

library(readr)
library(ISLR)
library(tidyverse)
library(factoextra)
univ<-read_csv("Universities.csv")

#Question 1
#Removing all records with missing measurements from the dataset
univ1<-na.omit(univ)
View(univ1)

#Question 2
# Scaling the data frame (z-score)
uni<-univ1[,c(-1,-2,-3)]
uni<-scale(uni)
distance <- get_dist(uni)
fviz_dist(distance)

# To find the best K value using Elbow Method and Silhouette Method
fviz_nbclust(uni,kmeans,method = "wss")
fviz_nbclust(uni,kmeans,method = "silhouette")

# From above two methods we have found out that the Best K value for cluster analysis is 3.

# To run kmeans clustering analysis 
k3<- kmeans(uni, centers = 3, nstart = 25)
k3$centers #summary of cluster analysis
k3$size #Size of each cluster
k3$cluster[99] # To see which Cluster does 99th record belong to 
fviz_cluster(k3, data = uni) #Drawing cluster graph

#Question 3
# As seen above from summary of k3$centers, we can observe the values for three different clusters.

# In cluster 3,
# Columns (Application Rejected, 
#            Application Accepted, 
#            New Student Enrolled, 
#            Full Time underGrad, 
#            Part Time underGrad, 
#            Additional fees, 
#            book costs, 
#            estimated personal expenses, 
#            student to faculty ratio) 
#            have higher values and we can discern this pattern in cluster 3.

#In cluster 2,
# Columns (New student from 10%,
#          New student from top 25%, 
#          in-state tution, 
#          out-of-station tution, 
#          Room, 
#          Board,
#          Percentage of faculty with PhD,
#          Graduation Rate)
#          have higher values and we can discern that in Cluster 2. 

#In cluster 1,
# Columns (Application Rejected, 
#            Application Accepted, 
#            New Student Enrolled,
#            New student from 10%,
#            New student from top 25%,
#            Full Time underGrad,
#            Part Time underGrad,
#            in-state tution,
#            out-of-station tution,
#            Room,
#            Board,)
#            have lower values and we can discern that in Cluster 1.

#Question 4
cat<-cbind(univ1[,c(1,2,3)],k3$cluster)
head(cat)
cat<-as.data.frame(cat)
cat$`Public (1)/ Private (2)`<-factor(univ1$`Public (1)/ Private (2)`, levels=c("1","2"), labels = c("Public","Private"))
Cluster1 <- cat[cat$`k3$cluster` == 1,]
View(Cluster1)
Cluster2 <- cat[cat$`k3$cluster` == 2,]
View(Cluster2)
Cluster3 <- cat[cat$`k3$cluster` == 3,]
View(Cluster3)

#After binding the categorical columns with clusters, we observe that
# Cluster 1 has data of both Public and Private Universities
# Cluster 2 has data belonging to Private universities
# Cluster 3 has data belonging to Public Universities mostly

# Using Pivot table we can get detailed information on number of universities belonging to each cluster, 
# represented according to states. Separated by Public and Private Universities.
# We can also see the total number of Public and Private universities in each state. 
library(pivottabler)
pt<-PivotTable$new()
pt$addData(cat)
pt$addColumnDataGroups('Public (1)/ Private (2)')
pt$addColumnDataGroups('k3$cluster')
pt$addRowDataGroups('State')
pt$defineCalculation(calculationName= 'Total', summariseExpression = 'n()')
pt$renderPivot()

#Question 5
# Using cluster.stats() function, we can get statastics of the all the clusters.
# This Statistics include Number of Cluster, Cluster Size, Diameter of each cluster, distance, Separation.
library(fpc)
cluster.stats(distance,k3$cluster)
 

#Question 6
# Replacing the NA value
univ$`# PT undergrad`[is.na(univ$'# PT undergrad')] <- mean(univ$'# PT undergrad',na.rm = TRUE)
tuftuni<-univ[476,] 
summary(univ$`# PT undergrad`)
x<- rbind(univ1,tuftuni) #Binding the Tuft University record to our Dataset without NA values
y<- scale(x[,c(-1,-2,-3)]) #Normalizing the dataset
k.tuft<-kmeans(y,centers = 3,nstart = 25) #Performing Cluster Analysis on Dataset
k.tuft$cluster 
k.tuft$centers
which(grepl("Tufts University",x$`College Name`)) #To find the index of Tuft University record
k.tuft$cluster[472] #To find cluster value in which Tuft University belongs to, using the index value

# From above results, we can see that Tufts University belongs to Cluster 3 and its indexed at 472nd record. 