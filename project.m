
function project
% PROJECT yet another project
%   Details...
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

    Settings = defaultSettings();

    % get the screen dimensions
    ScreenSize = get(0, 'ScreenSize');
    Settings.ScreenSize = ScreenSize(3:4);

    Window.Settings = Settings;
    Window.Figure = figure(...
        'Visible', 'off',...
        'Position', [ (Settings.ScreenSize - Settings.Dimension) / 2, Settings.Dimension ],...
        'SizeChangedFcn', @onResize...
    );

    Window.PlotPanel = uipanel(Window.Figure,...
        'Title', 'Plot',...
        'FontSize', 12 ...
    );
    Window.PlotPanel.Units = 'pixels';

    Window.ListPanel = uipanel(Window.Figure,...
        'Title', 'Transformations',...
        'FontSize', 12 ...
    );
    Window.ListPanel.Units = 'pixels';

    Window.TransformationList = uicontrol(Window.ListPanel,...
        'Style', 'listbox',...
        'String', { 'A', 'B', 'C' },...
        'FontSize', 14,...
        'Callback', @onEvent...
    );

    ArrowSymbols = struct(...
        'up', sprintf('\x2191'),...
        'down', sprintf('\x2193'),...
        'left', sprintf('\x2190'),...
        'right', sprintf('\x2192'),...
        'dup', sprintf('\x219f'),...
        'ddown', sprintf('\x21a1'),...
        'dleft', sprintf('\x219e'),...
        'dright', sprintf('\x21a0')...
    );
    Window.TransformationButtonDUp = uicontrol(Window.ListPanel,...
        'Style', 'pushbutton',...
        'String', ArrowSymbols.dup,...
        'FontSize', 30,...
        'Callback', @onDUp...
    );
    Window.TransformationButtonUp = uicontrol(Window.ListPanel,...
        'Style', 'pushbutton',...
        'String', ArrowSymbols.up,...
        'FontSize', 30,...
        'Callback', @onUp...
    );
    Window.TransformationButtonDown = uicontrol(Window.ListPanel,...
        'Style', 'pushbutton',...
        'String', ArrowSymbols.down,...
        'FontSize', 30,...
        'Callback', @onDown...
    );
    Window.TransformationButtonDDown = uicontrol(Window.ListPanel,...
        'Style', 'pushbutton',...
        'String', ArrowSymbols.ddown,...
        'FontSize', 30,...
        'Callback', @onDDown...
    );

    Window.ControlPanel = uipanel(Window.Figure,...
        'Title', 'Controls',...
        'FontSize', 12 ...
    );
    Window.ControlPanel.Units = 'pixels';

    Window.Axes = axes(...
        'Parent', Window.PlotPanel,...
        'Units', 'pixels'...
    );

    Window.Figure.Visible = 'on';

    function onEvent(ObjectHandle, ActionData)
        %ObjectHandle.String(ObjectHandle.Value) = [];
        ObjectHandle.Value = max(min(ObjectHandle.Value, length(ObjectHandle.String)), 1);
    end

    function onDUp(ObjectHandle, ActionData)
        SelectedIndex = Window.TransformationList.Value;
        if(SelectedIndex > 1)
            for I = SelectedIndex:-1:1 + 1
                swapTransformation(I, I - 1);
            end
            Window.TransformationList.Value = 1;
        end
    end

    function onUp(ObjectHandle, ActionData)
        SelectedIndex = Window.TransformationList.Value;
        if(SelectedIndex > 1)
            swapTransformation(SelectedIndex, SelectedIndex - 1);
            Window.TransformationList.Value = SelectedIndex - 1;
        end
    end

    function onDown(ObjectHandle, ActionData)
        SelectedIndex = Window.TransformationList.Value;
        LastIndex = length(Window.TransformationList.String);
        if(SelectedIndex < LastIndex)
            swapTransformation(SelectedIndex, SelectedIndex + 1);
            Window.TransformationList.Value = SelectedIndex + 1;
        end
    end

    function onDDown(ObjectHandle, ActionData)
        SelectedIndex = Window.TransformationList.Value;
        LastIndex = length(Window.TransformationList.String);
        if(SelectedIndex < LastIndex)
            for I = SelectedIndex:1:LastIndex - 1
                swapTransformation(I, I + 1)
            end
            Window.TransformationList.Value = LastIndex;
        end
    end

    function swapTransformation(Index1, Index2)
        Tmp = Window.TransformationList.String(Index1);
        Window.TransformationList.String(Index1) = Window.TransformationList.String(Index2);
        Window.TransformationList.String(Index2) = Tmp;
    end

    function onResize(ObjectHandle, Event)
        Temp = ObjectHandle.Position(1:2);
        ObjectHandle.Position(3) = max(ObjectHandle.Position(3), Settings.MinDimension(1));
        ObjectHandle.Position(4) = max(ObjectHandle.Position(4), Settings.MinDimension(2));
        ObjectHandle.Position(1) = Temp(1);
        ObjectHandle.Position(2) = Temp(2);

        MaxVerticalPadding = max(Settings.Padding.Top, Settings.Padding.Bottom);
        MaxHorizontalPadding = max(Settings.Padding.Left, Settings.Padding.Right);
        Settings.Dimension = ObjectHandle.Position(3:4);
        PlotPanelDimension = [...
            (Settings.Dimension(1) - (Settings.Padding.Left + Settings.Padding.Right + MaxHorizontalPadding)) / 2,...
            Settings.Dimension(2) - (Settings.Padding.Top + Settings.Padding.Bottom) ...
        ];
        Window.PlotPanel.Position = [ Settings.Padding.Left, Settings.Padding.Bottom, PlotPanelDimension ];
        ControlPanelsDimension = [...
            PlotPanelDimension(1),...
            (Settings.Dimension(2) - (Settings.Padding.Top + Settings.Padding.Bottom + MaxVerticalPadding)) / 2,...
        ];
        Window.ListPanel.Position = [...
            Settings.Padding.Left + MaxHorizontalPadding + PlotPanelDimension(1),...
            Settings.Padding.Bottom + MaxVerticalPadding + ControlPanelsDimension(2),...
            ControlPanelsDimension ];
        Window.ControlPanel.Position = [...
            Settings.Padding.Left + MaxHorizontalPadding + PlotPanelDimension(1),...
            Settings.Padding.Bottom,...
            ControlPanelsDimension ];

        Window.TransformationList.Position = [ Settings.Padding.Left, Settings.Padding.Bottom,...
            ControlPanelsDimension(1) - Settings.Padding.Left - (50 + MaxHorizontalPadding * 2),...
            ControlPanelsDimension(2) - 30 - (Settings.Padding.Top + Settings.Padding.Bottom)...
        ];

        TransformationListCenter = Window.TransformationList.Position(4) / 2 + Settings.Padding.Bottom;
        Window.TransformationButtonDUp.Position = [...
            Window.TransformationList.Position(1) + Window.TransformationList.Position(3) + MaxHorizontalPadding,...
            TransformationListCenter + ((3 / 2) * MaxVerticalPadding) + 60,...
            50,...
            60];
        Window.TransformationButtonUp.Position = [...
            Window.TransformationList.Position(1) + Window.TransformationList.Position(3) + MaxHorizontalPadding,...
            TransformationListCenter + (MaxVerticalPadding / 2),...
            50,...
            60];
        Window.TransformationButtonDown.Position = [...
            Window.TransformationList.Position(1) + Window.TransformationList.Position(3) + MaxHorizontalPadding,...
            TransformationListCenter - 60 - (MaxVerticalPadding / 2),...
            50,...
            60];
        Window.TransformationButtonDDown.Position = [...
            Window.TransformationList.Position(1) + Window.TransformationList.Position(3) + MaxHorizontalPadding,...
            TransformationListCenter - (2 * 60) - ((3 / 2) * MaxVerticalPadding),...
            50,...
            60];

        Window.Axes.Position = [ 40, 40, Window.PlotPanel.Position(3:4) - 80 ];
    end
end
