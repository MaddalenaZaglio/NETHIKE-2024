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

## we simplified in visone, so this reads it back in

potter_fixed <- read.delim("hp4merged.csv", header = T, row.names = 1, sep = ";")
potter_fixed <- as.matrix(potter_fixed)

# setup for ergm

potter_fixed_net <- network(potter_fixed, directed = TRUE)

potter_attributes <- node_attribute(potter_1_4)



potter_fixed_net %v% "resistance" <- potter_attributes$resistance
potter_fixed_net %v% "gender" <- potter_attributes$gender
potter_fixed_net %v% "house" <- potter_attributes$house



