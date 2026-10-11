local Fonts = { }
local FontIndexes = { }

do
    local HttpService = game:GetService('HttpService')

    for _, Path in { 'RoseHook', 'RoseHook/fonts' } do
        if not isfolder(Path) then
            makefolder(Path)
        end
    end

    for _, Data in {
        { 'ProggyClean', 'ProggyClean.ttf' },
        { 'Tahoma', 'fs-tahoma-8px.ttf' },
        { 'Verdana', 'Verdana-Font.ttf' },
        { 'SmallestPixel', 'smallest_pixel-7.ttf' },
        { 'ProggyTiny', 'ProggyTiny.ttf' },
        { 'Minecraftia', 'Minecraftia-Regular.ttf' },
        { 'Tahoma Bold', 'tahoma_bold.ttf' },
        { 'Rubik', 'Rubik-Regular.ttf' }
    } do
        local Name, File = Data[1], Data[2]
        local Ttf = 'RoseHook/fonts/' .. File
        local Json = 'RoseHook/fonts/' .. Name .. '.font'

        if not isfile(Ttf) then
            writefile(Ttf, game:HttpGet('https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/' .. File))
        end

        writefile(Json, HttpService:JSONEncode({
            ['name'] = Name,
            ['faces'] = { { ['name'] = 'Normal', ['weight'] = 400, ['style'] = 'Normal', ['assetId'] = getcustomasset(Ttf) } }
        }))

        Fonts[Name] = Font.new(getcustomasset(Json))
        table.insert(FontIndexes, Name)
    end
end

local Render = { ['Cache'] = { }, ['Used'] = { }, ['Fonts'] = Fonts, ['FontIndexes'] = FontIndexes }

do
    local BarrackObama = Color3.new(0.1, 0.1, 0.1)

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

            self:Create('UIStroke', { Name = 'Stroke', Color = BarrackObama, LineJoinMode = Enum.LineJoinMode.Miter, Enabled = false, Parent = Object })

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
                self:Create('UIStroke', { Name = 'Stroke', Color = BarrackObama, LineJoinMode = Enum.LineJoinMode.Miter, Parent = Parent })
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

    function Render:Circle(Position, Radius, Color, Transparency, Filled, Thickness, Outline)
        local Object, Cache, Index = self:Get('Circle')
        local IsFilled = Filled ~= false

        if not Object then
            Object = self:Create('Frame', { BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Parent = Gui })

            self:Create('UICorner', { CornerRadius = UDim.new(1, 0), Parent = Object })
            self:Create('UIStroke', { Name = 'Stroke', Color = BarrackObama, Parent = Object })

            Cache[Index] = Object
        end

        Object.Position = UDim2.fromOffset(Position.X, Position.Y)
        Object.Size = UDim2.fromOffset(Radius * 2, Radius * 2)
        Object.BackgroundColor3 = Color
        Object.BackgroundTransparency = IsFilled and Transparency or 1
        Object.Stroke.Enabled = not IsFilled or Outline == true
        Object.Stroke.Color = IsFilled and BarrackObama or Color
        Object.Stroke.Thickness = IsFilled and 1 or (Thickness or 1)
        Object.Stroke.Transparency = Transparency
    end

    function Render:Arrow(PointA, PointB, PointC, Color, Transparency, Thickness, Outline)
        local Steps = math.max(1, math.ceil((PointC - PointB).Magnitude / 2))

        for Step = 0, Steps do
            self:Line(PointA, PointB:Lerp(PointC, Step / Steps), Color, Transparency, 2)
        end

        self:Line(PointA, PointB, Color, Transparency, Thickness, Outline)
        self:Line(PointB, PointC, Color, Transparency, Thickness, Outline)
        self:Line(PointC, PointA, Color, Transparency, Thickness, Outline)
    end

    function Render:Text(Position, Text, Color, Transparency, Centered, Font, Size)
        local Object, Cache, Index = self:Get('Text')

        if not Object then
            Object = self:Create('TextLabel', { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY, Parent = Gui })

            self:Create('UIStroke', { Name = 'Stroke', Color = BarrackObama, LineJoinMode = Enum.LineJoinMode.Miter, Parent = Object })

            Cache[Index] = Object
        end

        Object.FontFace = Fonts[Font] or Fonts['ProggyTiny']
        Object.TextSize = Size or 9
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
