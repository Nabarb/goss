function GP_plot_comparison(dataset1, dataset2, condition)
% function WMT_plot_comparison plots ers_erd time frequency maps calculated for the
% event defined in "condition" in two different datasets ("dataset1" and
% "dataset2")
%
% dataset1, dataset2: two different datasets containing ers_ers_sensor
% structures
%
% condition: string containing the name of the event used for ers_erd
% calculation
%
% Marianna Semprini, IIT
% April, 2018

for index1 = 1:10
    if strcmp(dataset2(index1).condition_name, condition)
        break
    else
        index1 = [];
    end
end

for index2 = 1:10
    if strcmp(dataset2(index2).condition_name, condition)
        break
    else
        index2 = [];
    end
end

if isempty(index1)
    error(['condition' condition 'not found for dataset' num2str(1)]);
elseif isempty(index2)
    error(['condition' condition 'not found for dataset' num2str(2)]);
else    
    figure(1000);
    title1 = dataset1(index1).condition_name;
    title1(title1== '_') = ' ';
    title2 = dataset2(index2).condition_name;
    title2(title2== '_') = ' ';
    
    title1 = 'pre stimulation';
    title2 = 'post stimulation';
    
    for ii = 1:127
        subplot(1,2,1); cla;
        imagesc(dataset1(index1).time_axis, dataset1(index1).frequency_axis, squeeze(dataset1(index1).tf_map(ii,:,:)));
        hold on;
        line([0 0], [0 max(dataset1(index1).frequency_axis)], 'color', 'red', 'linestyle', '--','linewidth', 1);
        line([500 500], [0 max(dataset1(index1).frequency_axis)], 'color', 'red', 'linestyle', '--','linewidth', 1);
        title([title1 '     ' dataset1(index1).label{ii}]);
        caxis([-50 50]);
        xlabel('Time [ms]');
        ylabel('Frequency [Hz]');
        set(gca, 'fontweigh','bold');

        subplot(1,2,2); cla;
        imagesc(dataset2(index2).time_axis, dataset2(index2).frequency_axis, squeeze(dataset2(index2).tf_map(ii,:,:)));
        hold on;
        line([0 0], [0 max(dataset2(index2).frequency_axis)], 'color', 'red', 'linestyle', '--','linewidth', 1);
        line([500 500], [0 max(dataset2(index2).frequency_axis)], 'color', 'red', 'linestyle', '--','linewidth', 1);
        title([title2 '     ' dataset2(index2).label{ii}]);
        caxis([-50 50]);
        xlabel('Time [ms]');        
        ylabel('');
        set(gca,'ytick', []);
        set(gca, 'fontweigh','bold');
        cb = colorbar; set(cb, 'position', [0.9297    0.1111    0.0286    0.8159]);
        
%         figName = ['erd_ers_sensor\' dataset1(index1).label{ii} '.png'];
        figName = [dataset1(index1).label{ii} '.png'];
        saveas(gcf, figName);
        close(figure(1000));
    end
end

end