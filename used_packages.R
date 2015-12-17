# script R
# 2015.12.02
# to install all required packages

install.packages("cluster")
install.packages("igraph")
install.packages("vegan")
install.packages("network")
install.packages("DLBCL")
install.packages("BoolNet") # pour la fonction saveNetwork

library(network)
library(cluster)
library(igraph)
library(vegan)
library(DLBCL) # http://rgm.ogalab.net/RGM/R_rdfile?f=BioNet/man/saveNetwork.Rd&d=R_BC
library(BoolNet)

# igraph to convert to leda format :
# http://www.inside-r.org/packages/cran/igraph/docs/write.graph
