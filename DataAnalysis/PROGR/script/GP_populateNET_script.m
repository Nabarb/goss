%% GP_populateNET_script populates a net configuration file named as specified in output with the entries specified in the opts structure
GP_set_FileList_script;
elements={'eeg','trigger'};
templatefilename='X:\DATA\Net220Template.xlsx';
outputfile={'C:\Users\MSemprini\Fondazione Istituto Italiano Tecnologia\Federico Barban - KinEEG\Data\Connectivity\RS_PRE_KinEEG_true_mri.xlsx'};
GP_Populate_Net(opts,outputfile,templatefilename,elements);
copyfile(outputfile{1},'D:\Barban Federico\TMP data');
