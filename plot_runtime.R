args = commandArgs(trailingOnly=T)
infile = args[1]
x = read.table(infile, row.names=1, header=T)
png("data/runtimes/runtimes.png", 1000, 1000)
n = as.numeric(rownames(x))
num.centers = 4
num.study = 200
n = n*num.centers - num.study
par(cex=2)
ylim = c(0, max(x))
plot(n, x$sp, ylim=ylim, col=1, pch=1, type="b", xlab="reference size", ylab="study time (sec)", main="study time vs. reference size", xaxt="n")
axis(side=1, at=n, labels=T)
points(n, x$ap, col=2, pch=2, type="b")
points(n, x$oadp, col=3, pch=3, type="b")
points(n, x$adp, col=4, pch=4, type="b")
legend("topleft", legend=toupper(c("sp", "ap", "oadp", "adp")), col=1:4, pch=1:4, lty=1)
dev.off()

