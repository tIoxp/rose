local Render = { Connections = { } }

do
    function Render:Paint(ZIndex, Callback)
        local Connection = DrawingImmediate.GetPaint(ZIndex):Connect(Callback)

        self.Connections[#self.Connections + 1] = Connection

        return Connection
    end

    function Render:Line(From, To, Color, Opacity, Thickness)
        DrawingImmediate.Line(From, To, Color, Opacity, Thickness or 1)
    end

    function Render:Box(Position, Size, Color, Opacity, Rounding, Thickness)
        DrawingImmediate.Rectangle(Position, Size, Color3.new(0.1, 0.1, 0.1), Opacity, Rounding or 0, (Thickness or 1) + 2)
        DrawingImmediate.Rectangle(Position, Size, Color, Opacity, Rounding or 0, Thickness or 1)
    end

    function Render:FilledBox(Position, Size, Color, Opacity, Rounding)
        DrawingImmediate.FilledRectangle(Position, Size, Color, Opacity, Rounding or 0)
    end

    function Render:Arrow(PointA, PointB, PointC, Color, Opacity, Thickness)
        DrawingImmediate.Triangle(PointA, PointB, PointC, Color3.new(0.1, 0.1, 0.1), Opacity, (Thickness or 1) + 2)
        DrawingImmediate.FilledTriangle(PointA, PointB, PointC, Color, Opacity)
    end

    function Render:Circle(Position, Radius, Color, Opacity, NumSides, Thickness)
        DrawingImmediate.Circle(Position, Radius, Color, Opacity, NumSides or 62, Thickness or 1)
    end

    function Render:FilledCircle(Position, Radius, Color, Opacity, NumSides)
        DrawingImmediate.FilledCircle(Position, Radius, Color, NumSides or 62, Opacity)
    end

    function Render:Text(Position, Text, Color, Opacity, Font, Size, Centered)
        DrawingImmediate.OutlinedText(Position, Font, Size, Color, Opacity, Color3.new(0.1, 0.1, 0.1), Opacity, tostring(Text), Centered == nil and true or Centered)
    end

    function Render:Quad(PointA, PointB, PointC, PointD, Color, Opacity, Thickness)
        DrawingImmediate.Quad(PointA, PointB, PointC, PointD, Color, Opacity, Thickness or 1)
    end

    function Render:FilledQuad(PointA, PointB, PointC, PointD, Color, Opacity)
        DrawingImmediate.FilledQuad(PointA, PointB, PointC, PointD, Color, Opacity)
    end

    function Render:CleanUp()
        for _, Connection in self.Connections do
            Connection:Disconnect()
        end

        table.clear(self.Connections)
    end
end

return Render
