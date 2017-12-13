
function plotObject(Object)
    switch(Object.Type)
        case 'Line'
            NumPairs = floor(length(Object.Indices) / 2);
            for I = 1:NumPairs
                Idx = 1 + (I - 1) * 2;
                Indices = Object.Indices(1, Idx:Idx + 1);
                Vectors = Object.Vertices(:, Indices);
                plot3(Vectors(1, :), zeros(length(Vectors), 1), Vectors(2, :), 'Color', [ 0.5, 0.5, 0.5 ]);
            end
        case 'TriangleStrip'
            NumTriangles = length(Object.Indices) - 2;
            for I = 1:NumTriangles
                Indices = Object.Indices(1, I:I + 2);
                Vectors = Object.Vertices(:, Indices);
                Surface = fill3(Vectors(1, :), zeros(length(Vectors), 1), Vectors(2, :), [ 0.75, 0.75, 0.75 ]);
                set(Surface, 'EdgeColor', 'none');
            end
    end
end
