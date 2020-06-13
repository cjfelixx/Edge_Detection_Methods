%Get easy image
easy = imread('jennie.png');

easy = im2double(easy);

%Make array of zeroes 
edges = zeros(400);

Threshold = 0.057;

for column = 1:399
    for row = 1:399
        
        currentRed = easy(column,row,1);
        nextRed_x = easy(column+1,row,1);
        nextRed_y = easy(column,row+1,1);
        
        currentGreen = easy(column,row,2);
        nextGreen_x = easy(column+1,row,2);
        nextGreen_y = easy(column,row+1,2);        

        currentBlue = easy(column,row,3);
        nextBlue_x = easy(column+1,row,3);
        nextBlue_y = easy(column,row+1,3);   
        
        %------------Red x ---------------%
        if currentRed > nextRed_x
            diffRed_x = currentRed - nextRed_x;
        elseif nextRed_x > currentRed
            diffRed_x = nextRed_x - currentRed;
        else
            diffRed_x = 0;
        end
        
        %------------Red y ---------------%
        if currentRed > nextRed_y
            diffRed_y = currentRed - nextRed_y;
        elseif nextRed_x > currentRed
            diffRed_y = nextRed_y - currentRed; 
        else
            diffRed_y = 0;
        end
       
        
        %------------Green x ---------------%
        if currentGreen > nextGreen_x
            diffGreen_x = currentGreen - nextGreen_x;
        elseif nextGreen_x > currentGreen
            diffGreen_x = nextGreen_x - currentGreen;
        else
            diffGreen_x = 0;
        end        
                
        %------------Green y ---------------%
        if currentGreen > nextGreen_y
            diffGreen_y = currentGreen - nextGreen_y;
        elseif nextGreen_y > currentGreen
            diffGreen_y = nextGreen_y - currentGreen;
        else
            diffGreen_y = 0;
        end         
        
        %------------Blue x ---------------%
        if currentBlue > nextBlue_x
            diffBlue_x = currentBlue - nextBlue_x;
        elseif nextBlue_x > currentBlue
            diffBlue_x = nextBlue_x - currentBlue;
        else
            diffBlue_x = 0;
        end        
        
        %------------Blue y ---------------%
        if currentBlue > nextBlue_y
            diffBlue_y = currentBlue - nextBlue_y;
        elseif nextBlue_y > currentBlue
            diffBlue_y = nextBlue_y - currentBlue;
        else
            diffBlue_y = 0;
        end         
        
        %------------Calculate Gradients ---------------%
        gradientRed = sqrt(power(diffRed_x,2)+power(diffRed_y,2));
        gradientGreen = sqrt(power(diffGreen_x,2)+power(diffGreen_y,2));
        gradientBlue = sqrt(power(diffBlue_x,2)+power(diffBlue_y,2));

        %------------Fill Array  ---------------%
        if (gradientRed>Threshold) || (gradientBlue>Threshold) || (gradientGreen>Threshold)
            edges(column, row) = 1;
        end
    end
end 

imshowpair(easy,edges,'montage')
saveas(gcf,'t3.png')
