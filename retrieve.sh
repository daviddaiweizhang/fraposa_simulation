#!/bin/bash
set -e

root=$1
cd $root

rm -f tmp_out
for n in `seq 300 125 800`; do
    echo $n
    for method in sp ap oadp; do
        runtime=`grep -A 1 'data/n'"$n"'s50/tmp/''[0-9]\+.[0-9]\{9\}''/a_'"$method"'.pcs' *.log | tail -n1 | cut -d' ' -f3`
        # runtime=$( cat tmp | grep -A 1 --no-group-separator a_"${method}".pcs | awk 'NR % 2 == 0' | cut -d' ' -f3 | Rscript -e 'x=scan("stdin", quiet=T); cat(mean(x), "\n")' )
        echo $method $n $runtime >> tmp_out
    done

    grep -h -A 100 -B 100 'data/n'"$n"'s50/tmp/''[0-9]\+.[0-9]\{9\}''/a_adp.ProPC.coord' *.log | grep "[0-9] [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} 20[0-9]\{2\}" | grep -B 1 --no-group-separator 'Finished at: ' > tmp_timestamps
    cat tmp_timestamps | awk 'NR % 2 == 1' > tmp_start
    cat tmp_timestamps | awk 'NR % 2 == 0' | cut -d':' -f2- > tmp_end

    for tmp_file in tmp_start tmp_end; do
        rm -f ${tmp_file}_epoch
        while read line; do
            date --date="$line" +"%s" >> ${tmp_file}_epoch
        done < $tmp_file
    done

    runtime_adp=$( paste tmp_start_epoch tmp_end_epoch | awk '{ print $2 - $1 }' | Rscript -e 'x=scan("stdin", quiet=T); cat(mean(x), "\n")' )
    echo adp $n $runtime_adp >> tmp_out
done

cut -d' ' -f3 tmp_out | Rscript -e 'x=scan("stdin"); x=matrix(x, 5, 4, byrow=T); x=round(x,2); colnames(x)=c("sp", "ap", "oadp", "adp"); rownames(x)=seq(300, 800, 125); write.table(x, "runtimes.tab", quote=F)'
cat runtimes.tab
rm tmp tmp_*
