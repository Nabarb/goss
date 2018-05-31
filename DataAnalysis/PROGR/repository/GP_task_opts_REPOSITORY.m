function task_opts = GP_task_opts_REPOSITORY(opt)
% function GP_task_opts set parameters according to opt
%
% opt: specifies experiment type
%
% task_opts: task parameters
%
% Marianna Semprini
% IIT, April 20185

switch(opt)
    
    %=========
    case 'pilot'
        %=========
        task_opts.ITI = 2; % inter trial interval in seconds
        task_opts.Lduration = 0.5; % stimulus duration in seconds
        
    case 'noStim'
        %=========
        task_opts.ITI = 2.5; % inter trial interval in seconds
        task_opts.Lduration = 0.5; % stimulus duration in seconds
        
 end