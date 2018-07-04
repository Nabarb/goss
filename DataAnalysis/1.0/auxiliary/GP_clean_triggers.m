function marker = GP_clean_triggers(marker,opt)
%% GP_clean_triggers cleans the trigger structure
% removes triggers when the delay between letter presentation and press is 
% higher than the inter stimulus time;
%
% Usage:marker = GP_clean_triggers(marker,opt)
% 
%       marker is the trigger structure
%       opt is the options structure.
%               needs to have a task.ITI and task.Lduration subfields
% 
% Federico Barban, IIT
 
% th = (opt.task.ITI - opt.task.Lduration) * opt.rec.freq;
th = (opt.task.ITI - 1)* opt.rec.freq; % so we keep 1s of "clean" signal for the baseline of next trial
NBlocks = size(marker.P_hit,2);
for ii = 1:NBlocks
    % hit
    delay = marker.P_hit{ii}-marker.L_hit{ii};
    ind = delay < th;
    marker.P_hit{ii} = marker.P_hit{ii}(ind);
    marker.L_hit{ii} = marker.L_hit{ii}(ind);
    
    % false alarm
    delay = marker.P_false{ii} - marker.L_false{ii};
    ind = delay < th;
    marker.P_false{ii} = marker.P_false{ii}(ind);
    marker.L_false{ii} = marker.L_false{ii}(ind);

end