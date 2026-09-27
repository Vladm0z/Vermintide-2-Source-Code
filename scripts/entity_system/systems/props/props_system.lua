-- chunkname: @scripts/entity_system/systems/props/props_system.lua

require("scripts/settings/level_settings")
require("scripts/settings/perlin_light_configurations")
require("scripts/unit_extensions/level/rotating_hazard_extension")

PropsSystem = class(PropsSystem, ExtensionSystemBase)

local tbl = {
	"rpc_thorn_bush_trigger_area_damage",
	"rpc_thorn_bush_trigger_despawn",
	"rpc_sync_rotating_hazard"
}
local tbl_2 = {
	"PerlinLightExtension",
	"BotNavTransitionExtension",
	"QuestChallengePropExtension",
	"ThornMutatorExtension",
	"ScaleUnitExtension",
	"StoreDisplayItemGizmoExtension",
	"RotatingHazardExtension",
	"EventUpsellPropExtension"
}

DLCUtils.append("prop_extension", tbl_2)

PropsSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	PropsSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	for k, v in pairs(PerlinLightConfigurations) do
		Light.add_flicker_configuration(k, v.persistance, v.octaves, v.min_value, v.frequency_multiplier, v.translation.persistance, v.translation.octaves, v.translation.jitter_multiplier_xy, v.translation.jitter_multiplier_z, v.translation.frequency_multiplier)
	end

	PerlinLightConfigurations_reload = false
	self._extensions = {}
	self._network_event_delegate = arg_1_1.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl))
end

PropsSystem.on_add_extension = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local var_2_0

	if arg_2_3 == "PerlinLightExtension" then
		local get_data = Unit.get_data(arg_2_2, "flicker_config")
		local var_2_2

		if not Unit.has_data(arg_2_2, "perlin_light_node_name") then
			local get_data_2 = Unit.get_data(arg_2_2, "perlin_light_node_name")

			if not Unit.has_light(arg_2_2, get_data_2) then
				var_2_2 = Unit.light(arg_2_2, get_data_2)
			end
		end

		if var_2_2 == nil then
			var_2_2 = Unit.light(arg_2_2, 0)
		end

		Light.set_flicker_type(var_2_2, get_data)

		var_2_0 = {}
	else
		if arg_2_3 ~= "ThornSisterWallExtension" or not self.is_server then
			Managers.level_transition_handler.transient_package_loader:add_unit(arg_2_2)
		end

		var_2_0 = PropsSystem.super.on_add_extension(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	end

	self._extensions[arg_2_2] = var_2_0

	return var_2_0
end

PropsSystem.destroy = function (self)
	-- function 3
	self._network_event_delegate:unregister(self)
end

PropsSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	if arg_4_2 ~= "PerlinLightExtension" then
		if arg_4_2 ~= "ThornSisterWallExtension" or not self.is_server then
			Managers.level_transition_handler.transient_package_loader:remove_unit(arg_4_1)
		end

		PropsSystem.super.on_remove_extension(self, arg_4_1, arg_4_2)
	end
end

PropsSystem.update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	PropsSystem.super.update(arg_5_0, arg_5_1, arg_5_2)
end

PropsSystem.rpc_thorn_bush_trigger_area_damage = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local unit = Managers.state.unit_storage:unit(arg_6_2)
	local extension = ScriptUnit.extension(unit, "props_system")

	if not extension then
		extension:trigger_area_damage()
	end
end

PropsSystem.rpc_thorn_bush_trigger_despawn = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local unit = Managers.state.unit_storage:unit(arg_7_2)
	local extension = ScriptUnit.extension(unit, "props_system")
	local world = Managers.world:world("level_world")

	WwiseUtils.trigger_unit_event(world, "Play_winds_life_gameplay_thorn_hit_player", unit, 0)

	if not extension then
		extension:despawn()
	end
end

PropsSystem.rpc_sync_rotating_hazard = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	-- function 8
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_8_2, arg_8_3)

	self._extensions[game_object_or_level_unit]:network_sync(arg_8_4, arg_8_5, arg_8_6, arg_8_7)
end
