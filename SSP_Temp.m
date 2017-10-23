load('HCIeng_10.mat')
load('HCIeng_1.mat')
CT1=interp1(THCIeng_10,CCel1T,THCIeng_1);
CT1=interp1(THCIeng_1,CCel1T,THCIeng_10);
length(CT1);
save('therm1t','CT1','SSP_C_Num','THCIeng_10')

%10hz
load('HCIeng_10.mat')
load('HCIeng_1.mat')
SSP_C_10=interp1(THCIeng_1,SSP_C_Num,THCIeng_10);
SSP_C_Num=SSP_C_10;
CT1=CCel1T;
save('therm1t','CT1','SSP_C_Num','THCIeng_10')