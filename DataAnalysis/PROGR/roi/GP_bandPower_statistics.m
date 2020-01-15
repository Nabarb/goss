analysis_name = {'updating','response','true_response','maintenance2','maintenance3'};
for curr_roi =1:nROI
    for analysis = 1:5
        switch analysis
            case 1  %%%%%% ANALYSIS OF "UPDATING" %%%%%%
                curr_list = update_list;
                load(fullfile(saveFolder,'updating_power'));
                band_power = updating_power;
                nPower = 1;
                figtitle = [condition(1).label];
                task = repelem({'2-back','3-back'},8);
                perf = repelem({'well','bad','well','bad'},4);
                band = repmat({'alpha','beta','gamma L','gamma H'},1,4);
                with_factors = {'task','perf','band'};
                
            case 2  %%%%%% ANALYSIS OF "RESPONSE" %%%%%%
                curr_list = response_list;
                load(fullfile(saveFolder,'response_power'));
                band_power = response_power;
                nPower = 1;
                figtitle = [condition(4).label ' all well vs all bad'];
                task = repelem({'2-back','3-back'},8);
                perf = repelem({'well','bad','well','bad'},4);
                band = repmat({'alpha','beta','gamma L','gamma H'},1,4);
                with_factors = {'task','perf','band'};
                
            case 3  %%%%%% ANALYSIS OF "RESPONSE" %%%%%%
                curr_list = tptn_list;
                load(fullfile(saveFolder,'trueresponse_power'));
                band_power = trueresponse_power;
                nPower = 1;
                figtitle = [condition(4).label ' TP vs TN'];
                task = repelem({'2-back','3-back'},8);
                perf = repelem({'TP','TN','TP','TN'},4);
                band = repmat({'alpha','beta','gamma L','gamma H'},1,4);
                with_factors = {'task','perf','band'};
                
            case 4  %%%%%% ANALYSIS OF "MANTAINANCE" %%%%%%
                curr_list = buffer2_list;
                load(fullfile(saveFolder,'maintainance2B_power'));
                band_power = maintainance2B_power;
                nPower = 2;
                figtitle = [condition(2).label];
                task = repelem({'mant1','mant2'},8);
                perf = repelem({'well','bad','well','bad'},4);
                band = repmat({'alpha','beta','gamma L','gamma H'},1,4);
                with_factors = {'task','perf','band'};
                
            case 5  %%%%%% ANALYSIS OF "MANTAINANCE" %%%%%%
                curr_list = buffer3_list;
                load(fullfile(saveFolder,'maintainance3B_power'));
                band_power = maintainance3B_power;
                nPower = 3;
                figtitle = [condition(3).label];
                task = repelem({'mant1','mant2','mant3'},8);
                perf = repelem({'well','bad','well','bad','well','bad'},4);
                band = repmat({'alpha','beta','gamma L','gamma H'},1,6);
                with_factors = {'task','perf','band'};
        end
        
%         figure('Name',[group.seed_info(curr_roi).name ': ' figtitle]);
        
        within = table(task', perf', band');
        within.Properties.VariableNames = with_factors;
        
        data_tmp = nan(size(band_power,2),4,numel(subjects_index),nPower);
        
        for nCond = 1:size(band_power,2)
            for k = 1:nPower
                for ff = 3:6
                    tmp(ff-2,:) = band_power(nCond).roi(curr_roi,ff).power(:,k);
                end
                data_tmp(nCond,:,:,k) = tmp;
            end
        end
        
        % plot data
        for ff = 3:6
            data_m = squeeze(nanmean(data_tmp(:,ff-2,:,:),3));
            data_s = squeeze(nanstd(data_tmp(:,ff-2,:,:),0,3));
            data_plot = data_m+(data_s.*data_m./abs(data_m));
            
            subplot(2,2,ff-2)
            bar(data_plot,'grouped','k','barwidth',0.1);
            hold on
            bar(data_m,'grouped');
            ax = gca;
            ax.YGrid = 'on';
            if numel(curr_list)>2
            ax.XTickLabel = [condition_list(curr_list(1)),condition_list(curr_list(2)),condition_list(curr_list(3)),condition_list(curr_list(4))];
            else
                ax.XTickLabel = [condition_list(curr_list(1)),condition_list(curr_list(2))];
            end
            ax.XTickLabelRotation = 20;
            xlabel('Conditions');
            ylabel('Average Band Power');
            title([bands(ff).label ' band'])
        end
        
        % save and close figure
        saveas(gcf,[group.seed_info(curr_roi).name '_' figtitle],'png');
        close gcf;
        
        
        % build dataset for RANOVA
        if analysis <4 % encoding and response
            data = nan(numel(subjects_index),numel(task));
            idx = [1 3; 2 4]; % well2 bad2; well3 bad3
            for back = 1:2      % 2- and 3- back
                for perf = 1:2      % all well and all bad
                    for ff = 3:6        % alpha, beta, gamma low and gamma high
                        index = ((ff-2)+4*(perf-1))+8*(back-1);
                        data(:,index) = data_tmp(idx(back, perf),ff-2,:,:);
                    end
                end
            end
            
        else % maintenance
            data = nan(numel(subjects_index),numel(task));
            for nCond = 1:size(band_power,2)      % all well and all bad
                for k = 1:nPower      % number of observed maintenance periods
                    for ff = 3:6      % alpha, beta, gamma low and gamma high
                        index = ((ff-2)+4*(k-1))+(4*nPower)*(nCond-1);
                        data(:,index) = data_tmp(nCond,ff-2,:,k);
                    end
                end
            end
        end
        % save data to excel
        roi_name = group.seed_info(curr_roi).name;
        roi_name(strfind(roi_name, ' ')) = [];
        xlswrite(['X:\DATA\_ANALYSIS\ROI' roi_name '_'  analysis_name{analysis} '.xls'],data)
        
        % run RANOVA
        try
            out(curr_roi,analysis) = GP_rmanova(data, within);
        catch
            disp('Check if NET is in the path and remove it!');
        end
    end 
    
    %%% Plot statistics
    res = zeros(3,3);
    for c = 1:5
        idx = find(out(curr_roi,c).pValGG < 0.01);
        res(c,idx) = 1;
    end
    figure(100+curr_roi);
    imagesc(res);
    set(gca, 'xtick',[1:3], 'xticklabel', with_factors, 'ytick', [1:5], 'yticklabel', {'update','resp','trueresp','mant2','mant3'});
    title(group.seed_info(curr_roi).name)
    saveas(gcf,group.seed_info(curr_roi).name,'png');
    close gcf;
end

