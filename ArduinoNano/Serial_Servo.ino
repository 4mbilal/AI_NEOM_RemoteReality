#include <Servo.h>
uint8_t ypr_angle[3];
uint8_t ypr_cmd[3];
Servo yaw,pitch,roll;
uint8_t rcv;

void setup() {
  Serial.begin(115200);
  yaw.attach(3);
  pitch.attach(5);
  roll.attach(6);
  ypr_angle[0] = 90;
  ypr_angle[1] = 0;
  ypr_angle[2] = 90;
  ypr_cmd[0] = 90;
  ypr_cmd[1] = 0;
  ypr_cmd[2] = 90;
  delay(500);
  update_servo_commands();
}

void loop() {
  update_servo_commands();
  /*if(Serial.available()){
    rcv = Serial.read();
    if(rcv=='a')
      ypr_cmd[0] = 0;
    if(rcv=='s')
      ypr_cmd[0] = 180;      
  }*/
  //Serial.println(ypr_angle[0]);
  if(Serial.available()>5){//Process only when at least six bytes are available
    rcv = Serial.read();
    if(rcv=='Y'){
      rcv = Serial.read();
      if(rcv=='P'){
        rcv = Serial.read();
        if(rcv=='R'){
          ypr_cmd[0] = Serial.read();
          ypr_cmd[1] = Serial.read();
          ypr_cmd[2] = Serial.read();
        }
      }
    }
  }
}

void update_servo_commands(){
  /*static unsigned long t_prev,t_curr;
  t_curr = millis();
  if((t_curr-t_prev)<15){//update only once per 15 msec. 
    return;
  }
  t_prev = t_curr;*/
  //Serial.println(ypr_angle[0]);
//  if(abs((int)ypr_angle[0]-(int)ypr_cmd[0])>5){
    if(ypr_angle[0]<ypr_cmd[0])
      ypr_angle[0] = ypr_angle[0] + 1;  //Change by only one degree per update cycle (i.e. 180 degrees=2.7 sec at 15msec update interval)
    if(ypr_angle[0]>ypr_cmd[0])
      ypr_angle[0] = ypr_angle[0] - 1;
//  }
    
  if(ypr_angle[1]<ypr_cmd[1])
    ypr_angle[1] = ypr_angle[1] + 1;
  if(ypr_angle[1]>ypr_cmd[1])
    ypr_angle[1] = ypr_angle[1] - 1;
    
  if(ypr_angle[2]<ypr_cmd[2])
    ypr_angle[2] = ypr_angle[2] + 1;
  if(ypr_angle[2]>ypr_cmd[2])
    ypr_angle[2] = ypr_angle[2] - 1;
    
  
  yaw.write(ypr_angle[0]);
  pitch.write(ypr_angle[1]);
  roll.write(ypr_angle[2]);
}
