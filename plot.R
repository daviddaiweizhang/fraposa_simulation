rm(list=ls())
library(plotrix)

radius = 0.9
methods = c("sp", "ap", "oadp", "adp")
lim = c(-35, 35)

args = commandArgs(trailingOnly=TRUE)
inpref = ifelse(length(args) >= 1, args[1], "data/c800/a")
x.ref = read.table(paste0(inpref, "_ref.pcs"))
colnames(x.ref) = c("popu", "id", "PC1", "PC2")

# # Center samples to the origin
# cent = colMeans(x.ref[,c("PC1", "PC2")])
# x.ref[,c("PC1", "PC2")] = x.ref[,c("PC1", "PC2")] - rep(cent, each=nrow(x.ref))

# rotate the samples
c.ref = aggregate(x.ref[,c("PC1", "PC2")], by = list(x.ref$popu), FUN = mean)
colnames(c.ref) = c("popu", "C1", "C2")
c.ref = c.ref[order(c.ref$popu),]
aa = c.ref[1:2, 2:3]
aa = aa / sqrt(rowSums(aa^2))
bb = 1/sqrt(2) * matrix(c(1,-1,1,1), 2, 2)
rot = as.matrix(solve(aa) %*% bb)
x.ref[,c("PC1", "PC2")] = as.matrix(x.ref[,c("PC1", "PC2")]) %*% rot
c.ref[,c("C1", "C2")] = as.matrix(c.ref[,c("C1", "C2")]) %*% rot

x.ref = merge(x.ref, c.ref)
x.ref$r = sqrt(rowSums((x.ref[,c("PC1", "PC2")] - x.ref[,c("C1", "C2")])^2))
c.ref = merge(c.ref, aggregate(data.frame(r=x.ref$r), by=list(popu=x.ref$popu), FUN=function(x) quantile(x, radius)))

png(paste0(inpref, ".png"), 2000, 2000)
par(mfrow=c(2,2), cex=2)
for(method in methods){
    x.stu = read.table(paste0(inpref, "_", method, ".pcs"))
    colnames(x.stu) = c("popu", "id", "PC1", "PC2")
    # x.stu[,c("PC1", "PC2")] = as.matrix(x.stu[,c("PC1", "PC2")] - rep(cent, each=nrow(x.stu))) %*% rot
    x.stu[,c("PC1", "PC2")] = as.matrix(x.stu[,c("PC1", "PC2")]) %*% rot
    main = paste(method, nrow(x.ref))
    col = as.integer(x.ref$popu) + 1
    plot(x.ref[,3:4], main=main, col=col, xlim=lim, ylim=lim)
    points(x.stu[,3:4], col=1, pch=15)
    lapply(1:nrow(c.ref), function(i) draw.circle(c.ref$C1[i], c.ref$C2[i], c.ref$r[i], border=i+1, lty=5, lwd=3))
    c.stu = aggregate(x.stu[,c("PC1", "PC2")], by = list(x.stu$popu), FUN = mean)
    colnames(c.stu) = c("popu", "C1", "C2")
    x.stu = merge(x.stu, c.stu)
    x.stu$r = sqrt(rowSums((x.stu[,c("PC1", "PC2")] - x.stu[,c("C1", "C2")])^2))
    c.stu = merge(c.stu, aggregate(data.frame(r=x.stu$r), by=list(popu=x.stu$popu), FUN=function(x) quantile(x, radius)))
    # points(c.stu$C1, c.stu$C2, pch=17, cex=3, col='orange')
    lapply(1:nrow(c.stu), function(i) draw.circle(c.stu$C1[i], c.stu$C2[i], c.stu$r[i], border=1, lty=5, lwd=3))
}
dev.off()
