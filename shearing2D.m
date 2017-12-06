function [ xsh, ysh ] = shearing2D( shx, shy, x, y )
%shearing2D Shears with factor shx in x direction and shy in y direction
%   Detailed explanation goes here

    SH = [1,shx;shy,1];

    Q1 = SH*[x;y];
    
    xsh = Q1(1,:);
    ysh = Q1(2,:);
end

