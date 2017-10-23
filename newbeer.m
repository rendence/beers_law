function concentration=newbeer(icosout,scannums)

%concentration=newbeer(icosout,scannums);
%Concentration is the beer's law concentration resulting from taking the depth of the line. It uses the line centers from icosout to find the lines.

S = ICOS_setup(icosout);
if isempty(scannums)
    scannums=S.scannum;
end
% CT1=interp1(THCIeng_10,CCel1T,THCIeng_1); %get this into program somehow, need to use pointer to rawdata
load('therm1t.mat'); %this requires a prior step of getting and converting the HCI_eng

%The loop below finds the location of the absorption features in sample space
%using the ICOSout output. It then builds the absorption depth vs. baseline
%to get transmission percent, both from raw data and from fitted data
count=0; %test, remove

warning('off','MATLAB:polyfit:RepeatedPointsOrRescale');

for j=1:length(scannums)
    [m,I]=min(abs(SSP_C_Num-S.scannum(j)));
    %T1=CT1(find(SSP_C_Num == S.scannum(j))); 
    temp(j,1)=CT1(I)+273.15;%this pulls in the temperature for each scan
    fit=load(mlf_path(icosout,S.scannum(j)));
    pos=round(interp1(fit(:,2)+S.nu_F0(j)+S.nu0,1:size(fit,1),S.nu));
    % no polyfit trans(j,1:(length(pos)))=fit(pos,3)./fit(pos,5); %this is the transmittance based on the raw data
    
   %The following section is in bug testing mode!
   
   for k=1:length(pos) %This accounts for the fact that there are an equal number of positions to fitted lines
    polycos=polyfit(rot90(pos(k)-3:pos(k)+3),fit(pos(k)-3:pos(k)+3,3),2); %Each line has coefficients. 3 on either side is good for 65 torr. Need to change both the 3 and the 7 to change width. Maybe make dynamic?
    %fitted(k,1)=min(polycos(1)*(pos(k))^2+polycos(2)*pos(k)+polycos(3)); %This builds up the fit based on the minimum.
    fitted(k,1)=min(polyval(polycos,pos(k)-3:.02:pos(k)+3));
   end
    
    testfit(j,1:(length(pos)))=fitted./fit(pos,5);
    trans(j,1:(length(pos)))=fit(pos,3)./fit(pos,5); %this is the transmittance based on the raw data
    trans2fit(j,1:(length(pos)))=fit(pos,4)./fit(pos,5); %transmittance based on fitted data
    base(j,1:(length(pos)))=fit(pos,3); %baseline
    fit(j,1:(length(pos)))=fit(pos,4); %the fitted line
    scanline(j,1:(length(pos)))=fit(pos,5); % This is the actual raw line
    assignin('base','count',count)
end
assignin('base','transmittance',trans)
assignin('base','transmittanceVfit',trans2fit)
assignin('base','baseline',base)
assignin('base','fitline',fit)
assignin('base','scanline',scanline)
figure
plot(temp)

warning('on','MATLAB:polyfit:RepeatedPointsOrRescale');

%%%% Okay now do temperature and pressure correction%%%

figure
plot(temp)


%%Simple formula
c2 = 1.438789;          % second radiation constant c2 = hc/k (cm*K)
Tref=296;
F=load('fitline.dat'); %gets numbers for later use
SnnC13 = F(13,4); %strength of C13 absorption, need to change for other components
%in the line below, F column 6 is E, or energy transition, and F column 3 is V0, or line center. 
S13cTemp = SnnC13*(Tref./temp).^(3/2).*exp(c2*F(13,6)*(temp-Tref)./(Tref*temp)).*(1-exp(-c2*F(13,3)./temp))./(1-exp(-c2*F(13,3)./Tref)); %F(13,3) is the line in cm-1
G = F(13,5)*65/760; % lorentz correction for pressure, need to make dynamic
Fv = 1/(pi * G); % for getting sigma
sigma = S13cTemp.*Fv; % this is our sigma adjusted for temperature to be used in Beer's

% sigmadumb = SnnC13;
% Adumb =2-log10(100*trans(:,7));  %basic equation for absorbance
% bdumb= 21.9*35; % length of cell in cm
% %Need S for molar absorbtivity in L/(mol*cm)
% cdumb = Adumb./(bdumb.*sigmadumb); % gives concentration in mols/L
% Cppmdumb = cdumb/22.4; % convert to mixing ratio of air. Not sure if this actually works.
% assignin('base','C13Con_uncorrected',Cppmdumb)
% 
% figure
% plot(Cppmdumb);
% xlabel('scan number')
% ylabel('concentration in ppm')
% title('13CO2 run 5 concentrations calculated by Beers-Lambert Law')


figure
scatter(temp,sigma);
title('temperature corrected absorption vs. temperature');
xlabel('temp');
ylabel('sigma');


%%%This section is commented out because I don't want to use it%%%
%A=2-log10(100*trans2fit(:,7));  %basic equation for absorbance
A=2-log10(100*trans(:,7)); %For using raw line as opposed to fit
Apoly=2-log10(100*testfit(:,7));
b= 21.9*35; % length of cell in cm
%Need S for molar absorbtivity in L/(mol*cm)
c = A./(b.*sigma); % gives concentration in mols/L
Cppmpoly = Apoly./(b.*sigma)/22.4;
Cppm = c/22.4; % convert to mixing ratio of air. Not sure if this actually works.

assignin('base','C13Con',Cppm)

% Figure for the beers law concentration, change numbers and parameters
figure
plot((Cppm*10e-21*400/.164).*temp/273.15); %make into Cppm(:,X) for non-truncated A above
xlabel('scan number')
ylabel('concentration in ppm')
title('13CO2 run 5 concentrations calculated by Beers-Lambert Law')


figure
plot((Cppmpoly*10e-21*400/.164).*temp/273.15); %make into Cppm(:,X) for non-truncated A above
xlabel('scan number')
ylabel('concentration in ppm')
title('13CO2 run 5, polynomial then Beers-Lambert Law')

% Figure for the icosfit, change numbers and parameters for other runs
[cal,ssp] = mixlines(icosout,4);
figure
plot(cal(:,7))
xlabel('scan number')
ylabel('concentration in ppm')
title('130305-1 run 5 13CO2 concentrations calculated by ICOSfit')


% Figure for the icosfit, change numbers and parameters for other runs
figure
%plot(trans2fit(:,7))
plot(trans(:,7)) %For raw data rather than fitted data
xlabel('Scan Number')
ylabel('Transmittance')
title('130305-1 run 5 Transmittance of 13CO2 line')
%In F, we are looking at 18, 16, 13, and 11 as CO2, deep CO2, 13CO2, and CO18O, respectively


% 1. convert linecenters to wavenumbers for temp correction
% get vector of line strengths to sub in for sigma
% need vector of AMU, since m uses that

%I currently have transmittance, and need to arrive at concentration. 

%Need to get Bnn to calculate spectral line intensity
%Snn=h*Vnn/c *Nn / N * (1 - Gn/Gn1 * Nn1/Nn) * Bnn;
%Rnn=3*h^2/(8 Pi^3) * Bnn x10e-36;

%I need to get 

