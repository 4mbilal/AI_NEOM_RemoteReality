close all
clear all
clc
% takes roughly 2.5 minutes to compile and upload on device

% For OCV support, add both addLinkFlags and addCompileFlags.  
% To compile natively on Nano use the following command. This command appears when Matlab gives an error due to some reason while compiling
% touch -c /home/brainiac/MatlabDev/MATLAB_ws/R2020a/D/RnD/Frameworks/Matlab/ML/CNN/Example04_JetsonNano_Squeezenet/codegen/exe/squeezenet_svm_Nano_predict/*.*;make  -f squeezenet_svm_Nano_predict_rtw.mk all MATLAB_WORKSPACE="/home/brainiac/MatlabDev/MATLAB_ws/R2020a" -C /home/brainiac/MatlabDev/MATLAB_ws/R2020a/D/RnD/Frameworks/Matlab/ML/CNN/Example04_JetsonNano_Squeezenet/codegen/exe/squeezenet_svm_Nano_predict

device = 0;     %Change to opencv4 in squeezenet_svm_predict
% device = 1;     %Change to opencv in squeezenet_svm_predict

if(device ==0)
    hwobj = jetson('192.168.0.167','brainiac','123');
%     hwobj.getCameraList
    cfg = coder.gpuConfig('exe');
%     cfg = coder.gpuConfig('lib');
    % cfg.TargetLang = 'C++';
%     cfg.StackUsageMax=50000;
    cfg.Hardware = coder.hardware('NVIDIA Jetson');
    cfg.Hardware.BuildDir = '~/MatlabDev';
    cfg.CustomSource = ['main_rr.cpp',' ','MJPEGWriter.cpp'];
    % cfg.GenerateExampleMain = 'GenerateCodeAndCompile';%This will create example main which will conflict with the main in the supplied source file.
    dlcfg = coder.DeepLearningConfig('TENSORRT');
    % dlcfg = coder.DeepLearningConfig('CUDNN');
    cfg.DeepLearningConfig = dlcfg;
%     codegen -config cfg squeezenet_svm_predict -args {ones(640, 480, 3,'uint8')} -report
    codegen -config cfg squeezenet_svm_predict -args {ones(227, 227, 3,'uint8')} -report
end

if(device ==1)
    cfg = coder.config('exe');
%     cfg = coder.config('lib');
    cfg.TargetLang = 'C++';
    cfg.Hardware = coder.hardware('Raspberry Pi');
    cfg.Hardware.BuildDir = '~/MatlabDev';
    cfg.CustomSource = ['main_rr.cpp',' ','MJPEGWriter.cpp'];
    dlcfg = coder.DeepLearningConfig('arm-compute');
    dlcfg.ArmArchitecture = 'armv7';
    dlcfg.ArmComputeVersion = '19.05';
    cfg.DeepLearningConfig = dlcfg;
%     codegen -config cfg squeezenet_svm_predict -args {ones(640, 480, 3,'uint8')} -report
    codegen -config cfg squeezenet_svm_predict -args {ones(227, 227, 3,'uint8')} -report
%     r = raspi('192.168.1.27','pi','123');
%     r.putFile('D:\RnD\Frameworks\Dataset\NEOMchallenge\videos\vid2.avi', '~/Videos');
end

