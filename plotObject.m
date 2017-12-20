
function plotObject(Object)
    S = 1 / tan(30 * pi / 180);
    F = 5;
    N = 0.1;
    FMN = F - N;
    FTM = F * N;
    Matrix = [...
        S, 0, 0, 0 ...
      ; 0, S, 0, 0 ...
      ; 0, 0, -F / FMN, -1 ...
      ; 0, 0, -FTM / FMN, 0 ...
    ];
    switch(Object.Type)
        case 'Line'
            NumPairs = floor(length(Object.Indices) / 2);
            for I = 1:NumPairs
                Idx = 1 + (I - 1) * 2;
                Indices = Object.Indices(1, Idx:Idx + 1);
                Vectors = Object.Vertices(:, Indices);
                plot3(Vectors(1, :), Vectors(3, :), Vectors(2, :), 'Color', [ 0.5, 0.5, 0.5 ]);
            end
        case 'TriangleStrip'
            NumTriangles = length(Object.Indices) - 2;
            for I = 1:NumTriangles
                Indices = Object.Indices(1, I:I + 2);
                Vectors = Object.Vertices(:, Indices);
                Surface = fill3(Vectors(1, :), Vectors(3, :), Vectors(2, :), [ 0.75, 0.75, 0.75 ]);
                set(Surface, 'EdgeColor', [ 0.5, 0.5, 0.5 ]);
            end
    end
end
