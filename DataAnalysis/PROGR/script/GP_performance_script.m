% GP_performance_script calculates behavioral performance
%
% Marianna Semprini
% IIT, April 2018

GP_set_FileList_script; % load opts structure
performance=struct('dPrime',[],'hit',[],'fa',[],...
    'resp3back',[],'resp2back',[]);

for ii=1:length(opts)
    file_opts = opts(ii);
    perf_.dPrime = nan(length(file_opts.set),2);
    perf_.hit = nan(length(file_opts.set),2);
    perf_.fa = nan(length(file_opts.set),2);
    perf_.resp2back={};
    perf_.resp3back={};
    
    
    for ff = 1:length(file_opts.set)
        
        file_opts_=file_opts;
        file_opts_.set = file_opts.set(ff);
        perf = GP_performance_compute(file_opts_);
        
        for nn=fieldnames(perf)'
            perf_.(nn{:})(ff,:) = perf.(nn{:});
        end
        
        %         perf_.dPrime(ff,:) = perf.dPrime;
        %         perf_.hit(ff,:) = perf.hit;
        %         perf_.fa(ff,:) = perf.fa;
    end
    performance=appendfields(performance,perf_);
    dirs = GP_dir_opts_REPOSITORY(file_opts.protocol);
    fileName = [opts(ii).protocol, '_', opts(ii).datatype];
    save(fullfile(dirs.dir_performance, fileName),'perf_');
    PopPerf=GP_population_BH_analysis(performance);
end

function struct=appendfields(struct1,struct2)
    for i=fieldnames(struct1)'
        struct.(i{:})=[struct1.(i{:}) ; struct2.(i{:})];
        
    end
end