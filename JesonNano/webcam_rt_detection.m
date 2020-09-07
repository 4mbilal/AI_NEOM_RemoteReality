clear all
close all
clc

v = VideoReader('D:\RnD\Frameworks\Dataset\NEOMchallenge\videos\vid2.avi');

% cam = webcam(2);
% cam.Resolution='1280x480';
% preview(cam);

tic
while(1)
%     frame = snapshot(cam);
    frame = readFrame(v);
%     frame = imresize(frame,[640,480]);
    img = frame(127:353,206:432,:);
%     size(img)
    YPred = squeezenet_svm_predict(img);
    img_str = '';
%     YPred = YPred + 1;
    switch(YPred)
        	case 1 
                img_str = 'Robbie';
        	case 2
                img_str = 'Elephant Mountain';
        	case 3
                img_str = 'Jeddah Floating Mosque';
        	case 4
                img_str = 'AlAhsa Script';
        	case 5
                img_str = 'Qasar Al-Farid (Al-Ula)';
        	case 6
                img_str = 'Riyadh Kingdom Tower';
        	case 7
                img_str = '';	
    end
        
    imshow(img)
    t=toc;
    fps = 1/t;
    str = strcat(img_str,', fps =  ',num2str(fps));
    title(sprintf('%s', str))
   drawnow
   tic
end