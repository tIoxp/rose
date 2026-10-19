local Render = { } do
    local BarrackObama = Color3.new(0.1, 0.1, 0.1)

    Render.Paint = DrawingImmediate.GetPaint(1)

    function Render:Line(Properties)
        local Transparency = Properties.Transparency

        if not Transparency then
            return
        end

        local Opacity = 1 - Transparency
        local From, To = Properties.From, Properties.To
        local Thickness = Properties.Thickness or 1

        if Properties.Outline == true then
            DrawingImmediate.Line(From, To, BarrackObama, Opacity, Thickness + 2)
        end

        DrawingImmediate.Line(From, To, Properties.Color, Opacity, Thickness)
    end

    function Render:Box(Properties)
        local Transparency = Properties.Transparency

        if not Transparency then
            return
        end

        local Opacity = 1 - Transparency
        local Position, Size = Properties.Position, Properties.Size

        DrawingImmediate.Rectangle(Position - Vector2.one, Size + Vector2.one * 2, BarrackObama, Opacity, 0, 1)
        DrawingImmediate.Rectangle(Position, Size, Properties.Color, Opacity, 0, 1)
        DrawingImmediate.Rectangle(Position + Vector2.one, Size - Vector2.one * 2, BarrackObama, Opacity, 0, 1)
    end

    function Render:Circle(Properties)
        local Transparency = Properties.Transparency

        if not Transparency then
            return
        end

        local Opacity = 1 - Transparency
        local Position, Radius, Color = Properties.Position, Properties.Radius, Properties.Color

        if Properties.Filled ~= false then
            DrawingImmediate.FilledCircle(Position, Radius, Color, 32, Opacity)
            DrawingImmediate.Circle(Position, Radius, BarrackObama, Opacity, 32, 1)
        else
            if Properties.Outline == true then
                DrawingImmediate.Circle(Position, Radius, BarrackObama, Opacity, 32, (Properties.Thickness or 1) + 2)
            end

            DrawingImmediate.Circle(Position, Radius, Color, Opacity, 32, Properties.Thickness or 1)
        end
    end

    function Render:Arrow(Properties)
        local Transparency = Properties.Transparency

        if not Transparency then
            return
        end

        local Opacity = 1 - Transparency
        local PointA, PointB, PointC = Properties.PointA, Properties.PointB, Properties.PointC

        DrawingImmediate.FilledTriangle(PointA, PointB, PointC, Properties.Color, Opacity)

        if Properties.Outline == true then
            DrawingImmediate.Triangle(PointA, PointB, PointC, BarrackObama, Opacity, Properties.Thickness or 1)
        end
    end

    function Render:Text(Properties)
        local Transparency = Properties.Transparency

        if not Transparency then
            return
        end

        local Opacity = 1 - Transparency

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
