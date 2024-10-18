% Generate a synthetic timeseries with a given spectral slope, 
% then calculate the spectral slope of the
% synthetic timeseries

addpath(genpath('functions_forJannis')); % make sure that this folder is in your path

clear; close all;

% spectral characteristics of desired spectrum
beta = 1; % spectral slope of the timeseries you want to create
sigbdot = 2; % variance

delt = 1.0; % time difference
ts = 0; % starting time
tf = 1000; % final time
nts=floor((tf-ts)/delt) +1; %number of time steps ('round' used because need nts as integer)
nyrs = tf-ts; ntp = tf+1;
t = ts:delt:tf;

delta_f = 1/tf; % Sampling frequency (Hz)
f = (1/tf:1/tf:ntp/2/tf)'; % frequency vector

Pmax = 2*delt*sigbdot^2; fmax = f(end);
PSD = Pmax*(f/fmax).^-beta; % this is the spectrum that the timeseries *should* have - you can also make this red, white, etc...

x = generate_timeseries2(PSD,f); % this is the synthetic timeseries

% okay, now compute the spectrum of the synthetic timeseries
[P_est,s] = pmtmPH(x,delt);

p = est_beta_bin2(P_est,s, 10);