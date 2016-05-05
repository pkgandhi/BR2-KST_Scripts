%
% Initialization for AMICO
%
% NB: DO NOT MODIFY THIS FILE!
%     Make a copy of it, adapt to your paths and rename it to "AMICO_Setup.m"
%

global AMICO_code_path AMICO_data_path CAMINO_path CONFIG
global niiSIGNAL niiMASK
global KERNELS bMATRIX

% Path definition: adapt these to your needs
% ==========================================
AMICO_code_path = '/N/u/pkgandhi/BigRed2/AMICO/AMICO-master/matlab';
AMICO_data_path = '/N/dc2/scratch/pkgandhi/DTI_denoise/AMICO_subjects';
CAMINO_path     = '/N/soft/rhel6/camino/2.3.5';
NODDI_path      = '/N/u/pkgandhi/BigRed2/AMICO/AMICO-master/matlab/NODDI_toolbox_v0.9';
SPAMS_path      = '/N/u/pkgandhi/BigRed2/SPAMS/spams-matlab';

if ~isdeployed
    addpath( genpath(NODDI_path) )
    addpath( fullfile(SPAMS_path,'build') )
    addpath( fullfile(AMICO_code_path,'kernels') )
    addpath( fullfile(AMICO_code_path,'models') )
    addpath( fullfile(AMICO_code_path,'optimization') )
    addpath( fullfile(AMICO_code_path,'other') )
    addpath( fullfile(AMICO_code_path,'vendor','NIFTI') )
end
