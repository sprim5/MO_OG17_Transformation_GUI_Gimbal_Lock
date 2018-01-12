function Window = setupUI(Settings)
    TransformationUpdatedListeners = {};
    Window.addTransformationUpdatedListener = @(Listener) addListener(Listener, 'updated');

    SelectedIndex = 1;
    Transformations = {};

    Figure = figure(...
        'Visible', 'on' ...
      , 'Position', [ (Settings.ScreenDimension - Settings.Dimension) / 2, Settings.Dimension ] ...
    );

    RootBox = uix.HBox(...
        'Parent', Figure ...
      , 'Spacing', 5 ...
      , 'Padding', 5 ...
    );

    PlotPanel = uix.BoxPanel(...
        'Parent', RootBox ...
      , 'Title', 'Plot' ...
      , 'TitleColor', [ 0.5, 0.6, 0.7 ] ...
      , 'FontSize', 12 ...
      , 'FontWeight', 'bold' ...
      , 'Padding', 0 ...
    );

    Window.Axes = axes(...
        'Parent', PlotPanel ...
    );

    ControlBox = uix.VBox(...
        'Parent', RootBox ...
      , 'Spacing', 5 ...
      , 'Padding', 0 ...
    );

    TransformationPanel = setupTransformationsPanel(ControlBox, Window);
    TransformationPanel.addTransformationAddedListener(@addTransformation);
    TransformationPanel.addTransformationRemovedListener(@removeTransformation);
    TransformationPanel.addTransformationSelectedListener(@updateIndex);
    TransformationPanel.addTransformationSwitchedListener(@(Args) listSwap(Args{1}));

    ControlPanel = setupControlPanel(ControlBox, Window);
    ControlPanel.addTransformationUpdatedListener(@onUpdate);

    set(ControlBox, 'Heights', [ -1, 300 ]);
    set(RootBox, 'Widths', [ -1, 500 ]);

    plot;


    function onUpdate(Args)
        Transformations{SelectedIndex} = Args{1};
        notify('updated', Transformations);

        plot;
    end

%{
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Mirroring
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Window.MirroringTab = uitab(Window.TransformationTabs ...
      , 'Title', 'Mirroring' ...
    );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Shearing
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Window.ShearingTab = uitab(Window.TransformationTabs ...
      , 'Title', 'Shearing' ...
    );


    Window.TranslationPanel = uipanel(Window.ControlPanel ...
      , 'BorderWidth', 0 ...
      , 'BackgroundColor', [ 1, 0, 0 ] ...

    %% Translation

    TranslationTab = uix.VBox(...
        'Parent', TransformationTabs ...
      , 'Spacing', 5 ...

    );
    Window.TranslationPanel.Units = 'pixels';
    Window.TranslationPanel.Visible = 'off';
%}

    function addListener(Listener, Type)
        switch(Type)
            case 'updated'
                TransformationUpdatedListeners = appendListener(Listener, TransformationUpdatedListeners);
        end
    end

    function Listeners = appendListener(Listener, Listeners)
        NumListeners = length(Listeners);
        Listeners{NumListeners + 1} = Listener;
    end

    function notify(Type, varargin)
        if nargin > 1
            ArgCount = nargin;
            Args = varargin;
        else
            ArgCount = 0;
        end

        Listeners = [];
        switch(Type)
            case 'updated'
                Listeners = TransformationUpdatedListeners;
                ArgCount = 2;
                Args = { Transformations, SelectedIndex };
        end

        NumListeners = length(Listeners);
        for I = 1:NumListeners
            Listener = Listeners{I};
            if ArgCount >= 1
                Listener(Args);
            else
                Listener();
            end
        end
    end

    function listSwap(Index)
        NumTransformations = length(Transformations);
        switch(Index)
            case 'first'
                To = 1;
            case 'prev'
                To = SelectedIndex - 1;
            case 'next'
                To = SelectedIndex + 1;
            case 'last'
                To = NumTransformations;
        end
        To = min(max(1, To), NumTransformations);

        swap(SelectedIndex, To);

        notify('updated', Transformations);
        select(To);

        plot;

        function swap(From, To)
            NumTransformations = length(Transformations);
            if 1 <= From && From <= NumTransformations && 1 <= To && 1 <= NumTransformations && From ~= To
                Iter = sign(To - From);
                while abs(From - To) > 0
                    Next = From + Iter;
                    Tmp = Transformations{Next};
                    Transformations{Next} = Transformations{From};
                    Transformations{From} = Tmp;
                    From = Next;
                end

                select(To);
            end
        end
    end

    function addTransformation(Source, Event)
        LastIndex = length(Transformations);
        Transformations{LastIndex + 1} = struct('Type', 'translation', 'X', 0, 'Y', 0, 'Z', 0);

        notify('updated', Transformations);
        select(LastIndex + 1);

        plot;
    end

    function plot
        ObjectList = Objects;
        Scale = 5;
        cla(Window.Axes);
        grid on;

        axis([ -Scale, Scale, -Scale, Scale, -Scale, Scale ]);
        set(Window.Axes, 'xtick', -1000:1000);
        set(Window.Axes, 'ytick', -1000:1000);
        set(Window.Axes, 'ztick', -1000:1000);
        xlabel('Z');
        ylabel('X');
        zlabel('Y');
        h = rotate3d;
        h.Enable = 'on';

        hold on;

        % plot main axes
        plot3([ -1000, 1000 ], [ 0, 0 ], [ 0, 0 ], 'r' ...
           , [ 0, 0 ], [ -1000, 1000 ], [ 0, 0 ], 'b' ...
           , [ 0, 0 ], [ 0, 0 ], [ -1000, 1000 ], 'g');

        for I = 1:length(ObjectList)
            plotObject(ObjectList(I));
        end

        for I = 1:length(ObjectList)
            plotObjectTransformed(ObjectList(I), Transformations);
        end
    end

    function removeTransformation()
        NumTransformations = length(Transformations);
        if ~(1 <= SelectedIndex && SelectedIndex <= NumTransformations)  % index is out of range
            error('Index out of range in removeTransformation!');
        end

        Transformations(SelectedIndex) = [];
        select(min(max(1, SelectedIndex), max(1, NumTransformations - 1)));
        notify('updated', Transformations);

        plot;
    end

    function select(Index)
        SelectedIndex = Index;
        TransformationPanel.select(SelectedIndex);
    end

    function updateIndex(Index)
        SelectedIndex = Index;
        notify('updated');
    end
%{
    function changeShearing(Sign, Value)
        switch(Value)
            case 'X'
                x = str2double(ShearingInputX.String);
            case 'Y'
                x = str2double(ShearingInputY.String);
            case 'Z'
                x = str2double(ShearingInputZ.String);
        end
        if (isempty(x))
            x = 0;
        end
        
        change = str2double(ShearingInputChange.String);
        
        if (isempty(change))
            change = 0;
        end
        
        switch(Sign)
            case '-'
                x = x-change;
            case '+'
                x = x+change;
        end
        
        switch(Value)
            case 'X'
                ShearingInputX.String = x;

            case 'Y'
                ShearingInputY.String = x;

            case 'Z'
                ShearingInputZ.String = x;

        end
        setShearing();

        
    end

    function setShearing()

        
        Length = length(Window.TransformationList.String);
        if Length >= 1
            Window.Transformations{Window.SelectedIndex}.X = str2double(ShearingInputX.String);
            Window.Transformations{Window.SelectedIndex}.Y = str2double(ShearingInputY.String);
            Window.Transformations{Window.SelectedIndex}.Z = str2double(ShearingInputZ.String);
            
            Window.TransformationList.String(Window.SelectedIndex) = { getTransformationString(Window.Transformations{Window.SelectedIndex})};
        end

        onPlot;
    end
%}
end
