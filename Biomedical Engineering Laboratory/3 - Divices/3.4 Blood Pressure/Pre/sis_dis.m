function [sistole,diastole] = sis_dis(Korto,Press)
%this fuction sorting the kortokoff sound 
%and take 0.5% of the value to be the threshold 
%to find the sistole and diastole pressure 
%the Fucntion gets the Kortkoff sound and
%the pressure from the cuff
%and giving back the sistole and diastole pressure
%the number 0.5% is emipric number.
sorted = sort(Korto);
thresh = sorted(round(0.995*numel(sorted)));
logi = abs(Korto)>=thresh;
ind = find(logi == 1);
sistole = Press(ind(1));
diastole = Press(ind(end));
end