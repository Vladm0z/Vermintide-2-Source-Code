-- chunkname: @scripts/entity_system/systems/props/end_zone_system.lua

EndZoneSystem = class(EndZoneSystem, ExtensionSystemBase)

local var_0_0 = {
	"EndZoneExtension"
}

EndZoneSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	PropsSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)
end

EndZoneSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	return PropsSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
end

EndZoneSystem.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2)
	PropsSystem.super.on_remove_extension(arg_3_0, arg_3_1, arg_3_2)
end

EndZoneSystem.update = function (arg_4_0, arg_4_1, arg_4_2)
	PropsSystem.super.update(arg_4_0, arg_4_1, arg_4_2)
end

EndZoneSystem.activate_end_zone_by_name = function (arg_5_0, arg_5_1)
	if not Managers.player.is_server then
		return
	end

	local var_5_0 = Managers.state.entity:get_entities("EndZoneExtension")
	local var_5_1 = Unit.get_data

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		local var_5_2 = var_5_1(iter_5_0, "activation_name")

		if var_5_2 and var_5_2 == arg_5_1 then
			local var_5_3 = Unit.world_position(iter_5_0, 0)
			local var_5_4 = "units/hub_elements/objective_unit"
			local var_5_5 = Managers.state.unit_spawner:spawn_network_unit(var_5_4, "objective_unit", nil, var_5_3)

			ScriptUnit.extension(var_5_5, "tutorial_system"):set_active(true)
			iter_5_1:activation_allowed(true)
		end
	end
end
