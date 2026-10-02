-- ui/tabs.lua
local C = {}
C.__index = C

function C.new(content)
    local self = setmetatable({}, C)
    self.content = content
    self.tabs = {}
    self.active = nil

    function self:register(name, sectionList)
        self.tabs[name] = sectionList or {}
    end

    function self:show(name)
        for _, obj in ipairs(self.content:GetChildren()) do
            if obj:IsA("Frame") then obj.Visible = false end
        end
        local list = self.tabs[name]
        if list then
            for _, obj in ipairs(list) do obj.Visible = true end
        end
        self.active = name
    end

    return self
end

return C
