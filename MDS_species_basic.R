# script R
# 2015.12.17
# MDS Multidimensional Scaling
# bacteria species are considered as the individuals

# data importation
data <- read.table("species_abundance.txt", header=TRUE, sep="\t", dec=".")
head(data)
dim(data)

# libraries
library(cluster) # https://cran.r-project.org/web/packages/cluster/cluster.pdf

# transpose (other option is to use the melt function from the reshape2 package)
t.data <- t(data[2:875]) # remove data[1] which is the sequencing id

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

# plot with colors and names
par(pty="s") # to have a square layout
plot(x, y, 
	type = "p", # type of points
	pch = 16,
	col = Palette,
	xlab = "", ylab = "", # axes labels	
	# xlim = c(-100, 100), ylim = c(-100, 100), # axes limits
	cex.axis = 0.5,
	#xaxt = "n", yaxt = "n", # no graduation on axes
	)
text(x, y, labels = row.names(m), cex=.8, pos = 3, col = Palette) 

# draw plot with species names
plot(x, y, xlab = "", ylab = "", type="n")
text(x, y, labels = row.names(m), cex=.7) 

# use igraph
# install.packages("igraph")
library(igraph)

# draw a graph with igraph package
plot(x, y, pch = 19, xlim = range(x) + c(0, 600))
text(x, y, pos = 4, labels = row.names(m))

g <- graph.full(nrow(m))
V(g)$label <- row.names(m)
V(g)$color <- Palette

get.vertex.attribute(g)
get.edge.attribute(g)
set_vertex_attr(g, "label", index = V(g), V(g)$label)

par(mai=c(0,0,1,0)) #this specifies the size of the margins. the default settings leave too much free space on all sides (if no axes are printed)
plot(g,				#the graph to be plotted
	#main='',	#specifies the title
	layout=layout.mds(g, dist = as.matrix(m)),
	vertex.size = 5,
	vertex.color= V(g)$color,
	vertex.label.dist=0.2, #puts the name labels slightly off the dots
	vertex.frame.color='white', #the color of the border of the dots 
	vertex.label=NA
	#vertex.label.color='black', #the color of the name labels
	#vertex.label.font=2, #the font of the name labels
	#vertex.label.cex=0.7, #specifies the size of the font of the labels. can also be made to vary
	#vertex.label.family = "sans"
)

# to save graph as leda format
write.graph(g, "tmp/MDS_species_basic.gw", format="leda", edge.attr=NULL, vertex.attr="label")

# export graph with saveNetwork from BoolNet package
# http://rgm.ogalab.net/RGM/R_rdfile?f=BioNet/man/saveNetwork.Rd&d=R_BC
# http://www.inside-r.org/packages/cran/BoolNet/docs/saveNetwork
# https://github.com/cytoscape/r-cytoscape.js/blob/master/README.md
