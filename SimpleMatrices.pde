public float[][] multiplyMatrix(float matA[][],float[][] matB)
{
  int rowsA=matA.length;
  int colsA=matA[0].length;
  int rowsB=matB.length;
  int colsB=matB[0].length;
  
  if (colsA!=rowsB)
  {
    println("("+rowsA+"x"+colsA+") |"+" ("+rowsB+"x"+colsB+")");
    println("Errore, la moltiplicazione di matrici richiede che le colonne della prima matrice debbano combaciare con le righe della seocnda");
    return new float[][]{{0}};
  }
  
  float[][] output=new float[rowsA][colsB];
  for (int r=0;r<rowsA;r++)
  {
    for (int cb=0;cb < colsB;cb++)
    {
        for (int ca=0;ca < colsA;ca++)
        {
          output[r][cb]+=matA[r][ca]*matB[ca][cb];
        }
    }
  }
  
  return output;
}

public float[][] rotateMatrix(float[][] matrixInput,float xRotation,float yRotation,float zRotation)
{
  
  float[][] rotX=//roll
  {
    {1,0,0},
    {0,cos(xRotation),-sin(xRotation)},
    {0,sin(xRotation),cos(xRotation)}
  };
  
  float[][] rotY=//pitch
  {
    {cos(yRotation),0,sin(yRotation)},
    {0,1,0},
    {-sin(yRotation),0,cos(yRotation)}
  };
  
  float[][] rotZ=//yaw
  {
    {cos(zRotation),-sin(zRotation),0},
    {sin(zRotation),cos(zRotation),0},
    {0,0,1}
  };
  matrixInput = multiplyMatrix(rotX,matrixInput);
  matrixInput = multiplyMatrix(rotY,matrixInput);
  matrixInput = multiplyMatrix(rotZ,matrixInput);
  return matrixInput;
}

public PVector rotateVector(PVector inputVector,float xRotation,float yRotation,float zRotation)
{
  float [][] inputMatrix = vecToMat(inputVector,false);
  inputMatrix = rotateMatrix(inputMatrix,xRotation,yRotation,zRotation);
  return matToVec(inputMatrix);
}

public float[][] vecToMat(PVector inputV)
{
  return vecToMat(inputV,true);
}
public float[][] vecToMat(PVector inputV,boolean type) //0 = vettore riga, 1 = vettore colonna
{
  float[][] toRet;
  if (type==false)//(3x1)
  {
    toRet=new float[3][1];
    toRet[0][0]=inputV.x;
    toRet[1][0]=inputV.y;
    toRet[2][0]=inputV.z;
  }
  else//(1x3)
  {
    toRet=new float[1][3];
    toRet[0][0]=inputV.x;
    toRet[0][1]=inputV.y;
    toRet[0][2]=inputV.z;
  }
  return toRet;
}

public PVector matToVec(float[][] inputMat)
{
  PVector toRet=new PVector(0,0,0);
  if (inputMat.length==3)//matrice a colonna in vettore
  {
    toRet.x=inputMat[0][0];
    toRet.y=inputMat[1][0];
    toRet.z=inputMat[2][0];
  }
  else if(inputMat.length==1)//matrice a riga in vettore
  {
    toRet.x=inputMat[0][0];
    toRet.y=inputMat[0][1];
    toRet.z=inputMat[0][2];
  }
  return toRet;
}

public void printMatrix(float [][] inputMat)
{
  println("("+inputMat.length+","+inputMat[0].length+")");
  for (int r=0;r<inputMat.length;r++)
  {
    print("|");
    for (int c=0;c<inputMat[r].length;c++)
    {
       print(inputMat[r][c]);
       if (c<inputMat[r].length-1)
       {
         print("  ");
       }
    }
    print("|");
    println();
  }
}
