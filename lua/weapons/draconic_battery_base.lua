SWEP.Base				= "draconic_gun_base"
SWEP.Gun				= "draconic_battery_base"

SWEP.Category			= "Draconic"
SWEP.PrintName			= "Draconic Battery Base"
SWEP.Auhtor				= "Vuthakral"
SWEP.Contact			= " https://discord.gg/6Y7WXrX // Steam: Vuthakral // Disc: Vuthakral#9761 "
SWEP.Purpose			= "SWEP BAse"
SWEP.Instructions		= "open rectum & insert"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Slot				= 0
SWEP.SlotPos			= 0

SWEP.ViewModelFOV		= 54
SWEP.ViewModelFlip		= false

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.VMPos = Vector(0, 0, 0)
SWEP.VMAng = Vector(0, 0, 0)
SWEP.IronSightPos = Vector(0, 0, 0)
SWEP.IronSightAng = Vector(0, 0, 0)
SWEP.SS = 0
SWEP.BS = 0

SWEP.InfAmmo				= false

SWEP.HPS					= 6
SWEP.OverHeatFinishPercent	= 0.17
SWEP.DisperseHeatPassively = true
SWEP.HeatLossInterval		= 0.1
SWEP.HeatLossPerInterval	= 1
SWEP.DoOverheatDamage		= false
SWEP.OverheatDamagePerInt	= 0
SWEP.OverheatHoldType		= "knife"
SWEP.OverheatStrength		= 3
SWEP.VentingHoldType		= "slam"
SWEP.VentingStrength		= 4
SWEP.CanOverheat			= true
SWEP.CanVent				= false
SWEP.LowerRPMWithHeat		= true
SWEP.HeatRPMmin				= 120

SWEP.LoadAfterShot 			= false
SWEP.LoadAfterReloadEmpty	= false
SWEP.ManualReload			= false
SWEP.Primary.NumShots 		= 1
SWEP.Primary.IronRecoilMul	= 0.5
SWEP.Primary.Spread			= 1
SWEP.Primary.SpreadDiv		= 90
SWEP.Primary.Force			= 0
SWEP.Primary.Damage			= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.RPM			= 857
SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.APS			= 1
SWEP.Primary.Tracer			= 4 -- https://wiki.garrysmod.com/page/Enums/TRACER
SWEP.Primary.Sound			= Sound("draconic.PewPew")

SWEP.Secondary.Ironsights	= false
SWEP.Secondary.Scoped		= false
SWEP.Secondary.ScopeMat		= "overlays/draconic_scope"
SWEP.Secondary.IronFOV		= 60

SWEP.Secondary.NumShots 		= 1
SWEP.Secondary.Spread			= 3.5
SWEP.Secondary.SpreadDiv		= 100
SWEP.Secondary.Kick				= 0.5
SWEP.Secondary.RecoilUp			= 1
SWEP.Secondary.RecoilDown		= 1
SWEP.Secondary.RecoilHoriz		= 1
SWEP.Secondary.Force			= 0.2
SWEP.Secondary.Damage			= 12
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Automatic		= false
SWEP.Secondary.RPM				= 444
SWEP.Secondary.ClipSize			= 18
SWEP.Secondary.DefaultClip		= 18
SWEP.Secondary.APS				= 1
SWEP.Secondary.Tracer			= 1 -- https://wiki.garrysmod.com/page/Enums/TRACER
SWEP.Secondary.Sound = Sound("weapon_pistol.Single")

-- Settings for NPCs
SWEP.NPCBurstShots = 0
SWEP.JackalSniper = false

-- the DO NOT TOUCH zone
SWEP.Primary.Ammo = "CombineCannon"
SWEP.Loading = false
SWEP.IronCD = false

function SWEP:CanPrimaryAttack()
local ply = self:GetOwner()
local curFOV = ply:GetFOV()
local IronFOV = self.Secondary.IronFOV

	if self.Overheated == true then
		return false
	end
	if ply:GetAmmoCount(self.Primary.Ammo) >= 100 && self.Weapon:Clip1() >= 1 && self.CanOverheat == true && self.InfAmmo == false then
		self:SetHoldType(self.OverheatHoldType)
		self:Overheat()
		ply:SetFOV(0, 0.05)
		return false
	elseif ply:GetAmmoCount(self.Primary.Ammo) >= 100 && self.Weapon:Clip1() >= 1 && self.CanOverheat == false && self.InfAmmo == false then
		self:SetHoldType(self.OverheatHoldType)
		ply:SetFOV(0, 0.05)
		return true
	elseif self.Weapon:Clip1() <= 0 && self.InfAmmo == false then
		self:EmitSound ( "draconic.BatteryDepleted" )
		self:SetNextPrimaryFire (( CurTime() + 0.3 ))
		return false
	elseif ply:GetAmmoCount(self.Primary.Ammo) >= 100 && self.Weapon:Clip1() >= 0 && self.CanOverheat == true && self.InfAmmo == true then
		self:SetHoldType(self.OverheatHoldType)
		self:Overheat()
		ply:SetFOV(0, 0.05)
		return false
	elseif ply:GetAmmoCount(self.Primary.Ammo) >= 100 && self.Weapon:Clip1() >= 0 && self.CanOverheat == false && self.InfAmmo == true then
		self:SetHoldType(self.OverheatHoldType)
		ply:SetFOV(0, 0.05)
		return true
	elseif self.Weapon:Clip1() <= 0 && self.InfAmmo == true && self.Loading == false && self.ManuallyReloading == false then
		self:SetNextPrimaryFire (( CurTime() + 0.3 ))
		return true
	end
	if self.Weapon:GetNWBool("ironsights") == false && self.Overheated == false then
		if self.EnableFOVKick == true then
			ply:SetFOV(curFOV + 1 * self.FOVKickMult, 0.01 * self.FOVKickTimeMult)
			timer.Simple (0.01 * self.FOVKickTimeMult, function() self:unKick() end)
		elseif self.EnableFOVKick == false then
		end
	elseif self.Weapon:GetNWBool("ironsights") == true && self.Overheated == false then
		if self.EnableFOVKick == true then
			ply:SetFOV(IronFOV + 1 * (self.FOVKickMult / 2), 0.01 * self.FOVKickTimeMult)
			timer.Simple (0.01 * self.FOVKickTimeMult, function() self:unKick() end)
		elseif self.EnableFOVKick == false then
		end
	end
	if self.Loading == true or self.ManuallyReloading == true then
		return false
	else
	return true
	end
end

function SWEP:CanPrimaryAttackNPC()
local npc = self:GetOwner()

	if self.Weapon:Clip1() <= 0 or npc:GetActivity() == ACT_RELOAD or self.Weapon:GetNWBool("NPCLoading") == true then
		self:LoadNextShot()
		return false
	end
	npc:SetSchedule(SCHED_RANGE_ATTACK1)
	return true
end

function SWEP:Reload()
local ply = self:GetOwner()
local usekey = ply:KeyDown(IN_USE)
local reloadkey = ply:KeyDown(IN_RELOAD)
local walkkey = ply:KeyDown(IN_WALK)
local sprintkey = ply:KeyDown(IN_SPEED)

	if usekey && reloadkey then
		if self.Inspecting == 0 then
			self.Idle = 0
			self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self:Inspect()
		elseif self.Inspect == 1 then end
	elseif walkkey && reloadkey && self.IsTaunting == 0 then
		self:Taunt()
		elseif walkkey && reloadkey && self.IsTaunting == 1 then
		self:SetHoldType(self.VentingHoldType)
	elseif reloadkey && !sprintkey && self.ManuallyReloading == false && self.Loading == false && self.ManualReload == false && self.CanVent == true && ( self.Weapon:Clip1() < self.Primary.ClipSize ) then
			if ( self.Weapon:Clip1() < self.Primary.ClipSize ) && self.Weapon:Ammo1() > 0 then
				self:SetHoldType(self.VentingHoldType)
				self:Vent()
				ply:SetFOV(0, 0.05)
				self.Weapon:SetNWBool( "Ironsights", false )
				if self.Weapon:Clip1() <= 0 then
					self:SetNWBool("reloadedEmpty", true)
				else
					self:SetNWBool("reloadedEmpty", false)
				end
				return true
			elseif ( self.Weapon:Clip1() < self.Primary.ClipSize ) && self.Weapon:Ammo1() > 1 then
			end
	elseif reloadkey && sprintkey && self.ManuallyReloading == false && self.Loading == false && ( self.Weapon:Clip2() < self.Secondary.ClipSize ) then
		self:SetHoldType(self.VentingHoldType)
		ply:SetFOV(0, 0.05)
		self:ReloadSecondary()
	end
end

function SWEP:Vent()
	local ply = self:GetOwner()
	local loopseq = self:SelectWeightedSequence( ACT_SHOTGUN_RELOAD_START )
	local looptime = self:SequenceDuration( loopseq )

--	if self:Clip1() >= self.Primary.ClipSize then self:FinishManualReload() end
	
	self.ManuallyReloading = true
	self.Weapon:SetNWFloat("HeatDispersePower", self.VentingStrength)
	self:SetIronsights(false, self.Owner)

	if CLIENT or SERVER then
	self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
	end
	timer.Simple( looptime, function() self:VentHold() end)
end

function SWEP:VentHold()
local ply = self:GetOwner()
	self:SendWeaponAnim(ACT_VM_RELOAD)
	if self:Clip1() <= self.Primary.ClipSize then
		if ply:KeyDown(IN_RELOAD) && ply:GetAmmoCount("CombineCannon") > 0 then
			self:Vent()
		else
			self:FinishVent()
		end
	end
end

function SWEP:FinishVent()
	local ply = self:GetOwner()
	local loopseq = self:SelectWeightedSequence( ACT_VM_RELOAD )
	local looptime = self:SequenceDuration( loopseq )
	
	self.ManuallyReloading = false
	self.Overheated = false
	self.IronCD = false
	self:SetHoldType( self.HoldType )
	self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
	self.Weapon:SetNWFloat("HeatDispersePower", 1)
	
	timer.Simple( looptime, function() self:ManuallyLoadAfterReload() end)
end

function SWEP:Overheat()
	local ply = self:GetOwner()
	local loopseq = self:SelectWeightedSequence( ACT_VM_RELOAD )
	local looptime = self:SequenceDuration( loopseq )
	self.ManuallyReloading = true
	self:SetIronsights(false, self.Owner)
	
	if self.Weapon:Clip1() <= 0 && self.InfAmmo == false then
		self:EmitSound ( "draconic.BatteryDepleted" )
		self:SetNextPrimaryFire (( CurTime() + (60 / self.Primary.RPM) ) * (self:GetNWInt("Heat") * 0.1))
		return false
	elseif self.Weapon:Clip1() <= 0 && self.InfAmmo == true then
		self.Weapon:SetNWFloat("HeatDispersePower", self.OverheatStrength)
		self.Overheated = true
		if CLIENT or SERVER then
			self:SendWeaponAnim(ACT_VM_RELOAD)
		end
		timer.Simple( looptime, function() self:AutoVent() end)
	else
		self.Weapon:SetNWFloat("HeatDispersePower", self.OverheatStrength)
		self.Overheated = true
		if CLIENT or SERVER then
			self:SendWeaponAnim(ACT_VM_RELOAD)
		end
		timer.Simple( looptime, function() self:AutoVent() end)
	end

	if SERVER then
		self.Weapon:SetNWBool("NPCLoading", true)
	else end
end

function SWEP:AutoVent()
local ply = self:GetOwner()
local AmmoName = ""..self:GetPrintName().."_heat"

	if ply:GetAmmoCount(AmmoName) > 0 then
		if ply:GetAmmoCount(self.Primary.Ammo) <= (self.Primary.ClipSize * self.OverHeatFinishPercent) then
			self:AutoVentLoop()
		else
			self:FinishVent()
			if SERVER then self.Weapon:SetNWBool("NPCLoading", true) end
		end
	else 
		timer.Simple(1, function() self:FinishVent() end)
		if SERVER then self.Weapon:SetNWBool("NPCLoading", true) end
	end
end

function SWEP:AutoVentLoop()
	self.Weapon:SetNWFloat("HeatDispersePower", (self.VentingStrength / 2))
	timer.Simple(0.05, function() self:AutoVent() end)
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	local fireseq = self:SelectWeightedSequence( ACT_VM_PRIMARYATTACK )
	local firetime = self:SequenceDuration( fireseq )
	local heat = self:GetNWInt("Heat")
	
if ply:IsPlayer() then
	if self.Primary.CanMelee == true then
		if ply:KeyDown(self.Primary.MeleeKeyInput) then
			self:DoMelee()
		else
			if self.Loading == false then
				self:DoPrimaryAttack()
					if self.LoadAfterShot == true && (self.Weapon:Clip1() > 0) then
						self.Loading = true
						timer.Simple( firetime, function() self:LoadNextShot() end)
					elseif self.LoadAfterShot == true && (self.Weapon:Clip1() <= 0) then
						self.Loading = false
					elseif self.Loading == false then
					end
			end
		end
	elseif self.Primary.CanMelee == false && self.Loading == false then
		self:DoPrimaryAttack()
		if self.LoadAfterShot == true && (self.Weapon:Clip1() > 0) then
			self.Loading = true
			timer.Simple( firetime, function() self:LoadNextShot() end)
		elseif self.LoadAfterShot == true && self.LoadAfterReloadEmpty == false && (self.Weapon:Clip1() <=0) then
			self.Loading = true
			timer.Simple( firetime, function() self:LoadNextShot() end)
		elseif self.LoadAfterShot == true && (self.Weapon:Clip1() <= 0) then
		self.Loading = false
		else end
	end
elseif !ply:IsPlayer() then
if SERVER then
	if (self.Weapon:Clip1() > 0) then
	if self.FireDelay > CurTime() then
		return
	end
		if self.Owner:IsNPC() and IsValid(self.Owner:GetEnemy()) then
			if self.LowerRPMWithHeat == true then
				self.FireDelay = ( CurTime() + math.Clamp(((heat * 2) / self.Primary.RPM), (60 / self.Primary.RPM), (60 / self.HeatRPMmin)) )
			else
				self.FireDelay = ( CurTime() + (60 / self.Primary.RPM) )
			end
			for i=0, self.NPCBurstShots do
				timer.Simple(i + 0.1, function()
					if not IsValid(self) or not IsValid(self.Owner) then
						return
					end
					if not self.Owner:GetEnemy() or not self:CanPrimaryAttackNPC() then
						return
					end
					if self.Loading == false then
						self:DoPrimaryAttackNPC()
						if self.LoadAfterShot == true then
							self.Loading = true
							timer.Simple( 0.01, function() self.Weapon:SetNWBool("NPCLoading", true) end)
						else end
					end
				end)
			end
		end
	elseif (self.Weapon:Clip1() <= 0) then
	end
else end
end
end

function SWEP:DoPrimaryAttack()
local ply = self:GetOwner()
local eyeang = ply:EyeAngles()
local cv = ply:Crouching()
local heat = self:GetNWInt("Heat")
	
	if ( self:CanPrimaryAttack() ) then
	ply:SetAmmo(self:GetNWInt("Heat"), self.Primary.Ammo)
	if self.Weapon:GetNWBool("ironsights") == false && cv == false then
		if CLIENT then
		eyeang.pitch = eyeang.pitch - ((math.Rand(self.Primary.RecoilUp / 1.85, self.Primary.RecoilUp * 1.62)) - (math.Rand(self.Primary.RecoilDown / 1.85, self.Primary.RecoilDown * 1.85) * FrameTime()))
		eyeang.yaw = eyeang.yaw - (math.Rand( self.Primary.RecoilHoriz, (self.Primary.RecoilHoriz * -0.81) ) * FrameTime())
		else end
		self.Owner:ViewPunch(Angle( -self.Primary.Kick, 0, 0 ))
	elseif self.Weapon:GetNWBool("ironsights") == true && cv == false then
		eyeang.pitch = eyeang.pitch - (((math.Rand(self.Primary.RecoilUp / 1.5, self.Primary.RecoilUp * 1.5)) - (math.Rand(self.Primary.RecoilDown / 1.5, self.Primary.RecoilDown * 1.5) * FrameTime())) * self.Primary.IronRecoilMul)
		eyeang.yaw = eyeang.yaw - (math.Rand( self.Primary.RecoilHoriz, (self.Primary.RecoilHoriz * -1) ) * FrameTime())
		self.Owner:ViewPunch(Angle( (-self.Primary.Kick * 0.69) * self.Primary.IronRecoilMul, 0, 0 ))
	elseif self.Weapon:GetNWBool("ironsights") == false && cv == true then
		eyeang.pitch = eyeang.pitch - ((math.Rand(self.Primary.RecoilUp / 1.5, self.Primary.RecoilUp * 1.5)) - (math.Rand(self.Primary.RecoilDown / 1.5, self.Primary.RecoilDown * 1.5) * FrameTime()))
			eyeang.yaw = eyeang.yaw - (math.Rand( self.Primary.RecoilHoriz, (self.Primary.RecoilHoriz * -1) ) * FrameTime())
		self.Owner:ViewPunch(Angle( -self.Primary.Kick * 0.75, 0, 0 ))
	elseif self.Weapon:GetNWBool("ironsights") == true && cv == true then
		eyeang.pitch = eyeang.pitch - (((math.Rand(self.Primary.RecoilUp / 1.5, self.Primary.RecoilUp * 0.9)) - (math.Rand(self.Primary.RecoilDown / 1.9, self.Primary.RecoilDown * 0.9) * FrameTime())) * self.Primary.IronRecoilMul)
		eyeang.yaw = eyeang.yaw - (math.Rand( self.Primary.RecoilHoriz, (self.Primary.RecoilHoriz * -1) ) * FrameTime())
		self.Owner:ViewPunch(Angle( (-self.Primary.Kick * 0.42) * self.Primary.IronRecoilMul, 0, 0 ))
	end
		local bullet = {}
			bullet.Num = self.Primary.NumShots
			bullet.Src = self.Owner:GetShootPos()
			bullet.Dir = self.Owner:GetAimVector()
			bullet.Spread = Vector( self.Primary.Spread / self.Primary.SpreadDiv, self.Primary.Spread / self.Primary.SpreadDiv, 0 )
			bullet.Tracer = self.Primary.Tracer
			bullet.Force = self.Primary.Force
			bullet.Damage = self.Primary.Damage
			self.AmmoType = self.Primary.AmmoType
				
	if self.Primary.Projectile == nil then
		self.Owner:FireBullets ( bullet )
	else
	local aim = self.Owner:GetAimVector()
	local side = aim:Cross(Vector(0,0,0))
	local up = side:Cross(aim)
	local pos = self.Owner:GetShootPos() + side * 0 + up * 0
		if SERVER then
			local proj = ents.Create(self.Primary.Projectile)
			if !proj:IsValid() then return false end
			proj:SetAngles(self.Owner:EyeAngles())
			proj:SetPos(pos)
			proj:SetOwner(self.Owner)
			proj:Spawn()
			proj.Owner = self.Owner
			proj:Activate()
			eyes = self.Owner:EyeAngles()
			local phys = proj:GetPhysicsObject()
			if self.Primary.ProjInheritVelocity == true then
				phys:SetVelocity((self.Owner:GetAimVector() * self.Primary.ProjSpeed) + ply:GetVelocity())
			else
				phys:SetVelocity(self.Owner:GetAimVector() * self.Primary.ProjSpeed)
			end
		end
	end
	self.Owner:MuzzleFlash()
	ply:SetAnimation( PLAYER_ATTACK1 )
	if self.Secondary.SightsSuppressAnim == false && self.Weapon:GetNWBool("ironsights") == false then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	elseif self.Secondary.SightsSuppressAnim == false && self.Weapon:GetNWBool("ironsights") == true then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	elseif self.Secondary.SightsSuppressAnim == true && self.Weapon:GetNWBool("ironsights") == false then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	elseif self.Secondary.SightsSuppressAnim == true && self.Weapon:GetNWBool("ironsights") == true then
	end
	self.Weapon:EmitSound(Sound(self.Primary.Sound))
	if CLIENT then
		ply:SetEyeAngles( eyeang )
	else end
		self:TakePrimaryAmmo( self.Primary.APS )
		self:SetNWInt("Heat", (self:GetNWInt("Heat") + self.HPS))
		if self.LowerRPMWithHeat == true then
			self:SetNextPrimaryFire ( CurTime() + math.Clamp(((heat * 2) / self.Primary.RPM), (60 / self.Primary.RPM), (60 / self.HeatRPMmin)) )
		else
			self:SetNextPrimaryFire ( CurTime() + (60 / self.Primary.RPM) )
		end
		self:MuzzleFlash()
		self:ShootEffects()
	else return end
end

function SWEP:DoPrimaryAttackNPC()
local npc = self:GetOwner()
local eyeang = npc:EyeAngles()
local tgt = npc:GetEnemy()
local tgtclass = tgt:GetClass()
local ctrpos = tgt:WorldSpaceCenter()
local eyepos = tgt:EyePos()
local muzzle = self:LookupAttachment("muzzle")
local tgtpos = nil
local accuracy = Vector( self.Primary.Spread / self.Primary.SpreadDiv, self.Primary.Spread / self.Primary.SpreadDiv, 0 )
local AccuracyHorizmath = math.random((self.Primary.Kick * -self.Primary.RecoilHoriz), (self.Primary.Kick * self.Primary.RecoilHoriz))
local AccuracyVertmath = math.random((math.Rand((self.Primary.Kick * -self.Primary.RecoilUp), (self.Primary.Kick * self.Primary.RecoilUp))), (math.Rand((self.Primary.Kick * -self.Primary.RecoilDown), (self.Primary.Kick * self.Primary.RecoilDown))))
local heat = self:GetNWInt("Heat")	

if self.JackalSniper == false then
	if tgt:IsPlayer() or tgtclass == "npc_citizen" or tgtclass == "npc_combine_s" or tgtclass == "npc_metropolice" or tgtclass == "npc_helicopter" or tgtclass == "npc_strider" or tgtclass == "npc_ministrider" or tgtclass == "npc_hunter" or tgtclass == "npc_barnacle" or tgtclass == "npc_zombie_torso" or tgtclass == "npc_fastzombie_torso" or tgtclass == "monster_alien_controller" or tgtclass == "monster_scientist" or tgtclass == "monster_barney" then
		tgtpos = (eyepos - Vector(AccuracyHorizmath, 0, (AccuracyVertmath + math.random(5, 15))))
	elseif tgtclass == "npc_zombie" or tgtclass == "npc_fastzombie" or tgtclass == "npc_poisonzombie" or tgtclass == "npc_zombine" or tgtclass == "monster_human_grunt" or tgtclass == "npc_stalker" or tgtclass == "monster_tentacle" or tgtclass == "monster_alien_grunt" or tgtclass == "monster_human_assassin" or tgtclass == "monster_alien_slave" or tgtclass == "monster_zombie" then
		tgtpos = (ctrpos + Vector(AccuracyHorizmath, 0, (AccuracyVertmath + math.Rand(10, 17))))
	elseif tgtclass == "npc_headcrab" or tgtclass == "npc_headcrab_black" or tgtclass == "npc_headcrab_fast" or tgtclass == "npc_manhack" or tgtclass == "npc_rollermine" or tgtclass == "npc_turret_floor" or tgtclass == "npc_cscanner" or tgtclass == "npc_clawscanner" or tgtclass == "npc_antlion_worker" or tgtclass == "npc_antlionguard" or tgtclass == "npc_antlionguardian" or tgtclass == "monster_sentry" or tgtclass == "monster_snark" or tgtclass == "monster_houndeye"  or tgtclass == "monster_babycrab" or tgtclass == "monster_bullchicken" or tgtclass == "monster_cockroach" or tgtclass == "monster_headcrab" or tgtclass == "monster_turret" or tgtclass == "monster_miniturret" or tgtclass == "npc_combinegunship" then
		tgtpos = ctrpos
	elseif tgtclass == "npc_antlion" then
		tgtpos = eyepos
	elseif tgtclass == "monster_gargantua" or tgtclass == "monster_nihilanth" or tgtclass == "monster_bigmomma" then
		tgtpos = (ctrpos + Vector(AccuracyHorizmath, 0, (AccuracyVertmath + math.random(6, 102))))
	else
		tgtpos = (ctrpos + Vector(AccuracyHorizmath, 0, (AccuracyVertmath + math.random(-5, 15))))
	end
elseif self.JackalSniper == true then
	tgtpos = eyepos - Vector(0, 0, 5)
end

if ( self:CanPrimaryAttackNPC() ) then
	local bullet = {}
		bullet.Num = self.Primary.NumShots
		bullet.Src = self.Owner:GetShootPos()
		if (npc:GetPos():Distance(tgt:GetPos()) > 150)  then -- if you're this close to a hostile NPC we cant properly do our artificial aiming and nothing will ever hit, so we resort to standard NPC accuracy.
			if muzzle == 0 then bullet.Dir = (tgtpos - npc:EyePos()):GetNormalized()
			else bullet.Dir = (tgtpos - self.Weapon:GetAttachment(muzzle).Pos):GetNormalized() end
		else
			bullet.Dir = npc:GetAimVector()
		end
		if self.JackalSniper == false then
			bullet.Spread = Vector( (self.Primary.Spread / self.Primary.SpreadDiv), (self.Primary.Spread / self.Primary.SpreadDiv), 0 )
		elseif self.JackalSniper == true then
			bullet.Spread = Vector(0, 0, 0)
		end
		bullet.Tracer = self.Primary.Tracer
		bullet.Force = self.Primary.Force
		bullet.Damage = self.Primary.Damage
		
	self.AmmoType = self.Primary.AmmoType	
	if self.Primary.Projectile == nil then
		self.Owner:FireBullets ( bullet )
	else
	local aim = self.Owner:GetAimVector()
	local side = aim:Cross(Vector(0,0,0))
	local up = side:Cross(aim)
	local pos = self.Owner:GetShootPos() + side * 0 + up * 0
		if SERVER then
			local proj = ents.Create(self.Primary.Projectile)
			if !proj:IsValid() then return false end
			proj:SetAngles(self.Owner:EyeAngles())
			proj:SetPos(pos)
			proj:SetOwner(self.Owner)
			proj:Spawn()
			proj.Owner = self.Owner
			proj:Activate()
			eyes = self.Owner:EyeAngles()
			local phys = proj:GetPhysicsObject()
			if self.Primary.ProjInheritVelocity == true then
				phys:SetVelocity((self.Owner:GetAimVector() * self.Primary.ProjSpeed) + ply:GetVelocity())
			else
				phys:SetVelocity(self.Owner:GetAimVector() * self.Primary.ProjSpeed)
			end
		end
	end
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	if self.Primary.NPCSound == nil then
		self.Weapon:EmitSound(Sound(self.Primary.Sound))
	else
		if self.Primary.NPCSound == nil then self.Weapon:EmitSound(Sound(self.Primary.Sound))
		else self.Weapon:EmitSound(Sound(self.Primary.NPCSound)) end
	end
		self:TakePrimaryAmmo( self.Primary.APS )
		self:SetNWInt("Heat", (self:GetNWInt("Heat") + self.HPS))
		if self.LowerRPMWithHeat == true then
			self:SetNextPrimaryFire ( CurTime() + math.Clamp(((heat * 2) / self.Primary.RPM), (60 / self.Primary.RPM), (60 / self.HeatRPMmin)) )
		else
			self:SetNextPrimaryFire ( CurTime() + (60 / self.Primary.RPM) )
		end
		self:MuzzleFlash()
		self:ShootEffects()
	else return end
end