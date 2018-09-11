function GP_Populate_Net(file_opts,outputfile)

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Very custom made for this applicartion!     %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% writes everything to net configuration file
% WIP
templatefilename='X:\Net216Template.xlsx';
[~, ~, array] = xlsread( templatefilename, 'data' );
protocol={file_opts.protocol};
file_opts_=file_opts;
elements={'eeg','trigger','elec','mr'};
for jj=1:numel(protocol)
        for ii=1:numel(file_opts(jj).set)
            file_opts_.set=file_opts.set(ii);
            for kk=1:numel(elements)
               [dirName, fileName] = GP_file_opts_REPOSITORY(file_opts_, elements{kk});
               array{ii+1,kk}=fullfile(dirName,fileName);
            end
            array(ii+1,6:end)=array(2,6:end);
        end
end
    copyfile(templatefilename,outputfile)
    xlswrite(outputfile,array,'data');
end