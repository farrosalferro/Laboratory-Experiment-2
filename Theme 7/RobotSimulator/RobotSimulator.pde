PShape base, shoulder, upArm, loArm, end;
float rotX, rotY=2*PI;

float posX=0, posY=0, posZ=0;
float theta1, theta2, theta3;
float offset=15;

float L1 = 25;
float L2 = 50;
float L3 = 65;
float L4 = 15; // Only for drawing end effector offset

float[] Xsphere = new float[99]; 
float[] Ysphere = new float[99];
float[] Zsphere = new float[99];


void setup() {
  size(800, 800, OPENGL);
  base = loadShape("r5.obj");
  shoulder = loadShape("r1.obj");
  upArm = loadShape("r2.obj");
  loArm = loadShape("r3.obj");
  end = loadShape("r4.obj");

  shoulder.disableStyle();
  upArm.disableStyle();
  loArm.disableStyle();
  
  //Initial Position of Spheres
  for (int i=0; i< Xsphere.length ; i++) {
    Xsphere[i] = posX;
    Ysphere[i] = posY;
    Zsphere[i] = posZ-11;
  }
}

void draw() { 
  
  background(255, 255, 255);
  smooth();
  lights(); 
  directionalLight(200, 200, 200, -1, 0, 0);
  noStroke();

  translate(width/2, height/2);
  rotateX(rotX);
  rotateY(-rotY);
  scale(-3);
  updateParameters();
  drawRobot(theta1, theta2, theta3, color(#FFE308));
  drawEndpoint();
  
}


void mouseDragged() {
  rotY -= (mouseX - pmouseX) * 0.01;
  rotX -= (mouseY - pmouseY) * 0.01;
}

void drawEndpoint(){
  for (int i=0; i< Xsphere.length - 1; i++) {
    Xsphere[i] = Xsphere[i + 1];
    Ysphere[i] = Ysphere[i + 1];
    Zsphere[i] = Zsphere[i + 1];
  }

  Xsphere[Xsphere.length - 1] = posX;
  Ysphere[Ysphere.length - 1] = posY;
  Zsphere[Zsphere.length - 1] = posZ-11;
  
  for (int i=0; i < Xsphere.length; i++) {
    pushMatrix();
    translate(-Ysphere[i], Zsphere[i], -Xsphere[i]);
    fill (#FF0000, 25);
    sphere (float(i) / 30);
    popMatrix();
  }
}

void drawRobot(float theta1, float theta2, float theta3, color c) {
  pushMatrix();
  fill(c);  
  translate(0, -40, 0);   
  shape(base);

  translate(0, 4, 0);
  rotateY(theta1);
  shape(shoulder);

  translate(0, L1, 0);
  rotateY(PI);
  rotateX(-theta2);
  shape(upArm);

  translate(0, 0, L2);
  rotateY(PI);
  rotateX(theta3);
  shape(loArm);

  translate(0, 0, -L3+L4);
  rotateY(PI);
  shape(end);
  popMatrix();
}
