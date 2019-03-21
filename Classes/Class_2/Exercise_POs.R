library(tidyverse)

N <- 1000
c <- 0

x <- rbinom(N,1,0.5)
y0 <- rnorm(N,5,1) + x
y1 <- y0 + c

data <- tibble(x=x,
       y0=y0,
       y1=y1)

data %>% ggplot() +
  geom_density(aes(x=y0), col="blue") +
  geom_density(aes(x=y1),col="dark green") +
  theme_classic()

data <- data %>% mutate(rnd=runif(N,0,1),
                        D=ifelse(0.5*x+rnd>0.75,1,0))
cor(data$x,data$D)

Actual_causal_effect <- data %>% 
  summarize(Actual_ATE=mean(y1-y0))

data <- data %>% mutate(y_obs=case_when(D==1~y1,
                                        D==0~y0))

data %>% lm(y_obs~D,data=.) %>% summary()

data %>% lm(y_obs~D + x,data=.) %>% summary()

data %>% ggplot() +
  geom_density(data=data %>% filter(D==0),aes(x=y_obs), col="blue") +
  geom_density(data=data %>% filter(D==1),aes(x=y_obs),col="dark green") +
  theme_classic()

# Add noise to c
# c>0
# +N doesn't help