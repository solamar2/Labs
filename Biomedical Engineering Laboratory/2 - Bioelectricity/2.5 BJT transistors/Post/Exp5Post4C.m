%%
%2.a
data = readtable('current.xlsx');
va = data.Va;
ib = data.Ib;
CurrentGain(ib,va);

%%
%2.b
ic = (9-va)/5000;
fit = polyfit(ib,ic,1);
ic_lin = polyval(fit,ib);
figure
plot(ib,ic_lin)
xlabel('I_b [A]')
ylabel('I_c [A]')
title('Linear fit of I_c as function of I_b')

%new linear fits using low ib current data
ic_new = ic([1 2 3]);
ib_new = ib([1 2 3]);
fit2 = polyfit(ib_new,ic_new,1);
ic_n_lin = polyval(fit2,ib_new);
figure
plot(ib_new,ic_n_lin)
xlabel('I_b [A]')
ylabel('I_c [A]')
title('New linear fit of I_c as function of I_b using low ib current fewer data points')