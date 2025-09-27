%% Simple F1 Track Design - No Function Definition Issues
% All code in one script block to avoid MATLAB function definition problems

%% Clear workspace
close all
clear all
clc

%% Parameters
x_initial = 6;
y_initial = 6;
x_final = 8;
y_final = 16;
friction_coefficient = 1.7;%used for safety limits
banking_angle = 19; % degrees
step_size = 0.01;

% Cubic function coefficients
A3 = 7.3558;
A2 = -157.43;
A1 = 1119.5;
A0 = -2631.3;

% Conversion functions (inline)
km_conversion = @(d) d * 0.1 * 16583 / 39370;
scale_conversion = @(d) (d * 39370) / (0.1 * 16583);

% Track functions (inline)
track_function = @(x) A3*x^3 + A2*x^2 + A1*x + A0;
first_derivative = @(x) 3*A3*x^2 + 2*A2*x + A1;
second_derivative = @(x) 6*A3*x + 2*A2;

%% Generate Track Coordinates
fprintf('🏁 F1 Track Design and Analysis\n');
fprintf('================================\n');

x_coords = x_initial:step_size:x_final;
y_coords = arrayfun(track_function, x_coords);

%% Calculate Track Length (Numerical Integration)
track_length = 0;
for i = 2:length(x_coords)
    dx = x_coords(i) - x_coords(i-1);
    dy = y_coords(i) - y_coords(i-1);
    track_length = track_length + sqrt(dx^2 + dy^2);
end

fprintf('Track length: %.3f km\n', km_conversion(track_length));

%% Find Critical Points
% Solve: 3*A3*x^2 + 2*A2*x + A1 = 0
a_coeff = 3 * A3;
b_coeff = 2 * A2;
c_coeff = A1;

discriminant = b_coeff^2 - 4*a_coeff*c_coeff;
if discriminant >= 0
    crit1_y = (-b_coeff + sqrt(discriminant)) / (2*a_coeff);
    crit2_y = (-b_coeff - sqrt(discriminant)) / (2*a_coeff);
    crit1_x = track_function(crit1_y);
    crit2_x = track_function(crit2_y);
    
    fprintf('Critical Points:\n');
    fprintf('  Point 1: (%.2f, %.2f)\n', crit1_x, crit1_y);
    fprintf('  Point 2: (%.2f, %.2f)\n', crit2_x, crit2_y);
end

%% Calculate Radius of Curvature and Danger Zones
radius_of_curvature = @(x) ((1 + first_derivative(x)^2)^(3/2)) / abs(second_derivative(x));

danger_points_x = [];
danger_points_y = [];
max_velocities = [];
curve_radii_m = [];

% Sample every 10th point for efficiency
sample_indices = 1:10:length(x_coords);

for i = sample_indices
    x = x_coords(i);
    radius = radius_of_curvature(x);
    radius_m = km_conversion(radius) * 1000;
    curve_radii_m(end+1) = radius_m;
    
    % Check if dangerous (radius < 100m)
    if radius < scale_conversion(100/1000)
        danger_points_x(end+1) = x;
        danger_points_y(end+1) = track_function(x);
    end
    
    % Calculate maximum safe velocity with banking
    g = 9.81;
    mu = friction_coefficient;
    theta_rad = deg2rad(banking_angle);
    
    numerator = mu * cos(theta_rad) + sin(theta_rad);
    denominator = cos(theta_rad) - mu * sin(theta_rad);
    
    if denominator > 0 && radius_m > 0
        v_ms = sqrt(g * radius_m * numerator / denominator);
        v_kmh = v_ms * 3.6;
        max_velocities(end+1) = v_kmh;
    else
        max_velocities(end+1) = 0;
    end
end

fprintf('\nDanger Zones (radius < 100m): %d points found\n', length(danger_points_x));
if ~isempty(danger_points_x)
    fprintf('First danger point: (%.2f, %.2f)\n', danger_points_x(1), danger_points_y(1));
    fprintf('Last danger point: (%.2f, %.2f)\n', danger_points_x(end), danger_points_y(end));
end

%% Create Comprehensive Plot
figure(1);
set(gcf, 'Position', [100, 100, 1200, 900]);

% Main track plot
subplot(2,2,1);
plot(y_coords, x_coords, 'r-', 'LineWidth', 2);
hold on;
plot(y_initial, x_initial, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
plot(y_final, x_final, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

% Plot critical points
if exist('crit1_x', 'var')
    plot(crit1_x, crit1_y, 'b*', 'MarkerSize', 12);
    plot(crit2_x, crit2_y, 'b*', 'MarkerSize', 12);
    text(crit1_x-0.5, crit1_y, 'Critical 1', 'FontSize', 10);
    text(crit2_x-0.5, crit2_y, 'Critical 2', 'FontSize', 10);
end

% Plot danger zones
if ~isempty(danger_points_x)
    plot(danger_points_y, danger_points_x, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'yellow');
end

xlim([5 17]);
ylim([5 17]);
xlabel('Y Coordinate');
ylabel('X Coordinate');
title('F1 Track Layout');
legend('Track', 'Start', 'Finish', 'Critical Points', 'Danger Zones', 'Location', 'best');
grid on;

% Curvature analysis
subplot(2,2,2);
plot(x_coords(sample_indices), curve_radii_m);
hold on;
yline(100, 'r--', 'LineWidth', 2);
xlabel('Track Position');
ylabel('Radius of Curvature (m)');
title('Curvature Analysis');
legend('Curve Radius', '100m Danger Threshold');
grid on;

% Speed analysis
subplot(2,2,3);
plot(x_coords(sample_indices), max_velocities, 'b-', 'LineWidth', 2);
xlabel('Track Position');
ylabel('Maximum Safe Speed (km/h)');
title('Speed Limits with Banking');
grid on;

% Track slope
subplot(2,2,4);
slopes = arrayfun(first_derivative, x_coords(sample_indices));
plot(x_coords(sample_indices), slopes);
xlabel('Track Position');
ylabel('Track Slope (dy/dx)');
title('Track Gradient Analysis');
grid on;

%% Safety Analysis Summary
fprintf('\n=== SAFETY ANALYSIS SUMMARY ===\n');
fprintf('Minimum curve radius: %.1f m\n', min(curve_radii_m));
fprintf('Maximum safe speed: %.1f km/h\n', max(max_velocities));
fprintf('Minimum safe speed: %.1f km/h\n', min(max_velocities));
fprintf('Average safe speed: %.1f km/h\n', mean(max_velocities));

%% Crash Simulation
test_speeds = [150, 200, 250, 300];
fprintf('\n=== CRASH SIMULATION ===\n');

for test_speed = test_speeds
    crashes = 0;
    for i = 1:length(max_velocities)
        if test_speed > max_velocities(i)
            crashes = crashes + 1;
        end
    end
    
    crash_percentage = (crashes / length(max_velocities)) * 100;
    
    if crashes > 0
        fprintf('Speed %d km/h: ⚠️  %d crash points (%.1f%% of track)\n', ...
                test_speed, crashes, crash_percentage);
    else
        fprintf('Speed %d km/h: ✅ Safe driving\n', test_speed);
    end
end

%% Simple Animation (Optional)
fprintf('\n=== ANIMATION ===\n');
animate_choice = input('Show car animation? (y/n): ', 's');

if strcmpi(animate_choice, 'y')
    figure(2);
    test_speed = 180; % km/h
    
    fprintf('Animating car at %d km/h...\n', test_speed);
    
    for i = 1:5:length(x_coords) % Every 5th point for smooth animation
        clf;
        
       % Load the car image
car_img = imread('car.png');

% Define the size of the image on the plot (adjust these)
img_width = 1;   % Width in plot units
img_height = 1;  % Height in plot units

% Calculate coordinates for image placement (center the image on the point)
x_img = x_coords(i) - img_height/2;
y_img = y_coords(i) - img_width/2;

% Plot the track and other elements first
plot(y_coords, x_coords, 'r-', 'LineWidth', 2);
hold on;

if ~isempty(danger_points_x)
    plot(danger_points_y, danger_points_x, 'ro', 'MarkerSize', 6);
end

% Plot the car image at the current position
image('CData', car_img, 'XData', [y_img y_img + img_width], 'YData', [x_img x_img + img_height]);

xlim([5 17]);
ylim([5 17]);
title(sprintf('F1 Car Position - Speed: %d km/h', test_speed));
xlabel('Y Coordinate');
ylabel('X Coordinate');
hold off;

        % Check if in danger zone
        current_pos_index = find(sample_indices <= i, 1, 'last');
        if ~isempty(current_pos_index) && current_pos_index <= length(max_velocities)
            if test_speed > max_velocities(current_pos_index)
                text(8, 15, '⚠️ DANGER ZONE!', 'FontSize', 16, 'Color', 'red');
                text(8, 14, sprintf('Max Safe: %.0f km/h', max_velocities(current_pos_index)), 'FontSize', 12);
            end
        end
        
        pause(0.05);
    end
end

fprintf('\nAnalysis complete! 🏁\n');
%% 
