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

# calculs des dissimilaritées avec daisy
m <- daisy(data)
m <- as.matrix(m)
# check
dim(m)
summary(m)

# MDS avec cmdscale
fit <- cmdscale(m, eig = TRUE, k = 2) # https://stat.ethz.ch/R-manual/R-devel/library/stats/html/cmdscale.html
x <- fit$points[, 1]
y <- fit$points[, 2]

# draw plot
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2", main="Metric MDS", type="n")
text(x, y, labels = row.names(data), cex=.7) 
