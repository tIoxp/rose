Utility = {
    Connections = {},
    DrawingObjects = {}
}

local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
  Camera = workspace.CurrentCamera
end)

local Stats = cloneref(game:GetService('Stats'))

do
    do -- math
        Utility.Math = {}

        function Utility.Math:Round(Number)
            return math.floor(Number + 0.5)
        end

        function Utility.Math:Lerp(Start, End, Alpha)
            return Start + (End - Start) * Alpha
        end

        function Utility.Math:Clamp(Value, Min, Max)
            return math.max(math.min(Value, Max), Min)
        end
    end


    function Utility:Draw(Class, Properties)
        local DrawingObject = Drawing.new(Class)
        
        for Propety, Value in Properties do
            DrawingObject[Propety] = Value
        end

        self.DrawingObjects[#self.DrawingObjects + 1] = DrawingObject

        return DrawingObject
    end

    function Utility:Connect(Connection, Callback)
        local ConnectionObject = Connection:Connect(Callback)

        self.Connections[#self.Connections + 1] = Connection

        return ConnectionObject
    end     

    function Utility:DeepCopy(Original, Seen)
        Seen = Seen or {}
        if Seen[Original] then
            return Seen[Original]
        end

        local Copy = {}
        Seen[Original] = Copy

        for Key, Value in Original do
            if type(Value) == 'table' then
                Value = self:DeepCopy(Value, Seen)
            end
            Copy[Key] = Value
        end

        setmetatable(Copy, getmetatable(Original))

        return Copy
    end

    function Utility:WorldToScreen(WorldPosition)
        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(WorldPosition)
        return Vector2.new(ScreenPosition.X, ScreenPosition.Y), OnScreen, ScreenPosition.Z
    end

    function Utility:FindUpvalue(Function, UpvalueName)
        assert(typeof(Function) == 'function', 'Not a function')

        local Upvalues = getupvalues(Function)
        assert(#Upvalues > 0, 'Function has no upvalues')
        
        for Index, Upvalue in Upvalues do
            if typeof(Upvalue) == 'function' then
                local Name = debug.getinfo(Upvalue).name

                if Name == UpvalueName then
                    return Upvalue
                end
            end
        end
        
        return nil
    end

    function Utility:FindProto(Function, ProtoName)
        assert(typeof(Function) == 'function', 'Not a function')

        local Protos = getprotos(Function)
        assert(#Protos > 0, 'Function has no protos')
    
        for Index, Proto in Protos do
            local Name = debug.getinfo(Proto).name
            if Name == ProtoName then
                return getproto(Function, Index, true)
            end
        end
        
        return nil
    end

    function Utility:GetPerformanceStats()
        local StatsTable = {
            FPS = self.Math:Round(1 / Stats.FrameTime),
            MemoryUsage = Stats:GetTotalMemoryUsageMb(),
            Ping = string.format('%.2f', Stats.Network.ServerStatsItem['Data Ping']:GetValue())
        }

        return StatsTable
    end
end

getgenv().Utility = Utility
return Utility
