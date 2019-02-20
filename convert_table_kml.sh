#!/usr/bin/bash

# Get table from shared directory as a TSV
curl "https://docs.google.com/spreadsheets/d/1N7CjkpUITPmj3ObOvTZnH8AtgmsinqOJ_ZR2MNJFnVI/export?format=tsv&id=1N7CjkpUITPmj3ObOvTZnH8AtgmsinqOJ_ZR2MNJFnVI&gid=0" -o data.tsv


# Remove headers from data.tsv
sed -i data.tsv -e "1,6d"

#cat data.tsv | awk -F'\t' '{print $2, $5, $4, $9, $8}' 
#cat data.tsv | awk -F'\t' '{print "<name>",$2,"</name><description>","$5," CCS / ",$4," total</description><Point>",$9,",",$8,"</Point>"}' 
cat data.tsv | awk -F'\t' '{print "<Placemark><name>",$3,"</name><description><![CDATA[CCS: ",$5,"<br>Address: ",$3,"<br>Country: ",$1,"]]></description><styleUrl>STYLE</styleUrl><ExtendedData><Data name=\"CCS\"><value>",$5,"</value></Data><Data name=\"Address\"><value>",$3,"</value></Data><Data name=\"Country\"><value>",$1,"</value></Data></ExtendedData><Point><coordinates>",$9,",0</coordinates></Point></Placemark>"}' | sed -e "s/\([0-9.\-]\+\) *, *\([0-9.\-]\+\) *, *0/\2, \1, 0/"> data.kml

rm -f doc.kml
cat << EOF >> doc.kml
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
    <name>TESLA CCS SUPERCHARGERS</name>
    <description>Tesla Supercharger with CCS for Model 3</description>
    <Style id="icon-ci-1-labelson">
      <IconStyle>
        <scale>1.1</scale>
        <Icon>
          <href>images/icon-1.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Folder>
      <name>SUPERCHARGER CCS</name>
EOF


#grep "> *0\? *CCS" data.kml | sed -e "s/> *CCS/> 0 CCS/" -e "s/STYLE/#icon-1899-C2185B/" -e "s/>/\n>/g" >> doc.kml
grep -v "CCS: *0\? *<br" data.kml | sed -e "s/STYLE/#icon-ci-1-labelson/" >> doc.kml



cat << EOF >> doc.kml
</Folder>
</Document>
</kml>
EOF


zip 'TESLA CCS SUPERCHARGERS.kmz' doc.kml images/*





#curl "https://docs.google.com/spreadsheets/d/1N7CjkpUITPmj3ObOvTZnH8AtgmsinqOJ_ZR2MNJFnVI/export?format=tsv&id=1N7CjkpUITPmj3ObOvTZnH8AtgmsinqOJ_ZR2MNJFnVI&gid=770972283" -o tesla_data.tsv
