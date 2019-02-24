
% This is the major code of the project. 
%In this program, for updating the excel sheet, every time, the folder name and the range for xlswrite are changed.

clearvars
folder = 'G:\cotton plants fluoro\Fluo_TV_90\6-13-17cotton\613-190-10';
filePattern = fullfile(folder, '*.png');
f=dir(filePattern);
files={f.name};
for k=1:numel(files)
	fullFileName = fullfile(folder, files{k});
	cellArrayOfImages{k}=imread(fullFileName);
end
for i=1:numel(files)
        I=cellArrayOfImages{i};
        [bw{i}, clr{i}]=lastones(I);
        bw2{i}=bwareaopen(bw{i},2200);
        [bw3{i},masked_rgb{i}]=image_segmenter(I,bw2{i});
end

for i=1:numel(files)
  A(i,1)=min(masked_rgb{i}(:));
  pink(i)=0;
  yellow(i)=0;
end



for i=1:numel(files)
  A(i,2)=max(masked_rgb{i}(:));
end

[counts,binLocations] = imhist(masked_rgb{22});
bar(binLocations, counts, 'BarWidth', 1);
ylim([0 10000])
xlabel('Itensity');
ylabel('No. of pixels');
m=1;
for i=1:numel(files)
Img=masked_rgb{i};

%imhist(Img);
    [a b c] = size(Img);
    for i = 1:a
        for j = 1:b
               if Img(i,j,1) <= 70 %all backgroung black working 
                 Img(i,j,1) = 0;
                 Img(i,j,2) = 0;
                 Img(i,j,3) = 0;
               elseif Img(i,j,1) > 70 && Img(i,j,1)<=193 % Pink 
                 Img(i,j,1) = 255;
                 Img(i,j,2) = 105;
                 Img(i,j,3) = 180;
                 pink(m)=pink(m)+1;
%                elseif Img(i,j,1) > 130 && Img(i,j,1)<=150 % Yellow
%                  Img(i,j,1) = 238;
%                  Img(i,j,2) = 232;
%                  Img(i,j,3) = 170;   
%                  yellow_pix
               elseif Img(i,j,1) > 193 % Yellow
                 Img(i,j,1) = 238;
                 Img(i,j,2) = 232;
                 Img(i,j,3) = 170;
                 yellow(m)=yellow(m)+1;
            end
        end
    end
    
    figure;
    imshow(Img)
    m=m+1;
end
for i=1:numel(files)
    p=pink(i);
    y=yellow(i);
    A=double(A);
  A(i,3)=p*100/(p+y);
  A(i,4)=y*100/(p+y);
end

filename='data.xlsx'

xlswrite('data.xlsx',A,'A246:D275')
data = data_import('data.xlsx','Sheet1','A2:E275');


figure;
plot(data(:,1),data(:,2),'k*','MarkerSize',5);
title 'My data';
xlabel 'min-value'; 
ylabel 'max-value';

opts = statset('Display','final');
[idx,C] = kmeans(data,2,'Distance','cityblock','Replicates',5,'Options',opts);

figure;
plot(data(idx==1,1),data(idx==1,2),'r.','MarkerSize',12)
hold on
plot(data(idx==2,1),data(idx==2,2),'b.','MarkerSize',12)
plot(C(:,3),C(:,4),'kx','MarkerSize',15,'LineWidth',3)
title 'Clustered data';
xlabel 'min-value'; 
ylabel 'max-value';
legend('Cluster 1','Cluster 2','Centroids','Location','NW')
title 'Cluster Assignments and Centroids'
hold off
[trainedClassifier, validationAccuracy] = SVM(data);

