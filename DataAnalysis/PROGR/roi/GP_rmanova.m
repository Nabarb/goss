% repeated measure anova for gossweiler dataset
function out = GP_rmanova(data, within)

nCond = size(data,2);

if nCond == 16
    between = table(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6),data(:,7),data(:,8),...
        data(:,9),data(:,10),data(:,11),data(:,12),data(:,13),data(:,14),data(:,15),data(:,16));
    rm = fitrm(between,'Var1-Var16 ~ 1','WithinDesign',within);

elseif nCond == 24
    between = table(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6),data(:,7),data(:,8),...
        data(:,9),data(:,10),data(:,11),data(:,12),data(:,13),data(:,14),data(:,15),data(:,16),...
        data(:,17),data(:,18),data(:,19),data(:,20),data(:,21),data(:,22),data(:,23),data(:,24));
    rm = fitrm(between,'Var1-Var24 ~ 1','WithinDesign',within);
end

ranovatab  = ranova(rm,'WithinModel','task+perf+band');
out.pVal = ranovatab.pValue(3:2:end);
out.pValGG = ranovatab.pValueGG(3:2:end);
out.correction = find(ranovatab.pValue(3:2:end)-ranovatab.pValueGG(3:2:end));