
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
                
            case 3  %%%%%% ANALYSIS OF "UPDATING" %%%%%%
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
                with_factors = {'mant','perf','band'};
                
            case 5  %%%%%% ANALYSIS OF "MANTAINANCE" %%%%%%
                curr_list = buffer3_list;
                load(fullfile(saveFolder,'maintainance3B_power'));
                band_power = maintainance3B_power;
                nPower = 3;
                figtitle = [condition(3).label];
                task = repelem({'mant1','mant2','mant3'},8);
                perf = repelem({'well','bad','well','bad','well','bad'},4);
                band = repmat({'alpha','beta','gamma L','gamma H'},1,6);
                with_factors = {'mant','perf','band'};
        end
        
        figure('Name',[group.seed_info(curr_roi).name ': ' figtitle]);
        
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
            ax.XTickLabel = [condition_list(curr_list(1)),condition_list(curr_list(2)),condition_list(curr_list(3)),condition_list(curr_list(4))];
            ax.XTickLabelRotation = 20;
            xlabel('Conditions');
            ylabel('Average Band Power');
            title([bands(ff).label ' band'])
        end
        
        % build dataset for RANOVA
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
        
        % run RANOVA
        out(curr_roi,analysis) = GP_rmanova(data, within);        
    end
end

