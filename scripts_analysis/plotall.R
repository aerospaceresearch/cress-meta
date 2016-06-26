
csvfilenames<-paste("cycle",2:7,".csv",sep="")
plottitles=paste("Cress green coverage analysis: Cycle",2:7)
pinfos=data.frame(c=csvfilenames,p=plottitles,stringsAsFactors = FALSE)
pinfos$t=18 # threshold for all 

pdf("cycleplots.pdf",height=8,width=20)
for (i in 1:length(pinfos$c)){
	print(pinfos[i,])
    csvfilename=pinfos[i,]$c
	plottitle=pinfos[i,]$p
	threshmin=pinfos[i,]$t
	source("greenplot.R")
}
dev.off()

