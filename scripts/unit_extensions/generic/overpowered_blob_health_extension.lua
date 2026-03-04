-- chunkname: @scripts/unit_extensions/generic/overpowered_blob_health_extension.lua

OverpoweredBlobHealthExtension = class(OverpoweredBlobHealthExtension, GenericHealthExtension)

OverpoweredBlobHealthExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, ...)
	OverpoweredBlobHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, ...)

	arg_1_0.target_unit = arg_1_3.target_unit
	arg_1_0.death_time = Managers.time:time("game") + (arg_1_3.life_time or math.huge)
	arg_1_0.bots_can_do_damage = true
end

OverpoweredBlobHealthExtension.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = ScriptUnit.has_extension(arg_2_0.target_unit, "status_system")

	if not var_2_0 or not var_2_0.overpowered or arg_2_3 > arg_2_0.death_time then
		Managers.state.unit_spawner:mark_for_deletion(arg_2_0.unit)
	end
end

OverpoweredBlobHealthExtension.destroy = function (arg_3_0)
	if not Unit.alive(arg_3_0.target_unit) then
		return
	end

	if ScriptUnit.has_extension(arg_3_0.target_unit, "status_system") then
		StatusUtils.set_overpowered_network(arg_3_0.target_unit, false)
	end
end
