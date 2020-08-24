function [score] = BLPOC(im1,im2)

f1 = fftshift(fft2(im1));
f2 = fftshift(fft2(im2));

pw = (f1.*conj(f2))./(abs(f1.*f2));

[r,c] = size(pw);

k1 = floor(r/6);
k2 = floor(c/6);
x = floor(r/2);
y = floor(c/2);

crop = pw(x-k1:x+k1,y-k2:y+k2);

Inv_ft = real(ifft2(ifftshift(crop)));

a1 = max(Inv_ft(:));
Inv_ft(find(Inv_ft == a1)) = 0;
a2 = max(Inv_ft(:));
score = a1+a2;
end