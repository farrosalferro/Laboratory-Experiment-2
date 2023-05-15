float millisOld;
float gTime; //Time in Seconds

// start point
float xa = 50, ya = 50, za = 40;
// end point
float xb = 60, yb = 50, zb = 70;
// motion start time
float t0 = 3;
// motion end time
float tf = 8;
// radius
  float r = 30;

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

void IK(){
  float d1 = sqrt(pow(posX, 2) + pow(posY, 2) + pow(posZ, 2));
  float d2 = sqrt(pow(posX, 2) + pow(posY, 2));
  theta1 = atan2(posY, posX);
  theta3 = - acos((pow(d1, 2) - pow(L2, 2) - pow(L3, 2)) / (2 * L2 * L3));
  theta2 = atan2(posZ, d2) - atan2(L3 * sin(theta3),  L2 + L3 * cos(theta3));
}


 //2nd assignment: circle
void updateParameters(){
  setTime();
  if(gTime < t0){
    posX = xa + r;
    posY = ya;
    posZ = za;
  } else if (gTime > t0 && gTime <= tf){
    posX = xa + r * cos(2 * PI * motionLaw5th(0, 1, t0, tf, gTime));
    posY = ya;
    posZ = za + r * sin(2 * PI * motionLaw5th(0, 1, t0, tf, gTime));
  } 
  else {
    posX = xa + r;
    posY = ya;
    posZ = za;
  }

  IK();
  println(gTime + "," + posX + "," + posY + "," + posZ);
}

void setTime(){
  gTime += ((float)millis()/1000 - millisOld);  
  millisOld = (float)millis()/1000;
}
