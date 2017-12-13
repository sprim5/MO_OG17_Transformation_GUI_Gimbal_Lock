
function project
% PROJECT yet another project
%   Details...

    Settings = defaultSettings();
    Window = setupUI(Settings);
    Window.setVisible(true);

    %{
    scale = 5;
    x = [0,1,1,0,0,...  %bl
        2,2,1,1,2,...
        2,1,1,2,2,...
        0,0,1,1,0];
    y = [0,0,1,1,0,...  %bl
        0,1,1,0,0,...
        2,2,1,1,2,...
        2,1,1,2,2];

    function draw()
        cla(Window.Axes);
        hold on;
            plotBase(x, y, scale);
            tmpX = x;
            tmpY = y;
            for I = 1:length(Window.TransformationList.String)
                if(strcmp(Window.TransformationList.String(I), 'A'))
                    [ tmpX, tmpY ] = rotation2D(45.0, tmpX, tmpY);
                elseif(strcmp(Window.TransformationList.String(I), 'B'))
                    [ tmpX, tmpY ] = translation2D(2.0, 0, tmpX, tmpY);
                end
            end
            plotResult(tmpX, tmpY);
        hold off;

        cla(Window.Axes);
        axis([ -5, 5, -5, 5 ]);
        ObjectList = Objects;
        hold on
        for I = 1:length(ObjectList)
            plotObject(ObjectList(I))
        end
        hold off
    end
    %}
    function Settings = defaultSettings
        Settings.Dimension = [ 1366, 768 ];
        Settings.MinDimension = [ 500, 640 ];

        Settings.Padding = struct(...
            'Top',     0,...
            'Bottom', 10,...
            'Left',   10,...
            'Right',  10 ...
        );
    end
end
