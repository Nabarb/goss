function GP_Populate_Net(file_opts,outputfile,templatefilename,elements)

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Very custom made for this applicartion!     %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% writes everything to net configuration file
% WIP
[~, ~, array_] = xlsread( templatefilename, 'data' );
protocol={file_opts.protocol};
file_opts_=file_opts;
for jj=1:numel(protocol)
    Nsubjects=numel(file_opts(jj).set);
    array=array_;
    array(2:Nsubjects+1,:)=repmat(array_(2,:),Nsubjects,1);
        for ii=1:numel(file_opts(jj).set)
            file_opts_.set=file_opts.set(ii);
            for kk=1:numel(elements)
               [dirName, fileName] = GP_file_opts_REPOSITORY(file_opts_, elements{kk});
               array{ii+1,kk}=fullfile(dirName,fileName);
            end
%             array(ii+1,6:end)=array(2,6:end);
        end
        file=strsplit(outputfile{jj},'.');
        out=sprintf('%s.xlsx',file{1});
        copyfile(templatefilename,out);
        xlswrite(out,array,'data');
end
end