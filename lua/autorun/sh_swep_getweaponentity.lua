-- This file ensures GetWeaponEntity is available for all SWEPs
-- This fixes errors with external addons that don't load homigrad_base

if not SWEP.GetWeaponEntity then
	function SWEP:GetWeaponEntity()
		return IsValid(self.worldModel) and IsValid(self:GetOwner()) and self.worldModel or self
	end
end
