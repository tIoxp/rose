local Visuals = { Objects = { }, Cache = { } }

do
    function Visuals:Create(Class, Properties)
        local Instance = Instance.new(Class)
        for Key, Value in Properties do Instance[Key] = Value end
        table.insert(self.Objects, Instance)
        return Instance
    end

    Visuals.Screen = Visuals:Create('ScreenGui', {
        Parent = gethui(),
        Name = 'Visuals',
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    Visuals.Holder = Visuals:Create('Frame', {
        Parent = Visuals.Screen,
        Name = 'Holder',
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })

    function Visuals:CreateText(Properties)
        local Text = self:Create('TextLabel', {
            BackgroundTransparency = 1,
            TextColor3 = Color3.new(1, 1, 1),
            TextStrokeTransparency = 0,
            Visible = false,
            Parent = self.Holder
        })

        self:Create('UIStroke', {
            Thickness = 1,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Parent = Text
        })

        if Properties then
            for Key, Value in Properties do Text[Key] = Value end
        end

        return Text
    end

    function Visuals:CreateCircle()
        local Circle = self:Create('Frame', {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            Parent = self.Holder
        })

        self:Create('UICorner', {
            CornerRadius = UDim.new(1, 0),
            Parent = Circle
        })
        
        local Stroke = self:Create('UIStroke', {
            Color = Color3.new(1, 1, 1),
            LineJoinMode = Enum.LineJoinMode.Round,
            Parent = Circle
        })

        self:Create('UIStroke', {
            Thickness = 3,
            ZIndex = -1,
            LineJoinMode = Enum.LineJoinMode.Round,
            BorderOffset = UDim.new(0, -1),
            Parent = Circle
        })
        
        return Circle, Stroke
    end 

    function Visuals:CreateBox(Properties)
        local Box = self:Create('Frame', {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            Parent = self.Holder
        })

        local Stroke = self:Create('UIStroke', {
            Thickness = 1,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Color = Color3.new(1, 1, 1),
            Parent = Box
        })

        if Properties then
            for Key, Value in Properties do
                if Key == 'Color' then
                    Stroke.Color = Value
                elseif Key == 'Thickness' then
                    Stroke.Thickness = Value
                end
            end
        end

        return Box, Stroke
    end

    function Visuals:CreateLine()
        local Line = self:Create('Frame', {
            Parent = self.Holder,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 2
        })
        self:Create('UIStroke', {
            Parent = Line,
            Thickness = 1,
            Color = Color3.new(0, 0, 0)
        })
        return Line
    end

    function Visuals:Clear()
        for _, Object in self.Objects do if Object then Object:Destroy() end end
        table.clear(self.Objects)
        table.clear(self.Cache)
    end
end

return Visuals
