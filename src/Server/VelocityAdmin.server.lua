-- // Variables \\ --

local DataStoreService = game:GetService("DataStoreService")
local Settings = require(game.ReplicatedStorage.VelocityAdmin.Modules.Settings)
local Helper = require(game.ReplicatedStorage.VelocityAdmin.Modules.Helper)
local Commands = game.ReplicatedStorage.VelocityAdmin.Modules.Commands
local Remotes = game.ReplicatedStorage.VelocityAdmin.Remotes

-- // Events \\ --

game.Players.PlayerAdded:Connect(function(p)
    Helper.Data[p.Name] = {}

    -- Checks if slocked
    local Reason = Helper.Data.ServerLocked
    if Reason then
        p:Kick("Server is locked: " .. Reason)
    end

    -- Checks if tempbanned
    local BanInfo = Helper.Data.TempBanned[p.UserId]
    if BanInfo then      
        print(os.time() - BanInfo.StartTime .. " seconds has passed sinced banned. " .. p.Name .. " was banned for " .. BanInfo.PublishedLength .. " (" .. BanInfo.RealLength .. ")")
        if os.time() - BanInfo.StartTime < BanInfo.RealLength then
            p:Kick("TEMP BANNED (duration: " .. BanInfo.PublishedLength .. "): " .. BanInfo.Reason)
        else
            Helper.Data.TempBanned[p.UserId] = nil
            print(p.Name .. "'s ban was lifted")
        end
    end

    -- Checks if pBanned
    local BanStore = DataStoreService:GetDataStore(Settings.Basic.BanScope)
    pcall(function()
        local Data = BanStore:GetAsync(p.UserId)
        if Data then
            p:Kick("BANNED: " .. Data)
        end
    end)

end)

game.Players.PlayerRemoving:Connect(function(p)
    Helper.Data[p.Name] = nil
end)

Remotes.FireCommand.OnServerInvoke = function(p, Data)
    for _,Heading in pairs(Commands:GetChildren()) do
        for __,Command in pairs(Heading:GetChildren()) do
            if Command.Name == Data.Command then
                return require(Command).Run(p, table.unpack(Data.Arguments))
            end
        end
    end
end