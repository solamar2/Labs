function [N_IMG]=Negative(IMG)
% Inputs:
% IMG - Gray levels image
%
% Outputs:
% N_IMG - Negative image of IMG
%%
R = 2^nextpow2(max(IMG(:))); %because IM is in image type variable, matlab reduces 1 from the result automaticly
N_IMG = R-IMG;