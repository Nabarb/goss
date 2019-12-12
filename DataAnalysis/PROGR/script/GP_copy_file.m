
input_folder = 'X:\DATA\GOSS100_noStimH\CT_NoStimH_templ_mri\group\eeg_source\ers_erd_results\mni';
output_folder = 'X:\DATA\_ANALYSIS\mni';
selection = '_rfx_thres.nii';

list = dir(input_folder);
sel_size = numel(selection)-1;

for ii = 3:size(list,1)
    
    if length(list(ii).name)<= sel_size
        % do nothing
    elseif strcmp(list(ii).name(end-sel_size:end),selection)
        copyfile([input_folder '\' list(ii).name],[output_folder '\' list(ii).name]);
    end
end
