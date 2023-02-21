function [state]=breath_state(ECG,Respiration,Temp,n,t,Fs)
% this function checking the brath state using temerature changes
%1-normal breath, 2-stop breath, 3-deep, 4-quick and flat, 5-through the nose
Temp=Temp(1:length(ECG)); Respiration=Respiration(1:length(ECG));
state=[]; color=['r','b','g','y','k'];
L=floor(length(ECG)/n);
for i=0:L-1
    Tmean=mean(Temp(i*n+1:(i+1)*n));
     FFres=meanfreq(Respiration(i*n+1:(i+1)*n),500);
     FFtemp =meanfreq(Temp(i*n+1:(i+1)*n),500);
    if Tmean<=25.7 %if the temerature mean is less than 25 it's can be stop breath or through the nose  
        [pks,locs] = findpeaks(Respiration,Fs,'MinPeakHeight',0.2,'MinPeakDistance',2);
        a=locs<=t((i+1)*n);b=locs>=t(i*n+1);
        count=length(find(a.*b==1));
        if count<1 || (FFres<=0.4 && FFtemp>=0.003)
            % if there is no peaks (or number that close to zero) it's mean that the breath stop- there is no movment of the chest
            state=[state ones(1,n)*2];
        else
            state=[state ones(1,n)*5]; % if the temp mean is less than 25 but there is a movment of the cheast it's breath through the nose
        end
    else % if the mean of the temp is more than 26 we check the frequency:
        if FFtemp>=0.003 && FFres<=0.2 
             state=[state ones(1,n)*3];
        else
            if FFtemp<=0.0014 && FFres>=0.4 
                state=[state ones(1,n)*4]; 
            else
                state=[state ones(1,n)]; %  if it doesnt meet any of the consitions- normal breath
            end
        end
    end
    plot(t(i*n+1:(i+1)*n),ECG(i*n+1:(i+1)*n),'color',color(state(i*n+1)));
    hold on
end
end