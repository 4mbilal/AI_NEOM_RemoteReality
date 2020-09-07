function out = colortest(in)%#codegen
coder.inline('never');  %keep this function definition separate and not merge with the calling function 
opencv_linkflags = '`pkg-config --cflags --libs opencv4`';
coder.updateBuildInfo('addLinkFlags',opencv_linkflags);
opencv_compileflags = '`pkg-config --cflags --libs opencv4`';
coder.updateBuildInfo('addCompileFlags',opencv_compileflags);

    s = size(in);
    out1 = in(:,:,1);%Red
    out2 = in(:,:,2);%green
    out3 = in(:,:,3);%Blue
    temp = cat(2,out1,out2,out3);
    out = imresize(temp,[s(1),s(2)]);
end

