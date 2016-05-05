function [bvecs_corr,angular_motion_deg,angular_motion_rad] = f_correct_bvec(fileRef,fileDWI,file_bvec,fileDWI_corr,file_bvec_corr,path2DWI,FSLsetup,path2FSL)

    if nargin<7
        path2FSL = '/N/soft/rhel6/fsl/5.0.8/bin';
        FSLsetup = 'FSLDIR=/N/soft/rhel6/fsl/5.0.8; . ${FSLDIR}/etc/fslconf/fsl.sh; PATH=${FSLDIR}/bin:${PATH}; export FSLDIR PATH';
        ldpath= 'export LD_LIBRARY_PATH=/N/soft/rhel6/gcc/4.9.2/lib64/';
    end

    bvecs = dlmread(file_bvec,'');
    numVols = max(size(bvecs));
    
    if size(bvecs,1)==3
        bvecs = bvecs';
    end

    bvecs_corr = zeros(size(bvecs));
    
    fileMatrix = fullfile(path2DWI,'temp_matrix.txt');
    for dwi_dir = 1:numVols
        dwi_dir
        sentence = sprintf('%s;%s;%s/fslroi %s temp.nii.gz %d 1',ldpath,FSLsetup,path2FSL,fileDWI,dwi_dir-1)
        [status,result] = system(sentence);
        sentence = sprintf('%s;%s;%s/flirt -in temp.nii.gz -ref %s -datatype short -interp nearestneighbour -nosearch -o temp_corr.nii.gz -paddingsize 1 -dof 6 -omat %s',...
            ldpath,FSLsetup,path2FSL,fileRef,fileMatrix)
        [status,result] = system(sentence);
        matrix = dlmread(fileMatrix);
        matrix(1:3,1:3)
        bvecs_corr(dwi_dir,:) = matrix(1:3,1:3) * bvecs(dwi_dir,:)';
        clear matrix;
        sentence = sprintf('rm %s',fileMatrix);
        [status,result] = system(sentence);

        if dwi_dir==1
            sentence = sprintf('%s;%s;%s/fslmerge -t %s temp_corr.nii.gz',ldpath,FSLsetup,path2FSL,fileDWI_corr);
            [status,result] = system(sentence);
          
        else
            sentence = sprintf('%s;%s;%s/fslmerge -t %s %s temp_corr.nii.gz',ldpath,FSLsetup,path2FSL,fileDWI_corr,fileDWI_corr);
            [status,result] = system(sentence);
           
        end
            
    end
    
    dlmwrite(file_bvec_corr,bvecs_corr','delimiter',' ','precision','%.8f')
    
    angular_motion_rad = zeros(numVols,1);
    angular_motion_deg = zeros(numVols,1);
    for i=1:numVols
        dir_uncorr = bvecs(i,:);
        dir_corr = bvecs_corr(i,:);
        angular_motion_rad(i) = acos(sum(dir_uncorr.*dir_corr)./sqrt(sum(dir_uncorr.^2))./sqrt(sum(dir_corr.^2)));
        angular_motion_deg(i) = 180*angular_motion_rad(i)./pi;
    end