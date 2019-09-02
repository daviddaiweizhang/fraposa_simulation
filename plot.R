args = commandArgs(trailingOnly=TRUE)
inpref = ifelse(length(args) > 1, args[1], "data/c100/a")
x.ref = read.table(paste0(inpref, "_ref.pcs"))
methods = c("sp", "ap", "oadp", "adp")
png(paste0(inpref, ".png"), 2000, 2000)
par(mfrow=c(2,2), cex=2)
for(method in methods){
    x.stu = read.table(paste0(inpref, "_", method, ".pcs"))
    main = paste(method, nrow(x.ref))
    plot(x.ref, main=main, col=2)
    points(x.stu, col='grey50', pch=16)
}
dev.off()
