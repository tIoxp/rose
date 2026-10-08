local Render = { ['Cache'] = { }, ['Used'] = { } }

do
    local Dark = Color3.new(0.1, 0.1, 0.1)

    for _, Path in { 'RoseHook', 'RoseHook/fonts' } do
        if not isfolder(Path) then
            makefolder(Path)
        end
    end

    if not isfile('RoseHook/fonts/ProggyTiny.ttf') then
        writefile('RoseHook/fonts/ProggyTiny.ttf', game:HttpGet('https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyTiny.ttf'))
    end

    writefile('RoseHook/fonts/ProggyTiny.font', HttpService:JSONEncode({
        ['name'] = 'ProggyTiny',
        ['faces'] = { {
            ['name'] = 'Normal',
            ['weight'] = 400,
            ['style'] = 'Normal',
            ['assetId'] = getcustomasset('RoseHook/fonts/ProggyTiny.ttf')
        } }
    }))

    local ProggyTiny = Font.new(getcustomasset('RoseHook/fonts/ProggyTiny.font'))

    local Gui = Instance.new('ScreenGui')

    Gui.Name = 'Render'
    Gui.IgnoreGuiInset = true
    Gui.ResetOnSpawn = false
    Gui.Parent = gethui()

    function Render:Create(Class, Properties)
        local Object = Instance.new(Class)

        for Property, Value in Properties do
            Object[Property] = Value
        end

        return Object
    end

    function Render:Get(Type)
        local Cache = self.Cache[Type]

        if not Cache then
            Cache = { }
            self.Cache[Type] = Cache
            self.Used[Type] = 0
        end

        local Index = self.Used[Type] + 1
        local Object = Cache[Index]

        self.Used[Type] = Index

        if Object then
            Object.Visible = true
        end

        return Object, Cache, Index
    end

    function Render:Line(From, To, Color, Transparency, Thickness, Outline)
        local Object, Cache, Index = self:Get('Line')
        local Offset = To - From

        if not Object then
            Object = self:Create('Frame', { BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Parent = Gui })

            self:Create('UIStroke', { Name = 'Stroke', Color = Dark, LineJoinMode = Enum.LineJoinMode.Miter, Enabled = false, Parent = Object })

            Cache[Index] = Object
        end

        Object.Position = UDim2.fromOffset((From.X + To.X) * 0.5, (From.Y + To.Y) * 0.5)
        Object.Size = UDim2.fromOffset(Offset.Magnitude, Thickness or 1)
        Object.Rotation = math.deg(math.atan2(Offset.Y, Offset.X))
        Object.BackgroundColor3 = Color
        Object.BackgroundTransparency = Transparency
        Object.Stroke.Enabled = Outline == true
        Object.Stroke.Transparency = Transparency
    end

    function Render:Box(Position, Size, Color, Transparency)
        local Object, Cache, Index = self:Get('Box')

        if not Object then
            Object = self:Create('Frame', { BackgroundTransparency = 1, BorderSizePixel = 0, Parent = Gui })

            local Inner = self:Create('Frame', { Name = 'Inner', BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), Parent = Object })
            local Inline = self:Create('Frame', { Name = 'Inline', BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), Parent = Inner })

            for _, Parent in { Object, Inner, Inline } do
                self:Create('UIStroke', { Name = 'Stroke', Color = Dark, LineJoinMode = Enum.LineJoinMode.Miter, Parent = Parent })
            end

            Cache[Index] = Object
        end

        Object.Position = UDim2.fromOffset(Position.X, Position.Y)
        Object.Size = UDim2.fromOffset(Size.X, Size.Y)
        Object.Stroke.Transparency = Transparency
        Object.Inner.Stroke.Color = Color
        Object.Inner.Stroke.Transparency = Transparency
        Object.Inner.Inline.Stroke.Transparency = Transparency
    end

    function Render:Arrow(PointA, PointB, PointC, Color, Transparency, Thickness, Outline)
        self:Line(PointA, PointB, Color, Transparency, Thickness, Outline)
        self:Line(PointB, PointC, Color, Transparency, Thickness, Outline)
        self:Line(PointC, PointA, Color, Transparency, Thickness, Outline)
    end

    function Render:Text(Position, Text, Color, Transparency, Centered)
        local Object, Cache, Index = self:Get('Text')

        if not Object then
            Object = self:Create('TextLabel', { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY, FontFace = ProggyTiny, TextSize = 9, Parent = Gui })

            self:Create('UIStroke', { Name = 'Stroke', Color = Dark, LineJoinMode = Enum.LineJoinMode.Miter, Parent = Object })

            Cache[Index] = Object
        end

        Object.AnchorPoint = Vector2.new(Centered == false and 0 or 0.5, 0)
        Object.Position = UDim2.fromOffset(Position.X, Position.Y)
        Object.Text = tostring(Text)
        Object.TextColor3 = Color
        Object.TextTransparency = Transparency
        Object.Stroke.Transparency = Transparency
    end

    function Render:CleanUp()
        Gui:Destroy()
    end
end

return Render
