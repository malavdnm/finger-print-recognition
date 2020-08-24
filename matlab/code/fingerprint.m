function [score] = fingerprint(im1,im2)

[found1,x1,y1]=Core_detect(im1);
[found2,x2,y2]=Core_detect(im2);
theta = rotation(im1,im2);
xshift=0;
yshift=0;
if found1 && found2
    xshift=x1-x2 + xshift;
    yshift=y1-y2 + yshift;
    im2_translated= imtranslate(im2,[y1-y2,x1-x2]);
    im2_rotated = imrotate(im2_translated,theta,'bicubic','crop');
    [new_im1,new_im2]=common_region(im1,im2_rotated,xshift,yshift,theta);
    score = BLPOC(new_im1,new_im2);
else
    im2_rotated = imrotate(im2,theta,'bicubic','crop');
    [sc,x,y]=POC(im1,im2_rotated);
    xshift = x + xshift;
    yshift = y + yshift;
    if xshift < 50 && yshift < 50
        im2_translated=imtranslate(im2_rotated,[y,x]);
    else
        im2_translated = im2;
        xshift = 0;
        yshift = 0;
    end
    [new_im1,new_im2]=common_region(im1,im2_translated,xshift,yshift,theta);
    score = BLPOC(new_im1,new_im2);   
end

end

