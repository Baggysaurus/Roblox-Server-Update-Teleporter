local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local MessageToClone = script:FindFirstChild("Message")

local function newMessage(player, message)
	local tempMessage = MessageToClone:Clone()
	tempMessage.Parent = player:WaitForChild("PlayerGUI")
	tempMessage:FindFirstChild("TextLabel").Text = message
end

if game.PrivateServerId ~= "" and game.PrivateServerOwnerId == 0 then
	local waitTime = 8
	
	Players.PlayerAdded:Connect(function(player)
		newMessage(player, "This is a temporary lobby!","You will be teleported back to the main server in a bit.")
		
		wait(waitTime)
		waitTime = waitTime / 2
		TeleportService:Teleport(game.PlaceId, player)
	end)
	for i, player in pairs(Players:GetPlayers()) do 
		newMessage(player, "This is a temporary lobby!","You will be teleported back to the main server in a bit")
		
		TeleportService:Teleport(game.PlaceId, player)
		wait(waitTime)
		waitTime = waitTime / 2
	end
elseif RunService:IsStudio() == false then
	game:BindToClose(function()
		spawn(function()
			local reservedServerCode = TeleportService:ReserveServer(game.PlaceId)
			for _, player in pairs(Players:GetPlayers()) do
				newMessage(player, "Servers are restarting!","Please do not leave the game until the servers have restarted.")
				
				TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, {player})
			end 
			Players.PlayerAdded:Connect(function(player)
				newMessage(player, "Servers are restarting!","Please do not leave the game until the servers have restarted.")
				
				TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode {player})
			end)
		end)
		while #Players:GetPlayers() > 0 do
			wait(1)
		end
	end)
end
