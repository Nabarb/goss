function tbl = GP_multcompare_3conditions(inputData, within, between, cond1, cond2, cond3, comparison)
% function GP_multcompare_3conditions computes multiple comparisons for
% rmanova among 3 conditions
%
% inputData: rm model
% within: table specifing the statistical design
% between: string containing the name of the between condition
% cond1, cond2, cond3: strings containing the name of the conditions specified in the within table
% comaparison: string specifing the post-hoc test
%
% tbl: table of results in obtained by multcompare function
%
% Marianna Semprini, IIT
% July 2020

if strcmp(between,cond1)
    
    withins2 = within;
    withins2.cond2 = eval(['categorical(withins2.' cond2 ')']);
    withins2.cond3 = eval(['categorical(withins2.' cond3 ')']);
    withins2.cond3_cond2 = withins2.cond3 .* withins2.cond2;
    %%run my repeated measures anova for Directional Biases
    rm = fitrm(inputData,['Var2-Var13 ~' between],'WithinDesign',withins2); % overal fit
    tbl = multcompare(rm,cond1,'By','cond3_cond2','ComparisonType',comparison);
    tbl.Properties.VariableNames(1:3) = {'var1','var2','var3'};
  
else
    withins2 = within;
    withins2.cond1 = eval(['categorical(withins2.' cond1 ')']);
    withins2.cond2 = eval(['categorical(withins2.' cond2 ')']);
    withins2.cond3 = eval(['categorical(withins2.' cond3 ')']);
    
    withins2.cond1_cond2 = withins2.cond1 .* withins2.cond2;
    %%run my repeated measures anova for Directional Biases
    rm = fitrm(inputData,['Var2-Var13 ~' between],'WithinDesign',withins2); % overal fit
    tbl1 = multcompare(rm,'cond1_cond2','By',cond3,'ComparisonType',comparison);
    tbl1.Properties.VariableNames(1:3) = {'var1','var2','var3'};
    
    withins2.cond1_cond3= withins2.cond1 .* withins2.cond3;
    %%run my repeated measures anova for Directional Biases
    rm = fitrm(inputData,['Var2-Var13 ~' between],'WithinDesign',withins2); % overal fit
    tbl2 = multcompare(rm,'cond1_cond3','By',cond2,'ComparisonType',comparison);
    tbl2.Properties.VariableNames(1:3) = {'var1','var2','var3'};
    
    withins2.cond3_cond2 = withins2.cond3 .* withins2.cond2;
    %%run my repeated measures anova for Directional Biases
    rm = fitrm(inputData,['Var2-Var13 ~' between],'WithinDesign',withins2); % overal fit
    tbl3 = multcompare(rm,'cond3_cond2','By',cond1,'ComparisonType',comparison);
    tbl3.Properties.VariableNames(1:3) = {'var1','var2','var3'};
    
    tbl = [tbl1;tbl2;tbl3];
    
end