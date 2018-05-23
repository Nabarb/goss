% GP_performance_script calculates behavioral performance
%
% Marianna Semprini
% IIT, April 2018

GP_set_FileList_script; % load opts structure

performance.dPrime = nan(length(opts.set),2);
performance.hit = nan(length(opts.set),2);
performance.fa = nan(length(opts.set),2);

for ff = 1:length(opts.set)
    
    file_opts = opts;
    file_opts.set = file_opts.set(ff);
    perf = GP_performance_compute(file_opts);
    
    performance.dPrime(ff,:) = perf.dPrime;
    performance.hit(ff,:) = perf.hit;
    performance.miss(ff,:) = perf.fa;
end

dirs = GP_dir_opts_REPOSITORY;
fileName = [opts_BH_analysis, '_', opts.dataset];
save(fullfile(dirs.dir_performance, fileName),'performance');