%% Preluare date
serialPort = 'COM6';  
baudRate = 9600;      

% Close and delete any existing serial connections
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

% Set up serial connection
s = serial(serialPort, 'BaudRate', baudRate);
fopen(s);

% Open CSV file to save data
csvFile = 'stepperData.csv';
fileID = fopen(csvFile, 'w');
fprintf(fileID, 'Time (s),Position (C)\n');

% Read data and save to CSV
try
    while true
        data = fgetl(s);
        if ischar(data)
            fprintf(fileID, '%s\n', data);
        end
        pause(1);
    end
catch
    % Close file and serial port on error or when stopped
    fclose(fileID);
    fclose(s);
    disp('Datele au fost salvate și conexiunea a fost închisă.');
end
%%
close
data = readtable("stepperData.csv");

time = data{:,1} / 1000;
position = data{:,2};

plot(time,position);

[time, uniqueIdx] = unique(time);  % Get unique timestamps and their indices
position = position(uniqueIdx);  % Filter position data accordingly

% Determine the length of available data
dataLength = length(position);
u = ones(dataLength, 1);

% Define an evenly spaced time vector for `tId`
tId = linspace(time(1), time(end), dataLength)';  % Evenly spaced from start to end time

% Interpolate position data to match the evenly spaced `tId`
yId = interp1(time, position, tId, 'linear');

plateau1 = position([2, 3]);  
plateau2 = position([4, 5]);  
plateau3 = position([6, 7]);

yss1 = mean(plateau1);
yss2 = mean(plateau2);
yss3 = mean(plateau3);

yss = mean([yss1 yss2 yss3]);  % If you want the last plateau as the final steady-state
y0 = position(1);

% Define input step levels
u0 = 0;
uss = 1;  % Assuming a consistent step input of 1 (or adjust as needed)

% Calculate system gain K
K = (yss - y0) / (uss - u0);

% Estimate time constant T
T = time(find(position >= y0 + 0.632 * (yss - y0), 1)) - time(1);

% Define transfer function
H = tf(K, [T, 1]);

% Simulate system response for identification input
outputId = lsim(H, u(1:dataLength), tId);

% Plot Identification
figure;
plot(tId, yId, 'b', 'DisplayName', 'Actual Data');
hold on;
plot(tId, outputId, 'r--', 'DisplayName', 'Simulated Output');
title('Identification');
legend;

% Validation
output = lsim(H, u, time);
figure;
plot(time, position, 'b', 'DisplayName', 'Actual Data');
hold on;
plot(time, output, 'r--', 'DisplayName', 'Simulated Output');
title('Validation');
legend;

% Calculate MSE
MSE = calcMSE(output, position);

function MSE = calcMSE(yAprox, y)
    N = size(y, 1);
    e = yAprox - y;
    MSE = sum(e.^2) / N;
end