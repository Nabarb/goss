% repeated measure anova for gossweiler dataset
function [out, res_table] = GP_rmanova(data, within, fileSaveName, band, band_num)

nCond = size(data,2);

if nCond == 12
    between = table(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6),data(:,7),data(:,8),...
        data(:,9),data(:,10),data(:,11),data(:,12));
    rm = fitrm(between,'Var1-Var12 ~ 1','WithinDesign',within);
    ranovatab  = ranova(rm,'WithinModel','task*perf*phase');
    
elseif nCond == 16
    between = table(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6),data(:,7),data(:,8),...
        data(:,9),data(:,10),data(:,11),data(:,12),data(:,13),data(:,14),data(:,15),data(:,16));
    rm = fitrm(between,'Var1-Var16 ~ 1','WithinDesign',within);
    ranovatab  = ranova(rm,'WithinModel','task+perf+band');
    
elseif nCond == 24
    between = table(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6),data(:,7),data(:,8),...
        data(:,9),data(:,10),data(:,11),data(:,12),data(:,13),data(:,14),data(:,15),data(:,16),...
        data(:,17),data(:,18),data(:,19),data(:,20),data(:,21),data(:,22),data(:,23),data(:,24));
    rm = fitrm(between,'Var1-Var24 ~ 1','WithinDesign',within);
    ranovatab  = ranova(rm,'WithinModel','task+perf+band');
    
elseif nCond == 6
    between = table(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6));
    rm = fitrm(between,'Var1-Var6 ~ 1','WithinDesign',within);
    ranovatab  = ranova(rm,'WithinModel','cond+perf');
    
elseif nCond == 8
    between = table(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6),data(:,7),data(:,8));
    rm = fitrm(between,'Var1-Var8 ~ 1','WithinDesign',within);
    ranovatab  = ranova(rm,'WithinModel','cond+perf');
    
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
res_table.Properties.DimensionNames = {'Factor','Statistics'};
writetable(res_table, fileSaveName,'Sheet',band);

indexTrend = find(out.pVal<0.08);
index = find(out.pVal<0.05);
% color significant effects
Excel = actxserver('excel.application');
% Get Workbook object
WB = Excel.Workbooks.Open(fileSaveName,0,false);
% Set the color of cell "A1" of Sheet 1 to RED
% WB.Worksheets.Item(1).Range('A1').Interior.ColorIndex = 3;
for ii = 1:numel(indexTrend)
    WB.Worksheets.Item(band_num).Range(['A' num2str(indexTrend(ii)+1)]).Interior.ColorIndex = 6; % yellow
end
for ii = 1:numel(index)
    WB.Worksheets.Item(band_num).Range(['A' num2str(index(ii)+1)]).Interior.ColorIndex = 3; % red
end

sigTest = find(out.pVal<0.08)';
row = 10;
if ~isempty(sigTest)
    for ii = sigTest
        switch ii
            case 1 % Task
                tbl = multcompare(rm,'task','ComparisonType','bonferroni');
                test = 'Task';
                range{ii} = ['A' num2str(row+1) ':G' num2str(row + 1 + size(tbl,1))];
                
                range_des{ii} = ['K',num2str(row+1),':M',num2str(row+3)];
                data_tmp = [mean(data(:,1:6),2) mean(data(:,7:12),2)];
                var_names = {'descr','back2','back3'};
                
            case 2 % Perf
                tbl = multcompare(rm,'perf','ComparisonType','bonferroni');
                test = 'Perf';
                range{ii} = ['A' num2str(row+1) ':G' num2str(row + 1 + size(tbl,1))];
                               
                range_des{ii} = ['K',num2str(row+1),'M',num2str(row+3)];
                data_tmp = [mean(data(:,[1:3 7:9]),2) mean(data(:,[4:6 9:12]),2)];
                var_names = {'descr','TP','TN'};
                
            case 3 % Phase
                tbl = multcompare(rm,'phase','ComparisonType','bonferroni');
                test = 'Phase';
                range{ii} = ['A' num2str(row+1) ':G' num2str(row + 1 + size(tbl,1))];
                
                range_des{ii} = ['K',num2str(row+1),':N',num2str(row+3)];
                data_tmp = [mean(data(:,[1 4 7 10]),2) mean(data(:,[2 5 8 11]),2) mean(data(:,[3 6 9 12]),2)];
                var_names = {'descr','U','M','R'};
                
            case 4 % Task*Perf
                test = 'TaskXPerf';
                tbl1 = multcompare(rm,'task','By','perf','ComparisonType','bonferroni');
                tbl2 = multcompare(rm,'perf','By','task','ComparisonType','bonferroni');
                tbl1.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl2.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl = [tbl1;tbl2];
                range{ii} = ['A' num2str(row+2+ size(tbl,1)) ':H' num2str(row + 2 + size(tbl,1))];
                
                range_des{ii} = ['K',num2str(row+1),':Q',num2str(row+3)];
                data_tmp = [mean(data(:,[1:3]),2) mean(data(:,[4:6]),2) mean(data(:,[7:9]),2) mean(data(:,[9:12]),2)];
                var_names = {'descr','b2TP','b2TN','b3TP','b3TN'};
                
            case 5 % Task*Phase
                test = 'TaskXPhase';
                tbl1 = multcompare(rm,'task','By','phase','ComparisonType','bonferroni');
                tbl2 = multcompare(rm,'phase','By','task','ComparisonType','bonferroni');
                tbl1.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl2.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl = [tbl1;tbl2];
                range{ii} = ['A' num2str(row+2+ size(tbl,1)) ':H' num2str(row + 2 + size(tbl,1))];
                
                range_des{ii} = ['K',num2str(row+1),':Q',num2str(row+3)];
                data_tmp = [mean(data(:,[1 4]),2) mean(data(:,[2 5]),2) mean(data(:,[3 6]),2) mean(data(:,[7 10]),2) mean(data(:,[8 11]),2) mean(data(:,[9 12]),2)];
                var_names = {'descr','b2U','b2M','b2R','b3U','b3M','b3R'};
                
            case 6 % Perf*Phase
                test = 'PerfXPhase';
                tbl1 = multcompare(rm,'perf','By','phase','ComparisonType','bonferroni');
                tbl2 = multcompare(rm,'phase','By','perf','ComparisonType','bonferroni');
                tbl1.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl2.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                tbl = [tbl1;tbl2];                
                range{ii} = ['A' num2str(row+2+ size(tbl,1)) ':H' num2str(row + 2 + size(tbl,1))];
                
                range_des{ii} = ['K',num2str(row+1),':Q',num2str(row+3)];
                data_tmp = [mean(data(:,[1 4]),2) mean(data(:,[2 5]),2) mean(data(:,[3 6]),2) mean(data(:,[7 10]),2) mean(data(:,[8 11]),2) mean(data(:,[9 12]),2)];
                var_names = {'descr','TPU','TPM','TPR','TNU','TNM','TN'};
                
            case 7 % Task*Perf*Phase
                test = 'TaskXPerfXPhase';
                
                withins2 = within;
                withins2.task = categorical(withins2.task);
                withins2.perf = categorical(withins2.perf);
                withins2.phase = categorical(withins2.phase);
                
                withins2.task_perf = withins2.task .* withins2.perf;
                %%run my repeated measures anova for Directional Biases
                rm = fitrm(between,'Var1-Var12 ~ 1','WithinDesign',withins2); % overal fit
                tbl1 = multcompare(rm,'task_perf','By','phase','ComparisonType','bonferroni');
                tbl1.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                
                withins2.task_phase= withins2.task .* withins2.phase;
                %%run my repeated measures anova for Directional Biases
                rm = fitrm(between,'Var1-Var12 ~ 1','WithinDesign',withins2); % overal fit
                tbl2 = multcompare(rm,'task_phase','By','perf','ComparisonType','bonferroni');
                tbl2.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                
                withins2.phase_perf = withins2.phase .* withins2.perf;
                %%run my repeated measures anova for Directional Biases
                rm = fitrm(between,'Var1-Var12 ~ 1','WithinDesign',withins2); % overal fit
                tbl3 = multcompare(rm,'phase_perf','By','task','ComparisonType','bonferroni');
                tbl3.Properties.VariableNames(1:3) = {'var1','var2','var3'};
                
                tbl = [tbl1;tbl2;tbl3];
                range{ii} = ['A' num2str(row+1) ':L' num2str(row + 1 + size(tbl,1))];
                
                range_des{ii} = ['M',num2str(row+1),':X',num2str(row+3)];
                data_tmp = data;
                var_names = {'descr','b2TPU','b2TPM','b2TPR','b2TNU','b2TNM','b2TNR','b3TPU','b3TPM','b3TPR','b3TNU','b3TNM','b3TNR'};
                
        end
        WB.Worksheets.Item(band_num).Range(['A' num2str(row)]).Value = test;
        
        temp{ii} = tbl;
        row = row + 1 + size(tbl,1)+ + 2;
        
        m = mean(data_tmp);
        s = std(data_tmp);
        destat(1,1) = table({'mean'});
        destat(2,1) = table({'std'});
        for ii = 1:size(data_tmp,2)
            destat(1,ii+1) = table({m(ii)});
            destat(2,ii+1) = table({s(ii)});
        end
        destat.Properties.VariableNames = var_names;
    end
   
end

% Save Workbook
WB.Save();
% Close Workbook
WB.Close();
% Quit Excel
Excel.Quit();

 if ~isempty(sigTest)
    for ii = sigTest
        writetable(temp{ii}, fileSaveName,'Sheet',band,'Range',range{ii});
        writetable(destat, fileSaveName,'Sheet',band,'Range',range_des{ii});
    end
end