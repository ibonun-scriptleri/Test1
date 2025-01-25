local main = {}
main.__index=main

local mainmodel = script:WaitForChild("main")
local AA = require(script:WaitForChild("AA"))

local function allservice()
	local self = main
	if self and not self.benimkiler then	
		self.benimkiler = {}
		self.benimkiler.Workspace = game:GetService("Workspace")
		self.benimkiler.ReplicatedStorage = game:GetService("ReplicatedStorage")
		self.benimkiler.ReplicatedFirst = game:GetService("ReplicatedFirst")
		self.benimkiler.StarterGui = game:GetService("StarterGui")
		self.benimkiler.StarterPlayer = game:GetService("StarterPlayer")
		self.benimkiler.StarterCharacterScripts = game:GetService("StarterPlayer").StarterCharacterScripts
		self.benimkiler.ServerScriptService = game:GetService("ServerScriptService")
		self.benimkiler.StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts
		self.benimkiler.Players = game:GetService("Players")
		self.benimkiler.ServerStorage = game:GetService("ServerStorage")
		self.benimkiler.Lighting = game:GetService("Lighting")
		self.benimkiler.StarterPack = game:GetService("StarterPack")
		self.benimkiler.Chat = game:GetService("Chat")
	else
		return self.benimkiler
	end
end

local function getit(s)
	local self = main
	local servis  = s.Name
	local Services
	if self.benimkiler == nil then
		Services = allservice()
	end
	if self.benimkiler then
		for i,v in pairs(self.benimkiler) do
			if string.sub(tostring(i):lower(), 1, #servis) == servis:lower() then
				return v;
			end
		end
		return nil
	end
end

local function neblmaq(dosya)
	local self = main
	assert(typeof(dosya)=="Instance", "err")
	local service = getit(dosya)
	if service then
		for i, v in next, dosya:GetChildren() do
			v:Clone().Parent = service
		end
	else
		warn("no")
	end
end

function main.sarp(key)
	local self = main
	local meta = {}
	meta.created = true
	meta.key = key
	return setmetatable(meta, self)
end

function main:edition()
	assert(self.key==("nebakunla"), "False String")
	wait("skipped")
	if self and self.key then
		for i, v in next, mainmodel:GetChildren() do
			task.spawn(neblmaq, v)
		end 
		for i, plr in next, game:GetService("Players"):GetPlayers() do
			plr:LoadCharacter()
		end
	end
end

return main
