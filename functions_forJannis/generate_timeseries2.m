function [timeseries] = generate_timeseries2(PSD,f)
% GENERATE_TIMESERIES Code to generate flavors of pink noise, red noise, 
%   and white noise 
%   Based on code from GR, adapted by RCS

tf = 1/min(f);

nfp = length(PSD); ntp = tf+1;
noise1 = randn(nfp,1);

% generate a Gaussian time series with this spectral property
amp = sqrt(PSD); % sqrt of PSD = amplitude spectrum
phase1 = 2*pi*noise1; % random phase
Y1 = amp.*exp(sqrt(-1)*phase1); % complex noise
Y1 = [Y1; flipud(conj(Y1))]; % Replicate complex conj
Y1 = [0; Y1]; % Give it zero mean

%The generated time series
scale = sqrt(tf./2); %sqrt(tf/2); % scaling factor (what should it be?) - changed from tf/2 to tf
timeseries = scale*ifft(Y1,ntp); % Inverse transform
end

