local Visuals = {
    Objects = { },
    DrawingObjects = { },
    Cache = { },
}

do
    function Visuals:New(Class, Properties)
        local InstanceObject = Instance.new(Class)

        for Property, Value in Properties do
            InstanceObject[Property] = Value
        end

        self.Objects[#self.Objects + 1] = InstanceObject

        return InstanceObject
    end

    function Visuals:Draw(Class, Properties)
        local DrawingObject = Drawing.new(Class)

        for Property, Value in Properties do
            DrawingObject[Property] = Value
        end

        self.DrawingObjects[#self.DrawingObjects + 1] = DrawingObject

        return DrawingObject
    end

    Visuals.Screen = Visuals:New('ScreenGui', {
        Parent = gethui(),
        Name = 'Visuals',
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    Visuals.Holder = Visuals:New('Frame', {
        Parent = Visuals.Screen,
        Name = 'Holder',
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })

    function Visuals:CreateText(Properties)
        local Text = self:New('TextLabel', {
            BackgroundTransparency = 1,
            TextColor3 = Color3.new(1, 1, 1),
            TextStrokeTransparency = 0,
            Visible = false,
            Parent = self.Holder
        })

        self:New('UIStroke', {
            Thickness = 1,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Parent = Text
        })

        if Properties then
            for Property, Value in Properties do
                Text[Property] = Value
            end
        end

        return Text
    end

    function Visuals:CreateCircle()
        local Circle = self:New('Frame', {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            Parent = self.Holder
        })

        self:New('UICorner', {
            CornerRadius = UDim.new(1, 0),
            Parent = Circle
        })

        local Stroke = self:New('UIStroke', {
            Color = Color3.new(1, 1, 1),
            LineJoinMode = Enum.LineJoinMode.Round,
            Parent = Circle
        })

        self:New('UIStroke', {
            Thickness = 3,
            ZIndex = -1,
            LineJoinMode = Enum.LineJoinMode.Round,
            BorderOffset = UDim.new(0, -1),
            Parent = Circle
        })

        return Circle, Stroke
    end

    function Visuals:CreateBox(Properties)
        local Box = self:New('Frame', {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            Parent = self.Holder
        })

        local Stroke = self:New('UIStroke', {
            Thickness = 1,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Color = Color3.new(1, 1, 1),
            Parent = Box
        })

        if Properties then
            for Property, Value in Properties do
                if Property == 'Color' then
                    Stroke.Color = Value
                elseif Property == 'Thickness' then
                    Stroke.Thickness = Value
                end
            end
        end

        return Box, Stroke
    end

    function Visuals:CreateLine()
        local Line = self:New('Frame', {
            Parent = self.Holder,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 2
        })

        self:New('UIStroke', {
            Parent = Line,
            Thickness = 1,
            Color = Color3.new(0, 0, 0)
        })

        return Line
    end

    function Visuals:CleanUp()
        for _, DrawingObject in self.DrawingObjects do
            if DrawingObject then
                DrawingObject:Destroy()
            end
        end

        for _, InstanceObject in self.Objects do
            if InstanceObject then
                InstanceObject:Destroy()
            end
        end

        table.clear(self.DrawingObjects)
        table.clear(self.Objects)
        table.clear(self.Cache)
    end
end

return Visuals
