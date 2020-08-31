% repeated measure anova for gossweiler dataset
function [out, res_table] = GP_rmanova_betweenGroups(data, within, group, fileSaveName, band, band_num,group_n)

nCond = size(data,2);

if nCond ~= 12
    disp('DATA should have 12 columns!')
else
    inputData = table(group, data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6),data(:,7),data(:,8),...
        data(:,9),data(:,10),data(:,11),data(:,12));
    rm = fitrm(inputData,'Var2-Var13 ~ group','WithinDesign',within);
    ranovatab  = ranova(rm,'WithinModel','task*perf*phase');
    
end

index = 2;
out.F = ranovatab.F(index:3:end);
out.pVal = ranovatab.pValue(index:3:end);
out.pValGG = ranovatab.pValueGG(index:3:end);
out.correction = find(ranovatab.pValue(index:3:end)-ranovatab.pValueGG(index:3:end));

res_table(1,1) = table({'Group'});
res_table(2,1) = table({'Group*Task'});
res_table(3,1) = table({'Group*Perf'});
res_table(4,1) = table({'Group*Phase'});
res_table(5,1) = table({'Group*Task*Perf'});
res_table(6,1) = table({'Group*Task*Phase'});
res_table(7,1) = table({'Group*Perf*Phase'});
res_table(8,1) = table({'Group*Task*Perf*Phase'});

for ii = 1:8
    res_table(ii,2) = table({ranovatab.DF(index)});
    res_table(ii,3) = table({ranovatab.DF(index+1)});
    res_table(ii,4) = table(out.F(ii));
    res_table(ii,5) = table(out.pVal(ii));
    res_table(ii,6) = table(out.pValGG(ii));
    index = index+3;
end
res_table.Properties.VariableNames = {'Factor','Dof1', 'Dof2', 'F', 'pVal', 'pValGG'};
res_table.Properties.RowNames = {'Group','Group*Task','Group*Perf','Group*Phase','Group*Task*Perf','Group*Task*Phase','Group*Perf*Phase','Group*Task*Perf*Phase'};
% res_table.Properties.DimensionNames = {'Factor','Statistics'};
writetable(res_table, fileSaveName,'Sheet',band);

indexTrend = find(out.pVal<0.08);
index = find(out.pVal<0.05);
sigTest = indexTrend';

comparison = 'lsd'; % Fisher's least significant difference procedure

g1 = 1:group_n(1);
g2 = group_n(1)+1: group_n(2);
d = numel(g1)-numel(g2);
if d < 0
    errordlg('adjust nan vectors in data_tmp!');
end

row = size(res_table,1) + 3;
if ~isempty(sigTest)
    for ii = sigTest
        switch ii
            case 1 % Group
                test{ii} = 'Group';
                ab = xlsColNum2Str(1);
                range_test{ii} = [ab{1} num2str(row)];
                
                tbl = multcompare(rm,'group','ComparisonType',comparison);
                
                data_tmp = [mean(data(g1,:),2) [mean(data(g2,:),2);nan(d,1)]];
                var_names = {'descr','ctrl','hung'};
                
            case 2 % Task
                test{ii} = 'GroupXTask';
                ab = xlsColNum2Str(1);
                range_test{ii} = [ab{1} num2str(row)];
                
                tbl = multcompare(rm,'group','By','task','ComparisonType',comparison);
                
                data_tmp = [mean(data(g1,1:6),2) mean(data(g1,7:12),2) [mean(data(g2,1:6),2);nan(d,1)] [mean(data(g2,7:12),2);nan(d,1)]];
                var_names = {'descr','ctrl:back2','ctrl:back3','hung:back2','hung:back3'};
                
            case 3 % Perf
                test{ii} = 'GroupXPerf';
                ab = xlsColNum2Str(1);
                range_test{ii} = [ab{1} num2str(row)];
                
                tbl = multcompare(rm,'group','By','perf','ComparisonType',comparison);
                
                data_tmp = [mean(data(g1,[1:3 7:9]),2) mean(data(g1,[4:6 10:12]),2) [mean(data(g2,[1:3 7:9]),2);nan(d,1)] [mean(data(g2,[4:6 10:12]),2);nan(d,1)]];
                var_names = {'descr','ctrl:TP','ctrl:TN','hung:TP','hung:TN'};
                
            case 4 % Phase
                test{ii} = 'GroupXPhase';
                ab = xlsColNum2Str(1);
                range_test{ii} = [ab{1} num2str(row)];
                
                tbl = multcompare(rm,'group','By','phase','ComparisonType',comparison);
                
                data_tmp = [mean(data(g1,[1 4 7 10]),2) mean(data(g1,[2 5 8 11]),2) mean(data(g1,[3 6 9 12]),2) [mean(data(g2,[1 4 7 10]),2); nan(d,1)] [mean(data(g2,[2 5 8 11]),2); nan(d,1)] [mean(data(g2,[3 6 9 12]),2); nan(d,1)]];
                var_names = {'descr','ctrl:U','ctrl:M','ctrl:R','hung:U','hung:M','hung:R'};
                
            case 5 % Task*Perf
                test{ii} = 'GroupXTaskXPerf';
                ab = xlsColNum2Str(1);
                range_test{ii} = [ab{1} num2str(row)];
                
                tbl = GP_multcompare_3conditions(inputData,within,'group','group','task','perf',comparison);
                
                data_tmp = [mean(data(g1,[1:3]),2) mean(data(g1,[4:6]),2) mean(data(g1,[7:9]),2) mean(data(g1,[10:12]),2)...
                    [mean(data(g2,[1:3]),2); nan(d,1)] [mean(data(g2,[4:6]),2); nan(d,1)] [mean(data(g2,[7:9]),2); nan(d,1)] [mean(data(g2,[10:12]),2); nan(d,1)]];
                var_names = {'descr','ctrl:b2TP','ctrl:b2TN','ctrl:b3TP','ctrl:b3TN','hung:b2TP','hung:b2TPb2TN','hung:b2TPb3TP','hung:b2TPb3TN'};
                
            case 6 % Task*Phase
                test{ii} = 'GroupXTaskXPhase';
                ab = xlsColNum2Str(1);
                range_test{ii} = [ab{1} num2str(row)];
                
                tbl = GP_multcompare_3conditions(inputData,within,'group','group','task','phase',comparison);
                
                data_tmp = [mean(data(g1,[1 4]),2) mean(data(g1,[2 5]),2) mean(data(g1,[3 6]),2) mean(data(g1,[7 10]),2) mean(data(g1,[8 11]),2) mean(data(g1,[9 12]),2)...
                    [mean(data(g2,[1 4]),2); nan(d,1)] [mean(data(g2,[2 5]),2); nan(d,1)] [mean(data(g2,[3 6]),2); nan(d,1)] [mean(data(g2,[7 10]),2); nan(d,1)] [mean(data(g2,[8 11]),2); nan(d,1)] [mean(data(g2,[9 12]),2); nan(d,1)]];
                var_names = {'descr','ctrl:b2U','ctrl:b2M','ctrl:b2R','ctrl:b3U','ctrl:b3M','ctrl:b3R','hung:b2U','hung:b2M','hung:b2R','hung:b3U','hung:b3M','hung:b3R'};
                
            case 7 % Perf*Phase
                test{ii} = 'GroupXPerfXPhase';
                ab = xlsColNum2Str(1);
                range_test{ii} = [ab{1} num2str(row)];
                
                tbl = GP_multcompare_3conditions(inputData,within,'group','group','perf','phase',comparison);
                
                data_tmp = [mean(data(g1,[1 7]),2) mean(data(g1,[2 8]),2) mean(data(g1,[3 9]),2) mean(data(g1,[4 10]),2) mean(data(g1,[5 11]),2) mean(data(g1,[6 12]),2)...
                    [mean(data(g2,[1 7]),2); nan(d,1)] [mean(data(g2,[2 8]),2); nan(d,1)] [mean(data(g2,[3 9]),2); nan(d,1)] [mean(data(g2,[4 10]),2); nan(d,1)] [mean(data(g2,[5 11]),2); nan(d,1)] [mean(data(g2,[6 12]),2); nan(d,1)]];
                var_names = {'descr','ctrl:TPU','ctrl:TPM','ctrl:TPR','ctrl:TNU','ctrl:TNM','ctrl:TNR','hung:TPU','hung:TPM','hung:TPR','hung:TNU','hung:TNM','hung:TN'};
                
            case 8 % Task*Perf*Phase
                test{ii} = 'GroupXTaskXPerfXPhase';
                ab = xlsColNum2Str(1);
                range_test{ii} = [ab{1} num2str(row)];
                
                % not implemented
                tbl = table;
                
                data_tmp = [data(g1,:) [data(g2,:);nan(d,size(data,2))]];
                var_names = {'descr','ctrl:b2TPU','ctrl:b2TPM','ctrl:b2TPR','ctrl:b2TNU','ctrl:b2TNM','ctrl:b2TNR','ctrl:b3TPU','ctrl:b3TPM','ctrl:b3TPR','ctrl:b3TNU','ctrl:b3TNM','ctrl:b3TNR',...
                    'hung:b2TPU','hung:b2TPM','hung:b2TPR','hung:b2TNU','hung:b2TNM','hung:b2TNR','hung:b3TPU','hung:b3TPM','hung:b3TPR','hung:b3TNU','hung:b3TNM','hung:b3TNR'};
                
        end
        
        m = nanmean(data_tmp);
        s = nanstd(data_tmp)./sqrt(size(data_tmp,1));
        destat(1,1) = table({'mean'});
        destat(2,1) = table({'se'});
        for jj = 1:size(data_tmp,2)
            destat(1,jj+1) = table({m(jj)});
            destat(2,jj+1) = table({s(jj)});
        end
        destat.Properties.VariableNames = var_names;
        ab1 = xlsColNum2Str(1); ab2 = xlsColNum2Str(1+size(tbl,2));
        range_tbl = [ab1{1} num2str(row+1) ':' ab2{1} num2str(row + 1 + size(tbl,1))];
        ab1 = xlsColNum2Str(12); ab2 = xlsColNum2Str(12+size(data_tmp,2));
        range_des = [ab1{1} num2str(row+1) ':' ab2{1} num2str(row+3)];
        
        writetable(tbl, fileSaveName,'Sheet',band,'Range',range_tbl);
        writetable(destat, fileSaveName,'Sheet',band,'Range',range_des);
        row = row + 1 + size(data_tmp,2) + 2;
        
        %%% set colors for significant and trend values
        
        if exist('tbl.pValue')
            
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
