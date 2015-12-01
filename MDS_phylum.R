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
#library(reshape2) # to do the transpose dataframe or matrix

# transpose
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

# NMDS tutorial with R
# http://jonlefcheck.net/2012/10/24/nmds-tutorial-in-r/

#install.packages("vegan") # https://cran.r-project.org/web/packages/vegan/index.html
library(vegan)

m <- as.matrix(data[2:32], dimnames=list(data[1], colnames(data)))

# NMDS http://cc.oulu.fi/~jarioksa/softhelp/vegan/html/metaMDS.html
nmds=metaMDS(m,k=2,trymax=100) # metaMDS has automatically applied a square root transformation and calculated the Bray-Curtis distances for our community-by-site matrix

# Shepard plot
stressplot(nmds, p.col="slategray3", l.col="steelblue4")
# shows scatter around the regression between the interpoint distances in the final configuration (i.e., the distances between each pair of pots) against their original dissimilarities.

# Large scatter around the line suggests that original dissimilarities are not well preserved in the reduced number of dimensions. Looks pretty good in this case.

# save Shepard plot 
pdf("MDS_shepard_plot_phylum.pdf")
stressplot(nmds, p.col="slategray3", l.col="steelblue4")
dev.off()

# draw basic plot
plot(nmds)

# draw plot with names
pdf("NMDS_pots_phylum.pdf")
ordiplot(nmds,type="n")
orditorp(nmds,display="sites",cex=0.5 ,air=0.01, col="slategray3")
orditorp(nmds,display="species",col="steelblue4",air=0.01, cex=1.25)
dev.off()

# Vegan: an introduction to ordination
# https://cran.r-project.org/web/packages/vegan/vignettes/intro-vegan.pdf

# 1. Ordination
data(data)

# Detrended correspondence analysis
ord <- decorana(data)
ord

#  Non-metric multidimensional scaling
ord <- metaMDS(data)
ord

# 2 Ordination graphics

# basic plot
plot(ord)

# 2.1 Cluttered plots

# sophisticated plot
plot(ord, type = "n")
points(ord, display = "sites", cex = 0.8, pch=21, col="slategray3", bg="slategray1")
text(ord, display = "spec", cex=0.7, col="steelblue4")

# 2.2 Adding items to ordination plots
data.env <- read.table("synthese.csv", header=TRUE, sep=",", dec=".")
head(data.env)
dim(data.env)

# create categorical variables for the total biomass
data.env$cat.biomasse<-cut(data.env$Biomasse.totale_VS3, seq(0,1.5,0.5), right=FALSE, labels=c(1:3))
summary(data.env$cat.biomasse)

attach(data.env)

# fancy plot :D
pdf("NMDS_magic.pdf")
plot(ord, disp="sites", type="n")
ordihull(ord, data.env$cat.biomasse, col="blue")
ordiellipse(ord, data.env$cat.biomasse, col=3,lwd=2)
ordispider(ord, data.env$cat.biomasse, col="red", label = TRUE)
points(ord, disp="sites", pch=21, col="red", bg="yellow", cex=1.3)
dev.off()
