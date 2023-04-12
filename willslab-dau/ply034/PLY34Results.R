print("DAU: PLY34:")
print("Author: Charlotte E. R. Edmunds")
print("Licence: CC-BY-SA 4.0")

## Setup
## ------------------------------------------------

rm(list=ls())

## Add functions
source('PLY34functions.R')

print("Simulation 1")
## Load pre-recorded results of Simulation 1
simulation1 <- read.csv("Simulation1stored.csv", header=T)
simulation1[is.na(simulation1)]<-0

## Calculate table of means from these results
print("Table 1 (Simulation 1) - Strategy proportions")

table <- aggregate(list(simulation1$prop_UD, simulation1$prop_CJ,
                        simulation1$prop_GLC,  simulation1$prop_RND),
                   list(simulation1$categoryStructure,
                        simulation1$strategyType), mean)

colnames(table) <- c("Structure","Strategy","UD","CJ","GLC","RND")

table$Strategy <- relevel(table$Strategy, "UD")

table <- with(table, 
              table[order(Structure, Strategy),])

table[,3:6] <- round(table[,3:6],2)

print(table, include.rownames=FALSE)

print("Table 1 (Simulation 1) - wBICs")

table_wBIC <- aggregate(list(simulation1$wBIC_UD, simulation1$wBIC_CJ,
                             simulation1$wBIC_GLC,
                             simulation1$wBIC_RND),
                        list(simulation1$categoryStructure,
                             simulation1$strategyType),
                        mean)

colnames(table_wBIC) <- c("Structure","Strategy","wBIC_UD","wBIC_CJ",
                          "wBIC_GLC","wBIC_RND")

table_wBIC$Strategy <- relevel(table_wBIC$Strategy, "UD")

table_wBIC <- with(table_wBIC, 
                   table_wBIC[order(Structure, Strategy),])

table_wBIC[,3:6] <- round(table_wBIC[,3:6],2)

print(table_wBIC, include.rownames=FALSE)

## Simulation 2
## -------------------------------------------------------------
print("Simulation 2")

## Load pre-recorded results of simulation
simulation2 <- read.csv("Simulation2stored.csv", header=T)

## Calculate table of means from these results
print("Table 2 (Simulation 2) - Strategy proportions")

table <- aggregate(list(simulation2$prop_UD, simulation2$prop_CJ,
                        simulation2$prop_GLC,  simulation2$prop_RND),
                   list(simulation2$categoryStructure,
                        simulation2$strategyType), mean)

colnames(table) <- c("Structure","Strategy","UD","CJ","GLC","RND")

table$Strategy <- relevel(table$Strategy, "UD")

table <- with(table, 
              table[order(Structure, Strategy),])

table[,3:6] <- round(table[,3:6],2)

print(table, include.rownames=FALSE)

print("Table 2 (Simulation 2) - wBICs")

table_wBIC <- aggregate(list(simulation2$wBIC_UD, simulation2$wBIC_CJ,
                             simulation2$wBIC_GLC,
                             simulation2$wBIC_RND),
                        list(simulation2$categoryStructure,
                             simulation2$strategyType), mean)

colnames(table_wBIC) <-
    c("Structure","Strategy","wBIC_UD","wBIC_CJ","wBIC_GLC","wBIC_RND")

table_wBIC$Strategy <- relevel(table_wBIC$Strategy, "UD")

table_wBIC$Structure <- relevel(table_wBIC$Structure, "UD")

table_wBIC <- with(table_wBIC, 
                   table_wBIC[order(Structure, Strategy),])

table_wBIC[,3:6] <- round(table_wBIC[,3:6],2)

print(table_wBIC, include.rownames=FALSE)

## Simulation 3
## -------------------------------------------------------------
print("Simulation 3")

## Load in pre-recorded results of Simulation 3
simulation3 <- read.csv("Simulation3stored.csv", header=T)

## Remove simulations of participants using a GLC strategy
## (Recall that the purpose of this simulation is to reproduce Smith's
## results without the use of 'implicit' (GLC) strategies.

simulation3 <- simulation3[!simulation3$strategyType=="GLC",]

## Minor preprocessing 
simulation3$participant <- 1:nrow(simulation3)

data <- simulation3[,c("participant","categoryStructure",
                       "strategyType", "Accuracy","UDX","UDY", "GLC",
                       "RND")]

ud_data <- data[data$categoryStructure=="UD",]

ii_data <- data[data$categoryStructure=="II",]

## Observed UD accuracies of Smith et al. (2014)
##ud_immediate <- 0.82
##ud_deferred <- 0.84

## Pick simulated participants so as to match accuracy and DB analysis
## results of Smith et al. (2014)

ud_immediate_data <- ud_data[ud_data$participant %in% 
                             c(1455,1456,1457,1458,1459, 1461,1463,
                               1464,1465,1468,1475,1561, 557, 2632,
                               1563, 1544,1779,2126,2145,2511,2877,
                               1701),]

ud_immediate_data["Condition"] <- "UDImm"
ud_immediate_data["FeedbackType"] <- "Immediate"

ud_deferred_data <- ud_data[ud_data$participant %in% 
                            c(1567,1566,1565,1561, 1466,1462,1461,
                              1463,1464,1459,1469,1470,1477,1480,1564,
                              2632, 1544,1666,1779,2138,2367),]

ud_deferred_data["Condition"] <- "UDDef"
ud_deferred_data["FeedbackType"] <- "Deferred"

ii_immediate_data <- ii_data[ii_data$participant %in% 
                             c(462,347, 849,845,773,774,775,778,765,
                               760,759,757,744,740,734,732,731,722,
                               817,827,1400),]

ii_immediate_data["Condition"] <- "IIImm"
ii_immediate_data["FeedbackType"] <- "Immediate"

ii_deferred_data <- ii_data[ii_data$participant %in% 
                            c(730,570,78, 732,721, 227,228,347,
                              1439,1422,1413,1314,1146,1126,1044,1250,
                              949,930,1339,817,1289),]

ii_deferred_data["Condition"] <- "IIDef"
ii_deferred_data["FeedbackType"] <- "Deferred"

data <- rbind(ud_immediate_data, ud_deferred_data, ii_immediate_data,
              ii_deferred_data)

## Create summary column indicating recovered strategy 

data["recoveredStrategy"] <- NA

for (i in 1:nrow(data)){
    if (data$UDX[i]==1){
        data$recoveredStrategy[i] <- "UDX"
    } else if (data$UDY[i]==1){
        data$recoveredStrategy[i] <- "UDY"
    } else if (data$GLC[i]==1){
        data$recoveredStrategy[i] <- "GLC"
    } else {
        data$recoveredStrategy[i] <- "RND"
    }
}

output <- table(data$strategyType, data$recoveredStrategy, data$Condition)
output <- output[c(2,1),c(3,4,1,2),c(3,4,1,2)]

print("Table 3 (Simulation 3)")
print(output)

## Figure 2 (Simulation 3 results)
## ---------------------------------

## Take means of simulated participants in each condition

graph_data <- data.frame(
    "CategoryStructure" = factor(rep(1:2,each=2,times=2),
                                 labels=c("Unidimensional","Information-integration")),
    "TimePressure" = factor(rep(1:2,times=2),
                            labels=c("Immediate","Deferred")),
    "Study"=factor(rep(1:2, each=4), labels=c("Smith","Simulation")),
    "Accuracy"=c(0.82,0.84,0.77,0.64,
                 mean(ud_immediate_data$Accuracy),
                 mean(ud_deferred_data$Accuracy),
                 mean(ii_immediate_data$Accuracy),
                 mean(ii_deferred_data$Accuracy)),
    "SD"=c(NA,NA,NA,NA,sd(ud_immediate_data$Accuracy),
           sd(ud_deferred_data$Accuracy),
           sd(ii_immediate_data$Accuracy),
           sd(ii_deferred_data$Accuracy))
)

## Produce pretty plot
require("ggplot2")
plot <- ggplot() +
    geom_bar(data=graph_data[graph_data$Study=="Smith",],
             aes(y=Accuracy, x=CategoryStructure, fill = TimePressure),
             position=position_dodge(),  stat="identity",
             colour="black", width=0.75) +
    scale_fill_manual(values=c("#7F7F7F","White")) +
    geom_point(data=graph_data[graph_data$Study=="Simulation",],
               aes(y=Accuracy, x=c(0.81,1.18,1.81,2.18)),size=3,shape=15) +
    # geom_errorbar(data=graph_data[graph_data$Study=="Simulation",],
    #               aes(ymax = Accuracy + SD, ymin=Accuracy - SD,
    #                   x=c(0.81,1.18,1.81,2.18)),
    #               width=0.1, linetype="solid") +
    labs(x="Category structure",y="Accuracy") +
    coord_cartesian(ylim=c(0.5, 1)) + theme_bw(base_size = 18) +
    theme(legend.justification=c(1,1),
          legend.position=c(1,1),
          legend.direction="horizontal",
          legend.title=element_blank(),
          plot.title = element_text(family="sans", size=18),
          axis.text.x  = element_text(family="sans", size=12),
          axis.title.x = element_text(size=14),
          axis.text.y  = element_text(family="sans", size=12),
          axis.title.y = element_text(size=14),
          legend.text = element_text(size = 12),
          strip.text.x = element_text(size=14, colour="white"),
          strip.background = element_rect(colour="black", fill="black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_rect(size = 1, colour = "black"),
          legend.key = element_blank(),
          legend.background = element_rect(fill="transparent"))
print(plot)

## NHST testing
## ------------

print("ANOVA")
require(ez)

data$wid <- as.factor(1:nrow(data))
eza <- ezANOVA(data = data, dv = Accuracy, wid = wid,
               between = c('categoryStructure','strategyType') , type
               = 3)
print(eza)

print("T-test comparing both rule-based category structure conditions")

t.test(ud_immediate_data$Accuracy, ud_deferred_data$Accuracy,
       var.equal=T)

print("T-test comparing both immediate conditions")

t.test(ud_immediate_data$Accuracy, ii_immediate_data$Accuracy,
       var.equal=T)

print("T-test comparing both information-integration category structure conditions")

t.test(ii_immediate_data$Accuracy, ii_deferred_data$Accuracy,
       var.equal=T)
