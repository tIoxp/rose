Utility = {
    Instances = { },
    Connections = { },
    Hooks = { },
}

do
    do -- math
        Utility.Math = { }

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

    do
        function Utility:GetService(Name)
            return cloneref(game:GetService(Name))
        end

        function Utility:New(Class, Properties)
            local InstanceObject = Instance.new(Class)

            for Property, Value in Properties do
                InstanceObject[Property] = Value
            end

            self.Instances[#self.Instances + 1] = InstanceObject

            return InstanceObject
        end

        function Utility:Connect(Connection, Callback)
            local ConnectionObject = Connection:Connect(Callback)

            self.Connections[#self.Connections + 1] = ConnectionObject

            return ConnectionObject
        end
    end

    do
        function Utility:WorldToScreen(WorldPosition)
            local ScreenPosition, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(WorldPosition)

            return Vector2.new(ScreenPosition.X, ScreenPosition.Y), OnScreen, ScreenPosition.Z
        end

        function Utility:GetDistance(Point1, Point2)
            return (Point2 - Point1).Magnitude
        end

        function Utility:GetDistanceSquared(Point1, Point2)
            local Difference = Point2 - Point1

            return Difference:Dot(Difference)
        end

        function Utility:IsWithin(Point1, Point2, Range)
            return self:GetDistanceSquared(Point1, Point2) <= Range * Range
        end
    end

    do
        function Utility:Hook(Name, Function, Callback)
            assert(typeof(Function) == 'function', 'Not a function')
            assert(typeof(Callback) == 'function', 'Not a function')
            assert(not self.Hooks[Name], `Hook {Name} already exists`)

            local Original

            local function Wrapper(...)
                return Callback(Original, ...)
            end

            if iscclosure(Function) then
                Wrapper = newcclosure(Wrapper)
            end

            Original = hookfunction(Function, Wrapper)

            self.Hooks[Name] = {
                Target = Function,
                Original = Original
            }

            return Original
        end

        function Utility:Unhook(Name)
            local Hook = self.Hooks[Name]
            if not Hook then return end

            if Hook.Target then
                restorefunction(Hook.Target)
            end

            self.Hooks[Name] = nil
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
    end

    do
        function Utility:DeepCopy(Original, Seen)
            Seen = Seen or { }

            if Seen[Original] then
                return Seen[Original]
            end

            local Copy = { }
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

        function Utility:Spawn(Callback, ...)
            return task.spawn(Callback, ...)
        end
    end

    do
        local Stats = Utility:GetService('Stats')

        function Utility:GetPerformanceStats()
            local StatsTable = {
                FPS = self.Math:Round(1 / Stats.FrameTime),
                MemoryUsage = Stats:GetTotalMemoryUsageMb(),
                Ping = string.format('%.2f', Stats.Network.ServerStatsItem['Data Ping']:GetValue())
            }

            return StatsTable
        end
    end

    do
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

            for Name in self.Hooks do
                self:Unhook(Name)
            end

            table.clear(self.Connections)
            table.clear(self.Instances)
        end
    end
end

return Utility
