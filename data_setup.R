## setup data

library(manynet)

resistance <- read.csv("extra variables.csv", header = TRUE)

# add resistance data to potter nets and save as graphml

potter <- vector(mode = "list", length = 6)
names(potter) <- c("book1", "book2", "book3", "book4", "book5", "book6")

for(i in 1:6){
  potter[[i]] <- add_node_attribute(ison_potter[[i]], "resistance", resistance$Resistance)
  write_graphml(potter[[i]], paste0("ison_potter_", i, ".graphml"))
}

potter_1_4 <- from_ties(potter[1:4])
write_graphml(potter_1_4, "potter_1_4.graphml")

#
