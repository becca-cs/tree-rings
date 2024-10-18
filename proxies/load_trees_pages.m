clear;
load coastlines
filenm = '/Users/rcs/Documents/MATLAB/tree-rings/pages2k/pages2kv2.xlsx';
[Fnum,Ftxt,~] = xlsread(filenm,'Table S1');

Ftype = cell(1,length(Ftxt)-1);
for i = 2:length(Ftxt)
    archType{i-1} = Ftxt{i,5};
    urlLoad{i-1} = Ftxt{i,25};
end

lat = Fnum(:,1);
lon = Fnum(:,2);

% only look at trees, corals
ct_tree = 1; ct_coral = 1; ct_ice = 1; ct_msed = 1;
for i = 1:length(archType)
    if ismember(archType{i},'tree')
        idxTree(ct_tree) = i;
        ct_tree = ct_tree+1;
    elseif ismember(archType{i},'coral')
        idxCoral(ct_coral) = i;
        ct_coral = ct_coral+1;
    elseif ismember(archType{i},'glacier ice')
        idxIce(ct_ice) = i;
        ct_ice = ct_ice+1;
    elseif ismember(archType{i},'marine sediment')
        idxMSed(ct_msed) = i;
        ct_msed = ct_msed+1;
    end
end

%%
ctTree = 1; 
for i = idxTree
    url = urlLoad{i}; % Replace with your URL
    rawData = webread(url);

    % Split the data into lines
    lines = splitlines(rawData);

    % Initialize a cell array to store filtered lines
    filteredLines = {};
    splitLines = [];

    % Iterate through each line
    ct = 1;
    for j = 1:numel(lines)
        % Skip lines starting with '#'
        if ~startsWith(lines{j}, '#') & ~isempty(lines{j})
            if ct==1
                labels = strsplit(lines{j}); lab = {};
                for k = 1:length(labels)
                    if ~isempty(labels{k})
                        lab{k} = labels{k};
                    end
                end
            else
                filteredLines{ct-1} = lines{j};
                splitLines(ct-1,:) = str2num(filteredLines{ct-1});
            end
            ct = ct+1;
        end
    end

    % save stuff!
    processedData.Data{ctTree} = splitLines;
    processedData.DataLabels{ctTree} = lab;
    ctTree = ctTree+1;
end

processedData.Lat = lat(idxTree);
processedData.Lon = lon(idxTree);

% ProcessedData.Data holds data, ProcessedData.DataLabels holds labels
% (temperature, etc...). Probably need to do some additional data
% processing

%% just look at locations of tree rings...

load coastlines
filenm = 'pages2k/pages2kv2.xlsx';
[Fnum,Ftxt,~] = xlsread(filenm,'Table S1');

Ftype = cell(1,length(Ftxt)-1);
for i = 2:length(Ftxt)
    archType{i-1} = Ftxt{i,5};
end

lat = Fnum(:,1);
lon = Fnum(:,2);

% only look at trees, corals
ct_tree = 1; ct_coral = 1; ct_ice = 1; ct_msed = 1;
for i = 1:length(archType)
    if ismember(archType{i},'tree')
        idxTree(ct_tree) = i;
        ct_tree = ct_tree+1;
    elseif ismember(archType{i},'coral')
        idxCoral(ct_coral) = i;
        ct_coral = ct_coral+1;
    elseif ismember(archType{i},'glacier ice')
        idxIce(ct_ice) = i;
        ct_ice = ct_ice+1;
    elseif ismember(archType{i},'marine sediment')
        idxMSed(ct_msed) = i;
        ct_msed = ct_msed+1;
    end
end

figure('Renderer', 'painters', 'Position', [10 10 800 350]);
h1 = mapshow(coastlon, coastlat, 'DisplayType','polygon','FaceColor',...
    [0.8 0.8 0.8]); hold on;
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
scatter(lon(idxTree),lat(idxTree),'filled','markerfacecolor',[0 0.5 0])
scatter(lon(idxCoral),lat(idxCoral),'filled','markerfacecolor',[0.8 0.2 0])
scatter(lon(idxIce),lat(idxIce),'filled','markerfacecolor',[0 0.3 0.7])
scatter(lon(idxMSed),lat(idxMSed),'filled','markerfacecolor',[0.5 0.4 0.4])
set(gca,'fontsize',12); axis tight; xlim([-180 180])
legend({'trees','corals','glacier ice','marine sediments'},'location','southwest')
