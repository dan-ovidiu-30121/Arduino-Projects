%% preluare date
serialPort = 'COM6';  
baudRate = 9600;      
fclose(instrfind); 
delete(instrfind);

s = serial(serialPort, 'BaudRate', baudRate);
fopen(s);

csvFile = 'data.csv';

fileID = fopen(csvFile, 'w');
fprintf(fileID, 'Time (s),Temperature (C)\n');

try
    while true
        data = fgetl(s);
        if ischar(data)
            fprintf(fileID, '%s\n', data);
        end
        pause(1);
    end
catch
    fclose(fileID);
    fclose(s);
    disp('Datele au fost salvate și conexiunea a fost închisă.');
end
%%
data = readtable("data.csv");
time = data{:,1};
temp = data{:,2};
% plot(time, temp)

input = zeros(length(time), 1); 
input(time >= 5 & time <= 15) = 1;  
input(time >= 23 & time <= 36) = 1; 

inputId = input(time >= 1 & time <= 16);
inputVal = input(time >= 21 & time <= 40);

outputId = temp(time >= 1 & time <= 16);
outputVal = temp(time >= 21 & time <= 40);

inputIdSize = size(inputId,1);
inputValSize = size(inputVal,1);

grades = 30;
MSE = zeros(1,grades);
for pol_grade = 1 : grades
    phiId = calcPhi(inputIdSize,pol_grade,inputId);
    thetta = phiId \ outputId;
    
    phiVal = calcPhi(inputValSize,pol_grade,inputVal);
    outputAprox = phiVal * thetta;

    MSE(pol_grade) = calcMSE(outputAprox,outputVal');
end

plot(MSE);
title('MSE');
bestGrade = find(MSE == min(MSE));

bestPhiId = calcPhi(inputIdSize,bestGrade,inputVal);
thetta = bestPhiId \ outputId;

bestPhiVal = calcPhi(inputValSize,bestGrade,inputVal);
output = bestPhiVal * thetta;

plot(outputVal)
hold on
plot(output)

function phi = calcPhi(N,n,u)
phi = zeros(N,n);
for i = 1 : N
    for j = 1 : n
        phi(i,j) = u(i)^(j-1);
    end
end
end

function MSE = calcMSE(yAprox,y)
N = size(y,2);
e = yAprox' - y;
MSE = sum(e.^2) / N;
end