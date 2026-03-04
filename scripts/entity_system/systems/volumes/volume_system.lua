-- chunkname: @scripts/entity_system/systems/volumes/volume_system.lua

require("scripts/settings/volume_settings")
require("scripts/unit_extensions/generic/generic_volume_templates")

VolumeSystem = class(VolumeSystem, ExtensionSystemBase)

local var_0_0 = {
	"PlayerVolumeExtension",
	"BotVolumeExtension",
	"AIVolumeExtension",
	"PickupProjectileVolumeExtension",
	"LocalPlayerVolumeExtension"
}

function VolumeSystem.init(arg_1_0, arg_1_1, arg_1_2)
	VolumeSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0._volume_system = EngineOptimizedExtensions.volume_init_system(arg_1_0._volume_system, VolumeSystemSettings.updates_per_frame)
	arg_1_0.nav_tag_volume_handler = nil
	arg_1_0.nav_tag_volumes_to_create = {}
	arg_1_0._unit_dead_cbs = {}
end

function VolumeSystem.destroy(arg_2_0)
	VolumeSystem.super.destroy(arg_2_0)
	EngineOptimizedExtensions.volume_destroy_system(arg_2_0._volume_system)

	arg_2_0._volume_system = nil
	arg_2_0.nav_tag_volume_handler = nil
	arg_2_0.nav_tag_volumes_to_create = nil
end

local var_0_1 = {}

function VolumeSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	fassert(arg_3_0.is_server or arg_3_3 == "LocalPlayerVolumeExtension", "Only LocalPlayerVolumeExtension is allowed on clients!")
	EngineOptimizedExtensions.volume_on_add_extension(arg_3_0._volume_system, arg_3_2, arg_3_3)
	ScriptUnit.set_extension(arg_3_2, arg_3_0.name, var_0_1)

	return var_0_1
end

function VolumeSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_cleanup_extension(arg_4_1, arg_4_2)
end

function VolumeSystem.on_freeze_extension(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_cleanup_extension(arg_5_1, arg_5_2)
end

function VolumeSystem.freeze(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0:_cleanup_extension(arg_6_1, arg_6_2)
end

function VolumeSystem.unfreeze(arg_7_0, arg_7_1, arg_7_2)
	EngineOptimizedExtensions.volume_on_add_extension(arg_7_0._volume_system, arg_7_1, arg_7_2)
	ScriptUnit.set_extension(arg_7_1, arg_7_0.name, var_0_1)
end

function VolumeSystem._cleanup_extension(arg_8_0, arg_8_1, arg_8_2)
	if ScriptUnit.has_extension(arg_8_1, "volume_system") == nil then
		return
	end

	local var_8_0 = arg_8_0._unit_dead_cbs[arg_8_1]

	if var_8_0 then
		var_8_0()

		arg_8_0._unit_dead_cbs[arg_8_1] = nil
	end

	EngineOptimizedExtensions.volume_on_remove_extension(arg_8_0._volume_system, arg_8_1, arg_8_2)
	ScriptUnit.remove_extension(arg_8_1, arg_8_0.name)
end

function VolumeSystem.update(arg_9_0, arg_9_1, arg_9_2)
	EngineOptimizedExtensions.volume_update(arg_9_0._volume_system, arg_9_2, arg_9_1.dt)
end

function VolumeSystem.register_volume(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = LevelHelper:current_level(arg_10_0.world)

	fassert(Level.has_volume(var_10_0, arg_10_1), "No volume named %q exists in current level", arg_10_1)

	local var_10_1 = arg_10_3.sub_type

	for iter_10_0, iter_10_1 in ipairs(var_0_0) do
		local var_10_2 = VolumeExtensionSettings[arg_10_2][var_10_1][iter_10_1]

		if var_10_2 then
			local var_10_3 = {
				volume_name = arg_10_1,
				volume_type = arg_10_2,
				level = var_10_0,
				params = arg_10_3,
				settings = var_10_2,
				inverted = arg_10_3.invert_volume
			}
			local var_10_4
			local var_10_5

			if GenericVolumeTemplates.functions and GenericVolumeTemplates.functions[var_10_3.volume_type] and GenericVolumeTemplates.functions[var_10_3.volume_type][var_10_3.params.sub_type] then
				var_10_4 = GenericVolumeTemplates.functions[var_10_3.volume_type][var_10_3.params.sub_type].on_enter
				var_10_5 = GenericVolumeTemplates.functions[var_10_3.volume_type][var_10_3.params.sub_type].on_exit
			end

			local var_10_6 = var_10_2.filter

			EngineOptimizedExtensions.volume_register_volume(arg_10_0._volume_system, var_10_0, arg_10_1, iter_10_1, arg_10_3.invert_volume, var_10_3, var_10_4, var_10_5, var_10_6)
		end
	end

	if not LEVEL_EDITOR_TEST then
		local var_10_7 = VolumeSystemSettings.nav_tag_layer_costs

		var_10_7 = var_10_7[arg_10_2] and var_10_7[arg_10_2][var_10_1]

		if var_10_7 then
			local var_10_8 = arg_10_2 .. "_" .. var_10_1

			if arg_10_0.nav_tag_volume_handler then
				arg_10_0:create_nav_tag_volume(arg_10_1, var_10_8, var_10_7)
			else
				local var_10_9 = arg_10_0.nav_tag_volumes_to_create

				var_10_9[#var_10_9 + 1] = {
					volume_name = arg_10_1,
					layer_name = var_10_8,
					layer_costs = var_10_7
				}
			end
		end
	end
end

function VolumeSystem.unregister_volume(arg_11_0, arg_11_1)
	local var_11_0 = LevelHelper:current_level(arg_11_0.world)

	fassert(Level.has_volume(var_11_0, arg_11_1), "No volume named %q exists in current level", arg_11_1)

	for iter_11_0, iter_11_1 in ipairs(var_0_0) do
		EngineOptimizedExtensions.volume_unregister_volume(arg_11_0._volume_system, var_11_0, arg_11_1, iter_11_1)
	end
end

function VolumeSystem.ai_ready(arg_12_0)
	arg_12_0.nav_tag_volume_handler = Managers.state.conflict.nav_tag_volume_handler

	local var_12_0 = arg_12_0.nav_tag_volumes_to_create

	for iter_12_0 = 1, #var_12_0 do
		local var_12_1 = var_12_0[iter_12_0]

		arg_12_0:create_nav_tag_volume(var_12_1.volume_name, var_12_1.layer_name, var_12_1.layer_costs)
	end

	arg_12_0.nav_tag_volumes_to_create = nil
end

function VolumeSystem.create_nav_tag_volume_from_data(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if LevelHelper:current_level_settings().no_bots_allowed then
		return
	end

	local var_13_0 = arg_13_0.nav_tag_volume_handler
	local var_13_1 = var_13_0:create_mapping(arg_13_1, arg_13_2, arg_13_3)

	var_13_0:create_tag_volume_from_mappings(var_13_1)

	return var_13_1
end

function VolumeSystem.get_volume_mapping_from_lookup_id(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.nav_tag_volume_handler

	return arg_14_0.nav_tag_volume_handler:get_mapping_from_lookup_id(arg_14_1)
end

function VolumeSystem.destroy_nav_tag_volume(arg_15_0, arg_15_1)
	arg_15_0.nav_tag_volume_handler:destroy_nav_tag_volume(arg_15_1)
end

function VolumeSystem.create_nav_tag_volume(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if LevelHelper:current_level_settings().no_bots_allowed then
		return
	end

	local var_16_0 = arg_16_0.nav_tag_volume_handler

	var_16_0:set_mapping_layer_name(arg_16_1, arg_16_2)
	var_16_0:create_tag_volume_from_mappings(arg_16_1)

	local var_16_1 = Managers.state.entity
	local var_16_2 = arg_16_3.BotVolumeExtension
	local var_16_3 = arg_16_3.AIVolumeExtension

	if var_16_2 then
		NAV_TAG_VOLUME_LAYER_COST_BOTS[arg_16_2] = var_16_2

		Managers.state.bot_nav_transition:set_layer_cost(arg_16_2, var_16_2)
	end

	if var_16_3 then
		NAV_TAG_VOLUME_LAYER_COST_AI[arg_16_2] = var_16_3

		local var_16_4 = var_16_1:get_entities("AINavigationExtension")

		for iter_16_0, iter_16_1 in pairs(var_16_4) do
			iter_16_1:set_layer_cost(arg_16_2, var_16_3)
		end
	end
end

function VolumeSystem.volume_has_units_inside(arg_17_0, arg_17_1)
	return EngineOptimizedExtensions.volume_has_any_units_inside(arg_17_0._volume_system, arg_17_1)
end

function VolumeSystem.any_alive_human_players_inside(arg_18_0, arg_18_1)
	local var_18_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

	for iter_18_0, iter_18_1 in ipairs(var_18_0) do
		local var_18_1 = Unit.alive(iter_18_1) and ScriptUnit.has_extension(iter_18_1, "status_system")

		if var_18_1 and not var_18_1:is_disabled() and EngineOptimizedExtensions.volume_has_all_units_inside(arg_18_0._volume_system, arg_18_1, iter_18_1) then
			return true
		end
	end

	return false
end

function VolumeSystem.all_alive_human_players_inside(arg_19_0, arg_19_1)
	local var_19_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	local var_19_1 = 0
	local var_19_2 = {}

	for iter_19_0, iter_19_1 in ipairs(var_19_0) do
		local var_19_3 = Unit.alive(iter_19_1) and ScriptUnit.has_extension(iter_19_1, "status_system")

		if var_19_3 and not var_19_3:is_disabled() then
			var_19_1 = var_19_1 + 1
			var_19_2[var_19_1] = iter_19_1
		end
	end

	if var_19_1 ~= 0 then
		return EngineOptimizedExtensions.volume_has_all_units_inside(arg_19_0._volume_system, arg_19_1, unpack(var_19_2))
	end

	return false
end

function VolumeSystem.all_alive_or_respawned_human_players_inside(arg_20_0, arg_20_1)
	local var_20_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	local var_20_1 = 0
	local var_20_2 = {}

	for iter_20_0, iter_20_1 in ipairs(var_20_0) do
		local var_20_3 = Unit.alive(iter_20_1) and ScriptUnit.has_extension(iter_20_1, "status_system")

		if var_20_3 and (not var_20_3:is_disabled() or var_20_3:is_disabled() and not var_20_3:is_ready_for_assisted_respawn()) then
			var_20_1 = var_20_1 + 1
			var_20_2[var_20_1] = iter_20_1
		end
	end

	if var_20_1 ~= 0 then
		return EngineOptimizedExtensions.volume_has_all_units_inside(arg_20_0._volume_system, arg_20_1, unpack(var_20_2))
	end

	return false
end

function VolumeSystem.all_human_players_inside_disabled(arg_21_0, arg_21_1)
	local var_21_0 = Managers.player:human_players()
	local var_21_1 = 0
	local var_21_2 = {}

	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		local var_21_3 = iter_21_1.player_unit
		local var_21_4 = Unit.alive(var_21_3) and ScriptUnit.has_extension(var_21_3, "status_system")

		if var_21_4 then
			if not var_21_4:is_disabled() then
				return false
			end

			var_21_1 = var_21_1 + 1
			var_21_2[var_21_1] = var_21_3
		end
	end

	if var_21_1 ~= 0 then
		return EngineOptimizedExtensions.volume_has_all_units_inside(arg_21_0._volume_system, arg_21_1, unpack(var_21_2))
	end

	return false
end

function VolumeSystem.player_inside(arg_22_0, arg_22_1, arg_22_2)
	return EngineOptimizedExtensions.volume_has_all_units_inside(arg_22_0._volume_system, arg_22_1, arg_22_2)
end

function VolumeSystem.register_track_unit_dead(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0._unit_dead_cbs[arg_23_1] = arg_23_2
end

function VolumeSystem.unregister_track_unit_dead(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0._unit_dead_cbs[arg_24_1] = nil
end
