rm(list=ls())
args = commandArgs(trailingOnly=TRUE)
msd.pref = ifelse(length(args) >= 1, args[1], "data/msd")
x = read.table(msd.pref)
methods = c("sp", "ap", "oadp", "adp")
colnames(x) = c("nref", methods)
ylim = c(0.0, 0.4)

lwd = 3
cex = 2
png(paste0(msd.pref, ".png"), 1000, 1000)
par(cex=2)
for(i in 1:length(methods)){
    method = methods[i]
    if(i == 1){
        xlab = "Reference size"
        ylab = "sqrtMSD"
	main = "Comparison of accuracy as reference size varies"
        plot(x$nref, x[[method]], type="b", col=i, ylim=ylim, xlab=xlab, ylab=ylab, lwd=lwd, cex=cex, main=main)
    } else{
        points(x$nref, x[[method]], type="b", col=i, lwd=lwd, cex=cex)
    }
}
legend("topright", legend=toupper(methods), pch=1, lty=1, col=1:4)
dev.off()
