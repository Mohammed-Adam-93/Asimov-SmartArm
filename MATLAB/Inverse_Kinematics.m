%% Luther_1, Manipulator
clear all;
close all;
clc;

% Inputs
% q  = [47.33  47.33  -60   -70   -10    35];
% q2 = [0      0      -40   -30   -0    -20];
% q3 = [183    -       178   -     -     - ];
x = [183  138  178  90  90  90];
q = x - [138  138  138  90  90   90];% The value of the gripper angle does not change the orientation of the endeffector
q = q*pi/180;
DH = param(q);
calDH = calcDH(DH);
transform = transform(q);

% Dispay
display(q)
display(DH)
display(calDH)
display(transform)
%% Inverse Kinematics
% Asumptions
%desiredT =   [      0    0   1   -100;
%                   -1    0   0   -100;
%                    0   -1   0    300;
 %                   0    0   0     1];
desiredT =  [     0         0        1        -100.0000;
                 -1         0        0         100.2000;
                  0        -1        0         290.5000;
                  0         0        0           1.0000];

% Intial guess
q0 = [0, 0, 0, 0, 0, 0];
% limits
lb = [-149*1.5*pi/270, -149 * 1.5 * pi /270,-149 * 1.5 * pi /270, -90 *pi/180, -90 *pi/180, -90 *pi/180];
ub = [121 * 1.5 * pi /270, 121 * 1.5 * pi /270, 121 * 1.5 * pi /270, 90 *pi/180, 90 *pi/180, 90 *pi/180];
% Option
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');
% Solution
[q_sol, fval] = fmincon(@(q) objective(q, desiredT), q0, [], [], [], [], lb, ub, [], options);
disp('Optimized joint angles:');
disp(q_sol);
disp('Start communicating')
pause(4);
%% Send to Ardunio

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

start_pos = [start_pos1, start_pos2, start_pos3, start_pos4, start_pos5, start_pos6];

q_sol(1:3) = q_sol(1:3)/(1.5*pi);
q_sol(4:6) = q_sol(4:6)/(pi);

target = start_pos + q_sol;% 149 == 00 in 270 deg motors
disp(target)
 

targetPos1 = target(1);
targetPos2 = target(2);
targetPos3 = target(3);
targetPos4 = target(4);
targetPos5 = target(5);
targetPos6 = target(6);

v1 = 0.7;
v2 = 0.2;
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
%clear servo1 servo2 servo3  servo4 servo5 servo6 a;




