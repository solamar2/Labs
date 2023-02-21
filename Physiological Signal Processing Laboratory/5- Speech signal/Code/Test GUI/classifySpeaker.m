function Decision=classifySpeaker(SuperVector,Model_PATH)

Model=load(Model_PATH);
Model=Model.Model;

Mu_A=mean(Model.FeatsA); Mu_B=mean(Model.FeatsB);
Sig_A=std(Model.FeatsA); Sig_B=std(Model.FeatsB);

y_A=sum(log(normpdf(SuperVector,Mu_A,Sig_A))); 
y_B=sum(log(normpdf(SuperVector,Mu_B,Sig_B)));    

if y_A>y_B 
    Decision=1;
else  
    Decision=2;
end