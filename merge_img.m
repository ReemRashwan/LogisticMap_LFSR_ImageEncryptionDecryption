function [img] = merge_img(r, g, b)
img(:,:,1) = r;
img(:,:,2) = g;
img(:,:,3) = b;
end 