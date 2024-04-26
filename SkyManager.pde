import java.time.*;

float startTime = 0;
float deltaTime = 0;
float[] timerPrint ={0,0}; //start time/deltaTime
float virtualTimer=0;
float virtualTimeSpeed=1;
float elapsedDays=0;
float lst=0;
class SkyManager
{
  String[] ngcCatalogue;
  CelestialBody[] stars;
  ArrayList<CelestialBody> toPrint=new ArrayList();
  
  float sky_diameter=400;
  float starsDistance=(sky_diameter/2)+3;
  int grid_azimuth=5;  //gradi per cella azimuth
  int grid_alt=5;     //gradi per cella altezza
  
  float[][] grid_data; //alt_step,alt_diameter
  
  
  float longitude = 12 +(6/60.0)+(34.92/3600.0);//    12 6 34.92
  float latitude =  43+(8/60.0)+(52.44/3600.0);//     43 8 52.44
  float latitude_calc=latitude*(PI/180.0);
  float skyRotation=0;
  float skyAngularVel=0.01745;
  
  
  LocalDateTime j2000=LocalDateTime.of(2000,1,1,12,0);
  LocalDateTime timeNow;//= LocalDateTime.now();
  LocalDateTime virtualTime;
  Duration timeDelta;// = Duration.between(j2000,timeNow);
  OffsetDateTime gmt;// = LocalDateTime.now(ZoneId.of("GMT"));
  //LocalDateTime gmt;
  float ut;// = gmt.getHour() + (gmt.getMinute()/60.0) + (gmt.getSecond()/3600.0);

  private SkyManager()
  {
     println("Inizializzato lo sky manager");
     ngcCatalogue = loadStrings("ngcLess13-5-dec.txt");
     
     stars = new CelestialBody[ngcCatalogue.length];
     
     println("Catalogo da : "+stars.length + " corpi celesti");
     
     virtualTime = LocalDateTime.now();
     initGrid();

  }
  
  private void initGrid()
  {
    PVector linea;
    grid_data=new float[int(90/grid_alt)][2];
    for (int c=0;c<int(90/grid_alt);c++)
    {
      linea=PVector.fromAngle(grid_alt*c*PI/180.0);
      linea.setMag(sky_diameter/2);
      grid_data[c][0]=linea.y;
      grid_data[c][1]=sqrt( pow((sky_diameter/2.0),2)-pow((linea.y),2.0) )*2.0;
    }
  }
  
  private void testRndStars()
  {
    testRndStars(100);
  }
  
  private void testRndStars(int n)
  {
    
    stars=new CelestialBody[n];
    for(int x=0;x<n;x++)
    {
      stars[x]=new CelestialBody();
      stars[x].fraio_id="test_"+x;
      stars[x].ngc="id_"+x;
      stars[x].name="Test_"+x;
      stars[x].constellation="Fraio";
      stars[x].type="type_test";
      stars[x].ra=0;
      stars[x].dec=0;
      stars[x].alt=random(-90,90)*(PI/180);;
      stars[x].azimuth=random(0,360)*(PI/180);
      stars[x].mag_app=random(-1.0,13.5);
      stars[x].dimension[0] = random((sky_diameter*178.0)/10800.0); stars[x].dimension[1] = random((sky_diameter*178.0)/10800.0); 
      stars[x].distance=random(4,10000);
      
      //stars[x].position=new PVector(random(-sky_diameter,sky_diameter),random(-sky_diameter,sky_diameter),random(-sky_diameter,sky_diameter));
      stars[x].position = new PVector(0,0,-1);

      stars[x].position = rotateVector(stars[x].position,stars[x].alt,0,0);
      stars[x].position = rotateVector(stars[x].position,0,stars[x].azimuth,0);
      stars[x].position.setMag(starsDistance);
      
      stars[x].startPosition = stars[x].position.copy();
      stars[x].initBody();
    }

  }
  
  private void initStars()
  {
    
    updateTimeData();
    for(int c=0;c<ngcCatalogue.length;c++)
    {
      String[] data = split(ngcCatalogue[c],"|");
      stars[c]=new CelestialBody();
      
      stars[c].ngc=data[1];
      stars[c].name=data[2];
      stars[c].constellation=data[4];
      stars[c].type=data[3];
      stars[c].ra=float(data[5]);
      stars[c].dec=float(data[6]);
      stars[c].mag_app=float(data[7]);
      
      updateStarAltAz(c);
      
      
      stars[c].position = new PVector(0,0,-1);
      println(stars[c].ngc);
      println(stars[c].alt);
      println(stars[c].azimuth);
      println("----");
      
      float alt = -stars[c].alt*(PI/180.0);
      float azimuth = -(stars[c].azimuth +180)*(PI/180.0);
      stars[c].position = new PVector(0,0,0);
      stars[c].position.x=starsDistance * cos(alt) * sin(azimuth);
      stars[c].position.y=starsDistance * sin(alt);
      stars[c].position.z=starsDistance * cos(alt) * cos(azimuth);


      if (stars[c].name!="")
      {
       stars[c].messageToPrint=stars[c].name.split(";")[0];//+"\n"+stars[c].type;
      }
      else
      {
        stars[c].messageToPrint="NGC_"+stars[c].ngc.split(";")[0];//+"\n"+stars[c].type;
      }
      
      stars[c].drawLuminosity=255-(255*(1/13.5)*stars[c].mag_app);
      stars[c].drawSize=30-(30*(1/13.5)*stars[c].mag_app);
      println(stars[c].position);
      
    }
    

    //debugStars();
    //delay(100000);
  }
  
  private void drawGrid()
  {
    strokeWeight(1);
    stroke(0,127,63);

    float toRot[] = {PI/2.0,0.01745*grid_azimuth};
    for (int c=0;c<180/grid_azimuth;c++)
    {
      
      circle(0,0,sky_diameter);
      rotateY(toRot[1]);
    }
    
    rotateX(toRot[0]);  
    for (int c=0;c<grid_data.length;c++)
    {
      translate(0,0,grid_data[c][0]);
      circle(0,0,grid_data[c][1]);
      translate(0,0,-grid_data[c][0]);
    }
    
    rotateX(-toRot[0]);
    rotateY(-toRot[1]*180);

  }

  private void drawCursor()
  {
    stroke(0,255,127);
    strokeWeight(1);
    translate(0,0,-180);
    
    circle(0,0,10);
    
    stroke(0,255,127,127\);
    line(-5,0,5,0);
    line(0,-5,0,5);
    
    translate(0,0,180);
  }
  
  private void printCardinals()
  {
     textAlign(CENTER);
     fill(0,255,255);
     int cardinalDist = -180;
     text("N",0,0,cardinalDist);
     rotateY(PI/2.0);
     text("W",0,0,cardinalDist);
     rotateY(PI/2.0);
     text("S",0,0,cardinalDist);
     rotateY(PI/2.0);
     text("E",0,0,cardinalDist);
     
     rotateY(-(PI/2.0)*3);
     noFill();
  }
  
  private void printStars(float telescopeRotX,float telescopeRotY)
  {
    textSize(4);
    textAlign(LEFT);
    strokeWeight(1);
    stroke(255,255,0,100);
    float azi =((telescopeRotX*180.0/PI)+360)%360 ;
    float alt = telescopeRotY*180/PI;
    float range=10;//degrees
    
    
    //timerPrint[1]=millis()-timerPrint[0];
    //if (timerPrint[1]>=20)
    //{
      //timerPrint[0]=millis();
      toPrint=new ArrayList();
      for(int c=0;c<stars.length;c++)
      {
        if ((azi>=(stars[c].azimuth) -range && azi<=(stars[c].azimuth)+range) && (alt>=(stars[c].alt)-range && alt<=(stars[c].alt)+range))
        {
          toPrint.add(stars[c]);
        }
      }
    //}
    
    
    CelestialBody starToPrint;
    for (int c=0;c<toPrint.size();c++)
    {
        
        fill(255,0,255,255);
        starToPrint=toPrint.get(c);
        pushMatrix();
        translate(starToPrint.position.x,starToPrint.position.y,starToPrint.position.z);
        rotateY(-telescopeRotX);
        rotateX(-telescopeRotY);
        
        float centerAzi = azi-(starToPrint.azimuth);//*(180/PI));
        float centerAlt = alt-(starToPrint.alt);//*(180/PI));

        float dist = sqrt(pow(centerAzi,2)+pow(centerAlt,2));
        float angle = atan2(centerAzi,centerAlt)+(PI/2);
        
        PVector printDir = PVector.fromAngle(angle);//(PI/180)*18*c);
        
        printDir.setMag(10+(dist/10)*50);
        
        PVector printDir2=PVector.fromAngle(angle-(PI/4));
        printDir2.setMag(10);
        printDir2.x+=printDir.x;
        printDir2.y+=printDir.y;
        
        
        strokeWeight(1);
        strokeWeight(1+(2-((dist/10)*2)));
        fill((dist/10)*255,255,255-((dist/10)*255));
        line(0,0,printDir.x,printDir.y);
        line(printDir.x,printDir.y,printDir2.x,printDir2.y);

        textSize(4+(2- ((dist/10)*2)   ));

        text(starToPrint.messageToPrint,printDir2.x,printDir2.y,0);

        popMatrix();
    }
    
    textSize(12);
  }
  
  private void printMoreData()
  {
     CelestialBody starToPrint;
     String printBox="";
     for (int c=0;c<toPrint.size();c++)
     {
       starToPrint = toPrint.get(c);
       printBox+="NGC_"+starToPrint.ngc+" : "+starToPrint.type+"\n";
     }
     fill(255);
     textAlign(LEFT);
     text(printBox,10,10);
     println(printBox);
  }
  
  private void drawStars()
  {
    strokeWeight(5);
    stroke(0,127,255);
    
    for(int c=0;c<stars.length;c++)
    {
      //stars[c].position = rotateVector(stars[c].startPosition,0,-skyRotation,0);
      //stars[c].position = rotateVector(stars[c].position,(90-latitude) * PI/180.0,0,0);
      point(stars[c].position.x,stars[c].position.y,stars[c].position.z);
    }
    
    
    blendMode(ADD);
    for(int c=0;c<stars.length;c++)
    {
      stroke(0,127,255,stars[c].drawLuminosity);
      strokeWeight(stars[c].drawSize);
      point(stars[c].position.x,stars[c].position.y,stars[c].position.z);
    }
    blendMode(BLEND);
  }
  
  private float getAltFromPos(PVector position)
  {
    return asin(-position.y/starsDistance);
  }
  
  private float getAziFromPos(PVector position)
  {
    float azimuth = atan2(-position.x,position.z);
    if (azimuth<PI)
      {azimuth+=PI;}
    else
    {
       azimuth-=PI; 
    }
    return azimuth;
  }
  
  private void updateSkyRotation()
  {
    deltaTime = millis()-startTime;
    if (deltaTime>10)
    {
      startTime=millis();
      updateStarsAltAz();
      //skyRotation+=skyAngularVel/100;
      //skyRotation += skyAngularVel*deltaTime/1000.0;
     // for(int c=0;c<stars.length;c++)
     // {
        //stars[c].position = rotateVector(stars[c].startPosition,0,-skyRotation,0);
      //  stars[c].position = rotateVector(stars[c].position,(90-latitude) * PI/180.0,0,0);
        
      //   stars[c].azimuth=getAziFromPos(stars[c].position);
       //  stars[c].alt = getAltFromPos(stars[c].position);
        
     // }
    }
  }
  
  private void updateTimeData()
  {
    if (virtualTimeMode)
    {
      updateVirtualData();
      timeNow=virtualTime;
    }
    else
    {
      timeNow = LocalDateTime.now();
    }
    //timeNow = LocalDateTime.of(2023,11,11,22,00,00);
    
    timeDelta = Duration.between(j2000,timeNow);
    elapsedDays = (timeDelta.getSeconds()/86400.0);
    //gmt = LocalDateTime.now(ZoneId.of("GMT"));
    
    
    //gmt = timeNow.zoneOffset(ZoneOffset.UTC);
    //gmt = ZonedDateTime.ofInstant(timeNow,ZoneOffset.UTC,ZoneId.of("GMT"));
    gmt=timeNow.atZone(ZoneId.of("Europe/Rome")).toOffsetDateTime().withOffsetSameInstant(ZoneOffset.UTC);
    //println(timeNow);
    //println(gmt);
  // gmt = timeNow;
    
    
    
    ut = gmt.getHour() + (gmt.getMinute()/60.0) + (gmt.getSecond()/3600.0);
    lst = (100.46+ (0.985647 *elapsedDays) +longitude + (15*ut))%360;
      //println("longitude :",longitude);
      //println("latitude : ",latitude);
      //println("now : ",timeNow);
      //println("timedelta : ",timeDelta);
      //println("elapsedDays : ",elapsedDays);
      //println("gmt : ",gmt);
      //println("ut : ",ut);
      //println("lst : ",lst);
  }
  
  private void updateVirtualData()
  {
    float elapsedTimer=millis()-virtualTimer;
    if (elapsedTimer>=10)
    {
      virtualTime = virtualTime.plus(Duration.ofMillis((long) (elapsedTimer * virtualTimeSpeed)));
      virtualTimer=millis();
    }
  }
  
  private void updateStarsAltAz()
  {
    
    updateTimeData();
    
    for (int c=0;c<stars.length;c++)
    {
      stars[c].ha=(lst-stars[c].ra)%360;
      //float ra=stars[c].ra* (PI/180.0);
      float dec=stars[c].dec* (PI/180.0);
      stars[c].ha*=(PI/180.0);
      
      stars[c].alt = asin ( ( sin(dec)*sin(latitude_calc)  ) + ( cos(dec)*cos(latitude_calc)*cos(stars[c].ha))) *180/PI;

      stars[c].azimuth = atan2( (-cos(dec)*(sin(stars[c].ha))) , (cos(latitude_calc)*sin(dec))-( sin(latitude_calc)*cos(dec)*cos(stars[c].ha)))*(180/PI);
      if (stars[c].azimuth<0){stars[c].azimuth+=360;}
      
      
      float alt = -stars[c].alt*(PI/180.0);
      float azimuth = -(stars[c].azimuth +180)*(PI/180.0);
      stars[c].position.x=starsDistance * cos(alt) * sin(azimuth);
      stars[c].position.y=starsDistance * sin(alt);
      stars[c].position.z=starsDistance * cos(alt) * cos(azimuth);
    }
  }

  private void updateStarAltAz(int index)
  {
    //updateTimeData();

      stars[index].ha=(lst-stars[index].ra)%360;
      //float ra=stars[index].ra* (PI/180.0);
      float dec=stars[index].dec* (PI/180.0);
      stars[index].ha*=(PI/180.0);
      
      stars[index].alt = asin ( ( sin(dec)*sin(latitude_calc)  ) + ( cos(dec)*cos(latitude_calc)*cos(stars[index].ha))) *180/PI;

      stars[index].azimuth = (atan2( (-cos(dec)*(sin(stars[index].ha))) , (cos(latitude_calc)*sin(dec))-( sin(latitude_calc)*cos(dec)*cos(stars[index].ha)))*(180/PI)   ) ;
      if (stars[index].azimuth<0){stars[index].azimuth+=360;}//println(254%360);
      //println(stars[index].ngc,"   ",stars[index].alt,"   ",stars[index].azimuth,"   ");
  }
  
  
  private void debugStars()
  {
    for(int c=0;c<stars.length;c++)
    {
      debugStar(c);
    }
  }
  private void debugStar(int index)
  {
    println("-----",stars[index].ngc,"-----");
    println("name: ",stars[index].name);
    println("constellation: ",stars[index].constellation);
    println("type: ",stars[index].type);
    println("ra: ",stars[index].ra);
    println("dec: ",stars[index].dec);
    println("ha: ",stars[index].ha);
    println("alt: ",stars[index].alt);
    println("azimuth: ",stars[index].azimuth);
    println("mag_app: ",stars[index].mag_app);
  }
  
};
