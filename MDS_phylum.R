# script R
# 2015.12.1
# MDS Multidimensional Scaling
# bacteria phylum are considered as the individuals

# data importation
data <- read.table("../data/phylum_abundance.txt", header=TRUE, sep="\t", dec=".")
head(data)
dim(data)

# libraries
library(cluster) # https://cran.r-project.org/web/packages/cluster/cluster.pdf

# transpose
t.data <- t(data[2:32]) # remove data[1] which is the sequencing id

# check
dim(t.data)
head(t.data)

# calculs des dissimilaritées avec daisy
m <- daisy(t.data)
m <- as.matrix(m)

# check
dim(m)
summary(m)

# MDS avec cmdscale
mds1 <- cmdscale(m, eig = TRUE, k = 2) # https://stat.ethz.ch/R-manual/R-devel/library/stats/html/cmdscale.html
x <- mds1$points[, 1]
y <- mds1$points[, 2]

# draw basic plot
plot(x, y, xlab = "", ylab = "")

# draw plot with phylum names
plot(x, y, xlab = "", ylab = "", type="n")
text(x, y, labels = row.names(m), cex=.7) 

# save plot as pdf
pdf("MDS_phylum.pdf")
plot(x, y, type="n", main="MDS solution in 2 dimensions of migroorganisms phylum of the rhizosphere")
text(x, y, labels = row.names(m), cex=.7) 
dev.off()
