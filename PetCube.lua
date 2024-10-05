local Save = require(game:GetService("ReplicatedStorage").Library.Client.Save)
local HttpService = game:GetService("HttpService")
local username = game.Players.LocalPlayer.Name

local function countPetCubes()
    local petCubeCount = 0
    for _, item in pairs(Save.Get()["Inventory"]["Misc"]) do
        if item.id == "Pet Cube" then petCubeCount = petCubeCount + (item._am or 0) end
    end
    
    if petCubeCount < Config["PetCubeMinimum"] then
        return request({
            Url = Config["WebhookURL"],
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({content = "<@!" .. Config["UserID"] .. "> " .. username .. " only has " .. petCubeCount .. " Pet Cubes! Make sure to refill!"})
        })
    end
end

while true do
    countPetCubes()
    wait(Config["CheckTime"])
end
