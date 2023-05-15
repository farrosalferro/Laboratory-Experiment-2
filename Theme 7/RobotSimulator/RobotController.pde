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

float motionLaw3rd(float s_0, float s_f, float t_0, float t_f, float t){
  t = t - t_0;
  t_f = t_f - t_0;
  float dt = t/t_f;
  float ds = s_f - s_0;
  if (t <= t_f / 3){
    return s_0 + 3 * ds * pow(dt, 2) - 2 * ds * pow(dt, 3);
  } 
  else {
    return s_f;
  }
}

float motionLawTrapezoid(float s_0, float s_f, float t_0, float t_f, float t){
  t = t - t_0;
  t_f = t_f - t_0;
  float dt = t/t_f;
  float ds = s_f - s_0;
  if (t < t_f / 3){
    return s_0 + 9 * ds * pow(dt, 2) / 4
  
  } else if (t_f / 3 <= t && t < 2 * t_f / 3){
    return s_0 + ds * (dt - 1) / 4
  
  } else if (2 * t_f / 3 <= t && t < t_f){
    return s_f - 9 * ds * pow(1 - dt, 2) / 4 
    
  } else {
    return s_f;
  }

}

void IK(){
  float d1 = sqrt(pow(posX, 2) + pow(posY, 2) + pow(posZ, 2));
  float d2 = sqrt(pow(posX, 2) + pow(posY, 2));
  theta1 = atan2(posY, posX);
  theta3 = - acos((pow(d1, 2) - pow(L2, 2) - pow(L3, 2)) / (2 * L2 * L3));
  theta2 = atan2(posZ, d2) - atan2(L3 * sin(theta3),  L2 + L3 * cos(theta3));
}

// Principles
//void updateParameters(){ 
//  setTime();
  
//   //For forward kinematics
//  //theta1 = PI/3;
//  //theta2 = PI;
//  //theta3 = 5*PI/6;
  
//  // For inverse kinematics
//  posX = 15;
//  posY = 15;
//  posZ = 5;
  
//  IK();
//  println(theta1 + "," + theta2 + "," + theta3);
//}

// 1st assignment: 1st and 5th order
void updateParameters(){ 
  float posX_1, posY_1, posZ_1;
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


// 2nd assignment: circle
//void updateParameters(){
//  float r = 30;
//  setTime();
//  if(gTime < t0){
//    posX = xa + r;
//    posY = ya;
//    posZ = za;
//  } else if (gTime > t0 && gTime <= tf){
//    posX = xa + r * cos(2 * PI * motionLaw5th(0, 1, t0, tf, gTime));
//    posY = ya;
//    posZ = za + r * sin(2 * PI * motionLaw5th(0, 1, t0, tf, gTime));
//  } 
//  else {
//    posX = xa + r;
//    posY = ya;
//    posZ = za;
//  }
//
//  IK();
//  println(gTime, posX + "," + posY + "," + posZ);
//}

void updateParameters(){ 
  float posX_1, posY_1, posZ_1;
  float posX_3, posY_3, posZ_3;
  float posX_t, posY_t, posZ_t;
  setTime();
  if(gTime <= t0){
    posX = xa;
    posY = ya;
    posZ = za;
    posX_1 = xa;
    posY_1 = ya;
    posZ_1 = za;
    posX_3 = xa;
    posY_3 = ya;
    posZ_3 = za;
    posX_t = xa;
    posY_t = ya;
    posZ_t = za;
  } else if (gTime > t0 && gTime <= tf){
    posX = xa + (xb - xa) * motionLaw5th(0, 1, t0, tf, gTime);
    posY = ya + (yb - ya) * motionLaw5th(0, 1, t0, tf, gTime);
    posZ = za + (zb - za) * motionLaw5th(0, 1, t0, tf, gTime);
    posX_1 = xa + (xb - xa) * motionLaw1st(0, 1, t0, tf, gTime);
    posY_1 = ya + (yb - ya) * motionLaw1st(0, 1, t0, tf, gTime);
    posZ_1 = za + (zb - za) * motionLaw1st(0, 1, t0, tf, gTime);
    posX_3 = xa + (xb - xa) * motionLaw3rd(0, 1, t0, tf, gTime);
    posY_3 = ya + (yb - ya) * motionLaw3rd(0, 1, t0, tf, gTime);
    posZ_3 = za + (zb - za) * motionLaw3rd(0, 1, t0, tf, gTime);
    posX_t = xa + (xb - xa) * motionLawTrapezoid(0, 1, t0, tf, gTime);
    posY_t = ya + (yb - ya) * motionLawTrapezoid(0, 1, t0, tf, gTime);
    posZ_t = za + (zb - za) * motionLawTrapezoid(0, 1, t0, tf, gTime);
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
