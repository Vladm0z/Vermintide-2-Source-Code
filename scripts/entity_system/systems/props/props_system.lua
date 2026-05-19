-- chunkname: @scripts/entity_system/systems/props/props_system.lua

require("scripts/settings/level_settings")
require("scripts/settings/perlin_light_configurations")
require("scripts/unit_extensions/level/rotating_hazard_extension")

PropsSystem = class(PropsSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_thorn_bush_trigger_area_damage",
	"rpc_thorn_bush_trigger_despawn",
	"rpc_sync_rotating_hazard"
}
local var_0_1 = {
	"PerlinLightExtension",
	"BotNavTransitionExtension",
	"QuestChallengePropExtension",
	"ThornMutatorExtension",
	"ScaleUnitExtension",
	"StoreDisplayItemGizmoExtension",
	"RotatingHazardExtension",
	"EventUpsellPropExtension"
}

DLCUtils.append("prop_extension", var_0_1)

function PropsSystem.init(arg_1_0, arg_1_1, arg_1_2)
	PropsSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	for iter_1_0, iter_1_1 in pairs(PerlinLightConfigurations) do
		Light.add_flicker_configuration(iter_1_0, iter_1_1.persistance, iter_1_1.octaves, iter_1_1.min_value, iter_1_1.frequency_multiplier, iter_1_1.translation.persistance, iter_1_1.translation.octaves, iter_1_1.translation.jitter_multiplier_xy, iter_1_1.translation.jitter_multiplier_z, iter_1_1.translation.frequency_multiplier)
	end

	PerlinLightConfigurations_reload = false
	arg_1_0._extensions = {}
	arg_1_0._network_event_delegate = arg_1_1.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_0))
end

function PropsSystem.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0

	if arg_2_3 == "PerlinLightExtension" then
		local var_2_1 = Unit.get_data(arg_2_2, "flicker_config")
		local var_2_2

		if Unit.has_data(arg_2_2, "perlin_light_node_name") then
			local var_2_3 = Unit.get_data(arg_2_2, "perlin_light_node_name")

			if Unit.has_light(arg_2_2, var_2_3) then
				var_2_2 = Unit.light(arg_2_2, var_2_3)
			end
		end

		if var_2_2 == nil then
			var_2_2 = Unit.light(arg_2_2, 0)
		end

		Light.set_flicker_type(var_2_2, var_2_1)

		var_2_0 = {}
	else
		if arg_2_3 == "ThornSisterWallExtension" and arg_2_0.is_server then
			Managers.level_transition_handler.transient_package_loader:add_unit(arg_2_2)
		end

		var_2_0 = PropsSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	end

	arg_2_0._extensions[arg_2_2] = var_2_0

	return var_2_0
end

function PropsSystem.destroy(arg_3_0)
	arg_3_0._network_event_delegate:unregister(arg_3_0)
end

function PropsSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_2 ~= "PerlinLightExtension" then
		if arg_4_2 == "ThornSisterWallExtension" and arg_4_0.is_server then
			Managers.level_transition_handler.transient_package_loader:remove_unit(arg_4_1)
		end

		PropsSystem.super.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	end
end

function PropsSystem.update(arg_5_0, arg_5_1, arg_5_2)
	PropsSystem.super.update(arg_5_0, arg_5_1, arg_5_2)
end

function PropsSystem.rpc_thorn_bush_trigger_area_damage(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.state.unit_storage:unit(arg_6_2)
	local var_6_1 = ScriptUnit.extension(var_6_0, "props_system")

	if var_6_1 then
		var_6_1:trigger_area_damage()
	end
end

function PropsSystem.rpc_thorn_bush_trigger_despawn(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Managers.state.unit_storage:unit(arg_7_2)
	local var_7_1 = ScriptUnit.extension(var_7_0, "props_system")
	local var_7_2 = Managers.world:world("level_world")

	WwiseUtils.trigger_unit_event(var_7_2, "Play_winds_life_gameplay_thorn_hit_player", var_7_0, 0)

	if var_7_1 then
		var_7_1:despawn()
	end
end

function PropsSystem.rpc_sync_rotating_hazard(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	local var_8_0 = Managers.state.network:game_object_or_level_unit(arg_8_2, arg_8_3)

	arg_8_0._extensions[var_8_0]:network_sync(arg_8_4, arg_8_5, arg_8_6, arg_8_7)
end
