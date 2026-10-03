local Render = {
    Connections = { },
}

do
    function Render:Paint(ZIndex, Callback)
        local Connection = DrawingImmediate.GetPaint(ZIndex):Connect(Callback)

        self.Connections[#self.Connections + 1] = Connection

        return Connection
    end

    function Render:Line(From, To, Color, Opacity, Thickness)
        DrawingImmediate.Line(From, To, Color, Opacity, Thickness)
    end

    function Render:Box(Position, Size, Color, Opacity)
        DrawingImmediate.Rectangle(Position, Size, Color3.new(0.1, 0.1, 0.1), Opacity, 0, 3)
        DrawingImmediate.Rectangle(Position, Size, Color, Opacity, 0, 1)
    end

    function Render:Arrow(PointA, PointB, PointC, Color, Opacity)
        DrawingImmediate.Triangle(PointA, PointB, PointC, Color3.new(0.1, 0.1, 0.1), Opacity, 3)
        DrawingImmediate.FilledTriangle(PointA, PointB, PointC, Color, Opacity)
    end

    function Render:Text(Position, Text, Color, Opacity)
        DrawingImmediate.OutlinedText(Position, 2, 13, Color, Opacity, Color3.new(0.1, 0.1, 0.1), Opacity, tostring(Text), true)
    end

    function Render:CleanUp()
        for _, Connection in self.Connections do
            Connection:Disconnect()
        end

        table.clear(self.Connections)
    end
end

return Render
