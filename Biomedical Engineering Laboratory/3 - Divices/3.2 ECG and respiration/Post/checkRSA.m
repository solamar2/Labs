function [HR_in,HR_out,ampQRS_in,ampQRS_out]=checkRSA(ECG,Respiration,Fs,pks,locs)
%this function receive the ECG and Respiration and found the aspiration and
%exhalation times and return the amplitude of QRS and heart rate for each
Respiration=Respiration(1:length(ECG));
for i=1:length(Respiration)-1
    m(i)=sign(Respiration(i+1)-Respiration(i));
end
for i=1:300:(length(m)-300)
    slope(i:i+300)=mode(m(i:i+300));
end
slope(length(m)-300:length(ECG))=mode(m(end-300:end));

in=find(slope==1);%aspiration
out=find(slope==-1); %exhalation

d=diff(in); in_index(1)=in(1); j=2;
for i=2:length(d)
if d(i)>500
    in_index(j)=in(i);
    in_index(j+1)=in(i+1);
    j=j+2;
end
end
in_index(j)=in(end);
d=diff(out); out_index(1)=out(1); j=2;
for i=2:length(d)
if d(i)>500
    out_index(j)=out(i);
    out_index(j+1)=out(i+1);
    j=j+2;
end
end
out_index(j)=out(end);
locs=locs*500; count1=1; count2=1;
for i=1:2:length(in_index)/2
     l=pks(find((locs>=in_index(i)).*(locs<=in_index(i+1))));
     ampQRS_in(count1:count1+length(l)-1)=l; count1=count1+length(l);
     if length(l)>1
    RR_in(count2:count2+length(l)-2)=diff(locs(find((locs>=in_index(i)).*(locs<=in_index(i+1)))))/500;
    count2=count2+length(l)-1;
     end
end
count1=1; count2=1;
for i=1:2:length(out_index)/2
     l=pks(find((locs>=out_index(i)).*(locs<=out_index(i+1))));
     ampQRS_out(count1:count1+length(l)-1)=l; count1=count1+length(l);
     if length(l)>1
    RR_out(count2:count2+length(l)-2)=diff(locs(find((locs>=out_index(i)).*(locs<=out_index(i+1)))))/500;
    count2=count2+length(l)-1;
     end
end

HR_in=60./RR_in;
HR_out=60./RR_out;

figure
subplot(2,1,1)
scatter(1:length(HR_in),HR_in,'filled');
hold on
scatter(1:length(HR_out),HR_out,'filled');
legend('aspiration','exhalation');
ylabel('Heart rate');xlabel('n');
subplot(2,1,2)
scatter(1:length(ampQRS_in),ampQRS_in,'filled');
hold on
scatter(1:length(ampQRS_out),ampQRS_out,'filled');
legend('aspiration','exhalation');
ylabel('Amplitude of QRS complex');xlabel('n');

end