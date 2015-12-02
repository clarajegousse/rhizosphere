# Vegan: an introduction to ordination
# https://cran.r-project.org/web/packages/vegan/vignettes/intro-vegan.pdf

# 1. Ordination

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

# fancy plot :D
pdf("NMDS_magic.pdf")
plot(ord, disp="sites", type="n")
ordihull(ord, data.env$cat.biomasse, col="blue")
ordiellipse(ord, data.env$cat.biomasse, col=3,lwd=2)
ordispider(ord, data.env$cat.biomasse, col="red", label = TRUE)
points(ord, disp="sites", pch=21, col="red", bg="yellow", cex=1.3)
dev.off()
