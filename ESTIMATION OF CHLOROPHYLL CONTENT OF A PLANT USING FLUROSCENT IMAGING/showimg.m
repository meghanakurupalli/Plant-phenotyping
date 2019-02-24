
%This program is used temporarily to show any display required, 
%instead of disturbing the original code


clearvars
folder = 'G:\cotton plants fluoro\Fluo_TV_90\6-13-17cotton\613-181-01';
filePattern = fullfile(folder, '*.png');
f=dir(filePattern);
files={f.name};
for k=1:numel(files)
	fullFileName = fullfile(folder, files{k});
	cellArrayOfImages{k}=imread(fullFileName);
    I=cellArrayOfImages{k};
        [bw{k}, clr{k}]=lastones(I);
end
imshow(clr{7});
