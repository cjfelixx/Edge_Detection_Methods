%% Canny Edge Function

function g = cannyedge(img,Tlo,Thi)

img=im2double(img); g=zeros(size(img));
[imgx,imgy]= size(img,[1 2]);

% 5x5 Gaussian Filter (STEP 1)

G = (1/159).*[2, 4, 5, 4, 2; 4, 9, 12, 9, 4;5, 12, 15, 12, 5;4, 9, 12, 9, 4;2, 4, 5, 4, 2 ];
for i=1:3
X(:,:,i) = conv2(G,img(:,:,i));
end

% Apply Sobel Operator(STEP 2)
hx = [-1 0 1;-2 0 2;-1 0 1]; hy = flip(hx');
for RGB=1:3  
    p = padarray(X,[(length(hx)+1)/2 (length(hx)+1)/2],0);
    for i=1:length(X(:,1,RGB)) 
        for j=1:length(X(1,:,RGB))         
            gx(i,j,RGB) = sum(sum(hx.*p(i:i+length(hx)-1,j:length(hx)+j-1,RGB)));
            gy(i,j,RGB) = sum(sum(hy.*p(i:i+length(hy)-1,j:length(hy)+j-1,RGB)));
        end
    end                 
end
g = abs(sqrt(gx.^2 + gy.^2));
theta = atan2(gy,gx)*180/pi;

    % Discretization of theta (Preliminary to STEP 3)
newtheta = zeros(imgx, imgy);
for i = 1  : imgx
    for j = 1 : imgy
        if ((theta(i, j) > 0 ) && (theta(i, j) < 22.5) || (theta(i, j) > 157.5) && (theta(i, j) < -157.5))
            newtheta(i, j) = 0;
        end
        if ((theta(i, j) > 22.5) && (theta(i, j) < 67.5) || (theta(i, j) < -112.5) && (theta(i, j) > -157.5))
            newtheta(i, j) = 45;
        end
        if ((theta(i, j) > 67.5 && theta(i, j) < 112.5) || (theta(i, j) < -67.5 && theta(i, j) > 112.5))
            newtheta(i, j) = 90;
        end
        if ((theta(i, j) > 112.5 && theta(i, j) <= 157.5) || (theta(i, j) < -22.5 && theta(i, j) > -67.5))
            newtheta(i, j) = 135;
        end
    end
end

%Apply nonmaxima supression (STEP 3)
imgs = zeros(imgx, imgy);
for i = 2  : imgx-1
    for j = 2 : imgy-1      
        switch newtheta(i,j)
            case 0
            if (g(i, j) > g(i, j - 1) && g(i, j) > g(i, j + 1))
                imgs(i, j) = g(i, j);
            else
                imgs(i, j) = 0;
            end
            case 45
            if (g(i, j) > g(i + 1, j - 1) && g(i, j) > g(i - 1, j + 1))
                imgs(i, j) = g(i, j);
            else
                imgs(i, j) = 0;
            end
            case 90
            if (g(i, j) > g(i - 1, j) && g(i, j) > g(i + 1, j))
                imgs(i, j) = g(i, j);
            else
                imgs(i, j) = 0;
            end
            case 135
            if (g(i, j) > g(i - 1, j - 1) && g(i, j) > g(i + 1, j + 1))
                imgs(i, j) = g(i, j);
            else
                imgs(i, j) = 0;
            end   
        end
end
end
% Double Thresholding
Tlo = Tlo*max(max(imgs));
Thi = Thi*max(max(imgs));

g = zeros (imgx, imgy);

for i = 2 : imgx-1
    for j = 2 : imgy-1
        if (imgs(i, j) < Tlo)
            g(i, j) = 0;
        elseif (imgs(i, j) > Thi)
            g(i, j) = 1;
        else
            if ((imgs(i + 1, j) > Thi) || (imgs(i - 1, j) > Thi) || (imgs(i, j + 1) > Thi) || (imgs(i, j - 1) > Thi))
                g(i, j) = 1;
            end
        end
    end
end

end