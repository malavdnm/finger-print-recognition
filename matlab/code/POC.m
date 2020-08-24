function [score,x,y] = POC(im1,im2)

f1 = fftshift(fft2(im1));
f2 = fftshift(fft2(im2));

pw = (f1.*conj(f2))./(abs(f1.*f2));

Inv_ft = real(ifft2(ifftshift(pw)));

score = max(Inv_ft(:));

[x,y] = find(Inv_ft == score);

end