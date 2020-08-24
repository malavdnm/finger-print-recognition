function [Check,ind_x,ind_y] = Core_detect(Im)
    I = Im;
    [R,C, ~] = size(I) ;
    if ~isa(I,'double'), I = double(I); end	

    mu = mean(I(:)) ;
    sigma = std(I(:)); 
    
    %Normalising Image
    for i = 1:R
        for j = 1:C
            if I(i,j) > mu
                I(i,j) = 0.5 + sqrt(((I(i,j)-mu)^2)/sigma) ;
            else
                I(i,j) = 0.5 - sqrt(((I(i,j)-mu)^2)/sigma) ;
            end
        end
    end

    blocksigma = 3 ;
    orientsmoothsigma = 3 ;

    [Gx,Gy] = imgradientxy(I);

    Gxx = Gx.^2;       % Covariance data for the image gradients
    Gxy = Gx.*Gy;
    Gyy = Gy.^2;

    sze = fix(6*blocksigma);   if ~mod(sze,2); sze = sze+1; end    
    f = fspecial('gaussian', sze, blocksigma);
    Gxx = filter2(f, Gxx); 
    Gxy = 2*filter2(f, Gxy);
    Gyy = filter2(f, Gyy);

     % Analytic solution of principal direction
    denom = sqrt(Gxy.^2 + (Gxx - Gyy).^2) + eps;
    sin2theta = Gxy./denom;            % Sine and cosine of doubled angles
    cos2theta = (Gxx-Gyy)./denom;

    if orientsmoothsigma
            sze = fix(6*orientsmoothsigma);   if ~mod(sze,2); sze = sze+1; end    
            f = fspecial('gaussian', sze, orientsmoothsigma);    
            cos2theta = filter2(f, cos2theta); % Smoothed sine and cosine of
            sin2theta = filter2(f, sin2theta); % doubled angles
    end

    orientim = pi/2 + atan2(sin2theta,cos2theta)/2;     %oriented Image 
 
    Theta = orientim;
    Poincare = zeros(size(I)) ;



    for i=2:R-1
        for j = 2:C-1
            theta = Theta(i-1:i+1,j-1:j+1) ;
            rot_theta = [[theta(2,1),theta(1,1),theta(1,2)];[theta(3,1),theta(2,2),theta(1,3)];[theta(3,2),theta(3,3),theta(2,3)]] ;
            delta = theta - rot_theta ;
    %         [m,n]  = size(delta);
            dell = zeros(size(delta));
            for x=1:3
                for y = 1:3
                    val = delta(x,y) ;
                    if abs(val) < pi/2
                        dell(x,y) = val;
                    elseif val <= -pi/2
                        dell(x,y) = val + pi ;
                    elseif val >= pi/2
                        dell(x,y) = pi - val;
                    end
            dell(2,2) = 0 ;        
            Poincare(i,j) = sum(dell(:))/(2*pi) ;
                end
            end          
        end
    end

    max_val = max(Poincare(:));
    [p,q] = find(Poincare == max_val);
    [m,~] = size(p);
    if m == 1
        ind_x = p;
        ind_y = q;
        if (p < 20 || p > 280) ||(q<20 || q > 280)
            Check = 0;
        else    
            Check = 1;
        end    
    else
        Check = 0;
        ind_x = p(1);
        ind_y = q(1);
    end    
end

