#include <VarSpeedServo.h> 

// Define the motors
VarSpeedServo base; 
VarSpeedServo shoulder;
VarSpeedServo elbow;
VarSpeedServo wrist;
VarSpeedServo wrot; 
VarSpeedServo gripper;

//Pins of motors
int basePin = 6; 
int shoulderPin = 9;
int elbowPin = 10;
int wristPin = 11;
int wrotPin = 12;
int gripperPin = 13;

//define the motors speeds
int baseV = 10;
int shoulderV = 8;
int elbowV = 10;
int wristV = 50;
int wrotV = 5;
int gripperV = 3;

// intial angles

int b_angle[3] = {ceil(138.0*270.0/360.0 - 3.0), ceil(183.0*270.0/360.0 - 3.0), ceil(170.0*270.0/360.0 - 3.0)};
int sh_angle[3] = {ceil(138.0*270.0/360.0 - 3.0), ceil(138.0*270.0/360.0 - 3.0), ceil(60.0*270.0/360.0 - 3.0)};
int elb_angle[3] = {ceil(138.0*270.0/360.0 - 3.0), ceil(178.0*270.0/360.0 - 3.0), ceil(70.0*270.0/360.0 - 3.0)};
//float angle_0[6] = {b_angle[0],sh_angle[0],170,15,90,90};
int angle_1[6] = {b_angle[1],sh_angle[1],elb_angle[1],90,90,125};
int angle_2[6] = {b_angle[2],sh_angle[2],elb_angle[2],170,80,125};

// intiatial Pose
int angle_0[6] = {b_angle[0],sh_angle[0],elb_angle[0],90,90,125};//170,15,90,90}; {103,103,100,30,80,125};

// array of motors
VarSpeedServo motors[6] = {base,shoulder,elbow,wrist,wrot,gripper};

// array of speeds
int velocity[6] = {baseV,shoulderV,elbowV,wristV,wrotV,gripperV};

// size of parameters
int sizeM = 6;




// Number of joints (or angles)
const int numJoints = 6;
int jointAngles[numJoints];
int numSteps = 20;
int interpolated[6];

void setup() {

    //attach the pins
  base.attach(basePin);   
  shoulder.attach(shoulderPin);
  elbow.attach(elbowPin);
  wrist.attach(wristPin);
  wrot.attach(wrotPin);
  gripper.attach(gripperPin);
  
 // intial Pose
  newMove(motors,angle_0,velocity);
  delay(15000);


    // Start the serial communication at 9600 baud rate
  Serial.begin(9600);
  delay(50);

}

void loop() {
  // Check if data is available to read
  if (Serial.available() >= sizeof(int32_t) * numJoints) {
    // Read the joint angles from the serial buffer
    for (int i = 0; i < numJoints; i++) {
      Serial.readBytes((char *)&jointAngles[i], sizeof(int32_t));
    }
    newMove(motors,jointAngles ,velocity);
    
    delay(50);

     

  }


}

void newMove(VarSpeedServo motor[],int angle[],int velocity[]){
//motor.write(angle, velocity, false); 
  
   motor[0].write(angle[0],velocity[0],false);
   
   motor[1].write(angle[1],velocity[1],false);
   
   motor[2].write(angle[2],velocity[2],false);
   
   motor[3].write(angle[3],velocity[3],false);
   
   motor[4].write(angle[4],velocity[4],false);
   
   motor[5].write(angle[5],velocity[5],false);
  
  
}
