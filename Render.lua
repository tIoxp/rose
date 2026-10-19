local Render = { } do
    local BarrackObama = Color3.new(0.1, 0.1, 0.1)

    Render.Paint = DrawingImmediate.GetPaint(1)

    function Render:Line(Properties)
        if not Properties.Transparency then
            return
        end

        local Opacity = 1 - Properties.Transparency

        if Properties.Outline == true then
            DrawingImmediate.Line(Properties.From, Properties.To, BarrackObama, Opacity, (Properties.Thickness or 1) + 2)
        end

        DrawingImmediate.Line(Properties.From, Properties.To, Properties.Color, Opacity, Properties.Thickness or 1)
    end

    function Render:Box(Properties)
        if not Properties.Transparency then
            return
        end

        local Opacity = 1 - Properties.Transparency

        DrawingImmediate.Rectangle(Properties.Position - Vector2.one, Properties.Size + Vector2.one * 2, BarrackObama, Opacity, 0, 1)
        DrawingImmediate.Rectangle(Properties.Position, Properties.Size, Properties.Color, Opacity, 0, 1)
        DrawingImmediate.Rectangle(Properties.Position + Vector2.one, Properties.Size - Vector2.one * 2, BarrackObama, Opacity, 0, 1)
    end

    function Render:Circle(Properties)
        if not Properties.Transparency then
            return
        end

        local Opacity = 1 - Properties.Transparency

        if Properties.Filled ~= false then
            DrawingImmediate.FilledCircle(Properties.Position, Properties.Radius, Properties.Color, 32, Opacity)
            DrawingImmediate.Circle(Properties.Position, Properties.Radius, BarrackObama, Opacity, 32, 1)
        else
            if Properties.Outline == true then
                DrawingImmediate.Circle(Properties.Position, Properties.Radius, BarrackObama, Opacity, 32, (Properties.Thickness or 1) + 2)
            end

            DrawingImmediate.Circle(Properties.Position, Properties.Radius, Properties.Color, Opacity, 32, Properties.Thickness or 1)
        end
    end

    function Render:Arrow(Properties)
        if not Properties.Transparency then
            return
        end

        local Opacity = 1 - Properties.Transparency

        DrawingImmediate.FilledTriangle(Properties.PointA, Properties.PointB, Properties.PointC, Properties.Color, Opacity)

        if Properties.Outline == true then
            DrawingImmediate.Triangle(Properties.PointA, Properties.PointB, Properties.PointC, BarrackObama, Opacity, Properties.Thickness or 1)
        end
    end

    function Render:Text(Properties)
        if not Properties.Transparency then
            return
        end

        local Opacity = 1 - Properties.Transparency

        DrawingImmediate.OutlinedText(
            Properties.Position,
            2,
            13,
            Properties.Color,
            Opacity,
            BarrackObama,
            Opacity,
            tostring(Properties.Text),
            Properties.Centered ~= false
        )
    end
end

return Render
