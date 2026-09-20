-- // Variables
local ws = game:GetService("Workspace")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local hs = game:GetService("HttpService")
local cas = game:GetService("ContextActionService")
local plrs = game:GetService("Players")
local stats = game:GetService("Stats")

local localplayer = plrs.LocalPlayer
local mouse = localplayer and localplayer:GetMouse()

local Remove = table.remove
local Unpack = table.unpack
local Find = table.find

local Themes = {
    Default = {1, [[{"Outline":"000000","Accent":"#37AFE1","LightText":"ffffff","DarkText":"afafaf","LightContrast":"1e1e1e","CursorOutline":"0a0a0a","DarkContrast":"141414","TextBorder":"000000","Inline":"323232"}]]},
    Neverlose = {2, [[{"Outline":"000005","Accent":"00b4f0","LightText":"ffffff","DarkText":"afafaf","LightContrast":"000f1e","CursorOutline":"0f0f28","DarkContrast":"050514","TextBorder":"0a0a0a","Inline":"0a1e28"}]]},
    Onetap = {3, [[{"Outline":"000000","Accent":"dda85d","LightText":"d6d9e0","DarkText":"afafaf","LightContrast":"2c3037","CursorOutline":"000000","DarkContrast":"1f2125","TextBorder":"000000","Inline":"4e5158"}]]},
    Entropy = {4, [[{"Outline":"0a0a0a","Accent":"81bbe9","LightText":"dcdcdc","DarkText":"afafaf","LightContrast":"3d3a43","CursorOutline":"000000","DarkContrast":"302f37","TextBorder":"000000","Inline":"4c4a52"}]]},
    Interwebz = {5, [[{"Outline":"1a1a1a","Accent":"c9654b","LightText":"fcfcfc","DarkText":"a8a8a8","LightContrast":"291f38","CursorOutline":"1a1a1a","DarkContrast":"1f162b","TextBorder":"000000","Inline":"40364f"}]]},
    Dracula = {6, [[{"Outline":"202126","Accent":"9a81b3","LightText":"b4b4b8","DarkText":"88888b","LightContrast":"2a2c38","CursorOutline":"202126","DarkContrast":"252730","TextBorder":"2a2c38","Inline":"3c384d"}]]},
    Spotify = {7, [[{"Outline":"0a0a0a","Accent":"1ed760","LightText":"d0d0d0","DarkText":"949494","LightContrast":"181818","CursorOutline":"000000","DarkContrast":"121212","TextBorder":"000000","Inline":"292929"}]]},
    Sublime = {8, [[{"Outline":"000000","Accent":"ff9800","LightText":"e8ffff","DarkText":"d3d3c2","LightContrast":"32332d","CursorOutline":"000000","DarkContrast":"282923","TextBorder":"000000","Inline":"484944"}]]},
}

local theme = {
    accent = Color3.fromRGB(55, 175, 225),
    lightcontrast = Color3.fromRGB(30, 30, 30),
    darkcontrast = Color3.fromRGB(20, 20, 20),
    outline = Color3.fromRGB(0, 0, 0),
    inline = Color3.fromRGB(50, 50, 50),
    textcolor = Color3.fromRGB(255, 255, 255),
    textdark = Color3.fromRGB(175, 175, 175),
    textborder = Color3.fromRGB(0, 0, 0),
    cursoroutline = Color3.fromRGB(10, 10, 10),
    font = 2,
    textsize = 13
}

local library = {
    drawings = {},
    objects = {},
    hidden = {},
    connections = {},
    pointers = {},
    began = {},
    ended = {},
    changed = {},
    colors = {},
    hovers = {},
    Relations = {},
    configs = {},
    themes = Themes,
    theme = theme,
    configExtension = ".rosehook",
    configFooter = "[ rosehook ]",
    configListPointer = "ConfigConfiguration_Box",
    ignoreConfigFlags = {
        ["ConfigConfiguration_Box"] = true,
        ["ConfigConfiguration_Name"] = true
    },
    locals = {
        Shift = 0,
        ShiftTick = 0
    },
    folders = {
        main = "rosehook",
        assets = "rosehook/Images",
        configs = "rosehook/Configs"
    },
    shared = {
        initialized = false,
        fps = 0,
        ping = 0
    }
}

local utility = {
    images = {
        arrow_down = "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAGCAYAAAARx7TFAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAApSURBVBhXY/hPADDAAJSPFUCVQABUDAVApVABVA4MoELYAUEF2AEDAwABG1+hl3/LwgAAAABJRU5ErkJggg==",
        arrow_up = "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAGCAYAAAARx7TFAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAoSURBVBhXYyAL/AcCKBM7ACmAAagQKoDKoQCoFARAxbACqBJCgIEBAOQhP8GFUn6eAAAAAElFTkSuQmCC",
        gradient = "iVBORw0KGgoAAAANSUhEUgAAAAQAAAAgCAYAAAA1zNleAAAAa0lEQVR42l3I0QqCYABD4SMWgpRJIRaJKAVC0Ps/3q+7Gxt8uziUUv6O435OYXMKX6ewOoXZKbydwtMpDE7h7hRuTuHqFFqn0DiFk1OoHMeqQB04B5pAG7gEukAfeASGwBh4BabAHFgCH7cD2uTJWYT5ljgAAAAASUVORK5CYII=",
        gradientdown = "iVBORw0KGgoAAAANSUhEUgAAAAQAAAAgCAYAAAA1zNleAAAAa0lEQVR42l3IwQqCYAAE4UkUJTMzFI0g6BAEQYfe/93+2Nu6h28OA/ALfAOfwDvwCjwDj8A9sAXmwBQ4B/pAF6gDh51Syo5SOY3aaTROo3UandM4Oo2T0xicxug0Lk7j6jRmp7E4jdVp3NwfQtrIsWgNpi4AAAAASUVORK5CYII=",
        valsat_cursor = "iVBORw0KGgoAAAANSUhEUgAAAAYAAAAGCAYAAADgzO9IAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAWSURBVBhXY/iPA4AlGNAALSQwwf//AFp/T7FS2x1DAAAAAElFTkSuQmCC",
        transp = "iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAeSURBVChTY4iKivqPjM3NzVEwPRSgC6BroLmCqP8AqJx2IdHGhOAAAAAASUVORK5CYII=",
        alphagradient = "iVBORw0KGgoAAAANSUhEUgAAAIAAAAAICAYAAAAx3fd+AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAETSURBVFhH7dLhRphhAIDRJMkkSZJJMkmSJJmZJElmkiSTSZIkmcwkmUSSJEkyM8lMksxkkplJkiRJkiSZSZJMkmQm+Tp1GXl/nCt4npgoiu7EEkc8CTwikSSSSSGVNNJ5TAaZZPGEbHLIJY98CiikiGKe8oznlFBKGeVUUMkLXlJFNTXUUscr6nlNA4000UwLrbTRzhs6eMs7Oumim/f00Esf/QwwyBDDjDDKGON84COfmGCSz3xhimlmmOUr35jjO/Ms8IOf/GKRJZZZYZU11tlgky222WGXPfY54Dd/OOSIY0445S9nnHPBJVf84z/X3HAfPwwQBggDEAYgDBAGCAMQBiAMEAYIAxAGIAzwIAeIoluwM/LECJrV7wAAAABJRU5ErkJggg==",
    },
    Keyboard = {
        Letters = {
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        },
        Modifiers = {
            ["`"] = "~", ["1"] = "!", ["2"] = "@", ["3"] = "#", ["4"] = "$", ["5"] = "%", ["6"] = "^", ["7"] = "&", ["8"] = "*", ["9"] = "(",
            ["0"] = ")", ["-"] = "_", ["="] = "+", ["["] = "{", ["]"] = "}", ["\\"] = "|", [";"] = ":", ["'"] = '"', [","] = "<", ["."] = ".",
            ["/"] = "?"
        },
        InputNames = {
            One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Zero = "0",
            LeftBracket = "[", RightBracket = "]", Semicolon = ";", BackSlash = "\\", Slash = "/", Minus = "-", Equals = "=", Return = "Enter",
            Backquote = "`", CapsLock = "Caps", LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl",
            LeftAlt = "LAlt", RightAlt = "RAlt", Backspace = "Back", Plus = "+", PageUp = "PgUp", PageDown = "PgDown", Delete = "Del",
            Insert = "Ins", NumLock = "NumL", Comma = ",", Period = ".",
            MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3"
        }
    }
}

local pages = {}
local sections = {}

-- // Utility Functions
do
    function utility:Size(xScale, xOffset, yScale, yOffset, instance)
        if instance then
            return Vector2.new(xScale * instance.Size.x + xOffset, yScale * instance.Size.y + yOffset)
        else
            local vx, vy = ws.CurrentCamera.ViewportSize.x, ws.CurrentCamera.ViewportSize.y
            return Vector2.new(xScale * vx + xOffset, yScale * vy + yOffset)
        end
    end

    function utility:Position(xScale, xOffset, yScale, yOffset, instance)
        if instance then
            return Vector2.new(instance.Position.x + xScale * instance.Size.x + xOffset, instance.Position.y + yScale * instance.Size.y + yOffset)
        else
            local vx, vy = ws.CurrentCamera.ViewportSize.x, ws.CurrentCamera.ViewportSize.y
            return Vector2.new(xScale * vx + xOffset, yScale * vy + yOffset)
        end
    end

    function utility:Create(instanceType, instanceOffset, instanceProperties, instanceParent)
        instanceType = instanceType or "Frame"
        instanceOffset = instanceOffset or {Vector2.new(0, 0)}
        instanceProperties = instanceProperties or {}
        local instanceHidden = false
        local instance = nil

        local lower = instanceType:lower()
        if lower == "frame" then
            local frame = Drawing.new("Square")
            frame.Visible = true
            frame.Filled = true
            frame.Thickness = 0
            frame.Color = Color3.fromRGB(255, 255, 255)
            frame.Size = Vector2.new(100, 100)
            frame.Position = Vector2.new(0, 0)
            frame.ZIndex = 50
            frame.Transparency = library.shared.initialized and 1 or 0
            instance = frame
        elseif lower == "textlabel" then
            local text = Drawing.new("Text")
            text.Font = 2
            text.Visible = true
            text.Outline = true
            text.Center = false
            text.Color = Color3.fromRGB(255, 255, 255)
            text.ZIndex = 50
            text.Transparency = library.shared.initialized and 1 or 0
            instance = text
        elseif lower == "triangle" then
            local triangle = Drawing.new("Triangle")
            triangle.Visible = true
            triangle.Filled = true
            triangle.Thickness = 0
            triangle.Color = Color3.fromRGB(255, 255, 255)
            triangle.ZIndex = 50
            triangle.Transparency = library.shared.initialized and 1 or 0
            instance = triangle
        elseif lower == "image" then
            local s, image = pcall(Drawing.new, "Image")
            if not s or not image then
                image = Drawing.new("Square")
                image.Filled = true
                image.Thickness = 0
                image.Color = Color3.fromRGB(255, 255, 255)
            end
            image.Size = Vector2.new(12, 19)
            image.Position = Vector2.new(0, 0)
            image.Visible = true
            image.ZIndex = 50
            image.Transparency = library.shared.initialized and 1 or 0
            instance = image
        elseif lower == "circle" then
            local circle = Drawing.new("Circle")
            circle.Visible = false
            circle.Color = Color3.fromRGB(255, 0, 0)
            circle.Thickness = 1
            circle.NumSides = 30
            circle.Filled = true
            circle.Radius = 50
            circle.ZIndex = 50
            circle.Transparency = library.shared.initialized and 1 or 0
            instance = circle
        elseif lower == "line" then
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = Color3.fromRGB(255, 255, 255)
            line.Thickness = 1.5
            line.ZIndex = 50
            line.Transparency = library.shared.initialized and 1 or 0
            instance = line
        end

        if instance then
            for i, v in pairs(instanceProperties) do
                if i:lower() == "hidden" then
                    instanceHidden = true
                else
                    if library.shared.initialized or instanceProperties.Hidden or instanceProperties.hidden then
                        instance[i] = v
                    elseif i ~= "Transparency" then
                        instance[i] = v
                    end
                end
            end

            if not instanceHidden then
                library.drawings[#library.drawings + 1] = {instance, instanceOffset, instanceProperties["Transparency"] or 1}
            else
                library.hidden[#library.hidden + 1] = {instance}
            end

            if instanceParent then
                instanceParent[#instanceParent + 1] = instance
            end

            return instance
        end
    end

    function utility:GetImageData(Name)
        if not utility.images[Name] then return nil end
        local Success, Data = pcall(function()
            return crypt.base64decode(utility.images[Name])
        end)
        return Success and Data or nil
    end

    function utility:CreateColorPickerGrid(Parent, Drawings, Hue)
        local Cells = {}
        local Columns = 16
        local Rows = 16

        for Y = 1, Rows do
            for X = 1, Columns do
                local Saturation = (X - 1) / (Columns - 1)
                local Value = 1 - ((Y - 1) / (Rows - 1))
                local Cell = utility:Create("Frame", {Vector2.new(0, 0), Parent}, {
                    Size = utility:Size(1 / Columns, 0, 1 / Rows, 0, Parent),
                    Position = utility:Position((X - 1) / Columns, 0, (Y - 1) / Rows, 0, Parent),
                    Color = Color3.fromHSV(Hue, Saturation, Value),
                    ZIndex = 51
                }, Drawings)

                Cells[#Cells + 1] = {Cell, Saturation, Value}
            end
        end

        return Cells
    end

    function utility:UpdateColorPickerGrid(Cells, Hue)
        for _, Cell in pairs(Cells) do
            Cell[1].Color = Color3.fromHSV(Hue, Cell[2], Cell[3])
        end
    end

    function utility:CreateHuePickerGrid(Parent, Drawings)
        local Rows = 36
        for Y = 1, Rows do
            utility:Create("Frame", {Vector2.new(0, 0), Parent}, {
                Size = utility:Size(1, 0, 1 / Rows, 0, Parent),
                Position = utility:Position(0, 0, (Y - 1) / Rows, 0, Parent),
                Color = Color3.fromHSV((Y - 1) / (Rows - 1), 1, 1),
                ZIndex = 51
            }, Drawings)
        end
    end

    function utility:CreateTransparencyPickerGrid(Parent, Drawings, Color)
        utility:Create("Image", {Vector2.new(0, 0), Parent}, {
            Data = utility:GetImageData("transp"),
            Size = utility:Size(1, 0, 1, 0, Parent),
            Position = utility:Position(0, 0, 0, 0, Parent),
            ZIndex = 51
        }, Drawings)

        local Gradient = utility:Create("Image", {Vector2.new(0, 0), Parent}, {
            Data = utility:GetImageData("alphagradient"),
            Size = utility:Size(1, 0, 1, 0, Parent),
            Position = utility:Position(0, 0, 0, 0, Parent),
            Color = Color,
            ZIndex = 52
        }, Drawings)

        return {Gradient}
    end

    function utility:UpdateTransparencyPickerGrid(Cells, Color)
        for _, Cell in pairs(Cells) do
            Cell.Color = Color
        end
    end

    function utility:Remove(instance, hidden)
        if not instance then return end
        library.colors[instance] = nil

        local list = hidden and library.hidden or library.drawings
        local ind = nil
        for i, v in pairs(list) do
            if v[1] == instance then
                ind = i
                v[2] = nil
                v[1] = nil
                break
            end
        end

        if ind and ind > 0 then
            Remove(list, ind)
        end

        pcall(function()
            if instance.Remove then
                instance:Remove()
            end
        end)
    end

    function utility:Connection(connectionType, connectionCallback)
        local connection = connectionType:Connect(connectionCallback)
        library.connections[#library.connections + 1] = connection
        return connection
    end

    function utility:Disconnect(connection)
        for i, v in pairs(library.connections) do
            if v == connection then
                library.connections[i] = nil
                v:Disconnect()
            end
        end
    end

    function utility:MouseLocation()
        return uis:GetMouseLocation()
    end

    function utility:MouseOverDrawing(values, valuesAdd)
        valuesAdd = valuesAdd or {}
        local minX = (values[1] or 0) + (valuesAdd[1] or 0)
        local minY = (values[2] or 0) + (valuesAdd[2] or 0)
        local maxX = (values[3] or 0) + (valuesAdd[3] or 0)
        local maxY = (values[4] or 0) + (valuesAdd[4] or 0)

        local mouseLocation = utility:MouseLocation()
        return (mouseLocation.x >= minX and mouseLocation.x <= maxX) and (mouseLocation.y >= minY and mouseLocation.y <= maxY)
    end

    function utility:GetTextBounds(text, textSize, font)
        local textlabel = utility:Create("TextLabel", {Vector2.new(0, 0)}, {
            Text = text,
            Size = textSize or 13,
            Font = font or 2,
            Hidden = true
        })
        local textbounds = textlabel.TextBounds
        utility:Remove(textlabel, true)
        return textbounds
    end

    function utility:GetScreenSize()
        return ws.CurrentCamera.ViewportSize
    end

    function utility:LoadImage(instance, imageName, imageLink)
        if not instance then return end
        if utility.images[imageName] then
            local data = utility:GetImageData(imageName)
            if data then
                pcall(function() instance.Data = data end)
                return
            end
        end

        if not isfolder(library.folders.main) then pcall(makefolder, library.folders.main) end
        if not isfolder(library.folders.assets) then pcall(makefolder, library.folders.assets) end

        local path = library.folders.assets .. "/" .. imageName .. ".png"
        if isfile(path) then
            local s, res = pcall(readfile, path)
            if s and res then
                pcall(function() instance.Data = res end)
                return
            end
        end

        if imageLink then
            local s, res = pcall(game.HttpGet, game, imageLink)
            if s and res then
                pcall(writefile, path, res)
                pcall(function() instance.Data = res end)
            end
        end
    end

    function utility:Lerp(instance, instanceTo, instanceTime)
        local currentTime = 0
        local currentIndex = {}
        for i, v in pairs(instanceTo) do
            currentIndex[i] = instance[i]
        end
        local connection
        connection = utility:Connection(rs.RenderStepped, function(delta)
            if currentTime < instanceTime then
                currentTime = currentTime + delta
                for i, v in pairs(instanceTo) do
                    instance[i] = ((v - currentIndex[i]) * currentTime / instanceTime) + currentIndex[i]
                end
            else
                for i, v in pairs(instanceTo) do
                    instance[i] = v
                end
                connection:Disconnect()
            end
        end)
    end

    function utility:InputToString(Input)
        if not Input then return "None" end
        if typeof(Input) == "string" then return Input end
        if typeof(Input) == "EnumItem" then
            if Input.EnumType == Enum.UserInputType then
                if Input == Enum.UserInputType.MouseButton1 then return "MB1" end
                if Input == Enum.UserInputType.MouseButton2 then return "MB2" end
                if Input == Enum.UserInputType.MouseButton3 then return "MB3" end
                return Input.Name
            elseif Input.EnumType == Enum.KeyCode then
                local name = Input.Name
                if name == "Unknown" or Input.Value == 27 then return "None" end
                return utility.Keyboard.InputNames[name] or name
            end
        end
        return tostring(Input)
    end

    function utility:MatchesInput(input, targetKey)
        if not targetKey then return false end
        if typeof(targetKey) == "EnumItem" then
            if targetKey.EnumType == Enum.KeyCode then
                return input.KeyCode == targetKey
            elseif targetKey.EnumType == Enum.UserInputType then
                return input.UserInputType == targetKey
            end
        end
        return false
    end

    function utility:IsInputPressed(targetKey)
        if not targetKey then return false end
        if typeof(targetKey) == "EnumItem" then
            if targetKey.EnumType == Enum.KeyCode then
                return uis:IsKeyDown(targetKey)
            elseif targetKey.EnumType == Enum.UserInputType then
                return uis:IsMouseButtonPressed(targetKey)
            end
        end
        return false
    end

    function utility:GetTableIndexes(Table, Custom)
        local Table2 = {}
        for Index, Value in pairs(Table) do
            Table2[Custom and (typeof(Value) == "table" and Value[1] or Index) or #Table2 + 1] = Index
        end
        return Table2
    end

    function utility:Encode(Table)
        local Table2 = {}
        for Index, Value in pairs(Table) do
            if typeof(Value) == "Color3" then
                Table2[Index] = Value:ToHex()
            else
                Table2[Index] = tostring(Value)
            end
        end
        return hs:JSONEncode(Table2)
    end

    function utility:Decode(Table)
        if typeof(Table) == "table" then return Table end
        local s, r = pcall(hs.JSONDecode, hs, Table)
        return s and r or {}
    end
end

-- // Library Methods
do
    library.__index = library
    pages.__index = pages
    sections.__index = sections

    function library:EnsureFolders()
        if not isfolder(library.folders.main) then pcall(makefolder, library.folders.main) end
        if not isfolder(library.folders.configs) then pcall(makefolder, library.folders.configs) end
        if not isfolder(library.folders.assets) then pcall(makefolder, library.folders.assets) end
    end

    function library:ScanConfigs()
        library:EnsureFolders()
        library.configs = {}
        local success, files = pcall(listfiles, library.folders.configs)
        if success and typeof(files) == "table" then
            for _, filePath in pairs(files) do
                local fileName = filePath:match("([^\\/]+)$")
                if fileName then
                    local baseName = fileName:match("([^\\/]+)%.[^\\/.]+$") or fileName
                    if not Find(library.configs, baseName) then
                        library.configs[#library.configs + 1] = baseName
                    end
                end
            end
        end
        return library.configs
    end

    function library:GetConfigs()
        if #library.configs == 0 then library:ScanConfigs() end
        return library.configs
    end

    function library:RefreshConfigList(pointerName)
        library:ScanConfigs()
        local boxName = pointerName or library.configListPointer or "ConfigConfiguration_Box"
        local list = library.pointers[boxName]
        if list and list.options then
            list.options = library.configs
            list.current = math.clamp(list.current or 0, 0, #library.configs)
            if list.UpdateScroll then list:UpdateScroll() end
        end
    end

    function library:GetConfig()
        local Config = ""
        for Index, Value in pairs(library.pointers) do
            if not library.ignoreConfigFlags[Index] then
                local Value2 = Value:Get()
                local Final = ""

                if typeof(Value2) == "Color3" then
                    local Values = Value.current or {Value2:ToHSV()}
                    Final = ("rgb(%s,%s,%s,%s)"):format(Values[1] or 0, Values[2] or 0, Values[3] or 0, Values[4] or 0)
                elseif typeof(Value2) == "table" and Value2.Color and Value2.Transparency then
                    local Values = Value.current or {Value2.Color:ToHSV()}
                    Final = ("rgb(%s,%s,%s,%s)"):format(Values[1] or 0, Values[2] or 0, Values[3] or 0, Value2.Transparency or 0)
                elseif Value.mode then
                    local Values = Value.current
                    local k1 = typeof(Values) == "table" and Values[1] or Values
                    Final = ("key(%s,%s)"):format(utility:InputToString(k1), Value.mode or "Toggle")
                elseif Value2 ~= nil then
                    if typeof(Value2) == "boolean" then
                        Final = ("bool(%s)"):format(tostring(Value2))
                    elseif typeof(Value2) == "table" then
                        Final = "table(" .. table.concat(Value2, ",") .. ")"
                    elseif typeof(Value2) == "string" then
                        Final = ("string(%s)"):format(Value2)
                    elseif typeof(Value2) == "number" then
                        Final = ("number(%s)"):format(Value2)
                    end
                end

                if Final ~= "" then
                    Config = Config .. Index .. ": " .. Final .. "\n"
                end
            end
        end
        return Config .. (library.configFooter or "[ rosehook ]")
    end

    function library:ParseConfig(ConfigData)
        if typeof(ConfigData) == "table" then return ConfigData end
        if typeof(ConfigData) ~= "string" then return {} end

        local Table = ConfigData:split("\n")
        local Table2 = {}

        if Table[#Table] and Table[#Table]:match("^%[.+%]$") then
            Remove(Table, #Table)
        end

        for _, Value in pairs(Table) do
            local colonPos = Value:find(":")
            if colonPos then
                local FlagName = Value:sub(1, colonPos - 1):match("^%s*(.-)%s*$")
                local RawVal = Value:sub(colonPos + 1):match("^%s*(.-)%s*$")

                if not library.ignoreConfigFlags[FlagName] then
                    local ParsedVal = RawVal
                    if RawVal:sub(1, 3) == "rgb" then
                        local parts = RawVal:sub(5, #RawVal - 1):split(",")
                        for i = 1, #parts do parts[i] = tonumber(parts[i]) or 0 end
                        ParsedVal = parts
                    elseif RawVal:sub(1, 3) == "key" then
                        local parts = RawVal:sub(5, #RawVal - 1):split(",")
                        ParsedVal = parts
                    elseif RawVal:sub(1, 4) == "bool" then
                        ParsedVal = (RawVal:sub(6, #RawVal - 1):lower() == "true")
                    elseif RawVal:sub(1, 5) == "table" then
                        local inner = RawVal:sub(7, #RawVal - 1)
                        ParsedVal = inner == "" and {} or inner:split(",")
                    elseif RawVal:sub(1, 6) == "string" then
                        ParsedVal = RawVal:sub(8, #RawVal - 1)
                    elseif RawVal:sub(1, 6) == "number" then
                        ParsedVal = tonumber(RawVal:sub(8, #RawVal - 1)) or 0
                    end
                    Table2[FlagName] = ParsedVal
                end
            end
        end
        return Table2
    end

    function library:LoadConfig(Config)
        if typeof(Config) == "string" then
            Config = library:ParseConfig(Config)
        end
        if typeof(Config) == "table" then
            for Index, Value in pairs(Config) do
                if library.pointers[Index] and typeof(library.pointers[Index].Set) == "function" then
                    pcall(function() library.pointers[Index]:Set(Value) end)
                end
            end
        end
    end

    function library:SaveConfig(ConfigName)
        return library:PerformConfigAction(ConfigName, "Save")
    end

    function library:DeleteConfig(ConfigName)
        return library:PerformConfigAction(ConfigName, "Delete")
    end

    function library:PerformConfigAction(ConfigName, Action)
        if not ConfigName or ConfigName:match("^%s*$") then
            if library.pointers["ConfigConfiguration_Name"] and library.pointers["ConfigConfiguration_Name"]:Get() ~= "" then
                ConfigName = library.pointers["ConfigConfiguration_Name"]:Get()
            elseif library.pointers["ConfigConfiguration_Box"] and library.pointers["ConfigConfiguration_Box"]:Get() then
                ConfigName = library.pointers["ConfigConfiguration_Box"]:Get()
            end
        end
        if not ConfigName or ConfigName:match("^%s*$") then return end

        library:EnsureFolders()
        local filePath = library.folders.configs .. "/" .. ConfigName .. (library.configExtension or ".rosehook")

        if Action == "Delete" then
            local foundIndex = Find(library.configs, ConfigName)
            if foundIndex then
                Remove(library.configs, foundIndex)
                library:RefreshConfigList()
            end
            if isfile(filePath) then pcall(delfile, filePath) end
        elseif Action == "Save" then
            local configData = library:GetConfig()
            if configData then
                if not Find(library.configs, ConfigName) then
                    library.configs[#library.configs + 1] = ConfigName
                    library:RefreshConfigList()
                end
                pcall(writefile, filePath, configData)
            end
        elseif Action == "Load" then
            if isfile(filePath) then
                local success, data = pcall(readfile, filePath)
                if success and data then
                    library:LoadConfig(data)
                end
            end
        end
    end

    function library:UpdateColor(ColorType, ColorValue)
        if not ColorType or not ColorValue then return end
        local normType = ColorType:lower()
        if normType == "lighttext" or normType == "text" then normType = "textcolor" end
        if normType == "darktext" then normType = "textdark" end
        if normType == "textoutline" then normType = "textborder" end

        theme[normType] = ColorValue
        for drawing, propTable in pairs(library.colors) do
            for propName, colorKey in pairs(propTable) do
                if colorKey:lower() == normType then
                    pcall(function() drawing[propName] = ColorValue end)
                end
            end
        end
    end

    function library:LoadTheme(ThemeType)
        local themeData
        if typeof(ThemeType) == "table" then
            themeData = ThemeType[2] or ThemeType
        elseif typeof(ThemeType) == "string" and library.themes[ThemeType] then
            themeData = library.themes[ThemeType][2] or library.themes[ThemeType]
        end

        if typeof(themeData) == "string" then themeData = utility:Decode(themeData) end
        if typeof(themeData) == "table" then
            for Index, Value in pairs(themeData) do
                local col = Value
                if typeof(col) == "string" then
                    local s, parsed = pcall(Color3.fromHex, col)
                    if s and parsed then col = parsed end
                end
                if typeof(col) == "Color3" then
                    library:UpdateColor(Index, col)
                end
            end
        end
    end

    function library:GetThemes()
        return utility:GetTableIndexes(library.themes, true)
    end
end

-- // Window Construction
function library:New(info)
    info = info or {}
    local name = info.name or info.Name or info.title or info.Title or "Rosehook"
    local size = info.size or info.Size or Vector2.new(504, 604)
    local accent = info.accent or info.Accent or theme.accent
    local uibind = info.uibind or Enum.KeyCode.End

    theme.accent = accent

    local window = {
        pages = {},
        isVisible = false,
        currentPage = nil,
        fading = false,
        dragging = false,
        drag = Vector2.new(0, 0),
        currentContent = {frame = nil, dropdown = nil, multibox = nil, colorpicker = nil, keybind = nil, textbox = nil},
        tooltipElements = {},
        uibind = uibind
    }

    local main_frame = utility:Create("Frame", {Vector2.new(0, 0)}, {
        Size = utility:Size(0, size.X, 0, size.Y),
        Position = utility:Position(0.5, -(size.X / 2), 0.5, -(size.Y / 2)),
        Color = theme.outline
    })
    window.main_frame = main_frame
    library.colors[main_frame] = {Color = "outline"}

    local frame_inline = utility:Create("Frame", {Vector2.new(1, 1), main_frame}, {
        Size = utility:Size(1, -2, 1, -2, main_frame),
        Position = utility:Position(0, 1, 0, 1, main_frame),
        Color = theme.accent
    })
    library.colors[frame_inline] = {Color = "accent"}

    local inner_frame = utility:Create("Frame", {Vector2.new(1, 1), frame_inline}, {
        Size = utility:Size(1, -2, 1, -2, frame_inline),
        Position = utility:Position(0, 1, 0, 1, frame_inline),
        Color = theme.lightcontrast
    })
    library.colors[inner_frame] = {Color = "lightcontrast"}

    local title = utility:Create("TextLabel", {Vector2.new(6, 2), inner_frame}, {
        Text = name,
        Size = theme.textsize,
        Font = theme.font,
        Color = theme.textcolor,
        OutlineColor = theme.textborder,
        Position = utility:Position(0, 6, 0, 2, inner_frame)
    })
    library.colors[title] = {OutlineColor = "textborder", Color = "textcolor"}

    local inner_frame_inline = utility:Create("Frame", {Vector2.new(4, 18), inner_frame}, {
        Size = utility:Size(1, -8, 1, -22, inner_frame),
        Position = utility:Position(0, 4, 0, 18, inner_frame),
        Color = theme.inline
    })
    library.colors[inner_frame_inline] = {Color = "inline"}

    local inner_frame_inline2 = utility:Create("Frame", {Vector2.new(1, 1), inner_frame_inline}, {
        Size = utility:Size(1, -2, 1, -2, inner_frame_inline),
        Position = utility:Position(0, 1, 0, 1, inner_frame_inline),
        Color = theme.outline
    })
    library.colors[inner_frame_inline2] = {Color = "outline"}

    local back_frame = utility:Create("Frame", {Vector2.new(1, 1), inner_frame_inline2}, {
        Size = utility:Size(1, -2, 1, -2, inner_frame_inline2),
        Position = utility:Position(0, 1, 0, 1, inner_frame_inline2),
        Color = theme.darkcontrast
    })
    window.back_frame = back_frame
    library.colors[back_frame] = {Color = "darkcontrast"}

    local tab_frame_inline = utility:Create("Frame", {Vector2.new(4, 24), back_frame}, {
        Size = utility:Size(1, -8, 1, -28, back_frame),
        Position = utility:Position(0, 4, 0, 24, back_frame),
        Color = theme.outline
    })
    library.colors[tab_frame_inline] = {Color = "outline"}

    local tab_frame_inline2 = utility:Create("Frame", {Vector2.new(1, 1), tab_frame_inline}, {
        Size = utility:Size(1, -2, 1, -2, tab_frame_inline),
        Position = utility:Position(0, 1, 0, 1, tab_frame_inline),
        Color = theme.inline
    })
    library.colors[tab_frame_inline2] = {Color = "inline"}

    local tab_frame = utility:Create("Frame", {Vector2.new(1, 1), tab_frame_inline2}, {
        Size = utility:Size(1, -2, 1, -2, tab_frame_inline2),
        Position = utility:Position(0, 1, 0, 1, tab_frame_inline2),
        Color = theme.lightcontrast
    })
    window.tab_frame = tab_frame
    library.colors[tab_frame] = {Color = "lightcontrast"}

    -- // Tooltip Drawings (Hidden by Default)
    local tooltip_outline = utility:Create("Frame", nil, {
        Size = Vector2.new(100, 30),
        Color = theme.outline,
        ZIndex = 120,
        Visible = false,
        Hidden = true
    })
    local tooltip_inline = utility:Create("Frame", {Vector2.new(1, 1), tooltip_outline}, {
        Size = Vector2.new(98, 28),
        Color = theme.inline,
        ZIndex = 121,
        Visible = false,
        Hidden = true
    })
    local tooltip_fill = utility:Create("Frame", {Vector2.new(1, 1), tooltip_inline}, {
        Size = Vector2.new(96, 26),
        Color = theme.darkcontrast,
        ZIndex = 122,
        Visible = false,
        Hidden = true
    })
    local tooltip_title = utility:Create("TextLabel", {Vector2.new(4, 3), tooltip_fill}, {
        Text = "",
        Size = 13,
        Font = 2,
        Color = theme.accent,
        OutlineColor = theme.textborder,
        ZIndex = 123,
        Visible = false,
        Hidden = true
    })
    local tooltip_desc = utility:Create("TextLabel", {Vector2.new(4, 18), tooltip_fill}, {
        Text = "",
        Size = 12,
        Font = 2,
        Color = theme.textcolor,
        OutlineColor = theme.textborder,
        ZIndex = 123,
        Visible = false,
        Hidden = true
    })

    function window:ShowTooltip(text)
        if not window.isVisible or window:IsOverContent() or window.dragging then
            window:HideTooltip()
            return
        end

        local titleText, descText = text:match("^(.-)\n(.*)$")
        if not titleText then
            titleText = text
            descText = nil
        end

        tooltip_title.Text = titleText
        tooltip_desc.Text = descText or ""
        tooltip_desc.Visible = (descText ~= nil and descText ~= "")

        local titleBounds = utility:GetTextBounds(titleText, 13, 2)
        local descBounds = descText and utility:GetTextBounds(descText, 12, 2) or Vector2.new(0, 0)

        local width = math.max(titleBounds.X, descBounds.X) + 12
        local height = (descText and (titleBounds.Y + descBounds.Y + 10) or (titleBounds.Y + 8))

        local mousePos = utility:MouseLocation() + Vector2.new(14, 14)
        local screen = utility:GetScreenSize()
        if mousePos.X + width > screen.X - 5 then
            mousePos = Vector2.new(mousePos.X - width - 20, mousePos.Y)
        end
        if mousePos.Y + height > screen.Y - 5 then
            mousePos = Vector2.new(mousePos.X, mousePos.Y - height - 20)
        end

        tooltip_outline.Size = Vector2.new(width, height)
        tooltip_outline.Position = mousePos
        tooltip_inline.Size = Vector2.new(width - 2, height - 2)
        tooltip_inline.Position = mousePos + Vector2.new(1, 1)
        tooltip_fill.Size = Vector2.new(width - 4, height - 4)
        tooltip_fill.Position = mousePos + Vector2.new(2, 2)
        tooltip_title.Position = mousePos + Vector2.new(5, 4)
        if descText then
            tooltip_desc.Position = mousePos + Vector2.new(5, 4 + titleBounds.Y + 2)
        end

        tooltip_outline.Visible = true
        tooltip_inline.Visible = true
        tooltip_fill.Visible = true
        tooltip_title.Visible = true
    end

    function window:HideTooltip()
        tooltip_outline.Visible = false
        tooltip_inline.Visible = false
        tooltip_fill.Visible = false
        tooltip_title.Visible = false
        tooltip_desc.Visible = false
    end

    function window:Move(vector)
        for _, v in pairs(library.drawings) do
            if v[1] and v[1].Visible then
                if v[2] and v[2][2] then
                    v[1].Position = utility:Position(0, v[2][1].X, 0, v[2][1].Y, v[2][2])
                else
                    v[1].Position = utility:Position(0, vector.X, 0, vector.Y)
                end
            end
        end
    end

    function window:CloseContent()
        if window.currentContent.dropdown and window.currentContent.dropdown.open then
            local dropdown = window.currentContent.dropdown
            dropdown.open = false
            utility:LoadImage(dropdown.dropdown_image, "arrow_down")
            for _, v in pairs(dropdown.holder.drawings or {}) do utility:Remove(v) end
            dropdown.holder.drawings = {}
            dropdown.holder.buttons = {}
            window.currentContent.frame = nil
            window.currentContent.dropdown = nil
        elseif window.currentContent.multibox and window.currentContent.multibox.open then
            local multibox = window.currentContent.multibox
            multibox.open = false
            utility:LoadImage(multibox.multibox_image, "arrow_down")
            for _, v in pairs(multibox.holder.drawings or {}) do utility:Remove(v) end
            multibox.holder.drawings = {}
            multibox.holder.buttons = {}
            window.currentContent.frame = nil
            window.currentContent.multibox = nil
        elseif window.currentContent.colorpicker and window.currentContent.colorpicker.open then
            local cp = window.currentContent.colorpicker
            cp.open = false
            for _, v in pairs(cp.holder.drawings or {}) do utility:Remove(v) end
            cp.holder.drawings = {}
            window.currentContent.frame = nil
            window.currentContent.colorpicker = nil
        elseif window.currentContent.keybind and window.currentContent.keybind.open then
            local modemenu = window.currentContent.keybind.modemenu
            window.currentContent.keybind.open = false
            for _, v in pairs(modemenu.drawings or {}) do utility:Remove(v) end
            modemenu.drawings = {}
            window.currentContent.frame = nil
            window.currentContent.keybind = nil
        end
    end

    function window:IsOverContent()
        if not window.isVisible then return false end
        if window.currentContent.frame then
            local f = window.currentContent.frame
            return utility:MouseOverDrawing({f.Position.X, f.Position.Y, f.Position.X + f.Size.X, f.Position.Y + f.Size.Y})
        end
        return false
    end

    function window:IsOverUI()
        if not window.isVisible then return false end
        return utility:MouseOverDrawing({main_frame.Position.X, main_frame.Position.Y, main_frame.Position.X + main_frame.Size.X, main_frame.Position.Y + main_frame.Size.Y})
    end

    -- // Block clicks ONLY when window is visible and mouse is over UI
    local BlockClicksAction = "RosehookBlockClicks" .. tostring(window)
    cas:BindActionAtPriority(BlockClicksAction, function()
        if window.isVisible and (window:IsOverUI() or window:IsOverContent()) then
            return Enum.ContextActionResult.Sink
        end
        return Enum.ContextActionResult.Pass
    end, false, 3000, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2)

    function window:Cursor()
        window.cursor = {}
        local cursor = utility:Create("Triangle", nil, {
            Color = theme.cursoroutline,
            Thickness = 2.5,
            Filled = false,
            ZIndex = 65,
            Hidden = true
        })
        window.cursor.cursor = cursor
        library.colors[cursor] = {Color = "cursoroutline"}

        local cursor_inline = utility:Create("Triangle", nil, {
            Color = theme.accent,
            Filled = true,
            Thickness = 0,
            ZIndex = 65,
            Hidden = true
        })
        window.cursor.cursor_inline = cursor_inline
        library.colors[cursor_inline] = {Color = "accent"}

        utility:Connection(rs.RenderStepped, function()
            if not window.isVisible then
                cursor.Visible = false
                cursor_inline.Visible = false
                return
            end
            local mouseLoc = utility:MouseLocation()
            cursor.PointA = Vector2.new(mouseLoc.X, mouseLoc.Y)
            cursor.PointB = Vector2.new(mouseLoc.X + 12, mouseLoc.Y + 4)
            cursor.PointC = Vector2.new(mouseLoc.X + 4, mouseLoc.Y + 12)
            cursor.Visible = true

            cursor_inline.PointA = Vector2.new(mouseLoc.X, mouseLoc.Y)
            cursor_inline.PointB = Vector2.new(mouseLoc.X + 12, mouseLoc.Y + 4)
            cursor_inline.PointC = Vector2.new(mouseLoc.X + 4, mouseLoc.Y + 12)
            cursor_inline.Visible = true
        end)
    end

    function window:Fade()
        window.fading = true
        window.isVisible = not window.isVisible

        if not window.isVisible then
            window:CloseContent()
            window:HideTooltip()
        end

        for _, v in pairs(library.drawings) do
            utility:Lerp(v[1], {Transparency = window.isVisible and v[3] or 0}, 0.2)
        end

        if window.cursor and window.cursor.cursor then
            window.cursor.cursor.Visible = window.isVisible
            window.cursor.cursor_inline.Visible = window.isVisible
        end
        uis.MouseIconEnabled = not window.isVisible
        window.fading = false
    end

    function window:Initialize()
        if window.pages[1] then window.pages[1]:Show() end
        for _, v in pairs(window.pages) do v:Update() end
        library.shared.initialized = true
        window:Cursor()
        window:Fade()
    end

    function window:Unload()
        pcall(function() cas:UnbindAction(BlockClicksAction) end)
        for _, v in pairs(library.connections) do v:Disconnect() end
        for _, v in pairs(library.drawings) do pcall(function() v[1]:Remove() end) end
        for _, v in pairs(library.hidden) do pcall(function() v[1]:Remove() end) end
        uis.MouseIconEnabled = true
    end

    -- // Window drag & key handling
    library.began[#library.began + 1] = function(Input)
        if Input.KeyCode == window.uibind then
            window:Fade()
            return
        end

        if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible then
            if utility:MouseOverDrawing({main_frame.Position.X, main_frame.Position.Y, main_frame.Position.X + main_frame.Size.X, main_frame.Position.Y + 20}) then
                local mouseLocation = utility:MouseLocation()
                window.dragging = true
                window.drag = Vector2.new(mouseLocation.X - main_frame.Position.X, mouseLocation.Y - main_frame.Position.Y)
            end
        end
    end

    library.ended[#library.ended + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            window.dragging = false
        end
    end

    library.changed[#library.changed + 1] = function()
        if window.dragging and window.isVisible then
            local mouseLocation = utility:MouseLocation()
            local screen = utility:GetScreenSize()
            local move = Vector2.new(
                math.clamp(mouseLocation.X - window.drag.X, 5, screen.X - main_frame.Size.X - 5),
                math.clamp(mouseLocation.Y - window.drag.Y, 5, screen.Y - main_frame.Size.Y - 5)
            )
            window:Move(move)
        end
    end

    -- // Tooltip Hover Scanner
    utility:Connection(rs.RenderStepped, function()
        if not window.isVisible or window.dragging or window:IsOverContent() then
            window:HideTooltip()
            return
        end

        local activeTooltip = nil
        for _, item in ipairs(window.tooltipElements) do
            if item.checkHover() and item.text then
                activeTooltip = item.text
                break
            end
        end

        if activeTooltip then
            window:ShowTooltip(activeTooltip)
        else
            window:HideTooltip()
        end
    end)

    utility:Connection(uis.InputBegan, function(Input)
        for _, func in pairs(library.began) do func(Input) end
    end)
    utility:Connection(uis.InputEnded, function(Input)
        for _, func in pairs(library.ended) do func(Input) end
    end)
    utility:Connection(uis.InputChanged, function()
        for _, func in pairs(library.changed) do func() end
    end)

    return setmetatable(window, library)
end

-- // Pages
function library:Page(info)
    info = info or {}
    local name = info.Name or info.name or "Page"
    local window = self

    local page = {
        name = name,
        window = window,
        sections = {},
        leftSections = {},
        rightSections = {},
        button = nil,
        active = false
    }

    local index = #window.pages + 1
    local tabWidth = math.floor((window.back_frame.Size.X - 8) / 5)

    local tab_button = utility:Create("Frame", {Vector2.new(4 + (index - 1) * tabWidth, 4), window.back_frame}, {
        Size = Vector2.new(tabWidth - 2, 18),
        Color = theme.darkcontrast,
        Position = utility:Position(0, 4 + (index - 1) * tabWidth, 0, 4, window.back_frame)
    })

    local tab_title = utility:Create("TextLabel", {Vector2.new(tabWidth / 2, 2), tab_button}, {
        Text = name,
        Size = 13,
        Font = 2,
        Center = true,
        Color = theme.textdark,
        Position = utility:Position(0.5, 0, 0, 2, tab_button)
    })

    page.button = tab_button
    page.title = tab_title

    function page:Show()
        for _, p in pairs(window.pages) do p:Hide() end
        page.active = true
        tab_title.Color = theme.textcolor
        for _, sec in pairs(page.sections) do sec:SetVisible(true) end
        page:Update()
    end

    function page:Hide()
        page.active = false
        tab_title.Color = theme.textdark
        for _, sec in pairs(page.sections) do sec:SetVisible(false) end
    end

    function page:Update()
        local leftOffset = 4
        for _, sec in ipairs(page.leftSections) do
            sec:SetOffset(leftOffset)
            leftOffset = leftOffset + sec.size + 8
        end
        local rightOffset = 4
        for _, sec in ipairs(page.rightSections) do
            sec:SetOffset(rightOffset)
            rightOffset = rightOffset + sec.size + 8
        end
    end

    library.began[#library.began + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible then
            if utility:MouseOverDrawing({tab_button.Position.X, tab_button.Position.Y, tab_button.Position.X + tab_button.Size.X, tab_button.Position.Y + tab_button.Size.Y}) then
                page:Show()
            end
        end
    end

    window.pages[index] = page
    return setmetatable(page, pages)
end

-- // Sections
function pages:Section(info)
    info = info or {}
    local name = info.Name or info.name or "Section"
    local side = (info.Side or info.side or "left"):lower()
    local page = self
    local window = page.window

    local secWidth = math.floor((window.tab_frame.Size.X - 12) / 2)
    local xOffset = side == "left" and 4 or (secWidth + 8)

    local section = {
        name = name,
        side = side,
        page = page,
        window = window,
        size = 20,
        drawings = {},
        elements = {}
    }

    local sec_outline = utility:Create("Frame", {Vector2.new(xOffset, 4), window.tab_frame}, {
        Size = Vector2.new(secWidth, 40),
        Color = theme.outline,
        Position = utility:Position(0, xOffset, 0, 4, window.tab_frame)
    }, section.drawings)

    local sec_inline = utility:Create("Frame", {Vector2.new(1, 1), sec_outline}, {
        Size = Vector2.new(secWidth - 2, 38),
        Color = theme.inline,
        Position = utility:Position(0, 1, 0, 1, sec_outline)
    }, section.drawings)

    local sec_fill = utility:Create("Frame", {Vector2.new(1, 1), sec_inline}, {
        Size = Vector2.new(secWidth - 4, 36),
        Color = theme.darkcontrast,
        Position = utility:Position(0, 1, 0, 1, sec_inline)
    }, section.drawings)

    local sec_title = utility:Create("TextLabel", {Vector2.new(10, -7), sec_outline}, {
        Text = " " .. name .. " ",
        Size = 13,
        Font = 2,
        Color = theme.textcolor,
        OutlineColor = theme.darkcontrast,
        Position = utility:Position(0, 10, 0, -7, sec_outline)
    }, section.drawings)

    section.frame = sec_outline
    section.fill = sec_fill

    function section:SetOffset(yOffset)
        sec_outline.Position = utility:Position(0, xOffset, 0, yOffset, window.tab_frame)
        sec_outline.Size = Vector2.new(secWidth, section.size)
        sec_inline.Size = Vector2.new(secWidth - 2, section.size - 2)
        sec_fill.Size = Vector2.new(secWidth - 4, section.size - 4)
    end

    function section:SetVisible(vis)
        for _, d in pairs(section.drawings) do d.Visible = vis end
        for _, elem in pairs(section.elements) do
            if elem.SetVisible then elem:SetVisible(vis) end
        end
    end

    function section:RegisterTooltip(checkHoverFunc, tooltipText)
        if tooltipText and tooltipText ~= "" then
            window.tooltipElements[#window.tooltipElements + 1] = {
                checkHover = checkHoverFunc,
                text = tooltipText
            }
        end
    end

    if side == "left" then
        page.leftSections[#page.leftSections + 1] = section
    else
        page.rightSections[#page.rightSections + 1] = section
    end
    page.sections[#page.sections + 1] = section

    return setmetatable(section, sections)
end

-- // Section Elements: Toggle (with Chaining)
function sections:Toggle(info)
    info = info or {}
    local name = info.Name or info.name or "Toggle"
    local flag = info.Flag or info.flag or name
    local default = info.Default or info.def or false
    local callback = info.Callback or info.callback or function() end
    local tooltip = info.Tooltip or info.tooltip
    local section = self
    local window = section.window

    local toggle = {
        name = name,
        flag = flag,
        state = default,
        callback = callback,
        drawings = {}
    }

    local yPos = section.size
    section.size = section.size + 18

    local box_outline = utility:Create("Frame", {Vector2.new(8, yPos), section.fill}, {
        Size = Vector2.new(10, 10),
        Color = theme.outline,
        Position = utility:Position(0, 8, 0, yPos, section.fill)
    }, section.drawings)

    local box_inline = utility:Create("Frame", {Vector2.new(1, 1), box_outline}, {
        Size = Vector2.new(8, 8),
        Color = theme.inline,
        Position = utility:Position(0, 1, 0, 1, box_outline)
    }, section.drawings)

    local box_fill = utility:Create("Frame", {Vector2.new(1, 1), box_inline}, {
        Size = Vector2.new(6, 6),
        Color = default and theme.accent or theme.lightcontrast,
        Position = utility:Position(0, 1, 0, 1, box_inline)
    }, section.drawings)

    local text_label = utility:Create("TextLabel", {Vector2.new(24, yPos - 2), section.fill}, {
        Text = name,
        Size = 13,
        Font = 2,
        Color = default and theme.textcolor or theme.textdark,
        Position = utility:Position(0, 24, 0, yPos - 2, section.fill)
    }, section.drawings)

    function toggle:Set(val)
        toggle.state = val
        box_fill.Color = val and theme.accent or theme.lightcontrast
        text_label.Color = val and theme.textcolor or theme.textdark
        library.pointers[flag] = toggle
        pcall(callback, val)
    end

    function toggle:Get() return toggle.state end

    section:RegisterTooltip(function()
        return section.page.active and utility:MouseOverDrawing({
            box_outline.Position.X, box_outline.Position.Y,
            box_outline.Position.X + 120, box_outline.Position.Y + 12
        })
    end, tooltip)

    library.began[#library.began + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and section.page.active then
            if not window:IsOverContent() and utility:MouseOverDrawing({
                box_outline.Position.X, box_outline.Position.Y,
                box_outline.Position.X + 120, box_outline.Position.Y + 12
            }) then
                toggle:Set(not toggle.state)
            end
        end
    end

    library.pointers[flag] = toggle
    section.page:Update()

    -- Chained Keybind Support
    function toggle:Keybind(kInfo)
        kInfo = kInfo or {}
        local kFlag = kInfo.Flag or (flag .. "_Key")
        local kDef = kInfo.Default or kInfo.def
        local kMode = kInfo.Mode or "Toggle"
        local kTooltip = kInfo.Tooltip or kInfo.tooltip

        local keybind = {
            current = kDef,
            mode = kMode,
            binding = false,
            bindTick = 0
        }

        local key_label = utility:Create("TextLabel", {Vector2.new(-12, yPos - 2), section.fill}, {
            Text = "[" .. utility:InputToString(kDef) .. "]",
            Size = 13,
            Font = 2,
            Color = theme.textdark,
            Position = utility:Position(1, -30, 0, yPos - 2, section.fill)
        }, section.drawings)

        function keybind:Set(newKey)
            if typeof(newKey) == "table" then
                keybind.current = newKey[1]
                keybind.mode = newKey[2] or keybind.mode
            else
                keybind.current = newKey
            end
            key_label.Text = "[" .. utility:InputToString(keybind.current) .. "]"
        end

        function keybind:Get() return keybind.current end

        section:RegisterTooltip(function()
            return section.page.active and utility:MouseOverDrawing({
                key_label.Position.X - 5, key_label.Position.Y,
                key_label.Position.X + key_label.TextBounds.X + 5, key_label.Position.Y + 12
            })
        end, kTooltip)

        library.began[#library.began + 1] = function(Input)
            if keybind.binding then
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseButton2 or Input.UserInputType == Enum.UserInputType.MouseButton3 then
                    if tick() - keybind.bindTick > 0.15 then
                        keybind.current = Input.UserInputType
                        keybind.binding = false
                        key_label.Text = "[" .. utility:InputToString(keybind.current) .. "]"
                    end
                elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                    if Input.KeyCode == Enum.KeyCode.Escape then
                        keybind.current = nil
                    else
                        keybind.current = Input.KeyCode
                    end
                    keybind.binding = false
                    key_label.Text = "[" .. utility:InputToString(keybind.current) .. "]"
                end
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and section.page.active then
                if not window:IsOverContent() and utility:MouseOverDrawing({
                    key_label.Position.X - 4, key_label.Position.Y,
                    key_label.Position.X + key_label.TextBounds.X + 4, key_label.Position.Y + 12
                }) then
                    keybind.binding = true
                    keybind.bindTick = tick()
                    key_label.Text = "[...]"
                    return
                end
            end

            if utility:MatchesInput(Input, keybind.current) then
                if keybind.mode == "Toggle" then
                    toggle:Set(not toggle.state)
                elseif keybind.mode == "On Hold" or keybind.mode == "Hold" then
                    toggle:Set(true)
                end
            end
        end

        library.ended[#library.ended + 1] = function(Input)
            if (keybind.mode == "On Hold" or keybind.mode == "Hold") and utility:MatchesInput(Input, keybind.current) then
                toggle:Set(false)
            end
        end

        library.pointers[kFlag] = keybind
        return toggle
    end

    return toggle
end

-- // Section Elements: Slider
function sections:Slider(info)
    info = info or {}
    local name = info.Name or info.name or "Slider"
    local flag = info.Flag or info.flag or name
    local min = info.Min or info.min or 0
    local max = info.Max or info.max or 100
    local def = info.Def or info.def or min
    local decimals = info.Decimals or info.decimals or 0
    local suffix = info.Suffix or info.suffix or ""
    local callback = info.Callback or info.callback or function() end
    local tooltip = info.Tooltip or info.tooltip
    local section = self
    local window = section.window

    local slider = {
        value = def,
        dragging = false,
        drawings = {}
    }

    local yPos = section.size
    section.size = section.size + 28

    local name_label = utility:Create("TextLabel", {Vector2.new(8, yPos), section.fill}, {
        Text = name,
        Size = 13,
        Font = 2,
        Color = theme.textcolor,
        Position = utility:Position(0, 8, 0, yPos, section.fill)
    }, section.drawings)

    local value_label = utility:Create("TextLabel", {Vector2.new(-8, yPos), section.fill}, {
        Text = tostring(def) .. suffix,
        Size = 13,
        Font = 2,
        Color = theme.textdark,
        Position = utility:Position(1, -30, 0, yPos, section.fill)
    }, section.drawings)

    local bar_width = section.fill.Size.X - 16
    local bar_outline = utility:Create("Frame", {Vector2.new(8, yPos + 14), section.fill}, {
        Size = Vector2.new(bar_width, 8),
        Color = theme.outline,
        Position = utility:Position(0, 8, 0, yPos + 14, section.fill)
    }, section.drawings)

    local bar_inline = utility:Create("Frame", {Vector2.new(1, 1), bar_outline}, {
        Size = Vector2.new(bar_width - 2, 6),
        Color = theme.inline,
        Position = utility:Position(0, 1, 0, 1, bar_outline)
    }, section.drawings)

    local bar_fill = utility:Create("Frame", {Vector2.new(1, 1), bar_inline}, {
        Size = Vector2.new(math.clamp((def - min) / (max - min) * (bar_width - 4), 0, bar_width - 4), 4),
        Color = theme.accent,
        Position = utility:Position(0, 1, 0, 1, bar_inline)
    }, section.drawings)

    function slider:Set(val)
        val = math.clamp(tonumber(val) or min, min, max)
        if decimals > 0 then
            val = math.floor(val * (10 ^ decimals) + 0.5) / (10 ^ decimals)
        else
            val = math.floor(val + 0.5)
        end
        slider.value = val
        bar_fill.Size = Vector2.new(math.clamp((val - min) / (max - min) * (bar_width - 4), 0, bar_width - 4), 4)
        value_label.Text = tostring(val) .. suffix
        library.pointers[flag] = slider
        pcall(callback, val)
    end

    function slider:Get() return slider.value end

    section:RegisterTooltip(function()
        return section.page.active and utility:MouseOverDrawing({
            bar_outline.Position.X - 2, bar_outline.Position.Y - 14,
            bar_outline.Position.X + bar_width + 2, bar_outline.Position.Y + 12
        })
    end, tooltip)

    library.began[#library.began + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and section.page.active then
            if not window:IsOverContent() and utility:MouseOverDrawing({
                bar_outline.Position.X, bar_outline.Position.Y,
                bar_outline.Position.X + bar_width, bar_outline.Position.Y + 8
            }) then
                slider.dragging = true
                local percent = math.clamp((utility:MouseLocation().X - bar_outline.Position.X) / bar_width, 0, 1)
                slider:Set(min + (max - min) * percent)
            end
        end
    end

    library.ended[#library.ended + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            slider.dragging = false
        end
    end

    library.changed[#library.changed + 1] = function()
        if slider.dragging and window.isVisible and section.page.active then
            local percent = math.clamp((utility:MouseLocation().X - bar_outline.Position.X) / bar_width, 0, 1)
            slider:Set(min + (max - min) * percent)
        end
    end

    library.pointers[flag] = slider
    section.page:Update()
    return slider
end

-- // Section Elements: Dropdown
function sections:Dropdown(info)
    info = info or {}
    local name = info.Name or info.name or "Dropdown"
    local flag = info.Flag or info.flag or name
    local options = info.Options or info.options or {}
    local default = info.Default or info.def or options[1]
    local callback = info.Callback or info.callback or function() end
    local tooltip = info.Tooltip or info.tooltip
    local section = self
    local window = section.window

    local dropdown = {
        value = default,
        options = options,
        open = false,
        drawings = {},
        holder = {drawings = {}}
    }

    local yPos = section.size
    section.size = section.size + 34

    utility:Create("TextLabel", {Vector2.new(8, yPos), section.fill}, {
        Text = name,
        Size = 13,
        Font = 2,
        Color = theme.textcolor,
        Position = utility:Position(0, 8, 0, yPos, section.fill)
    }, section.drawings)

    local bar_width = section.fill.Size.X - 16
    local box_outline = utility:Create("Frame", {Vector2.new(8, yPos + 14), section.fill}, {
        Size = Vector2.new(bar_width, 18),
        Color = theme.outline,
        Position = utility:Position(0, 8, 0, yPos + 14, section.fill)
    }, section.drawings)

    local box_inline = utility:Create("Frame", {Vector2.new(1, 1), box_outline}, {
        Size = Vector2.new(bar_width - 2, 16),
        Color = theme.inline,
        Position = utility:Position(0, 1, 0, 1, box_outline)
    }, section.drawings)

    local box_fill = utility:Create("Frame", {Vector2.new(1, 1), box_inline}, {
        Size = Vector2.new(bar_width - 4, 14),
        Color = theme.lightcontrast,
        Position = utility:Position(0, 1, 0, 1, box_inline)
    }, section.drawings)

    local val_label = utility:Create("TextLabel", {Vector2.new(4, 1), box_fill}, {
        Text = tostring(default),
        Size = 12,
        Font = 2,
        Color = theme.textcolor,
        Position = utility:Position(0, 4, 0, 1, box_fill)
    }, section.drawings)

    local arrow = utility:Create("Image", {Vector2.new(bar_width - 14, 5), box_outline}, {
        Size = Vector2.new(9, 6),
        Position = utility:Position(0, bar_width - 14, 0, 5, box_outline)
    }, section.drawings)
    utility:LoadImage(arrow, "arrow_down")
    dropdown.dropdown_image = arrow

    function dropdown:Set(val)
        dropdown.value = val
        val_label.Text = tostring(val)
        library.pointers[flag] = dropdown
        pcall(callback, val)
    end

    function dropdown:Get() return dropdown.value end

    function dropdown:ToggleOpen()
        dropdown.open = not dropdown.open
        if dropdown.open then
            window:CloseContent()
            dropdown.open = true
            utility:LoadImage(arrow, "arrow_up")

            local count = #dropdown.options
            local dropHeight = count * 16 + 4
            local d_outline = utility:Create("Frame", nil, {
                Size = Vector2.new(bar_width, dropHeight),
                Position = box_outline.Position + Vector2.new(0, 20),
                Color = theme.outline,
                ZIndex = 80
            }, dropdown.holder.drawings)

            local d_fill = utility:Create("Frame", {Vector2.new(1, 1), d_outline}, {
                Size = Vector2.new(bar_width - 2, dropHeight - 2),
                Position = d_outline.Position + Vector2.new(1, 1),
                Color = theme.darkcontrast,
                ZIndex = 81
            }, dropdown.holder.drawings)

            window.currentContent.frame = d_outline
            window.currentContent.dropdown = dropdown

            for i, opt in ipairs(dropdown.options) do
                local o_text = utility:Create("TextLabel", {Vector2.new(4, (i - 1) * 16 + 2), d_fill}, {
                    Text = tostring(opt),
                    Size = 12,
                    Font = 2,
                    Color = (opt == dropdown.value) and theme.accent or theme.textcolor,
                    Position = d_fill.Position + Vector2.new(4, (i - 1) * 16 + 2),
                    ZIndex = 82
                }, dropdown.holder.drawings)

                library.began[#library.began + 1] = function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and dropdown.open then
                        if utility:MouseOverDrawing({d_fill.Position.X, d_fill.Position.Y + (i - 1) * 16, d_fill.Position.X + bar_width, d_fill.Position.Y + i * 16}) then
                            dropdown:Set(opt)
                            window:CloseContent()
                        end
                    end
                end
            end
        else
            window:CloseContent()
        end
    end

    section:RegisterTooltip(function()
        return section.page.active and utility:MouseOverDrawing({
            box_outline.Position.X, box_outline.Position.Y - 14,
            box_outline.Position.X + bar_width, box_outline.Position.Y + 18
        })
    end, tooltip)

    library.began[#library.began + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and section.page.active then
            if utility:MouseOverDrawing({box_outline.Position.X, box_outline.Position.Y, box_outline.Position.X + bar_width, box_outline.Position.Y + 18}) then
                dropdown:ToggleOpen()
            elseif dropdown.open and not window:IsOverContent() then
                window:CloseContent()
            end
        end
    end

    -- Scroll Zoom Safety: Dropdown scroll never consumes zoom when closed
    library.changed[#library.changed + 1] = function(Input)
        if not window.isVisible then return end
    end

    library.pointers[flag] = dropdown
    section.page:Update()
    return dropdown
end

-- // Section Elements: Multibox
function sections:Multibox(info)
    info = info or {}
    local name = info.Name or info.name or "Multibox"
    local flag = info.Flag or info.flag or name
    local options = info.Options or info.options or {}
    local default = info.Default or info.def or {}
    local callback = info.Callback or info.callback or function() end
    local tooltip = info.Tooltip or info.tooltip
    local section = self
    local window = section.window

    local multibox = {
        value = default,
        options = options,
        open = false,
        drawings = {},
        holder = {drawings = {}}
    }

    local yPos = section.size
    section.size = section.size + 34

    utility:Create("TextLabel", {Vector2.new(8, yPos), section.fill}, {
        Text = name,
        Size = 13,
        Font = 2,
        Color = theme.textcolor,
        Position = utility:Position(0, 8, 0, yPos, section.fill)
    }, section.drawings)

    local bar_width = section.fill.Size.X - 16
    local box_outline = utility:Create("Frame", {Vector2.new(8, yPos + 14), section.fill}, {
        Size = Vector2.new(bar_width, 18),
        Color = theme.outline,
        Position = utility:Position(0, 8, 0, yPos + 14, section.fill)
    }, section.drawings)

    local box_inline = utility:Create("Frame", {Vector2.new(1, 1), box_outline}, {
        Size = Vector2.new(bar_width - 2, 16),
        Color = theme.inline,
        Position = utility:Position(0, 1, 0, 1, box_outline)
    }, section.drawings)

    local box_fill = utility:Create("Frame", {Vector2.new(1, 1), box_inline}, {
        Size = Vector2.new(bar_width - 4, 14),
        Color = theme.lightcontrast,
        Position = utility:Position(0, 1, 0, 1, box_inline)
    }, section.drawings)

    local function getDisplayText()
        if #multibox.value == 0 then return "None" end
        return table.concat(multibox.value, ", ")
    end

    local val_label = utility:Create("TextLabel", {Vector2.new(4, 1), box_fill}, {
        Text = getDisplayText(),
        Size = 12,
        Font = 2,
        Color = theme.textcolor,
        Position = utility:Position(0, 4, 0, 1, box_fill)
    }, section.drawings)

    local arrow = utility:Create("Image", {Vector2.new(bar_width - 14, 5), box_outline}, {
        Size = Vector2.new(9, 6),
        Position = utility:Position(0, bar_width - 14, 0, 5, box_outline)
    }, section.drawings)
    utility:LoadImage(arrow, "arrow_down")
    multibox.multibox_image = arrow

    function multibox:Set(val)
        multibox.value = val or {}
        val_label.Text = getDisplayText()
        library.pointers[flag] = multibox
        pcall(callback, multibox.value)
    end

    function multibox:Get() return multibox.value end

    function multibox:ToggleOpen()
        multibox.open = not multibox.open
        if multibox.open then
            window:CloseContent()
            multibox.open = true
            utility:LoadImage(arrow, "arrow_up")

            local count = #multibox.options
            local dropHeight = count * 16 + 4
            local d_outline = utility:Create("Frame", nil, {
                Size = Vector2.new(bar_width, dropHeight),
                Position = box_outline.Position + Vector2.new(0, 20),
                Color = theme.outline,
                ZIndex = 80
            }, multibox.holder.drawings)

            local d_fill = utility:Create("Frame", {Vector2.new(1, 1), d_outline}, {
                Size = Vector2.new(bar_width - 2, dropHeight - 2),
                Position = d_outline.Position + Vector2.new(1, 1),
                Color = theme.darkcontrast,
                ZIndex = 81
            }, multibox.holder.drawings)

            window.currentContent.frame = d_outline
            window.currentContent.multibox = multibox

            for i, opt in ipairs(multibox.options) do
                local selected = Find(multibox.value, opt) ~= nil
                local o_text = utility:Create("TextLabel", {Vector2.new(4, (i - 1) * 16 + 2), d_fill}, {
                    Text = tostring(opt),
                    Size = 12,
                    Font = 2,
                    Color = selected and theme.accent or theme.textcolor,
                    Position = d_fill.Position + Vector2.new(4, (i - 1) * 16 + 2),
                    ZIndex = 82
                }, multibox.holder.drawings)

                library.began[#library.began + 1] = function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and multibox.open then
                        if utility:MouseOverDrawing({d_fill.Position.X, d_fill.Position.Y + (i - 1) * 16, d_fill.Position.X + bar_width, d_fill.Position.Y + i * 16}) then
                            local idx = Find(multibox.value, opt)
                            if idx then
                                Remove(multibox.value, idx)
                                o_text.Color = theme.textcolor
                            else
                                multibox.value[#multibox.value + 1] = opt
                                o_text.Color = theme.accent
                            end
                            multibox:Set(multibox.value)
                        end
                    end
                end
            end
        else
            window:CloseContent()
        end
    end

    section:RegisterTooltip(function()
        return section.page.active and utility:MouseOverDrawing({
            box_outline.Position.X, box_outline.Position.Y - 14,
            box_outline.Position.X + bar_width, box_outline.Position.Y + 18
        })
    end, tooltip)

    library.began[#library.began + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and section.page.active then
            if utility:MouseOverDrawing({box_outline.Position.X, box_outline.Position.Y, box_outline.Position.X + bar_width, box_outline.Position.Y + 18}) then
                multibox:ToggleOpen()
            elseif multibox.open and not window:IsOverContent() then
                window:CloseContent()
            end
        end
    end

    library.pointers[flag] = multibox
    section.page:Update()
    return multibox
end

-- // Section Elements: Colorpicker (Reversed Transparency Slider)
function sections:Colorpicker(info)
    info = info or {}
    local name = info.Name or info.name or "Colorpicker"
    local flag = info.Flag or info.flag or name
    local default = info.Default or info.def or Color3.fromRGB(255, 255, 255)
    local hasTransp = info.Transparency or false
    local callback = info.Callback or info.callback or function() end
    local tooltip = info.Tooltip or info.tooltip
    local section = self
    local window = section.window

    local h, s, v = default:ToHSV()
    local colorpicker = {
        color = default,
        transparency = 0, -- 0 = fully opaque, 1 = fully transparent
        hue = h,
        sat = s,
        val = v,
        open = false,
        drawings = {},
        holder = {drawings = {}}
    }

    local yPos = section.size
    section.size = section.size + 18

    utility:Create("TextLabel", {Vector2.new(8, yPos), section.fill}, {
        Text = name,
        Size = 13,
        Font = 2,
        Color = theme.textcolor,
        Position = utility:Position(0, 8, 0, yPos, section.fill)
    }, section.drawings)

    local box_outline = utility:Create("Frame", {Vector2.new(-24, yPos), section.fill}, {
        Size = Vector2.new(16, 10),
        Color = theme.outline,
        Position = utility:Position(1, -24, 0, yPos, section.fill)
    }, section.drawings)

    local box_fill = utility:Create("Frame", {Vector2.new(1, 1), box_outline}, {
        Size = Vector2.new(14, 8),
        Color = default,
        Position = utility:Position(0, 1, 0, 1, box_outline)
    }, section.drawings)

    function colorpicker:Set(val)
        if typeof(val) == "Color3" then
            colorpicker.color = val
            local nh, ns, nv = val:ToHSV()
            colorpicker.hue, colorpicker.sat, colorpicker.val = nh, ns, nv
        elseif typeof(val) == "table" then
            if val.Color then
                colorpicker.color = val.Color
                local nh, ns, nv = val.Color:ToHSV()
                colorpicker.hue, colorpicker.sat, colorpicker.val = nh, ns, nv
                colorpicker.transparency = val.Transparency or 0
            elseif val[1] and val[2] and val[3] then
                colorpicker.hue, colorpicker.sat, colorpicker.val = val[1], val[2], val[3]
                colorpicker.color = Color3.fromHSV(val[1], val[2], val[3])
                colorpicker.transparency = val[4] or 0
            end
        end
        box_fill.Color = colorpicker.color
        library.pointers[flag] = colorpicker
        pcall(callback, colorpicker.color, colorpicker.transparency)
    end

    function colorpicker:Get()
        return hasTransp and {Color = colorpicker.color, Transparency = colorpicker.transparency} or colorpicker.color
    end

    function colorpicker:ToggleOpen()
        colorpicker.open = not colorpicker.open
        if colorpicker.open then
            window:CloseContent()
            colorpicker.open = true

            local width = 160
            local height = hasTransp and 175 or 155

            local pop_outline = utility:Create("Frame", nil, {
                Size = Vector2.new(width, height),
                Position = box_outline.Position + Vector2.new(-width + 16, 16),
                Color = theme.outline,
                ZIndex = 80
            }, colorpicker.holder.drawings)

            local pop_fill = utility:Create("Frame", {Vector2.new(1, 1), pop_outline}, {
                Size = Vector2.new(width - 2, height - 2),
                Position = pop_outline.Position + Vector2.new(1, 1),
                Color = theme.darkcontrast,
                ZIndex = 81
            }, colorpicker.holder.drawings)

            window.currentContent.frame = pop_outline
            window.currentContent.colorpicker = colorpicker

            -- SV Area
            local sv_box = utility:Create("Frame", {Vector2.new(6, 6), pop_fill}, {
                Size = Vector2.new(125, 125),
                Position = pop_fill.Position + Vector2.new(6, 6),
                Color = theme.outline,
                ZIndex = 82
            }, colorpicker.holder.drawings)

            local sv_cells = utility:CreateColorPickerGrid(sv_box, colorpicker.holder.drawings, colorpicker.hue)

            -- Hue Bar
            local hue_box = utility:Create("Frame", {Vector2.new(137, 6), pop_fill}, {
                Size = Vector2.new(14, 125),
                Position = pop_fill.Position + Vector2.new(137, 6),
                Color = theme.outline,
                ZIndex = 82
            }, colorpicker.holder.drawings)

            utility:CreateHuePickerGrid(hue_box, colorpicker.holder.drawings)

            -- Reversed Transparency Slider
            local transp_box, transp_gradient
            if hasTransp then
                transp_box = utility:Create("Frame", {Vector2.new(6, 137), pop_fill}, {
                    Size = Vector2.new(145, 12),
                    Position = pop_fill.Position + Vector2.new(6, 137),
                    Color = theme.outline,
                    ZIndex = 82
                }, colorpicker.holder.drawings)

                local grid = utility:CreateTransparencyPickerGrid(transp_box, colorpicker.holder.drawings, colorpicker.color)
                transp_gradient = grid[1]
            end

            local draggingSV = false
            local draggingHue = false
            local draggingTransp = false

            local function updateSV()
                local m = utility:MouseLocation()
                colorpicker.sat = math.clamp((m.X - sv_box.Position.X) / sv_box.Size.X, 0, 1)
                colorpicker.val = 1 - math.clamp((m.Y - sv_box.Position.Y) / sv_box.Size.Y, 0, 1)
                colorpicker.color = Color3.fromHSV(colorpicker.hue, colorpicker.sat, colorpicker.val)
                box_fill.Color = colorpicker.color
                if transp_gradient then transp_gradient.Color = colorpicker.color end
                pcall(callback, colorpicker.color, colorpicker.transparency)
            end

            local function updateHue()
                local m = utility:MouseLocation()
                colorpicker.hue = math.clamp((m.Y - hue_box.Position.Y) / hue_box.Size.Y, 0, 1)
                colorpicker.color = Color3.fromHSV(colorpicker.hue, colorpicker.sat, colorpicker.val)
                utility:UpdateColorPickerGrid(sv_cells, colorpicker.hue)
                box_fill.Color = colorpicker.color
                if transp_gradient then transp_gradient.Color = colorpicker.color end
                pcall(callback, colorpicker.color, colorpicker.transparency)
            end

            local function updateTransp()
                local m = utility:MouseLocation()
                -- Reversed so 0 transparency (solid) is left and 1 (invisible) is right
                local percent = math.clamp((m.X - transp_box.Position.X) / transp_box.Size.X, 0, 1)
                colorpicker.transparency = percent
                pcall(callback, colorpicker.color, colorpicker.transparency)
            end

            library.began[#library.began + 1] = function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and colorpicker.open then
                    if utility:MouseOverDrawing({sv_box.Position.X, sv_box.Position.Y, sv_box.Position.X + sv_box.Size.X, sv_box.Position.Y + sv_box.Size.Y}) then
                        draggingSV = true
                        updateSV()
                    elseif utility:MouseOverDrawing({hue_box.Position.X, hue_box.Position.Y, hue_box.Position.X + hue_box.Size.X, hue_box.Position.Y + hue_box.Size.Y}) then
                        draggingHue = true
                        updateHue()
                    elseif hasTransp and utility:MouseOverDrawing({transp_box.Position.X, transp_box.Position.Y, transp_box.Position.X + transp_box.Size.X, transp_box.Position.Y + transp_box.Size.Y}) then
                        draggingTransp = true
                        updateTransp()
                    end
                end
            end

            library.ended[#library.ended + 1

Error: Your previous response was cut off because it exceeded the output token limit
Please continue from where you left off, keeping your response shorter
Retries remaining: 3 (Error ID: 21e2155d-f371-4397-9101-3eaeba7efe77-32)

```lua
            library.ended[#library.ended + 1] = function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSV = false
                    draggingHue = false
                    draggingTransp = false
                end
            end

            library.changed[#library.changed + 1] = function()
                if not window.isVisible or not colorpicker.open then return end
                if draggingSV then updateSV()
                elseif draggingHue then updateHue()
                elseif draggingTransp then updateTransp() end
            end
        else
            window:CloseContent()
        end
    end

    section:RegisterTooltip(function()
        return section.page.active and utility:MouseOverDrawing({
            box_outline.Position.X, box_outline.Position.Y,
            box_outline.Position.X + 16, box_outline.Position.Y + 10
        })
    end, tooltip)

    library.began[#library.began + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and section.page.active then
            if utility:MouseOverDrawing({box_outline.Position.X, box_outline.Position.Y, box_outline.Position.X + 16, box_outline.Position.Y + 10}) then
                colorpicker:ToggleOpen()
            elseif colorpicker.open and not window:IsOverContent() then
                window:CloseContent()
            end
        end
    end

    library.pointers[flag] = colorpicker
    section.page:Update()
    return colorpicker
end

-- // Section Elements: Standalone Keybind (with Mouse1 / Mouse2 support)
function sections:Keybind(info)
    info = info or {}
    local name = info.Name or info.name or "Keybind"
    local flag = info.Flag or info.flag or name
    local default = info.Default or info.def
    local mode = info.Mode or info.mode or "Toggle"
    local callback = info.Callback or info.callback or function() end
    local tooltip = info.Tooltip or info.tooltip
    local section = self
    local window = section.window

    local keybind = {
        name = name,
        current = default,
        mode = mode,
        active = false,
        binding = false,
        bindTick = 0,
        drawings = {}
    }

    local yPos = section.size
    section.size = section.size + 18

    utility:Create("TextLabel", {Vector2.new(8, yPos), section.fill}, {
        Text = name,
        Size = 13,
        Font = 2,
        Color = theme.textcolor,
        Position = utility:Position(0, 8, 0, yPos, section.fill)
    }, section.drawings)

    local key_label = utility:Create("TextLabel", {Vector2.new(-8, yPos), section.fill}, {
        Text = "[" .. utility:InputToString(default) .. "]",
        Size = 13,
        Font = 2,
        Color = theme.textdark,
        Position = utility:Position(1, -30, 0, yPos, section.fill)
    }, section.drawings)

    function keybind:Set(newKey)
        if typeof(newKey) == "table" then
            keybind.current = newKey[1]
            keybind.mode = newKey[2] or keybind.mode
        else
            keybind.current = newKey
        end
        key_label.Text = "[" .. utility:InputToString(keybind.current) .. "]"
        library.pointers[flag] = keybind
    end

    function keybind:Get() return keybind.current end

    section:RegisterTooltip(function()
        return section.page.active and utility:MouseOverDrawing({
            key_label.Position.X - 5, key_label.Position.Y,
            key_label.Position.X + key_label.TextBounds.X + 5, key_label.Position.Y + 12
        })
    end, tooltip)

    library.began[#library.began + 1] = function(Input)
        if keybind.binding then
            -- Support Mouse1, Mouse2, Mouse3
            if Input.UserInputType == Enum.UserInputType.MouseButton1 
                or Input.UserInputType == Enum.UserInputType.MouseButton2 
                or Input.UserInputType == Enum.UserInputType.MouseButton3 then
                if tick() - keybind.bindTick > 0.15 then
                    keybind.current = Input.UserInputType
                    keybind.binding = false
                    key_label.Text = "[" .. utility:InputToString(keybind.current) .. "]"
                    pcall(callback, keybind.current, keybind.active)
                end
            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                if Input.KeyCode == Enum.KeyCode.Escape then
                    keybind.current = nil
                else
                    keybind.current = Input.KeyCode
                end
                keybind.binding = false
                key_label.Text = "[" .. utility:InputToString(keybind.current) .. "]"
                pcall(callback, keybind.current, keybind.active)
            end
            return
        end

        if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and section.page.active then
            if not window:IsOverContent() and utility:MouseOverDrawing({
                key_label.Position.X - 4, key_label.Position.Y,
                key_label.Position.X + key_label.TextBounds.X + 4, key_label.Position.Y + 12
            }) then
                keybind.binding = true
                keybind.bindTick = tick()
                key_label.Text = "[...]"
                return
            end
        end

        if utility:MatchesInput(Input, keybind.current) then
            if keybind.mode == "Toggle" then
                keybind.active = not keybind.active
                pcall(callback, keybind.active)
            elseif keybind.mode == "On Hold" or keybind.mode == "Hold" then
                keybind.active = true
                pcall(callback, true)
            elseif keybind.mode == "Always" then
                keybind.active = true
                pcall(callback, true)
            end
        end
    end

    library.ended[#library.ended + 1] = function(Input)
        if (keybind.mode == "On Hold" or keybind.mode == "Hold") and utility:MatchesInput(Input, keybind.current) then
            keybind.active = false
            pcall(callback, false)
        end
    end

    library.pointers[flag] = keybind
    section.page:Update()
    return keybind
end

-- // Section Elements: Button
function sections:Button(info)
    info = info or {}
    local name = info.Name or info.name or "Button"
    local callback = info.Callback or info.callback or function() end
    local tooltip = info.Tooltip or info.tooltip
    local section = self
    local window = section.window

    local yPos = section.size
    section.size = section.size + 24

    local bar_width = section.fill.Size.X - 16
    local btn_outline = utility:Create("Frame", {Vector2.new(8, yPos), section.fill}, {
        Size = Vector2.new(bar_width, 18),
        Color = theme.outline,
        Position = utility:Position(0, 8, 0, yPos, section.fill)
    }, section.drawings)

    local btn_inline = utility:Create("Frame", {Vector2.new(1, 1), btn_outline}, {
        Size = Vector2.new(bar_width - 2, 16),
        Color = theme.inline,
        Position = utility:Position(0, 1, 0, 1, btn_outline)
    }, section.drawings)

    local btn_fill = utility:Create("Frame", {Vector2.new(1, 1), btn_inline}, {
        Size = Vector2.new(bar_width - 4, 14),
        Color = theme.lightcontrast,
        Position = utility:Position(0, 1, 0, 1, btn_inline)
    }, section.drawings)

    local btn_text = utility:Create("TextLabel", {Vector2.new(bar_width / 2, 1), btn_fill}, {
        Text = name,
        Size = 12,
        Font = 2,
        Center = true,
        Color = theme.textcolor,
        Position = utility:Position(0.5, 0, 0, 1, btn_fill)
    }, section.drawings)

    section:RegisterTooltip(function()
        return section.page.active and utility:MouseOverDrawing({
            btn_outline.Position.X, btn_outline.Position.Y,
            btn_outline.Position.X + bar_width, btn_outline.Position.Y + 18
        })
    end, tooltip)

    library.began[#library.began + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and section.page.active then
            if not window:IsOverContent() and utility:MouseOverDrawing({
                btn_outline.Position.X, btn_outline.Position.Y,
                btn_outline.Position.X + bar_width, btn_outline.Position.Y + 18
            }) then
                btn_fill.Color = theme.darkcontrast
                pcall(callback)
            end
        end
    end

    library.ended[#library.ended + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            btn_fill.Color = theme.lightcontrast
        end
    end

    section.page:Update()
    return {
        SetText = function(_, t) btn_text.Text = t end
    }
end

-- // Section Elements: Textbox
function sections:Textbox(info)
    info = info or {}
    local name = info.Name or info.name or "Textbox"
    local flag = info.Flag or info.flag or name
    local default = info.Default or info.def or ""
    local placeholder = info.Placeholder or info.placeholder or "Type here..."
    local callback = info.Callback or info.callback or function() end
    local tooltip = info.Tooltip or info.tooltip
    local section = self
    local window = section.window

    local textbox = {
        value = default,
        focused = false,
        drawings = {}
    }

    local yPos = section.size
    section.size = section.size + 34

    utility:Create("TextLabel", {Vector2.new(8, yPos), section.fill}, {
        Text = name,
        Size = 13,
        Font = 2,
        Color = theme.textcolor,
        Position = utility:Position(0, 8, 0, yPos, section.fill)
    }, section.drawings)

    local bar_width = section.fill.Size.X - 16
    local box_outline = utility:Create("Frame", {Vector2.new(8, yPos + 14), section.fill}, {
        Size = Vector2.new(bar_width, 18),
        Color = theme.outline,
        Position = utility:Position(0, 8, 0, yPos + 14, section.fill)
    }, section.drawings)

    local box_inline = utility:Create("Frame", {Vector2.new(1, 1), box_outline}, {
        Size = Vector2.new(bar_width - 2, 16),
        Color = theme.inline,
        Position = utility:Position(0, 1, 0, 1, box_outline)
    }, section.drawings)

    local box_fill = utility:Create("Frame", {Vector2.new(1, 1), box_inline}, {
        Size = Vector2.new(bar_width - 4, 14),
        Color = theme.lightcontrast,
        Position = utility:Position(0, 1, 0, 1, box_inline)
    }, section.drawings)

    local val_label = utility:Create("TextLabel", {Vector2.new(4, 1), box_fill}, {
        Text = (default ~= "" and default) or placeholder,
        Size = 12,
        Font = 2,
        Color = (default ~= "") and theme.textcolor or theme.textdark,
        Position = utility:Position(0, 4, 0, 1, box_fill)
    }, section.drawings)

    function textbox:Set(val)
        textbox.value = tostring(val or "")
        val_label.Text = (textbox.value ~= "" and textbox.value) or placeholder
        val_label.Color = (textbox.value ~= "") and theme.textcolor or theme.textdark
        library.pointers[flag] = textbox
        pcall(callback, textbox.value)
    end

    function textbox:Get() return textbox.value end

    section:RegisterTooltip(function()
        return section.page.active and utility:MouseOverDrawing({
            box_outline.Position.X, box_outline.Position.Y - 14,
            box_outline.Position.X + bar_width, box_outline.Position.Y + 18
        })
    end, tooltip)

    library.began[#library.began + 1] = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and section.page.active then
            if not window:IsOverContent() and utility:MouseOverDrawing({
                box_outline.Position.X, box_outline.Position.Y,
                box_outline.Position.X + bar_width, box_outline.Position.Y + 18
            }) then
                textbox.focused = true
                box_fill.Color = theme.darkcontrast
            else
                if textbox.focused then
                    textbox.focused = false
                    box_fill.Color = theme.lightcontrast
                    textbox:Set(textbox.value)
                end
            end
        end

        if textbox.focused and Input.UserInputType == Enum.UserInputType.Keyboard then
            if Input.KeyCode == Enum.KeyCode.Return then
                textbox.focused = false
                box_fill.Color = theme.lightcontrast
                textbox:Set(textbox.value)
            elseif Input.KeyCode == Enum.KeyCode.Backspace then
                textbox.value = textbox.value:sub(1, #textbox.value - 1)
                val_label.Text = (textbox.value ~= "" and textbox.value) or placeholder
                val_label.Color = (textbox.value ~= "") and theme.textcolor or theme.textdark
            else
                local keyStr = utility:InputToString(Input.KeyCode)
                if #keyStr == 1 then
                    if uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.RightShift) then
                        keyStr = utility.Keyboard.Modifiers[keyStr] or keyStr:upper()
                    else
                        keyStr = keyStr:lower()
                    end
                    textbox.value = textbox.value .. keyStr
                    val_label.Text = textbox.value
                    val_label.Color = theme.textcolor
                elseif Input.KeyCode == Enum.KeyCode.Space then
                    textbox.value = textbox.value .. " "
                    val_label.Text = textbox.value
                    val_label.Color = theme.textcolor
                end
            end
        end
    end

    library.pointers[flag] = textbox
    section.page:Update()
    return textbox
end

-- // Section Elements: Label
function sections:Label(info)
    info = info or {}
    local text = info.Text or info.text or "Label"
    local tooltip = info.Tooltip or info.tooltip
    local section = self

    local yPos = section.size
    section.size = section.size + 16

    local label = utility:Create("TextLabel", {Vector2.new(8, yPos), section.fill}, {
        Text = text,
        Size = 13,
        Font = 2,
        Color = theme.textcolor,
        Position = utility:Position(0, 8, 0, yPos, section.fill)
    }, section.drawings)

    section:RegisterTooltip(function()
        return section.page.active and utility:MouseOverDrawing({
            label.Position.X, label.Position.Y,
            label.Position.X + label.TextBounds.X, label.Position.Y + 12
        })
    end, tooltip)

    section.page:Update()
    return {
        SetText = function(_, t) label.Text = t end
    }
end

-- // Return Library
return library, utility, library.pointers, theme
