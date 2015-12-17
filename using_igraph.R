# http://www.r-bloggers.com/network-visualization-in-r-with-the-igraph-package/

bacteria <- read.table("data/phylum_abundance.txt", header=TRUE, sep="\t", dec=".")
head(bacteria)
dim(bacteria)

bacteria <- bacteria[1:30]

synthese <- read.table("data/synthese.csv", header=TRUE, sep=",", dec=".")
head(synthese)
dim(synthese)

data <- merge(synthese, bacteria)
head(data)
dim(data)

data.network<-graph.data.frame(data, directed=F)

#prints the list of vertices (bacteria)
V(data.network)

#prints the list of edges (relationships)
E(data.network)

#print the number of edges per vertex (relationships per bacteria)
degree(data.network)

# plot(data.network) # impossible to read

#identify those vertices part of less than three edges
bad.vs<-V(data.network)[degree(data.network)<3]

#exclude them from the graph
data.network<-delete.vertices(data.network, bad.vs) 

V(data.network)$color<-ifelse(V(data.network)$Biomasse.totale_VS3 > 0.6, 'green', 'red') 

E(data.network)$color<-ifelse(E(data.network)$Biomasse.totale_VS3 > 0.6, 'green', 'red')

V(data.network)$size<-degree(data.network)


plot(	data.network, 
	layout = layout.fruchterman.reingold, 
	main = data.network$name,
	vertex.label = V(data.network)$name,
	vertex.size = 2,
	vertex.color= V(data.network)$color,
	vertex.frame.color= "white",
	vertex.label.color = "white",
	vertex.label.family = "sans",
	edge.width=E(data.network)$weight, 
	edge.color="black")


plot(data.network,
	layout=layout.fruchterman.reingold,
	main='Organizational network example',	
	vertex.label = V(data.network)$name)


	vertex.label.dist=0.5,			
	vertex.label.font=1,			
	#vertex.label=V(data.network)$Biomasse.totale_VS3,		
	vertex.label.cex=1			
)
vertex.label = V(G)$name,
plot(data.network,
	layout=layout.fruchterman.reingold,
	main='Organizational network example',	
	vertex.label.dist=0.5,			
	vertex.label.font=1,			
	vertex.label=V(data.network)$Biomasse.totale_VS3,		
	vertex.label.cex=1			
)
