################################################
## Main function to simulate the model
run_simulation <- function(inp,mod,sim_parameters){
  
    ev1 <- data.frame(ID=1,ii=0, cmt=1, time=0, addl=0,evid=1)

    ev1 <- merge(ev1,sim_parameters)
    print(ev1)


    #########################
    # Perform simulation with mrgsolve
    df <- mod %>%
      data_set(ev1) %>%
      mrgsim(start=0,end=12,delta=0.1) %>% #
      as.data.frame()
    

  return(df) # Return the simulation results
}