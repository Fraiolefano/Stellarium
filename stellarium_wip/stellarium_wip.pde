float distPos =422;
int w=1300;
int h = 1000;
PVector center=new PVector(w/2.0,h/2.0,780);
float angleRotation =0;


SkyManager sm;
float sphereDiameter=400;


//float starsOmega = 0.01745;
float totalStarsRotation =0;
//float elapsedTime = millis();


float altezza=0;
float azimut=0;


boolean printNames = false;
boolean printMoreData = false;
boolean virtualTimeMode = false;
//magMax 13.5
void setup()
{
  
   sm=new SkyManager();
   //sm.testRndStars(2000);
   sm.initStars();
   frameRate(60);
   size(1300,1000,P3D);
   ellipseMode(CENTER);
   rectMode(CENTER);
   textAlign(CENTER);
   noCursor();
}
  float rotYLimited = 0;
void draw()
{
  background(0);
  printFramerate();
  printLatitude();
  printOmega();
  if(virtualTimeMode){printVirtualTime();}
  if (printMoreData && distPos>600){sm.printMoreData();}
  translate(center.x,center.y,0+ distPos);//center.z+mouseX);
  noFill();
  float rotX =  ((mouseX-(width/2.0))/(width*1.0))*2*PI  ;//(mouseX/((width-20)*1.0))*2*PI;///width*1.0)*2.0*PI;//(((mouseX-(width/2.0))/(width*1.0))*2.0*PI)   +(PI/2.0) ;
  float rotY =((mouseY-(height/2.0))/(height))*1.0*PI;
  
  
  if (distPos<600)
  {
     rotYLimited=rotY;
  }
  else
  {
         
  }
  if (rotY>0 && rotY<1.7)
  {
    rotYLimited = rotY;
  }
  if (mouseX!=0)
  {
    rotateY(rotX);
  }

 if(mouseY!=0)
   {
     rotateY(-rotX);
     rotateX(rotYLimited);
     rotateY(rotX);
   }
   if (distPos>600)
   {
      sm.printCardinals();
   }
  
  sm.drawGrid();
  sm.drawStars();
//  sm.printStars();
  
  
  if (distPos>600)
  {
     if (printNames) {sm.printStars(rotX,altezza);}
     rotateY(-rotX);
     rotateX(-rotYLimited);
     
     altezza = rotYLimited;
     azimut = rotX;
     printTelescopeCoordinates();
     sm.drawCursor();
     
  }
  
  sm.updateSkyRotation();

}
  
  
  void printFramerate()
  {
    textAlign(CENTER);
    fill(255);
    text("Framerate : "+nf(frameRate,0,2),width-50,height-25);
    noFill();
  }
  
  void printLatitude()
  {
    textAlign(CENTER);
    fill(255);
    text("Latitude : "+sm.latitude,50,height-25);
    noFill();
  }
  void printOmega()
  {
    textAlign(CENTER);
    fill(255);
    text("Time Speed : "+virtualTimeSpeed,200,height-25);
    //text("Angular Velocity : "+nf(sm.skyAngularVel*(180.0/PI),0,2)+"°",200,height-25);
    noFill();
  }
  void printTelescopeCoordinates()
  {
    textAlign(CENTER);
    textSize(6);
    fill(255);
    text(nf(altezza*(180.0/PI),0,2)+"°,"+nf((((azimut*180.0/PI)+360)%360),0,2)+"°",25,10,-180);
    noFill();
    textSize(12);
  }
  void printVirtualTime()
  {
    textAlign(CENTER);
    text(""+sm.virtualTime,width/2.0,height-10);
  }
  
  
  void keyPressed()
  {
     if (key=='+')
     {
       if (sm.latitude<90){sm.latitude+=1;}
     }
     else if(key=='-')
     {
       if (sm.latitude>-90){sm.latitude-=1;}
     }
     else if(key=='w')
     {
       sm.skyAngularVel+=PI/180.0;
       virtualTimeSpeed+=10;
     }
     else if(key=='s')
     {
        sm.skyAngularVel-=PI/180.0;
        virtualTimeSpeed-=10;
     }
     else if (key=='p')
     {
       printNames=!printNames;
     }
     else if (key=='o')
     {
        printMoreData=!printMoreData; 
     }
     else if(key=='t')
     {
       virtualTimeMode=!virtualTimeMode;
     }
     else if(key=='z')
     {
      virtualTimeSpeed=0; 
     }
     else if(key==' ')
     {
       sm.virtualTime=LocalDateTime.now();
     }
     
  }
  void mouseWheel(MouseEvent wheel)
  {
    if (wheel.getCount()<0)
    {
      distPos+=20;
      if (distPos>780)
      {
         distPos=780; 
      }
    }
    else
    {
      distPos-=20;
    }
    
  }
