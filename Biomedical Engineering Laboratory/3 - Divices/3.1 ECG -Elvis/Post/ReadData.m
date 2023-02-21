function [Mean,Data]=ReadData(File,StrInd,EndInd,NumCol)
Data_File=lvm_import(File);

if strcmp(EndInd,'End')%the case where End reading is END
    EndInd = length(Data_File.Segment1.data(:,1));
    Data = Data_File.Segment1.data(StrInd:EndInd,1:NumCol); 
    Mean = mean(Data);
else
    Data = Data_File.Segment1.data(StrInd:EndInd,1:NumCol); %The case End reading 
    Mean = mean(Data);                                      %is a finite number
end