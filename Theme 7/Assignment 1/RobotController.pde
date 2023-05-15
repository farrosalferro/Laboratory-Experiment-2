float millisOld;
float gTime; //Time in Seconds

// start point
float xa = 10, ya = 20, za = 40;
// end point
float xb = 60, yb = 50, zb = 70;
// Motion start time
float t0 = 3;
// Motion end time
float tf = 8;
// position variables for the 1st law
float posX_1, posY_1, posZ_1;

float motionLaw5th(float s_0, float s_f, float t_0, float t_f, float t){
  t = t - t_0;
  t_f = t_f - t_0;
  float dt = t/t_f;
  float ds = s_f - s_0;
  if (t <= tf){
    return s_0 + 10 * ds * pow(dt, 3) - 15 * ds * pow(dt, 4) + 6 * ds * pow(dt, 5);
  }
  else {
    return s_f;
  }
}

float motionLaw1st(float s_0, float s_f, float t_0, float t_f, float t){
  t = t - t_0;
  t_f = t_f - t_0;
  float dt = t/t_f;
  float ds = s_f - s_0;
  if (t <= tf){
    return s_0 + ds * dt;
  }
  else {
    return s_f;
  }
}

void IK(){
  float d1 = sqrt(pow(posX, 2) + pow(posY, 2) + pow(posZ, 2));
  float d2 = sqrt(pow(posX, 2) + pow(posY, 2));
  theta1 = atan2(posY, posX);
  theta3 = acos((pow(d1, 2) - pow(L2, 2) - pow(L3, 2)) / (2 * L2 * L3));
  theta2 = atan2(posZ, d2) - atan2(L3 * sin(theta3),  L2 + L3 * cos(theta3));
}

// 1st assignment: 1st and 5th order
void updateParameters(){ 
  setTime();
  if(gTime <= t0){
    posX = xa;
    posY = ya;
    posZ = za;
    posX_1 = xa;
    posY_1 = ya;
    posZ_1 = za;
  } else if (gTime > t0 && gTime <= tf){
    posX = xa + (xb - xa) * motionLaw5th(0, 1, t0, tf, gTime);
    posY = ya + (yb - ya) * motionLaw5th(0, 1, t0, tf, gTime);
    posZ = za + (zb - za) * motionLaw5th(0, 1, t0, tf, gTime);
    posX_1 = xa + (xb - xa) * motionLaw1st(0, 1, t0, tf, gTime);
    posY_1 = ya + (yb - ya) * motionLaw1st(0, 1, t0, tf, gTime);
    posZ_1 = za + (zb - za) * motionLaw1st(0, 1, t0, tf, gTime);
    
  } 
  else {
    posX = xb;
    posY = yb;
    posZ = zb;
    posX_1 = xb;
    posY_1 = yb;
    posZ_1 = zb;
  }

  IK();
  println(gTime + "," + posX + "," + posY + "," + posZ+  "," + posX_1 + "," + posY_1 + "," + posZ_1);
}

void setTime(){
  gTime += ((float)millis()/1000 - millisOld);  
  millisOld = (float)millis()/1000;
}
