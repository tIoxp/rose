local HttpService = cloneref(game:GetService('HttpService'))

local Render = { ['Cache'] = { }, ['Drew'] = { }, ['Fonts'] = { } } do
    function Render:Create(Class, Properties)
        local Object = Instance.new(Class)

        for Property, Value in Properties do
            Object[Property] = Value
        end

        return Object
    end
    
    do --// Fonts
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
            local Ttf = `RoseHook/fonts/{File}`
            local Json = `RoseHook/fonts/{Name}.font`

            if not isfile(Ttf) then --// thnak you finobe kek
                writefile(Ttf, game:HttpGet('https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/' .. File))
            end

            writefile(Json, HttpService:JSONEncode({
                ['name'] = Name,
                ['faces'] = { { ['name'] = 'Normal', ['weight'] = 400, ['style'] = 'Normal', ['assetId'] = getcustomasset(Ttf) } }
            }))

            Render.Fonts[Name] = Font.new(getcustomasset(Json))
        end
    end

    local Holder = Render:Create('ScreenGui', { IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Global, Parent = gethui() })
    local BarrackObama = Color3.new(0.1, 0.1, 0.1) 

    function Render:Get(Type)
        local Cache = self.Cache[Type]

        if not Cache then
            Cache = { }
            self.Cache[Type] = Cache
            self.Drew[Type] = 0
        end

        local Index = self.Drew[Type] + 1
        local Object = Cache[Index]

        self.Drew[Type] = Index

        if Object then
            Object.Visible = true
        end

        return Object, Cache, Index
    end

    function Render:Line(Properties)
        local Object, Cache, Index = self:Get('Line')
        local Transparency = Properties.Transparency

        if not Transparency then
            if Object then
                Object.Visible = false
            end

            return
        end

        local From, To = Properties.From, Properties.To
        local Offset = To - From

        if not Object then
            Object = self:Create('Frame', { BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Parent = Holder })

            self:Create('UIStroke', { Name = 'Stroke', Color = BarrackObama, LineJoinMode = Enum.LineJoinMode.Miter, Enabled = false, Parent = Object })

            Cache[Index] = Object
        end

        Object.Position = UDim2.fromOffset((From.X + To.X) * 0.5, (From.Y + To.Y) * 0.5)
        Object.Size = UDim2.fromOffset(Offset.Magnitude, Properties.Thickness or 1)
        Object.Rotation = math.deg(math.atan2(Offset.Y, Offset.X))
        Object.BackgroundColor3 = Properties.Color
        Object.BackgroundTransparency = Transparency
        Object.ZIndex = Properties.ZIndex or 1
        Object.Stroke.Enabled = Properties.Outline == true
        Object.Stroke.Transparency = Transparency
    end

    function Render:Box(Properties)
        local Object, Cache, Index = self:Get('Box')
        local Transparency = Properties.Transparency

        if not Transparency then
            if Object then
                Object.Visible = false
            end

            return
        end

        local Position, Size = Properties.Position, Properties.Size
        local ZIndex = Properties.ZIndex or 1

        if not Object then
            Object = self:Create('Frame', { BackgroundTransparency = 1, BorderSizePixel = 0, Parent = Holder })

            local Inner = self:Create('Frame', { Name = 'Inner', BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), Parent = Object })
            local Inline = self:Create('Frame', { Name = 'Inline', BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), Parent = Inner })

            for _, Parent in { Object, Inner, Inline } do
                self:Create('UIStroke', { Name = 'Stroke', Color = BarrackObama, LineJoinMode = Enum.LineJoinMode.Miter, Parent = Parent })
            end

            Cache[Index] = Object
        end

        Object.Position = UDim2.fromOffset(Position.X, Position.Y)
        Object.Size = UDim2.fromOffset(Size.X, Size.Y)
        Object.ZIndex = ZIndex
        Object.Stroke.Transparency = Transparency
        Object.Inner.ZIndex = ZIndex
        Object.Inner.Stroke.Color = Properties.Color
        Object.Inner.Stroke.Transparency = Transparency
        Object.Inner.Inline.ZIndex = ZIndex
        Object.Inner.Inline.Stroke.Transparency = Transparency
    end

    function Render:Circle(Properties)
        local Object, Cache, Index = self:Get('Circle')
        local Transparency = Properties.Transparency

        if not Transparency then
            if Object then
                Object.Visible = false
            end

            return
        end

        local Position, Radius, Color = Properties.Position, Properties.Radius, Properties.Color
        local IsFilled = Properties.Filled ~= false

        if not Object then
            Object = self:Create('Frame', { BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Parent = Holder })

            self:Create('UICorner', { CornerRadius = UDim.new(1, 0), Parent = Object })
            self:Create('UIStroke', { Name = 'Stroke', Color = BarrackObama, Parent = Object })

            Cache[Index] = Object
        end

        Object.Position = UDim2.fromOffset(Position.X, Position.Y)
        Object.Size = UDim2.fromOffset(Radius * 2, Radius * 2)
        Object.BackgroundColor3 = Color
        Object.BackgroundTransparency = IsFilled and Transparency or 1
        Object.ZIndex = Properties.ZIndex or 1
        Object.Stroke.Enabled = not IsFilled or Properties.Outline == true
        Object.Stroke.Color = IsFilled and BarrackObama or Color
        Object.Stroke.Thickness = IsFilled and 1 or (Properties.Thickness or 1)
        Object.Stroke.Transparency = Transparency
    end

    function Render:Arrow(Properties)
        local Transparency = Properties.Transparency

        if not Transparency then
            return
        end

        local PointA, PointB, PointC = Properties.PointA, Properties.PointB, Properties.PointC
        local Color, ZIndex = Properties.Color, Properties.ZIndex
        local Steps = math.max(1, math.ceil((PointC - PointB).Magnitude / 2))

        for Step = 0, Steps do
            self:Line({ From = PointA, To = PointB:Lerp(PointC, Step / Steps), Color = Color, Transparency = Transparency, Thickness = 2, ZIndex = ZIndex })
        end

        self:Line({ From = PointA, To = PointB, Color = Color, Transparency = Transparency, Thickness = Properties.Thickness, Outline = Properties.Outline, ZIndex = ZIndex })
        self:Line({ From = PointB, To = PointC, Color = Color, Transparency = Transparency, Thickness = Properties.Thickness, Outline = Properties.Outline, ZIndex = ZIndex })
        self:Line({ From = PointC, To = PointA, Color = Color, Transparency = Transparency, Thickness = Properties.Thickness, Outline = Properties.Outline, ZIndex = ZIndex })
    end

    function Render:Text(Properties)
        local Object, Cache, Index = self:Get('Text')
        local Transparency = Properties.Transparency

        if not Transparency then
            if Object then
                Object.Visible = false
            end

            return
        end

        local Position = Properties.Position

        if not Object then
            Object = self:Create('TextLabel', { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY, Parent = Holder })

            self:Create('UIStroke', { Name = 'Stroke', Color = BarrackObama, LineJoinMode = Enum.LineJoinMode.Miter, Parent = Object })

            Cache[Index] = Object
        end

        Object.FontFace = self.Fonts[Properties.Font] or self.Fonts['ProggyTiny']
        Object.TextSize = Properties.Size or 9
        Object.AnchorPoint = Vector2.new(Properties.Centered == false and 0 or 0.5, 0)
        Object.Position = UDim2.fromOffset(Position.X, Position.Y)
        Object.Text = tostring(Properties.Text)
        Object.TextColor3 = Properties.Color
        Object.TextTransparency = Transparency
        Object.ZIndex = Properties.ZIndex or 1
        Object.Stroke.Transparency = Transparency
    end

    function Render:CleanUp()
        Holder:Destroy()
    end
end

return Render
