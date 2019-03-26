sink("GerberGreenLarimer_APSR_2008_r_output.txt")
####loading data####
social<-read.csv(file="GerberGreenLarimer_APSR_2008_social_pressure.csv",head=TRUE,sep=",")

####Table 1####
#list() can't convert from data frame, so make hh_id array#
hh_id<-social$hh_id;

#aggregate data for same hh_id, need to do mean and max separately#
agg_social_mean<-aggregate.data.frame(social,by=list(hh_id),FUN=mean);
agg_social_max<-aggregate.data.frame(social,by=list(hh_id),FUN=max);

#make a new dataframe of maxes and means#
socialagg<-data.frame(treatment=agg_social_max$treatment,hh_size=agg_social_max$hh_size,g2002=agg_social_mean$g2002,g2000=agg_social_mean$g2000,
	p2004=agg_social_mean$p2004,p2002=agg_social_mean$p2002,p2000=agg_social_mean$p2000,sex=agg_social_mean$sex,yob=agg_social_mean$yob);

#summary statistics for Table 1#
print(by(socialagg,socialagg$treatment,FUN=summary))

####MNL reported on p.37 of APSR article####
#rescale year of birth since R has convergence issues for continuous data#
socialagg$yob=(socialagg$yob-min(socialagg$yob))/(max(socialagg$yob)-min(socialagg$yob))
library(nnet);
mlogit<-multinom(treatment~hh_size+g2002+g2000+p2004+p2002+p2000+sex+yob,data=socialagg);
print(summary(mlogit))
library(lmtest);
print(lrtest(mlogit))
rm(list=ls())

####Table 2####
social<-read.csv(file="GerberGreenLarimer_APSR_2008_social_pressure.csv",head=TRUE,sep=",")
as.factor(social$treatment)
table2<-table(social$voted,social$treatment);
print(table2)
round(prop.table(table2,2)*100,1)

####Table 3####
#generate "dummy variables" for treatment type#
treatmentmatrix<-model.matrix(~factor(social$treatment)-1);
hawthorne<-treatmentmatrix[,2];
civicduty<-treatmentmatrix[,3];
neighbors<-treatmentmatrix[,4];
self<-treatmentmatrix[,5];

####Table 3, model a####
#linear regression where voter turnout is regressed on 4 treatments.#
library(Design);

#least squares regression, with clustered standard errors, need to keep residuals (x=T)#
regress_a<-ols(formula=voted~hawthorne+civicduty+neighbors+self,data=social,method="qr",x=T);
cluster_std_regress_a<-robcov(regress_a,social$hh_id,method=c('efron'));
print(cluster_std_regress_a)

####Table 3, model b####
#perform "within" transform for fixed effects#
hawthorne<-hawthorne-ave(hawthorne,social$cluster)+mean(hawthorne);
civicduty<-civicduty-ave(civicduty,social$cluster)+mean(civicduty);
neighbors<-neighbors-ave(neighbors,social$cluster)+mean(neighbors);
self<-self-ave(self,social$cluster)+mean(self);
voted<-social$voted-ave(social$voted,social$cluster)+mean(social$voted);
regress_b<-ols(formula=voted~hawthorne+civicduty+neighbors+self,method="qr",x=T);

#rescale standard errors to account for different degrees of freedom#
numobs<-length(hawthorne);
parameters<-(length(regress_b$var))^.5;
numfixedeffects<-length(levels(factor(social$cluster)))-1;
regress_b$var<-regress_b$var*((numobs-parameters)/(numobs-parameters-numfixedeffects))^.5;

#robust clustered errors#
cluster_std_regress_b<-robcov(regress_b,social$hh_id,method=c('efron'));
print(cluster_std_regress_b)

####Table 3, model c####
#includes fixed effects and controls for voting in five recent elections#
g2002<-social$g2002-ave(social$g2002,social$cluster)+mean(social$cluster);
g2000<-social$g2000-ave(social$g2000,social$cluster)+mean(social$cluster);
p2004<-social$p2004-ave(social$p2004,social$cluster)+mean(social$cluster);
p2002<-social$p2002-ave(social$p2002,social$cluster)+mean(social$cluster);
p2000<-social$p2000-ave(social$p2000,social$cluster)+mean(social$cluster);
regress_c<-ols(formula=voted~hawthorne+civicduty+neighbors+self+g2002+g2000+p2004+p2002+p2000,method="qr",x=T);
parameters<-(length(regress_c$var))^.5;
regress_c$var<-regress_c$var*((numobs-parameters)/(numobs-parameters-numfixedeffects))^.5;

#robust clustered errors with degrees of freedom adjustment#
cluster_std_regress_c<-robcov(regress_c,social$hh_id,method=c('efron'));
print(cluster_std_regress_c)

sink()