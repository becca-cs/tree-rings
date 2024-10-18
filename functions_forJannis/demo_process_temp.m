% load a temperature file, then compute annual-mean temp, winter temp,
% summer temp
clear;
exp = 'piControl';

folderPath = ['/Users/rcs/Documents/MATLAB/Variability/testdata/' exp '/'];

fileList = dir(folderPath); % list of files;
for k = 1:length(fileList)
    % Skip '.' and '..' entries
    fileind(k) = ~fileList(k).isdir;
end
fileList = {fileList(fileind).name};

% get regridding info also
load /Users/rcs/Documents/MATLAB/tree-rings/CMIP5_output/regridding

for k = 1:length(fileList)

    filenm = [folderPath fileList{k}];

    file_title = split(filenm,'_');
    time = ncread(filenm,'time'); % doesn't matter really for piControl
    tas = ncread(filenm,'ts'); %tas = detrend(tas);
    lat = ncread(filenm,'lat');
    lon = ncread(filenm,'lon');

    % Regrid stuff
    [Yi, Xi, Ti] = meshgrid(regrid_lat, regrid_long, 1:length(time));
    [Y, X, T] = meshgrid(lat, lon, 1:length(time));

    tas_int = interp3(Y,X,T,tas,Yi,Xi,Ti); % interpolated tas

    % reshape stuff
    yr_start = str2num(file_title{6}(1:4));
    tas_an = process_temp(tas_int,1:12); % input what months you want to grab temperature from!
    tas_jja = process_temp(tas_int,[6 7 8]); % June July August
    tas_djf = process_temp(tas_int,[1 2 12]); % Dec Jan Feb
    tas_nhwarm = process_temp(tas_int,[1 2 3 10 11 12]); % Jan Feb March Oct Nov Dec
    tas_nhcold = process_temp(tas_int,4:9); % Apr May June July Aug Sept
    yr = yr_start:1:yr_start+length(tas_an)-1;

    % Save as a file
    model = file_title{3};
    dirsave = ['/Users/rcs/Documents/MATLAB/tree-rings/CMIP5_output/' ...
        exp '/']; % directory to save stuff in
    savenm = [dirsave model];
    save(savenm,'yr','lat','lon','tas_an','tas_jja','tas_djf','tas_nhwarm','tas_nhcold')
end