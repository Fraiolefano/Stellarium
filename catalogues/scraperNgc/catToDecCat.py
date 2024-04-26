import datetime
import math
import SkyManager
ngcs = SkyManager.readList("./data/ngcLess13-5.txt")

for s in ngcs:
    s.print()
    ra_data = s.ra.split(" ")
    if (len(ra_data)==3):
        s.ra = (float(ra_data[0][:-1])+(float(ra_data[1][:-1])/60)+(float(ra_data[2][:-1])/3600))*15
    elif (len(ra_data)==2):
        s.ra = (float(ra_data[0][:-1])+(float(ra_data[1][:-1])/60))*15
    else:
        s.ra = (float(ra_data[0][:-1]))*15

    dec_data =s.dec.split(" ")

    isNegative=False
    if dec_data[0][0]=="-":
        isNegative=True
        dec_data[0]=dec_data[0][1:]

    if (len(dec_data)==3):
        s.dec = (float(dec_data[0][:-1])+(float(dec_data[1][:-1])/60)+(float(dec_data[2][:-2])/3600))
    elif (len(dec_data)==2):
        s.dec = (float(dec_data[0][:-1])+(float(dec_data[1][:-1])/60))
    else:
        s.dec = (float(dec_data[0][:-1]))
    
    if isNegative:
        s.dec*=-1


    #s.ra*=math.pi/180
    #s.dec*=math.pi/180
    #s.ha*=math.pi/180

SkyManager.saveList(ngcs,"./data/ngcLess13-5-dec.txt")