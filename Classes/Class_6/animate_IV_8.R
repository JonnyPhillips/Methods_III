library(ggplot2)
#devtools::install_github("dgrtwo/gganimate")
library(gganimate)
library(tidyverse)

#Move X and IV by same amount, and give them different coefficients that then pass through system

#Effect Sizes - note these shouldn't be multiples so they don't cancel each other out and produces static for D, O
#To teach, set IV effect to 0 and run; then set both C effects to zero and run; then reinstate all and run
IV_effect_D <- 0.7 #0.7
C_effect_D <- 0.25 #0.25
C_effect_Y <- 0.25 #0.25
D_effect_Y <- 0.5 #0.5

Frames <- 80

oscil <- function(Start,size,cycles=1){
  steps <- Frames/(4*cycles)
  out <- c(seq(Start,Start+size,by=size/steps),seq(Start+size-size/steps,Start-size,by=-size/steps),seq(Start-size+size/steps,Start-size/steps,by=size/steps))
  out <- rep(out,cycles)
  return(out)
}

lag_one_frame <- function(input){
  out <- c(input[length(input)],input[-length(input)])
  return(out)
}

#IV
X_start_y <- 2
X_size <- 1
X_y <- oscil(X_start_y,X_size)
Time <- seq(1,length(X_y))
X_x <- rep(1,length(Time))

#Confounder
C_start_y <- 4
C_size <- 1
C_x <- rep(1.5,length(Time))
#C_y <- rep(c(seq(C_start_y,C_start_y+C_size,by=C_size/2.5),seq(C_start_y+C_size-C_size/5,C_start_y-C_size,by=-C_size/5),seq(C_start_y-C_size+C_size/5,C_start_y,by=C_size/5)),2)
C_y <- oscil(C_start_y,C_size,2)

#Treatment
D_start_y <- 2
D_x <- rep(2,length(Time))
D_y <- D_start_y + ((C_y-C_start_y)*C_effect_D) + ((X_y-X_start_y)*IV_effect_D)
D_y <- lag_one_frame(D_y)


#Outcome
O_start_y <- 2
O_x <- rep(3,length(Time))
O_y <- O_start_y + ((D_y - D_start_y)*D_effect_Y) + ((C_y - C_start_y)*C_effect_Y)
O_y <- lag_one_frame(O_y)
O_y <- lag_one_frame(O_y)

x <- c(X_x,C_x,D_x,O_x)
y <- c(X_y,C_y,D_y,O_y)

#Variables
Vars_list <- c("X","C","D","O")
Vars <- c()

for (i in Vars_list){
  Vars <- append(Vars,rep(i,length(Time)))
}

d_chart <- data.frame(Vars,Time,x,y)

if (IV_effect_D!=0){
  d_chart$xend[d_chart$Vars=="X"] <- 2
  d_chart$yend[d_chart$Vars=="X"] <- d_chart$y[d_chart$Vars=="D"]
}

if (C_effect_D!=0){
  d_chart$xend[d_chart$Vars=="C"] <- 2
  d_chart$yend[d_chart$Vars=="C"] <- d_chart$y[d_chart$Vars=="D"]
}

if (C_effect_Y!=0){
  temp <- d_chart[d_chart$Vars=="C",]
  temp$xend <- 3
  temp$yend <- d_chart$y[d_chart$Vars=="O"]
  d_chart <- rbind(d_chart,temp)
}

d_chart$xend[d_chart$Vars=="D"] <- 3
d_chart$yend[d_chart$Vars=="D"] <- d_chart$y[d_chart$Vars=="O"]

plot <- ggplot(d_chart, aes(x=x,y=y,frame=Time)) + geom_point() + geom_text(aes(y=y+0.3,label=Vars)) + theme_classic() + xlim(0.7,4) + ylim(0.5,5) + geom_segment(aes(x=x,y=y,xend=xend,yend=yend),arrow=arrow(length=unit(0.2,"cm"),ends="last",type="closed")) + theme(axis.line=element_blank(),axis.text.x=element_blank(),axis.text.y=element_blank(),axis.ticks=element_blank(),axis.title.x=element_blank(),axis.title.y=element_blank())

gganimate(plot,interval=0.03)


#### Run regressions on this
library(AER)

#Need to remove duplicated C
d_analysis <- d_chart[-c(321:400),]

d_analysis <- d_analysis %>% select(Vars,Time,y) %>% spread(key=Vars,value=y)

iv_out <- ivreg(O ~ D|X,data=d_analysis) #correct

summary(lm(D~X,data=d_analysis)) #First-stage correct

summary(lm(X~O,data=d_analysis)) #Could calculate to see if correct (might be confounded here just due to coincident cycles with confounder)

summary(lm(D~O,data=d_analysis)) #Confounded regression over-estimates compared to IV due to Confounder presence

d_analysis$D_predicted <- lm(D~X,data=d_analysis)$fitted.values


ggplot() + geom_line(data=d_analysis,aes(x=Time,y=D),col="red")+ geom_line(data=d_analysis,aes(x=Time,y=D_predicted),color="blue") + theme_classic()
