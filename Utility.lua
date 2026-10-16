Utility = {
    Hooks = { },
    Instances = { },
    Connections = { },
}

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

    function Utility:GetService(Name)
        return cloneref(game:GetService(Name))
    end

    function Utility:New(Class, Properties)
        local InstanceObject = Instance.new(Class)

        for Propety, Value in Properties do
            InstanceObject[Propety] = Value
        end

        self.Instances[#self.Instances + 1] = InstanceObject

        return InstanceObject
    end

    function Utility:Connect(Connection, Callback)
        local ConnectionObject = Connection:Connect(Callback)

        self.Connections[#self.Connections + 1] = ConnectionObject

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
        local ScreenPosition, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(WorldPosition)
        return Vector2.new(ScreenPosition.X, ScreenPosition.Y), OnScreen, ScreenPosition.Z
    end

    function Utility:Hook(Function, NewFunction)
        assert(typeof(Function) == 'function', 'Not a function')
        assert(typeof(NewFunction) == 'function', 'Not a function')
    
        if iscclosure(Function) then
            NewFunction = newcclosure(NewFunction)
        end
    
        local Original = hookfunction(Function, NewFunction)
        self.Hooks[#self.Hooks + 1] = Function
    
        return Original
    end

    function Utility:FindUpvalue(Function, NameOrIndex)
        assert(typeof(Function) == 'function', 'Not a function')

        local Upvalues = getupvalues(Function)
        assert(#Upvalues > 0, 'Function has no upvalues')

        if type(NameOrIndex) == 'number' then
            return Upvalues[NameOrIndex]
        end

        for Index, Upvalue in Upvalues do
            if typeof(Upvalue) == 'function' then
                local Name = debug.getinfo(Upvalue).name

                if Name == NameOrIndex then
                    return Upvalue
                end
            end
        end

        return nil
    end

    function Utility:FindProto(Function, NameOrIndex)
        assert(typeof(Function) == 'function', 'Not a function')

        local Protos = getprotos(Function)
        assert(#Protos > 0, 'Function has no protos')

        if type(NameOrIndex) == 'number' then
            if not Protos[NameOrIndex] then
                return nil
            end

            return getproto(Function, NameOrIndex, true)
        end

        for Index, Proto in Protos do
            local Name = debug.getinfo(Proto).name

            if Name == NameOrIndex then
                return getproto(Function, Index, true)
            end
        end

        return nil
    end

    local Stats = Utility:GetService('Stats')
    function Utility:GetPerformanceStats()
        local StatsTable = {
            FPS = self.Math:Round(1 / Stats.FrameTime),
            MemoryUsage = Stats:GetTotalMemoryUsageMb(),
            Ping = string.format('%.2f', Stats.Network.ServerStatsItem['Data Ping']:GetValue())
        }

        return StatsTable
    end


    function Utility:CleanUp()
        for _, Connection in self.Connections do
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end

        for _, InstanceObject in self.Instances do
            if InstanceObject then
                InstanceObject:Destroy()
            end
        end

        for _, Function in self.Hooks do
            restorefunction(Function)
        end
        
        table.clear(self.Hooks)                                      
        table.clear(self.Connections)
        table.clear(self.Instances)
    end
end

return Utility
