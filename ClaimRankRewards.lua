local save = require(game:GetService("ReplicatedStorage").Library.Client.Save).Get
local network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local ranks = require(game:GetService("ReplicatedStorage").Library.Directory.Ranks)

while task.wait(15) do
    local totalStars = 0
    for i,v in ranks do
        if v["RankNumber"] == save()["Rank"] then
            for i2, v2 in v["Rewards"] do
                totalStars += v2["StarsRequired"]
                if save()["RankStars"] >= totalStars and not save()["RedeemedRankRewards"][tostring(i2)] then
                    network.Fire("Ranks_ClaimReward", i2)
                    task.wait(.5)
                end
            end
        end
    end
end
