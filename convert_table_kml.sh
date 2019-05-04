#!/usr/bin/bash

# Get table from shared directory as a TSV
curl "https://docs.google.com/spreadsheets/d/1N7CjkpUITPmj3ObOvTZnH8AtgmsinqOJ_ZR2MNJFnVI/export?format=tsv&id=1N7CjkpUITPmj3ObOvTZnH8AtgmsinqOJ_ZR2MNJFnVI&gid=0" -o data.tsv


mkdir -p backup
cp data.tsv backup/$(date +%Y%m%d_%H%M%S)_data.tsv

# Remove headers from data.tsv
sed -i data.tsv -e "1,6d" # remove headers
sed  -n '/^[^\t]/p' -i data.tsv # remove empty lines (starting with \t, as country column is empty

#cat data.tsv | awk -F'\t' '{print $2, $5, $4, $9, $8}' 
#cat data.tsv | awk -F'\t' '{print "<name>",$2,"</name><description>","$5," CCS / ",$4," total</description><Point>",$9,",",$8,"</Point>"}' 

rm -f doc.kml
cat << EOF >> doc.kml
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
    <name>TESLA CCS SUPERCHARGERS</name>
    <description>Tesla Supercharger with CCS for Model 3</description>
    <Style id="empty-0"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/empty-0.png</href> </Icon> </IconStyle> </Style> 
    <Style id="empty-1"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/empty-1.png</href> </Icon> </IconStyle> </Style> 
    <Style id="empty-2"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/empty-2.png</href> </Icon> </IconStyle> </Style> 
    <Style id="empty-3"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/empty-3.png</href> </Icon> </IconStyle> </Style> 
    <Style id="empty-4"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/empty-4.png</href> </Icon> </IconStyle> </Style> 
    <Style id="partial-0"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/partial-0.png</href> </Icon> </IconStyle> </Style> 
    <Style id="partial-1"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/partial-1.png</href> </Icon> </IconStyle> </Style> 
    <Style id="partial-2"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/partial-2.png</href> </Icon> </IconStyle> </Style> 
    <Style id="partial-3"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/partial-3.png</href> </Icon> </IconStyle> </Style> 
    <Style id="partial-4"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/partial-4.png</href> </Icon> </IconStyle> </Style> 
    <Style id="full-0"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/full-0.png</href> </Icon> </IconStyle> </Style> 
    <Style id="full-1"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/full-1.png</href> </Icon> </IconStyle> </Style> 
    <Style id="full-2"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/full-2.png</href> </Icon> </IconStyle> </Style> 
    <Style id="full-3"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/full-3.png</href> </Icon> </IconStyle> </Style> 
    <Style id="full-4"> <IconStyle> <scale>1.1</scale> <Icon> <href>images/full-4.png</href> </Icon> </IconStyle> </Style> 
    <Folder>
      <name>SUPERCHARGER CCS</name>
EOF


#grep "> *0\? *CCS" data.kml | sed -e "s/> *CCS/> 0 CCS/" -e "s/STYLE/#icon-1899-C2185B/" -e "s/>/\n>/g" >> doc.kml
#grep -v "CCS: *0\? */" data.kml | grep -v "CCS: \+\([0-9]\+\) \+/ \+\1 \+<" | sed -e "s/STYLE/#icon-ci-1-labelson/" >> doc.kml
#grep "CCS: *0\? */" data.kml | sed -e "s/STYLE/#icon-ci-2-labelson/" >> doc.kml
#grep -v "CCS: *0\? */" data.kml | grep "CCS: \+\([0-9]\+\) \+/ \+\1 \+<" | sed -e "s/STYLE/#icon-ci-3-labelson/" >> doc.kml

cat data.tsv | awk -F'\t' '{ccs=0+(($7>$5)?$7:$5); print "<Placemark><name>",$2,"</name><description><![CDATA[CCS: ",ccs," / ", $4,"<br>Address: ",$3,"<br>Country: ",$1,"]]></description><styleUrl>", ((ccs>=$4) ? "#full-":(ccs > 0)?"#partial-":"#empty-") int($4/10),"</styleUrl><ExtendedData><Data name=\"CCS\"><value>",ccs,"</value></Data><Data name=\"Total\"><value>",$4,"</value></Data><Data name=\"Address\"><value>",$3,"</value></Data><Data name=\"Country\"><value>",$1,"</value></Data></ExtendedData><Point><coordinates>",$12,",0</coordinates></Point></Placemark>"}' | sed -e "s/\([0-9.\-]\+\) *, *\([0-9.\-]\+\) *, *0/\2, \1, 0/"> data.kml

cat data.kml >> doc.kml

cat << EOF >> doc.kml
</Folder>
</Document>
</kml>
EOF


rm -f 'TESLA CCS SUPERCHARGERS.kmz' 
zip 'TESLA CCS SUPERCHARGERS.kmz' doc.kml images/*

cp doc.kml backup/$(date +%Y%m%d_%H%M%S)_doc.kml


xmllint doc.kml -noout


#curl "https://docs.google.com/spreadsheets/d/1N7CjkpUITPmj3ObOvTZnH8AtgmsinqOJ_ZR2MNJFnVI/export?format=tsv&id=1N7CjkpUITPmj3ObOvTZnH8AtgmsinqOJ_ZR2MNJFnVI&gid=770972283" -o tesla_data.tsv
