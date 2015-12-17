# script R
# 2015.12.1
# MDS Multidimensional Scaling
# bacteria phylum are considered as the individuals

# data importation
data <- read.table("data/phylum_abundance.txt", header=TRUE, sep="\t", dec=".")
head(data)
dim(data)

# libraries
library(cluster) # https://cran.r-project.org/web/packages/cluster/cluster.pdf

# transpose (other option is to use the melt function from the reshape2 package)
t.data <- t(data[2:32]) # remove data[1] which is the sequencing id

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

# use igraph
# install.packages("igraph")
library(igraph)

# draw a graph with igraph package
# x <- 0 - x
# y <- 0 - y
plot(x, y, pch = 19, xlim = range(x) + c(0, 600))
text(x, y, pos = 4, labels = row.names(m))

g <- graph.full(nrow(m))
V(g)$label <- row.names(m)
layout <- layout.mds(g, dist = as.matrix(m))
plot(g, layout = layout, vertex.size = 3)

get.vertex.attribute(g)
get.edge.attribute(g)
#set_vertex_attr(g, "label", index = V(g), V(g)$label)
# to save graph as leda format
write.graph(g, "tmp/MDS_phylum_basic.gw", format="leda", edge.attr=NULL, vertex.attr=V(g)$label)

# export graph with saveNetwork from BoolNet package
# http://rgm.ogalab.net/RGM/R_rdfile?f=BioNet/man/saveNetwork.Rd&d=R_BC
# http://www.inside-r.org/packages/cran/BoolNet/docs/saveNetwork
