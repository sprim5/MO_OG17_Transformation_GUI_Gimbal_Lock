
function project
    % ==================================================
    % This project offers a GUI for applying different transformations to
    % an object interactively. The GUI allows for adding or removing
    % transformations aswell as modifying them.
    % ==================================================
    Settings = defaultSettings;
    Window = setupUI(Settings);

    set(Window.Axes, 'CameraPosition', [ 50, 50, 50 ]);

    function Settings = defaultSettings
        Settings.Dimension = [ 1600, 900 ];

         ScreenSize = get(0, 'ScreenSize');
         Settings.ScreenDimension = ScreenSize(3:4);
    end
end
