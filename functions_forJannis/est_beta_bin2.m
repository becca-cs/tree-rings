function [p] = est_beta_bin2(P,s,varargin)
    
    if isempty(varargin)
        n_bins = 5; % number of bins per log
        plt_flg = 1; % plot?
    elseif length(varargin)==1
        n_bins = varargin{1};
        plt_flg = 1;
    else
        n_bins = varargin{1};
        plt_flg = varargin{2};
    end

    I = log10(s); I = I(isfinite(I));
    edges = logspace(min(I),max(I),(max(I)-min(I)).*n_bins); % 5 bins per log...
    [~,~,bins] = histcounts(s,edges); % put stuff in bins
    midway=sqrt(edges(1:end-1).*edges(2:end));
    logP = log10(P);
    for n = 1:max(bins)
        P_means(n) = mean(logP(bins==n));
    end

    if sum(isnan(P_means))>0
        disp('Warning: There are some NaNs in the weighted data due to the bin size.')

        midway = midway(~isnan(P_means));
        P_means = P_means(~isnan(P_means));
    end

    % find best fit
    p = polyfit(log10(midway),P_means,1);

    %p = polyfit(log10(midway),P_means,1);
    if plt_flg
        figure();
        plot(s,P,'linewidth',1); hold on;
        P_est = 10.^(p(2)).*s.^p(1); plot(s,P_est,'--k','linewidth',1)
        scatter(midway,10.^P_means,'r','filled');
        ylabel('PSD (deg / yr^2)'); xlabel('frequency (1/yr)')
        legend('input spectral density','estimated spectral density',...
            'points used to estimate \beta')
        set(gca,'xscale','log','yscale','log','fontsize',14)
        loc_x = min(I)+(max(I)-min(I))*0.05;
        loc_y = min(P_means)+(max(P_means)-min(P_means))*0.05;
        text(10^loc_x,10^loc_y,['\beta = ' num2str(round(p(1),2))],'fontsize',20)
        xlim([10^min(I) 10^max(I)]); ylim([10^min(P_means) 10^max(P_means)])
        grid on;
    end

end