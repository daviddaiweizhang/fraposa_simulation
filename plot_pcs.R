rm(list=ls())
library(plotrix)

radius = 0.9
methods = c("sp", "ap", "oadp", "adp")
lim = c(-35, 35)

args = commandArgs(trailingOnly=TRUE)
inpref = ifelse(length(args) >= 1, args[1], "data/c800/a")
x.ref = read.table(paste0(inpref, "_ref.pcs"))
colnames(x.ref) = c("popu", "id", "PC1", "PC2")
x.ref = x.ref[order(x.ref$popu),]

# rotate the samples
c.ref = aggregate(x.ref[,c("PC1", "PC2")], by = list(x.ref$popu), FUN = mean)
colnames(c.ref) = c("popu", "C1", "C2")
aa = c.ref[1:2, 2:3]
aa = aa / sqrt(rowSums(aa^2))
bb = 1/sqrt(2) * matrix(c(1,-1,1,1), 2, 2)
rot = as.matrix(solve(aa) %*% bb)
x.ref[,c("PC1", "PC2")] = as.matrix(x.ref[,c("PC1", "PC2")]) %*% rot
c.ref[,c("C1", "C2")] = as.matrix(c.ref[,c("C1", "C2")]) %*% rot

x.ref = merge(x.ref, c.ref)
x.ref$r = sqrt(rowSums((x.ref[,c("PC1", "PC2")] - x.ref[,c("C1", "C2")])^2))
c.ref = merge(c.ref, aggregate(data.frame(r=x.ref$r), by=list(popu=x.ref$popu), FUN=function(x) quantile(x, radius)))

msd.all = c(nrow(x.ref))
png(paste0(inpref, ".png"), 2000, 2000)
par(mfrow=c(2,2), cex=2)
for(method in methods){
    x.stu = read.table(paste0(inpref, "_", method, ".pcs"))
    colnames(x.stu) = c("popu", "id", "PC1", "PC2")
    x.stu = x.stu[order(x.stu$popu),]
    x.stu[,c("PC1", "PC2")] = as.matrix(x.stu[,c("PC1", "PC2")]) %*% rot
    c.stu = aggregate(x.stu[,c("PC1", "PC2")], by = list(x.stu$popu), FUN = mean)
    colnames(c.stu) = c("popu", "C1", "C2")
    reflect = sign(c.stu[1, c("C1", "C2")] / c.ref[1, c("C1", "C2")])
    reflect = c(as.matrix(reflect))
    x.stu[,c("PC1", "PC2")] = x.stu[,c("PC1", "PC2")] * rep(reflect, each=nrow(x.stu))
    c.stu[,c("C1", "C2")] = c.stu[,c("C1", "C2")] * rep(reflect, each=nrow(c.stu))

    stu.pch = 14
    main = paste(method, nrow(x.ref))
    col.ref = as.integer(x.ref$popu) + 1
    plot(x.ref[,3:4], main=main, col=col.ref, xlim=lim, ylim=lim)

    pch.stu = as.integer(x.stu$popu) + stu.pch
    points(x.stu[,3:4], col=1, pch=pch.stu)
    lapply(1:nrow(c.ref), function(i) draw.circle(c.ref$C1[i], c.ref$C2[i], c.ref$r[i], border=i+1, lty=5, lwd=3))
    x.stu = merge(x.stu, c.stu)
    x.stu$r = sqrt(rowSums((x.stu[,c("PC1", "PC2")] - x.stu[,c("C1", "C2")])^2))
    c.stu = merge(c.stu, aggregate(data.frame(r=x.stu$r), by=list(popu=x.stu$popu), FUN=function(x) quantile(x, radius)))
    lapply(1:nrow(c.stu), function(i) draw.circle(c.stu$C1[i], c.stu$C2[i], c.stu$r[i], border=1, lty=5, lwd=3))
    if(method == "adp"){
        des.ref = paste("Popu.", 1:4, "ref.")
        legend("bottomright", legend=des.ref, pch=1, col=(1:4)+1)
        des.stu = paste("Popu.", 1:4, "stu.")
        legend("topright", legend=des.stu, pch=(1:4)+stu.pch, col=1)
    }
    msd = sqrt(mean(rowSums((c.stu[,c("C1", "C2")] - c.ref[,c("C1", "C2")])^2)))
    msd = round(msd, 3)
    legend("bottomleft", legend=paste("MSD:", msd))
    msd.all = c(msd.all, msd)
}
dev.off()
write(msd.all, paste0(inpref, "_msd"), ncolumns=length(msd.all), sep="\t")

