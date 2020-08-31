% repeated measure anova for gossweiler dataset
function [out, res_table] = GP_rmanova_bonferroni(data, within, fileSaveName, band, band_num)

nCond = size(data,2);

if nCond ~= 12
    disp('DATA should have 12 columns!')
else
    inputData = table(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6),data(:,7),data(:,8),...
        data(:,9),data(:,10),data(:,11),data(:,12));
    rm = fitrm(inputData,'Var1-Var12 ~ 1','WithinDesign',within);
    ranovatab  = ranova(rm,'WithinModel','task*perf*phase');
 
end

out.F = ranovatab.F(3:2:end);
out.pVal = ranovatab.pValue(3:2:end);
out.pValGG = ranovatab.pValueGG(3:2:end);
out.correction = find(ranovatab.pValue(3:2:end)-ranovatab.pValueGG(3:2:end));

res_table(1,1) = table({'Task'});
res_table(2,1) = table({'Perf'});
res_table(3,1) = table({'Phase'});
res_table(4,1) = table({'Task*Perf'});
res_table(5,1) = table({'Task*Phase'});
res_table(6,1) = table({'Perf*Phase'});
res_table(7,1) = table({'Task*Perf*Phase'});

index = 3;
for ii = 1:7
    res_table(ii,2) = table({ranovatab.DF(index)});
    res_table(ii,3) = table({ranovatab.DF(index+1)});
    res_table(ii,4) = table(out.F(ii));
    res_table(ii,5) = table(out.pVal(ii));
    res_table(ii,6) = table(out.pValGG(ii));
    index = index+2;
end
res_table.Properties.VariableNames = {'Factor','Dof1', 'Dof2', 'F', 'pVal', 'pValGG'};
res_table.Properties.RowNames = {'Task','Perf','Phase','Task*Perf','Task*Phase','Perf*Phase','Task*Perf*Phase'};
% res_table.Properties.DimensionNames = {'Factor','Statistics'};
writetable(res_table, fileSaveName,'Sheet',band);

indexTrend = find(out.pVal<0.08);
index = find(out.pVal<0.05);
sigTest = indexTrend';
alphabeth = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
comparison = 'lsd'; % Fisher's least significant difference procedure


row = size(res_table,1) + 3;
if ~isempty(sigTest)
    for ii = sigTest
        switch ii
            case 1 % Task
                test{ii} = 'Task';
                range_test{ii} = [alphabeth(1) num2str(row)];
                
                tbl = multcompare(rm,'task','ComparisonType',comparison);
                
                data_tmp = [mean(data(:,1:6),2) mean(data(:,7:12),2)];
                var_names = {'descr','back2','back3'};
                
            case 2 % Perf
                test{ii} = 'Perf';
                range_test{ii} = [alphabeth(1) num2str(row)];
                
                tbl = multcompare(rm,'perf','ComparisonType',comparison);
                
                data_tmp = [mean(data(:,[1:3 7:9]),2) mean(data(:,[4:6 10:12]),2)];
                var_names = {'descr','TP','TN'};
                
            case 3 % Phase
                test{ii} = 'Phase';
                range_test{ii} = [alphabeth(1) num2str(row)];
                
                tbl = multcompare(rm,'phase','ComparisonType',comparison);
                
                data_tmp = [mean(data(:,[1 4 7 10]),2) mean(data(:,[2 5 8 11]),2) mean(data(:,[3 6 9 12]),2)];
                var_names = {'descr','U','M','R'};
                
            case 4 % Task*Perf
                test{ii} = 'TaskXPerf';
                range_test{ii} = [alphabeth(1) num2str(row)];
                
                tbl1 = multcompare(rm,'task','By','perf','ComparisonType',comparison);
                tbl2 = multcompare(rm,'perf','By','task','ComparisonType',comparison);
                tbl1.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl2.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl = [tbl1;tbl2];
                
                data_tmp = [mean(data(:,[1:3]),2) mean(data(:,[4:6]),2) mean(data(:,[7:9]),2) mean(data(:,[10:12]),2)];
                var_names = {'descr','b2TP','b2TN','b3TP','b3TN'};
                
            case 5 % Task*Phase
                test{ii} = 'TaskXPhase';
                range_test{ii} = [alphabeth(1) num2str(row)];
                
                tbl1 = multcompare(rm,'task','By','phase','ComparisonType',comparison);
                tbl2 = multcompare(rm,'phase','By','task','ComparisonType',comparison);
                tbl1.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl2.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl = [tbl1;tbl2];
                
                data_tmp = [mean(data(:,[1 4]),2) mean(data(:,[2 5]),2) mean(data(:,[3 6]),2) mean(data(:,[7 10]),2) mean(data(:,[8 11]),2) mean(data(:,[9 12]),2)];
                var_names = {'descr','b2U','b2M','b2R','b3U','b3M','b3R'};
                
            case 6 % Perf*Phase
                test{ii} = 'PerfXPhase';
                range_test{ii} = [alphabeth(1) num2str(row)];
                
                tbl1 = multcompare(rm,'perf','By','phase','ComparisonType',comparison);
                tbl2 = multcompare(rm,'phase','By','perf','ComparisonType',comparison);
                tbl1.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl2.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl = [tbl1;tbl2];
                
                data_tmp = [mean(data(:,[1 7]),2) mean(data(:,[2 8]),2) mean(data(:,[3 9]),2) mean(data(:,[4 10]),2) mean(data(:,[5 11]),2) mean(data(:,[6 12]),2)];
                var_names = {'descr','TPU','TPM','TPR','TNU','TNM','TN'};
                
            case 7 % Task*Perf*Phase
                test{ii} = 'TaskXPerfXPhase';
                range_test{ii} = [alphabeth(1) num2str(row)];
                
                withins2 = within;
                withins2.task = categorical(withins2.task);
                withins2.perf = categorical(withins2.perf);
                withins2.phase = categorical(withins2.phase);
                
                withins2.task_perf = withins2.task .* withins2.perf;
                %%run my repeated measures anova for Directional Biases
                rm = fitrm(inputData,'Var1-Var12 ~ 1','WithinDesign',withins2); % overal fit
                tbl1 = multcompare(rm,'task_perf','By','phase','ComparisonType',comparison);
                tbl1.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                
                withins2.task_phase= withins2.task .* withins2.phase;
                %%run my repeated measures anova for Directional Biases
                rm = fitrm(inputData,'Var1-Var12 ~ 1','WithinDesign',withins2); % overal fit
                tbl2 = multcompare(rm,'task_phase','By','perf','ComparisonType',comparison);
                tbl2.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                
                withins2.phase_perf = withins2.phase .* withins2.perf;
                %%run my repeated measures anova for Directional Biases
                rm = fitrm(inputData,'Var1-Var12 ~ 1','WithinDesign',withins2); % overal fit
                tbl3 = multcompare(rm,'phase_perf','By','task','ComparisonType',comparison);
                tbl3.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                
                tbl = [tbl1;tbl2;tbl3];
                
                data_tmp = data;
                var_names = {'descr','b2TPU','b2TPM','b2TPR','b2TNU','b2TNM','b2TNR','b3TPU','b3TPM','b3TPR','b3TNU','b3TNM','b3TNR'};
                
        end
        
        m = mean(data_tmp);
        s = std(data_tmp)./sqrt(size(data_tmp,1));
        destat(1,1) = table({'mean'});
        destat(2,1) = table({'se'});
        for jj = 1:size(data_tmp,2)
            destat(1,jj+1) = table({m(jj)});
            destat(2,jj+1) = table({s(jj)});
        end
        destat.Properties.VariableNames = var_names;
        
        range_tbl = [alphabeth(1) num2str(row+1) ':' alphabeth(1+size(tbl,2)) num2str(row + 1 + size(tbl,1))];
        range_des = [alphabeth(12) num2str(row+1) ':' alphabeth(12+size(data_tmp,2)) num2str(row+3)];
        
        writetable(tbl, fileSaveName,'Sheet',band,'Range',range_tbl);
        writetable(destat, fileSaveName,'Sheet',band,'Range',range_des);
        row = row + 1 + size(tbl,1) + 2;
        
        %%% set colors for significant and trend values
        
        % open Excel Application
        Excel = actxserver('excel.application');
        WB = Excel.Workbooks.Open(fileSaveName,0,false); % Get Workbook object
        sheet = Excel.ActiveWorkbook.Sheets.Item(band_num);
        sheet.Activate
        
        inter_index  = find(tbl.pValue<0.05);
        inter_indexTrend = find(tbl.pValue<0.08);
        for kk = 1:numel(inter_indexTrend) % highlight in yellow
            start = str2num(range_tbl(2:3));
            sel_range = ['A' num2str(start+inter_indexTrend(kk)) ':B' num2str(start+inter_indexTrend(kk))];
            WB.Worksheets.Item(band_num).Range(sel_range).Interior.ColorIndex = 6; % red
        end
        for kk = 1:numel(inter_index) % highlight in red
            start = str2num(range_tbl(2:3));
            sel_range = ['A' num2str(start+inter_index(kk)) ':B' num2str(start+inter_index(kk))];
            WB.Worksheets.Item(band_num).Range(sel_range).Interior.ColorIndex = 3; % red
        end
        
        % Save Workbook
        WB.Save();
        % Close Workbook
        WB.Close();
        % Quit Excel
        Excel.Quit();
    end
    
    
end

% NOW WRITE SINGLE CELLS AND COLOR THEM

Excel = actxserver('excel.application');
WB = Excel.Workbooks.Open(fileSaveName,0,false); % Get Workbook object
sheet = Excel.ActiveWorkbook.Sheets.Item(band_num);
sheet.Activate

cells = Excel.ActiveSheet.Range('A1:Z1');
set(cells.Font, 'Bold', true);

for ii = 1:numel(indexTrend) % highlight in yellow, write test name above the posthoc table
    WB.Worksheets.Item(band_num).Range(['A' num2str(indexTrend(ii)+1)]).Interior.ColorIndex = 6; % yellow
    
    WB.Worksheets.Item(band_num).Range([range_test{indexTrend(ii)}]).Value = test{indexTrend(ii)};
    bold_range = range_test{indexTrend(ii)};
    bold_range = [bold_range(1:3) ':Z' num2str(str2num(bold_range(2:3))+1)];
    cells = Excel.ActiveSheet.Range(bold_range);
    set(cells.Font, 'Bold', true);
end
for ii = 1:numel(index) % highlight in red
    WB.Worksheets.Item(band_num).Range(['A' num2str(index(ii)+1)]).Interior.ColorIndex = 3; % red
end


% Save Workbook
WB.Save();
% Close Workbook
WB.Close();
% Quit Excel
Excel.Quit();
