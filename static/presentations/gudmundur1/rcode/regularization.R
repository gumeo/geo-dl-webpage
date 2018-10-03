#######################################################################
# Standard plot to shot overfitting with polynomials of increasing
# order... Then start with the most complex polynomial and regularize
# it...
#######################################################################

# Function to fit polynomials of specific order and predict on interval
polFunc <- function(y, data, order, predPoints, reg = 0){
  # Create the data frame
  n <- length(data)
  nPred <- length(predPoints)
  datMat <- as.matrix(cbind(rep(1,n),data))
  predMat <- as.matrix(cbind(rep(1,nPred),predPoints))
  if(order >= 2){
    for(i in 2:order){
      datMat <- cbind(datMat,(data)^i)
      predMat <- cbind(predMat,(predPoints)^i)
    }
  }
  X <- datMat
  p <- dim(X)[2]
  beta <- (solve(t(X)%*%X+reg*diag(p))%*%t(X)%*%y)
  
  print(sum(diag(X%*%solve(t(X)%*%X+reg*diag(p))%*%t(X))))
  
  # Predictions
  return(predMat%*%beta)
}

n <- 20
x <- seq(-2,2,len=n)+0.1*rnorm(n)
y <- sin(x*2.5)+x + 0.5*rnorm(n)

plot(x,y)

pPoints <- seq(-2,2,len=300)
yPoints <- polFunc(y,x,2,pPoints,0)

pMat <- cbind(pPoints,yPoints)
degreeVec <- c(3,8,14)
for(i in degreeVec){
  yPoints <- polFunc(y,x,i,pPoints,0)
  pMat <- cbind(pMat, yPoints)
}
colnames(pMat) <- c('x',paste0('Degree ',c(2,degreeVec)))

library(ggplot2)
library(reshape2)
library(ggthemes)
library(scales)
library(showtext)
font_add_google(name = "Titillium Web", family = "Helv", regular.wt = 400, bold.wt = 700)
showtext_auto()
science_theme = theme(panel.grid.major = element_line(size = 0.5, color = "grey"), 
                      axis.line = element_line(size = 0.7, color = "black"), legend.position = c(0.85, 
                                                                                                 0.7), text = element_text(size = 14))

chartDat <- melt(pMat,id='x')
names(chartDat) <- c('x', 'Polynomial', 'value')

chartDat <- cbind(rep(pPoints,length(degreeVec)+2),chartDat)
colnames(chartDat) <- c('x','num','Polynomial','value')

chartDat <- chartDat[-(1:300),]

mPoints <- data.frame(x=x,y=y)

ggOut <- ggplot() +
  geom_line(data = chartDat, aes(x = x, y = value, color = Polynomial, linetype=Polynomial), size = 0.8,alpha=0.6)+
  geom_point(data=mPoints,aes(x=x,y=y),size=2)+
  xlab("x axis") +
  ylab("y axis") +
  theme_bw(base_size = 12) +
  science_theme +
  theme(legend.position = 'top') +
  ylab('') +
  xlab('')+
  scale_color_gdocs() +
  ggtitle('Overfitting') +theme(text = element_text(family = "Helv",size = 12))+ylim(c(-2,2))

showtext_begin()
ggOut
ggsave('./overfit.pdf',ggOut,width = 6,height = 4,unit='in')

###################################################################################################
# Same for regularization
###################################################################################################

set.seed(123)
n <- 20
x <- seq(-2,2,len=n)+0.1*rnorm(n)
y <- sin(x*2.5)+x + 0.5*rnorm(n)

plot(x,y)
pPoints <- seq(-2,2,len=300)
yPoints <- polFunc(y,x,14,pPoints,0)
mPoints <- data.frame(x=x,y=y)
specify_decimal <- function(x, k) trimws(format(round(x, k), nsmall=k))
pMat <- cbind(pPoints,yPoints)
degreeVec <- 10^(seq(-5,2,len=400))
num <- 1
for(i in degreeVec){
  print(num)
  yPoints <- polFunc(y,x,14,pPoints,i)
  pMat <- as.data.frame(cbind(pPoints, yPoints))
  colnames(pMat) <- c('x','y')
  ggOut <- ggplot() +
    geom_line(data = pMat, aes(x = x, y = y), size = 0.8,alpha=0.6)+
    geom_point(data=mPoints,aes(x=x,y=y),size=2)+
    xlab("x axis") +
    ylab("y axis") +
    theme_bw(base_size = 16) +
    science_theme +
    ylab('') +
    xlab('') +
    scale_color_gdocs() +
    ggtitle(paste0('Regularizing Polynomial - Lambda: ',specify_decimal(i,5))) +theme(text = element_text(family = "Helv",size = 16))+ylim(c(-3,3))
  
  showtext_begin()
  ggOut
  ggsave(paste0('./imgs/',sprintf("%08d", num),'.png'),ggOut,width = 4,height = 2,unit='in')
  num <- num+1
}


ggOut <- ggplot() +
  geom_line(data = chartDat, aes(x = x, y = value, color = Regularization,linetype=Regularization), size = 0.8,alpha=0.6)+
  geom_point(data=mPoints,aes(x=x,y=y),size=2)+
  xlab("x axis") +
  ylab("y axis") +
  theme_bw(base_size = 12) +
  science_theme +
  theme(legend.position = 'top') +
  ylab('') +
  xlab('')+
  scale_color_gdocs() +
  ggtitle('Regularizing Polynomial') +theme(text = element_text(family = "Helv",size = 12))+ylim(c(-2,2))

showtext_begin()
ggOut
ggsave('./regularization.pdf',ggOut,width = 6,height = 4,unit='in')
