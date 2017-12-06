function [ xt, yt ] = translation2D( dx, dy, x, y )
%translation2D Translates dx in x direction and dy in y drection
%   Detailed explanation goes here

    T1 = [1,0,dx; 0,1,dy;0,0,1];

    Q1 = T1*[x;y;ones(1,length(x))];

    xt = Q1(1,:);
    yt = Q1(2,:);
end