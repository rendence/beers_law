function reduceco2L2=reduceco2L2(co2file,l2file,runnum)

%reduceco2=reduceco2(co2file,l2file)
%This program reduces CO2 data to a set of data showing CO2 spatially and
%related to methane. It requires m.map to fully function.
%the co2file is the name given to the CO2 data resulting from beers law.
%The data is in the form of column 1 as SSP number, 2 as time, 3 as C12
%concentration, 4 as C13 concentration

load(co2file);
load(l2file);

c13=interp1(CO2run(:,2),CO2run(:,4),T1Hz_ftime);
co2=interp1(CO2run(:,2),CO2run(:,3),T1Hz_ftime);
ich4=fastavg(CH4dry,10);
alt=fastavg(Alt,10);


i=find(~isnan(co2) & alt<25 & alt~=0);
rc13=c13.*isovals(22,'abundance');
rco2=co2.*isovals(21,'abundance');
delC13=1000*((rc13./rco2)/(isovals(22,'abundance')/isovals(21,'abundance'))-1);
figure
scatter(co2(i),delC13(i),3,ich4(i))
title([runnum, '12CO2 vs delta 13CO2, colored by CH4 concentration'])
colorbar;
xlabel('12 CO2');
ylabel('del 13 CO2 (needs rescaling)')


figure

scatter(Lon(i),Lat(i),[],co2(i))
colorbar
title([runnum,'CO2 concentrations by location'])
xlabel('Longitude')
ylabel('Latitude')

figure
scatter(Lon(i),Lat(i),[],co2(i)./c13(i))
colorbar
title([runnum, ' 12CO2/13CO2 by location'])
xlabel('Longitude')
ylabel('Latitude')

figure
scatter(c13(i),alt(i),3,c13(i))
colorbar
title([runnum, 'CO2 by altitude <25m color coded by 13CO2'])
xlabel('[CO2]')
ylabel('Altitude')

