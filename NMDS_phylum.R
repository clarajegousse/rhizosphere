# NMDS tutorial with R
# http://jonlefcheck.net/2012/10/24/nmds-tutorial-in-r/

# data importation
data <- read.table("../data/phylum_abundance.txt", header=TRUE, sep="\t", dec=".")
head(data)
dim(data)

#install.packages("vegan") # https://cran.r-project.org/web/packages/vegan/index.html
library(vegan)

# remove put ids (they are considered as a value comparable to bacteria abundance)
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
