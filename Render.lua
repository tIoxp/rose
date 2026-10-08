local Render = {
    ['Pools'] = { ['Line'] = { }, ['Box'] = { }, ['Text'] = { } },
    ['Used'] = { ['Line'] = 0, ['Box'] = 0, ['Text'] = 0 },
    ['Fonts'] = { },
    ['DefaultFont'] = 'ProggyTiny',
    ['DefaultSize'] = 9
}

do
    do --// Fonts
        local FontNames = {
            ['ProggyClean'] = 'ProggyClean.ttf',
            ['Tahoma'] = 'fs-tahoma-8px.ttf',
            ['Verdana'] = 'Verdana-Font.ttf',
            ['SmallestPixel'] = 'smallest_pixel-7.ttf',
            ['ProggyTiny'] = 'ProggyTiny.ttf',
            ['Minecraftia'] = 'Minecraftia-Regular.ttf',
            ['Tahoma Bold'] = 'tahoma_bold.ttf',
            ['Rubik'] = 'Rubik-Regular.ttf'
        }

        Render.FontIndexes = { 'ProggyClean', 'Tahoma', 'Verdana', 'SmallestPixel', 'ProggyTiny', 'Minecraftia', 'Tahoma Bold', 'Rubik' }

        if not isfolder('RoseHook') then
            makefolder('RoseHook')
        end

        if not isfolder('RoseHook/fonts') then
            makefolder('RoseHook/fonts')
        end

        local function RegisterFont(Name, Weight, Style, Asset)
            if not isfile('RoseHook/fonts/' .. Asset.Id) then
                writefile('RoseHook/fonts/' .. Asset.Id, Asset.Font)
            end

            if isfile('RoseHook/fonts/' .. Name .. '.font') then
                delfile('RoseHook/fonts/' .. Name .. '.font')
            end

            local Data = {
                ['name'] = Name,
                ['faces'] = {
                    {
                        ['name'] = 'Normal',
                        ['weight'] = Weight,
                        ['style'] = Style,
                        ['assetId'] = getcustomasset('RoseHook/fonts/' .. Asset.Id)
                    }
                }
            }

            writefile('RoseHook/fonts/' .. Name .. '.font', HttpService:JSONEncode(Data))

            return getcustomasset('RoseHook/fonts/' .. Name .. '.font')
        end

        for Name, Suffix in FontNames do
            local Weight = Name == 'Rubik' and 900 or 400
            local FontData

            if isfile('RoseHook/fonts/' .. Suffix) then
                FontData = readfile('RoseHook/fonts/' .. Suffix)
            else
                FontData = game:HttpGet('https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/' .. Suffix)
            end

            local RegisteredFont = RegisterFont(Name, Weight, 'Normal', {
                ['Id'] = Suffix,
                ['Font'] = FontData
            })

            Render.Fonts[Name] = Font.new(RegisteredFont, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end
    end

    do --// Gui
        local Gui = Instance.new('ScreenGui')

        Gui.Name = 'Render'
        Gui.IgnoreGuiInset = true
        Gui.ResetOnSpawn = false
        Gui.Parent = gethui()

        Render.Gui = Gui
    end

    function Render:Create(Type)
        if Type == 'Line' then
            local Object = Instance.new('Frame')

            Object.BorderSizePixel = 0
            Object.AnchorPoint = Vector2.new(0.5, 0.5)
            Object.Parent = self.Gui

            return Object
        end

        if Type == 'Box' then
            local Object = Instance.new('Frame')

            Object.BackgroundTransparency = 1
            Object.BorderSizePixel = 0
            Object.Parent = self.Gui

            local Stroke = Instance.new('UIStroke')

            Stroke.Name = 'Stroke'
            Stroke.LineJoinMode = Enum.LineJoinMode.Miter
            Stroke.Parent = Object

            local Outline = Instance.new('Frame')

            Outline.Name = 'Outline'
            Outline.BackgroundTransparency = 1
            Outline.BorderSizePixel = 0
            Outline.Parent = Object

            local OutlineStroke = Instance.new('UIStroke')

            OutlineStroke.Name = 'Stroke'
            OutlineStroke.Color = Color3.new(0.1, 0.1, 0.1)
            OutlineStroke.LineJoinMode = Enum.LineJoinMode.Miter
            OutlineStroke.Parent = Outline

            return Object
        end

        local Object = Instance.new('TextLabel')

        Object.BackgroundTransparency = 1
        Object.BorderSizePixel = 0
        Object.Size = UDim2.fromOffset(0, 0)
        Object.AutomaticSize = Enum.AutomaticSize.XY
        Object.TextWrapped = false
        Object.Parent = self.Gui

        local Stroke = Instance.new('UIStroke')

        Stroke.Name = 'Stroke'
        Stroke.Color = Color3.new(0.1, 0.1, 0.1)
        Stroke.LineJoinMode = Enum.LineJoinMode.Miter
        Stroke.Parent = Object

        return Object
    end

    function Render:Acquire(Type)
        local Index = self.Used[Type] + 1

        self.Used[Type] = Index

        local Object = self.Pools[Type][Index]

        if not Object then
            Object = self:Create(Type)
            self.Pools[Type][Index] = Object
        end

        Object.Visible = true

        return Object
    end

    function Render:Line(From, To, Color, Transparency, Thickness)
        local Object = self:Acquire('Line')
        local Offset = To - From

        Object.Position = UDim2.fromOffset((From.X + To.X) * 0.5, (From.Y + To.Y) * 0.5)
        Object.Size = UDim2.fromOffset(Offset.Magnitude, Thickness or 1)
        Object.Rotation = math.deg(math.atan2(Offset.Y, Offset.X))
        Object.BackgroundColor3 = Color
        Object.BackgroundTransparency = Transparency
    end

    function Render:Box(Position, Size, Color, Transparency, Rounding, Thickness)
        local Object = self:Acquire('Box')
        local StrokeThickness = Thickness or 1

        Object.Position = UDim2.fromOffset(Position.X, Position.Y)
        Object.Size = UDim2.fromOffset(Size.X, Size.Y)

        Object.Stroke.Color = Color
        Object.Stroke.Thickness = StrokeThickness
        Object.Stroke.Transparency = Transparency

        Object.Outline.Position = UDim2.fromOffset(-StrokeThickness, -StrokeThickness)
        Object.Outline.Size = UDim2.new(1, StrokeThickness * 2, 1, StrokeThickness * 2)
        Object.Outline.Stroke.Transparency = Transparency
    end

    function Render:Arrow(PointA, PointB, PointC, Color, Transparency, Thickness)
        local LineThickness = (Thickness or 1) + 1

        self:Line(PointA, PointB, Color, Transparency, LineThickness)
        self:Line(PointB, PointC, Color, Transparency, LineThickness)
        self:Line(PointC, PointA, Color, Transparency, LineThickness)
    end

    function Render:Text(Position, Text, Color, Transparency, Font, Size, Centered)
        local Object = self:Acquire('Text')
        local FontName = type(Font) == 'number' and self.FontIndexes[Font] or Font or self.DefaultFont

        Object.AnchorPoint = Vector2.new(Centered == false and 0 or 0.5, 0)
        Object.Position = UDim2.fromOffset(Position.X, Position.Y)
        Object.FontFace = self.Fonts[FontName] or self.Fonts[self.DefaultFont]
        Object.TextSize = Size or self.DefaultSize
        Object.Text = tostring(Text)
        Object.TextColor3 = Color
        Object.TextTransparency = Transparency
        Object.Stroke.Transparency = Transparency
    end

    function Render:CleanUp()
        self.Gui:Destroy()

        for _, Pool in self.Pools do
            table.clear(Pool)
        end
    end
end
