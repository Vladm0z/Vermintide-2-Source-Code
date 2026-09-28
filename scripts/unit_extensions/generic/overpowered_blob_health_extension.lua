-- chunkname: @scripts/unit_extensions/generic/overpowered_blob_health_extension.lua

OverpoweredBlobHealthExtension = class(OverpoweredBlobHealthExtension, GenericHealthExtension)

OverpoweredBlobHealthExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	-- function 1
	OverpoweredBlobHealthExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self.target_unit = extension_init_data.target_unit

	local t = Managers.time:time("game")
	local life_time = extension_init_data.life_time

	life_time = not not life_time or not not math.huge
	self.death_time = t + life_time
	self.bots_can_do_damage = true
end

OverpoweredBlobHealthExtension.update = function (self, dt, context, t)
	-- function 2
	local target_status_ext = ScriptUnit.has_extension(self.target_unit, "status_system")

	if not target_status_ext or not target_status_ext.overpowered or t > self.death_time then
		Managers.state.unit_spawner:mark_for_deletion(self.unit)
	end
end

OverpoweredBlobHealthExtension.destroy = function (self)
	-- function 3
	if not Unit.alive(self.target_unit) then
		return
	end

	local target_status_ext = ScriptUnit.has_extension(self.target_unit, "status_system")

	if target_status_ext then
		StatusUtils.set_overpowered_network(self.target_unit, false)
	end
end
