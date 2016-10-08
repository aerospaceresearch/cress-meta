
datadir="data/"
# box1_cycle10/box1_cycle10.csv"

csvfiles=c(character())
plottitles=c(character())
for (boxcnt in 1:10){
    for (cycnt in 2:200){
        bn=paste("box",boxcnt,"_cycle",cycnt,sep="")
        csvfile=paste(datadir,bn,"/",bn,".csv",sep="")
        if(file.exists(csvfile)){
            csvfiles=c(csvfiles, csvfile)
            plottitles=c(plottitles,paste("Cress.space green coverage analysis: Box",boxcnt,",Cycle",cycnt))
        }
        csvfile=paste(datadir,bn,"/speedseed/",bn,"_threshold_percent.csv",sep="")
        if(file.exists(csvfile)){
            csvfiles=c(csvfiles, csvfile)
            plottitles=c(plottitles,paste("Cress.space green coverage analysis: Box",boxcnt,"Cycle",cycnt,"(stack analysis)"))
        }
    }
}

# csvfilenames<-paste("box",boxcnt,"_cycle",cnt,c("_threshold_percent.csv",".csv"),sep="")
pinfos=data.frame(c=csvfiles,p=plottitles,stringsAsFactors = FALSE)
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
