
function plotObjectTransformed(Object, TransformationStack)
    function Matrix = getTransform(Transform)
        switch(Transform.Type)
            case 'translation'
                Matrix = [...
                      1, 0, 0, Transform.X ...
                    ; 0, 1, 0, Transform.Y ...
                    ; 0, 0, 1, 0 ...
                    ; 0, 0, 0, 1 ...
                ];
            otherwise
                Matrix = [...
                      1, 0, 0, 0 ...
                    ; 0, 1, 0, 0 ...
                    ; 0, 0, 1, 0 ...
                    ; 0, 0, 0, 1 ...
                ];
        end
    end
    switch(Object.Type)
        case 'Line'
            NumPairs = floor(length(Object.Indices) / 2);
            for I = 1:NumPairs
                Idx = 1 + (I - 1) * 2;
                Indices = Object.Indices(1, Idx:Idx + 1);
                Vectors = [ Object.Vertices(:, Indices); ones(2, length(Indices)) ];
                for I = 1:length(TransformationStack)
                    Vectors = getTransform(TransformationStack{I}) * Vectors;
                end
                Vectors = Vectors(1:2, :);
                plot3(Vectors(1, :), zeros(length(Vectors), 1), Vectors(2, :), 'blue');
            end
        case 'TriangleStrip'
            NumTriangles = length(Object.Indices) - 2;
            for I = 1:NumTriangles
                Indices = Object.Indices(1, I:I + 2);
                Vectors = [ Object.Vertices(:, Indices); ones(2, length(Indices)) ];
                for I = 1:length(TransformationStack)
                    Vectors = getTransform(TransformationStack{I}) * Vectors;
                end
                Vectors = Vectors(1:2, :);
                Surface = fill3(Vectors(1, :), zeros(length(Vectors), 1), Vectors(2, :), 'red');
                set(Surface, 'EdgeColor', 'none');
            end
    end
end
