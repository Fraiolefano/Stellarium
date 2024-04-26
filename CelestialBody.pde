class CelestialBody
{
        String fraio_id="";
        String ngc="";
        String name="";
        String constellation="";
        String type=""; //1=Open Cluster, 2=Globular Cluster, 3=Planetary Nebula, 4=Starforming Nebula (with open cluster), 5=Spiral Galaxy, 6=Elliptical Galaxy, 7=Irregular Galaxy, 8=Lenticular (S0) Galaxy, 9=Supernova Remnant, A=System of 4 stars or Asterism, B=Milky Way Patch, C=Binary star. 
        float ra=0;
        float dec=0;
        float ha=0;
        float alt=0;
        float azimuth=0;
        float mag_app=0;
        float[] dimension = {0,0};
        float distance=0;
        PVector position=new PVector(0,0,0);
        PVector startPosition=new PVector(0,0,0);
        
        float drawSize = 0;
        float drawLuminosity = 0;
        
        String messageToPrint="";
        private void initBody()
        {
          drawSize = 25*(dimension[0]/6.592);
          if (drawSize<10){drawSize=10;}
          
          drawLuminosity = 127-(127*(mag_app+1)/14.5); 
          if (drawLuminosity<50){drawLuminosity=50;}
        }
};
