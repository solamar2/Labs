%% 1:
ECG = readtable('ECG_scope.csv');
volt = ECG.Voltage;
time = ECG.Time;
volt=volt-mean(volt); %dc=0
%1.2:
index=min(find(time>=5));
figure; plot(time(1:index),volt(1:index));xlabel('Time [sec]'); xlim([0 5]);

%1.3:
signalPower = sum((volt).^2);

%network noise:
f=sin(2*pi*50.*time);
fPower = sum((f).^2);
a=sqrt(signalPower*10^-3/fPower);
network_noise=a.*f;
%check:
S=snr(volt,network_noise)

ECG_noise1=volt+network_noise;

% EMG noise:
L=length(volt);
EMG_noise =normrnd(0,1,[L,1]); %EMG is from a normal distribution with mu=0 and sigma=1, random in the length of the signal
Fs=L/time(end);
fc1=20; %[Hz]
fc2=500; %[Hz]
[b,a] = butter(10,[fc1/(Fs/2) fc2/(Fs/2)],'bandpass'); %EMG frequency is between 20-500 Hz so we do a BPF to the random signal
EMG_noise = filter(b,a,EMG_noise);
fPower = sum((EMG_noise).^2);
a=sqrt(signalPower*10^-3/fPower);
EMG_noise=a.*EMG_noise;
%check:
S=snr(volt,network_noise)

ECG_noise2=volt+EMG_noise;

figure; subplot(3,1,1);plot(time(1:index),volt(1:index));xlabel('Time [sec]'); xlim([0 5]);title('The original ECG');
subplot(3,1,2);plot(time(1:index),ECG_noise1(1:index));xlabel('Time [sec]'); xlim([0 5]);title('ECG with network noise');
subplot(3,1,3);plot(time(1:index),ECG_noise2(1:index));xlabel('Time [sec]'); xlim([0 5]);title('ECG with EMG noise');

%1.4
%network noise
w0=2*pi*50/Fs; r=0.9;
b=[1 -2*cos(w0) 1];
a=[1 -2*r*cos(w0) r^2];
ECG1_withoutnoise=filter(b,a,ECG_noise1);
%EMG
w1=2*pi*20/Fs;
b=fir1(500,w1,'low');
ECG2_withoutnoise=filter(b,1,ECG_noise2);

figure; subplot(3,1,1);plot(time(1:index),volt(1:index));xlabel('Time [sec]'); xlim([0 5]);title('The original ECG');
subplot(3,1,2);plot(time(1:index),ECG1_withoutnoise(1:index));xlabel('Time [sec]'); xlim([0 5]);ylim([-0.2,0.8]);title('ECG with network noise after IIR');
subplot(3,1,3);plot(time(1:index),ECG2_withoutnoise(1:index));xlabel('Time [sec]'); xlim([0 5]); ylim([-0.2,0.8]);title('ECG with EMG noise after LPF (20 Hz)');

%1.5
breathnoise=sin(2*pi*0.25.*time);
ECG_breathnoise=volt+breathnoise;

%fir:
w1=2*pi*0.5/Fs;
b=fir1(500,w1,'high');
freqz(b,1)

ECGfir=filter(b,1,ECG_breathnoise);
ECGfir=ECGfir-mean(ECGfir);
%iir:
[b,a] = butter(5,2*0.5/Fs,'high');
freqz(b,a)

ECGfir_filter=filter(b,a,ECG_breathnoise);
ECGfir_filter=ECGfir_filter-mean(ECGfir_filter);

ECGfir_filtfilt=filtfilt(b,a,ECG_breathnoise);
ECGfir_filtfilt=ECGfir_filtfilt-mean(ECGfir_filtfilt);

index=min(find(time>=10));
figure; subplot(2,1,1);plot(time(1:index),volt(1:index));xlabel('Time [sec]'); xlim([0 10]);ylim([-1.5 2]);title('The original ECG');
subplot(2,1,2);plot(time(1:index),ECG_breathnoise(1:index));xlabel('Time [sec]'); xlim([0 10]);ylim([-1.5 2]);title('ECG with breath noise');

figure;subplot(3,1,1);plot(time(1:index),ECGfir(1:index));xlabel('Time [sec]');  xlim([0 10]); title('ECG with breath noise after FIR (using filter)');
subplot(3,1,2);plot(time(1:index),ECGfir_filter(1:index));xlabel('Time [sec]');  xlim([0 10]);title('ECG with breath noise after IIR (using filter)');
subplot(3,1,3);plot(time(1:index),ECGfir_filtfilt(1:index));xlabel('Time [sec]');  xlim([0 10]);title('ECG with breath noise after IIR (using filtfilt)');

%% 2: 

%2.3:
TrainLabels = readtable('Train_labels.xlsx');
Fs=300; %[Hz]


folder_path ='C:\Users\solam\OneDrive\Desktop\ECG data\Train';
files = dir(fullfile(folder_path,'*.mat'));
for i = 1:length(files)
   signal=load(fullfile(folder_path,files(i).name)).val;
   [signal,delay,t]=Pre_processing(signal,Fs); %Pre processing including DC, network, breath, etc.
   L=length(signal);
   %number of zero crossing:
   zero_cross(i,1)=ZeroCrossing(signal,Fs)/L;
   %heart rate:
   [~,~,~,~,ind_peak]=PanThomp_QRS(signal,Fs);
   timeRR=t(ind_peak);
   HR(i,1)=60/mean(diff(timeRR));
   %SDNN:
   r=diff(timeRR);
   SDNN(i,1)=sqrt(sum((r-mean(r)).^2)/(length(r)-1));
   %rMSSD:
   rmssd(i,1)=rMSSD(timeRR);
   %HAPO:
   Hapo(i,1)=HaPo(signal,Fs);
   %spectral centroid:
   centroid(i,1)=Spectral_Centroid(signal,Fs);
   %MDF:
   median_freq(i,1)=MDF(signal,Fs);
end
Labels=TrainLabels.Label;
Train_features=table(zero_cross,HR,SDNN,rmssd,Hapo,centroid,median_freq,Labels);
writetable(Train_features,'Train_features.xlsx');

clear all;
TestLabels = readtable('Test_labels.xlsx');
Fs=300; %[Hz]

folder_path ='C:\Users\solam\OneDrive\Desktop\ECG data\Test';
files = dir(fullfile(folder_path,'*.mat'));
for i = 1:length(files)
   signal=load(fullfile(folder_path,files(i).name)).val;
   [signal,delay,t]=Pre_processing(signal,Fs); %Pre processing including DC, network, breath, etc.
   L=length(signal);
   %number of zero crossing:
   zero_cross(i,1)=ZeroCrossing(signal,Fs)/L;
   %heart rate:
   [~,Newsignal,~,~,ind_peak]=PanThomp_QRS(signal,Fs);
   Newt=(0:1:length(Newsignal)-1)/Fs; %[sec]
   timeRR=Newt(ind_peak);
   HR(i,1)=60/mean(diff(timeRR));
   %SDNN:
   r=diff(timeRR);
   SDNN(i,1)=sqrt(sum((r-mean(r)).^2)/(length(r)-1));
   %rMSSD:
   rmssd(i,1)=rMSSD(timeRR);
   %HAPO:
   Hapo(i,1)=HaPo(signal,Fs);
   %spectral centroid:
   centroid(i,1)=Spectral_Centroid(signal,Fs);
   %MDF:
   median_freq(i,1)=MDF(signal,Fs);
end
Labels=TestLabels.Label;
Test_features=table(zero_cross,HR,SDNN,rmssd,Hapo,centroid,median_freq);
writetable(Test_features,'Test_features.xlsx');

%
Train_features=readtable('Train_features.xlsx');
Test_features=readtable('Test_features.xlsx');

%2.11:
test_pred_finetree =FineTree.predictFcn(Test_features); test_pred_finetree=categorical(test_pred_finetree);
test_pred_naivebayes= NaiveBayes.predictFcn(Test_features);test_pred_naivebayes =categorical(test_pred_naivebayes);
test_pred_svm =SVM.predictFcn(Test_features);test_pred_svm=categorical(test_pred_svm);
true_labels=categorical(Labels);


plotconfusion(true_labels,test_pred_finetree)
plotconfusion(true_labels,test_pred_naivebayes)
plotconfusion(true_labels,test_pred_svm)

%2.12
Train_features=Train_features(:,1:7);
train_pred_finetree =FineTree.predictFcn(Train_features); train_pred_finetree=categorical(train_pred_finetree);
train_pred_naivebayes= NaiveBayes.predictFcn(Train_features);train_pred_naivebayes =categorical(train_pred_naivebayes);
train_pred_svm =SVM.predictFcn(Train_features);train_pred_svm=categorical(train_pred_svm);
TrainLabels = readtable('Train_labels.xlsx');
true_labels=categorical(TrainLabels.Label);


plotconfusion(true_labels,train_pred_finetree)
plotconfusion(true_labels,train_pred_naivebayes)
plotconfusion(true_labels,train_pred_svm)

%% 3.
clear, clc

% 3.4
% run the first network
run('DLModel.mlx')

% exported the training progress as a figure neamed
% 'Training_prog_no_weights.png'
figure
imshow('Training_prog_no_weights.png')

% 3.6
% running the second model
clear, clc
run('ModelWithWeights.mlx')

% 3.9
% running the model with over sampled AF data to balanace the data:
clear, clc
run('re_sample_AF_model.mlx')
figure, imshow('Training_prog_resample.png')


%3.10
% we will observe how changing the amount of neurons in the LSTM layers
% affect the model:
clear, clc
run('neuron_size_model.mlx')

%plotting the results:
lstm1 = [8, 16, 32, 128]; % hidden units- first LSTM layer
lstm2 = [8, 16, 16, 64];% hidden units- second LSTM layer

for i=1:4
    figure, imshow(['LSTM_prog', num2str(i), '.png']) %training progress plot
    title(['Training Progress, # of neurons = ', num2str(lstm1(i)), ', ', num2str(lstm2(i))])
    YPred = classify(nets{i},Data_test,'MiniBatchSize',BatchSize);% Classify test data for confusion matrix
    figure, plotconfusion(Test_labels,YPred);% Confusion matrix plot
    title(['Confusion matrix, # of neurons = ', num2str(lstm1(i)), ', ', num2str(lstm2(i))])
end


%% 4.
% first change the directory to the Test file, assuming the Test file is
% inside the current directory
current = cd;
cd Test;

% get the list of names of the mat files
file_names = dir;

ECG = []; %initialization of ECG data vector
% iterate on the files concatinating them one after another
for i=3:length(file_names)
    test_data = load(file_names(i).name); %loading the data of specific sample
    ECG = [ECG, test_data.val]; % concatinating the samples
end

% return to the former directory
cd(current)

%loading the classification model to workspace:
importdata('finetree.mat');
% now run the GUI




