function [Clean_Signal,W] = LMS(Raw_Signal,Noise_ref,Options)
% This function recieves a raw signal and noise reference vectors and
% calculates the optimal weight vector and filters the signal using linear
% combiner filtering using these optimal weights.
%% inputs:
% Raw_Signal - the signal to be filtered
% Noise_ref - the noise reference signals
% Options - a starcture that contains initial values for the weight vector
% and step size. if one of these values isn't given it will be allocated as
% given in the function.
%% outputs:
% Clean_Signal - The filtered signal using linear combiner filter
% W - the LMS weight matrix. the last collumn is the optimal weight vector
% that can be recieved using LMS.
%%
if length(Raw_Signal)~=size(Noise_ref,2)
    error('Raw_signal and Noise_ref raws should be the same length!');
end
k = length(Raw_Signal); %number of iterations of the LMS algorithem.
R = 1/k*(Noise_ref*Noise_ref'); % the corelation matrix of the noise reference vectors
W = zeros(size(Noise_ref,1),k); %intialization of the weight matrix
if nargin<3 % if the Options structure is missing
   mu = 1/trace(R);
elseif ~(isfield(Options,'mu')) %if the Options.mu is missing
    mu = 1/trace(R);
    W(:,1) = Options.W0;
elseif ~(isfield(Options,'W0')) %if the Options.W0 is missing
    mu = Options.mu;
    W(:,1) = 0;
else
mu = Options.mu;
W(:,1) = Options.W0;
end
%LMS:
for i=1:k-1 
    W(:,i+1) = W(:,i) + mu*(Raw_Signal(i)-Noise_ref(:,i)'*W(:,i)).*Noise_ref(:,i);
end
Clean_Signal = Raw_Signal-sum(W.*Noise_ref);  
end