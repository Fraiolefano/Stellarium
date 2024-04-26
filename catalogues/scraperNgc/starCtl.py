from quopri import decodestring
import SkyManager
data =[]
skyObjs=[]

toAdd=[]
with open("./data/all.txt","rt",encoding='utf-8', errors="ignore") as f:
    data=f.read().splitlines()

# for d in data:
#     parametersData=d.split("|")
#     s = SkyObj()
#     s.ngc_number=parametersData[1]
#     s.name=parametersData[2]
#     s.type=parametersData[3]
#     s.constellation=parametersData[4]
#     s.ra=parametersData[5]
#     s.dec=parametersData[6]
#     s.mag_app=parametersData[7]
#     s.print()

for d in data:
    parametersData=d.split("|")
    s = SkyManager.SkyObj()
    s.ngc_number=parametersData[1]
    s.name=parametersData[2]
    s.type=parametersData[3]
    s.constellation=parametersData[4]
    s.ra=parametersData[5]
    s.dec=parametersData[6]
    s.mag_app=parametersData[7]
    if s.mag_app=="" or s.mag_app=="?" or s.mag_app=="N/A":
        s.mag_app="100"
    if "/" in s.mag_app:
        s.mag_app=s.mag_app.split("/")[0]

    s.print()
    if float(s.mag_app)<=13.5:
        toAdd.append(s)

for s in toAdd:
    s.print()
    SkyManager.printRaw(s);


SkyManager.save(toAdd,"./data/ngcLess13-5.txt")
print(len(toAdd))