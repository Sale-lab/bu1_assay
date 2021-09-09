
##Bu-1a fluctuation analysis plot and statistical analysis
##Guillaume Guilbaud, JE Sale lab 06 2021
	
	##The user should define the bin size (Bin line 14) for the Fisher exact test. The bin is set to contain 90% of the control sample.
	##Based on our previous experience, well looked after and well stained wild type DT40 do not exhibit more than a maximum of 20% apparent loss variants, most often < 10%. 
    ##If the apparent wild type BU-1 loss variant population is > 20% the cells are likely to be stressed and the results are unlikely to be reliable
	
	##The user should also change the file type (line 15) if the input files are not .csv
	##If the name of the gate to count the percentage of Bu-1 positive cells is different than "Bu1_Pos", this should be changed in line 18
	
	##Parameters that could be changed by user

Bin <- 20 ##The bins size for the fisher exact test

File.type <- "*.csv" ##The input file type, the default format id .csv files, tabulated .txt files could also be used	

Bu1_gate_name <- "*/Bu1_Pos" ##Gate name for Bu-1 positive cells


	##Required packages
list.of.packages <- c("beeswarm", "RSvgDevice")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

	library(beeswarm)
	library(RSvgDevice)

		##List directories within 'Input' folder. Each directory should contain the .csv files from the cytometry analysis for the experiments to appear on a single plot.  

	Dirs.In <- list.dirs("./Input")		
	
		##Start loop to analyse each directory separately
		
				for (Dir in Dirs.In){
		
		##List files	

	Files.In <- list.files(Dir[grep(paste(File.type),list.files(Dir))])   ##list .csv only files
	if(length(Files.In)>0){ ##rm ./Input Dir alone
	  
Working.Dir <- substr(Dir,9,nchar(Dir))	##Extract working directory name; later use as main title of graphic and output file name
		
Tab.out <- NULL
Names.Out <- NULL
n <- 0

	for (File in Files.In){

 		##Open and extract Bu-1a positive percentage  
  
 	 Tab.In <- read.table(paste(Dir,"/",File,sep=""))
  
 	 Bu <- 100-Tab.In[grep(paste(Bu1_gate_name), Tab.In[,1]),2]
  
	##Pool Bu1_Pos record per conditions 
 	 
 n <- n+1 
  Tab.out.temp <- cbind(Bu,rep(n,length(Bu)))
  Tab.out <- rbind(Tab.out, Tab.out.temp)
  	
  	##Retreive condition name

  Names.Out.temp <- substr(File,3,nchar(File)-4)
  Names.Out <- c(Names.Out, Names.Out.temp)
  
}

	##Create output directory
 dir.create("Output/")
 dir.create(paste("Output/",Working.Dir,sep=""))


	##Do Plot
devSVG(paste("Output/",Working.Dir,"/", Working.Dir,".svg",sep=""),height=4,width=n*1.3)
op <- par(mar=c(15,4,4,2))

##Do the scatter plot 
beeswarm(Tab.out[,1] ~ Tab.out[,2], data= Tab.out,col='gray35',  method = 'swarm', pch=19,ylab=c("Bu-1a low (%)"),labels= F,xlab="",bty="n",main=c(paste(Working.Dir)),ylim=c(0,100))
axis(1,at=unique(Tab.out[,2]), labels=Names.Out,las=2)
	
plot.Data <- boxplot(Tab.out[,1] ~ Tab.out[,2], data= Tab.out,plot=F)
IQR <- plot.Data $stat

	##Plot lower, upper quartile and the median
for (i in 1:length(IQR[1,])){

segments(i-0.3,IQR[3,i],i+0.3,IQR[3,i],lwd=2,col=rgb(1,0,0,0.8))#median
segments(i-0.3,IQR[2,i],i+0.3,IQR[2,i],lwd=2,col=rgb(0,0,0,0.8))#Lower quartile
segments(i,IQR[3,i],i,IQR[2,i],lwd=2,col=rgb(0,0,0,0.8))#vertical line (bottom)
segments(i-0.3,IQR[4,i],i+0.3,IQR[4,i],lwd=2,col=rgb(0,0,0,0.8))#Upper quartile
segments(i,IQR[3,i],i,IQR[4,i],lwd=2,col=rgb(0,0,0,0.8))#vertical line (Top)


}

dev.off()

	## Do Fisher exact test
	
 Breaks <- seq(0,100,Bin)

Fisher.exact.pValue <-  matrix(NA,length(Names.Out),length(Names.Out))
colnames(Fisher.exact.pValue) <- Names.Out
rownames(Fisher.exact.pValue) <- Names.Out

for (row in c(1:max(Tab.out[,2]))){
	for (col in c(1:max(Tab.out[,2]))){
	
 	cond.1 <- which(Tab.out[,2]==row)
 	counts.cond.1 <- hist(Tab.out[cond.1,1],breaks= Breaks,plot=F)$counts

	cond.2 <- which(Tab.out[,2]==col)
 	counts.cond.2 <- hist(Tab.out[cond.2,1],breaks= Breaks,plot=F)$counts

	
	Fisher.exact.pValue[row,col] <- fisher.test(rbind(counts.cond.1,counts.cond.2))$p.value
}}

	
write.table(Fisher.exact.pValue,paste("Output/",Working.Dir,"/fisher.test_bin.size_", Bin,"_of_", Working.Dir,".txt",sep=""),sep="\t")

	
	}
}

