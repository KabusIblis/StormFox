AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/props_c17/lamppost03a_off_dynamic.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )

	self.RenderMode = 1

	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(Color(255,255,255))
	self.on = false
	self.lastT = SysTime() + 7
end

ENT.Use = StormFox.MakeEntityPersistance

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * -0.5

	local ent = ents.Create( ClassName )
	local ang = (ply:GetPos() - SpawnPos):Angle().y - 90
	ent:SetPos( SpawnPos )
	ent:SetAngles(Angle(0,ang,0))
	ent:Spawn()
	ent:Activate()

	ply:PrintMessage( HUD_PRINTCENTER, "Press E to make persistent" )

	return ent

end

function ENT:Think()
	if (self.lastT or 0) > SysTime() + 20 then
		self.lastT = 0
	end
	if (self.lastT or 0) > SysTime() then return end
		self.lastT = SysTime() + math.random(5,7)
	--local on = StormFox.GetDaylightAmount() <= 0.4
	local on = StormFox.GetData("MapLight",100) < 20
	if self:GetModel() == "models/props_c17/lamppost03a_off_dynamic.mdl" and on then
		self.on = true
		self:DrawShadow(false)
		self:SetModel("models/props_c17/lamppost03a_on.mdl")
	elseif self.on and not on then
		self:SetModel( "models/props_c17/lamppost03a_off_dynamic.mdl" )
		self.on = false
		self:DrawShadow(true)
		if self.flashlight then
			self.flashlight:Remove()
		end
	end
end