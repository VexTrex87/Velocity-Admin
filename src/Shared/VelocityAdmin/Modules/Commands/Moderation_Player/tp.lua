local Cmd = {}
local Helper = require(game.ReplicatedStorage.VelocityAdmin.Modules.Helper)
local Chat = game:GetService("Chat")

----------------------------------------------------------------------

Cmd.Description = "Teleports player1 to player2"

Cmd.Arguments = {
    [1] = {
        ["Title"] = "player1",
        ["Description"] = "The player who will be teleported.",
        ["Choices"] = function()
            local Players = {}
            for _,p in pairs(game.Players:GetPlayers()) do
                table.insert(Players, p.Name)
            end
            return Players
        end
    },
    [2] = {
        ["Title"] = "player2",
        ["Description"] = "Where player1 will be teleported to.",
        ["Choices"] = function()
            local Players = {}
            for _,p in pairs(game.Players:GetPlayers()) do
                table.insert(Players, p.Name)
            end
            return Players
        end
    },
}

Cmd.Run = function(CurrentPlayer, player1, player2)

    -- Settings
    local TP_OFFSET = CFrame.new(0, 0, 5)

    -- Check if necessary arguments are there
    if not player1 then
        return false, "Player 1 Argument Missing"
    elseif not player2 then
        return false, "Player 2 Argument Missing"
    end

    -- Run Command       
        
        -- Gets player 2 instance
    player2 = Velocity.Helper.FindSinglePlayer(player2, CurrentPlayer)
    if not player2 then
        return false, player2 .. " does not exist."
    end

        -- Gets the player 2 character  
    local player2Char = player2.Character
    if not player2Char then
        return false, player2 .. "'s character does not exist"
    end
    local player2Root = player2Char:WaitForChild("HumanoidRootPart")

    local Players = Velocity.Helper.FindPlayer(player1, CurrentPlayer)
    if Players then
        local Info = {}
        for _,p in pairs(Players) do
            local pChar = p.Character
            if pChar then
                local pRoot = pChar:WaitForChild("HumanoidRootPart")
                pRoot.CFrame = player2Root.CFrame * TP_OFFSET
                table.insert(Info, {
                    Success = true,
                    Status = p.Name .. " was teleported to " .. player2.Name
                })
            else
                table.insert(Info, {
                    Success = false,
                    Status = p.Name .. "'s character does not exist"
                })
            end
        end         
        return Info     
    else
        return false, player1 .. " is not a valid player."
    end

end

----------------------------------------------------------------------

return Cmd