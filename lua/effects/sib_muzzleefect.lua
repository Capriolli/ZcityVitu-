local images_muzzle = {"effects/muzzleflash1", "effects/muzzleflash2", "effects/muzzleflash3", "effects/muzzleflash4"}
local images_distort = {"sprites/heatwave"}
local function TableRandomChoice(tbl)
	return tbl[math.random(#tbl)]
end

local SIB = {}
SIB.SmokeImages = {"particle/smokesprites_0001", "particle/smokesprites_0002", "particle/smokesprites_0003", "particle/smokesprites_0004", "particle/smokesprites_0005", "particle/smokesprites_0006", "particle/smokesprites_0007", "particle/smokesprites_0008", "particle/smokesprites_0009", "particle/smokesprites_0010", "particle/smokesprites_0011", "particle/smokesprites_0012", "particle/smokesprites_0013", "particle/smokesprites_0014", "particle/smokesprites_0015", "particle/smokesprites_0016"}
function SIB_GetSmokeImage()
	return SIB.SmokeImages[math.random(#SIB.SmokeImages)]
end

function EFFECT:Init(data)
	local quality = 3
	if quality == 0 then return end
	local wpn = data:GetEntity()
	if not IsValid(wpn) then return end
	local ply = wpn:GetOwner()
	if not IsValid(ply) then return end
	local pos, dir = wpn:GetAttachment(wpn:LookupAttachment("muzzle")).Pos, wpn:GetAttachment(wpn:LookupAttachment("muzzle")).Ang
	dir = dir:Forward()
	local addvel = ply:GetVelocity()
	local emitter = ParticleEmitter(pos)
	
	if quality >= 3 then
		local particle = emitter:Add(TableRandomChoice(images_distort), pos)
		if particle then
			particle:SetVelocity((dir * 40) + 1.1 * addvel)
			particle:SetLifeTime(0)
			particle:SetDieTime(math.Rand(0.15, 0.3))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(15, 25))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetAirResistance(5)
			particle:SetGravity(Vector(0, 0, 50))
			particle:SetColor(255, 255, 255)
		end
		
		for i = 1, 3 do
			local smoke = emitter:Add(SIB_GetSmokeImage(), pos)
			if smoke then
				smoke:SetVelocity(dir * math.random(30, 60) + addvel * 0.5)
				smoke:SetLifeTime(0)
				smoke:SetDieTime(math.Rand(0.4, 0.8))
				smoke:SetStartAlpha(math.Rand(80, 150))
				smoke:SetEndAlpha(0)
				smoke:SetStartSize(math.Rand(8, 15))
				smoke:SetEndSize(math.Rand(25, 45))
				smoke:SetRoll(math.Rand(0, 360))
				smoke:SetRollDelta(math.Rand(-1, 1))
				smoke:SetLighting(true)
				smoke:SetAirResistance(120)
				smoke:SetGravity(Vector(-5, 2, 80))
				smoke:SetColor(200, 200, 200)
			end
		end
	end

	if wpn.DoFlash and math.random(1, 100) <= 70 then
		local dlight = DynamicLight(LocalPlayer():EntIndex())
		if dlight then
			dlight.pos = pos
			dlight.r = 255
			dlight.g = 215
			dlight.b = 55
			dlight.brightness = 2
			dlight.decay = 3000
			dlight.size = 256
			dlight.dietime = CurTime() + 0.15
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	return false
end
