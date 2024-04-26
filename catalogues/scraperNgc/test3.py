import datetime
import math
import SkyManager
ngcs = SkyManager.readList("./data/ngcLess13-5-dec.txt")

longitude = 12 +(6/60)+(34.92/3600)#    12 6 34.92
latitude =  43+(8/60)+(52.44/3600)#     43 8 52.44
j2000=datetime.datetime(2000,1,1,12)


now = datetime.datetime.now()
timeDelta =now-j2000

elapsedDays = timeDelta.days+ (timeDelta.seconds/3600/24) #days elapsed in decimal form
gmt= datetime.datetime.now(datetime.timezone.utc)
ut = gmt.hour+ (gmt.minute/60)+ (gmt.second/3600)

lst = (100.46+ (0.985647 *elapsedDays) +longitude + (15*ut))%360

print("longitude :",longitude)
print("latitude : ",latitude)
print("now : ",now)
print("timedelta : ",timeDelta)
print("elapsedDays : ",elapsedDays)
print("gmt : ",gmt)
print("ut : ",ut)
print("lst : ",lst)

input()

for s in ngcs:
    s.print()
    s.ra=float(s.ra)
    s.dec=float(s.dec)

    s.ha=(lst-s.ra)%360

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