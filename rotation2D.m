function [ xr, yr ] = rotation2D( a , x, y )
%rotation2D rotates a degrees around origin
%   Detailed explanation goes here

    R1 = [cosd(a),-sind(a);sind(a),cosd(a)];

    Q1 = R1*[x;y];

    xr = Q1(1,:);
    yr = Q1(2,:);
end