import datetime
import math
import SkyManager
ngcs = SkyManager.readList("./data/ngcLess13-5.txt")

longitude = 12 +(6/60)+(34.92/3600)#    12 6 34.92
latitude =  43+(8/60)+(52.44/3600)#     43 8 52.44
j2000=datetime.datetime(2000,1,1,12)
now = datetime.datetime.now()
timeDelta =now-j2000
elapsedDays = timeDelta.days+ (timeDelta.seconds/3600/24) #days elapsed in decimal form
gmt= datetime.datetime.now(datetime.timezone.utc)
ut = gmt.hour+ (gmt.minute/60)+ (gmt.second/3600)
lst = (100.46+ (0.985647 *elapsedDays) +longitude + (15*ut))%360

for s in ngcs:
    s.print()
    ra_data = s.ra.split(" ")
    if (len(ra_data)==3):
        s.ra = (float(ra_data[0][:-1])+(float(ra_data[1][:-1])/60)+(float(ra_data[2][:-1])/3600))*15
    elif (len(ra_data)==2):
        s.ra = (float(ra_data[0][:-1])+(float(ra_data[1][:-1])/60))*15
    else:
        s.ra = (float(ra_data[0][:-1]))*15

    s.ha=(lst-s.ra)%360

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


    s.ra*=math.pi/180
    s.dec*=math.pi/180
    s.ha*=math.pi/180
    latitude_calc=latitude*(math.pi/180)
    
    s.alt = math.asin ( ( math.sin(s.dec)*math.sin(latitude_calc)  ) + ( math.cos(s.dec)*math.cos(latitude_calc)*math.cos(s.ha))) *180/math.pi

    s.azimuth = math.atan2( (-math.cos(s.dec)*(math.sin(s.ha))) , (math.cos(latitude_calc)*math.sin(s.dec))-( math.sin(latitude_calc)*math.cos(s.dec)*math.cos(s.ha)))*(180/math.pi)


    print("RA : ",s.ra)
    print("DEC : ",s.dec)
    print("HA : ",s.ha)
    print("Altezza : ",s.alt)
    print("Azimuth : ",s.azimuth)