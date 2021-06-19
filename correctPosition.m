function [realPosition] = correctPosition(centroid, current)
 O = [480 270] / 2; 
 R = centroid; 
 
 moveVector = R - O; 
 moveVector(2) = 270 - moveVector(2); 
 
 %% Real Dimensions of the image 
 % 480x270 px 
 tableHeight = 0.5; % m 
 rH = current(3)- tableHeight; 
 
 % Aspect Ratio 16:9
 angDiagonal = atan2(9, 16);  % rads 
 % Real diagonal
 rD = 2 * ( rH * tan(deg2rad(36)) ); % m
 
 % Real w and h
 rW = rD * cos(angDiagonal) % m
 rH = rD * sin(angDiagonal) % m 
 
 rDimensions= [-rW rH];  % m
 proportionFactor =  rDimensions ./ [480 270];  
 
 realPosition = proportionFactor .* moveVector; 
 realPosition = [fliplr(realPosition) 0 ]+current;
 realPosition = realPosition - [0.09 0 0];
end