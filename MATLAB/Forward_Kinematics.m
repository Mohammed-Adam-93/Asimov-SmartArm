% Clear up
clear all;
close all;
clc;

% Define board
a = arduino('/dev/tty.usbmodem1201', 'uno', 'Libraries', 'Servo');

% Create servos
servo1 = servo(a, 'D6');
servo2 = servo(a, 'D9');
servo3 = servo(a, 'D10');
servo4 = servo(a, 'D11');
servo5 = servo(a, 'D12');
servo6 = servo(a, 'D13');

start_pos1 = 0.55;
start_pos2 = 0.55;
start_pos3 = 0.55;
start_pos4 = 0.5;
start_pos5 = 0.5;
start_pos6 = 0.5;

writePosition(servo1, start_pos1);
writePosition(servo2, start_pos2);
writePosition(servo3, start_pos3);
writePosition(servo4, start_pos4);
writePosition(servo5, start_pos5);
writePosition(servo6, start_pos6);
pause(4);

target = [149, 138, 216, 30, 96, 96];

targetPos1 = target(1)/270;
targetPos2 = target(2)/270;
targetPos3 = target(3)/270;
targetPos4 = target(4)/180;
targetPos5 = target(5)/180;
targetPos6 = target(6)/180;

v1 = 0.7;
v2 = 0.3;
v3 = 0.3;
v4 = 0.5;
v5 = 0.5;
v6 = 0.5;

numSteps = 1/min([v1,v2,v3,v4,v5,v6]);

incre1 = (targetPos1 - start_pos1)/numSteps;
incre2 = (targetPos2 - start_pos2)/numSteps;
incre3 = (targetPos3 - start_pos3)/numSteps;
incre4 = (targetPos4 - start_pos4)/numSteps;
incre5 = (targetPos5 - start_pos5)/numSteps;
incre6 = (targetPos6 - start_pos6)/numSteps;

i = 0;

while i < numSteps

    writePosition(servo1, start_pos1 + i * incre1 );
    writePosition(servo2, start_pos2 + i * incre2 );
    writePosition(servo3, start_pos3 + i * incre3 );
    writePosition(servo4, start_pos4 + i * incre4 );
    writePosition(servo5, start_pos5 + i * incre5 );
    writePosition(servo6, start_pos5 + i * incre6 );
    i = i + 1;
    pause(0.0001);
end

% Cleanup



