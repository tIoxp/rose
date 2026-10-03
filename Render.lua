local Render = { Connections = { } }

do
    function Render:Paint(ZIndex, Callback)
        local Connection = DrawingImmediate.GetPaint(ZIndex):Connect(Callback)

        self.Connections[#self.Connections + 1] = Connection

        return Connection
    end

    function Render:Line(From, To, Color, Opacity, Thickness)
        DrawingImmediate.Line(From, To, Color, Opacity, Thickness)
    end

    function Render:Box(Position, Size, Color, Opacity, OutlineColor)
        DrawingImmediate.Rectangle(Position, Size, OutlineColor, Opacity, 0, 3)
        DrawingImmediate.Rectangle(Position, Size, Color, Opacity, 0, 1)
    end

    function Render:Arrow(PointA, PointB, PointC, Color, Opacity, OutlineColor)
        DrawingImmediate.Triangle(PointA, PointB, PointC, OutlineColor, Opacity, 3)
        DrawingImmediate.FilledTriangle(PointA, PointB, PointC, Color, Opacity)
    end

    function Render:Text(Position, Text, Color, Opacity, Font, Size, OutlineColor)
        DrawingImmediate.OutlinedText(Position, Font, Size, Color, Opacity, OutlineColor, Opacity, tostring(Text), true)
    end

    function Render:CleanUp()
        for _, Connection in self.Connections do
            Connection:Disconnect()
        end

        table.clear(self.Connections)
    end
end

return Render
