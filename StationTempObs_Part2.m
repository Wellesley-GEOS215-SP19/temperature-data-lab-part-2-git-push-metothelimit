%% Shreya Parjan & Jannitta Yao

%% Load in a list of all 18 stations and their corresponding latitudes and longitudes
load GlobalStationsLatLon.mat

%% Calculate the linear temperature trends over the historical observation period for all 18 station
% You will do this using a similar approach as in Part 1 of this lab, but
% now implementing the work you did last week within a function that you
% can use to loop over all stations in the dataset

%Set the beginning year for the more recent temperature trend
RecentYear = 1960; %you can see how your results change if you vary this value

%Initialize arrays to hold slope and intercept values calculated for all stations
P_all = NaN*zeros(length(sta),2); %example of how to do this for the full observational period
P_recent = NaN*zeros(length(sta),2);%<-- do the same thing just for values from RecentYear to today

%Use a for loop to calculate the linear trend over both the full
%observational period and the time from RecentYear (i.e. 1960) to today
%using the function StationTempObs_LinearTrend
for i = 1:18
    station = sta(i);
    [P_all(i,:),P_recent(i,:)] = StationTempObs_LinearTrend(station, RecentYear);
end
%% Plot global maps of station locations
%Example code, showing how to plot the locations of all 18 stations
% figure(1); clf
% worldmap('World')
% load coastlines
% plotm(coastlat,coastlon)
% plotm(lat,lon,'m.','markersize',15)
% title('Locations of stations with observational temperature data')

%Follow the model above, now using the function scatterm rather than plotm
%to plot symbols for all 18 stations colored by the rate of temperature
%change from RecentYear to present (i.e. the slope of the linear trendline)
figure(1); clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
scatterm(lat,lon,50,P_recent(:,1),'filled')
colorbar('southoutside')
title('Temperature Change 1960-Present');

%title('Locations of stations with observational temperature data')

%Extension option: again using scatterm, plot the difference between the
%local rate of temperature change (plotted above) and the global mean rate
%of temperature change over the same period (from your analysis of the
%global mean temperature data in Part 1 of this lab).
%Data visualization recommendation - use the colormap "balance" from the
%function cmocean, which is a good diverging colormap option
%<--

%% Now calculate the projected future rate of temperature change at each of these 18 stations
% using annual mean temperature data from GFDL model output following the
% A2 scenario (here you will call the function StationModelProjections,
% which you will need to open and complete)

%Use the function StationModelProjections to loop over all 18 stations to
%extract the linear rate of temperature change over the 21st century at
%each station
% Initialize arrays to hold all the output from the for loop you will write
% below
baseline_model = NaN*zeros(length(sta),2);
tempAnnMeanAnomaly = NaN*zeros(94,length(sta));
P = NaN*zeros(length(sta),2);
%isp('--------')
% Write a for loop that will use the function StationModelProjections to
% extract from the model projections for each station:
% 1) the mean and standard deviation of the baseline period
% (2006-2025) temperatures, 2) the annual mean temperature anomaly, and 3)
% the slope and y-intercept of the linear trend over the 21st century
for i = 1:18
    station = sta(i);
    [baseline_model(i,:), tempAnnMeanAnomaly(:,i), P(i,:)] = StationModelProjections(station);
end

disp(P(:,1))
%% Plot a global map of the rate of temperature change projected at each station over the 21st century
figure(2); clf
worldmap('World');
load coastlines;
plotm(coastlat, coastlon);
scatterm(lat,lon,50,P(:,1),'filled');
colorbar('southoutside');
title('Projected Rate of Temperature Change 2006-2099');

%% Plot a global map of the interannual variability in annual mean temperature at each station
%as determined by the baseline standard deviation of the temperatures from
%2005 to 2025
figure(3); clf
worldmap('World');
load coastlines
plotm(coastlat, coastlon);
scatterm(lat,lon,50,baseline_model(:,2),'filled');
colorbar('southoutside');
title('Projected Interannual Variability in Annual Mean Temperature 2006-2025');

%% Calculate the time of emergence of the long-term change in temperature from local variability
%There are many ways to make this calcuation, but here we will compare the
%linear trend over time (i.e. the rate of projected temperature change
%plotted above) with the interannual variability in the station's
%temperature, as determined by the baseline standard deviation

%Calculate the year of long-term temperature signal emergence in the model
%projections, calculated as the time (beginning from 2006) when the linear
%temperature trend will have reached 2x the standard deviation of the
%temperatures from the baseline period
%<-- 2x standard deviation
% slope and year after 2006 
% year after 2006 = when the slope is 2x the standard deviation
targetYear = (2 * baseline_model(:,2))./(P(:,1)) + 2006;

%Plot a global map showing the year of emergence

figure(4); clf
worldmap('World');
load coastlines;
plotm(coastlat,coastlon);
scatterm(lat, lon, 50, targetYear,'filled');
colorbar('southoutside');
title("Long-term temperature signal emergence after 2006");