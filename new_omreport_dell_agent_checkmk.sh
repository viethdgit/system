#! /bin/sh

cat > /usr/lib/check_mk_agent/local/check_raid.sh << EOF
OUTPUT=""
RAID_STATUS=\`omreport storage vdisk |grep "^ID\|^Status"|sed -e ':a' -e 'N' -e '\$!ba' -e 's/\nStatus/ /g'\`
while IFS= read -r line ; 
do if [[ "\$line" != *"Ok"* ]];then
   OUTPUT=\$OUTPUT"\\\nRAID "\$(echo \$line| awk '{print \$1,\$3,\$5}')
   fi
done <<< "\$RAID_STATUS"
#echo \$OUTPUT
if [ "\$OUTPUT" == "" ];then
  echo "0 RAID - RAID OK"
else
  echo "2 RAID - RAID ERROR"\$OUTPUT
fi
EOF

cat > /usr/lib/check_mk_agent/local/check_disk.sh << EOF
OUTPUT=""
DISK_STATUS=\`omreport storage pdisk controller=0 | grep "^ID\|^Status\|^Bus\|^Media\|^Capacity"|sed -e ':a' -e 'N' -e '\$!ba' -e 's/\n/ /g'|sed -e 's/ID/\nID/g'|grep ID\`
while IFS= read -r line ; 
do if [[ "\$line" != *"Ok"* ]];then
   OUTPUT=\$OUTPUT"\\\nDisk "\$(echo \$line| awk '{print \$3,\$10,\$13,\$16,\$17,\$6}')
   fi
done <<< "\$DISK_STATUS"
#echo \$OUTPUT
if [ "\$OUTPUT" == "" ];then
  echo "0 DISK - DISK OK"
else
  echo "2 DISK - DISK ERROR"\$OUTPUT
fi
EOF


cat > /usr/lib/check_mk_agent/local/check_ram.sh << EOF
OUTPUT=""
RAM_STATUS=\`omreport chassis memory |grep "^Status\|^Connector\|^Size\|^Type"|sed -e ':a' -e 'N' -e '\$!ba' -e 's/\n/ /g'|sed -e 's/Status/\nStatus/g'| grep -v "Unknown Connector"|grep Status\`
while IFS= read -r line ; 
do if [[ "\$line" != *"Ok"* ]];then
   OUTPUT=\$OUTPUT"\\\RAM "\$(echo \$line| awk '{print \$7,\$10,\$17,\$18,\$3}')
   fi
done <<< "\$RAM_STATUS"
#echo \$OUTPUT
if [ "\$OUTPUT" == "" ];then
  echo "0 RAM - RAM OK"
else
  echo "2 RAM - RAM ERROR"\$OUTPUT
fi
EOF

cat > /usr/lib/check_mk_agent/local/check_power.sh << EOF
OUTPUT=""
POWER_STATUS=\`omreport chassis pwrsupplies |grep "^Status\|^Location"|sed -e ':a' -e 'N' -e '\$!ba' -e 's/\nLocation/ /g'\`
while IFS= read -r line ; 
do if [[ "\$line" != *"Ok"* ]];then
   OUTPUT=\$OUTPUT"\\\POWER "\$(echo \$line| awk '{print \$5,\$6,\$3}')
   fi
done <<< "\$POWER_STATUS"
#echo \$OUTPUT
if [ "\$OUTPUT" == "" ];then
  echo "0 POWER - POWER OK"
else
  echo "2 POWER - POWER ERROR"\$OUTPUT
fi
EOF

cat > /usr/lib/check_mk_agent/local/check_cpu.sh << EOF
OUTPUT=""
CPU_STATUS=\`omreport chassis processors |grep "^Status\|^Connector\|^Processor Brand"|sed -e ':a' -e 'N' -e '\$!ba' -e 's/\n/ /g'|sed -e 's/Status/\nStatus/g'|grep -v "Unknown Connector"|grep Status\`
while IFS= read -r line ; 
do if [[ "\$line" != *"Ok"* ]];then
   #echo \$line| awk '{printf \$7;printf " ";for (i=11; i<=NF; i++) printf \$i FS;print \$3}'
   OUTPUT=\$OUTPUT"\\\CPU "\$(echo \$line| awk '{printf \$7;printf " ";for (i=11; i<=NF; i++) printf \$i FS;print \$3}')
   fi
done <<< "\$CPU_STATUS"
if [ "\$OUTPUT" == "" ];then
  echo "0 CPU - CPU OK"
else
  echo "2 CPU - CPU ERROR"\$OUTPUT
fi
EOF






