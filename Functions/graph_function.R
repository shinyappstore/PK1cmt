###########################################
###  Function to create the PK profiles in ggplot
graph_function <- function(df,inp){

# If no data is simulated, do not create anything
if (is.null(df)) return()


####### Numeric stats
cmax <- df %>% 
  summarise(CMAX = round(max(DV),1),
            Tmax=round(time[which.max(DV)],1))
  
AUC = round((inp$dose*inp$BIOF/100) / inp$CL,1)
  
print(cmax)
print(AUC)
  


titnew = paste("Cmax = ",cmax$CMAX,"ng/mL\nTmax = ", cmax$Tmax,"h\nAUC =",AUC,"h*ng/mL")

  
# Create plot
p1lin <- ggplot(df, aes(x=time,y=DV)) +

  ## Add median line
  geom_line(size=2) +
  
  # Set axis and theme
  ylab(paste("Concentration (ng/mL)",sep=""))+
  xlab("Time after dose (h)")+
  scale_x_continuous(expand=c(0,0))+
  # Set theme details
  theme_bw(base_size = 16)+
  theme(legend.position="none", panel.grid.minor = element_blank()) # Remove minor grid lines because of log y-axis


## Same figure on log scale
p1log <- p1lin + 
  scale_y_log10(expand=c(0,0.4)) + 
  annotation_logticks(sides = "l")+
  theme(legend.position="right",legend.title = element_blank()) +
  annotate('text', label=titnew, x=-Inf, y=Inf, hjust=0, vjust=1,size=6)



## Combine in 1 plot with different widths to include the legend
plot_combine <- plot_grid(p1lin,p1log,ncol=2)

return(plot_combine)
}