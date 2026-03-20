%% Luther_1, Manipulator
clear all;
close all;
clc;

% Inputs
% q  = [47.33  47.33  -60   -70   -10    35];
% q2 = [0      0      -40   -30   -0    -20];
% q3 = [183    -       178   -     -     - ];
x = [138 1183  138  0  90  90];
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
angles = zeros(6,10);
for j = 1:280
% Asumptions
desiredT =  [  -1.0000    0.0000    0.0000   -110;
                0.0000   -1.0000    0.0000    100-0.5*j;
                0.0000    0.0000    1.0000    300 ;
                0         0         0           1];
% Intial guess
q0 = [0, 0, 0, 0, 0, 0];
% limits
lb = [-0.55*1.5*pi, -0.55*1.5*pi, -0.4*1.5*pi, -0.4*pi, -0.5*pi, -90 *pi/180];
ub = [0.3*1.5*pi, 0.3*1.5*pi, 0.3*1.5*pi, 0.45*pi, 0.45*pi, 90 *pi/180];
% Option
options = optimoptions('fmincon', 'Display', 'none', 'Algorithm', 'sqp');
% Solution
[q_sol, fval] = fmincon(@(q) objective(q, desiredT), q0, [], [], [], [], lb, ub, [], options);
angles(:,j) = q_sol';
%disp('Optimized joint angles:');
%disp(q_sol);
end


disp('Optimized joint angles:');
disp(angles)


disp(angles*180/pi);
angles(1:3, :) = angles(1:3,:)/(1.5*pi);
angles(4:6,:) = angles(4:6,:)/(pi);
disp(angles);

start_pos1 = 149/270;
start_pos2 = 149/270;
start_pos3 = 149/270;
start_pos4 = 0.5;
start_pos5 = 0.5;
start_pos6 = 0.5;
start_pos = [start_pos1, start_pos2, start_pos3, start_pos4, start_pos5, start_pos6];

%q_sol(4:6) = q_sol(4:6)/pi;

target = angles + start_pos' ;% 149 == 00 in 270 deg motors
disp('target = ')
disp(target)
%% Define board
a = arduino('/dev/tty.usbmodem1201', 'uno', 'Libraries', 'Servo');

% Create servos
servo1 = servo(a, 'D6');
servo2 = servo(a, 'D9');
servo3 = servo(a, 'D10');
servo4 = servo(a, 'D11');
servo5 = servo(a, 'D12');
servo6 = servo(a, 'D13');

writePosition(servo1, start_pos1);
writePosition(servo2, start_pos2);
writePosition(servo3, start_pos3);
writePosition(servo4, start_pos4);
writePosition(servo5, start_pos5);
writePosition(servo6, start_pos6);
pause(4);

[row, col] = size(target);

i = 1;

while i < col

    writePosition(servo1, target(1,i) );
    writePosition(servo2, target(2,i) );
    writePosition(servo3, target(3,i) );
    writePosition(servo4, target(4,i) );
    writePosition(servo5, target(5,i) );
    writePosition(servo6, target(6,i) );
    i = i + 1;
    pause(0.001);
end