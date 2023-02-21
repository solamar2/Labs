function [Qsignal,T]=Miu_quantizer(Signal,miu,bits)
% Inputs:
% Signal - Original signal [1 X N (line vector)]
% miu – Miu
% bits - Amount of bits for quantization
%
% Outputs:
% Qsignal - New quantized signal [line vector]
% T - Contains vector with the current miu Law
% transformation [ (qnjuantization levels) X 2 ]
%%
Trn = sign(Signal).*log(1+miu*abs(Signal))/log(1+miu);
[Qsignal,~] = U_quantizer(Trn,bits);
Qsignal = (sign(Qsignal).*(1+miu).^(abs(Qsignal))-1)/miu;

T(:,1) = linspace(min(Signal),max(Signal),length(Signal));
T(:,2) = sign(T(:,1)).*log(1+miu*abs(T(:,1)))/log(1+miu);
T(:,2) = U_quantizer(T(:,2),bits);
T(:,2) = (sign(T(:,2)).*(1+miu).^(abs(T(:,2)))-1)/miu;
