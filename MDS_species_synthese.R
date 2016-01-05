# script R
# 2015.12.20
# MDS Multidimensional Scaling
# bacteria species are considered as the individuals

# libraries
library(cluster) # https://cran.r-project.org/web/packages/cluster/cluster.pdf

# MDS on the bacteria phylum abundance in the pots

# data importation
species.abundance <- read.table("species_abundance.txt", header=TRUE, sep="\t", dec=".")
head(species.abundance)
dim(species.abundance)

# to remove Unknown and Unclassified bacteria species
species.abundance <- species.abundance[1:875]

# to remove id_sequencage
t.species.abundance <- t(species.abundance[2:875]) 

# dissimilarities matrix avec daisy
m.species.abundance <- daisy(t.species.abundance)
m.species.abundance <- as.matrix(m.species.abundance)

# check
dim(m.species.abundance)
summary(m.species.abundance)

# MDS avec cmdscale
mds1 <- cmdscale(m.species.abundance, eig = TRUE, k = 2) # https://stat.ethz.ch/R-manual/R-devel/library/stats/html/cmdscale.html
x <- mds1$points[, 1]
y <- mds1$points[, 2]

# draw basic plot
plot(x, y, xlab = "", ylab = "")

# draw plot with bacteria species names
plot(x, y, xlab = "", ylab = "", type="n")
text(x, y, labels = row.names(m.species.abundance), cex=.7) 

df.species.abundance.mds1 <- as.data.frame(mds1$point)
colnames(df.species.abundance.mds1) <- c("x", "y")

# Environmental information

# data importation
synthese <- read.table("synthese.csv", header=TRUE, sep=",", dec=".")
head(synthese)
dim(synthese)

# create categorical variables for the total biomass
synthese$size<-cut(synthese$Biomasse.totale_VS3, seq(0,1.5,0.5), right=FALSE, labels=c(1:3))
summary(synthese$size)

data <- merge(synthese, species.abundance, na.omit=TRUE)
dim(data)

# transpose (other option is to use the melt function from the reshape2 package)
# remove data[1] which is the sequencing id
t.data <- t(data[2:892]) 
dim(t.data)

# plants are healthy if weight > 1g and check 3rd Quartile

for (i in 1:dim(df.species.abundance.mds1)[1]){
	df.species.abundance.mds1$cat[i] <- 0
}

# for each plant
for (i in 1:ncol(data) ){
	# if the plant weights more than 1g (size 3)
	if (as.numeric(data$size[i]) > 2 ){
		# for each bacteria phylum
		for (j in 1:as.numeric(dim(df.species.abundance.mds1)[1]) ){
			# for each mesurement done on the plant
			for ( k in 19:ncol(data) ){
				# if the abundance of bacteria is higher than the 3 quartile
				if ( data[i,k] > as.numeric(summary(data[,19])[5]) ){
					if ( colnames(data[k]) == rownames(df.species.abundance.mds1[j,] )){
						df.species.abundance.mds1$cat[j] <- df.species.abundance.mds1$cat[j] + 1
					}
				}
			}
		}
	}
}

# plants are healthy if weight > 0.5g and check mean

for (i in 1:dim(df.phylum.abundance.mds1)[1]){
	df.phylum.abundance.mds1$cat[i] <- 0
}
# for each plant
for (i in 1:ncol(data) ){
	# if the plant weights more than 1g (size 3)
	if (as.numeric(data$size[i]) > 1 ){
		# for each bacteria phylum
		for (j in 1:as.numeric(dim(df.species.abundance.mds1)[1]) ){
			# for each mesurement done on the plant
			for ( k in 19:ncol(data) ){
				# if the abundance of bacteria is higher than the average
				if ( data[i,k] > as.numeric(summary(data[,19])[4]) ){
					if ( colnames(data[k]) == rownames(df.species.abundance.mds1[j,] )){
						df.species.abundance.mds1$cat[j] <- df.species.abundance.mds1$cat[j] + 1
					}
				}
			}
		}
	}
}

library(igraph)

# create graph, and set number of vertices
g <- graph.full(nrow(m.species.abundance))
# set labels of the vertices
V(g)$label <- rownames(m.species.abundance)

# to display the distance
layout <- layout.mds(g, dist = as.matrix(m.species.abundance))
plot(g, layout = layout, vertex.size = 3)

# other possibility

# get a vector of the combination of the different vertices that have edges
for (i in 1:nrow(df.species.abundance.mds1)){
	if (df.species.abundance.mds1$cat[i] != 0){
		v[i]<-i
	}
	else{
		v[i]<-0
	}
}
setdiff(v, 0)
as.matrix(combn(setdiff(v, 0), 2))
as.vector(as.matrix(combn(setdiff(v, 0), 2)))

g <- graph( as.vector(as.matrix(combn(setdiff(v, 0), 2))), n=nrow(df.phylum.abundance.mds1), directed=FALSE )
V(g)$label <- rownames(df.species.abundance.mds1)
plot(g)

V(g)$color <- Palette

par(mai=c(0,0,1,0)) #this specifies the size of the margins. the default settings leave too much free space on all sides (if no axes are printed)
plot(g,				#the graph to be plotted
layout=layout.fruchterman.reingold,	# the layout method. see the igraph documentation for details
main='Bacteria species',	#specifies the title
vertex.size = 5,
vertex.color= V(g)$color,
vertex.label.dist=0.2, #puts the name labels slightly off the dots
vertex.frame.color='white', #the color of the border of the dots 
vertex.label.color='black', #the color of the name labels
vertex.label.font=2, #the font of the name labels
vertex.label.cex=0.5, #specifies the size of the font of the labels. can also be made to vary
vertex.label.family = "sans"
)
