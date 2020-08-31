band_label = {'delta';'theta';'alpha';'beta';'gamma_low';'gamma_high'};
task = [repelem({'2-back'},6) repelem({'3-back'},6)];
perf = [repelem({'TP'},3) repelem({'TN'},3) repelem({'TP'},3) repelem({'TN'},3)];
phase = {'Update','Maint','Resp','Update','Maint','Resp','Update','Maint','Resp','Update','Maint','Resp'};

with_factors = {'task','perf','phase'};
within = table(task', perf', phase');
within.Properties.VariableNames = with_factors;

groups = [{subjects.group}]';


%%% NOTA: index deve essere l'indice delle colonne di data

for curr_roi = 1:nROI
    for ff = 1:numel(band_label)
        
        data = nan(numel(subjects),numel(task));
        for analysis = 1:3
            switch analysis
                case 1             %%%%% "UPDATE" %%%%%%
                    curr_list = update_list;
                    load(fullfile(saveFolder,'update_power'));
                    band_power = update_power;
                    index = [1 7 4 10];
                              
                case 2              %%%%%% "MANTAINANCE" %%%%%%
                    curr_list = maintenance_list;
                    load(fullfile(saveFolder,'maintenance_power'));
                    band_power = maintenance_power;
                    index = [2 8 5 11];
                    
                case 3              %%%%%% "RESPONSE" %%%%%%
                    curr_list = response_list;
                    load(fullfile(saveFolder,'response_power'));
                    band_power = response_power;
                    index = [3 9 6 12];
          
            end
            
            for nCond = 1:numel(index)
                tmp = band_power(nCond).roi(curr_roi,ff).power;
                data(:,index(nCond)) = tmp;
            end
           
        end
        % save data to excel
        roi_name = group.seed_info(curr_roi).label;
        band = band_label{ff};
        xlswrite(['X:\DATA\_ANALYSIS\ROI\' roi_name '_' band '.xls'],data)
        
        % run RANOVA
%         try
            fileSaveName = ['X:\DATA\_ANALYSIS\ROI\ranova_lsd\' roi_name '_stat.xls'];
            out = GP_rmanova_betweenGroups(data, within, groups, fileSaveName, band, ff,group_n);
            stats(curr_roi,ff,:) = out;
            stats_data{curr_roi,ff} = data;
%         catch
%             disp('Check if NET is in the path and remove it!');
%         end
    end
    
    objExcel = actxserver('Excel.Application');
    objExcel.Workbooks.Open(fileSaveName); % Full path is necessary!
    % Delete sheets.
    % Throws an error if the sheets do not exist.
%     objExcel.ActiveWorkbook.Worksheets.Item(['Sheet1']).Delete;
%     objExcel.ActiveWorkbook.Worksheets.Item(['Sheet2']).Delete;
%     objExcel.ActiveWorkbook.Worksheets.Item(['Sheet3']).Delete;
    objExcel.ActiveWorkbook.Save;
    objExcel.ActiveWorkbook.Close;
    objExcel.Quit;
    objExcel.delete;
    
    %%% Plot statistics
    %     res = zeros(3,3);
    %     for c = 1:5
    %         idx = find(out(curr_roi,c).pValGG < 0.01);
    %         res(c,idx) = 1;
    %     end
    %     figure(100+curr_roi);
    %     imagesc(res);
    %     set(gca, 'xtick',[1:3], 'xticklabel', with_factors, 'ytick', [1:5], 'yticklabel', {'update','resp','trueresp','mant2','mant3'});
    %     title(group.seed_info(curr_roi).name)
    %     saveas(gcf,group.seed_info(curr_roi).name,'png');
    %     close gcf;
    
end

save stats stats
save stats_data stats_data
