-- chunkname: @scripts/unit_extensions/generic/overpowered_blob_health_extension.lua

OverpoweredBlobHealthExtension = class(OverpoweredBlobHealthExtension, GenericHealthExtension)

OverpoweredBlobHealthExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3, ...)
	-- function 1
	OverpoweredBlobHealthExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3, ...)

	self.target_unit = arg_1_3.target_unit

	local time = Managers.time:time("game")
	local life_time = arg_1_3.life_time

	life_time = life_time or math.huge
	self.death_time = time + life_time
	self.bots_can_do_damage = true
end

OverpoweredBlobHealthExtension.update = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local has_extension = ScriptUnit.has_extension(self.target_unit, "status_system")

	if not (not has_extension and not has_extension.overpowered and not (arg_2_3 > self.death_time)) then
		Managers.state.unit_spawner:mark_for_deletion(self.unit)
	end
end

OverpoweredBlobHealthExtension.destroy = function (self)
	-- function 3
	if not Unit.alive(self.target_unit) then
		return
	end

	if not ScriptUnit.has_extension(self.target_unit, "status_system") then
		StatusUtils.set_overpowered_network(self.target_unit, false)
	end
end
