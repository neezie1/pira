local plrs = cloneref(game:GetService("Players"))
local rs = cloneref(game:GetService("ReplicatedStorage"))
local plr = plrs.LocalPlayer

local save = require(rs.Library.Client.Save)

local wantedItems = {
    ["Bucket O' Paint"] = 1,
}

function getCoolItemsCounts()
    local itemsTable = {}
    for _,v in save.Get().Inventory.Misc do
        if wantedItems[v.id] then
            itemsTable[v.id] = v._am
        end
    end
    return itemsTable
end

function craftGraffitis(count)
    local args = {
        [1] = "Color",
        [2] = count
    }

    rs.Network.ColorCrafting_Craft:InvokeServer(unpack(args))
end

while task.wait(getgenv().Config.CraftEvery) do
    local coolItemsCounts = getCoolItemsCounts()
    
    for item, count in pairs(coolItemsCounts) do
        local craftableCount = math.floor(count / wantedItems[item])
        
        if craftableCount > 0 then
            craftGraffitis(craftableCount)
        end
    end
end
