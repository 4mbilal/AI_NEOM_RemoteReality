function out = squeezenet_svm_predict(img)%#codegen
coder.inline('never');  %keep this function definition separate and not merge with the calling function 
opencv_linkflags = '`pkg-config --cflags --libs opencv4` -lpthread';
coder.updateBuildInfo('addLinkFlags',opencv_linkflags);
opencv_compileflags = '`pkg-config --cflags --libs opencv4` -lpthread';
coder.updateBuildInfo('addCompileFlags',opencv_compileflags);

persistent net;
persistent v;
if isempty(net)
    net = coder.loadDeepLearningNetwork('squeezenet', 'squeezenet');
    v = coder.load('svm_classifier.mat');
end

% img = imresize(in,[227,227]);
layer = 'pool10';
featuresTest = activations(net,img,layer,'OutputAs','channels');
featuresTest = featuresTest(:);
featuresTest = reshape(featuresTest,1000,[])';
[out,score] = predict(v.classifier,featuresTest);
% if(score<-0.1)
%     out = 7;
% end
% score(out)

end


