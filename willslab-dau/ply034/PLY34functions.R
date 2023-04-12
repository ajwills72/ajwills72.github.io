## List of functions for submission to Cognitive Science by Edmunds,
## Milton & Wills

## Licence: CC-BY-SA 4.0
## Attribution: C E R Edmunds, ceredmunds@gmail.com

## Tools -------------------------------------------------------------------------------------------

line_eval <- function(x_vector, gradient, y_intercept){
    ## Evaluates the equation of a straight line
    y_vector <- gradient*x_vector + y_intercept
}

point2line_distance <- function(stim_coords, gradient, y_intercept){
    ## calculates minimum distance between point and line
    ## args:
    ##   gradient: gradient of line
    ##   y_intercept: y-intercept of the line
    ##   stimulus_coordinates: a nx2 vector of stimulus coordinates
    ## output:
    ##   nx1 distances from the line, -ve above line, +ve below line
    return((gradient*stim_coords[ ,1] - stim_coords[ ,2] + y_intercept)/
           sqrt(gradient^2 + 1))
}

get_BIC <- function(neg_log_likelihood, no_data_points,
                    no_parameters){
    BIC <- 2.0*neg_log_likelihood + no_parameters*log(no_data_points)
}

save_simulation <- function(simulation_frame, simulation=1) {
    filename <- paste("Simulation",simulation,".csv",sep="")
    write.csv(simulation_frame, filename, row.names=F)
}

get_combined_wBICs <- function(vectorA, vectorB){
    
    if (length(vectorA)==0 && length(vectorB)==0) {
        return(0)
    } else if (length(vectorA)==0) {
        return(mean(vectorB))
    } else if (length(vectorB)==0){
        return(mean(vectorA))
    } else {
        return(mean(vectorA + vectorB))
    }
}

## Get output data frame
## -------------------------------------------------------

## Define category structures - as in Smith et al. (2014)

define_UD_structure <- function(){
    data.frame(meanA_x=35.86, meanA_y=50, meanB_x=64.14, meanB_y=50,
               var_x=16.33, var_y=355.55, var_xy=0, angle=0)
}

define_II_structure <- function(){
    data.frame(meanA_x=40, meanA_y=60, meanB_x=60, meanB_y=40,
               var_x=185.94, var_y=185.94, var_xy=169.61, angle=pi/4)
}

define_CJ_structure <- function(){
    data.frame(meanA_x=40, meanA_y=40, meanB_x=40, meanB_y=60,
               meanC_x=60, meanC_y=60, meanD_x=60, meanD_y=40,
               var_x=20, var_y=20, var_xy=0)
}

format_frame <- function(simulation_frame){
    simulation_frame <- with(
        simulation_frame,
        simulation_frame[order(categoryStructure, strategyType,
                               perceptualNoise),])
    return(simulation_frame) 
}

get_simulation_frame <- function(simulation = 1){
    ## Function to produce data frame that outputs the results of the
    ## simulations. Variables: simulation: 1-Simulation 1, 2-Simulation
    ## 2, 3-Simulation 3
    
    model_labels <- c("prop_UD","prop_GLC","prop_CJ", "prop_RND",
                      "wBIC_UD","wBIC_GLC","wBIC_CJ","wBIC_RND")
    
    frame <- expand.grid(strategyType = c("UD","GLC","CJ"),
                         perceptualNoise = seq(0, 25, 5),
                         boundaryNoise=seq(0, 50, 10))
    
    frame_ii <- data.frame(categoryStructure = "II", frame)
    
    if (simulation==1){
        frame_ii["no_ppts"] <- 200 #20
        frame_ii[model_labels] <- NA
        return(format_frame(frame_ii))
    }
    
    frame_ud <- data.frame(categoryStructure="UD", frame)
    
    if (simulation==2){
        frame_ud["no_ppts"] <- 200 #20
        frame_ud[model_labels] <- NA
        return(format_frame(frame_ud))
    }
    
    if (simulation==3){
        simulation_frame <-
            rbind(frame_ii[rep(seq_len(nrow(frame_ii)),each=20),],
                  frame_ud[rep(seq_len(nrow(frame_ud)),each=20),])
                
        simulation_frame <- data.frame(participant=1:20,
                                       simulation_frame)
        
        simulation_frame[c("Accuracy","UDX","UDY","GLC","RND",
                           "wBIC_UDX","wBIC_UDY","wBIC_GLC",
                           "wBIC_RND")] <- NA
        
        simulation_frame <-
            simulation_frame[simulation_frame$strategyType!="GLC",]
        
        return(format_frame(simulation_frame))
    }
} 

## Generating category structure  ------------------------------------------------------------------

get_category_structure <- function(categoryStructure,
                                   stim_per_category=200){
    
    if(categoryStructure=="II")
        return(generate_ii_coords(stim_per_category))
    
    if(categoryStructure=="UD")
        return(generate_ud_coords(stim_per_category))
    
    if(categoryStructure=="CJ")
        return(generate_cj_coords(stim_per_category))
    
    if(categoryStructure=="test")
        return(generate_test_coords(stim_per_category))
    
}

generate_ud_coords <- function(stim_per_category=200){

    ## generates 2D stimuli using normal distributions according to
    ## the category structure defined by define_UD_structure

    require(mvtnorm)
    
    structure <- data.frame(
        "stimulusNo" = 1:(2*stim_per_category),
        "Xvalue"=NA, "Yvalue"=NA,
        "category" =  factor(rep(c(0,1), each=stim_per_category),
                             labels=c("A","B"))
    )
    
    parameters <- define_UD_structure()
    
    structure[structure$category=="A", c("Xvalue","Yvalue")] <-
        rmvnorm(
            n=stim_per_category,
            mean=c(parameters$meanA_x, parameters$meanA_y),
            sigma=diag(c(parameters$var_x, parameters$var_y))
            )
    
    structure[structure$category=="B", c("Xvalue","Yvalue")] <-
        rmvnorm(
            n=stim_per_category, 
            mean=c(parameters$meanB_x, parameters$meanB_y),
            sigma=diag(c(parameters$var_x, parameters$var_y))
        )
    
    detach("package:mvtnorm", unload=TRUE)
    
    return(structure)
}

generate_ii_coords <- function(stim_per_category=200){

    ## generates 2D stimuli using normal distributions according to
    ## the category structure defined by define_UD_structure
    
    require(mvtnorm)
    
    structure <- data.frame(
        "stimulusNo"=1:(2*stim_per_category),
        "Xvalue"=NA, "Yvalue"=NA,
        "category" = factor(rep(c(0,1), each=stim_per_category), 
                            labels=c("A","B"))
        )
    
    parameters <- define_II_structure()
    
    structure[structure$category=="A", c("Xvalue","Yvalue")] <-
        rmvnorm(
            n=stim_per_category, 
            mean=c(parameters$meanA_x, parameters$meanA_y),
            sigma=matrix(c(parameters$var_x, parameters$var_xy,
                           parameters$var_xy, parameters$var_y), 2, 2)
            )
    
    structure[structure$category=="B", c("Xvalue","Yvalue")] <-
        rmvnorm(
            n=stim_per_category, 
            mean=c(parameters$meanB_x, parameters$meanB_y),
            sigma=matrix(c(parameters$var_x, parameters$var_xy,
                           parameters$var_xy, parameters$var_y), 2, 2)
        )
    
    detach("package:mvtnorm", unload=TRUE)
    
    return(structure)
}

generate_cj_coords <- function(stim_per_category){
    require(mvtnorm)
    
    structure <- data.frame(
        "stimulusNo"=1:(2*stim_per_category),
        "Xvalue"=NA, "Yvalue"=NA,
        "category"=factor(rep(c(0,1), each=stim_per_category), 
                          labels=c("A","B"))
        )
    
    parameters <- define_CJ_structure()
    
    structure[1:66, c("Xvalue","Yvalue")] <-
        rmvnorm(
            n=66, 
            mean=c(parameters$meanA_x, parameters$meanA_y),
            sigma=matrix(c(parameters$var_x, parameters$var_xy,
                           parameters$var_xy,
                           parameters$var_y), 2, 2)
        )
    
    structure[67:132, c("Xvalue","Yvalue")] <-
        rmvnorm(
            n=66,
            mean=c(parameters$meanB_x, parameters$meanB_y),
            sigma=matrix(c(parameters$var_x, parameters$var_xy,
                           parameters$var_xy,
                           parameters$var_y), 2, 2)
        )
    
    structure[133:200, c("Xvalue","Yvalue")] <-
        rmvnorm(
            n=67,
            mean=c(parameters$meanC_x, parameters$meanC_y),                   
            sigma=matrix(c(parameters$var_x, parameters$var_xy,
                           parameters$var_xy, parameters$var_y), 2, 2)
        )

    structure[structure$category=="B", c("Xvalue","Yvalue")] <-
        rmvnorm(
            n=stim_per_category, 
            mean=c(parameters$meanD_x, parameters$meanD_y),
            sigma=matrix(c(parameters$var_x, parameters$var_xy,
                           parameters$var_xy,
                           parameters$var_y), 2, 2)
        )
    
    detach("package:mvtnorm", unload=TRUE)
    return(structure)
}


## Generate simulated responses --------------------------------------------------------------------

get_random_responses <- function(bias=0.5, no_trials){
    ## generates random responses
    ## args:
    ##   bias: bias towards responding A or B, 0=all A; 1=all B
    ## returns:
    ##   vector of A-B responses equal to the length of the category input
    
    if (bias>0 && bias<1){

        responses <- factor(sample(c(0,1), size=no_trials, replace=T,
                                   prob=c(1-bias, bias)),
                            labels=c("A","B"))
        
    } else if(bias==0){
        
        responses <- factor(rep("A", no_trials))
        levels(responses)<-c(levels(responses), "B")
        
    } else if (bias==1){
        
        responses <- factor(rep("B", no_trials))
        levels(responses)<-c("A", levels(responses))
        
    }
    
    return(responses)
}

get_response_parameters <- function(simulation_frame){

    return(list(perceptual_noise=simulation_frame$perceptualNoise, 
                boundary_noise=simulation_frame$boundaryNoise, 
                exp_noise=simulation_frame$experimentalNoise))
    
}

apply_perceptual_noise <- function(vector, noise){

    return(vector + rnorm(n=length(vector), 0, noise))

}

apply_boundary <- function(vector, boundary, noise){
    
    boundary <- rnorm(n=length(vector), boundary, noise)
    return(ifelse(vector < boundary, 0, 1))

}

apply_exp_noise <- function(vector, noise){

    vector <- ifelse(sample(0:1, length(vector), replace=T,
                            c(1-noise, noise)),
                     1-vector, vector)
    return(factor(vector, labels=c("A","B")))

}

correct_responses <- function(responses, category){

    correct <- ifelse(responses==category, 1, 0)

    if (mean(correct) < 0.5){
        require(plyr)
        responses <- revalue(responses, c("A"="B", "B"="A"))
    }

    return(responses)
}

get_ud_responses <- function(coord_vector, boundary=50,
                             perceptual_noise, boundary_noise){
    
    ## generates unidimensional responses (based on dim1)
    ## args:
    ##   coord_vector: vector of either x- or y-values (depending on
    ##   the ud version)
    ##   boundary: position of boundary
    ##   perceptual_noise: perceptual noise
    ##   boundary_noise: variation in implementing boundary (norm
    ##   distributed)
    ##   exp_noise: uniformly distributed noise respresenting
    ##   participant idiocy
    ## returns:
    ##   factor of A-B responses equal to the length of the category
    ##   input
    
    ## Setup
    
    perceived_coords <- apply_perceptual_noise(coord_vector,
                                               noise=perceptual_noise)
        
    responses <- apply_boundary(perceived_coords, boundary,
                                boundary_noise)
    
    return(factor(responses, labels=c("A","B")))
    
}

get_ii_responses <- function(category_structure, gradient,
                             y_intercept, perceptual_noise,
                             boundary_noise){
    
    ## generates information-integration responses (based on dim1)
    ## args:
    ##   category_structure: data frame describing the category
    ##   structure
    ##   perceptual_noise: perceptual noise (assumes no
    ##     correlation between dim 1 and 2)
    ##   boundary: position of boundary
    ##   boundary_noise: variation in implementing boundary (norm
    ##   distributed)
    ##   exp_noise: uniformly distributed noise respresenting
    ##   participant idiocy
    ## returns:
    ##   vector of A-B responses equal to the length of the category
    ##   input
    
    distances <- point2line_distance(gradient, y_intercept,
                                     stim_coords=category_structure[
                                        ,c("Xvalue","Yvalue")])
        
    perceived_dist <- apply_perceptual_noise(distances,
                                             noise=perceptual_noise)
    
    
    responses <- factor(apply_boundary(perceived_dist, boundary=0,
                                       boundary_noise), 
                        labels=c("A","B"))
    
    return(correct_responses(responses, category_structure$category))
    
}

get_cj_responses <- function(structure, 
                         x_intercept, y_intercept, type="CJ_TL",
                         perceptual_noise, boundary_noise){
    
    ## generates conjunction responses
    ## args:
    ##   category_structure: data.frame describing the category
    ## structure
    ##   x_intercept: value of boundary on x-axis
    ##   y_intercept: value of boundary on y-axis
    ##   type: type of conjunction "CJ_TL", "CJ_TR", "CJ_BL", "CJ_BR"
    ##   T=top, B=bottom, L=left,
    ##       R=right
    ##   perceptual_noise: perceptual noise (assumes no correlation
    ##   between dim 1 and 2)
    ##   boundary_noise: variation in implementing boundary (norm
    ##   distributed)
    ##   exp_noise: uniformly distributed noise respresenting
    ##   participant idiocy
    ## returns:
    ##   vector of A-B responses equal to the length of the category
    ##   input
    
    
    perceived_coords <- cbind(apply_perceptual_noise(structure$Xvalue,
                                                     noise=perceptual_noise),
                              apply_perceptual_noise(structure$Yvalue,
                                                     noise=perceptual_noise))
    
    
    dim_responses <- cbind(apply_boundary(perceived_coords[,1],
                                          x_intercept, boundary_noise),
                           2*apply_boundary(perceived_coords[,2],
                                            y_intercept, boundary_noise))
    
    if (type=="CJ_BL"){
        
        responses <- ifelse(dim_responses[,1] + dim_responses[,2]==0,
                            0, 1)
        
    } else if (type=="CJ_TR"){
        
        responses <- ifelse(dim_responses[,1] + dim_responses[,2]==3,
                            0, 1)
        
    } else if (type=="CJ_BR"){
        
        responses <- ifelse(dim_responses[,1] + dim_responses[,2]==1,
                            0, 1)
        
    } else if (type=="CJ_TL"){
        
        responses <- ifelse(dim_responses[,1] + dim_responses[,2]==2,
                            0, 1)
        
    }
    
    return(factor(responses, labels=c("A","B")))
    
}

## Models ------------------------------------------------------------------------------------------

## Unidimensional rule
## 2 parameters to fit: parameters = c(boundary_intercept, noise)

## Set predictor to stimulus coordinates along the relevant dimension
## and
##response to the name of either the participant's response or the
##category
## label

UD_model <- function(parameters, data,
                     predictor="Xvalue",
                     response="response"){
    ## Parameters are c(boundary_intercept, noise)
    
    respA_stim_val <- data[[predictor]][data[[response]]=="A"]
    respB_stim_val <- data[[predictor]][data[[response]]=="B"]

    ## Calculate likelihoods
    if (mean(respA_stim_val) < mean(respB_stim_val)){
        likelihood <- c(pnorm(parameters[1], mean=respA_stim_val,
                              sd=parameters[2], lower.tail=T),
                        pnorm(parameters[1], mean=respB_stim_val,
                              sd=parameters[2], lower.tail=F))
    } else {
        likelihood <- c(pnorm(parameters[1], mean=respA_stim_val,
                              sd=parameters[2], lower.tail=F),
                        pnorm(parameters[1], mean=respB_stim_val,
                              sd=parameters[2], lower.tail=T))
    }
    
    ## Likelihood check - ensure greater than 0 and less than 1
    
    likelihood[likelihood<.Machine$double.eps] <- .Machine$double.eps
    
    likelihood[likelihood>(1-.Machine$double.eps)] <-
        (1-.Machine$double.eps)

    ## Negative log likelihood
    
    return(-sum(log(likelihood)))
}

## Function to run fit models

UD_fit <- function(data, predictor_label="Xvalue",
                   response_label="response"){
    min_coord <- min(data[[predictor_label]])
    max_coord <- max(data[[predictor_label]])
    start_coord <- mean(data[[predictor_label]])
    min_noise <- .Machine$double.eps
    max_noise <- .Machine$integer.max
    start_noise <- sd(data[[predictor_label]])
    nlminb(start=c(start_coord, start_noise), objective=UD_model,
           lower=c(min_coord, min_noise),
           upper=c(max_coord, max_noise), data=data,
           predictor=predictor_label, response=response_label)
}

##---------------------------------------------------------------
## General linear classifier
## 3 parameters: y_intercept, gradient, noise

GLC_model <- function(parameters, data,
                      Xvalue="Xvalue", Yvalue="Yvalue",
                      response="response"){
    
    ## Parameters are c(gradient, y_intercept, noise)
    
    ## Get distance from line
    distance <- point2line_distance(gradient=parameters[1],
                        y_intercept=parameters[2],
                        stim_coord=cbind(data[[Xvalue]],data[[Yvalue]]))
    
    respA_distance <- distance[data[[response]]=="A"]
    
    respB_distance <- distance[data[[response]]=="B"]
    
    ##  Calculate likelihoods
    likelihood <- c(
        pnorm(0, mean=respA_distance, sd=parameters[3], lower.tail=T),
        pnorm(0, mean=respB_distance, sd=parameters[3], lower.tail=F)
    )
    
    ## Likelihood check - ensure greater than 0 and less than 1
    
    likelihood[likelihood<.Machine$double.eps] <- .Machine$double.eps
    
    likelihood[likelihood>(1-.Machine$double.eps)] <-
        (1-.Machine$double.eps)
    
    ## Negative log likelihood
    
    return(-sum(log(likelihood)))
}

GLC_fit<- function(data, Xvalue_label="Xvalue", Yvalue_label="Yvalue",
                   response_label="response"){
    A_label <- levels(data[[response_label]])[1]
    B_label <- levels(data[[response_label]])[2]
    
    mean_A <-
        c(mean(data[[Xvalue_label]][data[[response_label]]==A_label]),
          mean(data[[Yvalue_label]][data[[response_label]]==A_label]))
    
    mean_B <-
        c(mean(data[[Xvalue_label]][data[[response_label]]==B_label]),
          mean(data[[Yvalue_label]][data[[response_label]]==B_label]))
    
    mid_point <- 0.5*(mean_A + mean_B)
    
    start_gradient <- (mean_B[2]-mean_A[2])/(mean_B[1]-mean_A[1])
    
    start_y <- mid_point[2]-start_gradient*mid_point[1]
    
    ## Parameters are c(gradient, y_intercept, noise)
    min_gradient <- start_gradient - 200
    max_gradient <- start_gradient + 200
    
    min_y<- start_y -
        (max(data[[Xvalue_label]])-min(data[[Xvalue_label]]))
    
    max_y <- start_y +
        (max(data[[Xvalue_label]])-min(data[[Xvalue_label]]))
    
    min_noise <- .Machine$double.eps
    max_noise <- .Machine$integer.max
    start_noise <- sd(data[[Yvalue_label]])
    
    nlminb(start=c(start_gradient, start_y, start_noise),
           objective=GLC_model, data=data, Xvalue=Xvalue_label,
           Yvalue=Yvalue_label, response=response_label,
           lower=c(min_gradient, min_y, min_noise),
           upper=c(max_gradient, max_y, max_noise))
}

## Conjunction models
## -----------------------------------------------------------
## 4 parameters: x_intercept, y_intercept, noise_X, noise_Y

CJ_BL_model <- function(parameters, data, Xvalue="Xvalue",
                        Yvalue="Yvalue", response="response"){
    ## Parameters are c(x_intercept, y_intercept, noise_X, noise_Y)
    x_intercept <- parameters[1]
    y_intercept <- parameters[2]
    noise_X <- parameters[3]
    noise_Y <- parameters[4]
    
    ## Calculate probabilities of generating a response in that area
    
    require(mnormt)
    
    predP <- pmnorm(
        x=cbind(rep(x_intercept, length(data[[response]])),
                rep(y_intercept, length(data[[response]]))),
        varcov=diag(c(noise_X, noise_Y)),
        mean=cbind(data[[Xvalue]],
                   data[[Yvalue]]))
    
    respA_stim_val <- data[[Xvalue]][data[[response]]=="A"]
    respB_stim_val <- data[[Xvalue]][data[[response]]=="B"]
    
    mean_diff <- mean(respA_stim_val, na.rm=T) - mean(respB_stim_val,
                                                      na.rm=T)
    
    ##  Calculate likelihoods - making sure A's and B's are correct
    likelihood <- c(predP[data[[response]]=="A"],
    (1.0-predP[data[[response]]=="B"]))
    
    ## Likelihood check - ensure greater than 0 and less than 1
    likelihood[likelihood<.Machine$double.eps] <- .Machine$double.eps
    likelihood[likelihood>(1.0-.Machine$double.eps)] <-
        (1.0-.Machine$double.eps)
    
    ## Negative log likelihood
    return(-sum(log(likelihood)))
}

#---------------------------------------------------------------------
# Conjunction: Upper left corner
# 4 parameters: x_intercept, y_intercept, noise_X, noise_Y

CJ_TL_model <- function(parameters, data,
                        Xvalue="Xvalue", Yvalue="Yvalue",
                        response="response"){
    ## Parameters are c(x_intercept, y_intercept, noise_X, noise_Y)
    
    SD <- diag(c(parameters[3], parameters[4]))

    ## Get stimulus coordinates
    stim_coord <- cbind(data[[Xvalue]], data[[Yvalue]])
    
    boundary <- cbind(rep(parameters[1], dim(stim_coord)[1]),
                      parameters[2], .Machine$integer.max)
    
    ## Calculate probabilities of generating a response in that area
    require(mnormt)
    
    predP <- pmnorm(x=boundary[,c(1,3)], varcov=SD, mean=stim_coord) - # LL + LM
        pmnorm(x=boundary[,c(1,2)], varcov=SD, mean=stim_coord) # LL

    likelihood <- c(predP[data[[response]]=="A"],
                    1.0-predP[data[[response]]=="B"])

    ## Likelihood check - ensure greater than 0 and less than 1
    likelihood[likelihood<.Machine$double.eps] <- .Machine$double.eps
    likelihood[likelihood>(1.0-.Machine$double.eps)] <-
        (1.0-.Machine$double.eps)
    
    ## Negative log likelihood
    return(-sum(log(likelihood)))
}

## -----------------------------------------------------------------------------
## Conjunction: Upper right corner
## 4 parameters: x_intercept, y_intercept, noise_X, noise_Y

CJ_TR_model <- function(parameters, data,
                        Xvalue="Xvalue", Yvalue="Yvalue",
                        response="response"){
    
    ## Parameters are c(x_intercept, y_intercept, noise_X, noise_Y)

    SD <- diag(c(parameters[3], parameters[4]))

    ## Get stimulus coordinates
    stim_coord <- cbind(data[[Xvalue]], data[[Yvalue]])
    
    boundary <- cbind(rep(parameters[1], dim(stim_coord)[1]),
                      parameters[2], .Machine$integer.max)
    
    ## Calculate probabilities of generating a response in that area
    require(mnormt)
    
    predP <- 1.0 - pmnorm(x=boundary[,c(1,3)], varcov=SD, mean=stim_coord) -
        pmnorm(x=boundary[,c(3,2)], varcov=SD, mean=stim_coord) + # LL + LM
        pmnorm(x=boundary[,c(1,2)], varcov=SD, mean=stim_coord) # LL
    
    likelihood <- c(predP[data[[response]]=="A"],
    (1.0-predP[data[[response]]=="B"]))

    ## Likelihood check - ensure greater than 0 and less than 1
    likelihood[likelihood<.Machine$double.eps] <- .Machine$double.eps
    
    likelihood[likelihood>(1.0-.Machine$double.eps)] <-
        (1.0-.Machine$double.eps)
    
    ## Negative log likelihood
    return(-sum(log(likelihood)))
}

##------------------------------------------------------------------------------
## Conjunction: Lower right corner
## 4 parameters: x_intercept, y_intercept, noise_X, noise_Y

CJ_BR_model <- function(parameters, data,
                        Xvalue="Xvalue", Yvalue="Yvalue",
                        response="response"){
    
    ## Parameters are c(x_intercept, y_intercept, noise_X, noise_Y)
    SD <- diag(c(parameters[3], parameters[4]))

    ## Get stimulus coordinates
    stim_coord <- cbind(data[[Xvalue]], data[[Yvalue]])
    
    boundary <- cbind(rep(parameters[1], dim(stim_coord)[1]),
                      parameters[2], .Machine$integer.max)
    
    ## Calculate probabilities of generating a response in that area
    
    require(mnormt)
    
    predP <- pmnorm(x=boundary[,c(3,2)], varcov=SD, mean=stim_coord) - # L
                pmnorm(x=boundary[,c(1,2)], varcov=SD, mean=stim_coord) # LL

    likelihood <- c(predP[data[[response]]=="A"], 
                    (1.0-predP[data[[response]]=="B"]))
    
    
    ## Likelihood check - ensure greater than 0 and less than 1
    likelihood[likelihood<.Machine$double.eps] <- .Machine$double.eps
    likelihood[likelihood>(1.0-.Machine$double.eps)] <-
        (1-.Machine$double.eps)
    
    ## Negative log likelihood
    neg_log_likelihood <- -sum(log(likelihood))
}

CJ_fit <- function(data, CJ_type=CJ_BL_model, Xvalue_label="Xvalue",
                   Yvalue_label="Yvalue", response_label="response"){

    ## Parameters are c(x_intercept, y_intercept, noise_X, noise_Y)

    ## CJ types: CJ_BL_model, CJ_TL_model, CJ_TR_mode, CJ_BR_model
    ## (top vs. bottom, left vs. right)
    
    min_x<- min(data[[Xvalue_label]])
    max_x <- max(data[[Xvalue_label]])
    start_x <- mean(data[[Xvalue_label]])
    
    min_y<- min(data[[Yvalue_label]])
    max_y <- max(data[[Yvalue_label]])
    start_y <- mean(data[[Yvalue_label]])
    
    min_noise <- 1.0 # .Machine$double.eps
    max_noise <- Inf
    start_noiseX <- sd(data[[Xvalue_label]])
    start_noiseY <- sd(data[[Yvalue_label]])
    
    nlminb(start=c(start_x, start_y, start_noiseX, start_noiseY),
           objective=CJ_type, data=data, Xvalue=Xvalue_label,
           Yvalue=Yvalue_label, response=response_label,
           lower=c(min_x, min_y, min_noise, min_noise),
           upper=c(max_x, max_y, max_noise, max_noise),
           control=list(eval.max=1000.0, iter.max=1000.0, x.tol=1e-4))
    
}

## Random models
## ------------------------------------------------------------------------

## Fixed random
## 0 parameters
RND_FIX_model <- function(data){
   return(-dim(data)[1]*log(0.5))
}

#--------------------------------------------------------------------------
## Baised random
## 1 parameter: bias

RND_BIAS_model <- function(bias, data, response="response"){
    bias <- 1.0-1.0/(1.0+exp(2.0*bias))
    count <- sum(ifelse(data[[response]]=="A", 1.0, 0.0))
    likelihood <- c(rep(bias, count), rep(1-bias, dim(data)[1]-count))
    return(-sum(log(likelihood)))
}

RND_BIAS_fit <- function(data, response_label="response"){
    nlminb(start=c(0.5),
           objective=RND_BIAS_model, data=data,
           response=response_label, lower=c(0), upper=c(1),
           control=list(maxit=1e+6, eval.max=1e+6))
}


## Applying models function
## --------------------------------------------------------------------

apply_models <- function(data, models=list('UDX'=T, 'UDY'=T, 'GLC'=T,
                                           'CJ_BL'=T, 'CJ_TL'=T,
                                           'CJ_TR'=T,
                                           'CJ_BR'=T,'RND_FIX'=T,
                                           'RND_BIAS'=T),
                         Xvalue_label="Xvalue", Yvalue_label="Yvalue",
                         response_label="response"){
    
    participant_number <- 1
    N <- dim(data)[1]
    
    ## Set up
    models_run <- vector(mode="numeric", length=0)
    BIC <- vector(mode="numeric", length=0)
    blank_df <- data.frame("Participant"=participant_number, "Model"=NA,
                           "Converge"=NA, "Nll"=NA, "BIC"=NA, "Rank"=NA,
                           "wBIC"=NA, "Parameters"=NA,
                           "ParameterValues"=NA)
    
    ## Unidimensional models
    UDX <- blank_df; UDX$Model <- "UDX"

    if (models$UDX){
        fit <- UD_fit(data=data, predictor_label="Xvalue",
                      response=response_label)
        
        UDX <- UDX[rep(seq_len(nrow(UDX)), length(fit$par)), ]
        UDX$Converge <- ifelse(fit$convergence==0, "Fit", fit$message)
        UDX$Nll <- fit$objective
        UDX$BIC <- get_BIC(neg_log_likelihood=fit$objective,
                           no_data_points=N, no_parameters=2)
        UDX$Parameters <- c("x_intercept", "noise")
        UDX$ParameterValues <- fit$par
        
        models_run <- c(models_run, "UDX")
        BIC <- c(BIC, UDX$BIC[1])
    }
    
    UDY <- blank_df; UDY$Model <- "UDY"
    
    if (models$UDY){
        fit <- UD_fit(data, predictor_label="Yvalue",
                      response=response_label)
        
        UDY <- UDY[rep(seq_len(nrow(UDY)), length(fit$par)), ]
        UDY$Converge <- ifelse(fit$convergence==0, "Fit", fit$message)
        UDY$Nll <- fit$objective
        UDY$BIC <- get_BIC(neg_log_likelihood=fit$objective,
                           no_data_points=N, no_parameters=2)
        UDY$Parameters <- c("y_intercept", "noise")
        UDY$ParameterValues <- fit$par
        
        models_run <- c(models_run, "UDY")
        BIC <- c(BIC, UDY$BIC[1])
    }
    
    ## General linear classifier
    
    GLC <- blank_df; GLC$Model <- "GLC"

    if (models$GLC){
        fit <- GLC_fit(data, Xvalue_label=Xvalue_label,
                       Yvalue_label=Yvalue_label,
                       response_label=response_label)
        
        GLC <- GLC[rep(seq_len(nrow(GLC)), length(fit$par)), ]
        GLC$Converge <- ifelse(fit$convergence==0, "Fit", fit$message)
        GLC$Nll <- fit$objective
        GLC$BIC <- get_BIC(neg_log_likelihood=fit$objective,
                           no_data_points=N, no_parameters=3)
        GLC$Parameters <- c("gradient", "y_intercept", "noise")
        GLC$ParameterValues <- fit$par
        
        models_run <- c(models_run, "GLC")
        BIC <- c(BIC, GLC$BIC[1])
    }
    
    ## Conjunctions
    
    CJ_BL <- blank_df; CJ_BL$Model <- "CJ_BL"
    if (models$CJ_BL){
        fit <- CJ_fit(data, CJ_type=CJ_BL_model,
                      Xvalue_label=Xvalue_label,
                      Yvalue_label=Yvalue_label,
                      response_label=response_label)
        CJ_BL <- CJ_BL[rep(seq_len(nrow(CJ_BL)), length(fit$par)), ]
        CJ_BL$Converge <- ifelse(fit$convergence==0, "Fit", fit$message)
        CJ_BL$Nll <- fit$objective
        CJ_BL$BIC <- get_BIC(neg_log_likelihood=fit$objective,
                             no_data_points=N, no_parameters=4)
        CJ_BL$Parameters <- c("x_intercept", "y_intercept", "noise_X",
                              "noise_Y")
        CJ_BL$ParameterValues <- fit$par
        
        models_run <- c(models_run, "CJ_BL")
        BIC <- c(BIC, CJ_BL$BIC[1])
    }
    
    CJ_TL <- blank_df; CJ_TL$Model <- "CJ_TL"
    
    if (models$CJ_TL){
        fit <- CJ_fit(data, CJ_type=CJ_TL_model,
                      Xvalue_label=Xvalue_label,
                      Yvalue_label=Yvalue_label,
                      response_label=response_label)
        
        CJ_TL <- CJ_TL[rep(seq_len(nrow(CJ_TL)), length(fit$par)), ]
        CJ_TL$Converge <-
            ifelse(fit$convergence==0, "Fit", fit$message)
        CJ_TL$Nll <- fit$objective
        CJ_TL$BIC <- get_BIC(neg_log_likelihood=fit$objective,
                             no_data_points=N, no_parameters=4)
        CJ_TL$Parameters <-
            c("x_intercept", "y_intercept", "noise_X", "noise_Y")
        CJ_TL$ParameterValues <- fit$par
        
        models_run <- c(models_run, "CJ_TL")
        BIC <- c(BIC, CJ_TL$BIC[1])
    }
    
    CJ_TR <- blank_df; CJ_TR$Model <- "CJ_TR"
    
    if (models$CJ_TR){
        fit <- CJ_fit(data, CJ_type=CJ_TR_model,
                      Xvalue_label=Xvalue_label,
                      Yvalue_label=Yvalue_label,
                      response_label=response_label)
        
        CJ_TR <- CJ_TR[rep(seq_len(nrow(CJ_TR)), length(fit$par)), ]
        CJ_TR$Converge <-
            ifelse(fit$convergence==0, "Fit", fit$message)
        CJ_TR$Nll <- fit$objective
        CJ_TR$BIC <- get_BIC(neg_log_likelihood=fit$objective,
                             no_data_points=N, no_parameters=4)
        CJ_TR$Parameters <- c("x_intercept", "y_intercept", "noise_X",
                              "noise_Y")
        
        CJ_TR$ParameterValues <- fit$par
        
        models_run <- c(models_run, "CJ_TR")
        BIC <- c(BIC, CJ_TR$BIC[1])
    }
    
    CJ_BR <- blank_df; CJ_BR$Model <- "CJ_BR"

    if (models$CJ_BR){
        fit_CJ_BR <- CJ_fit(data, CJ_type=CJ_BR_model,
                            Xvalue_label=Xvalue_label,
                            Yvalue_label=Yvalue_label,
                            response_label=response_label)
        
        CJ_BR <- CJ_BR[rep(seq_len(nrow(CJ_BR)), length(fit$par)), ]
        CJ_BR$Converge <-
            ifelse(fit$convergence==0, "Fit", fit$message)
        CJ_BR$Nll <- fit$objective
        CJ_BR$BIC <- get_BIC(neg_log_likelihood=fit$objective,
                             no_data_points=N, no_parameters=4)
        CJ_BR$Parameters <-
            c("x_intercept", "y_intercept", "noise_X", "noise_Y")
        CJ_BR$ParameterValues <- fit$par
        
        models_run <- c(models_run, "CJ_BR")
        BIC <- c(BIC, CJ_BR$BIC[1])
    }
    
    ## Random models
    RND_FIX <- blank_df; RND_FIX$Model <- "RND_FIX"
    if (models$RND_FIX){
        fit <- RND_FIX_model(data)
        
        RND_FIX$Converge <- "N/A"
        RND_FIX$Nll <- fit
        RND_FIX$BIC <- 2*fit
        RND_FIX$Parameters <- "None"
        RND_FIX$ParameterValues <- "N/A"
        
        models_run <- c(models_run, "RND_FIX")
        BIC <- c(BIC, RND_FIX$BIC[1])
    }
    
    RND_BIAS <- blank_df; RND_BIAS$Model <- "RND_BIAS"
    if (models$RND_BIAS){
        fit <- RND_BIAS_fit(data, response_label=response_label)
        
        RND_BIAS$Converge <-
            ifelse(fit$convergence==0, "Fit", fit$message)
        RND_BIAS$Nll <- fit$objective
        RND_BIAS$BIC <- get_BIC(neg_log_likelihood=fit$objective,
                                no_data_points=N, no_parameters=1)
        RND_BIAS$Parameters <- "bias"
        RND_BIAS$ParameterValues <- fit$par
        
        models_run <- c(models_run, "RND_BIAS")
        BIC <- c(BIC, RND_BIAS$BIC[1])
    }
   
    output <- rbind(UDX, UDY, GLC, CJ_BL, CJ_TL, CJ_TR, CJ_BR,
                    RND_FIX, RND_BIAS)
    
    ordered_models <- models_run[order(BIC)]
    ordered_BIC <- BIC[order(BIC)]
    delta_BIC <- ordered_BIC - min(ordered_BIC)
    wBIC <- exp(-0.5*delta_BIC)/sum(exp(-0.5*delta_BIC))
    
    for (i in 1:length(ordered_models)){
        output$Rank[output$Model==ordered_models[i]] <- i
        output$wBIC[output$Model==ordered_models[i]] <- wBIC[i]
    }
    return(output)
}

apply_opt_models <- function(data, categoryStructure,
                             models=list('UDX'=T, 'UDY'=T, 'GLC'=T,
                                         'CJ_TL'=T, 'CJ_BR'=T,
                                         'RND_FIX'=T),
                             Xvalue_label="Xvalue",
                             Yvalue_label="Yvalue",
                             response_label="response"){
    
    participant_number <- 1
    N <- dim(data)[1]
    
    ## Set up
    models_run <- vector(mode="numeric", length=0)
    BIC <- vector(mode="numeric", length=0)
    blank_df <- data.frame("Participant"=participant_number, "Model"=NA,
                           "Converge"=NA, "Nll"=NA, "BIC"=NA, "Rank"=NA,
                           "wBIC"=NA, "Parameters"=NA,
                           "ParameterValues"=NA)
    
    ## Unidimensional models
    UDX <- blank_df; UDX$Model <- "UDX"
    opt_fit <- glc(category ~ Xvalue, data=categoryStructure,
                   control=list(iter.max=1E4, eval.max=1E4))
    coef_fit <- coef(opt_fit)
    
    if (models$UDX){
        fit_UDX <- UD_model(
            parameters=c(as.numeric(coef_fit["(Intercept)"]), 
                         as.numeric(opt_fit$par$noise)), data,
            predictor="Xvalue",
            response="response")
        
        UDX$Nll <- fit_UDX
        UDX$BIC <- get_BIC(neg_log_likelihood=fit_UDX,
                           no_data_points=N, no_parameters=0)
        
        models_run <- c(models_run, "UDX")
        BIC <- c(BIC, UDX$BIC[1])
    }
    
    UDY <- blank_df; UDY$Model <- "UDY"
    opt_fit <- glc(category ~ Yvalue, data=categoryStructure,
                   control=list(iter.max=1E4, eval.max=1E4))
    coef_fit <- coef(opt_fit)
    
    if (models$UDY){
        fit_UDY <- UD_model(
            parameters=c(coef_fit["(Intercept)"],opt_fit$par$noise), data,
            predictor="Yvalue",
            response="response")
        
        UDY$Nll <- fit_UDY
        UDY$BIC <- get_BIC(
            neg_log_likelihood=fit_UDY,
            no_data_points=N, no_parameters=0)
        
        models_run <- c(models_run, "UDY")
        BIC <- c(BIC, UDY$BIC[1])
    }
    
    ## General linear classifier
    GLC <- blank_df; GLC$Model <- "GLC"
    
    opt_fit <- glc(category ~ Xvalue + Yvalue, data=category_structure)
    opt_coef <- coef(opt_fit)
    
    if (models$GLC){
        fit_GLC <- GLC_model(
            parameters=c(opt_coef["Xvalue"], opt_coef["(Intercept)"], 
                         opt_fit$par$noise), data, 
            Xvalue=Xvalue_label,
            Yvalue=Yvalue_label, response=response_label)
        
        GLC$Nll <- fit_GLC
        GLC$BIC <- get_BIC(neg_log_likelihood=fit_GLC,
                           no_data_points=N, no_parameters=0)
        
        models_run <- c(models_run, "GLC")
        BIC <- c(BIC, GLC$BIC[1])
    }
    
    ## Conjunctions
    opt_fit <- gcjc(category ~ Xvalue + Yvalue,
                    data=category_structure, config=2)
    
    opt_coef <- coef(opt_fit)
    
    CJ_TL <- blank_df; CJ_TL$Model <- "CJ_TL"

    if (models$CJ_TL){
        fit_CJ_TL <- CJ_TL_model(parameters=c(as.numeric(opt_coef["Xvalue"]),
                                        as.numeric(opt_coef["Yvalue"]),
                                        opt_fit$par$Xvalue$noise,
                                        opt_fit$par$Yvalue$noise),
                           data, Xvalue=Xvalue_label,
                           Yvalue=Yvalue_label,
                           response=response_label)
        
        CJ_TL$Nll <- fit_CJ_TL
        CJ_TL$BIC <- get_BIC(neg_log_likelihood=fit_CJ_TL,
                             no_data_points=N, no_parameters=0)
        
        models_run <- c(models_run, "CJ_TL")
        BIC <- c(BIC, CJ_TL$BIC[1])
    }
    
    opt_fit <- gcjc(category ~ Xvalue + Yvalue,
                    data=category_structure, config=4)
    
    opt_coef <- coef(opt_fit)
    
    CJ_BR <- blank_df; CJ_BR$Model <- "CJ_BR"
    
    if (models$CJ_BR){

        fit_CJ_BR <- CJ_BR_model(parameters=c(as.numeric(opt_coef["Xvalue"]),
                                              as.numeric(opt_coef["Yvalue"]),
                                              opt_fit$par$Xvalue$noise,
                                              opt_fit$par$Yvalue$noise),
                                 data, Xvalue=Xvalue_label,
                                 Yvalue=Yvalue_label,
                                 response=response_label)
        
        CJ_BR$Nll <- fit_CJ_BR
        CJ_BR$BIC <- get_BIC(neg_log_likelihood=fit_CJ_BR,
                             no_data_points=N, no_parameters=0)
        
        models_run <- c(models_run, "CJ_BR")
        BIC <- c(BIC, CJ_BR$BIC[1])
    }
    
    ## Random models
    RND_FIX <- blank_df; RND_FIX$Model <- "RND_FIX"
    if (models$RND_FIX){
        fit <- RND_FIX_model(data)
        
        RND_FIX$Nll <- fit
        RND_FIX$BIC <- 2*fit
        
        models_run <- c(models_run, "RND_FIX")
        BIC <- c(BIC, RND_FIX$BIC[1])
    }
    
    output <- rbind(UDX, UDY, GLC, CJ_TL, CJ_BR, RND_FIX)
    
    ordered_models <- models_run[order(BIC)]
    ordered_BIC <- BIC[order(BIC)]
    delta_BIC <- ordered_BIC - min(ordered_BIC)
    wBIC <- exp(-0.5*delta_BIC)/sum(exp(-0.5*delta_BIC))
    
    for (i in 1:length(ordered_models)){
        output$Rank[output$Model==ordered_models[i]] <- i
        output$wBIC[output$Model==ordered_models[i]] <- wBIC[i]
    }
    return(output)
}

## Run simulations 1 and 2 -----------------------------------------------------

run_simulation <- function(simulation=1){
    ## Load required packages
    packages <- c("grt","foreach","doParallel","parallel")
    lapply(packages, require, character.only=T)
    
    ## Setup parallel backend
    number_cores <- detectCores(logical=T)
    
    ## Setup parameters
    no_trials <- 400.0
    
    ## Get data frame
    output <- get_simulation_frame(simulation)
    save_simulation(output, simulation)
    
    print("Running simulation. Will take some time")
    
    ## Setting up clusters
    cl <- makeCluster(number_cores-1)
    registerDoParallel(cl)
    
    chunks <- seq(1, nrow(output), 20)
    
    for (j in 1:length(chunks)){
        start_i <- chunks[j]
        end_i <- chunks[j]+19
        
        if(end_i > dim(output)[1]) end_i <- dim(output)[1]
        
        recovered_models <- foreach(i=start_i:end_i, .combine="rbind") %dopar% {
            require("grt")
            source("PLY34functions.R")
            ## Generate appropriate category structure
            category_structure <- get_category_structure(output$categoryStructure[i])
                        
            ## Get optimum strategy
            if (output$strategyType[i]=="UD"){
                opt_fit <- glc(category ~ Xvalue,
                               data=category_structure,
                               control=list(iter.max=1E4, eval.max=1E4))
            } else if (output$strategyType[i]=="GLC"){
                opt_fit <- glc(category ~ Xvalue + Yvalue,
                               data=category_structure)
            } else if (output$strategyType[i]=="CJ"){
                opt_fit <- gcjc(category ~ Xvalue + Yvalue,
                                data=category_structure, config=2)
            }
            opt_coef <- coef(opt_fit)
            
            ## Loop to get responses/model fits
            models <- data.frame("participant"=1:output$no_ppts[i])

            models[c("Model","BIC","wBIC_UD","wBIC_GLC",
                     "wBIC_CJ", "wBIC_RND")] <- NA
            
            for (ppt in 1:output$no_ppts[i]){
                stimuli <- category_structure
                stimuli["participant"] <- ppt
                
                if (output$strategyType[i]=="UD"){
                    stimuli["response"] <-
                        get_ud_responses(coord_vector=stimuli$Xvalue,
                                         perceptual_noise=output$perceptualNoise[i],
                                         boundary=opt_coef["(Intercept)"],
                                         boundary_noise=output$boundaryNoise[i])
                } else if (output$strategyType[i]=="GLC"){
                    stimuli["response"] <-
                        get_ii_responses(category_structure=stimuli[,1:4],
                                         perceptual_noise=output$perceptualNoise[i],
                                         gradient=opt_coef["Xvalue"],
                                         y_intercept=opt_coef["(Intercept)"],
                                         boundary_noise=output$boundaryNoise[i])
                } else if (output$strategyType[i]=="CJ"){
                    stimuli["response"] <-
                        get_cj_responses(structure=stimuli[,1:4],
                                         perceptual_noise=output$perceptualNoise[i],
                                         x_intercept=as.numeric(opt_coef["Xvalue"]),
                                         y_intercept=as.numeric(opt_coef["Yvalue"]),
                                         type="CJ_TL",
                                         boundary_noise=output$boundaryNoise[i])
                }
                
                model_fit <- apply_models(data=stimuli,
                                          models=list('UDX'=T,
                                                      'UDY'=T,
                                                      'GLC'=T,
                                                      'CJ_BL'=F,
                                                      'CJ_TL'=T,
                                                      'CJ_TR'=F,
                                                      'CJ_BR'=T,
                                                      'RND_FIX'=T,
                                                      'RND_BIAS'=T),
                                          Xvalue_label="Xvalue",
                                          Yvalue_label="Yvalue",
                                          response_label="response")
                
                model_fit <- model_fit[complete.cases(model_fit),]
                win_model <- model_fit[model_fit$Rank==1,]
                models[ppt,2:3] <- win_model[1, c("Model","BIC")]
                
                all_model <- aggregate(list(model_fit$wBIC),
                                       list(model_fit$Model), mean)
                colnames(all_model)<-c("Model", "wBIC")
                
                wBICs <- c(0,0,0,0)
                
                if (win_model$Model=="UDX" | win_model$Model=="UDY"){
                    wBICs[1] <- (all_model$wBIC[all_model$Model=="UDX"] +
                                all_model$wBIC[all_model$Model=="UDY"])/
                                sum(all_model$wBIC)
                } else if (win_model$Model=="GLC"){
                    wBICs[2] <- all_model$wBIC[all_model$Model=="GLC"]/
                                sum(all_model$wBIC)
                } else if (win_model$Model=="CJ_TL" | win_model$Model=="CJ_BR"){
                    wBICs[3] <- (all_model$wBIC[all_model$Model=="CJ_TL"] +
                                all_model$wBIC[all_model$Model=="CJ_BR"])/
                                sum(all_model$wBIC)
                } else {
                    wBICs[4] <- (all_model$wBIC[all_model$Model=="RND_FIX"] +
                                 all_model$wBIC[all_model$Model=="RND_BIAS"]) /
                                 sum(all_model$wBIC)
                }
                models[ppt,c("wBIC_UD", "wBIC_GLC", "wBIC_CJ", "wBIC_RND")] <- 
                    wBICs
            }
            
            models <- models[complete.cases(models),]

            proportions <- c(
                nrow(models[models$Model=="UDX"|models$Model=="UDY",]), 
                nrow(models[models$Model=="GLC",]), 
                nrow(models[models$Model=="CJ_TL"|models$Model=="CJ_BR",]),
                nrow(models[models$Model=="RND_FIX"|models$Model=="RND_BIAS",])
            ) / nrow(models)
            
            
            wBICs <- c(mean(models$wBIC_UD), mean(models$wBIC_GLC), 
                       mean(models$wBIC_CJ), mean(models$wBIC_RND))
            wBICs[is.na(wBICs)] <- 0
            c(proportions, wBICs)
        }
        
        output[start_i:end_i,
               c("prop_UD","prop_GLC","prop_CJ","prop_RND", 
                 "wBIC_UD", "wBIC_GLC", "wBIC_CJ","wBIC_RND")] <-
            recovered_models
        
        save_simulation(output, simulation)
        print(j)
    }
    stopCluster(cl)
}
