# script R
# 2015.11.25
# MDS Multidimensional Scaling
# plant pots are the individuals, and all variables are used
# save synthese sheet from Data_ecophy_pour_Christophe_def_v2-1.xlsx as synthese.csv

bacteria <- read.table("data/phylum_abundance.txt", header=TRUE, sep="\t", dec=".")
head(bacteria)
dim(bacteria)

synthese <- read.table("data/synthese.csv", header=TRUE, sep=",", dec=".")
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
pdf("MDS_pots.pdf")
plot(x, y, main="MDS solution in 2 dimensions of the plant pots data")
dev.off()

# plot with the number of the pots as labels
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2", main="Metric MDS", type="n")
text(x, y, labels = row.names(data), cex=.7) 

# from the plot, we can see that we have no clusters, or specific shape :
# which suggests that there was no biaise during the collect of experimental data
