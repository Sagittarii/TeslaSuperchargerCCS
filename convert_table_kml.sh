#!/usr/bin/bash

# Get table from shared directory as a TSV
curl "https://docs.google.com/spreadsheets/d/1N7CjkpUITPmj3ObOvTZnH8AtgmsinqOJ_ZR2MNJFnVI/export?format=tsv&id=1N7CjkpUITPmj3ObOvTZnH8AtgmsinqOJ_ZR2MNJFnVI&gid=0" -o data.tsv


# Remove headers from data.tsv
sed -i data.tsv -e "1,8d"

#cat data.tsv | awk -F'\t' '{print $2, $5, $4, $9, $8}' 
#cat data.tsv | awk -F'\t' '{print "<name>",$2,"</name><description>","$5," CCS / ",$4," total</description><Point>",$9,",",$8,"</Point>"}' 
cat data.tsv | awk -F'\t' '{print "<Placemark><name>",$2,"</name><description>",$5," CCS / ",$4," total</description><styleUrl>STYLE</styleUrl><Point><coordinates>",$9,",0</coordinates></Point></Placemark>"}' | sed -e "s/\([0-9.\-]\+\) *, *\([0-9.\-]\+\) *, *0/\2, \1, 0/"> data.kml

cat << EOF >> SUC_CCS.kml
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
    <Style id="icon-1899-0F9D58-normal">
      <IconStyle>
        <color>ff589d0f</color>
        <scale>1</scale>
        <Icon>
          <href>http://www.gstatic.com/mapspro/images/stock/503-wht-blank_maps.png</href>
        </Icon>
        <hotSpot x="32" xunits="pixels" y="64" yunits="insetPixels"/>
      </IconStyle>
      <LabelStyle>
        <scale>0</scale>
      </LabelStyle>
    </Style>
    <Style id="icon-1899-0F9D58-highlight">
      <IconStyle>
        <color>ff589d0f</color>
        <scale>1</scale>
        <Icon>
          <href>http://www.gstatic.com/mapspro/images/stock/503-wht-blank_maps.png</href>
        </Icon>
        <hotSpot x="32" xunits="pixels" y="64" yunits="insetPixels"/>
      </IconStyle>
      <LabelStyle>
        <scale>1</scale>
      </LabelStyle>
    </Style>
    <StyleMap id="icon-1899-0F9D58">
      <Pair>
        <key>normal</key>
        <styleUrl>#icon-1899-0F9D58-normal</styleUrl>
      </Pair>
      <Pair>
        <key>highlight</key>
        <styleUrl>#icon-1899-0F9D58-highlight</styleUrl>
      </Pair>
    </StyleMap>
 <Style id="icon-1899-C2185B-normal">
      <IconStyle>
        <color>ff5b18c2</color>
        <scale>1</scale>
        <Icon>
          <href>http://www.gstatic.com/mapspro/images/stock/503-wht-blank_maps.png</href>
        </Icon>
        <hotSpot x="32" xunits="pixels" y="64" yunits="insetPixels"/>
      </IconStyle>
      <LabelStyle>
        <scale>0</scale>
      </LabelStyle>
    </Style>
    <Style id="icon-1899-C2185B-highlight">
      <IconStyle>
        <color>ff5b18c2</color>
        <scale>1</scale>
        <Icon>
          <href>http://www.gstatic.com/mapspro/images/stock/503-wht-blank_maps.png</href>
        </Icon>
        <hotSpot x="32" xunits="pixels" y="64" yunits="insetPixels"/>
      </IconStyle>
      <LabelStyle>
        <scale>1</scale>
      </LabelStyle>
    </Style>
   <StyleMap id="icon-1899-C2185B">
      <Pair>
        <key>normal</key>
        <styleUrl>#icon-1899-C2185B-normal</styleUrl>
      </Pair>
      <Pair>
        <key>highlight</key>
        <styleUrl>#icon-1899-C2185B-highlight</styleUrl>
      </Pair>
    </StyleMap>
EOF


grep "> *0\? *CCS" data.kml | sed -e "s/> *CCS/> 0 CCS/" -e "s/STYLE/#icon-1899-C2185B/" >> SUC_CCS.kml
grep -v "> *0\? *CCS" data.kml | sed -e "s/STYLE/#icon-1899-0F9D58/" >> SUC_CCS.kml

echo '</Document></kml>' >> SUC_CCS.kml

