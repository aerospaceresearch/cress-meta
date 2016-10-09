require("ggplot2")
require("plotly")

if (!("csvfilename" %in% ls())){
    csvfilename="../coverage.csv"
}

d<-read.csv(csvfilename,sep="\t",header=T)

if(!("threshmin" %in% ls())){
    threshmin=-1
}

if(!("plottitle" %in% ls())){
    plottitle="Cress.space green coverage analysis"
}
d$covperc<-d$covperc*100.0 # percent range [0-100]

d$plotval=d$covperc
# invalidate measurements with threshold < threshmin
d$plotval[d$threshold<threshmin]=NA

ts=vector(mode="numeric")
for (s in strsplit(as.character(d$imagefilename),'\\.|_')){
#     print (s);
    tp=as.POSIXct(as.numeric(s[1]), origin="1970-01-01")
#     print (tp); 
    ts=append(ts,tp)
    }

d$ts<-ts

csvbasename=unlist(strsplit(basename(csvfilename),"\\."))[1]

p<-ggplot(d)+geom_line(aes(ts,plotval))+geom_smooth(aes(ts,plotval))
p=p+geom_point(aes(ts,covperc,color=(threshold>=threshmin)),alpha=0.5,shape=21)
p=p+geom_line(aes(ts,threshold/2.55,color="Threshold [%]"))
p=p+geom_hline(yintercept = threshmin/2.55,)
p=p+labs(title=plottitle,x="Time",y="Green coverage [%], Threshold [%]")
print(p)

# plot to a png file
png(paste(csvbasename,"_plot.png",sep=""),width=800, height=400)
print(p)
dev.off()

try(htmlwidgets::saveWidget(widget=as.widget(ggplotly(p)),file=paste(csvbasename,"_plot.html",sep=""), selfcontained = FALSE, libdir="html_libs"))
