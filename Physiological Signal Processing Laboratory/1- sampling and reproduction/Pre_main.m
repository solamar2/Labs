%% Signals Sampling & Reconstruction Lab - main code

%% remove previous data
clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Signal acquisition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Pre-Sampling for acquisition

% connect sampler to matlab.

% Create interface object
DataAcquisition = daq('ni');

% define object's parameters
get(DataAcquisition);
DataAcquisition.Rate = 1100;

% Add analog input channel
devices = daqlist;
DeviceID = devices.DeviceID;
channelInput = addinput(DataAcquisition, DeviceID, 'ai0', 'Voltage');

%% Sample signal & plot

% sample signal from signal generator.
% plot a few cycles of signal (just for checking).

% read data from signal generator
durationInSeconds = seconds(2);
data = read(DataAcquisition, durationInSeconds);

% change type and add meaningful names
data = timetable2table(data);
data.Time = seconds(data.Time);
data.Properties.VariableNames{2} = 'Voltage';

% plot first few cycles of signal
figure;
plot(data.Time, data.Voltage);
axis tight;
xlim([0 0.08]);

%% save signal to file

% dont forget to update folder's name before each save!!!

fileName = "aaa"; % define file name
writetable(data, fileName + ".csv");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Signal reconstruction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Pre-Sampling for reconstruction

% connect sampler to matlab.

% Create interface object
DataAcquisition = daq('ni');

% define object's parameters
get(DataAcquisition);

% Add analog input channel
devices = daqlist;
DeviceID = devices.DeviceID;
channelOutput = addoutput(DataAcquisition, DeviceID, 'ao1', 'Voltage');

%% Create a synthesized signal and write

samplingFrequency = 1100;
tic;

while toc < 100
   
   % create sin function
   outputSignal = sin(toc * 2 * pi * 80) + 2;
   
   % write signal to scope
   write(DataAcquisition, outputSignal);
   
   % Pause execution for 1 / samplingFrequency [seconds]
   pause(1 / samplingFrequency);
end
