-- chunkname: @scripts/entity_system/systems/props/end_zone_system.lua

EndZoneSystem = class(EndZoneSystem, ExtensionSystemBase)

local tbl = {
	"EndZoneExtension"
}

EndZoneSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	PropsSystem.super.init(arg_1_0, arg_1_1, arg_1_2, tbl)
end

EndZoneSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	return PropsSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
end

EndZoneSystem.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	PropsSystem.super.on_remove_extension(arg_3_0, arg_3_1, arg_3_2)
end

EndZoneSystem.update = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	PropsSystem.super.update(arg_4_0, arg_4_1, arg_4_2)
end

EndZoneSystem.activate_end_zone_by_name = function (arg_5_0, arg_5_1)
	-- function 5
	if not Managers.player.is_server then
		return
	end

	local get_entities = Managers.state.entity:get_entities("EndZoneExtension")
	local get_data = Unit.get_data

	for k, v in pairs(get_entities) do
		local var_5_2 = get_data(k, "activation_name")

		if not (not var_5_2 and var_5_2 ~= arg_5_1) then
			local world_position = Unit.world_position(k, 0)
			local str = "units/hub_elements/objective_unit"
			local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "objective_unit", nil, world_position)

			ScriptUnit.extension(spawn_network_unit, "tutorial_system"):set_active(true)
			v:activation_allowed(true)
		end
	end
end
