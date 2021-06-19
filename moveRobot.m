% Define Gripper Position
% Based on the information provided by the Vision :V
function [q] = moveRobot(vPos, vRot, robot, jointSub, trajAct, trajGoal)
    gripperTranslation = vPos;
    gripperRotationX = vRot(1); % radians
    gripperRotationY = vRot(2); % radians
    gripperRotationZ = vRot(3); % radians
    desiredGripperPose = trvec2tform(gripperTranslation)*axang2tform([1 0 0 gripperRotationX])*axang2tform([0 1 0 gripperRotationY])*axang2tform([0 0 1 gripperRotationZ]);
    % Compute Trajectory

    jointMsg = receive(jointSub,2);
    currentRobotJConfig =  jointMsg.Position(2:8);
    [q,qd,qdd,trajTimes] = RoboCupManipulation_computeTrajectory(currentRobotJConfig, desiredGripperPose, robot, 'gripper', 4);

    % Package and send the joint trajectory 

    trajGoal = RoboCupManipulation_packageJointTrajectory(trajGoal,q,qd,qdd,trajTimes);
    waitForServer(trajAct);
    sendGoal(trajAct,trajGoal);
end

