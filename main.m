%% Configure Robot
configureRobot;
%% Move to Section 1
% Section 1 pos = [0.38 0.05 0.68]
% rot = [0 pi pi/2]
sec1_pos = [0.38 0.05 0.68]
sec1_rot = [0 pi pi/2]
moveRobot(sec1_pos, sec1_rot, robot, jointSub, trajAct, trajGoal);
%% Identify, Classify and Move Objects in Section 1
close all;
% Get RGB Image
rgbImgSub = rossubscriber('/camera/color/image_raw');
curImage = receive(rgbImgSub);
rgbImg = readImage(rgbImgSub.LatestMessage); 
% Get Depth Image
rgbDptSub = rossubscriber('/camera/depth/image_raw');
curDepth = receive(rgbDptSub);
depthImg = readImage(rgbDptSub.LatestMessage); 
% Load YOLO Net
load('trained_final.mat', 'net');
% get prediction image
[prediction, bboxes, scores, labels] = net.predict(rgbImg);
i = 1;
box = bboxes(i, :);
% get object position
figure
imshow(prediction)

figure
imshow(depthImg)
hold on;
centroid = @(bbox) [bbox(1) + bbox(3) * 0.5, bbox(2) + bbox(4) * 0.5];
box = centroid(box);
plot(box(1)*1.78,box(2), '*');
box_pos = [box(1)*1.78 box(2)];
robot_pos = sec1_pos;
corrected_pos = correctPosition(box_pos, sec1_pos);
robot_pos = corrected_pos -[0 0 0.6];
moveRobot(robot_pos, sec1_rot, robot, jointSub, trajAct, trajGoal);
%% 
rgbDptSub = rossubscriber('/camera/depth/image_raw');
curDepth = receive(rgbDptSub);
depthImg = readImage(rgbDptSub.LatestMessage); 
figure
imshow(depthImg)