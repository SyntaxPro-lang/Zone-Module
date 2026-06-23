--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Framework = ReplicatedStorage.Framework

--// Variables
local Modules = Framework.Client.Modules
local Shared = Framework.Shared
local Utils = Framework.Utils

--// Modules
local JanitorUtil = require(Utils.Janitor)
local Signal = require(Utils.Signal)

--// Main
local Zone = {}

Zone.__index = Zone
local players = {}

function Zone.new(Zone: Part)
	local self = setmetatable({}, Zone)
	self.Janitor = JanitorUtil.new()
	self.Zone = Zone
	self.PlayerAdded = Signal.new()
	self.PlayerRemoved = Signal.new()
	
	local transparency = RunService:IsStudio() and 0.5 or 1 -- set to invisible if not studio
	
	-- automatically set properties
	Zone.CanCollide = false
	Zone.Anchored = true
	Zone.Transparency = transparency
	
	self.playersInside = {}
	
	self.Janitor:Add(RunService.RenderStepped:Connect(function()
		for _, player in players do
			local character = player.Character or player.CharacterAdded:Wait()
			if not character then continue end
			if not character.PrimaryPart then continue end
			local distance = (character.PrimaryPart.Position - Zone.Position).Magnitude / (Zone.Size.Magnitude) + 0.5 -- small offset
			
			if distance <= 1 then
				if self.playersInside[player] then continue end
				
				self.playersInside[player] = true
				self.PlayerAdded:Fire(player)
			else
				if self.playersInside[player] == nil then continue end
				self.playersInside[player] = nil
				self.PlayerRemoved:Fire(player)
			end
		end
	end))
	self.Janitor:Add(Players.PlayerRemoving:Connect(function(removedPlayer)
		if self.playersInside[removedPlayer] then
			self.playersInside[removedPlayer] = nil
			self.PlayerRemoved:Fire(removedPlayer)
		end
	end))
	return self
end

function Zone:GetPlayersInZone()
	return self.playersInside
end

function Zone:IsPlayerInZone(player)
	return self.playersInside[player] ~= nil
end

function Zone:Destroy()
	self.Janitor:Destroy()
	self.PlayerAdded:Destroy()
	self.PlayerRemoved:Destroy()
	--self = nil
end

for i, v in Players:GetPlayers() do
	players[v] = v
end

Players.PlayerAdded:Connect(function(newPlayer)
	players[newPlayer] = newPlayer
	newPlayer.CharacterAdded:Connect(function(newChar)
		if players[newPlayer] then
			players[newPlayer].Character = newChar
		end
	end)
end)

Players.PlayerRemoving:Connect(function(removedPlayer)
	players[removedPlayer] = nil
end)

return Zone
