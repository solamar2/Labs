function [Clean_Signal,W,R,P] = Linear_Combiner(Raw_Signal,Noise_ref)
% this function preforming the linear combiner
% algorithm as we studied in class
sizo = size(Raw_Signal);
Raw_Signal = reshape(Raw_Signal,[1 numel(Raw_Signal)]);
L_Noise = length(Noise_ref(1,:));           % length of the noise signal

R_r = (Noise_ref * Noise_ref') / L_Noise;   % R matrix defenition
R = inv(R_r);                               % for the calculation we will need the inverse matrix of R
P = (Noise_ref * Raw_Signal') / L_Noise;    % P matrix defenition

W = R * P;                                  % reference signal coeficient

Clean_Signal = Raw_Signal' - Noise_ref' * W;
Clean_Signal =reshape(Clean_Signal,sizo);