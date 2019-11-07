% GP_create_triggerFile_scripts creates and saves a trigger files for NET analysis
%
% Marianna Semprini
% IIT, April 2018

GP_set_FileList_script; % load opts structure
for ii=1:numel(opts)
    for ff = 1:numel(opts(ii).set)
        
        file_opts = opts(ii);
        file_opts.set = file_opts.set(ff);
        GP_create_triggerFile_compute(file_opts);
    end
end


% NOTE THAT THIS SCRIPT WILL MAKE USE OF TWO MAGIC NUMBERS:
% TH = xx s, trials in which response were given before TH were removed for TPr and TNr
% ISI = xx s, inter stimulus interval now 2.5 s