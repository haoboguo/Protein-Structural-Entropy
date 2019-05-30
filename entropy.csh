#!/bin/csh -f

# ./entropy.csh proteome.fasta
set file = $1
# the sequences are saved in a single line
set gene = `grep '>' $file | awk '{print $1}'`
set line = `grep -n '>' $file | sed 's/:/ /g' | awk '{print $1}'`
set dat = $file:r.entropy.dat
set csv = $file:r.entropy.csv
set tmp = $file:r.tmp
set idp = $file:r.idp
set test = $file:r.test
set i = 0
#formating, if using csv format?
echo Gene Capacity Entropy Info lnC IE >> $dat # | awk '{printf "%-10s %-10s %-10s %-10s %-10s %-10s\n", $1,$2,$3,$4,$5,$6}' >> $dat
while ($i < $#gene)
    @ i++
    set v1 = `echo $line[$i] + 1 | bc -l`
    sed -n $v1,$v1\p $file > $tmp
#this line runs vsl2 programe using java
    java -jar /home/hguo/soft/VSL2/VSL2.jar -s:$tmp > $idp
    set loc = `grep -n '=========' $idp | sed 's/:/ /g' | awk '{print $1}'`
    set first = `echo $loc[1] +3 | bc -l`
    set last = `echo $loc[2] - 1 | bc -l`
    sed -n $first,$last\p $idp | awk '{print $3}' > $test
    set j = 0
    set val = 0
    set loop = `cat $test`
    set capa = `cat $test | wc -l | awk '{print $1}'`
    while ($j < $#loop)
        @ j++
        set ent = `echo $loop[$j]/2 | bc -l`
    if ($ent == 0) then
        set val = `echo $val | bc -l`
    else
        set val = `echo $val - \(\($ent \* l\($ent\) + \(1-$ent\)\*l\(1-$ent\)\) \/ l\(2\)\) | bc -l`
    endif
    end
    set info = `echo $capa - $val | bc -l`
    set lnc  = `echo l\($capa\) | bc -l`
    set ratio = `echo $info \/ $val | bc -l`
    echo $gene[$i] $capa $val $info $lnc $ratio >> $dat
    rm $tmp
    rm $idp
    rm $test
end

cat $dat | sed "s/ /,/g" > $csv
