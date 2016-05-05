clearvars, clearvars -global, clc
         
         list={'10158_1','10570_1','10578_1','10588_1','10614_1','10648_1'};
         for i=1:length(list)
         AMICO_Setup;
         AMICO_PrecomputeRotationMatrices();
         AMICO_SetSubject(list{i},'data');
         CONFIG.dwiFilename    = fullfile( CONFIG.DATA_path,'NODDI_DWI.nii');
         CONFIG.maskFilename   = fullfile( CONFIG.DATA_path, 'roi_mask.nii');
         CONFIG.schemeFilename = fullfile( CONFIG.DATA_path,'NODDI_DWI.scheme');
         AMICO_LoadData;
         AMICO_SetModel('NODDI');
         AMICO_GenerateKernels( false );
         AMICO_ResampleKernels();
         AMICO_Fit();
         end
         clear 
         exit
