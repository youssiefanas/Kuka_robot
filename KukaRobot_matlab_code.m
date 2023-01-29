clear;
close all;
clc;

% this is the connection protocol between MATLAB and coppelia sim
sim=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
sim.simxFinish(-1); % just in case, close all opened connections
clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5);

% if condition where if ClientID is greater than -1 then this means that
% the client has successfully connected
if (clientID>-1)
    % if the client has successfully connected then print the statement
    % below
    disp('Connected to remote API server');
 %Object Handle
   %Wheels 
[errorCode, wheel_rr]=sim.simxGetObjectHandle(clientID,'rollingJoint_rr', sim.simx_opmode_blocking);
[errorCode, wheel_rl]=sim.simxGetObjectHandle(clientID,'rollingJoint_rl', sim.simx_opmode_blocking);
[errorCode, wheel_fr]=sim.simxGetObjectHandle(clientID,'rollingJoint_fr', sim.simx_opmode_blocking);
[errorCode, wheel_fl]=sim.simxGetObjectHandle(clientID,'rollingJoint_fl', sim.simx_opmode_blocking);
    %Joints
    joint=[0,0,0,0,0];
[errorCode, joint(5)]=sim.simxGetObjectHandle(clientID,'youBotArmJoint0', sim.simx_opmode_blocking);
[errorCode, joint(1)]=sim.simxGetObjectHandle(clientID,'youBotArmJoint1', sim.simx_opmode_blocking);
[errorCode, joint(2)]=sim.simxGetObjectHandle(clientID,'youBotArmJoint2', sim.simx_opmode_blocking);
[errorCode, joint(3)]=sim.simxGetObjectHandle(clientID,'youBotArmJoint3', sim.simx_opmode_blocking);
[errorCode, joint(4)]=sim.simxGetObjectHandle(clientID,'youBotArmJoint4', sim.simx_opmode_blocking);

[errorCode, grib1]=sim.simxGetObjectHandle(clientID,'G1', sim.simx_opmode_blocking);
[errorCode, grib2]=sim.simxGetObjectHandle(clientID,'G2', sim.simx_opmode_blocking);


    %Camera
[errorCode, cam]=sim.simxGetObjectHandle(clientID,'Vision_sensor', sim.simx_opmode_blocking);

%Set Value
    %Wheels 
[errorCode]=sim.simxSetJointTargetVelocity(clientID,wheel_rr,-0, sim.simx_opmode_streaming);
[errorCode]=sim.simxSetJointTargetVelocity(clientID,wheel_rl,0, sim.simx_opmode_streaming);
[errorCode]=sim.simxSetJointTargetVelocity(clientID,wheel_fr,0, sim.simx_opmode_streaming);
[errorCode]=sim.simxSetJointTargetVelocity(clientID,wheel_fl,-0, sim.simx_opmode_streaming);

    %Joints
    pose1=[0 pi/4 -pi/2 1 0];
for i=1:5
  [errorCode]=sim.simxSetJointTargetPosition(clientID, joint(i), pose1(i), sim.simx_opmode_streaming);
end

%gribber
[errorCode]= sim.simxSetJointTargetVelocity(clientID,grib2,0.02, sim.simx_opmode_oneshot_wait);
[~,j2]= sim.simxGetJointPosition(clientID,grib2,sim.simx_opmode_blocking);  % 'simxGetJointPosition' retrieves the intrinsic position of a joint. 
[errorCode]= sim.simxSetJointTargetPosition(clientID,grib1,j2*0.02,sim.simx_opmode_oneshot_wait);

   %Camera live
[errorCode,resolution,image]=sim.simxGetVisionSensorImage2(clientID,cam,0,sim.simx_opmode_streaming);
%Live
for ii=1:50

    [errorCode,resolution,image]=sim.simxGetVisionSensorImage2(clientID,cam,0,sim.simx_opmode_buffer);
   imshow(image)

pause(0.1);
end

    else
    % if the client has failed to connect then print the statement
    % below
    disp('Failed Connecting to Remote API');
end
