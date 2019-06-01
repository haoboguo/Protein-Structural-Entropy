fasta <- c()
proset <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y")
rdmnum <- c(1:20)

rdmlength <- c(50:800)

for (k in 1:500) {
    rdmseq <- c()
    j <- head(sample(rdmlength)[1])
    for (i in 1:j) {
        k <- head(sample(rdmnum)[1])
        rdmseq <- paste(rdmseq, proset[k], sep="")
    }
    fasta <- rbind(fasta, rdmseq)
}

write.table(fasta, file="random.fasta", col.names=F, row.names=F, quote=F)
