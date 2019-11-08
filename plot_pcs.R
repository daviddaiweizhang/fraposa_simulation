rm(list=ls())
library(plotrix)
set.seed(123)

radius = 0.9
methods = c("sp", "ap", "oadp", "adp")
lim = c(-35, 35)
num.pcs = 2
pc.names = paste0("PC", c(1:num.pcs))

# read reference samples
args = commandArgs(trailingOnly=TRUE)
inpref = ifelse(length(args) >= 1, args[1], "data/n300s50/a")
x.ref = read.table(paste0(inpref, "_ref.pcs"))
colnames(x.ref) = c("popu", "id", "PC1", "PC2")

# read reference singular values
s.ref = scan(paste0(inpref, "_ref_s.dat"))
pc.contrib = round(s.ref[1:2]^2 / sum(s.ref^2), 4)

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
c.ref.scale = rowSums(as.matrix(c.ref[,c("C1", "C2")])^2)
fun = function(popu){
    y = x.ref[x.ref$popu == popu,]
    y = y[sample(nrow(y), nstu),]
    d = colMeans(y[,c("PC1", "PC2")]) - c.ref[c.ref$popu == popu, c("C1", "C2")]
    sum(d^2)
}
nrep = 100
msd.nulldist = sqrt(sapply(1:nrep, function(x) mean(sapply(c.ref$popu, fun) / c.ref.scale)))
msd.nullmean = round(mean(msd.nulldist), 3)
msd.nullsd = round(sd(msd.nulldist), 3)

msd.all = c(nrow(x.ref))
png(paste0(inpref, ".png"), 2000, 2000)
par(mfrow=c(2,2), cex=2, oma = c(4, 0, 4, 0))
for(method in methods){
    x.stu = x.stu.all[[method]]

    x.stu[,c("PC1", "PC2")] = as.matrix(x.stu[,c("PC1", "PC2")]) %*% rot
    c.stu = aggregate(x.stu[,c("PC1", "PC2")], by = list(x.stu$popu), FUN = mean)
    colnames(c.stu) = c("popu", "C1", "C2")
    stu.pch = 14

    main = toupper(method)
    xlab = paste0("PC1 (contribution=", pc.contrib[1], ")")
    ylab = paste0("PC2 (contribution=", pc.contrib[2], ")")
    col.ref = as.integer(x.ref$popu) + 1
    plot(x.ref[,3:4], main=main, col=col.ref, xlim=lim, ylim=lim, xlab=xlab, ylab=ylab)

    pch.stu = as.integer(x.stu$popu) + stu.pch
    points(x.stu[,3:4], col=1, pch=pch.stu)
    lapply(1:nrow(c.ref), function(i) draw.circle(c.ref$C1[i], c.ref$C2[i], c.ref$r[i], border=i+1, lty=5, lwd=3))
    x.stu = merge(x.stu, c.stu)
    x.stu$r = sqrt(rowSums((x.stu[,c("PC1", "PC2")] - x.stu[,c("C1", "C2")])^2))
    c.stu = merge(c.stu, aggregate(data.frame(r=x.stu$r), by=list(popu=x.stu$popu), FUN=function(x) quantile(x, radius)))
    lapply(1:nrow(c.stu), function(i) draw.circle(c.stu$C1[i], c.stu$C2[i], c.stu$r[i], border=1, lty=5, lwd=3))
    msd = sqrt(mean(rowSums((c.stu[,c("C1", "C2")] - c.ref[,c("C1", "C2")])^2) / c.ref.scale))
    msd = round(msd, 3)
    legend("bottomleft", legend=paste("sqrtMSD:", msd))
    msd.all = c(msd.all, msd)
}
supertitle = paste0(
		    "PC 1&2 of simulated genotypes\n",
		    "(reference size: ", nrow(x.ref),
		    ", study size: ", nrow(x.stu),
		    ", null sqrtMSD mean: ", msd.nullmean,
		    ", null sqrtMSD sd: ", msd.nullsd, ")")
mtext(supertitle, outer = TRUE, cex=3)
des.ref = paste("Popu.", 1:4, "ref.")
des.stu = paste("Popu.", 1:4, "stu.")
legend(-110, -60, xpd="NA", legend=c(des.ref, des.stu), pch=c(rep(1,4), (1:4)+stu.pch), col=c((1:4)+1, rep(1,4)), ncol=8)
dev.off()
write(msd.all, paste0(inpref, "_msd"), ncolumns=length(msd.all), sep="\t")


out.filename = paste0(inpref, "_scatter.png")
print(out.filename)
png(out.filename, 3000, 4000)
pairs = cbind(
    c(4,3,4,3,4,2),
    c(3,2,2,1,1,1))
par(mfcol=c(num.pcs*2, nrow(pairs)/2), cex=3)
for(i in 1:nrow(pairs)){
    pair = pairs[i,]
    method = c(methods[pair[1]], methods[pair[2]])
    msd = sqrt(mean(as.matrix(x.stu.all[[method[1]]][, pc.names] - x.stu.all[[method[2]]][, pc.names])^2))
    msd = round(msd, 3)
    print(paste(method[1], method[2], msd))
    for(j in 1:num.pcs){
	pc.name = pc.names[j]
        a = x.stu.all[[method[1]]][[pc.name]]
        b = x.stu.all[[method[2]]][[pc.name]]
        lim = c(min(a, b), max(a, b))
        xlab = paste(toupper(method[1]), pc.name)
        ylab = paste(toupper(method[2]), pc.name)
	main = ""
	if(j == 1) main = paste(toupper(method[1]), " vs ", toupper(method[2]), " (sqrtMSD: ", msd, ")")
        plot(a, b, xlab=xlab, ylab=ylab, main=main, xlim=lim, ylim=lim)
        abline(0,1)
        abline(v=0)
        abline(h=0)
    }
}
dev.off()
