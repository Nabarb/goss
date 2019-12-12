%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Build dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for analysis = 1:5
    switch analysis
        case 1  %%%%%% ANALYSIS OF "UPDATING" %%%%%%
            curr_list = update_list;
            cond = condition(1);
        case 2  %%%%%% ANALYSIS OF "RESPONSE" %%%%%%
            curr_list = response_list;
            cond = condition(4);
        case 3  %%%%%% ANALYSIS OF "UPDATING" %%%%%%
            curr_list = tptn_list;
            cond = condition(4);
        case 4  %%%%%% ANALYSIS OF "MANTAINANCE" %%%%%%
            curr_list = buffer2_list;
            cond = condition(2);
        case 5  %%%%%% ANALYSIS OF "MANTAINANCE" %%%%%%
            curr_list = buffer3_list;
            cond = condition(3);
    end
    for ll = 1:numel(curr_list)
        band_power(ll) = cond;
    end
    for curr_roi = 1:nROI
        
        counter = 0;
        for ll = curr_list
            counter = counter+1;
            band_power(counter).performance = condition_list{ll};
            band_power(counter).bands = bands;
            subject_counter = 0;
            for ss = subjects_index
                subject_counter = subject_counter+1;
                tmp_ers_erd = load(fullfile(list(ss).folder,list(ss).name,'eeg_source\ers_erd_results','ers_erd_roi.mat'));
                for jj = 3:6
                    tmp = squeeze(tmp_ers_erd.ers_erd_roi(ll).tf_map(curr_roi,:,:));
                    f_range = bands(jj).range;
                    n = size(band_power(counter).range,1);
                    for k = 1:n
                        x_range(1) = find(round(tmp_ers_erd.ers_erd_roi(ll).time_axis) == band_power(counter).range(k,1));
                        x_range(2) = find(round(tmp_ers_erd.ers_erd_roi(ll).time_axis) == band_power(counter).range(k,2));
                        %                         eval(['band_power(counter).roi(curr_roi,jj).power'(subject_counter,k) = mean(mean(tmp(f_range(1):f_range(2),x_range(1):x_range(2))))']);
                        band_power(counter).roi(curr_roi,jj).power(subject_counter,k) = mean(nanmean(tmp(f_range(1):f_range(2),x_range(1):x_range(2))));
                    end
                end
            end
        end
    end
    switch analysis
        case 1
            updating_power = band_power;
            save(fullfile(saveFolder,'updating_power'),'updating_power');
        case 2
            response_power = band_power;
            save(fullfile(saveFolder,'response_power'),'response_power');
        case 3
            trueresponse_power = band_power;
            save(fullfile(saveFolder,'trueresponse_power'),'trueresponse_power');
        case 4
            maintainance2B_power = band_power;
            save(fullfile(saveFolder,'maintainance2B_power'),'maintainance2B_power');
        case 5
            maintainance3B_power = band_power;
            save(fullfile(saveFolder,'maintainance3B_power'),'maintainance3B_power');
    end
    clear band_power tmp;
end
