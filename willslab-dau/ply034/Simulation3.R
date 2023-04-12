## PLY34: Script to run model recovery simulation
## Simulation 3 in Edmunds, Milton & Wills
## Written by: C E R Edmunds
## CC-BY-SA-4.0

print("DAU: PLY34: Simulation 1")
print("Author: Charlotte E. R. Edmunds")

## Setup
## ----------------------------------------------------
rm(list=ls())

## Get packages
packages <- c("grt","foreach","doParallel","parallel")
lapply(packages, require, character.only=T)

## Add functions
source('PLY34functions.R')

## Setup parallel backend
number_cores <- detectCores(logical=T)

## Setup parameters
no_trials <- 400.0
simulation <- 3
poss_models <- c("UDX","UDY","GLC","RND")

## Get data frame
output <- get_simulation_frame(simulation)
save_simulation(output, simulation)

## Generate appropriate category structure
## Unidimensional
ud_stimuli <- get_category_structure(
    categoryStructure="UD", stim_per_category=no_trials/2
)

## Information-integration 
ii_stimuli <- get_category_structure(
    categoryStructure="II", stim_per_category=no_trials/2
)

## Run simulation --------------------------------------
cl <- makeCluster(number_cores-1)
registerDoParallel(cl)

chunks <- seq(1, nrow(output), 20)
for (j in 1:length(chunks)){
    start_i <- chunks[j]
    end_i <- chunks[j]+19
    
    if(end_i>dim(output)[1]) end_i<-dim(output)[1]
    
    recovered_models <-
        foreach(i=start_i:end_i, .combine="rbind") %dopar% {
            require("grt")
            source("PLY34functions.R")
            if (output$categoryStructure[i]=="UD"){
                stimuli <- ud_stimuli
            } else if (output$categoryStructure[i]=="II") {
                stimuli <- ii_stimuli
            } else {
                print('Category structure unsupported')
            break
            }
        
            ## Get optimum strategy
            if (output$strategyType[i]=="UD"){
                opt_fit <- glc(category ~ Xvalue, data=stimuli,
                               control=list(iter.max=1E4, eval.max=1E4))
            } else if (output$strategyType[i]=="GLC") {
                opt_fit <- glc(category ~ Xvalue + Yvalue, data=stimuli)
            } else if (output$strategyType[i]=="CJ") {
                opt_fit <- gcjc(
                    category ~ Xvalue + Yvalue, data=stimuli, config=2)
            }
            opt_coef <- coef(opt_fit)
        
            if (output$strategyType[i]=="UD"){
                stimuli["response"] <- get_ud_responses(
                    coord_vector=stimuli$Xvalue, 
                    perceptual_noise=output$perceptualNoise[i],
                    boundary=opt_coef["(Intercept)"], 
                    boundary_noise=output$boundaryNoise[i])
            } else if (output$strategyType[i]=="GLC") {
                stimuli["response"] <- get_ii_responses(
                    category_structure=stimuli[,1:4], 
                    perceptual_noise=output$perceptualNoise[i],
                    gradient=opt_coef["Xvalue"], 
                    y_intercept=opt_coef["(Intercept)"], 
                    boundary_noise=output$boundaryNoise[i])
            } else if (output$strategyType[i]=="CJ") {
                stimuli["response"] <- get_cj_responses(
                    structure=stimuli[,1:4], 
                    perceptual_noise=output$perceptualNoise[i],
                    x_intercept=as.numeric(opt_coef["Xvalue"]), 
                    y_intercept=as.numeric(opt_coef["Yvalue"]), 
                    type="CJ_TL",
                    boundary_noise=output$boundaryNoise[i])
            }
        
            stimuli["correct"] <-
                ifelse(stimuli$category==stimuli$response, 1, 0)
            
            model_fit <- apply_models(
                data=stimuli, 
                models=list(
                    'UDX'=T, 'UDY'=T, 'GLC'=T, 'CJ_BL'=F, 'CJ_TL'=F, 
                    'CJ_TR'=F, 'CJ_BR'=F,'RND_FIX'=T, 'RND_BIAS'=T),
                    Xvalue_label="Xvalue", Yvalue_label="Yvalue",
                response_label="response"
                )
        
            model_fit <- model_fit[complete.cases(model_fit),]
            
            win_model_description <- model_fit[model_fit$Rank==1,]
            win_model <- win_model_description$Model[1]
            if (win_model=="RND_FIX" | win_model=="RND_BIAS")
                win_model <- "RND"
        
            all_model <-
                aggregate(list(model_fit$wBIC), list(model_fit$Model), mean)
            colnames(all_model)<-c("Model", "wBIC")
        
            c(mean(stimuli$correct),
              as.numeric(win_model==poss_models), 
              all_model$wBIC[all_model$Model=="UDX"],
              all_model$wBIC[all_model$Model=="UDY"],
              all_model$wBIC[all_model$Model=="GLC"], 
              get_combined_wBICs(
                  all_model$wBIC_RND[all_model$Model=="RND_FIX"],
                  all_model$wBIC_RND_BIAS[all_model$Model=="RND_BIAS"]
              ))
        }
    
        output[start_i:end_i,
               c("Accuracy","UDX","UDY","GLC","RND", "wBIC_UDX",
                 "wBIC_UDY","wBIC_GLC","wBIC_RND")] <- recovered_models
    
       save_simulation(output, simulation)
    print(j)
}
stopCluster(cl)
