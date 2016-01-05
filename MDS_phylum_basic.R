# script R
# 2015.12.1
# MDS Multidimensional Scaling
# bacteria phylum are considered as the individuals

# data importation
phylum.abundance <- read.table("phylum_abundance.txt", header=TRUE, sep="\t", dec=".")
head(phylum.abundance)
dim(phylum.abundance)

# overview
par(mar = c(9,4,4,2) + 0.1)
barplot(	as.vector(colMeans(phylum.abundance[,2:30])), 
			names.arg = colnames(phylum.abundance[,2:30]), 
			las=2, cex.names=0.7, 
			ylim=c(0,30000), 
			col = Palette, beside = TRUE, 
			main="Proportion of bacteria classified by phylum", width=1)

# to remove Unknown and Unclassified bacteria phylum
phylum.abundance <- phylum.abundance[1:30]

# libraries
library(cluster) # https://cran.r-project.org/web/packages/cluster/cluster.pdf

# transpose (other option is to use the melt function from the reshape2 package)
# remove data[1] which is the sequencing id
t.phylum.abundance <- t(phylum.abundance[2:30]) 

# calculs des dissimilaritées avec daisy
m <- daisy(t.phylum.abundance)
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
	xlim = c(-700000, 300000), ylim = c(-5000, 14000), # axes limits
	cex.axis = 0.5,
	#xaxt = "n", yaxt = "n", # no graduation on axes
	)
text(x, y, labels = row.names(m), cex=.8, pos = 3, col = Palette) 


# draw plot with phylum names
plot(x, y, xlab = "", ylab = "", type="n")
text(x, y, labels = row.names(m), cex=.7) 

df.data.mds1 <- as.data.frame(mds1$point)
colnames(df.data.mds1) <- c("x", "y")

# use igraph
# install.packages("igraph")
library(igraph)

# no mds, just a random graph
plot.igraph(g,vertex.size=3,layout=layout.lgl)

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
	#vertex.label=NA
	vertex.label.color='black', #the color of the name labels
	vertex.label.font=2, #the font of the name labels
	vertex.label.cex=0.7, #specifies the size of the font of the labels. can also be made to vary
	vertex.label.family = "sans"
)

# to save graph as leda format
write.graph(g, "tmp/MDS_phylum_basic.gw", format="leda", edge.attr=NULL, vertex.attr="label")

# to save graph as gml format
write.graph(g, "tmp/MDS_phylum_basic.gml", format="gml", id=V(g)$label)

# command bash to compare graphs using natalie
# ~/bioanalyse/tmp$ natalie -g1 MDS_phylum_basic.gw -if1 5 -g2 MDS_phylum_basic.gw -if2 5 -of 4

# export graph with saveNetwork from BoolNet package
# http://rgm.ogalab.net/RGM/R_rdfile?f=BioNet/man/saveNetwork.Rd&d=R_BC
# http://www.inside-r.org/packages/cran/BoolNet/docs/saveNetwork
# https://github.com/cytoscape/r-cytoscape.js/blob/master/README.md
