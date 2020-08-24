tic;
clear;

folder = '../Database/DB1_B/';
[r,c] = size(imread('../Database/DB1_B/101_1.tif'));
m = 9; n = 8;
images = zeros(m*n,r,c);

for i = 1:m
    for j = 1:n
        filename = strcat(folder,'10',num2str(i),'_',num2str(j),'.tif');
        images((i-1)*n+j,1:r,1:c) = im2double(imread(filename));
    end
end

FMR = zeros(1,10);
FNMR = zeros(1,10);

for i = 1:10
    threshold = 0.01*(i+5);
    [FMR(i), FNMR(i)] = MR_calc(images,threshold);
end

FMR2 = zeros(1,10);
FNMR2 = zeros(1,10);

for i = 1:10
    threshold = 0.01*(i+15);
    [FMR2(i), FNMR2(i)] = MR_calc_POC(images,threshold);
end



x = 0:0.1:80;
y = 0:0.1:80;

plot(FNMR,FMR,'-bo');
hold on;
plot(FNMR2,FMR2,'-go');
hold on;
plot(x,y,'r');
toc;