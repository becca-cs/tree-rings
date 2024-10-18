
% script to get variance in a given frequency band for model output
clear; close all;
exp = 'piControl'; % can also be ‘past1000’
fl = 1/10; fh = 1/1; % frequency cutoffs for computing variance 

folderPath = ['/Users/rcs/Documents/MATLAB/tree-rings/CMIP5_output/' exp '/'];

fileList = dir(folderPath); % list of models
for k = 1:length(fileList)
    % Skip '.' and '..' entries
    fileind(k) = ~fileList(k).isdir;
end
fileList = {fileList(fileind).name}; % this is also list of models

% load model output - plot variance in temp in given frequency band

load coastlines;   % Load built-in coastline data
load CMIP5_output/regridding.mat

figure('Position',[0 0 1800 900])

for k = 1:length(fileList)

    load([folderPath fileList{k}]);

    temp = tas_an; % this can also be winter temp, summer temp, etc…

    T = [];
    for i = 1:length(regrid_lat)
        for j = 1:length(regrid_long)
            T(j,i,:) = filtPH(squeeze(temp(j,i,:)),1,fl, fh); % filter temperature
        end
    end

    subplot(3,3,k); axesm('robinson', 'Frame', 'on', 'Grid', 'on');  % Robinson projection
    axis off;  % Hide standard axis

    % Plot data using pcolorm
    V = var(T,0,3); V = [V; V(1,:)];
    pcolorm(regrid_lat,[regrid_long; regrid_long(1)], V'); clim([0 5])

    % add coastlines for better reference
    load coastlines;   % Load built-in coastline data
    plotm(coastlat, coastlon, 'k');  % Plot coastlines in black
    title(fileList{k}); set(gca,'fontsize',14)
end

sgtitle(['Annual mean temperature, 1/' num2str(1/fh) ' yr - 1/' num2str(1/fl) ' yr'],...
    'fontsize',14)
cb = colorbar('Position', [0.92, 0.1, 0.02, 0.8]);  % [left, bottom, width, height]
cb.Label.String = '\sigma^2 of annual mean temperature (^oC^2)';
cb.FontSize = 20; cmap = crameri('lajolla');
colormap(cmap);

% Adjust layout to ensure colorbar fits without overlapping
set(gcf, 'PaperPositionMode', 'auto');
