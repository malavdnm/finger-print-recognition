function [new_im1,new_im2] = common_region(im1,im2,xshift,yshift,theta)

[rows,cols]=size(im1);
if theta == 0
    r = rows-4;
    c = cols-4;
else
r = rows*11/12;
c = cols*11/12;
end
centre_x=xshift + floor(rows/2);
centre_y=yshift + floor(cols/2);
xmin=max(1,centre_x-floor(r/2));
xmax=min(r,centre_x+floor(r/2));
ymin=max(1,centre_y-floor(c/2));
ymax=min(c,centre_y+floor(c/2));

new_im1 = im1(xmin:xmax,ymin:ymax) ;
new_im2 = im2(xmin:xmax,ymin:ymax) ;

end

