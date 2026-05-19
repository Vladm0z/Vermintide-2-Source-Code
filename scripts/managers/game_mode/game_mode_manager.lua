-- chunkname: @scripts/managers/game_mode/game_mode_manager.lua

require("scripts/settings/game_mode_settings")
require("scripts/managers/game_mode/game_mode_helper")
require("scripts/managers/game_mode/game_modes/game_mode_adventure")
require("scripts/managers/game_mode/game_modes/game_mode_survival")
require("scripts/managers/game_mode/game_modes/game_mode_tutorial")
require("scripts/managers/game_mode/game_modes/game_mode_inn")
require("scripts/managers/game_mode/game_modes/game_mode_demo")
require("scripts/managers/game_mode/game_modes/game_mode_weave")
require("scripts/managers/game_mode/mutator_handler")
require("scripts/managers/game_mode/horde_surge_handler")
DLCUtils.require_list("game_mode_files")

local var_0_0 = {
	"rpc_is_ready_for_transition",
	"rpc_apply_environment_variation",
	"rpc_change_game_mode_state",
	"rpc_trigger_level_event"
}
local var_0_1 = script_data.testify and require("scripts/managers/game_mode/game_mode_manager_testify")
local var_0_2 = {}

for iter_0_0, iter_0_1 in pairs(GameModeSettings) do
	local var_0_3 = {}

	for iter_0_2, iter_0_3 in ipairs(iter_0_1.game_mode_states) do
		var_0_3[iter_0_2] = iter_0_3
		var_0_3[iter_0_3] = iter_0_2
	end

	var_0_2[iter_0_0] = var_0_3
end

GameModeManager = class(GameModeManager)

function GameModeManager.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	local var_1_0 = Managers.level_transition_handler:get_current_level_keys()
	local var_1_1 = arg_1_2.is_host

	arg_1_0._lobby_host = var_1_1 and arg_1_2
	arg_1_0._lobby_client = var_1_1 and arg_1_2
	arg_1_0.is_server = var_1_1
	arg_1_0._world = arg_1_1
	arg_1_0._game_mode_key = arg_1_5
	arg_1_0._level_key = var_1_0
	arg_1_0._end_conditions_met = false
	arg_1_0._gm_event_end_conditions_met = false
	arg_1_0._round_started = false
	arg_1_0._end_reason = nil
	arg_1_0._ready_for_transition = nil
	arg_1_0.statistics_db = arg_1_4
	arg_1_0._network_handler = arg_1_6
	arg_1_0._network_transmit = arg_1_7
	arg_1_0._profile_synchronizer = arg_1_8
	arg_1_0._have_signalled_ready_to_transition = false

	arg_1_0:_init_game_mode(arg_1_5, arg_1_9)

	local var_1_2 = Managers.state.event

	var_1_2:register(arg_1_0, "reload_application_settings", "event_reload_application_settings")
	var_1_2:register(arg_1_0, "gm_event_round_started", "gm_event_round_started")
	var_1_2:register(arg_1_0, "camera_teleported", "event_camera_teleported")

	arg_1_0.network_event_delegate = arg_1_3

	arg_1_3:register(arg_1_0, unpack(var_0_0))
	arg_1_0._game_mode:register_rpcs(arg_1_3, arg_1_7)

	arg_1_0._object_sets = nil
	arg_1_0._object_set_names = nil

	local var_1_3 = 8192

	arg_1_0._flow_set_data = {
		units_per_frame = 150,
		write_index = 1,
		read_index = 1,
		size = 0,
		ring_buffer = Script.new_array(var_1_3),
		max_size = var_1_3
	}

	local var_1_4 = arg_1_0._game_mode:mutators()
	local var_1_5 = LevelSettings[arg_1_0._level_key].mutators

	if var_1_5 then
		var_1_4 = var_1_4 or {}

		for iter_1_0 = 1, #var_1_5 do
			var_1_4[#var_1_4 + 1] = var_1_5[iter_1_0]
		end
	end

	local var_1_6 = not DEDICATED_SERVER

	arg_1_0._mutator_handler = MutatorHandler:new(var_1_4, arg_1_0.is_server, arg_1_6, var_1_6, arg_1_1, arg_1_3, arg_1_7)
	arg_1_0._looping_event_timers = {}
	arg_1_0._disable_spawning_reasons = {}

	if arg_1_0.is_server then
		arg_1_0._initial_peers_ready = false
	end

	arg_1_0._has_created_game_mode_data = false
	arg_1_0._locked_profile_index = nil
end

function GameModeManager.destroy(arg_2_0)
	arg_2_0._mutator_handler:destroy()

	arg_2_0._lobby_host = nil
	arg_2_0._lobby_client = nil

	arg_2_0._game_mode:unregister_rpcs()
	arg_2_0._game_mode:destroy()
	Managers.party:cleanup_game_mode_data()
	arg_2_0.network_event_delegate:unregister(arg_2_0)

	arg_2_0.network_event_delegate = nil
end

function GameModeManager.cleanup_game_mode_units(arg_3_0)
	arg_3_0._game_mode:cleanup_game_mode_units()
end

function GameModeManager.deactivate_mutators(arg_4_0, arg_4_1)
	arg_4_0._mutator_handler:deactivate_mutators(arg_4_1)
end

function GameModeManager.conflict_director_updated_settings(arg_5_0)
	arg_5_0._mutator_handler:conflict_director_updated_settings()
end

function GameModeManager.settings(arg_6_0)
	return GameModeSettings[arg_6_0._game_mode_key]
end

function GameModeManager.setting(arg_7_0, arg_7_1)
	return GameModeSettings[arg_7_0._game_mode_key][arg_7_1]
end

function GameModeManager.gm_event_end_conditions_met(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0._gm_event_end_conditions_met = true

	if arg_8_1 == "lost" then
		local var_8_0 = LevelHelper:current_level(arg_8_0._world)
		local var_8_1 = arg_8_0._game_mode_key .. "_round_lost"

		Level.trigger_event(var_8_0, var_8_1)
	end

	arg_8_0._game_mode:gm_event_end_conditions_met(arg_8_1, arg_8_2, arg_8_3)
	arg_8_0:_save_last_level_completed(arg_8_1)
end

function GameModeManager.is_game_mode_ended(arg_9_0)
	return arg_9_0._gm_event_end_conditions_met
end

function GameModeManager.setup_done(arg_10_0)
	arg_10_0._game_mode:setup_done()
	arg_10_0._mutator_handler:activate_mutators()
end

function GameModeManager.deactivate_mutator(arg_11_0, arg_11_1)
	arg_11_0._mutator_handler:deactivate_mutator(arg_11_1)
end

function GameModeManager.player_entered_game_session(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_0._game_mode:player_entered_game_session(arg_12_1, arg_12_2, arg_12_3)
end

function GameModeManager.remove_bot(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	return arg_13_0._game_mode:remove_bot(arg_13_1, arg_13_2, arg_13_3, arg_13_4)
end

function GameModeManager.player_left_game_session(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0._game_mode:player_left_game_session(arg_14_1, arg_14_2)
end

function GameModeManager.player_joined_party(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	arg_15_0._game_mode:player_joined_party(arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
end

function GameModeManager.player_left_party(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	arg_16_0._game_mode:player_left_party(arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
end

function GameModeManager.ai_killed(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	arg_17_0._mutator_handler:ai_killed(arg_17_1, arg_17_2, arg_17_3, arg_17_4)

	local var_17_0 = arg_17_0._game_mode

	if var_17_0.ai_killed then
		var_17_0:ai_killed(arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	end
end

function GameModeManager.level_object_killed(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0._mutator_handler:level_object_killed(arg_18_1, arg_18_2)
end

function GameModeManager.ai_hit_by_player(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_0._mutator_handler:ai_hit_by_player(arg_19_1, arg_19_2, arg_19_3)
end

function GameModeManager.player_hit(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0._mutator_handler:player_hit(arg_20_1, arg_20_2, arg_20_3)
end

function GameModeManager.modify_player_base_damage(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	return arg_21_0._mutator_handler:modify_player_base_damage(arg_21_1, arg_21_2, arg_21_3, arg_21_4)
end

function GameModeManager.player_respawned(arg_22_0, arg_22_1)
	arg_22_0._mutator_handler:player_respawned(arg_22_1)
end

function GameModeManager.damage_taken(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	arg_23_0._mutator_handler:damage_taken(arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
end

function GameModeManager.pre_ai_spawned(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0._mutator_handler:pre_ai_spawned(arg_24_1, arg_24_2)
end

function GameModeManager.ai_spawned(arg_25_0, arg_25_1)
	arg_25_0._mutator_handler:ai_spawned(arg_25_1)
end

function GameModeManager.post_ai_spawned(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	arg_26_0._mutator_handler:post_ai_spawned(arg_26_2, arg_26_3)
end

function GameModeManager.set_override_respawn_group(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_0._game_mode.set_override_respawn_group then
		arg_27_0._game_mode:set_override_respawn_group(arg_27_1, arg_27_2)
	end
end

function GameModeManager.set_respawn_group_enabled(arg_28_0, arg_28_1, arg_28_2)
	if arg_28_0._game_mode.set_respawn_group_enabled then
		arg_28_0._game_mode:set_respawn_group_enabled(arg_28_1, arg_28_2)
	end
end

function GameModeManager.set_respawn_gate_enabled(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_0._game_mode.set_respawn_gate_enabled then
		arg_29_0._game_mode:set_respawn_gate_enabled(arg_29_1, arg_29_2)
	end
end

function GameModeManager.players_left_safe_zone(arg_30_0)
	arg_30_0._mutator_handler:players_left_safe_zone()

	if arg_30_0._game_mode.players_left_safe_zone then
		arg_30_0._game_mode:players_left_safe_zone()
	end
end

function GameModeManager.has_activated_mutator(arg_31_0, arg_31_1)
	return arg_31_0._mutator_handler:has_activated_mutator(arg_31_1)
end

function GameModeManager.activated_mutators(arg_32_0)
	return arg_32_0._mutator_handler:activated_mutators()
end

function GameModeManager.has_mutator(arg_33_0, arg_33_1)
	return arg_33_0._mutator_handler:has_mutator(arg_33_1)
end

function GameModeManager.mutators(arg_34_0)
	return arg_34_0._mutator_handler:mutators()
end

function GameModeManager.initialized_mutator_map(arg_35_0)
	return arg_35_0._mutator_handler:initialized_mutator_map()
end

function GameModeManager.evaluate_end_zone_activation_conditions(arg_36_0)
	return arg_36_0._mutator_handler:evaluate_end_zone_activation_conditions()
end

function GameModeManager.post_process_terror_event(arg_37_0, arg_37_1)
	arg_37_0._mutator_handler:post_process_terror_event(arg_37_1)
end

function GameModeManager.bots_disabled(arg_38_0)
	return arg_38_0:settings().bots_disabled
end

function GameModeManager.get_saved_game_mode_data(arg_39_0)
	if arg_39_0._game_mode.get_saved_game_mode_data then
		return arg_39_0._game_mode:get_saved_game_mode_data()
	end
end

function GameModeManager.set_object_set_enabled(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0._object_sets[arg_40_1]

	if not var_40_0 then
		return
	end

	arg_40_0:_set_flow_object_set_enabled(var_40_0, arg_40_2, arg_40_1)
end

function GameModeManager._set_flow_object_set_enabled(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if arg_41_1.flow_set_enabled == arg_41_2 then
		return
	end

	local var_41_0 = LevelHelper:current_level(arg_41_0._world)

	arg_41_1.flow_set_enabled = arg_41_2

	local var_41_1 = arg_41_0._flow_set_data
	local var_41_2 = var_41_1.ring_buffer
	local var_41_3 = var_41_1.write_index
	local var_41_4 = var_41_1.read_index
	local var_41_5 = var_41_1.size
	local var_41_6 = var_41_1.max_size
	local var_41_7 = arg_41_1.units
	local var_41_8 = #var_41_7
	local var_41_9 = var_41_5 + var_41_8 - var_41_6

	if var_41_9 > 0 then
		local var_41_10 = math.min(var_41_9, var_41_5)

		for iter_41_0 = 1, var_41_10 do
			local var_41_11 = var_41_2[var_41_4]

			arg_41_0:_set_flow_object_set_unit_enabled(var_41_0, var_41_11)

			var_41_4 = var_41_4 % var_41_6 + 1
			var_41_5 = var_41_5 - 1
		end

		var_41_1.read_index = var_41_4
	end

	local var_41_12 = var_41_8 - var_41_6

	for iter_41_1, iter_41_2 in ipairs(var_41_7) do
		local var_41_13 = Level.unit_by_index(var_41_0, iter_41_2)

		if var_41_13 then
			local var_41_14 = Unit.get_data(var_41_13, "flow_object_set_references") or 1

			if arg_41_2 then
				var_41_14 = var_41_14 + 1
			else
				var_41_14 = math.max(var_41_14 - 1, 0)
			end

			Unit.set_data(var_41_13, "flow_object_set_references", var_41_14)

			if iter_41_1 <= var_41_12 then
				arg_41_0:_set_flow_object_set_unit_enabled(var_41_0, iter_41_2)
			else
				var_41_2[var_41_3] = iter_41_2
				var_41_3 = var_41_3 % var_41_6 + 1
				var_41_5 = var_41_5 + 1
			end
		end
	end

	var_41_1.write_index = var_41_3
	var_41_1.size = var_41_5
end

function GameModeManager.event_camera_teleported(arg_42_0)
	arg_42_0._flush_object_set_enable = 3
end

function GameModeManager.post_update(arg_43_0, arg_43_1, arg_43_2)
	if arg_43_0._game_mode.post_update then
		arg_43_0._game_mode:post_update(arg_43_1, arg_43_2)
	end
end

function GameModeManager.update_flow_object_set_enable(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0._flow_set_data
	local var_44_1 = var_44_0.size
	local var_44_2 = arg_44_0._flush_object_set_enable

	if var_44_1 > 0 then
		local var_44_3 = var_44_2 and math.huge or var_44_0.units_per_frame
		local var_44_4 = math.min(var_44_3, var_44_1)
		local var_44_5 = var_44_0.read_index
		local var_44_6 = var_44_0.max_size
		local var_44_7 = var_44_0.ring_buffer
		local var_44_8 = LevelHelper:current_level(arg_44_0._world)

		for iter_44_0 = 1, var_44_4 do
			local var_44_9 = var_44_7[var_44_5]

			arg_44_0:_set_flow_object_set_unit_enabled(var_44_8, var_44_9)

			var_44_5 = var_44_5 % var_44_6 + 1
			var_44_1 = var_44_1 - 1
		end

		var_44_0.size = var_44_1
		var_44_0.read_index = var_44_5
	end

	if var_44_2 and var_44_2 == 1 then
		arg_44_0._flush_object_set_enable = false
	elseif var_44_2 then
		arg_44_0._flush_object_set_enable = var_44_2 - 1
	end
end

local var_0_4 = Unit.get_data
local var_0_5 = Unit.flow_event

function GameModeManager._set_flow_object_set_unit_enabled(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = Level.unit_by_index(arg_45_1, arg_45_2)
	local var_45_1 = var_0_4(var_45_0, "flow_object_set_references")
	local var_45_2 = var_0_4(var_45_0, "flow_object_set_enabled")

	if var_45_2 == nil then
		var_45_2 = true
	end

	local var_45_3 = not var_45_2 and var_45_1 > 0
	local var_45_4 = var_45_2 and var_45_1 == 0
	local var_45_5

	if var_45_3 then
		var_45_5 = true
	elseif var_45_4 then
		var_45_5 = false
	end

	if var_45_5 ~= nil then
		Unit.set_data(var_45_0, "flow_object_set_enabled", var_45_5)

		if Unit.has_data(var_45_0, "LevelEditor", "is_gizmo_unit") then
			local var_45_6 = Unit.get_data(var_45_0, "LevelEditor", "is_gizmo_unit")
			local var_45_7 = Unit.is_a(var_45_0, "core/stingray_renderer/helper_units/reflection_probe/reflection_probe")

			if var_45_6 and not var_45_7 then
				Unit.set_unit_visibility(var_45_0, false)
			else
				Unit.set_unit_visibility(var_45_0, var_45_5)
			end
		else
			Unit.set_unit_visibility(var_45_0, var_45_5)
		end

		if arg_45_0._game_mode_key == "versus" and Unit.is_a(var_45_0, "core/volumetrics/units/fog_volume") then
			if var_45_5 then
				local var_45_8 = Unit.get_data(var_45_0, "FogProperties", "albedo", 0)
				local var_45_9 = Unit.get_data(var_45_0, "FogProperties", "albedo", 1)
				local var_45_10 = Unit.get_data(var_45_0, "FogProperties", "albedo", 2)
				local var_45_11 = Unit.get_data(var_45_0, "FogProperties", "falloff", 0)
				local var_45_12 = Unit.get_data(var_45_0, "FogProperties", "falloff", 1)
				local var_45_13 = Unit.get_data(var_45_0, "FogProperties", "falloff", 2)
				local var_45_14 = Unit.get_data(var_45_0, "FogProperties", "extinction")
				local var_45_15 = Unit.get_data(var_45_0, "FogProperties", "phase")

				Volumetrics.register_volume(var_45_0, Vector3(var_45_8, var_45_9, var_45_9), var_45_14, var_45_15, Vector3(var_45_11, var_45_12, var_45_13))
			else
				Volumetrics.unregister_volume(var_45_0)
			end
		end

		if Unit.has_visibility_group(var_45_0, "gizmo") then
			Unit.set_visibility(var_45_0, "gizmo", false)
		end

		if var_0_4(var_45_0, "physics_ignores_object_set") then
			if var_45_5 then
				var_0_5(var_45_0, "hide_helper_mesh")
				var_0_5(var_45_0, "unit_object_set_enabled")
			else
				var_0_5(var_45_0, "unit_object_set_disabled")
			end
		else
			local var_45_16

			if var_45_5 then
				var_45_16 = var_0_4(var_45_0, "flow_object_set_actor_list")
			else
				var_45_16 = {}
			end

			for iter_45_0 = 0, Unit.num_actors(var_45_0) - 1 do
				if var_45_5 and var_45_16[iter_45_0] then
					Unit.create_actor(var_45_0, iter_45_0)
				elseif not var_45_5 and Unit.actor(var_45_0, iter_45_0) then
					Unit.destroy_actor(var_45_0, iter_45_0)

					var_45_16[iter_45_0] = true
				end
			end

			if var_45_5 then
				Unit.set_data(var_45_0, "flow_object_set_actor_list", nil)
				var_0_5(var_45_0, "hide_helper_mesh")
				var_0_5(var_45_0, "unit_object_set_enabled")
			else
				Unit.set_data(var_45_0, "flow_object_set_actor_list", var_45_16)
				var_0_5(var_45_0, "unit_object_set_disabled")
			end
		end
	end
end

function GameModeManager.get_end_screen_config(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	local var_46_0, var_46_1, var_46_2 = arg_46_0._game_mode:get_end_screen_config(arg_46_1, arg_46_2, arg_46_3, arg_46_4)

	fassert(var_46_0 ~= nil, "No screen name returned")
	fassert(var_46_1 ~= nil, "No screen config returned")

	return var_46_0, var_46_1, var_46_2
end

function GameModeManager.get_end_of_round_screen_settings(arg_47_0)
	if arg_47_0._game_mode.get_end_of_round_screen_settings then
		return arg_47_0._game_mode:get_end_of_round_screen_settings()
	end

	return "none", {}, {}
end

function GameModeManager.get_player_wounds(arg_48_0, arg_48_1)
	return arg_48_0._game_mode:get_player_wounds(arg_48_1)
end

function GameModeManager.get_initial_inventory(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
	return arg_49_0._game_mode:get_initial_inventory(arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
end

function GameModeManager.flow_cb_set_flow_object_set_enabled(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0._object_sets["flow_" .. arg_50_1]

	fassert(var_50_0, "[GameModeManager:flow_cb_set_flow_object_set_enabled()] Object set %s does not exist.", arg_50_1)
	arg_50_0:_set_flow_object_set_enabled(var_50_0, arg_50_2, arg_50_1)
end

function GameModeManager.register_object_sets(arg_51_0, arg_51_1)
	arg_51_0._object_sets = {}
	arg_51_0._object_set_names = {}

	for iter_51_0, iter_51_1 in pairs(arg_51_1) do
		arg_51_0._object_sets[iter_51_0] = iter_51_1
		arg_51_0._object_set_names[iter_51_1.key] = iter_51_0

		if iter_51_1.type == "flow" then
			arg_51_0:_set_flow_object_set_enabled(iter_51_1, false, iter_51_0)
		end
	end
end

function GameModeManager.event_reload_application_settings(arg_52_0)
	if arg_52_0._object_sets.shadow_lights then
		Managers.state.camera:set_shadow_lights(T(Application.user_setting("light_casts_shadows"), false), 1)
	end
end

function GameModeManager._init_game_mode(arg_53_0, arg_53_1, arg_53_2)
	fassert(GameModeSettings[arg_53_1], "[GameModeManager] Tried to set unknown game mode %q", tostring(arg_53_1))

	local var_53_0 = GameModeSettings[arg_53_1]
	local var_53_1 = rawget(_G, var_53_0.class_name)

	if DEDICATED_SERVER then
		cprintf("[GameModeManager] Changing game mode to: %s", arg_53_1)
	end

	arg_53_0._game_mode = var_53_1:new(var_53_0, arg_53_0._world, arg_53_0._network_handler, arg_53_0.is_server, arg_53_0._profile_synchronizer, arg_53_0._level_key, arg_53_0.statistics_db, arg_53_2)
end

function GameModeManager.host_player_spawned(arg_54_0)
	Managers.state.entity:system("round_started_system"):player_spawned()
end

function GameModeManager.round_started(arg_55_0)
	local var_55_0 = 0

	arg_55_0:trigger_event("round_started", var_55_0)
end

function GameModeManager.gm_event_round_started(arg_56_0, arg_56_1)
	arg_56_0._round_started = true
	arg_56_0._round_start_time = Managers.time:time("game") - arg_56_1

	local var_56_0 = LevelHelper:current_level(arg_56_0._world)
	local var_56_1 = arg_56_0._game_mode_key .. "_round_started"

	Level.trigger_event(var_56_0, var_56_1)
	Managers.telemetry_events:round_started()

	if TelemetrySettings.collect_memory then
		local var_56_2 = Profiler.memory_tree()
		local var_56_3 = Profiler.memory_resources("all")

		Managers.telemetry_events:memory_statistics(var_56_2, var_56_3, "round_started")
	end

	Level.trigger_event(var_56_0, "coop_round_started")

	if arg_56_0._game_mode.round_started then
		arg_56_0._game_mode:round_started()
	end
end

function GameModeManager.is_round_started(arg_57_0)
	local var_57_0 = arg_57_0._round_start_time and Managers.time:time("game") - arg_57_0._round_start_time or nil

	return arg_57_0._round_started, var_57_0
end

function GameModeManager.disable_lose_condition(arg_58_0)
	arg_58_0._game_mode:disable_lose_condition()
end

function GameModeManager.complete_level(arg_59_0)
	arg_59_0._game_mode:complete_level(arg_59_0._level_key)
	arg_59_0._game_mode:trigger_end_level_area_events()
end

function GameModeManager.wanted_transition(arg_60_0)
	return arg_60_0._game_mode:wanted_transition()
end

function GameModeManager.fail_level(arg_61_0)
	arg_61_0._game_mode:fail_level()
end

function GameModeManager.retry_level(arg_62_0)
	local var_62_0 = Managers.mechanism:generate_level_seed()

	Managers.level_transition_handler:reload_level(nil, var_62_0)
	Managers.level_transition_handler:promote_next_level_data()
end

function GameModeManager.disable_player_spawning(arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
	local var_63_0 = arg_63_0._disable_spawning_reasons

	if arg_63_1 then
		fassert(not var_63_0[arg_63_2], "Reason already disables player spawning")

		if table.is_empty(var_63_0) then
			arg_63_0._game_mode:disable_player_spawning()
		end

		var_63_0[arg_63_2] = true
	else
		fassert(var_63_0[arg_63_2], "Trying to enable spawning without disabling spawning first with reason")

		var_63_0[arg_63_2] = nil

		if table.is_empty(var_63_0) then
			arg_63_0._game_mode:enable_player_spawning(arg_63_3, arg_63_4)
		end
	end
end

function GameModeManager.start_specific_level(arg_64_0, arg_64_1, arg_64_2)
	if arg_64_2 then
		arg_64_0.specific_level_to_start = arg_64_1
		arg_64_0.specific_level_start_timer = arg_64_2
	else
		arg_64_0.specific_level_to_start = nil
		arg_64_0.specific_level_start_timer = nil

		local var_64_0 = Managers.level_transition_handler
		local var_64_1 = LevelHelper:get_environment_variation_id(arg_64_1)

		var_64_0:set_next_level(arg_64_1, var_64_1)
		var_64_0:promote_next_level_data()
	end
end

function GameModeManager.update_timebased_level_start(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_0.specific_level_start_timer

	if var_65_0 then
		local var_65_1 = var_65_0 - arg_65_1

		if var_65_1 <= 0 then
			arg_65_0:start_specific_level(arg_65_0.specific_level_to_start)
		else
			arg_65_0.specific_level_start_timer = var_65_1
		end
	end
end

function GameModeManager.pre_update(arg_66_0, arg_66_1, arg_66_2)
	arg_66_0._mutator_handler:pre_update(arg_66_2, arg_66_1)
	arg_66_0._game_mode:pre_update(arg_66_1, arg_66_2)
end

function GameModeManager.register_looping_event_timer(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	local var_67_0 = os.clock()

	arg_67_0._looping_event_timers[arg_67_1] = {
		delay = arg_67_2,
		next_trigger_time = var_67_0 + arg_67_2,
		event_name = arg_67_3
	}
end

function GameModeManager.unregister_looping_event_timer(arg_68_0, arg_68_1)
	arg_68_0._looping_event_timers[arg_68_1] = nil
end

function GameModeManager.local_player_ready_to_start(arg_69_0, arg_69_1)
	if not Managers.state.network:in_game_session() then
		return false
	end

	return arg_69_0._game_mode:local_player_ready_to_start(arg_69_1)
end

function GameModeManager.local_player_game_starts(arg_70_0, arg_70_1, arg_70_2)
	arg_70_0._game_mode:local_player_game_starts(arg_70_1, arg_70_2)
end

function GameModeManager.update(arg_71_0, arg_71_1, arg_71_2)
	arg_71_0._mutator_handler:update(arg_71_1, arg_71_2)

	if arg_71_0._game_mode.update then
		arg_71_0._game_mode:update(arg_71_2, arg_71_1)
	end

	local var_71_0 = os.clock()
	local var_71_1 = LevelHelper:current_level(arg_71_0._world)

	for iter_71_0, iter_71_1 in pairs(arg_71_0._looping_event_timers) do
		if var_71_0 > iter_71_1.next_trigger_time then
			Level.trigger_event(var_71_1, iter_71_1.event_name)

			iter_71_1.next_trigger_time = iter_71_1.next_trigger_time + iter_71_1.delay
		end
	end

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_1, arg_71_0)
	end
end

function GameModeManager._update_initial_join(arg_72_0, arg_72_1, arg_72_2)
	if arg_72_0._network_handler:are_all_peers_ingame() then
		arg_72_0._initial_peers_ready = true

		arg_72_0._game_mode:all_peers_ready()
	end
end

function GameModeManager.evaluate_end_condition_outcome(arg_73_0, arg_73_1, arg_73_2)
	if arg_73_0._game_mode.evaluate_end_condition_outcome then
		return arg_73_0._game_mode:evaluate_end_condition_outcome(arg_73_1, arg_73_2)
	end

	local var_73_0 = arg_73_1 and arg_73_1 == "won"
	local var_73_1 = arg_73_1 and arg_73_1 == "lost"

	return var_73_0, var_73_1
end

local var_0_6 = {
	party_one_won_early = true,
	reload = true,
	party_two_won_early = true
}

function GameModeManager.server_update(arg_74_0, arg_74_1, arg_74_2)
	if not arg_74_0._initial_peers_ready then
		arg_74_0:_update_initial_join(arg_74_2, arg_74_1)
	end

	local var_74_0 = arg_74_0._game_mode

	var_74_0:server_update(arg_74_2, arg_74_1)

	if not arg_74_0._have_signalled_game_mode_about_end_conditions then
		if not arg_74_0._end_conditions_met and not LEVEL_EDITOR_TEST then
			local var_74_1 = arg_74_0._mutator_handler
			local var_74_2 = arg_74_0._round_started
			local var_74_3, var_74_4, var_74_5 = arg_74_0._game_mode:evaluate_end_conditions(var_74_2, arg_74_1, arg_74_2, var_74_1)

			if var_74_3 then
				var_74_0:ended(var_74_4)
				Managers.mechanism:game_round_ended(arg_74_2, arg_74_1, var_74_4, var_74_5)

				if not var_0_6[var_74_4] then
					Managers.mechanism:progress_state()
				end

				arg_74_0._network_handler:enter_post_game()

				arg_74_0._end_conditions_met = true
				arg_74_0._end_reason = var_74_4

				local var_74_6 = var_74_4 == "lost" and Managers.state.spawn:checkpoint_data() and true or false
				local var_74_7 = Managers.state.entity:system("mission_system"):percentages_completed()

				arg_74_0:trigger_event("end_conditions_met", var_74_4, var_74_6, var_74_7)

				arg_74_0._gm_event_end_conditions_met = true

				arg_74_0:_save_last_level_completed(var_74_4)

				arg_74_0._ready_for_transition = {}

				local var_74_8 = Managers.player:human_players()

				for iter_74_0, iter_74_1 in pairs(var_74_8) do
					local var_74_9 = iter_74_1.peer_id

					arg_74_0._ready_for_transition[var_74_9] = false
				end
			end
		end

		if not LEVEL_EDITOR_TEST and arg_74_0._end_conditions_met then
			local var_74_10 = true
			local var_74_11 = Managers.player:human_players()

			for iter_74_2, iter_74_3 in pairs(var_74_11) do
				local var_74_12 = iter_74_3.peer_id

				if arg_74_0._ready_for_transition[var_74_12] == false then
					var_74_10 = false

					break
				end
			end

			if var_74_10 and not arg_74_0._have_signalled_ready_to_transition then
				var_74_0:ready_to_transition()

				arg_74_0._have_signalled_ready_to_transition = true
			else
				arg_74_0:update_timebased_level_start(arg_74_1)
			end
		end
	end
end

function GameModeManager._save_last_level_completed(arg_75_0, arg_75_1)
	local var_75_0 = arg_75_0:level_key()

	SaveData.last_played_level = var_75_0
	SaveData.last_played_level_result = arg_75_1

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

function GameModeManager.rpc_is_ready_for_transition(arg_76_0, arg_76_1)
	local var_76_0 = CHANNEL_TO_PEER_ID[arg_76_1]

	arg_76_0._ready_for_transition[var_76_0] = true
end

function GameModeManager.game_won(arg_77_0, arg_77_1)
	local var_77_0, var_77_1 = arg_77_0:evaluate_end_condition_outcome(arg_77_0._end_reason, arg_77_1)

	return var_77_0
end

function GameModeManager.game_lost(arg_78_0, arg_78_1)
	local var_78_0, var_78_1 = arg_78_0:evaluate_end_condition_outcome(arg_78_0._end_reason, arg_78_1)

	return var_78_1
end

function GameModeManager.set_end_reason(arg_79_0, arg_79_1)
	arg_79_0._end_reason = arg_79_1
end

function GameModeManager.get_end_reason(arg_80_0)
	return arg_80_0._end_reason
end

function GameModeManager.level_key(arg_81_0)
	return arg_81_0._level_key
end

function GameModeManager.trigger_event(arg_82_0, arg_82_1, ...)
	local var_82_0 = "gm_event_" .. arg_82_1

	Managers.state.event:trigger(var_82_0, ...)

	if arg_82_0._lobby_host then
		Managers.state.network[var_82_0](Managers.state.network, ...)
	end
end

function GameModeManager.game_mode(arg_83_0)
	return arg_83_0._game_mode
end

function GameModeManager.game_mode_key(arg_84_0)
	return arg_84_0._game_mode_key
end

function GameModeManager.hot_join_sync(arg_85_0, arg_85_1)
	arg_85_0._mutator_handler:hot_join_sync(arg_85_1)

	local var_85_0 = arg_85_0._game_mode:game_mode_state()

	if var_85_0 ~= "initial_state" then
		local var_85_1 = var_0_2[arg_85_0._game_mode_key][var_85_0]

		arg_85_0._network_transmit:send_rpc("rpc_change_game_mode_state", arg_85_1, var_85_1)
	end

	if arg_85_0._round_started then
		local var_85_2 = Managers.time:time("game") - arg_85_0._round_start_time

		arg_85_0._network_transmit:send_rpc("rpc_gm_event_round_started", arg_85_1, var_85_2)
	end

	arg_85_0._game_mode:hot_join_sync(arg_85_1)

	if arg_85_0:get_environment_variation_name() then
		arg_85_0._network_transmit:send_rpc("rpc_apply_environment_variation", arg_85_1)
	end
end

function GameModeManager.activate_end_level_area(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
	arg_86_0._game_mode:activate_end_level_area(arg_86_1, arg_86_2, arg_86_3, arg_86_4)
end

function GameModeManager.debug_end_level_area(arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
	arg_87_0._game_mode:debug_end_level_area(arg_87_1, arg_87_2, arg_87_3, arg_87_4)
end

function GameModeManager.disable_end_level_area(arg_88_0, arg_88_1)
	arg_88_0._game_mode:disable_end_level_area(arg_88_1)
end

function GameModeManager.teleport_despawned_players(arg_89_0, arg_89_1)
	arg_89_0._game_mode:teleport_despawned_players(arg_89_1)
end

function GameModeManager.flow_callback_add_spawn_point(arg_90_0, arg_90_1)
	arg_90_0._game_mode:flow_callback_add_spawn_point(arg_90_1)
end

function GameModeManager.flow_callback_add_game_mode_specific_spawn_point(arg_91_0, arg_91_1)
	local var_91_0 = 0
	local var_91_1 = {}

	while Unit.has_data(arg_91_1, "sides", var_91_0) do
		local var_91_2 = Unit.get_data(arg_91_1, "sides", var_91_0)

		if #var_91_2 > 0 then
			var_91_1[#var_91_1 + 1] = var_91_2
		end

		var_91_0 = var_91_0 + 1
	end

	local var_91_3 = 0

	while Unit.has_data(arg_91_1, "game_modes", var_91_3) do
		if Unit.get_data(arg_91_1, "game_modes", var_91_3) == arg_91_0._game_mode_key then
			if arg_91_0._game_mode.flow_callback_add_game_mode_specific_spawn_point then
				arg_91_0._game_mode:flow_callback_add_game_mode_specific_spawn_point(arg_91_1, var_91_1)
			end

			break
		end

		var_91_3 = var_91_3 + 1
	end
end

function GameModeManager.remove_respawn_units_due_to_crossroads(arg_92_0, arg_92_1, arg_92_2)
	if arg_92_0._game_mode.remove_respawn_units_due_to_crossroads then
		arg_92_0._game_mode:remove_respawn_units_due_to_crossroads(arg_92_1, arg_92_2)
	end
end

function GameModeManager.recalc_respawner_dist_due_to_crossroads(arg_93_0)
	if arg_93_0._game_mode.recalc_respawner_dist_due_to_crossroads then
		arg_93_0._game_mode:recalc_respawner_dist_due_to_crossroads()
	end
end

function GameModeManager.respawn_unit_spawned(arg_94_0, arg_94_1)
	arg_94_0._game_mode:respawn_unit_spawned(arg_94_1)
end

function GameModeManager.respawn_gate_unit_spawned(arg_95_0, arg_95_1)
	arg_95_0._game_mode:respawn_gate_unit_spawned(arg_95_1)
end

function GameModeManager.profile_changed(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5)
	arg_96_0._game_mode:profile_changed(arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5)
end

function GameModeManager.force_respawn(arg_97_0, arg_97_1, arg_97_2)
	arg_97_0._game_mode:force_respawn(arg_97_1, arg_97_2)
end

function GameModeManager.force_respawn_dead_players(arg_98_0)
	arg_98_0._game_mode:force_respawn_dead_players()
end

function GameModeManager.set_respawning_enabled(arg_99_0, arg_99_1)
	if arg_99_0._game_mode.set_respawning_enabled then
		arg_99_0._game_mode:set_respawning_enabled(arg_99_1)
	end
end

function GameModeManager.on_game_mode_data_created(arg_100_0, arg_100_1, arg_100_2)
	fassert(arg_100_0._has_created_game_mode_data == false, "There has already been a game mode data go created.")

	arg_100_0._has_created_game_mode_data = true

	arg_100_0._game_mode:on_game_mode_data_created(arg_100_1, arg_100_2)
end

function GameModeManager.on_game_mode_data_destroyed(arg_101_0)
	arg_101_0._has_created_game_mode_data = false

	arg_101_0._game_mode:on_game_mode_data_destroyed()
end

function GameModeManager._update_end_level_areas(arg_102_0)
	for iter_102_0, iter_102_1 in pairs(arg_102_0._debug_end_level_areas) do
		local var_102_0 = Unit.node(iter_102_0, iter_102_1.object)
		local var_102_1 = Unit.world_rotation(iter_102_0, var_102_0)
		local var_102_2 = Quaternion.right(var_102_1)
		local var_102_3 = Quaternion.forward(var_102_1)
		local var_102_4 = Quaternion.up(var_102_1)
		local var_102_5 = Unit.world_position(iter_102_0, var_102_0)
		local var_102_6 = iter_102_1.offset:unbox()
		local var_102_7 = var_102_5 + var_102_2 * var_102_6.x + var_102_3 * var_102_6.y + var_102_4 * var_102_6.z
		local var_102_8 = Matrix4x4.from_quaternion_position(var_102_1, var_102_7)
		local var_102_9 = iter_102_1.extents:unbox()

		QuickDrawer:quaternion(var_102_5, var_102_1)

		local var_102_10 = arg_102_0._end_level_areas[iter_102_0]

		QuickDrawer:box(var_102_8, var_102_9, var_102_10 and Color(0, 255, 0) or Color(255, 0, 0))
	end

	if table.is_empty(arg_102_0._end_level_areas) then
		return false
	else
		local var_102_11 = Vector3.dot
		local var_102_12 = math.abs
		local var_102_13 = 0

		for iter_102_2, iter_102_3 in pairs(Managers.player:human_players()) do
			local var_102_14 = iter_102_3.player_unit

			if Unit.alive(var_102_14) and not ScriptUnit.extension(var_102_14, "status_system"):is_disabled() then
				var_102_13 = var_102_13 + 1

				local var_102_15 = POSITION_LOOKUP[var_102_14]
				local var_102_16 = false

				for iter_102_4, iter_102_5 in pairs(arg_102_0._end_level_areas) do
					local var_102_17 = Unit.node(iter_102_4, iter_102_5.object)
					local var_102_18 = Unit.world_position(iter_102_4, var_102_17)
					local var_102_19 = Unit.world_rotation(iter_102_4, var_102_17)
					local var_102_20 = Quaternion.right(var_102_19)
					local var_102_21 = Quaternion.forward(var_102_19)
					local var_102_22 = Quaternion.up(var_102_19)
					local var_102_23 = iter_102_5.offset:unbox()
					local var_102_24 = var_102_18 + var_102_20 * var_102_23.x + var_102_21 * var_102_23.y + var_102_22 * var_102_23.z
					local var_102_25 = iter_102_5.extents:unbox()
					local var_102_26 = var_102_15 - var_102_24

					if var_102_12(var_102_11(var_102_26, var_102_20)) < var_102_12(var_102_25.x) and var_102_12(var_102_11(var_102_26, var_102_21)) < var_102_12(var_102_25.y) and var_102_12(var_102_11(var_102_26, var_102_22)) < var_102_12(var_102_25.z) then
						var_102_16 = true

						break
					end
				end

				if not var_102_16 then
					return false
				end
			end
		end

		return var_102_13 > 0
	end
end

function GameModeManager.on_round_end(arg_103_0)
	local var_103_0 = arg_103_0._game_mode

	if var_103_0 and var_103_0.on_round_end then
		var_103_0:on_round_end()
	end
end

function GameModeManager.change_game_mode_state(arg_104_0, arg_104_1)
	fassert(arg_104_0.is_server, "Should only be called on the server.")

	local var_104_0 = arg_104_0:setting("game_mode_states")

	fassert(table.contains(var_104_0, arg_104_1), "state_name (%s) does not exist in GameModeSettings", arg_104_1)

	local var_104_1 = var_0_2[arg_104_0._game_mode_key][arg_104_1]

	arg_104_0._network_transmit:send_rpc_clients("rpc_change_game_mode_state", var_104_1)
end

function GameModeManager.get_boss_loot_pickup(arg_105_0)
	if arg_105_0._game_mode.get_boss_loot_pickup then
		return arg_105_0._game_mode:get_boss_loot_pickup()
	end

	return "loot_die"
end

function GameModeManager.get_environment_variation_name(arg_106_0)
	local var_106_0 = Managers.level_transition_handler:get_current_environment_variation_name()

	if var_106_0 then
		local var_106_1 = arg_106_0:mutators()

		local function var_106_2(arg_107_0, arg_107_1)
			return arg_107_1.template.disable_environment_variations
		end

		if not var_106_1 or not table.find_func(var_106_1, var_106_2) then
			return var_106_0
		end
	end

	return nil
end

function GameModeManager.lock_available_hero(arg_108_0)
	local var_108_0 = Managers.player:human_and_bot_players()
	local var_108_1 = {}
	local var_108_2 = PROFILES_BY_AFFILIATION.heroes

	for iter_108_0, iter_108_1 in pairs(var_108_0) do
		local var_108_3 = iter_108_1:profile_index()

		if var_108_3 then
			var_108_1[var_108_3] = true
		end
	end

	for iter_108_2, iter_108_3 in ipairs(var_108_2) do
		local var_108_4 = FindProfileIndex(iter_108_3)

		if not var_108_1[var_108_4] then
			arg_108_0._locked_profile_index = var_108_4

			return arg_108_0._locked_profile_index
		end
	end

	if not arg_108_0._locked_profile_index then
		local var_108_5 = Managers.party:parties_by_name().heroes.party_id
		local var_108_6 = Managers.party:get_last_added_bot_for_party(var_108_5)

		if var_108_6 then
			arg_108_0._locked_profile_index = var_108_6.profile_index

			return arg_108_0._locked_profile_index
		end
	end

	if not arg_108_0._locked_profile_index then
		table.clear(var_108_1)

		local var_108_7 = Managers.player:human_players()

		for iter_108_4, iter_108_5 in pairs(var_108_7) do
			var_108_1[iter_108_5:profile_index()] = true
		end

		for iter_108_6, iter_108_7 in ipairs(var_108_2) do
			local var_108_8 = FindProfileIndex(iter_108_7)

			if not var_108_1[var_108_8] then
				arg_108_0._locked_profile_index = var_108_8

				return arg_108_0._locked_profile_index
			end
		end
	end

	if not arg_108_0._locked_profile_index then
		local var_108_9 = var_108_2[1]

		arg_108_0._locked_profile_index = FindProfileIndex(var_108_9)

		return arg_108_0._locked_profile_index
	end
end

function GameModeManager.hero_is_locked(arg_109_0, arg_109_1)
	return arg_109_0._locked_profile_index == arg_109_1
end

function GameModeManager.apply_environment_variation(arg_110_0)
	local var_110_0 = arg_110_0:get_environment_variation_name()

	if var_110_0 then
		LevelHelper:flow_event(arg_110_0._world, var_110_0)

		if arg_110_0.is_server then
			arg_110_0._network_transmit:send_rpc_clients("rpc_apply_environment_variation")
		end
	end
end

function GameModeManager.rpc_apply_environment_variation(arg_111_0)
	arg_111_0:apply_environment_variation()
end

function GameModeManager.rpc_change_game_mode_state(arg_112_0, arg_112_1, arg_112_2)
	fassert(not arg_112_0.is_server, "Should only appear on the clients.")

	local var_112_0 = var_0_2[arg_112_0._game_mode_key][arg_112_2]

	arg_112_0._game_mode:change_game_mode_state(var_112_0)
end

function GameModeManager.rpc_trigger_level_event(arg_113_0, arg_113_1, arg_113_2)
	local var_113_0 = LevelHelper:current_level(arg_113_0._world)

	if var_113_0 then
		Level.trigger_event(var_113_0, arg_113_2)
	end
end

function GameModeManager.is_reservable(arg_114_0)
	return arg_114_0._game_mode:is_reservable()
end

function GameModeManager.is_joinable(arg_115_0)
	return arg_115_0._game_mode:is_joinable()
end

function GameModeManager.mutator_handler(arg_116_0)
	return arg_116_0._mutator_handler
end

function GameModeManager.level_start_objectives(arg_117_0)
	if arg_117_0._game_mode.level_start_objectives then
		return arg_117_0._game_mode:level_start_objectives()
	end
end
