
function project
% PROJECT yet another project
    Settings = defaultSettings;
    Window = setupUI(Settings);

    set(Window.Axes, 'CameraPosition', [ 50, 50, 50 ]);

    function Settings = defaultSettings
        Settings.Dimension = [ 1366, 768 ];

         ScreenSize = get(0, 'ScreenSize');
         Settings.ScreenDimension = ScreenSize(3:4);
    end
end
