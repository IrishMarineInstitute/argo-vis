#!/usr/bin/env python3
from lxml import html
import requests
import re
from datetime import datetime, timedelta, date
import os
from time import sleep
from calendar import monthrange
import tempfile

politeness = 1.0

urlpattern = 'https://www.usgodae.org/cgi-bin/argo_select.pl?startyear={start_year}&startmonth={start_month}&startday={start_day}&endyear={end_year}&endmonth={end_month}&endday={end_day}&Nlat=90&Wlon=-180&Elon=180&Slat=-90&dac=ALL&floatid=ALL&gentype=txt&.submit=++Go++&.cgifields=endyear&.cgifields=dac&.cgifields=delayed&.cgifields=startyear&.cgifields=endmonth&.cgifields=endday&.cgifields=startday&.cgifields=startmonth&.cgifields=gentype'

def daterange(start_date, end_date):
    for n in range(int ((end_date - start_date).days)):
        yield start_date + timedelta(n)

def months(date1, date2):
    prev = date(1,1,1)
    for day in daterange(date1, date2):
        first = date(day.year,day.month,1)
        if not first == prev:
            prev = first
            last = date(day.year,day.month,monthrange(day.year,day.month)[1])
            yield (first,last)

def wanted(fnames):
    start_dt = date(1998,1,1)
    today = datetime.today()
    recent = (today - timedelta(days=45)).date()
    end_dt = today.date()
    for (first,last) in months(start_dt, end_dt):
         fname = "{0}.txt".format(first.strftime("%Y-%m-%d"))
         fnames.append(fname)
         filename = "/data/{0}".format(fname)
         result = (first,last,filename)
         if first >= recent or not os.path.exists(filename):
             yield result

filenames = []
for (start_day,end_day,filename) in wanted(filenames):
    sleep(politeness)
    print(filename)
    url = urlpattern.format(start_year=start_day.year,
                            start_month="{:02d}".format(start_day.month),
                            start_day="{:02d}".format(start_day.day),
                            end_year=end_day.year,
                            end_month="{:02d}".format(end_day.month),
                            end_day="{:02d}".format(end_day.day))
    page = requests.get(url, verify=False)
    tree = html.fromstring(page.content)
    data = tree.xpath("//option[contains(@value,'/profile')][contains(@value,'.nc')]/text()")
    data = [re.sub('[NE],',',',re.sub('\s*\|\s*',',',line)) for line in data]
    tmpfile = filename+next(tempfile._get_candidate_names())
    try:
      with open(tmpfile, mode='wt', encoding='utf-8') as out:
        out.write('\n'.join(data))
        out.write('\n')
      os.rename(tmpfile,filename)
    finally: 
        try:
            if os.exists(tmpfile):
                os.remove(tmpfile)
        except:
            pass

with open("/data/index.txt", mode='wt', encoding='utf-8') as out:
     out.write('\n'.join(filenames))


