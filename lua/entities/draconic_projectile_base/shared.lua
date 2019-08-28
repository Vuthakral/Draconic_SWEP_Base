ENT.Type 			= "anim"
ENT.PrintName		= "Draconic Projectile Base"
ENT.Author			= "Vuthakral"
ENT.Information		= ""
ENT.Category		= "Draconic Projectiles"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Damage 	= 25
ENT.Mass	= 1
ENT.Force	= 5
ENT.Gravity = true
ENT.ProjectileType = "point"
ENT.ExplodeShakePower = 25
ENT.ExplodeShakeTime  = 0.5	
ENT.ExplodeShakeDistance = 500

function ENT:Think()
	local vel = self:GetVelocity()
	if vel == vector_origin then return end
	local tr = util.TraceLine({start=self:GetPos(), endpos=self:GetPos() + vel:GetNormal() * 20, filter={self, self:GetOwner()}, mask=MASK_SHOT_HULL})
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_OBB)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	
	if self.Gravity == false then
		phys:EnableGravity(false)
	else end
	
	self:DoCustomInitialize()
end

function ENT:DoCustomInitialize()
end

function ENT:PhysicsCollide( data, phys )
local type = self.ProjectileType
local tgt = data.HitEntity

	if tgt:IsWorld() == false then
		if type == "point" then
			local tr = util.TraceLine({start=self:GetPos(), endpos=tgt:LocalToWorld(tgt:OBBCenter()), filter={self, self:GetOwner()}, mask=MASK_SHOT_HULL})
			self:DamageTarget(tgt, tr)
		elseif type == "explosive" then
			self:Explode()
		end
	elseif tgt:IsWorld() then
		if type == "point" then
			timer.Simple(0.01, function() self:Remove() end)
		elseif type == "explosive" then
			self:Explode()
		end
	end
end

function ENT:DamageTarget(tgt, tr)
	local dmg = DamageInfo()
	dmg:SetDamage(self.Damage)
	dmg:SetAttacker(self:GetOwner())
	dmg:SetInflictor(self)
	dmg:SetDamageForce(self:EyeAngles():Forward())
	dmg:SetDamagePosition(self:GetPos())
	dmg:SetDamageType(DMG_GENERIC)
	
	local ang = Angle(0,0,0) + tr.Normal:Angle()
	tgt:DispatchTraceAttack(dmg, self:GetPos() + ang:Forward() * 3, tgt:GetPos()) -- this code is taken from the TTT knife because I have no fucking clue how this works
	
	timer.Simple(0.01, function() self:Remove() end)
end

function ENT:Explode()
	if self:GetOwner() != nil then
		self.explosion = self:GetOwner()
	else
		self.explosion = self
	end
	self:EmitSound("draconic.ExplosionSmallGeneric")
	local explo = ents.Create("env_explosion")
		explo:SetOwner(self.explosion)
		explo:SetPos(self.Entity:GetPos())
		explo:SetKeyValue("iMagnitude", "25")
		explo:SetKeyValue("radius", "200")
		explo:Spawn()
		explo:Activate()
		explo:Fire("Explode", "", 0)
	util.BlastDamage(self, self.explosion, self:GetPos(), 120, self.Damage)
	util.ScreenShake( Vector( self:GetPos() ), (self.ExplodeShakePower / 2), self.ExplodeShakePower, self.ExplodeShakeTime, self.ExplodeShakeDistance )
	timer.Simple(0.01, function() self:Remove() end)
end