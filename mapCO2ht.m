function mapCO2ht=mapCO2ht(co2file,period,name)

%mapCO2=mapCO2(co2file)
% M-maps CO2 file. Auto-chooses the region to plot it in. co2file is the
% name of the run. It's going to be a string. Probably 'F130828.1.L2b.mat'
%
% period is the averaging time, in seconds. Choose .1, 1, 10, or 100. 
% 
% Title is what you want the charts to be titled, typically in the format
% of 'August 13, 2013'. It's going to be a string.

load(co2file);


% %For 28.3 to split data)
% scalr = 2.4for 28.3
% scalr=2.3;
% Alt=Alt(round(length(Alt)/scalr):end);
% CO2dry=CO2dry(round(length(CO2dry)/scalr):end);
% CO2C13O2=CO2C13O2(round(length(CO2C13O2)/scalr):end);
% CH4dry=CH4dry(round(length(CH4dry)/scalr):end);
% H2Odry=H2Odry(round(length(H2Odry)/scalr):end);
% AirT=AirT(round(length(AirT)/scalr):end);
% Lon=Lon(round(length(Lon)/scalr):end);
% Lat=Lat(round(length(Lat)/scalr):end);


% Converts all of the important datas to desired period.
alt1=fastavg(Alt,10*period);
C12=fastavg(CO2dry,10*period); 
% CO2C13O2=CO2C13O2*isovals(22,'abundance'); %leave this out when you fix CO2
C13=CO2C13O2-(4.93*1e-6*H2Odry);
C13=fastavg(C13,10*period);
CH4=fastavg(CH4dry,10*period);
H2O=fastavg(H2Odry,10*period);
i1=find(~isnan(C12) & alt1<99 & alt1~=0 & H2O>5e-3);
d13CO2=1000*(C13./C12./.0112372-1);
fillit=[];
sizeit=3;


if period ~=1 
AirT=fastavg(AirT,period);
Lon=fastavg(Lon,period);
Lat=fastavg(Lat,period);
fillit='filled';
sizeit=6;
Ht=fastavg(Ht,period);

end

periodt=[num2str(period),'s avg'];
if period == 0.1
    periodt='10Hz';
end
minlat=min(Lat(i1))-.25;
maxlat=max(Lat(i1))+.25;
minlon=min(Lon(i1))-.25;
maxlon=max(Lon(i1))+.25;

%12CO2 vs 13CO2
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C12,Ht,6,d13CO2,'filled');
hold on
h = colorbar;
set(get(h,'title'),'string','13CO2');
title([name, ' CO2, all altitudes ', periodt]);
xlabel('12CO2');
ylabel('Alt')
print(['CO2 vs Alt - all alts ', name, ' ', periodt, '.png'],'-dpng','-r300')

figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(1:1:length(Ht),Ht,6,C12,'filled');
hold on
h = colorbar;
set(get(h,'title'),'string','[CO2]');
title([name, ' Alt. Profile & CO2 ', periodt]);
xlabel('Scan');
ylabel('Alt')
print(['Alt Profile - CO2 ', name, ' ', periodt, '.png'],'-dpng','-r300')



