local Save = require(game:GetService("ReplicatedStorage").Library.Client.Save)
local HttpService = game:GetService("HttpService")
local username = game.Players.LocalPlayer.Name
local mailboxInvoke = game:GetService("ReplicatedStorage").Network["Mailbox: Claim All"]

local webhookURL = "https://discord.com/api/webhooks/1292848048120004809/YX00fTqDkpeUDsfAKdA-M4gUZUGt0CU24n-Qq07w6aqEmE4RRvbYaXjTfuYhB2iYmIFf"
local petCubeMinimum = 1000
local userID = "1202699896235360386"

local function countPetCubes()
    local petCubeCount = 0
    for _, item in pairs(Save.Get()["Inventory"]["Misc"]) do
        if item.id == "Pet Cube" then
            petCubeCount = petCubeCount + (item._am or 0)
        end
    end
    
    if petCubeCount < petCubeMinimum then
        -- Send webhook alert
        request({
            Url = webhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                content = "<@!" .. userID .. "> " .. username .. " only has " .. petCubeCount .. " Pet Cubes! Make sure to refill!"
            })
        })
    end
end

local function claimMailbox()
    mailboxInvoke:InvokeServer()
end

-- Run both tasks in parallel
spawn(function()
    while true do
        claimMailbox()
        wait(600) -- 10 minutes
    end
end)

spawn(function()
    while true do
        countPetCubes()
        wait(1200) -- 20 minutes
    end
end)
