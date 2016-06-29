require("ggplot2")

if (!("threshcountformat" %in% ls())){
    threshcountformat=TRUE
}

if (!("csvfilename" %in% ls())){
    csvfilename="../coverage.csv"
}
if(threshcountformat){
    d<-read.csv(csvfilename,sep=";",header=F)
    d[,2:3]<-NULL
    names(d)<-c("imagefilename", "threshold",     "covpix",        "covperc")
    d$threshold=0
}else{
    d<-read.csv(csvfilename,sep="\t",header=T)
}


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
p<-ggplot(d)+geom_line(aes(ts,plotval))+geom_smooth(aes(ts,plotval))
p=p+geom_point(aes(ts,covperc,color=(threshold>=threshmin)),alpha=0.5,shape=21)
p=p+geom_line(aes(ts,threshold/2.55,color="Threshold [%]"))
p=p+geom_hline(yintercept = threshmin/2.55,)
p=p+labs(title=plottitle,x="Time",y="Green coverage [%], Threshold [%]")
print(p)
