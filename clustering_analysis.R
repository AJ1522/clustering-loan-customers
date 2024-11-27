# Load necessary libraries
library(factoextra)
library(ggplot2)

# Load the dataset
data <- read.csv("CustomerProfileData.csv")

# Explore the dataset structure
str(data)

# Preprocess the data (removing non-numeric columns if necessary)
df <- data[, -1]  # Exclude 'CustomerNo'

# Scale the data for clustering
scaled_data <- scale(df)

# Set the seed for reproducibility
set.seed(123)

# Elbow Plot: Calculate the total within-cluster sum of squares (WCSS) for different cluster counts
wcss <- vector()
for (k in 1:10) {
  kmeans_result <- kmeans(scaled_data, centers = k, nstart = 25)
  wcss[k] <- kmeans_result$tot.withinss
}

# Create the Elbow Plot
elbow_plot <- data.frame(Clusters = 1:10, WCSS = wcss)

ggplot(elbow_plot, aes(x = Clusters, y = WCSS)) +
  geom_line(color = "blue", size = 1.2) +
  geom_point(color = "red", size = 3) +
  ggtitle("Elbow Method for Optimal Clusters") +
  xlab("Number of Clusters") +
  ylab("WCSS (Within-Cluster Sum of Squares)") +
  theme_minimal()

# Apply K-means clustering with the chosen number of clusters (e.g., 4 clusters)
res.km <- kmeans(scaled_data, centers = 4, nstart = 25)

# View cluster assignments
print(res.km$cluster)

# Add cluster information to the original data
data$Cluster <- res.km$cluster

# Summary of each cluster
cluster_summary <- aggregate(df, by = list(Cluster = res.km$cluster), FUN = mean)
print(cluster_summary)

# Visualize the clusters using factoextra
fviz_cluster(res.km, data = df, palette = c("#2E9FDF", "#00AFBB", "purple", "red"),
             geom = "point", ellipse.type = "convex", ggtheme = theme_bw())

# Export the clustered data to a CSV file
write.csv(data, "ClusteredData1.csv", row.names = FALSE)

# Save the Elbow Plot and Cluster Plot as images
ggsave("Elbow_Plot.png")
ggsave("Cluster_Plot1.png")
