function mapCO2coords=mapCO2coords(co2file,period,name)

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

end

periodt=[num2str(period),'s avg'];
if period == 0.1
    periodt='10Hz';
end
minlat=min(Lat(i1))-.25;
maxlat=max(Lat(i1))+.25;
minlon=min(Lon(i1))-.25;
maxlon=max(Lon(i1))+.25;

% Keeling Plot
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(1./(C12(i1)*1e6),d13CO2(i1),6,H2O(i1),'filled');
hold on
i2=find(C12 >0);
coeffs=polyfit(1./(C12(i2)*1e6),d13CO2(i2),1);
h = colorbar;
set(get(h,'title'),'string','[H2O]');
title([name, ' CO2 Keeling Plot <100m AGL ', periodt]);
xlabel('1/[12CO2] (in ppmv)');
ylabel('del-13CO2')
print(['Keeling Plot ', name, ' ', periodt, '.png'],'-dpng','-r300')

% 13CO2 vs 12CO2
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C12(i1),d13CO2(i1),6,H2O(i1),'filled');
hold on
h = colorbar;
set(get(h,'title'),'string','[H2O]');
title([name, ' d13C vs 12CO2 <100m AGL ', periodt]);
xlabel('12CO2');
ylabel('del 13C')
print(['H2Ovs13CO2v12CO2_below100m ', name, ' ', periodt, '.png'],'-dpng','-r300')

% 13CO2 vs 12CO2 vs T
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C12(i1),d13CO2(i1),6,AirT(i1),'filled');
hold on
h = colorbar;
set(get(h,'title'),'string','AirT - C');
title([name, ' d13C vs 12CO2 <100m AGL ', periodt]);
xlabel('12CO2');
ylabel('del 13C')
print(['Tvs13CO2v12CO2_below100m ', name, ' ', periodt, '.png'],'-dpng','-r300')


% 13CO2 vs 12CO2 - total flight
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C12,d13CO2,6,H2O,'filled');
hold on
h = colorbar;
set(get(h,'title'),'string','[H2O]');
title([name, ' d13C vs 12CO2 all Alts.', periodt]);
xlabel('12CO2');
ylabel('del 13C')
print(['13CO2v12CO2_all_alts', name, ' ', periodt, '.png'],'-dpng','-r300')


% 13CO2 vs 12CO2 - total flight based on  time
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C12,d13CO2,6,1:1:length(C12),'filled');
hold on
h = colorbar;
set(get(h,'title'),'string','Scan#');
title([name, ' d13C vs 12CO2 all Alts.', periodt]);
xlabel('12CO2');
ylabel('del 13C')
print(['13CO2v12CO2_all_scans', name, ' ', periodt, '.png'],'-dpng','-r300')


% T vs. H2O
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(AirT(i1),H2O(i1),6,C12(i1),'filled');
hold on
h = colorbar;
set(get(h,'title'),'string','[12CO2]');
title([name, ' AirT,H2O,12CO2 AGL<100m ', periodt]);
xlabel('Air Temp');
ylabel('H2O')
print(['TvsH2Ov12C ', name, ' ', periodt, '.png'],'-dpng','-r300')

% T vs. H2O vs 12:13C
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(AirT(i1),H2O(i1),6,d13CO2(i1)./C13(i1),'filled');
hold on
h = colorbar;
set(get(h,'title'),'string','d13CO2');
title([name, ' T,H2O,d13CO2 <100m ', periodt]);
xlabel('Air Temp');
ylabel('H2O')
print(['TvsH2Ov12C-13C ', name, ' ', periodt, '.png'],'-dpng','-r300')

% 12CO2 vs. H2O
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C12(i1),H2O(i1),'filled');
hold on
title([name, ' 12CO2 vs. H2O <100m AGL ', periodt]);
xlabel('12CO2');
ylabel('H2O')
print(['H2Ovs12CO2 ', name, ' ', periodt, '.png'],'-dpng','-r300')

% 12CO2 vs. T
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C12(i1),AirT(i1),'filled');
hold on
title([name, ' 12CO2 vs. Temp <100m AGL ', periodt]);
xlabel('12CO2');
ylabel('Air Temp')
print(['Tvs12CO2 ', name, ' ', periodt, '.png'],'-dpng','-r300')

% 13CO2 vs. H2O
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C13(i1),H2O(i1),'filled');
hold on
title([name, ' 13CO2 vs. H2O <100m AGL ', periodt]);
xlabel('13CO2');
ylabel('H2O')
print(['H2Ovs13CO2 ', name, ' ', periodt, '.png'],'-dpng','-r300')

% 13CO2 vs. T
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C13(i1),AirT(i1),'filled');
hold on
title([name, ' 13CO2 vs. Temp <100m AGL', periodt]);
xlabel('13CO2');
ylabel('Air Temp')
print(['Tvs13CO2 ', name, ' ', periodt, '.png'],'-dpng','-r300')

% 12CO2 vs. AGL
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C12(i1),alt1(i1),'filled');
hold on
title([name, ' 12CO2 vs. Alt <100m AGL ', periodt]);
xlabel('12CO2');
ylabel('Alt (m AGL)')
print(['AGLvs12CO2 ', name, ' ', periodt, '.png'],'-dpng','-r300')


% 13CO2 vs. AGL
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C13(i1),alt1(i1),'filled');
hold on
title([name, ' 13CO2 vs. Alt <100m AGL ', periodt]);
xlabel('13CO2');
ylabel('Alt (m AGL)')
print(['AGLv13CO2 ', name, ' ', periodt, '.png'],'-dpng','-r300')


% 13CO2/12CO2 vs. AGL
figure
set(gca,'fontsize',12)
%scatter(1./(C12*1e6),d13CO2,2,CH4);
scatter(C12(i1),d13CO2(i1),6,alt1(i1),'filled');
hold on
title([name, ' 12C:d13CO2 AGL<100m', periodt]);
xlabel('12CO2');
ylabel('13CO2')
h = colorbar;
set(get(h,'title'),'string','AGL');
print(['AGL100v13CO2v12CO2 ', name, ' ', periodt, '.png'],'-dpng','-r300')



% m.map mercator projection of water
figure
set(gca,'fontsize',12)
m_proj('mercator','lon',[minlon maxlon],'lat',[minlat maxlat])
m_gshhs_h('patch',[.8 .8 .8]);
m_grid('xtick',10,'box','fancy','ytick',10,'tickdir','in','fontsize',7)
hold on
[X,Y]=m_ll2xy(Lon, Lat);
scatter(X(i1),Y(i1),6,H2O(i1),'filled');
h = colorbar;
set(get(h,'title'),'string','[H2O]');
title([name, ' [H2O] Measured'])
print(['Mercator_water ', name, ' ', periodt, '.png'],'-dpng','-r300')


% m.map mercator projection of temperature
figure
set(gca,'fontsize',12)
m_proj('mercator','lon',[minlon maxlon],'lat',[minlat maxlat])
m_gshhs_h('patch',[.8 .8 .8]);
m_grid('xtick',10,'box','fancy','ytick',10,'tickdir','in','fontsize',7)
hold on
[X,Y]=m_ll2xy(Lon, Lat);
scatter(X(i1),Y(i1),6,AirT(i1),'filled');
h = colorbar;
set(get(h,'title'),'string','Temp - C');
title([name, ' Air Temp'])
print(['Mercator_temp ', name, ' ', periodt, '.png'],'-dpng','-r300')



% Here we have the mercator projection of CO2 mixing ratios
figure
set(gca,'fontsize',12)
m_proj('mercator','lon',[minlon maxlon],'lat',[minlat maxlat])
m_gshhs_h('patch',[.8 .8 .8]);
m_grid('xtick',10,'box','fancy','ytick',10,'tickdir','in','fontsize',7)
hold on 
scatter(X(i1),Y(i1),6,C12(i1).*1e6,'filled');
title([name,' [12CO2] ',periodt])
h = colorbar;
set(get(h,'title'),'string','CO2 ppm');
print(['Mercator_CO2 ', name, ' ', periodt, '.png'],'-dpng','-r300')

% Here we have the mercator projection of 13CO2 mixing ratios
figure
set(gca,'fontsize',12)
m_proj('mercator','lon',[minlon maxlon],'lat',[minlat maxlat])
m_gshhs_h('patch',[.8 .8 .8]);
m_grid('xtick',10,'box','fancy','ytick',10,'tickdir','in','fontsize',7)
hold on
scatter(X(i1),Y(i1),6,C13(i1).*1e6,'filled');
title([name, ' [13CO2]', periodt])
h = colorbar;
set(get(h,'title'),'string','C13O2 ppm');
print(['mercator_13CO2 ', name, ' ', periodt, '.png'],'-dpng','-r300')

% when we flew where, in scan time.
figure
set(gca,'fontsize',12)
m_proj('mercator','lon',[minlon maxlon],'lat',[minlat maxlat])
m_gshhs_h('patch',[.8 .8 .8]);
m_grid('xtick',10,'box','fancy','ytick',10,'tickdir','in','fontsize',7)
hold on
scatter(X(i1),Y(i1),6,i1,'filled');
title([name, ' scan', periodt])
h = colorbar;
set(get(h,'title'),'string','Scan');
print(['mercator_time ', name, ' ', periodt, '.png'],'-dpng','-r300')
