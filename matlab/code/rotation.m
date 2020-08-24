function [theta] = rotation(im1,im2)

score(1:81) = 0;
for val = -40:40
    im = imrotate(im1,val,'bicubic','crop');
    score(val+41) = BLPOC(im,im2);
end

max_score = max(score);
theta = find(score == max_score) -41;
end