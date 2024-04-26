import os

data=[]

for x in os.listdir("dataLists"):
    with open("./dataLists/"+x,"rt") as f:
        data+=f.read().splitlines()

print(len(data))

with open("./data/all.txt","wt") as f:
    for x in data:
        f.write(x+"\n")