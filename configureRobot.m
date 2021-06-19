%% Connect Matlab to Gazebo
%connect matlab to gazebo
rosIP = "192.168.0.4"; % Change IP address!!    % IP address of ROS enabled machine  
rosshutdown;
rosinit(rosIP,11311);
%% Load Robot
load('exampleHelperKINOVAGen3GripperROSGazebo.mat');
%% Set Inicial Configuration
RoboCupManipulation_setInitialConfig;
%% Unpause Gazebo Physics
physicsClient = rossvcclient('gazebo/unpause_physics');
physicsResp = call(physicsClient,'Timeout',3);
%% Setup ROS Subscriber and Action Client for Joint Control
jointSub = rossubscriber('/my_gen3/joint_states');
[trajAct,trajGoal] = rosactionclient( '/my_gen3/gen3_joint_trajectory_controller/follow_joint_trajectory');