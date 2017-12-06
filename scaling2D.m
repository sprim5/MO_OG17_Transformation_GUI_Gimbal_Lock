function [ xs, ys ] = scaling2D( sx, sy, x, y )
%scaling2D Scales with factor sx in x direction and sy in y direction
%   Detailed explanation goes here
    S = [sx,0;0,sy];

    Q1 = S*[x;y];

    xs = Q1(1,:);
    ys = Q1(2,:);
end

