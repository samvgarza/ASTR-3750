%% Header 
% finalProject.m
%
% This file serves as the main driver for the final project for ASTR 3750:
% Impact Crater Saturation Simulation. 
%
% This code is not entirely modular, you will have to manually adjust the
% time the simulaiton runs and adjust the plot titles accordingly. My bad!
%
% Author: Sam Garza
%
% Date Created: 11/19/2020                  Last Modified: 11/25/2020

clear 
close all
%% 
% generate a 500x500km square plot
% time --- 5 = 500k years
% 10 = 1 mill
% 15 = 1.5 mill
% 20 = 2 mill
time = 0:0.01:20; 

% create random x and y positions of the center of craters
% x = rand(length(time),1).*500; 
% y = rand(length(time),1).*500; 

% estbalish crater diameter --- can find impactor size from this 
%craterSize = 15; % km 
craterCount(1) = 1; 
i = 1; 
while i <= length(time)
      x(i) = rand(1,1).*500;
      y(i) = rand(1,1).*500;
      craterSize(i) = randi([10 50],1,1); % varying craterSize with a max size of 70km in diameter
    for j = 1:length(x)
        % go thru each centerpoint and make sure the center is "visible" by
        % finding the difference between the centers for ALL instances
        dx(j) = abs(x(i) - x(j));
        dy(j) = abs(y(i) - y(j));
        mag(j) = sqrt(dx(j).^2 + dy(j).^2); % finding absolute magnitude 
        if mag(j) ~= 0 % ensuring we are not comparing the same index ( mainly just to deal with the first iteration)
            if mag(j) <= (craterSize(j) / 2) % using the "visible" condition as stated above
                craterCount(i) = craterCount(i-1) - 1; % deleting the added crater 
                break;
            else
                craterCount(i) = craterCount(i-1) + 1; % adding the crater to the total count
            end
        end
    end
% condition just to make sure we never have negative numbers
if craterCount(i) <= 0
    craterCount(i) = 0;
end
i = i + 1; % iterate
end
%% Plotting Crater Distribution

for q = 1:(i-1)
% creating circles to plot the impact diameter
theta = linspace(0,2*pi,i);
radius = (craterSize(q) / 2);
x_circ = radius * cos(theta) + x(q);
y_circ = radius * sin(theta) + y(q);

plot(x(q),y(q),'b.');
hold on
plot(x_circ,y_circ,'r'); axis square;
hold on
end
% adjust the title name depending on how long we are running the simulation
title('Crater Distribution at 2 Million Years'); xlabel('Length [km]'); ylabel('Width [km]');
xlim([0 500]); ylim([0 500]);
xticks([0 100 200 300 400 500]);
xticklabels({'0', '100', '200', '300', '400', '500'});
yticks([0 100 200 300 400 500]);
yticklabels({'0', '100', '200', '300', '400', '500'});
%% Find Saturation Time 
for q = 1:(i-2)
   dx_slope(q) = x(q+1) - x(q);
   dy_slope(q) = y(q+1) - y(q);
   slope(q) = dy_slope(q) / dx_slope(q);
end
zeroSlope = find(abs(slope) < 1e-1);
%% Plotting Craters as a Function of Time
figure;
plot(time.*100000, craterCount, 'LineWidth', 1.5); grid on;
xlabel('Years [0 - 300k]'); ylabel('Number of Impact Craters'); title('Impact Craters as a Function of Time');
hold on
xline(time(zeroSlope(14))*100000, 'r--', 'LineWidth', 1.5);
satTime = sprintf('Time to Saturation: %d years', time(zeroSlope(14))*100000);
legend('Craters', satTime, 'Location', 'Best');