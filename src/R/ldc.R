require(dplyr)
require(data.table)
require(reshape2)
require(ggplot2)

rm(list = ls())
options(scipen=999)
options(digits=15)

path.data = "C:/Users/ablohm/Documents/vigilant-enigma/data/raw"
path.graphics = "C:/Users/ablohm/Documents/vigilant-enigma/paper/figures"
setwd(path.data)

data.load = read.table(file="pjmRTO_load_2015.txt", header= TRUE, sep="\t")

data.load = data.load %>%
  melt(., id.vars=c("DATE", "COMP")) %>%
  setNames(., c('date', 'region', 'variable', 'load')) %>%
  mutate(hour= gsub(x= variable, pattern= "HE", replacement= "")) %>%
  mutate(dt = as.POSIXct(paste(date, hour, sep=" "), format= "%m/%d/%Y %H")) %>%
  arrange(., desc(load)) %>%
  mutate(hr.order = seq(from=1, to= nrow(.), by=1))

p= ggplot(data= data.load, aes(x= hr.order, y= load)) +
  geom_line() +
  geom_point(size= 0.5) +
  labs(x= "Hour", 
       y= "Load (MW)", 
       title= "PJM Load Duration Curve (2015)") +
  theme(plot.title= element_text(size= 20),
        axis.text= element_text(size= 14),
        axis.title= element_text(size=18))

ggsave(filename= paste0(path.graphics,"/pjm_ldc.png"), plot= p, dpi= 800, width = 11, height = 8.5)

p= ggplot(data= data.load, aes(x= hr.order, y= load)) +
  geom_vline(xintercept=3) +
  xlim(0, 5) +
  geom_line() +
  geom_point(size= 3) +
  geom_text(aes(label=round(load)),hjust=1.1, vjust=2) +
  labs(x= "Hour", 
       y= "Load (MW)", 
       title= "PJM Load Duration Curve - Hours 1-5 (2015)") +
  theme(plot.title= element_text(size= 20),
        axis.text= element_text(size= 14),
        axis.title= element_text(size=18))

ggsave(filename= paste0(path.graphics,"/pjm_ldc_xlim1_5.png"), plot= p, dpi= 800, width = 11, height = 8.5)

x.value = 143125
x.percentile = 0.9991
ub = 200000

f2 = function(lambda) ppois(x.value, lambda) - x.percentile
uniroot(f2, c(0, ub))
max(f2(floor(as.numeric(uniroot(f2, c(0, ub))[1]))), f2(ceiling(as.numeric(uniroot(f2, c(0, ub))[1]))))

floor(as.matrix(uniroot(f2, c(0, ub))[1]),ceiling(uniroot(f2, c(0, ub))[1]))
qpois(p=0.000342465753424658)
