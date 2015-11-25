# script R
# 2015.11.25
# MDS Multidimensional Scaling
# save synthese sheet from Data_ecophy_pour_Christophe_def_v2-1.xlsx as synthese.csv

bacteria <- read.table("phylum_abundance.txt", header=TRUE, sep="\t", dec=".")
head(bacteria)
dim(bacteria)

synthese <- read.table("synthese.csv", header=TRUE, sep=",", dec=".")
head(synthese)
dim(synthese)

data <- merge(synthese, bacteria)
head(data)
dim(data)

library(cluster) # https://cran.r-project.org/web/packages/cluster/cluster.pdf

# calculs des dissimilaritées
m <- daisy(data)
m <- as.matrix(m)
dim(m)
summary(m)

fit <- cmdscale(m, eig = TRUE, k = 2)
x <- fit$points[, 1]
y <- fit$points[, 2]
plot(x, y, pch = 19, xlim = range(x) + c(0, 600))

library(igraph)

g <- graph.full(nrow(m))
layout <- layout.mds(g, dist = as.matrix(m))
plot(g, layout = layout, vertex.size = 3)
