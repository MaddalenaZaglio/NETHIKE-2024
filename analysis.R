library(manynet)
library(sna)
library(network)
library(ergm)

# set seed
set.seed(123)

# convert resistance attribute to homophily matrix
homophily_matrix <- function(attribute, n) {

  attribute_yes <- attribute == "yes"

  homophily <- matrix(0, nrow = n, ncol = n)
  for (i in 1:n) {
    for (j in 1:n) {
      homophily[i, j] <- ifelse(attribute_yes[i] == attribute_yes[j], 1, 0)
    }
  }
  return(homophily)
}


resistance_homophily <- homophily_matrix(resistance$Resistance, n = length(resistance$Resistance))

# run qap


model <- netlogit(potter_fixed, resistance_homophily, rep = 100, nullhyp="qapspp")
summary(model)


# run ergm

model0 <- ergm(potter_fixed_net ~ edges)
summary(model0)


model1 <- ergm(potter_fixed_net ~ edges + mutual + nodematch("resistance") + nodematch("gender") + nodematch("house"))
summary(model1)
plot(gof(model1))

model2 <- ergm(potter_fixed_net ~ edges + mutual + nodematch("resistance") +  nodematch("house") + gwesp(decay=0.2,fixed=TRUE) + isolates)


