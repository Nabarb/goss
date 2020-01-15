analysis_name = {'updating','response','true_response','maintenance2','maintenance3'};

nSub = numel(subjects_index);
data2 = cell(1,4);
data3 = cell(1,4);

for bb = 2:3
    switch bb
        case 2
            perf = repelem({'well','bad'},3);
            cond = repmat({'update','maint1','response'},1,2);
            withfactors = {'perf','cond'};
            nlevel = [2 3];
            order_analysis = [1 4 2];
        case 3
            perf = repelem({'well','bad'},4);
            cond = repmat({'update','maint1','maint2','response'},1,2);
            withfactors = {'perf','cond'};
            nlevel = [2 4];
            order_analysis = [1 5 2];
    end
    
    within = table(perf', cond');
    within.Properties.VariableNames = withfactors;
    
    for curr_roi =1:nROI
        
        roi_name = group.seed_info(curr_roi).name;
        roi_name(strfind(roi_name, ' ')) = [];
        
        for ff = 3:6      % alpha, beta, gamma low and gamma high
            
            data_tmp = nan(nlevel(1)*nlevel(2),nSub);
            
            for an = 1:numel(order_analysis)
                analysis = order_analysis(an);
                
                switch analysis
                    case 1  %%%%%% ANALYSIS OF "UPDATING" %%%%%%
                        curr_list = update_list;
                        load(fullfile(saveFolder,'updating_power'));
                        band_power = updating_power;
                        idx1 = [1 3; 2 4];
                        idx2 = [1];
                        
                        
                    case 2  %%%%%% ANALYSIS OF "RESPONSE" %%%%%%
                        curr_list = response_list;
                        load(fullfile(saveFolder,'response_power'));
                        band_power = response_power;
                        idx1 = [1 3; 2 4];
                        idx2 = [1];
                        
                    case 3  %%%%%% ANALYSIS OF "RESPONSE" %%%%%%
                        curr_list = tptn_list;
                        load(fullfile(saveFolder,'trueresponse_power'));
                        band_power = trueresponse_power;
                        idx1 = [1 3; 2 4];
                        idx2 = [1];
                        
                    case 4  %%%%%% ANALYSIS OF "MANTAINANCE" %%%%%%
                        curr_list = buffer2_list;
                        load(fullfile(saveFolder,'maintainance2B_power'));
                        band_power = maintainance2B_power;
                        idx1 = [1 2];
                        idx2 = [2];
                        
                    case 5  %%%%%% ANALYSIS OF "MANTAINANCE" %%%%%%
                        curr_list = buffer3_list;
                        load(fullfile(saveFolder,'maintainance3B_power'));
                        band_power = maintainance3B_power;
                        idx1 = [1 2; 1 2];
                        idx2 = [2 3];
                end
                
                if an == 3 && bb == 3
                    an = 4;     % trick otherwise following numbering won't work
                end
                
                for nCond = 1:nlevel(1)
                    index = an + nlevel(2)*(nCond-1);
                    for dd = 1:numel(idx2)
                        data_tmp(index,:) = band_power(idx1(bb-1,nCond)).roi(curr_roi,ff).power(:,idx2(dd));
                        index = index+1;
                    end
                end
                
            end
            data{ff} = data_tmp;
            
            % save data to excel
%             xlswrite(['X:\DATA\_ANALYSIS\ROI\' roi_name '_allCond_' num2str(bb) 'back.xls'],data_tmp',label{ff});
            
            % run RANOVA
            try
                out(curr_roi,ff) = GP_rmanova(data_tmp', within);
                %%% Plot statistics
                res = zeros(4,2);
                for c = 3:6
                    if ~isempty(idx)
                        idx = find(out(curr_roi,c).pValGG < 0.05);
                        res(c-2,idx) = 1;
                    end
                end
%                 figure(100+curr_roi);
%                 imagesc(res);
%                 if size(res,1)<4
%                     set(gca, 'xtick',[1:2], 'xticklabel', withfactors, 'ytick', [1:size(res,1)], 'yticklabel', {'update','maint1','resp'});
%                 else
%                     set(gca, 'xtick',[1:2], 'xticklabel', withfactors, 'ytick', [1:size(res,1)], 'yticklabel', {'update','maint1','maint2','resp'});
%                 end
%                 title(group.seed_info(curr_roi).name)
%                 saveas(gcf,['X:\DATA\_ANALYSIS\ROI\' roi_name '_allCond_' num2str(bb)],'png');
%                 close gcf;
                
            catch
                disp('Check if NET is in the path and remove it!');
            end
        end
        
    end
end