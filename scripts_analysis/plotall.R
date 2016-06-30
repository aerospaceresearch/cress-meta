
cnt=vector("numeric")
for(i in 2:8){
    cnt=append(cnt,i)
    cnt=append(cnt,i)
}

csvfilenames<-paste("cycle",cnt,c("_threshold_percent.csv",".csv"),sep="")
plottitles=paste("Cress green coverage analysis: Cycle",cnt)
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
