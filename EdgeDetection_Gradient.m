%% Gradient Edge Detection
clc; close all; clear all;

img1 = imread('images/rsz_easyimg.png');
img2= imread('images/test.png');
img3 = imresize(imread('images/jennie.png'), [400 400]);

filtername = 'prewitt';
% g1 = gradientedge(img1, filtername, .1);
% g2 = gradientedge(img2, filtername, .001);
% g3 = gradientedge(img3, filtername, .02);
% g1 = cannyedge(img1, .04, .09);
% g2 = cannyedge(img2, 0.04,.09);
% g3 = cannyedge(img3, .04, .09);
%% 
% Saving Files

switch filtername
    case 'prewitt'
%         figure;
%         I=cat(3,g1,g2,g3);
%         montage(I,'size',[1 3]);   
%         saveas(gcf,'prewitt.png')
    case 'sobel'
        figure;
%         I=cat(3,g1,g2,g3);
%         montage(I,'size',[1 3]);
%         saveas(gcf,'sobel1.png')        
    case 'roberts'   
%         figure;
%         I=cat(3,g1,g2,g3);
%         montage(I,'size',[1 3]);
%         saveas(gcf,'roberts.png')  
    case 'kirch'   
%         figure;
%         I=cat(3,g1,g2,g3);
%         montage(I,'size',[1 3]);
%         saveas(gcf,'kirch.png')  
    case 'canny'   
%         figure;
%         I=cat(3,g1,g2,g3);
%         montage(I,'size',[1 3]);
%         saveas(gcf,'canny.png')
end
%%  Gradient Function

function g = gradientedge(img,filtername,T)

%As of now, the threshold is not being used.

img=im2double(img); g=zeros(size(img));

switch filtername
    case 'roberts'
        hx = [-1 0; 0 1;]; hy = [0 -1; 1 0];
    case 'prewitt'
        hx = [-1 -1 -1; 0 0 0; 1 1 1]; hy = flip(hx');
    case 'sobel'
        hx = [-1 0 1;-2 0 2;-1 0 1]; hy = flip(hx');
    case 'kirch'
        hN = [-3,-3,5; -3,0,5;-3,-3,5]; hS = flip(hN');       
        hNW = [-3,5,5; -3,0,5;-3,-3,-3]; hSE = flip(hN');       
        hW = [5,5,5; -3,0,-3; -3,-3,-3]; hE = flip(hN');       
        hSW = [5,5,-3; 5,0,-3; -3,-3,-3]; hNE = flip(hN');       
end

if length(size(img)) == 3
for RGB=1:3  
    
    switch filtername
        case 'prewitt'
            p = padarray(img,[(length(hx)+1)/2 (length(hx)+1)/2],0);
            for i=1:length(img(:,1,RGB)) 
                for j=1:length(img(1,:,RGB))         
                    gx(i,j,RGB) = sum(sum(hx.*p(i:i+length(hx)-1,j:length(hx)+j-1,RGB)));
                    gy(i,j,RGB) = sum(sum(hy.*p(i:i+length(hy)-1,j:length(hy)+j-1,RGB)));
                end
            end 
            g = abs(sqrt(gx.^2 + gy.^2));
            % g = abs(gx)+abs(gy);
        case 'sobel'
            p = padarray(img,[(length(hx)+1)/2 (length(hx)+1)/2],0);
            for i=1:length(img(:,1,RGB)) 
                for j=1:length(img(1,:,RGB))         
                    gx(i,j,RGB) = sum(sum(hx.*p(i:i+length(hx)-1,j:length(hx)+j-1,RGB)));
                    gy(i,j,RGB) = sum(sum(hy.*p(i:i+length(hy)-1,j:length(hy)+j-1,RGB)));
                end
            end            
            g = abs(sqrt(gx.^2 + gy.^2));
            % g = abs(gx)+abs(gy);
        case 'roberts'   
            p = padarray(img,[(length(hx)+1) (length(hx)+1)],0);
            for i=1:length(img(:,1,RGB)) 
                for j=1:length(img(1,:,RGB))         
                gx(i,j,RGB) = sum(sum(hx.*p(i:i+length(hx)-1,j:length(hx)+j-1,RGB)));
                gy(i,j,RGB) = sum(sum(hy.*p(i:i+length(hy)-1,j:length(hy)+j-1,RGB)));
                end
            end 
            g = abs(sqrt(gx.^2 + gy.^2));
            % g = abs(gx)+abs(gy);          
        case 'kirch' 
            p = padarray(img,[(length(hN)+1)/2 (length(hS)+1)/2],0);   
            for i=1:length(img(:,1,RGB)) 
                for j=1:length(img(1,:,RGB))
                    x=0;
                gN(i,j,RGB) = sum(sum(hN.*p(i:i+length(hN)-1,j:length(hN)+j-1,RGB)));
                gS(i,j,RGB) = sum(sum(hS.*p(i:i+length(hS)-1,j:length(hS)+j-1,RGB)));
                gNW(i,j,RGB) = sum(sum(hNW.*p(i:i+length(hNW)-1,j:length(hNW)+j-1,RGB)));
                gSE(i,j,RGB) = sum(sum(hSE.*p(i:i+length(hSE)-1,j:length(hSE)+j-1,RGB)));
                gW(i,j,RGB) = sum(sum(hW.*p(i:i+length(hW)-1,j:length(hW)+j-1,RGB)));
                gE(i,j,RGB) = sum(sum(hE.*p(i:i+length(hE)-1,j:length(hE)+j-1,RGB)));
                gSW(i,j,RGB) = sum(sum(hSW.*p(i:i+length(hSW)-1,j:length(hSW)+j-1,RGB)));
                gNE(i,j,RGB) = sum(sum(hNE.*p(i:i+length(hNE)-1,j:length(hNE)+j-1,RGB))); 
                x(i,j) = max(gN(i,j,RGB),gS(i,j,RGB));
                x(i,j) = max(x(i,j),gNW(i,j,RGB));
                x(i,j) = max(x(i,j),gSE(i,j,RGB));
                x(i,j) = max(x(i,j),gW(i,j,RGB));
                x(i,j) = max(x(i,j),gE(i,j,RGB));
                x(i,j) = max(x(i,j),gSW(i,j,RGB));
                x(i,j) = max(x(i,j),gNE(i,j,RGB));
                g(i,j,RGB) = x(i,j);
                end
            end            
    end  
end

g = rgb2gray(g);
imshow(g)
end
end