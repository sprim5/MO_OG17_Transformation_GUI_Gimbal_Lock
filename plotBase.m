function [] = plotBase( x, y, scale )
%PLOTBASE Summary of this function goes here
%   Detailed explanation goes here

    %p = subplot(1,1,1);
    fill(x(6:10),y(6:10),'r');
    plot(x,y, 'b');
    plot([-scale,scale],[0,0], 'k');
    plot([0,0],[-scale,scale], 'k');
    axis('square',[-scale,scale,-scale,scale]);
    grid on;
    set(gca,'xtick',-scale:scale);

    set(gca,'ytick',-scale:scale);

end

