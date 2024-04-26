from turtle import right


class SkyObj:
    def __init__(self):
        ngc_number=""
        name=""
        type=""
        constellation=""
        ra=""
        dec=""
        ha=0
        alt=0
        azimuth=0
        mag_app=0
    
    def print(self):
        print("-"*10)
        print("ngc_id : "+self.ngc_number)
        if self.name!="":
            print("name : "+self.name)
        print("type : "+self.type)
        print("constellation : "+self.constellation)
        print("ra : "+self.ra)
        print("dec : "+self.dec)
        print("apparent magnitude : "+self.mag_app)



def printRaw(starObject):
    print("|{}|{}|{}|{}|{}|{}|{}".format(starObject.ngc_number,starObject.name,starObject.type,starObject.constellation,starObject.ra,starObject.dec,starObject.mag_app))
          

def saveList(inputList,pathDestination): #save a list of skyObjects
    with open(pathDestination,"wt", encoding='utf-8', errors="ignore") as f:
        for x in inputList:
            f.write("|{}|{}|{}|{}|{}|{}|{}".format(x.ngc_number,x.name,x.type,x.constellation,x.ra,x.dec,x.mag_app)+"\n")

def readList(inputFileList):
    listToRet=[]
    with open(inputFileList,"rt", encoding="utf-8", errors="ignore") as f:
        data=f.read().splitlines()
    for d in data:
        parametersData=d.split("|")
        s = SkyObj()
        s.ngc_number=parametersData[1]
        s.name=parametersData[2]
        s.type=parametersData[3]
        s.constellation=parametersData[4]
        s.ra=parametersData[5]
        s.dec=parametersData[6]
        s.mag_app=parametersData[7]
        listToRet.append(s)

    return listToRet