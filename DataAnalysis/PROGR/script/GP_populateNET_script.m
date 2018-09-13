%% GP_populateNET_script populates a net configuration file named as specified in output with the entries specified in the opts structure
GP_set_FileList_script;
elements={'eeg','trigger'};
templatefilename='X:\Net216Template.xlsx';
outputfile={'X:\DATA\noStimH\CT_NoStimH_templ_mri.xlsx'};
GP_Populate_Net(opts,outputfile,templatefilename,elements);
