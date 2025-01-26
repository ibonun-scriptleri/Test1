local rs = game:GetService("ReplicatedStorage")
local pps = game:GetService("ProximityPromptService")
local ts = game:GetService("TweenService")
local NewChanger = require(rs:WaitForChild("NewChanger"))

local Remotes = rs:WaitForChild("Remotes")
local Emote = Remotes:WaitForChild("Emote")
local PlaySound = Remotes:WaitForChild("PlaySound")
local ToggleParticles = Remotes:WaitForChild("ToggleParticles")
local Flash = Remotes:WaitForChild("Flash")

local statsGui = rs:WaitForChild("stats")

local res = rs:WaitForChild("RemoteEvents")
local awakenEvent = res:WaitForChild("awakenEvent")

local ownerId = game.CreatorIdlocal rs = game:GetService("ReplicatedStorage")
local pps = game:GetService("ProximityPromptService")
local ts = game:GetService("TweenService")
local NewChanger = require(rs:WaitForChild("NewChanger"))

local Remotes = rs:WaitForChild("Remotes")
local Emote = Remotes:WaitForChild("Emote")
local PlaySound = Remotes:WaitForChild("PlaySound")
local ToggleParticles = Remotes:WaitForChild("ToggleParticles")
local Flash = Remotes:WaitForChild("Flash")

local statsGui = rs:WaitForChild("stats")

local res = rs:WaitForChild("RemoteEvents")
local awakenEvent = res:WaitForChild("awakenEvent")

local ownerId = game.CreatorId
print(ownerId)

local RagdollModule = require(rs:WaitForChild("Manager"))
local CombatFunctions = require(rs:WaitForChild("CombatFunctions"))
local RagdollRemote = Remotes:WaitForChild("Ragdoll")
local OnDeath = Remotes:WaitForChild("OnDeath")
local TestAnimation = Remotes:WaitForChild("TestAnimation")
local GetUp = Remotes:WaitForChild("GetUp")
local WallBounce = Remotes:WaitForChild("WallBounce")
local ChangeAttacking = Remotes:WaitForChild("ChangeAttacking")

local animator = require(rs:WaitForChild("AnimationManager"))
local NewChanger = require(rs:WaitForChild("NewChanger"))

local Values = rs:WaitForChild("Values")
local mostKills = Values:WaitForChild("mostKills")
local mostNuts = Values:WaitForChild("mostNuts")


local shutdown = false

if game.PrivateServerId ~=  "" and game.PrivateServerOwnerId ~= 0 then
	print('private server')
else
	--shutdown = true
end

if shutdown then
	for _, plr in ipairs(game.Players:GetPlayers()) do
		plr:Kick()
	end
end

OnDeath.OnServerEvent:Connect(function(Plr,Char)
	local Hum : Humanoid = Char:FindFirstChild("Humanoid")
	print(Hum.Health)
	if Hum.Health <= 0 then return end
	if Plr.Character ~= Char then return end
	Hum.Health = 0
end)
-- INSTANCES

local flash = script:WaitForChild("FlashSFX")

game.Players.PlayerAdded:Connect(function(player)
	if shutdown then
		player:Kick()
	else
		player:SetAttribute("spawnedIn", false)
	end
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local kills = Instance.new("IntValue")
	kills.Name = "Kills"
	kills.Value = 0
	kills.Parent = leaderstats
	
	local killstreak = Instance.new("IntValue")
	killstreak.Name = "Killstreak"
	killstreak.Value = 0
	killstreak.Parent = leaderstats

	local nuts = Instance.new("IntValue")
	nuts.Name = "Nuts"
	nuts.Value = 0
	nuts.Parent = leaderstats
	
	
	player.CharacterAdded:Connect(function(char)
		
		if player.leaderstats:FindFirstChild("Killstreak") then
			player.leaderstats.Killstreak.Value = 0
		end
		
		wait(1)
		
		local hum = char:WaitForChild("Humanoid")
		local root = char:WaitForChild("HumanoidRootPart")
		
		local con
		con = player.leaderstats.Killstreak:GetPropertyChangedSignal("Value"):Connect(function()
			if player.leaderstats.Killstreak.Value == 5 then
				CombatFunctions:awaken(char)
				awakenEvent:FireAllClients(player.DisplayName)
			end
		end)
		--player.AccountAge <= 3 and player.UserId ~= ownerId then
		--player:Kick("Your account age must be at least 3 days old!")
		--end
		--local clothingIndicator = rs.Prompts.clothPrompt:Clone()
		--clothingIndicator.Parent = char:WaitForChild("Torso")
		
		--local executeIndicator = rs.Prompts.executePrompt:Clone()
		--executeIndicator.Parent = char:WaitForChild("Torso")
		--local funIndicator = rs.Prompts.funPrompt:Clone()
		--funIndicator.Parent = char:WaitForChild("Torso")
		--local stopPrompt = rs.Prompts:WaitForChild("stopPrompt"):Clone()
		--stopPrompt.Parent = char:WaitForChild("Torso")
		
		for _,v in rs.Prompts:GetChildren() do
			local p = v:Clone()
			p.Parent = char:WaitForChild("Torso")
		end
		
		
		for i,v in pairs(game.Workspace:WaitForChild(player.Name):GetChildren()) do
			if v:IsA("CharacterMesh") then
				v:Destroy()
			end
		end
		
		char.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		
		local newStatsGui = statsGui:Clone()
		newStatsGui.Frame.TextLabel.Text = player.DisplayName
		newStatsGui.Parent = char.Head
		newStatsGui.Adornee = char.Head
		
		char:SetAttribute("downed", false) 
		char:SetAttribute("iframes", false)
		char:SetAttribute("doing", false)
		char:SetAttribute("funMeter", 0)
		char:SetAttribute("carrying", false)
		char:SetAttribute("canGetUp", true)
		char:SetAttribute("ragdolled", false)
		char:SetAttribute("wallBounce", false)
		char:SetAttribute("attacking", false)
		char:SetAttribute("awakened", false)
		for i,v in pairs(game.Workspace:GetChildren()) do
			if v:FindFirstChild("IsMap") then
				local spawns = v:FindFirstChild("Spawns"):GetChildren()
					if game.Players:GetPlayerFromCharacter(char):GetAttribute("spawnedIn") == false then
					local hrp = char:WaitForChild("HumanoidRootPart")
					local randSpawn = spawns[math.random(1, #spawns)]
					hrp.CFrame = randSpawn.CFrame * CFrame.new(math.random(-3,3),3,math.random(-3,3))
					game.Players:GetPlayerFromCharacter(char):SetAttribute("spawnedIn", true)
				end
			end
		end
		--clothingIndicator.Triggered:Connect(function(sender)
		--	NewChanger.undress(player, sender)
		--end)

		char.Head.Size = Vector3.new(1, 1, 1)
		hum.BreakJointsOnDeath = false -- should we put that on,
		hum.RequiresNeck = false

		local Attach = Instance.new("Attachment", root)
		Attach.Name = "ForceAttachment"
		hum.Died:Connect(function()
			if con then
				con:Disconnect()
			end
			RagdollModule.Ragdoll(char)
			root:SetNetworkOwner(player)
			Remotes:WaitForChild("RagdollForce"):FireClient(player)
		end)

			
		hum.Died:Connect(function()
			print("Player died!")
			
		end)
		
		hum.HealthChanged:Connect(function(h)
			local ti = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local t = ts:Create(hum.Parent.Head:FindFirstChild("stats").Frame.health.Frame, ti, {Size = UDim2.new(h / hum.MaxHealth, 0, 1, 0)})
			t:Play()
		end)
		
		char:GetAttributeChangedSignal("funMeter"):Connect(function()
			local newMeter = char:GetAttribute("funMeter")
			local ti = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local t = ts:Create(hum.Parent.Head:FindFirstChild("stats").Frame.fun.Frame, ti, {Size = UDim2.new(newMeter, 0, 1, 0)})
			t:Play()
		end)
		
		task.spawn(function()
			local NORMAL_REGEN_RATE = 1/40
			local AWAKEN_REGEN_RATE = 1/25
			while hum do
				wait(1)
				if char:GetAttribute("awakened") then
					hum.Health += hum.MaxHealth * AWAKEN_REGEN_RATE
				else
					hum.Health += hum.MaxHealth * NORMAL_REGEN_RATE
				end
			end
		end)
		
	end)
end)

PlaySound.OnServerEvent:Connect(function(_, sound, start, duration, speed)
	if start then
		sound.TimePosition = start
	end
	if speed then
		sound.PlaybackSpeed = speed
	end
	sound:Play()
	if duration then
		wait(duration)
		if sound.IsPlaying then
			sound:Stop()
		end
	end
end)

ToggleParticles.OnServerEvent:Connect(function(_, particles, t, d)
	if type(particles) == "table" then
		for _,p in particles do
			p.Enabled = t
		end
		if d then
			wait(d)
		end
		for _,p in particles do
			p.Enabled = false
		end
	else
		particles.Enabled = t
		if d then
			wait(d)
			particles.Enabled = false
		end
	end
end)

Flash.OnServerEvent:Connect(function(plr, fill, outline, duration)
	
	if not plr.Character then return end
	if plr.Character.Humanoid.Health <= 0 then return end
	
	local root = plr.Character.HumanoidRootPart
	
	local h = Instance.new("Highlight")
	h.FillColor = fill
	h.FillTransparency = 0.2
	h.OutlineColor = outline
	h.Parent = plr.Character
	
	local c = flash:Clone()
	c.Parent = root
	c:Play()
	game.Debris:AddItem(c, c.TimeLength)
	
	local ti = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local t = ts:Create(h, ti, {FillTransparency = 1})
	local t2 = ts:Create(h, ti, {OutlineTransparency = 1})
	
	game.Debris:AddItem(h, duration)
	t:Play()
	t2:Play()
end)

pps.PromptTriggered:Connect(function(prompt, player)
	local victim = prompt.Parent.Parent
	local attacker = player.Character
	
	if attacker:GetAttribute("downed") then return end
	
	if prompt.Name == "executePrompt" then
		CombatFunctions:grip(attacker, victim, "Default")
	elseif prompt.Name:find("Fun") then
		CombatFunctions:fun(attacker, victim, string.sub(prompt.Name, 1, string.len(prompt.Name) - 3))
	elseif prompt.Name == "carryPrompt" then
		CombatFunctions:carry(attacker, victim)
	end
end)

TestAnimation.OnServerEvent:Connect(function(plr)
	RagdollModule.Ragdoll(plr.Character)
	wait(5)
	RagdollModule.UnRagdoll(plr.Character)
	--NewChanger:loadMorph(plr.Character, "pp")
	--wait(2)
	--animator.PlayAnimation(rs.Animations.male:WaitForChild("fun"), plr.Character)
end)

GetUp.OnServerEvent:Connect(function(plr)
	local char = plr.Character
	
	--warn(plr.Name.." has got up!")
	
	char:SetAttribute("downed", false)
	CombatFunctions:flash(char, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0), 1)
	CombatFunctions:playSound(script:WaitForChild("FlashSFX"), char.HumanoidRootPart)
	
	animator.StopAnimationOnHumanoid(char.Humanoid)
	
	for _,v in char.Torso:GetChildren() do
		if v:IsA("ProximityPrompt") then
			print("prox: "..v.Name)
			v.Enabled = false
		end
	end
	
	RagdollModule.UnRagdoll(char)
end)

local function calculateClosestPartSide(target, dest)
	local targetPos = target.Position
	local destPos = dest.Position
	local destSize = dest.Size
	
	local positions = {
		Vector3.new(destPos.X + (destSize.X / 2), destPos.Y, destPos.Z),
		Vector3.new(destPos.X - (destSize.X / 2), destPos.Y, destPos.Z),
		Vector3.new(destPos.X, destPos.Y + (destSize.Y / 2), destPos.Z),
		Vector3.new(destPos.X, destPos.Y - (destSize.Y / 2), destPos.Z),
		Vector3.new(destPos.X, destPos.Y, destPos.Z + (destSize.Z / 2)),
		Vector3.new(destPos.X, destPos.Y, destPos.Z - (destSize.Z / 2))
	}
	
	local closestPos = positions[1]
	local smallestMagnitude = math.abs((positions[1] - targetPos).Magnitude)
	
	for _,pos in positions do
		local currentMagnitude = math.abs((pos - targetPos).Magnitude)
		if (currentMagnitude < smallestMagnitude) then
			closestPos = pos
			smallestMagnitude = currentMagnitude
		end
	end
	
	if closestPos == nil then
		warn("nil position")
	end
	
	--local partRef = Instance.new("Part")
	--partRef.Anchored = true
	--partRef.CanCollide = false
	--partRef.Parent = game.Workspace
	--partRef.Name = "A"
	--partRef.Position = closestPos
	
	return {closestPos, smallestMagnitude}
end

WallBounce.OnServerEvent:Connect(function(plr, part, finalCFrame)
	warn("hello from server")
	local char = plr.Character
	if char.Humanoid.Health > 0 and not char:GetAttribute("downed") and char:GetAttribute("ragdolled") and not char:GetAttribute("wallBounce") then
		
		RagdollModule.UnRagdoll(char)
		char:SetAttribute("ragdolled", false)
		char:SetAttribute("wallBounce", true)
		
		char.HumanoidRootPart.CFrame = finalCFrame
		char.HumanoidRootPart.Anchored = true
		
		local newPart = Instance.new("Part")
		newPart.Anchored = true
		newPart.CanCollide = false
		newPart.Name = "wallBounce"
		newPart.Parent = game.Workspace
		
		game.Debris:AddItem(newPart, 5)
		
		animator.PlayAnimation(rs.Animations.other.wallBounce, char)
		
		CombatFunctions:hitEffect(char, "WallBounce")
		CombatFunctions:playSound(script:FindFirstChild("WallBounce"), newPart)
		CombatFunctions:playSound(script:FindFirstChild("WallBounce2"), newPart)
		
		local stoppedEarly = false
		local con
		local con2
		
		con = char.ChildAdded:Connect(function(child)
			if child:IsA("BoolValue") and child.Name == "stun" then
				con:Disconnect()
				stoppedEarly = true
				char:SetAttribute("ragdolled", false)
				char:SetAttribute("wallBounce", false)
				char.HumanoidRootPart.Anchored = false
			end
		end)
		
		con2 = task.spawn(function()
			wait(1.5)
			if not stoppedEarly then
				char:SetAttribute("ragdolled", false)
				char:SetAttribute("wallBounce", false)
				char.HumanoidRootPart.Anchored = false
			end
			if con then
				con:Disconnect()
			end
		end)
	end
end)

local killConnection
local nutConnection
local streakConnection

mostNuts.Changed:Connect(function(newValue)
	local plr = newValue
	
	if nutConnection then
		nutConnection:Disconnect()
	end
	
	if plr.Character then
		local newOffender = rs.offender:Clone()
		newOffender.Parent = plr.Character.Head
	end
	
	nutConnection = plr.CharacterAdded:Connect(function(char)
		local newOffender = rs.offender:Clone()
		newOffender.Parent = plr.Character.Head
	end)
end)

mostKills.Changed:Connect(function(newValue)
	local plr = newValue
	
	if killConnection then
		killConnection:Disconnect()
	end

	if plr.Character then
		local newSociety = rs.society:Clone()
		newSociety.Parent = plr.Character.Head
	end

	killConnection = plr.CharacterAdded:Connect(function(char)
		local newSociety = rs.society:Clone()
		newSociety.Parent = plr.Character.Head
	end)
end)

--mostKillstreak.Changed:Connect(function(newValue)
--	local plr = newValue

--	if streakConnection then
--		streakConnection:Disconnect()
--	end

--	if plr.Character then
--		warn("AWAKENED")
--		CombatFunctions:awaken(plr.Character)
--	end

--	streakConnection = plr.CharacterAdded:Connect(function(char)
--		for _,v in plr.Character:GetChildren() do
--			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
--				for _,b in rs.VFX.Killstreak:GetChildren() do
--					local c = b:Clone()
--					if c:IsA("ParticleEmitter") then
--						c.Parent = v
--					--elseif c:IsA("Highlight") then
--					--	c.Parent = plr.Character
--					end
--				end
--			end
--		end
--	end)
--end)

Emote.OnServerEvent:Connect(function(plr, tag)
	if not plr.Character then return end
	if plr.Character.Humanoid.Health <= 0 then return end
	warn(tag)
	if tag == "1" then
		animator.PlayAnimation(rs.Animations.Emotes["Boston Breakdance"], plr.Character)
	elseif tag == "2" then
		animator.PlayAnimation(rs.Animations.Emotes["Flex"], plr.Character)
	elseif tag == "3" then
		animator.PlayAnimation(rs.Animations.Emotes["Rat"], plr.Character)
	elseif tag == "4" then
		animator.PlayAnimation(rs.Animations.Emotes["Akiyama"], plr.Character)
	elseif tag == "5" then
		animator.PlayAnimation(rs.Animations.Emotes["idk"], plr.Character)
	end
end)

ChangeAttacking.OnServerEvent:Connect(function(plr, toggle)
	if not plr.Character or plr.Character.Humanoid.Health <= 0 then return end
	plr.Character:SetAttribute("attacking", toggle)
end)
print(ownerId)

local RagdollModule = require(rs:WaitForChild("Manager"))
local CombatFunctions = require(rs:WaitForChild("CombatFunctions"))
local RagdollRemote = Remotes:WaitForChild("Ragdoll")
local OnDeath = Remotes:WaitForChild("OnDeath")
local TestAnimation = Remotes:WaitForChild("TestAnimation")
local GetUp = Remotes:WaitForChild("GetUp")
local WallBounce = Remotes:WaitForChild("WallBounce")
local ChangeAttacking = Remotes:WaitForChild("ChangeAttacking")

local animator = require(rs:WaitForChild("AnimationManager"))
local NewChanger = require(rs:WaitForChild("NewChanger"))

local Values = rs:WaitForChild("Values")
local mostKills = Values:WaitForChild("mostKills")
local mostNuts = Values:WaitForChild("mostNuts")


local shutdown = false

if game.PrivateServerId ~=  "" and game.PrivateServerOwnerId ~= 0 then
	print('private server')
else
	--shutdown = true
end

if shutdown then
	for _, plr in ipairs(game.Players:GetPlayers()) do
		plr:Kick()
	end
end

OnDeath.OnServerEvent:Connect(function(Plr,Char)
	local Hum : Humanoid = Char:FindFirstChild("Humanoid")
	print(Hum.Health)
	if Hum.Health <= 0 then return end
	if Plr.Character ~= Char then return end
	Hum.Health = 0
end)
-- INSTANCES

local flash = script:WaitForChild("FlashSFX")

game.Players.PlayerAdded:Connect(function(player)
	if shutdown then
		player:Kick()
	else
		player:SetAttribute("spawnedIn", false)
	end
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local kills = Instance.new("IntValue")
	kills.Name = "Kills"
	kills.Value = 0
	kills.Parent = leaderstats
	
	local killstreak = Instance.new("IntValue")
	killstreak.Name = "Killstreak"
	killstreak.Value = 0
	killstreak.Parent = leaderstats

	local nuts = Instance.new("IntValue")
	nuts.Name = "Nuts"
	nuts.Value = 0
	nuts.Parent = leaderstats
	
	
	player.CharacterAdded:Connect(function(char)
		
		if player.leaderstats:FindFirstChild("Killstreak") then
			player.leaderstats.Killstreak.Value = 0
		end
		
		wait(1)
		
		local hum = char:WaitForChild("Humanoid")
		local root = char:WaitForChild("HumanoidRootPart")
		
		local con
		con = player.leaderstats.Killstreak:GetPropertyChangedSignal("Value"):Connect(function()
			if player.leaderstats.Killstreak.Value == 5 then
				CombatFunctions:awaken(char)
				awakenEvent:FireAllClients(player.DisplayName)
			end
		end)
		--player.AccountAge <= 3 and player.UserId ~= ownerId then
		--player:Kick("Your account age must be at least 3 days old!")
		--end
		--local clothingIndicator = rs.Prompts.clothPrompt:Clone()
		--clothingIndicator.Parent = char:WaitForChild("Torso")
		
		--local executeIndicator = rs.Prompts.executePrompt:Clone()
		--executeIndicator.Parent = char:WaitForChild("Torso")
		--local funIndicator = rs.Prompts.funPrompt:Clone()
		--funIndicator.Parent = char:WaitForChild("Torso")
		--local stopPrompt = rs.Prompts:WaitForChild("stopPrompt"):Clone()
		--stopPrompt.Parent = char:WaitForChild("Torso")
		
		for _,v in rs.Prompts:GetChildren() do
			local p = v:Clone()
			p.Parent = char:WaitForChild("Torso")
		end
		
		
		for i,v in pairs(game.Workspace:WaitForChild(player.Name):GetChildren()) do
			if v:IsA("CharacterMesh") then
				v:Destroy()
			end
		end
		
		char.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		
		local newStatsGui = statsGui:Clone()
		newStatsGui.Frame.TextLabel.Text = player.DisplayName
		newStatsGui.Parent = char.Head
		newStatsGui.Adornee = char.Head
		
		char:SetAttribute("downed", false) 
		char:SetAttribute("iframes", false)
		char:SetAttribute("doing", false)
		char:SetAttribute("funMeter", 0)
		char:SetAttribute("carrying", false)
		char:SetAttribute("canGetUp", true)
		char:SetAttribute("ragdolled", false)
		char:SetAttribute("wallBounce", false)
		char:SetAttribute("attacking", false)
		char:SetAttribute("awakened", false)
		for i,v in pairs(game.Workspace:GetChildren()) do
			if v:FindFirstChild("IsMap") then
				local spawns = v:FindFirstChild("Spawns"):GetChildren()
					if game.Players:GetPlayerFromCharacter(char):GetAttribute("spawnedIn") == false then
					local hrp = char:WaitForChild("HumanoidRootPart")
					local randSpawn = spawns[math.random(1, #spawns)]
					hrp.CFrame = randSpawn.CFrame * CFrame.new(math.random(-3,3),3,math.random(-3,3))
					game.Players:GetPlayerFromCharacter(char):SetAttribute("spawnedIn", true)
				end
			end
		end
		--clothingIndicator.Triggered:Connect(function(sender)
		--	NewChanger.undress(player, sender)
		--end)

		char.Head.Size = Vector3.new(1, 1, 1)
		hum.BreakJointsOnDeath = false -- should we put that on,
		hum.RequiresNeck = false

		local Attach = Instance.new("Attachment", root)
		Attach.Name = "ForceAttachment"
		hum.Died:Connect(function()
			if con then
				con:Disconnect()
			end
			RagdollModule.Ragdoll(char)
			root:SetNetworkOwner(player)
			Remotes:WaitForChild("RagdollForce"):FireClient(player)
		end)

			
		hum.Died:Connect(function()
			print("Player died!")
			
		end)
		
		hum.HealthChanged:Connect(function(h)
			local ti = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local t = ts:Create(hum.Parent.Head:FindFirstChild("stats").Frame.health.Frame, ti, {Size = UDim2.new(h / hum.MaxHealth, 0, 1, 0)})
			t:Play()
		end)
		
		char:GetAttributeChangedSignal("funMeter"):Connect(function()
			local newMeter = char:GetAttribute("funMeter")
			local ti = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local t = ts:Create(hum.Parent.Head:FindFirstChild("stats").Frame.fun.Frame, ti, {Size = UDim2.new(newMeter, 0, 1, 0)})
			t:Play()
		end)
		
		task.spawn(function()
			local NORMAL_REGEN_RATE = 1/40
			local AWAKEN_REGEN_RATE = 1/25
			while hum do
				wait(1)
				if char:GetAttribute("awakened") then
					hum.Health += hum.MaxHealth * AWAKEN_REGEN_RATE
				else
					hum.Health += hum.MaxHealth * NORMAL_REGEN_RATE
				end
			end
		end)
		
	end)
end)

PlaySound.OnServerEvent:Connect(function(_, sound, start, duration, speed)
	if start then
		sound.TimePosition = start
	end
	if speed then
		sound.PlaybackSpeed = speed
	end
	sound:Play()
	if duration then
		wait(duration)
		if sound.IsPlaying then
			sound:Stop()
		end
	end
end)

ToggleParticles.OnServerEvent:Connect(function(_, particles, t, d)
	if type(particles) == "table" then
		for _,p in particles do
			p.Enabled = t
		end
		if d then
			wait(d)
		end
		for _,p in particles do
			p.Enabled = false
		end
	else
		particles.Enabled = t
		if d then
			wait(d)
			particles.Enabled = false
		end
	end
end)

Flash.OnServerEvent:Connect(function(plr, fill, outline, duration)
	
	if not plr.Character then return end
	if plr.Character.Humanoid.Health <= 0 then return end
	
	local root = plr.Character.HumanoidRootPart
	
	local h = Instance.new("Highlight")
	h.FillColor = fill
	h.FillTransparency = 0.2
	h.OutlineColor = outline
	h.Parent = plr.Character
	
	local c = flash:Clone()
	c.Parent = root
	c:Play()
	game.Debris:AddItem(c, c.TimeLength)
	
	local ti = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local t = ts:Create(h, ti, {FillTransparency = 1})
	local t2 = ts:Create(h, ti, {OutlineTransparency = 1})
	
	game.Debris:AddItem(h, duration)
	t:Play()
	t2:Play()
end)

pps.PromptTriggered:Connect(function(prompt, player)
	local victim = prompt.Parent.Parent
	local attacker = player.Character
	
	if attacker:GetAttribute("downed") then return end
	
	if prompt.Name == "executePrompt" then
		CombatFunctions:grip(attacker, victim, "Default")
	elseif prompt.Name:find("Fun") then
		CombatFunctions:fun(attacker, victim, string.sub(prompt.Name, 1, string.len(prompt.Name) - 3))
	elseif prompt.Name == "carryPrompt" then
		CombatFunctions:carry(attacker, victim)
	end
end)

TestAnimation.OnServerEvent:Connect(function(plr)
	RagdollModule.Ragdoll(plr.Character)
	wait(5)
	RagdollModule.UnRagdoll(plr.Character)
	--NewChanger:loadMorph(plr.Character, "pp")
	--wait(2)
	--animator.PlayAnimation(rs.Animations.male:WaitForChild("fun"), plr.Character)
end)

GetUp.OnServerEvent:Connect(function(plr)
	local char = plr.Character
	
	--warn(plr.Name.." has got up!")
	
	char:SetAttribute("downed", false)
	CombatFunctions:flash(char, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0), 1)
	CombatFunctions:playSound(script:WaitForChild("FlashSFX"), char.HumanoidRootPart)
	
	animator.StopAnimationOnHumanoid(char.Humanoid)
	
	for _,v in char.Torso:GetChildren() do
		if v:IsA("ProximityPrompt") then
			print("prox: "..v.Name)
			v.Enabled = false
		end
	end
	
	RagdollModule.UnRagdoll(char)
end)

local function calculateClosestPartSide(target, dest)
	local targetPos = target.Position
	local destPos = dest.Position
	local destSize = dest.Size
	
	local positions = {
		Vector3.new(destPos.X + (destSize.X / 2), destPos.Y, destPos.Z),
		Vector3.new(destPos.X - (destSize.X / 2), destPos.Y, destPos.Z),
		Vector3.new(destPos.X, destPos.Y + (destSize.Y / 2), destPos.Z),
		Vector3.new(destPos.X, destPos.Y - (destSize.Y / 2), destPos.Z),
		Vector3.new(destPos.X, destPos.Y, destPos.Z + (destSize.Z / 2)),
		Vector3.new(destPos.X, destPos.Y, destPos.Z - (destSize.Z / 2))
	}
	
	local closestPos = positions[1]
	local smallestMagnitude = math.abs((positions[1] - targetPos).Magnitude)
	
	for _,pos in positions do
		local currentMagnitude = math.abs((pos - targetPos).Magnitude)
		if (currentMagnitude < smallestMagnitude) then
			closestPos = pos
			smallestMagnitude = currentMagnitude
		end
	end
	
	if closestPos == nil then
		warn("nil position")
	end
	
	--local partRef = Instance.new("Part")
	--partRef.Anchored = true
	--partRef.CanCollide = false
	--partRef.Parent = game.Workspace
	--partRef.Name = "A"
	--partRef.Position = closestPos
	
	return {closestPos, smallestMagnitude}
end

WallBounce.OnServerEvent:Connect(function(plr, part, finalCFrame)
	warn("hello from server")
	local char = plr.Character
	if char.Humanoid.Health > 0 and not char:GetAttribute("downed") and char:GetAttribute("ragdolled") and not char:GetAttribute("wallBounce") then
		
		RagdollModule.UnRagdoll(char)
		char:SetAttribute("ragdolled", false)
		char:SetAttribute("wallBounce", true)
		
		char.HumanoidRootPart.CFrame = finalCFrame
		char.HumanoidRootPart.Anchored = true
		
		local newPart = Instance.new("Part")
		newPart.Anchored = true
		newPart.CanCollide = false
		newPart.Name = "wallBounce"
		newPart.Parent = game.Workspace
		
		game.Debris:AddItem(newPart, 5)
		
		animator.PlayAnimation(rs.Animations.other.wallBounce, char)
		
		CombatFunctions:hitEffect(char, "WallBounce")
		CombatFunctions:playSound(script:FindFirstChild("WallBounce"), newPart)
		CombatFunctions:playSound(script:FindFirstChild("WallBounce2"), newPart)
		
		local stoppedEarly = false
		local con
		local con2
		
		con = char.ChildAdded:Connect(function(child)
			if child:IsA("BoolValue") and child.Name == "stun" then
				con:Disconnect()
				stoppedEarly = true
				char:SetAttribute("ragdolled", false)
				char:SetAttribute("wallBounce", false)
				char.HumanoidRootPart.Anchored = false
			end
		end)
		
		con2 = task.spawn(function()
			wait(1.5)
			if not stoppedEarly then
				char:SetAttribute("ragdolled", false)
				char:SetAttribute("wallBounce", false)
				char.HumanoidRootPart.Anchored = false
			end
			if con then
				con:Disconnect()
			end
		end)
	end
end)

local killConnection
local nutConnection
local streakConnection

mostNuts.Changed:Connect(function(newValue)
	local plr = newValue
	
	if nutConnection then
		nutConnection:Disconnect()
	end
	
	if plr.Character then
		local newOffender = rs.offender:Clone()
		newOffender.Parent = plr.Character.Head
	end
	
	nutConnection = plr.CharacterAdded:Connect(function(char)
		local newOffender = rs.offender:Clone()
		newOffender.Parent = plr.Character.Head
	end)
end)

mostKills.Changed:Connect(function(newValue)
	local plr = newValue
	
	if killConnection then
		killConnection:Disconnect()
	end

	if plr.Character then
		local newSociety = rs.society:Clone()
		newSociety.Parent = plr.Character.Head
	end

	killConnection = plr.CharacterAdded:Connect(function(char)
		local newSociety = rs.society:Clone()
		newSociety.Parent = plr.Character.Head
	end)
end)

--mostKillstreak.Changed:Connect(function(newValue)
--	local plr = newValue

--	if streakConnection then
--		streakConnection:Disconnect()
--	end

--	if plr.Character then
--		warn("AWAKENED")
--		CombatFunctions:awaken(plr.Character)
--	end

--	streakConnection = plr.CharacterAdded:Connect(function(char)
--		for _,v in plr.Character:GetChildren() do
--			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
--				for _,b in rs.VFX.Killstreak:GetChildren() do
--					local c = b:Clone()
--					if c:IsA("ParticleEmitter") then
--						c.Parent = v
--					--elseif c:IsA("Highlight") then
--					--	c.Parent = plr.Character
--					end
--				end
--			end
--		end
--	end)
--end)

Emote.OnServerEvent:Connect(function(plr, tag)
	if not plr.Character then return end
	if plr.Character.Humanoid.Health <= 0 then return end
	warn(tag)
	if tag == "1" then
		animator.PlayAnimation(rs.Animations.Emotes["Boston Breakdance"], plr.Character)
	elseif tag == "2" then
		animator.PlayAnimation(rs.Animations.Emotes["Flex"], plr.Character)
	elseif tag == "3" then
		animator.PlayAnimation(rs.Animations.Emotes["Rat"], plr.Character)
	elseif tag == "4" then
		animator.PlayAnimation(rs.Animations.Emotes["Akiyama"], plr.Character)
	elseif tag == "5" then
		animator.PlayAnimation(rs.Animations.Emotes["idk"], plr.Character)
	end
end)

ChangeAttacking.OnServerEvent:Connect(function(plr, toggle)
	if not plr.Character or plr.Character.Humanoid.Health <= 0 then return end
	plr.Character:SetAttribute("attacking", toggle)
end)
