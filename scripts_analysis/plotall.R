
csvfilenames<-c(
"cycle2.csv",
"cycle3.csv",
"cycle4.csv",
"cycle5.csv",
"cycle6.csv",
"cycle7.csv"
)
plottitles=paste("Cress green coverage analysis: Cycle",2:7)

pinfos=data.frame(c=csvfilenames,p=plottitles,stringsAsFactors = FALSE)
pinfos$t=18 # threshold

pdf("cycleplots.pdf",height=8,width=20)
for (i in 1:length(pinfos$c)){
	print(pinfos[i,])
    csvfilename=pinfos[i,]$c
	plottitle=pinfos[i,]$p
	threshmin=pinfos[i,]$t
	source("greenplot.R")
}
dev.off()

