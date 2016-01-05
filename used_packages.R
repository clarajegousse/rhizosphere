# script R
# used_packages.R

# creation  2015.12.02
# update1   2015.12.17

# to install all required packages
install.packages("network")
install.packages("cluster")
install.packages("igraph")
install.packages("Matrix") # https://cran.r-project.org/web/packages/Matrix/Matrix.pdf
install.packages("vegan")
# install.packages("DLBCL")
install.packages("BoolNet") # pour la fonction saveNetwork
install.packages("BioNet") # https://www.bioconductor.org/packages/3.3/bioc/manuals/BioNet/man/BioNet.pdf
install.packages("qgraph")

# load all libraries
library(network)
library(cluster)
library(igraph)
library(Matrix)
library(vegan)
# library(DLBCL) # http://rgm.ogalab.net/RGM/R_rdfile?f=BioNet/man/saveNetwork.Rd&d=R_BC
library(BoolNet)
library(Bionet)
library(qgraph)

# igraph to convert to leda format  :
# http://www.inside-r.org/packages/cran/igraph/docs/write.graph
