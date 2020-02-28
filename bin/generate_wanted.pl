use strict;
my $y;
for($y=1998;$y<2021;$y++){
 print "wget --no-check-certificate -O ${y}-01.html 'https://www.usgodae.org/cgi-bin/argo_select.pl?startyear=${y}&startmonth=01&startday=01&endyear=${y}&endmonth=03&endday=31&Nlat=90&Wlon=-180&Elon=180&Slat=-90&dac=ALL&floatid=ALL&gentype=txt&.submit=++Go++&.cgifields=endyear&.cgifields=dac&.cgifields=delayed&.cgifields=startyear&.cgifields=endmonth&.cgifields=endday&.cgifields=startday&.cgifields=startmonth&.cgifields=gentype'\n";
 print "wget --no-check-certificate -O ${y}-02.html 'https://www.usgodae.org/cgi-bin/argo_select.pl?startyear=${y}&startmonth=04&startday=01&endyear=${y}&endmonth=06&endday=30&Nlat=90&Wlon=-180&Elon=180&Slat=-90&dac=ALL&floatid=ALL&gentype=txt&.submit=++Go++&.cgifields=endyear&.cgifields=dac&.cgifields=delayed&.cgifields=startyear&.cgifields=endmonth&.cgifields=endday&.cgifields=startday&.cgifields=startmonth&.cgifields=gentype'\n";
 print "wget --no-check-certificate -O ${y}-03.html 'https://www.usgodae.org/cgi-bin/argo_select.pl?startyear=${y}&startmonth=07&startday=01&endyear=${y}&endmonth=09&endday=30&Nlat=90&Wlon=-180&Elon=180&Slat=-90&dac=ALL&floatid=ALL&gentype=txt&.submit=++Go++&.cgifields=endyear&.cgifields=dac&.cgifields=delayed&.cgifields=startyear&.cgifields=endmonth&.cgifields=endday&.cgifields=startday&.cgifields=startmonth&.cgifields=gentype'\n";
 print "wget --no-check-certificate -O ${y}-04.html 'https://www.usgodae.org/cgi-bin/argo_select.pl?startyear=${y}&startmonth=10&startday=01&endyear=${y}&endmonth=12&endday=31&Nlat=90&Wlon=-180&Elon=180&Slat=-90&dac=ALL&floatid=ALL&gentype=txt&.submit=++Go++&.cgifields=endyear&.cgifields=dac&.cgifields=delayed&.cgifields=startyear&.cgifields=endmonth&.cgifields=endday&.cgifields=startday&.cgifields=startmonth&.cgifields=gentype'\n";
}
print <<EOF
echo 'ProfileRef,Date,Time,Lat,Lon,FloatID,DAC,ProfileID' > profiles.csv
grep -h option  *.html  | grep profile | grep nc | sed -e 's/^.*value="//' -e 's#</option>##' -e 's#">#|#' -e 's#\s##g' -e 's#|#,#g' -e 's#[NE],#,#g' >> profiles.csv
echo "rm *.html"
EOF

