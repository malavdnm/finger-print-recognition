function [FMR, FNMR] = MR_calc(images, threshold)

true_case = 0; false_case = 0;
true_pos = 0; true_neg = 0; false_pos = 0; false_neg = 0;
[l,r,c] = size(images);
 
for i = 1:l
    for j = (i+1):l
        im1 = reshape(images(i,1:r,1:c),[r,c]);
        im2 = reshape(images(j,1:r,1:c),[r,c]);
        sc = fingerprint(im1,im2);
        p1 = 1+floor((i-1)/8);
        p2 = 1+floor((j-1)/8);
        if p1 == p2
            true_case = true_case + 1;
            if sc > threshold
                true_pos = true_pos + 1;
            else
                true_neg = true_neg + 1;
            end
        else
            if (mod((j-i),8) == 0) && (mod(i,8) == 2)
                false_case = false_case + 1;
                if sc > threshold
                    false_pos = false_pos + 1;
                else
                    false_neg = false_neg + 1;
                end
            end
        end
    end
end

FMR = 100*(false_pos/false_case);
FNMR = 100*(true_neg/true_case);

end