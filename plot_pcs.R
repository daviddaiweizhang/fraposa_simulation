rm(list=ls())
library(plotrix)

radius = 0.9
methods = c("sp", "ap", "oadp", "adp")
lim = c(-35, 35)

# read reference samples
args = commandArgs(trailingOnly=TRUE)
inpref = ifelse(length(args) >= 1, args[1], "data/c300/a")
x.ref = read.table(paste0(inpref, "_ref.pcs"))
colnames(x.ref) = c("popu", "id", "PC1", "PC2")
# x.ref = x.ref[order(x.ref$popu),]

# get reference centers
c.ref = aggregate(x.ref[,c("PC1", "PC2")], by = list(x.ref$popu), FUN = mean)
colnames(c.ref) = c("popu", "C1", "C2")

# rotate the samples
basis = c.ref[1:2, 2:3]
basis = basis / sqrt(rowSums(basis^2))
fortyfive = 1/sqrt(2) * matrix(c(1,-1,1,1), 2, 2)
rot = as.matrix(solve(basis) %*% fortyfive)
x.ref[,c("PC1", "PC2")] = as.matrix(x.ref[,c("PC1", "PC2")]) %*% rot
c.ref[,c("C1", "C2")] = as.matrix(c.ref[,c("C1", "C2")]) %*% rot

# add population center to each sample
x.ref = merge(x.ref, c.ref)
x.ref$r = sqrt(rowSums((x.ref[,c("PC1", "PC2")] - x.ref[,c("C1", "C2")])^2))
c.ref = merge(c.ref, aggregate(data.frame(r=x.ref$r), by=list(popu=x.ref$popu), FUN=function(x) quantile(x, radius)))

# read study samples
x.stu.all = list()
for(method in methods){
    x.stu = read.table(paste0(inpref, "_", method, ".pcs"))
    colnames(x.stu) = c("popu", "id", "PC1", "PC2")
    x.stu.all[[method]] = x.stu
}
nstu = sum(x.stu.all[[1]]$popu == c.ref$popu[1])

# find the null distribution of MSD
fun = function(popu){
    y = x.ref[x.ref$popu == popu,]
    y = y[sample(nrow(y), nstu),]
    d = colMeans(y[,c("PC1", "PC2")]) - c.ref[c.ref$popu == popu, c("C1", "C2")]
    sum(d^2)
}
nrep = 100
msd.nulldist = sapply(1:nrep, function(x) mean(sapply(c.ref$popu, fun)))
msd.nullmean = mean(msd.nulldist)

msd.all = c(nrow(x.ref))
png(paste0(inpref, ".png"), 2000, 2000)
par(mfrow=c(2,2), cex=2)
for(method in methods){
    x.stu = x.stu.all[[method]]
    # x.stu = x.stu[order(x.stu$popu),]

    x.stu[,c("PC1", "PC2")] = as.matrix(x.stu[,c("PC1", "PC2")]) %*% rot
    c.stu = aggregate(x.stu[,c("PC1", "PC2")], by = list(x.stu$popu), FUN = mean)
    colnames(c.stu) = c("popu", "C1", "C2")
    stu.pch = 14
    main = paste0(method, ' (ref. size = ', nrow(x.ref), ')')
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
    msd = mean(rowSums((c.stu[,c("C1", "C2")] - c.ref[,c("C1", "C2")])^2))
    msd = round(msd, 3)
    relmsd = msd / msd.nullmean
    relmsd = round(relmsd, 3)
    legend("bottomleft", legend=paste(c("abs.", "rel."), "MSD:", c(msd, relmsd)))
    msd.all = c(msd.all, msd)
}
dev.off()
write(msd.all, paste0(inpref, "_msd"), ncolumns=length(msd.all), sep="\t")

