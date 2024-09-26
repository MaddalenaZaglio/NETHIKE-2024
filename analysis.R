library(manynet)
library(sna)
library(network)
library(ergm)
library(stargazer)

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


model <- netlogit(potter_fixed, resistance_homophily, rep = 500, nullhyp="qapspp")
summary(model)


# run ergm

model0 <- ergm(potter_fixed_net ~ edges)
summary(model0)

model1 <- ergm(potter_fixed_net ~ edges + mutual + nodematch("resistance"))
summary(model1)
plot(gof(model1))

model2 <- ergm(potter_fixed_net ~ edges + mutual + nodematch("resistance") + nodefactor("resistance"))
summary(model1a)
plot(gof(model1))

model3 <- ergm(potter_fixed_net ~ edges + mutual + nodematch("resistance") + nodefactor("resistance") + nodefactor("house"))
summary(model3)
plot(gof(model3))

model4 <- ergm(potter_fixed_net ~ edges + mutual + nodematch("resistance") + nodefactor("resistance") + nodefactor("house") + gwesp(decay=0.2,fixed=TRUE))
summary(model4)
plot(gof(model4))

save.image("analysis.RData")

stargazer(model0, model1, model2, model3, model4, title = "Model Comparison", out = "model_comparison.txt")


results <- cbind(model0$coef, model1$coef, model2$coef, model3$coef, model4$coef)

