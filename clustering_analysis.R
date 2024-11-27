getwd()

# Load the necessary packages
install.packages("ggpubr") 
install.packages("factoextra")

library(ggpubr)
library(factoextra) 

# Load the dataset
data <- read.csv("CustomerProfileData.csv")


# Explore the dataset
str(data)
summary(data)

# Structure the data into a dataframe (excluding CustomerNo)
df <- data[, -1]  # Removing the 'CustomerNo' column

# Set the seed for reproducibility
set.seed(123)


# Apply K-means clustering with 4 clusters (updated from 5 to 4)
res.km <- kmeans(scale(df), centers = 4, nstart = 25)

# View cluster assignments
res.km$cluster


# Add cluster information to the original data
data$Cluster <- res.km$cluster

# Summary of each cluster
aggregate(df, by = list(Cluster = res.km$cluster), FUN = mean)

# Visualize the clusters using ggplot and factoextra
fviz_cluster(res.km, data = df, palette = c("#2E9FDF", "#00AFBB", "purple","red"),
             geom = "point", ellipse.type = "convex", ggtheme = theme_bw())

# Export the clustered data to a CSV file for further analysis in Excel
write.csv(data, "ClusteredData.csv", row.names = FALSE)
