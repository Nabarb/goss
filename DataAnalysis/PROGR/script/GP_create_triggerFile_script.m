% GP_create_triggerFile_scripts creates and saves a trigger files for NET analysis
%
% Marianna Semprini
% IIT, April 2018

GP_set_FileList_script; % load opts structure

for ff = 1:length(opts.set)
    
    file_opts = opts;
    file_opts.set = file_opts.set(ff);
    GP_create_triggerFile_compute(file_opts);
end

