function [X_proc] = process_temp(X, varargin)
%   INPUTS
%       X : temperature matrix; should be lat x lon x time
%       t : time (probably days since 850)
%       varargin : enter months (1-12) that you want temperature from (default is
%           annual-mean)

if isempty(varargin)
    tsteps = 1:12;
else
    tsteps = varargin{1};
end

sz = size(X);

tas_month = reshape(X,[sz(1) sz(2) 12 sz(3)./12]);
%time_month(:,:,:) = t;
%time_month = reshape(time_month,[1 1 12 length(t)./12]);

X_proc = squeeze(mean(tas_month(:,:,tsteps,:),3)); % just take the temperature for the months you want
%t_proc = squeeze(mean(time_month(:,:,tsteps,:),3);
end