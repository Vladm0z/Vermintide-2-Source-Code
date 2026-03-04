-- chunkname: @scripts/flow/flow_callbacks.lua

require("scripts/flow/flow_callbacks_ai")
require("scripts/flow/flow_callbacks_enemy")
require("scripts/flow/flow_callbacks_progression")
require("core/wwise/lua/wwise_flow_callbacks")
require("core/volumetrics/lua/volumetrics_flow_callbacks")
require("scripts/helpers/nav_tag_volume_utils")
require("scripts/settings/difficulty_settings")
require("scripts/settings/attachment_node_linking")
DLCUtils.dofile("flow_callbacks")

local var_0_0 = Boot.flow_return_table
local var_0_1 = Unit.alive

function flow_callback_show_gdc_intro(arg_1_0)
	local var_1_0 = Managers.player:local_player(1).player_unit

	if var_1_0 and var_0_1(var_1_0) then
		ScriptUnit.extension(var_1_0, "hud_system"):gdc_intro_active(true)
	end
end

function flow_callback_animation_callback(arg_2_0)
	Managers.state.event:trigger("animation_callback", arg_2_0.unit, arg_2_0.callback, arg_2_0.param1)
end

function flow_callback_disable_animation_state_machine(arg_3_0)
	Unit.disable_animation_state_machine(arg_3_0.unit)
end

function flow_callback_enable_actor_draw(arg_4_0)
	local var_4_0 = Managers.state.debug

	if var_4_0 then
		var_4_0:enable_actor_draw(arg_4_0.actor, arg_4_0.color)
	end
end

function flow_callback_disable_actor_draw(arg_5_0)
	local var_5_0 = Managers.state.debug

	if var_5_0 then
		var_5_0.debug:disable_actor_draw(arg_5_0.actor)
	end
end

function flow_callback_set_start_area(arg_6_0)
	local var_6_0 = Managers.state.entity

	if var_6_0 then
		var_6_0:system("round_started_system"):set_start_area(arg_6_0.volume_name)
	end
end

function flow_callback_add_coop_spawn_point(arg_7_0)
	local var_7_0 = Managers.state.game_mode

	if var_7_0 then
		var_7_0:flow_callback_add_spawn_point(arg_7_0.unit)
	end
end

function flow_callback_add_game_mode_spawn_point(arg_8_0)
	local var_8_0 = Managers.state.game_mode

	if var_8_0 then
		var_8_0:flow_callback_add_game_mode_specific_spawn_point(arg_8_0.unit)
	end
end

function flow_callback_set_checkpoint(arg_9_0)
	local var_9_0 = Managers.state.spawn

	if var_9_0 then
		var_9_0:flow_callback_set_checkpoint(arg_9_0.no_spawn_volume, arg_9_0.safe_zone_volume, arg_9_0.unit1, arg_9_0.unit2, arg_9_0.unit3, arg_9_0.unit4)
	end
end

function flow_callback_activate_spawning(arg_10_0)
	return
end

function flow_callback_grimoire_destroyed(arg_11_0)
	return
end

function flow_callback_tome_destroyed(arg_12_0)
	return
end

function debug_print_random_values()
	local var_13_0 = Application.main_world()
	local var_13_1 = World.get_data(var_13_0, "debug_level_seed")

	for iter_13_0, iter_13_1 in ipairs(var_13_1) do
		print(iter_13_1)
	end
end

local function var_0_2(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = Application.flow_callback_context_world()
	local var_14_1 = World.get_data(var_14_0, "level_seed")

	fassert(var_14_1, "Trying to use server seeded random without level seed being set. Is this attempted after level_loaded flow has been finished?")

	local var_14_2, var_14_3 = Math.next_random(var_14_1, arg_14_0, arg_14_1)

	World.set_data(var_14_0, "level_seed", var_14_2)

	if script_data.debug_server_seeded_random then
		local var_14_4 = World.get_data(var_14_0, "debug_level_seed")
		local var_14_5 = #var_14_4 + 1

		var_14_4[var_14_5] = string.format("%4.d:%s rnd: %f old seed: %d new seed: %d", var_14_5, tostring(arg_14_2), var_14_3, var_14_1, var_14_2)
	end

	return var_14_3
end

function flow_callback_query_server_seeded_random_int(arg_15_0)
	local var_15_0 = var_0_2(arg_15_0.min or 0, arg_15_0.max or 1, arg_15_0.debug_name)

	var_0_0.value = var_15_0

	return var_0_0
end

function flow_callback_query_server_seeded_random_float(arg_16_0)
	local var_16_0 = arg_16_0.min or 0
	local var_16_1 = arg_16_0.max or 1
	local var_16_2 = var_0_2(nil, nil, arg_16_0.debug_name)

	var_0_0.value = var_16_0 + var_16_2 * (var_16_1 - var_16_0)

	return var_0_0
end

function flow_callback_server_seeded_randomize(arg_17_0)
	local var_17_0 = arg_17_0.max or 8
	local var_17_1 = var_0_2(1, var_17_0, arg_17_0.debug_name)

	return {
		[tostring(var_17_1)] = true
	}
end

function flow_callback_switchcase(arg_18_0)
	local var_18_0 = {}
	local var_18_1 = "out"

	if arg_18_0.case ~= "" then
		for iter_18_0, iter_18_1 in pairs(arg_18_0) do
			if iter_18_0 ~= "case" and arg_18_0.case == iter_18_1 then
				var_18_0[var_18_1 .. string.sub(iter_18_0, -1)] = true
			end
		end
	end

	return var_18_0
end

function flow_callback_switchcase_special(arg_19_0)
	local var_19_0 = {}
	local var_19_1 = "out"
	local var_19_2

	if arg_19_0.case ~= "" then
		for iter_19_0, iter_19_1 in pairs(arg_19_0) do
			if iter_19_0 ~= "case" then
				local var_19_3 = string.sub(iter_19_0, -1)

				if arg_19_0.case == tonumber(var_19_3) then
					var_19_0[var_19_1 .. var_19_3] = true
					var_19_0.out_number = tonumber(var_19_3)
				end
			end
		end
	end

	return var_19_0
end

function flow_callback_switchcase_range(arg_20_0)
	local var_20_0 = {}
	local var_20_1 = "out"

	if arg_20_0.case ~= "" then
		for iter_20_0, iter_20_1 in pairs(arg_20_0) do
			if iter_20_0 ~= "case" then
				local var_20_2 = {}

				for iter_20_2 in string.gmatch(iter_20_1, "(%d+)") do
					table.insert(var_20_2, tonumber(iter_20_2))
				end

				if var_20_2[1] ~= nil and var_20_2[2] ~= nil and arg_20_0.case >= var_20_2[1] and arg_20_0.case <= var_20_2[2] then
					var_20_0[var_20_1 .. string.sub(iter_20_0, -1)] = true
				end
			end
		end
	end

	return var_20_0
end

function flow_callback_switchcase_unit(arg_21_0)
	local var_21_0

	if arg_21_0.case ~= "" then
		for iter_21_0, iter_21_1 in pairs(arg_21_0) do
			if iter_21_0 ~= "case" and arg_21_0.case == tonumber(string.sub(iter_21_0, -1)) then
				var_21_0 = arg_21_0[iter_21_0]
			end
		end
	end

	var_0_0.out_unit = var_21_0

	return var_0_0
end

function flow_callback_switch_event_to_number_0(arg_22_0)
	return {
		out_number = 0
	}
end

function flow_callback_switch_event_to_number_1(arg_23_0)
	return {
		out_number = 1
	}
end

function flow_callback_switch_event_to_number_2(arg_24_0)
	return {
		out_number = 2
	}
end

function flow_callback_switch_event_to_number_3(arg_25_0)
	return {
		out_number = 3
	}
end

function flow_callback_switch_event_to_number_4(arg_26_0)
	return {
		out_number = 4
	}
end

function flow_callback_switch_event_to_number_5(arg_27_0)
	return {
		out_number = 5
	}
end

function flow_callback_switch_event_to_number_6(arg_28_0)
	return {
		out_number = 6
	}
end

function flow_callback_relay_trigger(arg_29_0)
	return {
		out = true
	}
end

function flow_callback_randomize_sequential_numbers(arg_30_0)
	local var_30_0 = arg_30_0.max
	local var_30_1 = {}

	for iter_30_0 = 1, var_30_0 do
		var_30_1[iter_30_0] = iter_30_0
	end

	for iter_30_1 = 1, 10 do
		local var_30_2 = var_0_2(1, var_30_0, arg_30_0.debug_name)
		local var_30_3 = var_0_2(1, var_30_0, arg_30_0.debug_name)

		var_30_1[var_30_2], var_30_1[var_30_3] = var_30_1[var_30_3], var_30_1[var_30_2]
	end

	local var_30_4 = {}

	for iter_30_2 = 1, var_30_0 do
		var_30_4[tostring(iter_30_2)] = var_30_1[iter_30_2]
	end

	return var_30_4
end

function flow_callback_randomize_strings(arg_31_0)
	local var_31_0 = {}
	local var_31_1 = #arg_31_0

	for iter_31_0, iter_31_1 in pairs(arg_31_0) do
		var_31_0[#var_31_0 + 1] = iter_31_1
	end

	local var_31_2 = var_31_0[math.random(1, #var_31_0)]

	var_0_0.out_string = var_31_2

	return var_0_0
end

function flow_callback_select_output_by_number(arg_32_0)
	local var_32_0 = arg_32_0.num
	local var_32_1 = arg_32_0[tostring(var_32_0)]

	return {
		["out_" .. tostring(var_32_1)] = true
	}
end

function flow_callback_set_simple_animation_speed(arg_33_0)
	Unit.set_simple_animation_speed(arg_33_0.unit, arg_33_0.speed, arg_33_0.group)
end

function flow_callback_get_animation_layer_info(arg_34_0)
	var_0_0.time, var_0_0.length = Unit.animation_layer_info(arg_34_0.unit, arg_34_0.layer)

	return var_0_0
end

function flow_query_number_of_active_players(arg_35_0)
	local var_35_0 = 0
	local var_35_1 = Managers.state.side

	if var_35_1 then
		local var_35_2 = var_35_1:get_side_from_name("heroes").PLAYER_UNITS
		local var_35_3 = #var_35_2

		for iter_35_0 = 1, var_35_3 do
			local var_35_4 = var_35_2[iter_35_0]

			if not ScriptUnit.extension(var_35_4, "status_system"):is_disabled() then
				var_35_0 = var_35_0 + 1
			end
		end
	end

	var_0_0.value = var_35_0

	return var_0_0
end

function flow_query_number_of_human_players(arg_36_0)
	local var_36_0 = Managers.player

	var_0_0.value = var_36_0:num_human_players()

	return var_0_0
end

function flow_callback_play_music(arg_37_0)
	Managers.music:trigger_event(arg_37_0.event)
end

function flow_callback_idle_camera_dummy_spawned(arg_38_0)
	local var_38_0 = Managers.state.entity

	if var_38_0 then
		var_38_0:system("camera_system"):idle_camera_dummy_spawned(arg_38_0.unit)
	end
end

function flow_callback_pickup_gizmo_spawned(arg_39_0)
	local var_39_0 = Managers.state.entity

	if var_39_0 then
		local var_39_1 = var_39_0:system("pickup_system")

		if var_39_1 then
			var_39_1:pickup_gizmo_spawned(arg_39_0.unit)
		end
	end
end

function flow_callback_weave_item_gizmo_spawned(arg_40_0)
	local var_40_0 = Managers.state.entity

	if var_40_0 then
		local var_40_1 = var_40_0:system("objective_item_spawner_system")

		if var_40_1 then
			var_40_1:item_gizmo_spawned(arg_40_0.unit)
		end
	end
end

function flow_callback_versus_item_gizmo_spawned(arg_41_0)
	if Managers.mechanism:current_mechanism_name() == "versus" then
		local var_41_0 = Managers.state.entity

		if var_41_0 then
			local var_41_1 = var_41_0:system("objective_item_spawner_system")

			if var_41_1 then
				var_41_1:item_gizmo_spawned(arg_41_0.unit)
			end
		end
	end
end

function flow_callback_get_current_level_key(arg_42_0)
	var_0_0.level_key = Managers.mechanism:get_current_level_keys()

	return var_0_0
end

function flow_callback_get_deus_post_match(arg_43_0)
	local var_43_0 = Managers.mechanism:game_mechanism()

	var_0_0.post_match = var_43_0:post_match() == true

	return var_0_0
end

function flow_callback_get_current_current_deus_theme_index(arg_44_0)
	var_0_0.theme_index = 1

	local var_44_0 = Managers.mechanism:get_current_level_keys()
	local var_44_1 = LevelSettings[var_44_0].theme

	for iter_44_0 = 1, #DEUS_THEME_INDEX do
		if DEUS_THEME_INDEX[iter_44_0] == var_44_1 then
			var_0_0.theme_index = iter_44_0
		end
	end

	return var_0_0
end

function flow_callback_boss_gizmo_spawned(arg_45_0)
	local var_45_0 = Managers.state.conflict

	if var_45_0 then
		var_45_0.level_analysis:boss_gizmo_spawned(arg_45_0.unit)
	end
end

function flow_callback_generic_ai_node_spawned(arg_46_0)
	local var_46_0 = Managers.state.conflict

	if var_46_0 then
		var_46_0.level_analysis:generic_ai_node_spawned(arg_46_0.unit)
	end
end

function flow_callback_respawn_unit_spawned(arg_47_0)
	local var_47_0 = Managers.state.game_mode

	if var_47_0 then
		var_47_0:respawn_unit_spawned(arg_47_0.unit)
	end
end

function flow_callback_force_move_dead_players(arg_48_0)
	local var_48_0 = Managers.state
	local var_48_1 = var_48_0 and var_48_0.game_mode
	local var_48_2 = var_48_1 and var_48_1:game_mode()
	local var_48_3 = var_48_2 and var_48_2:get_respawn_handler()

	if var_48_3 then
		var_48_3:queue_force_move_dead_players()
	end
end

function flow_callback_respawn_gate_unit_spawned(arg_49_0)
	local var_49_0 = Managers.state.game_mode

	if var_49_0 then
		var_49_0:respawn_gate_unit_spawned(arg_49_0.unit)
	end
end

function flow_callback_respawn_enabled(arg_50_0)
	if not Managers.player.is_server then
		return
	end

	local var_50_0 = Managers.state.game_mode

	if var_50_0 then
		local var_50_1 = arg_50_0.enabled

		var_50_0:set_respawning_enabled(var_50_1)
	end
end

function flow_callback_force_respawn_dead_players(arg_51_0)
	if not Managers.player.is_server then
		return
	end

	local var_51_0 = Managers.state.game_mode

	if var_51_0 then
		var_51_0:force_respawn_dead_players()
	end
end

function flow_callback_increase_weave_score(arg_52_0)
	if not Managers.player.is_server then
		return
	end

	Managers.weave:increase_bar_score(arg_52_0.amount)
end

function flow_callback_activate_triggered_pickup_spawners(arg_53_0)
	local var_53_0 = Managers.state.entity:system("pickup_system")
	local var_53_1

	if Managers.player.is_server or LEVEL_EDITOR_TEST then
		var_53_1 = var_53_0:activate_triggered_pickup_spawners(arg_53_0.triggered_spawn_id)
	end

	var_0_0.spawned_pickup_unit = var_53_1

	return var_0_0
end

function flow_callback_disable_torch(arg_54_0)
	if Managers.state.game_mode:has_activated_mutator("darkness") then
		return
	end

	local var_54_0 = arg_54_0.touching_unit

	if Managers.player.is_server then
		Managers.state.entity:system("pickup_system"):disable_teleporting_pickups()
	end

	if not var_0_1(var_54_0) then
		return
	end

	local var_54_1 = ScriptUnit.has_extension(var_54_0, "inventory_system")

	if not var_54_1 then
		return
	end

	local var_54_2 = var_54_1:get_wielded_slot_name()
	local var_54_3 = var_54_1:get_slot_data(var_54_2)

	if var_54_3 then
		local var_54_4 = var_54_3.item_data

		if (var_54_4 and var_54_4.name) == "torch" then
			CharacterStateHelper.stop_weapon_actions(var_54_1, "wield")
			var_54_1:destroy_slot("slot_level_event", true)
			var_54_1:wield("slot_melee")
		end
	end
end

function flow_wield_slot(arg_55_0)
	local var_55_0 = arg_55_0.unit
	local var_55_1 = arg_55_0.slot_name
	local var_55_2 = ScriptUnit.has_extension(var_55_0, "inventory_system")

	if var_55_2 then
		var_55_2:wield(var_55_1)
	end
end

function flow_query_wielded_weapon(arg_56_0)
	local var_56_0 = Unit.null_reference()
	local var_56_1 = arg_56_0.player_unit
	local var_56_2

	if not var_0_1(var_56_1) then
		var_0_0.righthandweapon3p = var_56_0
		var_0_0.righthandammo3p = var_56_0
		var_0_0.righthandweapon = var_56_0
		var_0_0.righthandammo1p = var_56_0
		var_0_0.lefthandweapon3p = var_56_0
		var_0_0.lefthandammo3p = var_56_0
		var_0_0.lefthandweapon = var_56_0
		var_0_0.lefthandammo1p = var_56_0
		var_0_0.aliverighthandammo1p = var_56_0
		var_0_0.alivelefthandammo1p = var_56_0

		return var_0_0
	end

	local var_56_3 = ScriptUnit.has_extension(var_56_1, "inventory_system")

	if var_56_3 then
		var_56_2 = var_56_3:equipment()
	else
		var_56_2 = Unit.get_data(var_56_1, "equipment")
	end

	local var_56_4 = var_56_2.right_hand_wielded_unit_3p
	local var_56_5 = var_56_2.right_hand_ammo_unit_3p
	local var_56_6 = var_56_2.right_hand_wielded_unit
	local var_56_7 = var_56_2.right_hand_ammo_unit_1p
	local var_56_8 = var_56_2.left_hand_wielded_unit_3p
	local var_56_9 = var_56_2.left_hand_ammo_unit_3p
	local var_56_10 = var_56_2.left_hand_wielded_unit
	local var_56_11 = var_56_2.left_hand_ammo_unit_1p

	var_0_0.righthandweapon3p = var_56_4 or var_56_0
	var_0_0.righthandammo3p = var_56_5 or var_56_0
	var_0_0.righthandweapon = var_56_6 or var_56_0
	var_0_0.righthandammo1p = var_56_7 or var_56_0
	var_0_0.lefthandweapon3p = var_56_8 or var_56_0
	var_0_0.lefthandammo3p = var_56_9 or var_56_0
	var_0_0.lefthandweapon = var_56_10 or var_56_0
	var_0_0.lefthandammo1p = var_56_11 or var_56_0

	if var_56_7 and Unit.alive(var_56_7) then
		var_0_0.aliverighthandammo1p = true
	else
		var_0_0.aliverighthandammo1p = false
	end

	if var_56_11 and Unit.alive(var_56_11) then
		var_0_0.alivelefthandammo1p = true
	else
		var_0_0.alivelefthandammo1p = false
	end

	return var_0_0
end

function flow_query_ai_wielded_weapons(arg_57_0)
	local var_57_0 = arg_57_0.ai_unit
	local var_57_1 = ScriptUnit.has_extension(var_57_0, "ai_inventory_system")

	if not var_57_1 then
		var_0_0.weapon_1 = Unit.null_reference()
		var_0_0.weapon_2 = Unit.null_reference()

		return var_0_0
	end

	local var_57_2 = var_57_1.inventory_item_units

	for iter_57_0 = 1, 2 do
		var_0_0["weapon" .. iter_57_0] = var_57_2[iter_57_0] or Unit.null_reference()
	end

	return var_0_0
end

function flow_query_wielded_weapon_rarity(arg_58_0)
	var_0_0.rarity = ""

	local var_58_0 = Managers.player:local_player()

	if not var_58_0 then
		return var_0_0
	end

	local var_58_1 = var_58_0.player_unit

	if not var_0_1(var_58_1) then
		return var_0_0
	end

	local var_58_2 = ScriptUnit.has_extension(var_58_1, "inventory_system")

	if not var_58_2 then
		return var_0_0
	end

	local var_58_3 = var_58_2:get_wielded_slot_data()

	if not var_58_3 then
		return var_0_0
	end

	local var_58_4 = var_58_3.item_data.backend_id

	if not var_58_4 then
		return var_0_0
	end

	local var_58_5 = Managers.backend:get_interface("items"):get_item_from_id(var_58_4)

	if not var_58_5 then
		return var_0_0
	end

	local var_58_6 = var_58_5.rarity

	var_0_0.rarity = var_58_6 or ""

	return var_0_0
end

function flow_show_1p_ammo(arg_59_0)
	local var_59_0 = Managers.player:local_player()

	if not var_59_0 then
		return
	end

	local var_59_1 = var_59_0.player_unit

	if not var_0_1(var_59_1) then
		return
	end

	local var_59_2 = ScriptUnit.has_extension(var_59_1, "first_person_system")

	if not var_59_2 then
		return
	end

	local var_59_3 = arg_59_0.show

	var_59_2:show_first_person_ammo(var_59_3)
end

function flow_force_use_pickup_for_all_players(arg_60_0)
	if not Managers.player.is_server then
		return
	end

	local var_60_0 = arg_60_0.pickup_name
	local var_60_1 = NetworkLookup.pickup_names[var_60_0]

	Managers.state.network.network_transmit:send_rpc_server("rpc_force_use_pickup", var_60_1)
end

function flow_camera_shake(arg_61_0)
	DamageUtils.camera_shake_by_distance(arg_61_0.shake_name, Managers.time:time("game"), arg_61_0.player_unit, arg_61_0.shake_unit, arg_61_0.near_distance, arg_61_0.far_distance, arg_61_0.near_shake_scale, arg_61_0.far_shake_scale)
end

function flow_register_unit_extensions(arg_62_0)
	local var_62_0 = arg_62_0.unit
	local var_62_1 = Unit.get_data(var_62_0, "unit_template")

	fassert(var_62_1, "Missing unit_template!")

	local var_62_2 = Application.main_world()
	local var_62_3 = {
		navgraph_system = {
			nav_world = GLOBAL_AI_NAVWORLD
		}
	}

	Managers.state.unit_spawner:create_unit_extensions(var_62_2, var_62_0, var_62_1, var_62_3)
end

function flow_add_unit_extension(arg_63_0)
	local var_63_0 = arg_63_0.unit
	local var_63_1 = arg_63_0.extension

	fassert(var_63_1, "Missing extension")

	local var_63_2 = 0

	while Unit.has_data(var_63_0, "extensions", var_63_2) do
		var_63_2 = var_63_2 + 1
	end

	Unit.set_data(var_63_0, "extensions", var_63_2, var_63_1)
end

function flow_callback_debug_print_unit_actor(arg_64_0)
	print("FLOW DEBUG: Unit: ", tostring(arg_64_0.unit), "Actor: ", tostring(arg_64_0.actor))
end

function flow_callback_trigger_event(arg_65_0)
	Unit.flow_event(arg_65_0.unit, arg_65_0.event)
end

function flow_callback_play_screen_space_blood(arg_66_0)
	local var_66_0 = arg_66_0.effect

	Managers.state.blood:play_screen_space_blood(var_66_0, Vector3.zero())
end

function flow_callback_play_network_synched_particle_effect(arg_67_0)
	local var_67_0 = arg_67_0.effect
	local var_67_1 = arg_67_0.unit
	local var_67_2 = arg_67_0.object
	local var_67_3 = arg_67_0.offset or Vector3(0, 0, 0)
	local var_67_4 = arg_67_0.rotation_offset or Quaternion.identity()
	local var_67_5 = arg_67_0.linked or false
	local var_67_6 = Managers.state.network
	local var_67_7 = var_67_6:game()
	local var_67_8 = var_67_1 and var_67_5 and var_67_6:unit_game_object_id(var_67_1)

	fassert(var_67_7, "[flow_callback_play_network_synched_particle_effect] Trying to spawn effect with no network game running.")
	fassert(not var_67_1 or not var_67_5 or var_67_8, "[flow_callback_play_network_synched_particle_effect] Trying to spawn effect linked to unit not network_synched.")
	fassert(var_67_1 or not var_67_2, "[flow_callback_play_network_synched_particle_effect] Trying to spawn effect at object in unit without defining unit.")

	local var_67_9 = var_67_1 and var_67_2 and Unit.node(var_67_1, var_67_2) or 0

	Managers.state.event:trigger("event_play_particle_effect", var_67_0, var_67_1, var_67_9, var_67_3, var_67_4, var_67_5)

	if var_67_1 and not var_67_8 then
		local var_67_10 = Unit.world_pose(var_67_1, var_67_9)
		local var_67_11 = Matrix4x4.from_quaternion_position(var_67_4, var_67_3)
		local var_67_12 = Matrix4x4.multiply(var_67_11, var_67_10)

		var_67_3 = Matrix4x4.translation(var_67_12)
		var_67_4 = Matrix4x4.rotation(var_67_12)
	end

	if Managers.player.is_server then
		var_67_6.network_transmit:send_rpc_clients("rpc_play_particle_effect", NetworkLookup.effects[var_67_0], var_67_8 or 0, var_67_9, var_67_3, var_67_4, var_67_5)
	else
		var_67_6.network_transmit:send_rpc_server("rpc_play_particle_effect", NetworkLookup.effects[var_67_0], var_67_8 or 0, var_67_9, var_67_3, var_67_4, var_67_5)
	end
end

function flow_callback_output_debug_screen_text(arg_68_0)
	return
end

function flow_callback_debug_crash_game(arg_69_0)
	if Application.crash then
		local var_69_0 = arg_69_0.type or "access_violation"

		Application.crash(var_69_0)
	end
end

function flow_callback_debug_draw_line(arg_70_0)
	local var_70_0 = arg_70_0.stay and QuickDrawerStay or QuickDrawer
	local var_70_1 = arg_70_0.from
	local var_70_2 = arg_70_0.to
	local var_70_3 = arg_70_0.color

	var_70_0:line(var_70_1, var_70_2, var_70_3)
end

function flow_callback_debug_draw_vector(arg_71_0)
	local var_71_0 = arg_71_0.stay and QuickDrawerStay or QuickDrawer
	local var_71_1 = arg_71_0.vector
	local var_71_2 = arg_71_0.color

	var_71_0:vector(var_71_1, var_71_2)
end

function flow_callback_debug_draw_sphere(arg_72_0)
	local var_72_0 = arg_72_0.stay and QuickDrawerStay or QuickDrawer
	local var_72_1 = arg_72_0.center
	local var_72_2 = arg_72_0.radius
	local var_72_3 = arg_72_0.color
	local var_72_4 = arg_72_0.segments
	local var_72_5 = arg_72_0.parts

	var_72_0:sphere(var_72_1, var_72_2, var_72_3, var_72_4, var_72_5)
end

function flow_callback_debug_draw_capsule(arg_73_0)
	local var_73_0 = arg_73_0.stay and QuickDrawerStay or QuickDrawer
	local var_73_1 = arg_73_0.from
	local var_73_2 = arg_73_0.to
	local var_73_3 = arg_73_0.radius
	local var_73_4 = arg_73_0.color

	var_73_0:capsule(var_73_1, var_73_2, var_73_3, var_73_4)
end

function flow_callback_debug_draw_box(arg_74_0)
	local var_74_0 = arg_74_0.stay and QuickDrawerStay or QuickDrawer
	local var_74_1 = arg_74_0.position
	local var_74_2 = arg_74_0.rotation
	local var_74_3 = arg_74_0.extents
	local var_74_4 = arg_74_0.color
	local var_74_5 = Matrix4x4.from_quaternion_position(var_74_2, var_74_1)

	var_74_0:box(var_74_5, var_74_3, var_74_4)
end

function flow_callback_debug_draw_circle(arg_75_0)
	local var_75_0 = arg_75_0.stay and QuickDrawerStay or QuickDrawer
	local var_75_1 = arg_75_0.center
	local var_75_2 = arg_75_0.radius
	local var_75_3 = arg_75_0.normal
	local var_75_4 = arg_75_0.color
	local var_75_5 = arg_75_0.segments

	var_75_0:circle(var_75_1, var_75_2, var_75_3, var_75_4, var_75_5)
end

function flow_callback_reload_level(arg_76_0)
	if Managers.player.is_server then
		Managers.state.game_mode:retry_level()
	end
end

function flow_callback_complete_level(arg_77_0)
	if Managers.player.is_server then
		print("Level flags level completed.")
		Managers.state.game_mode:complete_level()
	end
end

function flow_callback_fail_level(arg_78_0)
	if Managers.player.is_server then
		Managers.state.game_mode:fail_level()
	end
end

function flow_callback_menu_camera_dummy_spawned(arg_79_0)
	Managers.state.event:trigger("menu_camera_dummy_spawned", arg_79_0.camera_name, arg_79_0.unit)
end

function flow_callback_menu_alignment_dummy_spawned(arg_80_0)
	Managers.state.event:trigger("menu_alignment_dummy_spawned", arg_80_0.alignment_name, arg_80_0.unit)
end

function flow_callback_block_profile_menu_accept_button(arg_81_0)
	local var_81_0 = arg_81_0.unit
	local var_81_1 = Managers.player:players()[Network.peer_id()].player_unit

	if var_0_1(var_81_1) and var_81_1 == var_81_0 then
		global_profile_view:block_accept_button(true)
	end
end

function flow_callback_unblock_profile_menu_accept_button(arg_82_0)
	local var_82_0 = arg_82_0.unit
	local var_82_1 = Managers.player:players()[Network.peer_id()].player_unit

	if var_0_1(var_82_1) and var_82_1 == var_82_0 then
		global_profile_view:block_accept_button(false)
	end
end

function flow_callback_event_enable_level_select(arg_83_0)
	Managers.state.event:trigger("event_enable_level_select")
end

function flow_callback_set_actor_enabled(arg_84_0)
	local var_84_0 = arg_84_0.unit

	fassert(var_84_0, "Set Actor Enabled flow node is missing unit")

	local var_84_1 = arg_84_0.actor or Unit.actor(var_84_0, arg_84_0.actor_name)

	fassert(var_84_1, "Set Actor Enabled flow node referring to unit %s is missing actor %s", tostring(var_84_0), tostring(arg_84_0.actor or arg_84_0.actor_name))
	Actor.set_collision_enabled(var_84_1, arg_84_0.enabled)
	Actor.set_scene_query_enabled(var_84_1, arg_84_0.enabled)
end

function flow_callback_set_actor_kinematic(arg_85_0)
	local var_85_0 = arg_85_0.unit

	fassert(var_85_0, "Set Actor Kinematic flow node is missing unit")

	local var_85_1 = arg_85_0.actor or Unit.actor(var_85_0, arg_85_0.actor_name)

	fassert(var_85_1, "Set Actor Kinematic flow node referring to unit %s is missing actor %s", tostring(var_85_0), tostring(arg_85_0.actor or arg_85_0.actor_name))
	Actor.set_kinematic(var_85_1, arg_85_0.enabled)
end

function flow_callback_spawn_actor(arg_86_0)
	local var_86_0 = arg_86_0.unit

	fassert(var_86_0, "Spawn Actor flow node is missing unit")

	local var_86_1 = arg_86_0.actor_name

	Unit.create_actor(var_86_0, var_86_1)
end

function flow_callback_destroy_actor(arg_87_0)
	local var_87_0 = arg_87_0.unit

	fassert(var_87_0, "Destroy Actor flow node is missing unit")

	local var_87_1 = arg_87_0.actor_name

	Unit.destroy_actor(var_87_0, var_87_1)
end

function flow_callback_set_actor_initial_velocity(arg_88_0)
	local var_88_0 = arg_88_0.unit

	fassert(var_88_0, "Set actor initial velocity has no unit")
	Unit.apply_initial_actor_velocities(var_88_0, true)
end

function flow_callback_set_unit_material_variation(arg_89_0)
	local var_89_0 = arg_89_0.unit
	local var_89_1 = arg_89_0.material_variation

	Unit.set_material_variation(var_89_0, var_89_1)
end

function flow_callback_setup_profiling_level_step_1()
	local var_90_0 = Mouse.pressed

	Mouse.pressed = function (arg_91_0)
		if arg_91_0 == 0 then
			Mouse.pressed = var_90_0

			return true
		else
			return false
		end
	end
end

function flow_callback_setup_profiling_level_step_2()
	local var_92_0 = Keyboard.pressed

	Keyboard.pressed = function (arg_93_0)
		if arg_93_0 == 120 then
			Keyboard.pressed = var_92_0

			return true
		else
			return false
		end
	end
end

function flow_callback_setup_profiling_level_step_3()
	local var_94_0 = Managers.state.entity:system("cutscene_system")._cameras
	local var_94_1

	for iter_94_0, iter_94_1 in pairs(var_94_0) do
		if iter_94_0 == "profiling_camera" then
			var_94_1 = iter_94_1
		end
	end

	local var_94_2 = var_94_1._unit
	local var_94_3 = Unit.world_pose(var_94_2, 0)
	local var_94_4 = Application.main_world()
	local var_94_5 = ScriptWorld.name(var_94_4)
	local var_94_6 = ScriptWorld.global_free_flight_viewport(var_94_4, var_94_5)
	local var_94_7 = ScriptViewport.camera(var_94_6)

	ScriptCamera.set_local_pose(var_94_7, var_94_3)
	Managers.state.event:trigger("force_close_ingame_menu")
end

function flow_callback_play_footstep_surface_material_effects(arg_95_0)
	EffectHelper.flow_cb_play_footstep_surface_material_effects(arg_95_0.effect_name, arg_95_0.unit, arg_95_0.object, arg_95_0.foot_direction, arg_95_0.use_occlusion or false)
end

function flow_callback_play_surface_material_effect(arg_96_0)
	local var_96_0 = arg_96_0.hit_unit
	local var_96_1
	local var_96_2 = arg_96_0.range
	local var_96_3 = arg_96_0.offset
	local var_96_4 = arg_96_0.normal
	local var_96_5 = Quaternion.look(arg_96_0.normal, Vector3.up())

	EffectHelper.flow_cb_play_surface_material_effect(arg_96_0.effect_name, var_96_0, arg_96_0.position, var_96_5, var_96_4, var_96_1, arg_96_0.husk, var_96_3, var_96_2)
end

function flow_callback_play_move_particle(arg_97_0)
	local var_97_0 = arg_97_0.particle_id
	local var_97_1 = arg_97_0.position
	local var_97_2 = Application.flow_callback_context_world()

	World.move_particles(var_97_2, var_97_0, var_97_1)
end

function flow_callback_play_voice(arg_98_0)
	local var_98_0 = arg_98_0.playing_unit
	local var_98_1 = arg_98_0.event_name
	local var_98_2 = arg_98_0.use_occlusion or false
	local var_98_3 = ScriptUnit.has_extension_input(var_98_0, "dialogue_system")

	if var_98_3 then
		var_98_3:play_voice(var_98_1, var_98_2)
	end
end

function flow_callback_foot_step(arg_99_0)
	local var_99_0 = arg_99_0.unit
end

function flow_callback_is_local_player(arg_100_0)
	local var_100_0 = arg_100_0.unit
	local var_100_1 = Managers.player:players()[1].player_unit

	if var_0_1(var_100_1) then
		if var_100_0 == var_100_1 then
			var_0_0.is_player = true
			var_0_0.is_not_player = false
		else
			var_0_0.is_player = false
			var_0_0.is_not_player = true
		end
	else
		var_0_0.is_player = false
		var_0_0.is_not_player = true
	end

	return var_0_0
end

function flow_callback_get_unit_type(arg_101_0)
	local var_101_0 = arg_101_0.unit
	local var_101_1 = Unit.get_data(var_101_0, "breed")
	local var_101_2 = Unit.get_data(var_101_0, "bot")

	if var_101_1 or var_101_2 then
		var_0_0.is_local_player = false
		var_0_0.is_remote_player = false
		var_0_0.is_ai = true
		var_0_0.is_environment = false
	else
		local var_101_3 = Managers.player:owner(var_101_0)

		if var_101_3 ~= nil then
			if var_101_3.remote then
				var_0_0.is_local_player = true
				var_0_0.is_remote_player = false
				var_0_0.is_ai = false
				var_0_0.is_environment = false
			else
				var_0_0.is_local_player = false
				var_0_0.is_remote_player = true
				var_0_0.is_ai = false
				var_0_0.is_environment = false
			end
		else
			var_0_0.is_local_player = false
			var_0_0.is_remote_player = false
			var_0_0.is_ai = false
			var_0_0.is_environment = true
		end
	end

	return var_0_0
end

function flow_callback_trigger_sound(arg_102_0)
	local var_102_0

	if arg_102_0.world_name then
		local var_102_1 = Managers.world:world(arg_102_0.world_name)

		var_102_0 = Managers.world:wwise_world(var_102_1)
	else
		local var_102_2 = Application.main_world()

		var_102_0 = Managers.world:wwise_world(var_102_2)
	end

	if arg_102_0.unit then
		if arg_102_0.actor then
			WwiseWorld.trigger_event(var_102_0, arg_102_0.event, arg_102_0.use_occlusion, arg_102_0.unit, Unit.actor(arg_102_0.unit, arg_102_0.actor))
		else
			WwiseWorld.trigger_event(var_102_0, arg_102_0.event, arg_102_0.use_occlusion, arg_102_0.unit)
		end
	elseif arg_102_0.position then
		WwiseWorld.trigger_event(var_102_0, arg_102_0.event, arg_102_0.use_occlusion, arg_102_0.position)
	else
		WwiseWorld.trigger_event(var_102_0, arg_102_0.event)
	end
end

function flow_callback_print_variable(arg_103_0)
	print(arg_103_0.string, arg_103_0.variable)
end

function flow_callback_set_environment(arg_104_0)
	local var_104_0 = arg_104_0.environment_name
	local var_104_1 = arg_104_0.time

	Managers.state.event:trigger("set_environment", var_104_0, var_104_1)
end

function flow_callback_start_bus_transition(arg_105_0)
	Managers.music:start_bus_transition(arg_105_0.bus_name, arg_105_0.target_value, arg_105_0.duration, arg_105_0.transition_type, arg_105_0.from_value)
end

function flow_callback_game_mode_event(arg_106_0)
	local var_106_0 = arg_106_0.announcement
	local var_106_1 = arg_106_0.side
	local var_106_2 = arg_106_0.param_1 or ""
	local var_106_3 = arg_106_0.param_2 or ""

	Managers.state.game_mode:trigger_event("flow", var_106_0, var_106_1, var_106_2, var_106_3)
end

function flow_callback_thrown_projectile_bounce(arg_107_0)
	local var_107_0 = arg_107_0.unit

	if var_0_1(var_107_0) and ScriptUnit.has_extension(var_107_0, "projectile_system") then
		ScriptUnit.extension(var_107_0, "projectile_system"):flow_cb_bounce(arg_107_0.hit_unit, arg_107_0.hit_actor, arg_107_0.position, arg_107_0.normal)
	end
end

function flow_callback_projectile_impacts_stopped(arg_108_0)
	local var_108_0 = arg_108_0.unit
	local var_108_1 = true
	local var_108_2 = ALIVE[var_108_0] and ScriptUnit.has_extension(var_108_0, "projectile_system")

	if var_108_2 and var_108_2.are_impacts_stopped then
		var_108_1 = var_108_2:are_impacts_stopped()
	end

	var_0_0.impacts_stopped = var_108_1

	return var_0_0
end

function flow_callback_mark_sack_for_linking(arg_109_0)
	local var_109_0 = arg_109_0.unit

	Unit.set_data(var_109_0, "link_to_unit", true)
end

function flow_callback_remove_link_mark_for_sack(arg_110_0)
	local var_110_0 = arg_110_0.unit

	Unit.set_data(var_110_0, "link_to_unit", nil)
end

function flow_callback_start_network_timer(arg_111_0)
	if Managers.player.is_server then
		local var_111_0 = arg_111_0.time

		Managers.state.event:trigger("event_start_network_timer", var_111_0)
	end
end

function flow_callback_set_flow_object_set_enabled(arg_112_0)
	fassert(arg_112_0.set, "[Flow Callback : Set Flow Object Set Enabled] No set set.")
	fassert(arg_112_0.enabled ~= nil, "[Flow Callback : Set Flow Object Set Enabled] No enabled set.")

	if Managers.state.game_mode then
		Managers.state.game_mode:flow_cb_set_flow_object_set_enabled(arg_112_0.set, arg_112_0.enabled)
	else
		Managers.state.event:trigger("set_flow_object_set_enabled", arg_112_0.set, arg_112_0.enabled)
	end
end

function flow_callback_set_flow_object_set_particles_enabled(arg_113_0)
	fassert(arg_113_0.set, "[Flow Callback : Set Flow Object Set Particles Enabled] No set set.")
	fassert(arg_113_0.enabled ~= nil, "[Flow Callback : Set Flow Object Set Particles Enabled] No enabled set.")

	local var_113_0 = Application.flow_callback_context_world()
	local var_113_1 = LevelHelper:current_level(var_113_0)

	if arg_113_0.enabled then
		Level.start_particle_effects_in_object_set(var_113_1, "flow_" .. arg_113_0.set)
	else
		Level.stop_particle_effects_in_object_set(var_113_1, "flow_" .. arg_113_0.set)
	end
end

flow_cb_set_flow_object_set_enabled = flow_callback_set_flow_object_set_enabled

function flow_callback_create_networked_flow_state(arg_114_0)
	local var_114_0 = Managers.state.networked_flow_state

	if var_114_0 then
		local var_114_1, var_114_2 = var_114_0:flow_cb_create_state(arg_114_0.unit, arg_114_0.state_name, arg_114_0.in_value, arg_114_0.client_state_changed_event, arg_114_0.client_hot_join_event, arg_114_0.is_game_object)

		if var_114_1 then
			var_0_0.created = var_114_1
			var_0_0.out_value = var_114_2

			return var_0_0
		end
	else
		local var_114_3 = arg_114_0.flow_state_unit

		Managers.level_transition_handler:queue_create_networked_flow_state(var_114_3)
	end
end

function flow_callback_change_networked_flow_state(arg_115_0)
	local var_115_0 = Managers.state.networked_flow_state

	if var_115_0 then
		local var_115_1, var_115_2 = var_115_0:flow_cb_change_state(arg_115_0.unit, arg_115_0.state_name, arg_115_0.in_value)

		if var_115_1 then
			var_0_0.changed = var_115_1
			var_0_0.out_value = var_115_2

			return var_0_0
		end
	end
end

function flow_callback_get_networked_flow_state(arg_116_0)
	local var_116_0 = Managers.state.networked_flow_state

	if var_116_0 then
		local var_116_1 = var_116_0:flow_cb_get_state(arg_116_0.unit, arg_116_0.state_name)

		var_0_0.out_value = var_116_1

		return var_0_0
	end
end

function flow_callback_client_networked_flow_state_changed(arg_117_0)
	local var_117_0 = Managers.state.networked_flow_state

	if var_117_0 then
		local var_117_1 = var_117_0:flow_cb_get_state(arg_117_0.unit, arg_117_0.state_name)

		var_0_0.changed = true
		var_0_0.out_value = var_117_1

		return var_0_0
	end
end

function flow_callback_client_networked_flow_state_set(arg_118_0)
	local var_118_0 = Managers.state.networked_flow_state

	if var_118_0 then
		local var_118_1 = var_118_0:flow_cb_get_state(arg_118_0.unit, arg_118_0.state_name)

		var_0_0.set = true
		var_0_0.out_value = var_118_1

		return var_0_0
	end
end

function flow_callback_create_networked_story(arg_119_0)
	local var_119_0 = Managers.state.networked_flow_state

	if var_119_0 then
		return var_119_0:flow_cb_create_story(arg_119_0)
	end
end

function flow_callback_networked_story_client_call(arg_120_0)
	local var_120_0 = Managers.state.networked_flow_state

	if var_120_0 then
		return var_120_0:flow_cb_networked_story_client_call(arg_120_0)
	end
end

function flow_callback_has_stopped_networked_story(arg_121_0)
	local var_121_0 = Managers.state.networked_flow_state

	if var_121_0 then
		return var_121_0:flow_cb_has_stopped_networked_story(arg_121_0)
	end
end

function flow_callback_has_played_networked_story(arg_122_0)
	local var_122_0 = Managers.state.networked_flow_state

	if var_122_0 then
		return var_122_0:flow_cb_has_played_networked_story(arg_122_0)
	end
end

function flow_callback_play_networked_story(arg_123_0)
	local var_123_0 = Managers.state.networked_flow_state

	if var_123_0 then
		return var_123_0:flow_cb_play_networked_story(arg_123_0)
	end
end

function flow_callback_stop_networked_story(arg_124_0)
	local var_124_0 = Managers.state.networked_flow_state

	if var_124_0 then
		return var_124_0:flow_cb_stop_networked_story(arg_124_0)
	end
end

function flow_callback_invert_bool(arg_125_0)
	var_0_0.out = true
	var_0_0.out_value = not arg_125_0.in_value

	return var_0_0
end

function flow_callback_projectile_bounce(arg_126_0)
	local var_126_0 = arg_126_0.unit
	local var_126_1 = arg_126_0.touching_unit
	local var_126_2 = arg_126_0.position
	local var_126_3 = arg_126_0.normal
	local var_126_4 = arg_126_0.separation_distance
	local var_126_5 = arg_126_0.impulse_force

	ScriptUnit.extension(var_126_0, "locomotion_system"):bounce(var_126_1, var_126_2, var_126_3, var_126_4, var_126_5)
end

function flow_callback_get_random_player(arg_127_0)
	local var_127_0 = PlayerUtils.get_random_alive_hero() or Unit.null_reference()

	var_0_0.playerunit = var_127_0

	return var_0_0
end

function flow_callback_get_local_player_unit(arg_128_0)
	local var_128_0 = Managers.player:local_player()
	local var_128_1 = var_128_0 and var_128_0.player_unit

	if var_128_1 and Unit.alive(var_128_1) then
		var_0_0.localplayer = var_128_1
	else
		var_0_0.localplayer = Unit.null_reference()
	end

	return var_0_0
end

local var_0_3 = {}

function flow_callback_get_random_player_or_global_observer(arg_129_0)
	table.clear(var_0_3)

	local var_129_0 = var_0_3
	local var_129_1 = 0
	local var_129_2 = PlayerUtils.get_random_alive_hero()

	if var_129_2 then
		var_129_0[1] = var_129_2
		var_129_1 = 1
	end

	local var_129_3 = Managers.state.entity:system("surrounding_aware_system").global_observers

	for iter_129_0 in pairs(var_129_3) do
		var_129_1 = var_129_1 + 1
		var_129_0[var_129_1] = iter_129_0
	end

	if var_129_1 > 0 then
		local var_129_4 = var_129_0[math.random(1, var_129_1)]

		var_0_0.unit = var_129_4
	else
		var_0_0.unit = Unit.null_reference()
	end

	return var_0_0
end

function flow_callback_get_random_global_observer(arg_130_0)
	local var_130_0 = Managers.state.entity:system("surrounding_aware_system").global_observers

	table.clear(var_0_3)

	local var_130_1 = var_0_3
	local var_130_2 = 0

	for iter_130_0 in pairs(var_130_0) do
		var_130_2 = var_130_2 + 1
		var_130_1[var_130_2] = iter_130_0
	end

	if var_130_2 > 0 then
		local var_130_3 = var_130_1[math.random(1, var_130_2)]

		var_0_0.unit = var_130_3

		return var_0_0
	end

	return nil
end

function flow_callback_trigger_dialogue_event(arg_131_0)
	local var_131_0 = arg_131_0.source

	fassert(var_131_0, "Calling flow_callback_trigger_dialogue_event without passing unit")

	if ScriptUnit.has_extension(var_131_0, "dialogue_system") then
		local var_131_1 = ScriptUnit.extension_input(var_131_0, "dialogue_system")
		local var_131_2 = FrameTable.alloc_table()

		if arg_131_0.argument1_name then
			var_131_2[arg_131_0.argument1_name] = tonumber(arg_131_0.argument1) or arg_131_0.argument1
		end

		if arg_131_0.argument2_name then
			var_131_2[arg_131_0.argument2_name] = tonumber(arg_131_0.argument2) or arg_131_0.argument2
		end

		if arg_131_0.argument3_name then
			var_131_2[arg_131_0.argument3_name] = tonumber(arg_131_0.argument3) or arg_131_0.argument3
		end

		var_131_1:trigger_dialogue_event(arg_131_0.concept, var_131_2, arg_131_0.identifier)
	else
		print(string.format("[flow_callback_trigger_dialogue_event] No extension found belonging to system \"dialogue_system\" for unit %s", tostring(var_131_0)))
	end
end

function flow_callback_trigger_networked_dialogue_event(arg_132_0)
	local var_132_0 = arg_132_0.source

	fassert(var_132_0, "Calling flow_callback_trigger_dialogue_event without passing unit")

	if ScriptUnit.has_extension(var_132_0, "dialogue_system") then
		local var_132_1 = ScriptUnit.extension_input(var_132_0, "dialogue_system")
		local var_132_2 = FrameTable.alloc_table()

		if arg_132_0.argument1_name then
			var_132_2[arg_132_0.argument1_name] = tonumber(arg_132_0.argument1) or arg_132_0.argument1
		end

		if arg_132_0.argument2_name then
			var_132_2[arg_132_0.argument2_name] = tonumber(arg_132_0.argument2) or arg_132_0.argument2
		end

		if arg_132_0.argument3_name then
			var_132_2[arg_132_0.argument3_name] = tonumber(arg_132_0.argument3) or arg_132_0.argument3
		end

		var_132_1:trigger_networked_dialogue_event(arg_132_0.concept, var_132_2, arg_132_0.identifier)
	else
		print(string.format("[flow_callback_trigger_networked_dialogue_event] No extension found belonging to system \"dialogue_system\" for unit %s", tostring(var_132_0)))
	end
end

flow_callback_trigger_ensured_dialogue_event = flow_callback_trigger_dialogue_event

function flow_callback_trigger_dialogue_event_on_players(arg_133_0)
	local var_133_0 = Managers.player:players()

	for iter_133_0, iter_133_1 in pairs(var_133_0) do
		local var_133_1 = iter_133_1.player_unit

		if ALIVE[var_133_1] then
			arg_133_0.source = var_133_1

			flow_callback_trigger_dialogue_event(arg_133_0)
		end
	end
end

flow_callback_trigger_ensured_dialogue_event_on_players = flow_callback_trigger_dialogue_event_on_players

function flow_callback_change_outline_params(arg_134_0)
	if DEDICATED_SERVER then
		return
	end

	local var_134_0 = arg_134_0.unit
	local var_134_1 = ScriptUnit.has_extension(var_134_0, "outline_system")

	fassert(var_134_1, "Trying to change outline params through flow without an outline extension on the unit")

	local var_134_2 = arg_134_0.method

	if var_134_2 then
		var_134_1:update_outline({
			method = var_134_2
		}, 0)
	end

	local var_134_3 = OutlineSettings.colors[arg_134_0.color]

	if var_134_3 then
		var_134_1:update_outline({
			outline_color = var_134_3
		}, 0)
	end
end

function flow_callback_register_transport_navmesh_units(arg_135_0)
	local var_135_0 = arg_135_0.unit
	local var_135_1 = arg_135_0.start_unit
	local var_135_2 = arg_135_0.end_unit

	ScriptUnit.extension(var_135_0, "transportation_system"):register_navmesh_units(var_135_1, var_135_2)
end

function flow_callback_start_transport(arg_136_0)
	local var_136_0 = arg_136_0.transport_unit
	local var_136_1 = Managers.player:local_player().player_unit

	ScriptUnit.extension(var_136_0, "transportation_system"):interacted_with(var_136_1)
end

function flow_callback_set_door_state_and_duration(arg_137_0)
	local var_137_0 = arg_137_0.unit
	local var_137_1 = arg_137_0.new_door_state
	local var_137_2 = arg_137_0.frames
	local var_137_3 = arg_137_0.speed

	ScriptUnit.extension(var_137_0, "door_system"):set_door_state_and_duration(var_137_1, var_137_2, var_137_3)
end

function flow_callback_set_door_state(arg_138_0)
	local var_138_0 = arg_138_0.unit
	local var_138_1 = arg_138_0.new_door_state
	local var_138_2 = ScriptUnit.extension(var_138_0, "door_system")

	var_138_2:set_door_state(var_138_1)

	var_138_2.frames_since_obstacle_update = 0
end

function flow_callback_door_animation_played(arg_139_0)
	local var_139_0 = arg_139_0.unit
	local var_139_1 = arg_139_0.frames
	local var_139_2 = arg_139_0.speed

	ScriptUnit.extension(var_139_0, "door_system"):animation_played(var_139_1, var_139_2)
end

function flow_callback_set_valid_ai_target(arg_140_0)
	local var_140_0 = arg_140_0.unit
	local var_140_1 = arg_140_0.valid_target

	ScriptUnit.extension(var_140_0, "ai_slot_system").valid_target = var_140_1
end

function flow_callback_set_ai_aggro_modifier(arg_141_0)
	local var_141_0 = arg_141_0.unit
	local var_141_1 = arg_141_0.aggro_modifier

	ScriptUnit.extension(var_141_0, "aggro_system").aggro_modifier = var_141_1 * -1
end

function flow_callback_objective_entered_socket_zone(arg_142_0)
	print("[flow_callback_objective_entered_socket_zone]", arg_142_0.socket_unit, arg_142_0.objective_unit)

	if Managers.player.is_server then
		local var_142_0 = arg_142_0.socket_unit
		local var_142_1 = arg_142_0.objective_unit

		if (Unit.get_data(var_142_0, "socket_type") or "none") == (Unit.get_data(var_142_1, "socket_type") or "none") then
			ScriptUnit.extension(var_142_0, "objective_socket_system"):objective_entered_zone_server(var_142_1)
		else
			print("[flow_callback_objective_entered_socket_zone] Socket type doesn't match", arg_142_0.socket_unit, arg_142_0.objective_unit)
		end
	end
end

function flow_callback_ussingen_barrel_challenge(arg_143_0)
	print("[flow_callback_ussingen_barrel_challenge]", arg_143_0.barrel_unit)

	if Managers.player.is_server then
		local var_143_0 = arg_143_0.barrel_unit
		local var_143_1 = arg_143_0.num_valid_barrels

		if not ScriptUnit.has_extension(var_143_0, "limited_item_track_system") then
			var_0_0.is_valid_barrel = 1

			return var_0_0
		end
	end

	var_0_0.is_valid_barrel = 0

	return var_0_0
end

function flow_callback_ussingen_barrel_challenge_completed(arg_144_0)
	print("[flow_callback_ussingen_barrel_challenge_completed]")

	if Managers.player.is_server then
		local var_144_0 = {
			"ussingen_used_no_barrels",
			"ussingen_used_no_barrels_cata"
		}

		for iter_144_0 = 1, #var_144_0 do
			local var_144_1 = Managers.state.difficulty:get_difficulty()

			if QuestSettings.allowed_difficulties[var_144_0[iter_144_0]][var_144_1] and arg_144_0.num_valid_barrels >= 3 then
				Managers.player:statistics_db():increment_stat_and_sync_to_clients(var_144_0[iter_144_0])
			end
		end
	end
end

function flow_callback_occupied_sockets_query(arg_145_0)
	local var_145_0 = arg_145_0.socket_unit
	local var_145_1 = ScriptUnit.extension(var_145_0, "objective_socket_system").num_closed_sockets

	var_0_0.sockets = var_145_1

	return var_0_0
end

function flow_callback_register_environment_volume(arg_146_0)
	local var_146_0 = arg_146_0.particle_light_intensity or 1

	if arg_146_0.shading_environment then
		Managers.state.event:trigger("register_environment_volume", arg_146_0.volume_name, arg_146_0.shading_environment, arg_146_0.priority, arg_146_0.blend_time, arg_146_0.override_sun_snap, var_146_0)
	end
end

function flow_callback_enable_environment_volume(arg_147_0)
	fassert(arg_147_0.volume_name, "[flow_callbacks] No volume name provided [required]")
	Managers.state.event:trigger("enable_environment_volume", arg_147_0.volume_name, arg_147_0.enable)
end

function flow_callback_volume_system_register_damage_volume(arg_148_0)
	Managers.state.entity:system("volume_system"):register_volume(arg_148_0.volume_name, "damage_volume", arg_148_0)
end

function flow_callback_volume_system_register_movement_volume(arg_149_0)
	Managers.state.entity:system("volume_system"):register_volume(arg_149_0.volume_name, "movement_volume", arg_149_0)
end

function flow_callback_volume_system_register_location_volume(arg_150_0)
	local var_150_0 = Managers.state.entity:system("volume_system")

	fassert(NetworkLookup.locations[arg_150_0.location], "Volume location named [\"%s\"] needs to be added to NetworkLookup.locations", arg_150_0.location)
	var_150_0:register_volume(arg_150_0.volume_name, "location_volume", arg_150_0)
end

function flow_callback_volume_system_register_trigger_volume(arg_151_0)
	Managers.state.entity:system("volume_system"):register_volume(arg_151_0.volume_name, "trigger_volume", arg_151_0)
end

function flow_callback_volume_system_register_despawn_volume(arg_152_0)
	Managers.state.entity:system("volume_system"):register_volume(arg_152_0.volume_name, "despawn_volume", arg_152_0)
end

function flow_callback_volume_system_unregister_volume(arg_153_0)
	Managers.state.entity:system("volume_system"):unregister_volume(arg_153_0.volume_name)
end

function flow_callback_intro_cutscene_show_location(arg_154_0)
	fassert(arg_154_0.location, "No location set")

	local var_154_0 = Managers.player:local_player().player_unit

	fassert(var_0_1(var_154_0), "Tried showing location with no player unit spawned")
	ScriptUnit.extension(var_154_0, "hud_system"):set_current_location(arg_154_0.location)
end

function flow_callback_local_player_profile_switch(arg_155_0)
	local var_155_0 = Managers.player:local_player():profile_index()
	local var_155_1 = SPProfiles[var_155_0].display_name

	return {
		witch_hunter = var_155_1 == "witch_hunter",
		bright_wizard = var_155_1 == "bright_wizard",
		dwarf_ranger = var_155_1 == "dwarf_ranger",
		wood_elf = var_155_1 == "wood_elf",
		empire_soldier = var_155_1 == "empire_soldier"
	}
end

function flow_callback_local_player_profile_check(arg_156_0)
	local var_156_0 = Managers.player:local_player():profile_index()
	local var_156_1 = SPProfiles[var_156_0].display_name

	return {
		player_profile = var_156_1
	}
end

function flow_callback_local_player_profile_available(arg_157_0)
	local var_157_0 = Managers.player:local_player_safe()

	if not var_157_0 then
		return {
			is_available = false
		}
	end

	local var_157_1 = var_157_0:profile_index()
	local var_157_2 = SPProfiles[var_157_1]
	local var_157_3 = var_157_2 and var_157_2.display_name

	return {
		is_available = var_157_3 ~= nil
	}
end

function flow_callback_compare_string(arg_158_0)
	local var_158_0 = arg_158_0.a
	local var_158_1 = arg_158_0.b

	return {
		equals = var_158_0 == var_158_1,
		not_equals = var_158_0 ~= var_158_1
	}
end

function flow_callback_set_allowed_nav_tag_volume_layer(arg_159_0)
	local var_159_0 = arg_159_0.layer
	local var_159_1 = arg_159_0.allowed

	Managers.state.entity:system("ai_system"):set_allowed_layer(var_159_0, var_159_1)
end

function flow_callback_register_spline_properties(arg_160_0)
	local var_160_0 = arg_160_0.spline_name
	local var_160_1 = arg_160_0.despawn_patrol_at_end_of_spline

	Managers.state.entity:system("ai_group_system"):register_spline_properties(var_160_0, {
		despawn_patrol_at_end_of_spline = var_160_1
	})
end

function flow_callback_register_sound_environment(arg_161_0)
	if DEDICATED_SERVER then
		return
	end

	local var_161_0 = arg_161_0.volume_name
	local var_161_1 = arg_161_0.prio
	local var_161_2 = arg_161_0.ambient_sound_event
	local var_161_3 = arg_161_0.fade_time
	local var_161_4 = arg_161_0.aux_bus_name
	local var_161_5 = arg_161_0.environment_state

	Managers.state.entity:system("sound_environment_system"):register_sound_environment(var_161_0, var_161_1, var_161_2, var_161_3, var_161_4, var_161_5)
end

function flow_callback_trigger_wwise_event_for_target_player(arg_162_0)
	if not arg_162_0.ai_unit then
		return
	end

	local var_162_0 = BLACKBOARDS[arg_162_0.ai_unit]
	local var_162_1 = var_162_0 and var_162_0.target_unit
	local var_162_2 = Managers.player:local_player()
	local var_162_3 = var_162_2 and var_162_2.player_unit

	if not (var_162_1 and var_162_1 == var_162_3) then
		return
	end

	if DEDICATED_SERVER or not Managers.state.entity then
		var_0_0.playing_id = 1
		var_0_0.source_id = 1

		return var_0_0
	end

	local var_162_4 = arg_162_0.name
	local var_162_5 = Managers.state.entity:system("sound_environment_system").wwise_world
	local var_162_6 = WwiseWorld.trigger_event(var_162_5, var_162_4)

	var_0_0.playing_id = var_162_6

	return var_0_0
end

function flow_callback_wwise_trigger_event_with_environment(arg_163_0)
	if DEDICATED_SERVER or not Managers.state.entity then
		var_0_0.playing_id = 1
		var_0_0.source_id = 1

		return var_0_0
	end

	local var_163_0 = arg_163_0.position
	local var_163_1 = arg_163_0.unit
	local var_163_2 = arg_163_0.unit_node
	local var_163_3 = arg_163_0.name
	local var_163_4 = arg_163_0.use_occlusion or false
	local var_163_5 = Managers.state.entity:system("sound_environment_system")
	local var_163_6 = var_163_5.wwise_world
	local var_163_7 = arg_163_0.existing_source_id and WwiseWorld.has_source(var_163_6, arg_163_0.existing_source_id) and arg_163_0.existing_source_id or nil
	local var_163_8

	if var_163_1 and var_163_2 and var_163_2 ~= "" then
		local var_163_9 = Unit.node(var_163_1, var_163_2)

		fassert(var_163_9, "Node %s doesn't exist in unit %s", var_163_1, var_163_2)

		var_163_8 = var_163_7 or WwiseWorld.make_auto_source(var_163_6, var_163_1, var_163_9)
		var_163_0 = Unit.world_position(var_163_1, var_163_9)
	elseif var_163_1 then
		var_163_8 = var_163_7 or WwiseWorld.make_auto_source(var_163_6, var_163_1)
		var_163_0 = Unit.world_position(var_163_1, 0)
	elseif var_163_0 then
		var_163_8 = var_163_7 or WwiseWorld.make_auto_source(var_163_6, var_163_0)
	else
		ferror("Missing unit or position in wwise trigger even with environment flow node in unit %s", var_163_1)
	end

	if Vector3.is_valid(var_163_0) then
		var_163_5:set_source_environment(var_163_8, var_163_0)
	end

	local var_163_10 = WwiseWorld.trigger_event(var_163_6, var_163_3, var_163_4, var_163_8)

	var_0_0.playing_id = var_163_10
	var_0_0.source_id = var_163_8

	return var_0_0
end

function flow_callback_wwise_create_environment_sampled_source(arg_164_0)
	local var_164_0 = Managers.state.entity:system("sound_environment_system")
	local var_164_1 = var_164_0.wwise_world
	local var_164_2 = arg_164_0.position
	local var_164_3 = arg_164_0.unit
	local var_164_4 = arg_164_0.unit_node
	local var_164_5

	if var_164_3 and var_164_4 and var_164_4 ~= "" then
		node = Unit.node(var_164_3, var_164_4)

		fassert(node, "Node %s doesn't exist in unit %s", var_164_3, var_164_4)

		var_164_5 = WwiseWorld.make_manual_source(var_164_1, var_164_3, node)
		var_164_2 = Unit.world_position(var_164_3, node)
	elseif var_164_3 then
		var_164_5 = WwiseWorld.make_manual_source(var_164_1, var_164_3)
		var_164_2 = Unit.world_position(var_164_3, 0)
	elseif var_164_2 then
		var_164_5 = WwiseWorld.make_manual_source(var_164_1, var_164_2)
	else
		ferror("Missing unit or position in wwise environment sampled source creation flow node in unit %s", var_164_3)
	end

	var_164_0:set_source_environment(var_164_5, var_164_2)

	var_0_0.source_id = var_164_5

	return var_0_0
end

function flow_callback_wwise_register_source_environment_update(arg_165_0)
	fassert(arg_165_0.source_id, "Missing SourceId in \"Register source for environment sample update\"")
	fassert(arg_165_0.unit, "Missing Unit in \"Register source for environment sample update\"")
	Managers.state.entity:system("sound_environment_system"):register_source_environment_update(arg_165_0.source_id, arg_165_0.unit)
end

function flow_callback_wwise_unregister_source_environment_update(arg_166_0)
	fassert(arg_166_0.source_id, "Missing SourceId in \"Unregister source for environment sample update\"")
	Managers.state.entity:system("sound_environment_system"):unregister_source_environment_update(arg_166_0.source_id)
end

function flow_callback_clear_linked_projectiles(arg_167_0)
	local var_167_0 = arg_167_0.unit

	Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(var_167_0)
end

function flow_callback_activate_cutscene_camera(arg_168_0)
	local var_168_0 = arg_168_0.transition
	local var_168_1 = arg_168_0.transition_length

	fassert(var_168_0 == "NONE" or var_168_1 ~= nil, "Transition Length must be set in flow node for cutscene camera with transition %q ", var_168_0)

	local var_168_2 = arg_168_0.camera
	local var_168_3 = {
		transition = var_168_0,
		transition_start_time = arg_168_0.transition_start_time,
		transition_length = var_168_1,
		allow_controls = arg_168_0.allow_controls,
		max_yaw_angle = arg_168_0.max_yaw_angle,
		max_pitch_angle = arg_168_0.max_pitch_angle
	}
	local var_168_4 = not not arg_168_0.ingame_hud_enabled
	local var_168_5 = not arg_168_0.letterbox_disabled

	Managers.state.entity:system("cutscene_system"):flow_cb_activate_cutscene_camera(var_168_2, var_168_3, var_168_4, var_168_5)
end

function flow_callback_deactivate_cutscene_cameras(arg_169_0)
	Managers.state.entity:system("cutscene_system"):flow_cb_deactivate_cutscene_cameras()
end

function flow_callback_activate_cutscene_logic(arg_170_0)
	local var_170_0 = not not arg_170_0.player_input_enabled
	local var_170_1 = arg_170_0.event_on_activate
	local var_170_2 = arg_170_0.event_on_skip

	Managers.state.entity:system("cutscene_system"):flow_cb_activate_cutscene_logic(var_170_0, var_170_1, var_170_2)
end

function flow_callback_deactivate_cutscene_logic(arg_171_0)
	local var_171_0 = arg_171_0.event_on_deactivate

	Managers.state.entity:system("cutscene_system"):flow_cb_deactivate_cutscene_logic(var_171_0)
end

function flow_callback_cutscene_fx_fade(arg_172_0)
	Managers.state.entity:system("cutscene_system"):flow_cb_cutscene_effect("fx_fade", arg_172_0)
end

function flow_callback_cutscene_fx_text_popup(arg_173_0)
	Managers.state.entity:system("cutscene_system"):flow_cb_cutscene_effect("fx_text_popup", arg_173_0)
end

function flow_callback_start_tutorial_intro_text(arg_174_0)
	local var_174_0 = local_require("scripts/ui/cutscene_overlay_templates/cutscene_template_tutorial")

	Managers.state.event:trigger("event_start_cutscene_overlay", var_174_0)
end

function flow_callback_start_mission(arg_175_0)
	if not Managers.state.network or not Managers.state.network:game() then
		return
	end

	local var_175_0 = arg_175_0.mission_name

	fassert(var_175_0, "[flow_callback_start_mission] No mission name passed")
	fassert(Missions[var_175_0], "[flow_callback_start_mission] There is no mission by the name %q", var_175_0)

	if Missions[var_175_0].is_tutorial_input then
		Managers.state.event:trigger("event_add_tutorial_input", var_175_0, arg_175_0.unit)
	else
		Managers.state.entity:system("mission_system"):flow_callback_start_mission(var_175_0, arg_175_0.unit, arg_175_0.client_may_start, arg_175_0.only_once)
	end
end

function flow_callback_update_mission(arg_176_0)
	local var_176_0 = arg_176_0.mission_name

	fassert(var_176_0, "[flow_callback_update_mission] No mission name passed")
	fassert(Missions[var_176_0], "[flow_callback_start_mission] There is no mission by the name %q", var_176_0)

	if Missions[var_176_0].is_tutorial_input then
		Managers.state.event:trigger("event_update_tutorial_input", var_176_0)
	else
		Managers.state.entity:system("mission_system"):flow_callback_update_mission(var_176_0)
	end
end

function flow_callback_reset_mission(arg_177_0)
	local var_177_0 = arg_177_0.mission_name

	fassert(var_177_0, "[flow_callback_reset_mission] No mission name passed")
	fassert(Missions[var_177_0], "[flow_callback_start_mission] There is no mission by the name %q", var_177_0)

	if Missions[var_177_0].is_tutorial_input then
		Managers.state.event:trigger("event_update_tutorial_input", var_177_0)
	else
		Managers.state.entity:system("mission_system"):flow_callback_reset_mission(var_177_0)
	end
end

function flow_callback_end_mission(arg_178_0)
	local var_178_0 = arg_178_0.mission_name

	fassert(var_178_0, "[flow_callback_end_mission] No mission name passed")
	fassert(Missions[var_178_0], "[flow_callback_start_mission] There is no mission by the name %q", var_178_0)

	if Missions[var_178_0].is_tutorial_input then
		Managers.state.event:trigger("event_remove_tutorial_input", var_178_0)
	else
		Managers.state.entity:system("mission_system"):flow_callback_end_mission(var_178_0)
	end
end

function flow_callback_show_health_bar(arg_179_0)
	fassert(arg_179_0.unit, "[flow_callback_show_health_bar] No unit passed")
	Managers.state.entity:system("tutorial_system"):flow_callback_show_health_bar(arg_179_0.unit, arg_179_0.show)
end

function flow_callback_spawn_tutorial_bot(arg_180_0)
	local var_180_0 = arg_180_0.profile_index
	local var_180_1 = 1

	Managers.state.game_mode:game_mode():add_bot(var_180_0, var_180_1)
end

function flow_callback_set_bot_ready_for_assisted_respawn(arg_181_0)
	local var_181_0 = arg_181_0.unit
	local var_181_1 = arg_181_0.respawn_unit

	Managers.state.entity:system("play_go_tutorial_system"):set_bot_ready_for_assisted_respawn(var_181_0, var_181_1)
end

function flow_callback_enable_tutorial_player_ammo_refill(arg_182_0)
	Managers.state.entity:system("play_go_tutorial_system"):enable_player_ammo_refill()
end

function flow_callback_remove_player_ammo(arg_183_0)
	Managers.state.entity:system("play_go_tutorial_system"):remove_player_ammo()
end

function flow_callback_check_player_ammo(arg_184_0)
	var_0_0.has_ammo = Managers.state.entity:system("play_go_tutorial_system"):check_player_ammo()

	return var_0_0
end

function flow_callback_give_player_potion_from_bot(arg_185_0)
	local var_185_0 = arg_185_0.player_unit
	local var_185_1 = arg_185_0.bot_unit

	Managers.state.entity:system("play_go_tutorial_system"):give_player_potion_from_bot(var_185_0, var_185_1)
end

function flow_callback_get_players_and_bots(arg_186_0)
	local var_186_0 = Managers.player:human_and_bot_players()

	table.clear(var_0_3)

	local var_186_1 = var_0_3
	local var_186_2 = 0

	for iter_186_0, iter_186_1 in pairs(var_186_0) do
		local var_186_3 = iter_186_1.player_unit

		if HEALTH_ALIVE[var_186_3] then
			var_186_2 = var_186_2 + 1
			var_186_1[iter_186_1:profile_index()] = var_186_3
		end
	end

	if var_186_2 > 0 then
		var_0_0.profile1 = var_186_1[1]
		var_0_0.profile2 = var_186_1[2]
		var_0_0.profile3 = var_186_1[3]
		var_0_0.profile4 = var_186_1[4]
		var_0_0.profile5 = var_186_1[5]

		return var_0_0
	end

	return nil
end

function flow_callback_add_group_buff(arg_187_0)
	if not Managers.player.is_server then
		return
	end

	local var_187_0 = arg_187_0.group_buff_template
	local var_187_1 = NetworkLookup.group_buff_templates[var_187_0]

	Managers.state.entity:system("buff_system"):rpc_add_group_buff(nil, var_187_1, 1)

	return nil
end

function flow_callback_set_career_voice_parameter_value(arg_188_0)
	local var_188_0 = Managers.player:local_player():profile_index()
	local var_188_1 = SPProfiles[var_188_0].career_voice_parameter
	local var_188_2 = Managers.state.spawn.world
	local var_188_3 = Wwise.wwise_world(var_188_2)
	local var_188_4 = arg_188_0.career_voice_parameter_value

	WwiseWorld.set_global_parameter(var_188_3, var_188_1, var_188_4)
end

function flow_is_carrying_explosive_barrel(arg_189_0)
	local var_189_0 = arg_189_0.player_unit

	if not var_0_1(var_189_0) then
		var_0_0.has_barrel = false

		return var_0_0
	end

	local var_189_1
	local var_189_2 = ScriptUnit.has_extension(var_189_0, "inventory_system")

	if var_189_2 then
		var_189_1 = var_189_2:equipment()
	else
		var_189_1 = Unit.get_data(var_189_0, "equipment")
	end

	local var_189_3 = var_189_1.left_hand_wielded_unit or var_189_1.right_hand_wielded_unit

	if var_189_3 then
		local var_189_4 = ScriptUnit.extension(var_189_3, "weapon_system")

		if var_189_4.item_name == "explosive_barrel_objective" or var_189_4.item_name == "explosive_barrel" then
			var_0_0.has_barrel = true
		end
	end

	return var_0_0
end

function flow_is_carrying_torch(arg_190_0)
	local var_190_0 = arg_190_0.player_unit

	if not var_0_1(var_190_0) then
		var_0_0.has_torch = false

		return var_0_0
	end

	local var_190_1
	local var_190_2 = ScriptUnit.has_extension(var_190_0, "inventory_system")

	if var_190_2 then
		var_190_1 = var_190_2:equipment()
	else
		var_190_1 = Unit.get_data(var_190_0, "equipment")
	end

	local var_190_3 = var_190_1.left_hand_wielded_unit or var_190_1.right_hand_wielded_unit

	if var_190_3 then
		local var_190_4 = ScriptUnit.extension(var_190_3, "weapon_system").item_name

		if var_190_4 == "torch" or var_190_4 == "shadow_torch" then
			var_0_0.has_torch = true
		end
	end

	return var_0_0
end

function flow_callback_teleport_unit(arg_191_0)
	local var_191_0 = arg_191_0.unit
	local var_191_1 = arg_191_0.position
	local var_191_2 = arg_191_0.rotation

	if not var_0_1(var_191_0) then
		return
	end

	if not Managers.state.network.is_server then
		local var_191_3 = Unit.get_data(var_191_0, "breed")

		if not var_191_3 or not var_191_3.is_player then
			return
		end
	end

	local var_191_4 = ScriptUnit.extension(var_191_0, "locomotion_system")

	if var_191_4.teleport_to then
		var_191_4:teleport_to(var_191_1, var_191_2)
	end

	if Unit.get_data(var_191_0, "bot") then
		ScriptUnit.extension(var_191_0, "ai_navigation_system"):teleport(var_191_1)
	end
end

function flow_callback_unspawn_all_ais(arg_192_0)
	Managers.state.conflict:destroy_all_units()
end

function flow_query_slots_status(arg_193_0)
	local var_193_0 = arg_193_0.player_unit

	if not var_0_1(var_193_0) then
		var_0_0.healthkit = false
		var_0_0.grenade = false
		var_0_0.potion = false

		return var_0_0
	end

	local var_193_1
	local var_193_2 = ScriptUnit.has_extension(var_193_0, "inventory_system")

	if var_193_2 then
		var_193_1 = var_193_2:equipment()
	else
		var_193_1 = Unit.get_data(var_193_0, "equipment")
	end

	local var_193_3 = var_193_1.slots.slot_healthkit
	local var_193_4 = var_193_1.slots.slot_grenade
	local var_193_5 = var_193_1.slots.slot_potion

	var_0_0.healthkit = var_193_3 ~= nil
	var_0_0.grenade = var_193_4 ~= nil
	var_0_0.potion = var_193_5 ~= nil

	return var_0_0
end

function flow_callback_damage_player_bot_ai(arg_194_0)
	local var_194_0 = arg_194_0.unit
	local var_194_1 = Unit.alive(arg_194_0.attacker_unit) and arg_194_0.attacker_unit or var_194_0
	local var_194_2 = arg_194_0.damage

	if var_0_1(var_194_0) then
		fassert(ScriptUnit.has_extension(var_194_0, "health_system"), "Tried to kill unit %s from flow but the unit has no health extension", var_194_0)

		local var_194_3 = "full"
		local var_194_4 = "level"
		local var_194_5 = Unit.world_position(var_194_0, 0)
		local var_194_6 = Vector3.up()
		local var_194_7 = NetworkConstants.damage.max
		local var_194_8 = ScriptUnit.extension(var_194_0, "health_system")
		local var_194_9 = math.min(var_194_2, var_194_8:current_health())
		local var_194_10 = math.ceil(var_194_9 / var_194_7)

		for iter_194_0 = 0, var_194_10 - 1 do
			local var_194_11 = math.min(var_194_9 - var_194_10 * iter_194_0, var_194_10)

			DamageUtils.add_damage_network(var_194_0, var_194_1, var_194_11, var_194_3, var_194_4, var_194_5, var_194_6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, iter_194_0)
		end
	end
end

function flow_callback_get_health_player_bot_ai(arg_195_0)
	if not Managers.player.is_server then
		return
	end

	local var_195_0 = arg_195_0.unit
	local var_195_1 = 0

	if var_0_1(var_195_0) then
		fassert(ScriptUnit.has_extension(var_195_0, "health_system"), "Tried to get unit %s health from flow but the unit has no health extension", var_195_0)

		local var_195_2 = ScriptUnit.extension(var_195_0, "health_system")
		local var_195_3 = ScriptUnit.has_extension(var_195_0, "status_system")

		if not var_195_3 or not var_195_3:is_knocked_down() and not var_195_3:is_ready_for_assisted_respawn() then
			var_195_1 = var_195_2:current_health()
		end
	end

	var_0_0.currenthealth = var_195_1

	return var_0_0
end

function flow_callback_clear_slot(arg_196_0)
	local var_196_0 = arg_196_0.player_unit
	local var_196_1 = arg_196_0.slot_name

	if not var_0_1(var_196_0) then
		return
	end

	local var_196_2 = ScriptUnit.has_extension(var_196_0, "inventory_system")

	if not var_196_2 then
		return
	end

	var_196_2:destroy_slot(var_196_1)
end

function flow_callback_set_wwise_elevation_alignment(arg_197_0)
	local var_197_0 = arg_197_0.position.z
	local var_197_1 = arg_197_0.scale
	local var_197_2 = arg_197_0.min
	local var_197_3 = arg_197_0.max
	local var_197_4 = Managers.state.camera

	if var_197_4 then
		var_197_4:set_elevation_offset(var_197_0, var_197_1, var_197_2, var_197_3)
	end
end

function flow_callback_kill_player_bot_ai(arg_198_0)
	if not Managers.player.is_server then
		return
	end

	local var_198_0 = arg_198_0.unit

	if var_0_1(var_198_0) then
		fassert(ScriptUnit.has_extension(var_198_0, "health_system"), "Tried to kill unit %s from flow but the unit has no health extension", var_198_0)
		ScriptUnit.extension(var_198_0, "health_system"):die()
	end
end

function flow_callback_overcharge_heal_unit(arg_199_0)
	if not Managers.player.is_server then
		return
	end

	local var_199_0 = arg_199_0.unit
	local var_199_1 = arg_199_0.health

	if var_0_1(var_199_0) then
		fassert(ScriptUnit.has_extension(var_199_0, "health_system"), "Tried to heal overcharge unit %s from flow but the unit has no health extension", var_199_0)

		local var_199_2 = ScriptUnit.extension(var_199_0, "health_system")

		var_199_2:add_heal(var_199_0, var_199_1, nil, "n/a")

		local var_199_3 = var_199_2:current_health()
		local var_199_4 = var_199_2:get_damage_taken()

		var_0_0.current_health = var_199_3
		var_0_0.current_damage = var_199_4

		return var_0_0
	end
end

function flow_callback_overcharge_init_unit(arg_200_0)
	local var_200_0 = arg_200_0.unit
	local var_200_1 = arg_200_0.init_damage

	if var_0_1(var_200_0) then
		fassert(ScriptUnit.has_extension(var_200_0, "health_system"), "Tried to damage overcharge unit %s from flow but the unit has no health extension", var_200_0)

		local var_200_2 = ScriptUnit.extension(var_200_0, "health_system")
		local var_200_3 = "full"
		local var_200_4 = Unit.world_position(var_200_0, 0)
		local var_200_5 = Vector3.up()

		var_200_2:add_damage(var_200_0, var_200_1, var_200_3, "destructible_level_object_hit", var_200_4, var_200_5, "wounded_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
	end
end

function flow_callback_overcharge_sync_damage(arg_201_0)
	local var_201_0 = arg_201_0.unit
	local var_201_1 = arg_201_0.damage
	local var_201_2 = "full"
	local var_201_3 = Unit.world_position(var_201_0, 0)
	local var_201_4 = ScriptUnit.extension(var_201_0, "health_system")
	local var_201_5 = Vector3.up()

	var_201_4:add_damage(var_201_0, var_201_1, var_201_2, "destructible_level_object_hit", var_201_3, var_201_5, "wounded_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
end

function flow_callback_overcharge_damage_unit(arg_202_0)
	if not Managers.player.is_server then
		return
	end

	local var_202_0 = arg_202_0.unit
	local var_202_1 = arg_202_0.damage

	if var_0_1(var_202_0) then
		fassert(ScriptUnit.has_extension(var_202_0, "health_system"), "Tried to damage overcharge unit %s from flow but the unit has no health extension", var_202_0)

		local var_202_2 = "full"
		local var_202_3 = Unit.world_position(var_202_0, 0)
		local var_202_4 = Vector3.up()

		ScriptUnit.extension(var_202_0, "health_system"):add_damage(var_202_0, var_202_1, var_202_2, "destructible_level_object_hit", var_202_3, var_202_4, "wounded_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
	end
end

function flow_callback_overcharge_reset_unit(arg_203_0)
	local var_203_0 = arg_203_0.unit
	local var_203_1 = arg_203_0.maxhealth

	if var_0_1(var_203_0) then
		fassert(ScriptUnit.has_extension(var_203_0, "health_system"), "Tried to reset health and damage on overcharge unit %s from flow but the unit has no health extension", var_203_0)

		local var_203_2 = ScriptUnit.extension(var_203_0, "health_system")
		local var_203_3 = 0

		var_203_2:set_current_damage(var_203_3)
		var_203_2:set_max_health(var_203_1)

		local var_203_4 = Managers.state.network

		if var_203_4.is_server then
			local var_203_5 = NetworkUtils.get_network_safe_damage_hotjoin_sync(var_203_3)
			local var_203_6 = var_203_2.state
			local var_203_7 = NetworkLookup.health_statuses[var_203_6]
			local var_203_8 = Managers.state.network.network_transmit
			local var_203_9, var_203_10 = var_203_4:game_object_or_level_id(var_203_0)

			var_203_8:send_rpc_clients("rpc_sync_damage_taken", var_203_9, var_203_10, false, var_203_5, var_203_7)
		end
	end
end

local var_0_4 = math.pi * 2

function flow_callback_fire_light_weight_projectile(arg_204_0)
	if not Managers.player.is_server then
		return
	end

	local var_204_0 = arg_204_0.unit
	local var_204_1 = arg_204_0.shots_to_fire or 1
	local var_204_2 = arg_204_0.light_weight_projectile_template_name
	local var_204_3 = LightWeightProjectiles[var_204_2]
	local var_204_4 = "skaven_ratling_gunner"
	local var_204_5 = Unit.world_position(var_204_0, 0)

	for iter_204_0 = 1, var_204_1 do
		local var_204_6 = Math.random() * var_204_3.spread
		local var_204_7 = Quaternion.forward(Unit.world_rotation(var_204_0, 0))
		local var_204_8 = Quaternion(Vector3.right(), var_204_6)
		local var_204_9 = Quaternion(Vector3.forward(), Math.random() * var_0_4)
		local var_204_10 = Quaternion.look(var_204_7, Vector3.up())
		local var_204_11 = Quaternion.multiply(Quaternion.multiply(var_204_10, var_204_9), var_204_8)
		local var_204_12 = Quaternion.forward(var_204_11)
		local var_204_13 = "filter_enemy_player_afro_ray_projectile"
		local var_204_14 = Managers.state.difficulty:get_difficulty_rank()
		local var_204_15 = var_204_3.attack_power_level[var_204_14] or var_204_3.attack_power_level[2]
		local var_204_16 = {
			power_level = var_204_15,
			damage_profile = var_204_3.damage_profile,
			hit_effect = var_204_3.hit_effect,
			player_push_velocity = Vector3Box(var_204_7 * var_204_3.impact_push_speed),
			projectile_linker = var_204_3.projectile_linker,
			first_person_hit_flow_events = var_204_3.first_person_hit_flow_events
		}
		local var_204_17 = Managers.state.entity:system("projectile_system")
		local var_204_18 = Network.peer_id()

		var_204_17:create_light_weight_projectile(var_204_4, var_204_0, var_204_5, var_204_12, var_204_3.projectile_speed, nil, nil, var_204_3.projectile_max_range, var_204_13, var_204_16, var_204_3.light_weight_projectile_effect, var_204_18)
	end
end

function flow_callback_trigger_explosion(arg_205_0)
	if not Managers.player.is_server then
		return
	end

	local var_205_0 = arg_205_0.unit
	local var_205_1 = arg_205_0.explosion_template_name

	fassert(var_205_1, "Trigger Explosion unit flow node is missing explosion_template_name")

	local var_205_2 = ExplosionUtils.get_template(var_205_1)

	fassert(var_205_2.explosion.level_unit_damage, "The explosion_template must have level_unit_damage set to true when using this flow node")

	local var_205_3 = Unit.world_position(var_205_0, 0)
	local var_205_4 = Unit.world_rotation(var_205_0, 0)
	local var_205_5 = 1
	local var_205_6 = "grenade_frag_01"

	Managers.state.entity:system("area_damage_system"):create_explosion(var_205_0, var_205_3, var_205_4, var_205_1, var_205_5, var_205_6, nil, false)
end

function flow_callback_enable_climb_unit(arg_206_0)
	local var_206_0 = arg_206_0.unit

	if var_0_1(var_206_0) then
		Managers.state.entity:system("nav_graph_system"):init_nav_graph_from_flow(var_206_0)
	end
end

function flow_callback_add_nav_graph_on_climb_unit(arg_207_0)
	local var_207_0 = arg_207_0.unit

	if var_0_1(var_207_0) then
		Managers.state.entity:system("nav_graph_system"):queue_add_nav_graph_from_flow(var_207_0)
	end
end

function flow_callback_remove_nav_graph_on_climb_unit(arg_208_0)
	local var_208_0 = arg_208_0.unit

	if var_0_1(var_208_0) then
		Managers.state.entity:system("nav_graph_system"):queue_remove_nav_graph_from_flow(var_208_0)
	end
end

function flow_callback_create_permanent_box_obstacle_from_unit(arg_209_0)
	local var_209_0 = arg_209_0.unit

	if not var_0_1(var_209_0) then
		return
	end

	local var_209_1 = GLOBAL_AI_NAVWORLD
	local var_209_2, var_209_3 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(var_209_1, var_209_0)

	GwNavBoxObstacle.add_to_world(var_209_2)
	GwNavBoxObstacle.set_transform(var_209_2, var_209_3)
	GwNavBoxObstacle.set_does_trigger_tagvolume(var_209_2, true)
end

function flow_callback_limited_item_spawner_group_register(arg_210_0)
	if not Managers.player.is_server then
		return
	end

	local var_210_0 = arg_210_0.name
	local var_210_1 = arg_210_0.pool_size

	Managers.state.entity:system("limited_item_track_system"):register_group(var_210_0, var_210_1)
end

function flow_callback_limited_item_spawner_group_decrease_pool_size(arg_211_0)
	if not Managers.player.is_server then
		return
	end

	local var_211_0 = arg_211_0.name
	local var_211_1 = arg_211_0.pool_size

	Managers.state.entity:system("limited_item_track_system"):decrease_group_pool_size(var_211_0, var_211_1)
end

function flow_callback_limited_item_spawner_group_activate(arg_212_0)
	if not Managers.player.is_server then
		return
	end

	local var_212_0 = arg_212_0.name
	local var_212_1 = arg_212_0.pool_size

	Managers.state.entity:system("limited_item_track_system"):activate_group(var_212_0, var_212_1)
end

function flow_callback_limited_item_spawner_group_deactivate(arg_213_0)
	if not Managers.player.is_server then
		return
	end

	local var_213_0 = arg_213_0.name

	Managers.state.entity:system("limited_item_track_system"):deactivate_group(var_213_0)
end

function flow_callback_decal_set_sort_order(arg_214_0)
	local var_214_0 = arg_214_0.unit
	local var_214_1 = arg_214_0.sort_order

	if var_214_1 then
		Unit.set_sort_order(var_214_0, var_214_1)
	end
end

function flow_callback_blood_collision(arg_215_0)
	if Managers.state.decal ~= nil then
		local var_215_0 = arg_215_0.blood_ball_actor
		local var_215_1 = Actor.unit(var_215_0)
		local var_215_2 = arg_215_0.position
		local var_215_3 = arg_215_0.normal
		local var_215_4 = Actor.velocity(var_215_0)
		local var_215_5 = 1000

		if var_215_5 < var_215_4.x or var_215_4.x < -var_215_5 or var_215_5 < var_215_4.y or var_215_4.y < -var_215_5 or var_215_5 < var_215_4.z or var_215_4.z < -var_215_5 then
			var_215_4 = Vector3(0, 0, -1)
		end

		local var_215_6 = Vector3.dot(var_215_3, Vector3.normalize(var_215_4))
		local var_215_7 = Vector3.normalize(Vector3.normalize(var_215_4) - var_215_6 * var_215_3)
		local var_215_8 = Quaternion.look(var_215_7, var_215_3)
		local var_215_9 = arg_215_0.hit_unit
		local var_215_10 = arg_215_0.hit_actor

		if Unit.alive(var_215_9) then
			local var_215_11, var_215_12 = Managers.state.network:game_object_or_level_id(var_215_9)

			if not var_215_12 then
				var_215_9 = nil
				var_215_10 = nil
			end
		end

		local var_215_13 = "units/decals/projection_blood_" .. string.format("%02d", tostring(Math.random(1, 17)))
		local var_215_14 = Vector3(BloodSettings.blood_decals.scale, BloodSettings.blood_decals.scale, 1)

		Managers.state.decal:add_projection_decal(var_215_13, var_215_9, var_215_10, var_215_2, var_215_8, var_215_14, var_215_3)
		Managers.state.blood:despawn_blood_ball(var_215_1)
	end
end

function flow_callback_move_decals(arg_216_0)
	if Managers.state.decal then
		local var_216_0 = arg_216_0.from_unit
		local var_216_1 = arg_216_0.to_unit

		Managers.state.decal:move_decals(var_216_0, var_216_1)
	end
end

function flow_callback_blood_ball_despawn(arg_217_0)
	if Managers.state.decal ~= nil then
		local var_217_0 = arg_217_0.unit

		Managers.state.blood:despawn_blood_ball(var_217_0)
	end
end

function flow_callback_blood_enabled()
	if Managers.state.blood then
		var_0_0.enabled = Managers.state.blood:get_blood_enabled()
	else
		var_0_0.enabled = false
	end

	return var_0_0
end

function flow_callback_enable_poison_wind(arg_219_0)
	local var_219_0 = arg_219_0.unit
	local var_219_1 = arg_219_0.enable

	Managers.state.entity:system("area_damage_system"):enable_area_damage(var_219_0, var_219_1)
end

function flow_callback_objective_unit_set_active(arg_220_0)
	if not Managers.player.is_server then
		return
	end

	local var_220_0 = arg_220_0.unit

	ScriptUnit.extension(var_220_0, "tutorial_system"):set_active(arg_220_0.active)
end

function flow_callback_objective_unit_set_active_generic(arg_221_0)
	if not Managers.player.is_server then
		return
	end

	local var_221_0 = arg_221_0.unit
	local var_221_1 = arg_221_0.system_name

	ScriptUnit.extension(var_221_0, var_221_1):set_active(arg_221_0.active, arg_221_0.unit)
end

local function var_0_5()
	return Managers.state.entity:system("objective_system")
end

function flow_callback_objective_get_num_current_main_objectives(arg_223_0)
	local var_223_0 = var_0_5()

	if not var_223_0 then
		return
	end

	var_0_0.out_value = #var_223_0:active_objectives()

	return var_0_0
end

function flow_callback_objective_get_total_main_objectives(arg_224_0)
	local var_224_0 = var_0_5()

	if not var_224_0 then
		return
	end

	var_0_0.out_value = var_224_0:num_main_objectives()

	return var_0_0
end

function flow_callback_objective_get_num_completed_main_objectives(arg_225_0)
	local var_225_0 = var_0_5()

	if not var_225_0 then
		return
	end

	var_0_0.out_value = var_225_0:num_completed_main_objectives()

	return var_0_0
end

function flow_callback_objective_get_current_completed_sub_objectives(arg_226_0)
	local var_226_0 = var_0_5()

	if not var_226_0 then
		return
	end

	var_0_0.out_value = var_226_0:num_current_completed_sub_objectives()

	return var_0_0
end

function flow_callback_objective_complete_current_objective_by_name(arg_227_0)
	if not Managers.player.is_server then
		return
	end

	local var_227_0 = var_0_5()

	if not var_227_0 then
		return
	end

	var_227_0:complete_objective(arg_227_0.name)
end

function flow_callback_umbra_set_gate_closed(arg_228_0)
	local var_228_0 = arg_228_0.unit
	local var_228_1 = Unit.world(var_228_0)

	if World.umbra_available(var_228_1) then
		local var_228_2 = arg_228_0.closed

		World.umbra_set_gate_closed(var_228_1, var_228_0, var_228_2)
	end
end

local var_0_6 = {}

function flow_callback_external_broadphase_unit_event(arg_229_0)
	local var_229_0 = arg_229_0.source_unit
	local var_229_1 = arg_229_0.radius
	local var_229_2 = arg_229_0.target_breed
	local var_229_3 = arg_229_0.event_name
	local var_229_4 = arg_229_0.value
	local var_229_5 = AiUtils.broadphase_query(Unit.world_position(var_229_0, 0), var_229_1 or 5, var_0_6)
	local var_229_6 = BLACKBOARDS

	for iter_229_0 = 1, var_229_5 do
		local var_229_7 = var_229_6[var_0_6[iter_229_0]]

		if var_229_7 and var_229_7.breed.name == var_229_2 then
			var_229_7.external_event_name = var_229_3
			var_229_7.external_event_value = var_229_4
		end
	end

	table.clear(var_0_6)
end

function flow_callback_force_unit_animation(arg_230_0)
	local var_230_0 = arg_230_0.source_unit
	local var_230_1 = arg_230_0.radius
	local var_230_2 = arg_230_0.target_breed
	local var_230_3 = arg_230_0.animation_event_name
	local var_230_4 = AiUtils.broadphase_query(Unit.world_position(var_230_0, 0), var_230_1 or 5, var_0_6)
	local var_230_5 = BLACKBOARDS

	for iter_230_0 = 1, var_230_4 do
		local var_230_6 = var_0_6[iter_230_0]
		local var_230_7 = var_230_5[var_230_6]

		if var_230_7 and var_230_7.breed.name == var_230_2 then
			Managers.state.network:anim_event(var_230_6, var_230_3)
		end
	end

	table.clear(var_0_6)
end

function flow_callback_synced_animation(arg_231_0)
	local var_231_0 = Managers.state.network:game()

	if var_231_0 then
		local var_231_1 = arg_231_0.unit
		local var_231_2 = arg_231_0.animation_event
		local var_231_3 = Managers.state.unit_storage
		local var_231_4 = var_231_3:go_id(var_231_1)
		local var_231_5 = GameSession.game_object_field(var_231_0, var_231_4, "animation_synced_unit_id")
		local var_231_6 = var_231_3:unit(var_231_5)

		if var_231_6 and var_231_2 and Unit.has_animation_event(var_231_6, var_231_2) then
			Unit.animation_event(var_231_6, var_231_2)
		end
	end
end

function flow_callback_player_animation(arg_232_0)
	local var_232_0 = arg_232_0.character_type
	local var_232_1 = arg_232_0.animation_event
	local var_232_2 = Managers.player:human_and_bot_players()

	for iter_232_0, iter_232_1 in pairs(var_232_2) do
		local var_232_3 = SPProfiles[iter_232_1:profile_index()].display_name
		local var_232_4 = iter_232_1.player_unit

		if var_232_4 and var_232_3 == var_232_0 and Unit.has_animation_event(var_232_4, var_232_1) then
			Unit.animation_event(var_232_4, var_232_1)
		end
	end
end

function flow_callback_trigger_dialogue_story(arg_233_0)
	local var_233_0 = arg_233_0.unit

	Managers.state.entity:system("dialogue_system"):trigger_story_dialogue(var_233_0)
end

function flow_callback_trigger_cutscene_subtitles(arg_234_0)
	local var_234_0 = arg_234_0.subtitle_event
	local var_234_1 = arg_234_0.speaker
	local var_234_2 = arg_234_0.end_delay

	Managers.state.entity:system("dialogue_system"):trigger_cutscene_subtitles(var_234_0, var_234_1, var_234_2)
end

function flow_callback_trigger_event_with_subtitles(arg_235_0)
	local var_235_0 = arg_235_0.sound_event
	local var_235_1 = arg_235_0.subtitle_event
	local var_235_2 = arg_235_0.speaker

	Managers.state.entity:system("dialogue_system"):trigger_sound_event_with_subtitles(var_235_0, var_235_1, var_235_2)
end

function flow_callback_trigger_event_with_unit_and_subtitles(arg_236_0)
	local var_236_0 = arg_236_0.sound_event
	local var_236_1 = arg_236_0.subtitle_event
	local var_236_2 = arg_236_0.speaker
	local var_236_3 = arg_236_0.source_unit
	local var_236_4 = arg_236_0.unit_node

	Managers.state.entity:system("dialogue_system"):trigger_sound_event_with_subtitles(var_236_0, var_236_1, var_236_2, var_236_3, var_236_4)
end

function flow_callback_trigger_random_event_with_unit_and_subtitles(arg_237_0)
	local var_237_0 = {
		arg_237_0.sound_event01,
		arg_237_0.sound_event02,
		arg_237_0.sound_event03,
		arg_237_0.sound_event04,
		arg_237_0.sound_event05,
		arg_237_0.sound_event06,
		arg_237_0.sound_event07,
		arg_237_0.sound_event08,
		arg_237_0.sound_event09,
		arg_237_0.sound_event10,
		arg_237_0.sound_event11,
		arg_237_0.sound_event12,
		arg_237_0.sound_event13,
		arg_237_0.sound_event14,
		arg_237_0.sound_event15,
		arg_237_0.sound_event16,
		arg_237_0.sound_event17,
		arg_237_0.sound_event18,
		arg_237_0.sound_event19,
		arg_237_0.sound_event20
	}
	local var_237_1 = var_237_0[math.random(#var_237_0)]
	local var_237_2 = var_237_1
	local var_237_3 = arg_237_0.speaker
	local var_237_4 = arg_237_0.source_unit
	local var_237_5 = arg_237_0.unit_node

	Managers.state.entity:system("dialogue_system"):trigger_sound_event_with_subtitles(var_237_1, var_237_2, var_237_3, var_237_4, var_237_5)
end

function flow_callback_override_start_dialogue_system()
	Managers.state.entity:system("dialogue_system").players_ready = true
end

function flow_callback_override_stop_dialogue_system()
	Managers.state.entity:system("dialogue_system").players_ready = false
end

function flow_callback_override_start_delay()
	DialogueSettings.dialogue_level_start_delay = 0
end

function flow_callback_damage_unit(arg_241_0)
	if not Managers.player.is_server then
		return
	end

	local var_241_0 = arg_241_0.unit
	local var_241_1 = arg_241_0.damage

	if var_0_1(var_241_0) then
		fassert(ScriptUnit.has_extension(var_241_0, "health_system"), "Tried to damage unit %s from flow but the unit has no health extension", var_241_0)

		local var_241_2 = "full"
		local var_241_3 = Unit.world_position(var_241_0, 0)
		local var_241_4 = Vector3.up()

		ScriptUnit.extension(var_241_0, "health_system"):add_damage(var_241_0, var_241_1, var_241_2, "destructible_level_object_hit", var_241_3, var_241_4, "wounded_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
	end
end

function flow_callback_set_material_property_scalar_all(arg_242_0)
	local var_242_0 = arg_242_0.unit
	local var_242_1 = arg_242_0.variable
	local var_242_2 = arg_242_0.value
	local var_242_3 = Script.index_offset()
	local var_242_4 = 1 - var_242_3
	local var_242_5 = Unit.num_meshes(var_242_0)

	for iter_242_0 = var_242_3, var_242_5 - var_242_4 do
		local var_242_6 = Unit.mesh(var_242_0, iter_242_0)
		local var_242_7 = Mesh.num_materials(var_242_6)

		for iter_242_1 = var_242_3, var_242_7 - var_242_4 do
			local var_242_8 = Mesh.material(var_242_6, iter_242_1)

			Material.set_scalar(var_242_8, var_242_1, var_242_2)
		end
	end
end

function flow_callback_material_scalar_set_chr_inventory(arg_243_0)
	fassert(arg_243_0.unit, "[flow_callback_material_scalar_set_chr_inventory] You need to specify the Unit")
	fassert(arg_243_0.variable, "[flow_callback_material_scalar_set_chr_inventory] You need to specify variable value")
	fassert(arg_243_0.value, "[flow_callback_material_scalar_set_chr_inventory] You need to specify variable name")

	local var_243_0 = arg_243_0.unit
	local var_243_1 = ScriptUnit.has_extension(var_243_0, "ai_inventory_system")

	if var_243_1 ~= nil then
		for iter_243_0 = 1, #var_243_1.inventory_item_units do
			arg_243_0.unit = var_243_1.inventory_item_units[iter_243_0]

			flow_callback_set_material_property_scalar_all(arg_243_0)
		end
	end
end

function do_material_dissolve(arg_244_0, arg_244_1, arg_244_2, arg_244_3, arg_244_4)
	Material.set_scalar(arg_244_0, arg_244_3, arg_244_4)
	Material.set_vector2(arg_244_0, arg_244_1, arg_244_2)
end

function flow_callback_material_dissolve(arg_245_0)
	fassert(arg_245_0.unit, "[flow_callback_material_dissolve] You need to specify the Unit")
	fassert(arg_245_0.duration, "[flow_callback_material_dissolve] You need to specify duration")

	local var_245_0 = arg_245_0.timer_var_name or "dissolve_timer"
	local var_245_1 = World.time(Application.main_world())
	local var_245_2 = Vector2(var_245_1, var_245_1 + arg_245_0.duration)
	local var_245_3 = arg_245_0.dissolve_start_state_var_name or "dissolve_start_value"
	local var_245_4 = math.floor(0.5 + arg_245_0.dissolve_start_state or 1)
	local var_245_5 = arg_245_0.unit
	local var_245_6
	local var_245_7 = arg_245_0.mesh_name

	if var_245_7 then
		fassert(Unit.has_mesh(var_245_5, var_245_7), string.format("[flow_callback_material_dissolve] The mesh %s doesn't exist in unit %s", var_245_7, tostring(var_245_5)))

		var_245_6 = Unit.mesh(var_245_5, var_245_7)
	end

	local var_245_8
	local var_245_9 = arg_245_0.material_name

	if var_245_6 and var_245_9 then
		fassert(Mesh.has_material(var_245_6, var_245_9), string.format("[flow_callback_material_dissolve] The material %s doesn't exist for mesh %s", var_245_7, var_245_9))

		var_245_8 = Mesh.material(var_245_6, var_245_9)
	end

	if var_245_6 and var_245_8 then
		do_material_dissolve(var_245_8, var_245_0, var_245_2, var_245_3, var_245_4)
	elseif var_245_6 then
		local var_245_10 = Mesh.num_materials(var_245_6)

		for iter_245_0 = 0, var_245_10 - 1 do
			do_material_dissolve(Mesh.material(var_245_6, iter_245_0), var_245_0, var_245_2, var_245_3, var_245_4)
		end
	elseif var_245_9 then
		local var_245_11 = Unit.num_meshes(var_245_5)

		for iter_245_1 = 0, var_245_11 - 1 do
			local var_245_12 = Unit.mesh(var_245_5, iter_245_1)

			if Mesh.has_material(var_245_12, var_245_9) then
				do_material_dissolve(Mesh.material(var_245_12, var_245_9), var_245_0, var_245_2, var_245_3, var_245_4)
			end
		end
	else
		local var_245_13 = Unit.num_meshes(var_245_5)

		for iter_245_2 = 0, var_245_13 - 1 do
			local var_245_14 = Unit.mesh(var_245_5, iter_245_2)
			local var_245_15 = Mesh.num_materials(var_245_14)

			for iter_245_3 = 0, var_245_15 - 1 do
				do_material_dissolve(Mesh.material(var_245_14, iter_245_3), var_245_0, var_245_2, var_245_3, var_245_4)
			end
		end
	end
end

function flow_callback_material_dissolve_chr(arg_246_0)
	fassert(arg_246_0.unit, "[flow_callback_material_dissolve_chr] You need to specify the Unit")
	fassert(arg_246_0.duration, "[flow_callback_material_dissolve_chr] You need to specify duration")
	flow_callback_material_dissolve(arg_246_0)

	local var_246_0 = arg_246_0.unit
	local var_246_1 = ScriptUnit.has_extension(var_246_0, "ai_inventory_system")

	if var_246_1 ~= nil then
		for iter_246_0 = 1, #var_246_1.stump_items do
			arg_246_0.unit = var_246_1.stump_items[iter_246_0]

			flow_callback_material_dissolve(arg_246_0)
		end

		for iter_246_1 = 1, #var_246_1.inventory_item_outfit_units do
			arg_246_0.unit = var_246_1.inventory_item_outfit_units[iter_246_1]

			flow_callback_material_dissolve(arg_246_0)
		end

		for iter_246_2 = 1, #var_246_1.inventory_item_helmet_units do
			arg_246_0.unit = var_246_1.inventory_item_helmet_units[iter_246_2]

			flow_callback_material_dissolve(arg_246_0)
		end

		if var_246_1.inventory_item_skin_unit ~= nil then
			arg_246_0.unit = var_246_1.inventory_item_skin_unit

			flow_callback_material_dissolve(arg_246_0)
		end
	end
end

function flow_callback_material_dissolve_chr_inventory(arg_247_0)
	fassert(arg_247_0.unit, "[flow_callback_material_dissolve_chr_inventory] You need to specify the Unit")
	fassert(arg_247_0.duration, "[flow_callback_material_dissolve_chr_inventory] You need to specify duration")
	fassert(arg_247_0.inventory_type, "[flow_callback_material_dissolve_chr_inventory] You need to specify inventory type")

	local var_247_0 = arg_247_0.unit
	local var_247_1 = ScriptUnit.has_extension(var_247_0, "ai_inventory_system")

	if var_247_1 ~= nil then
		if arg_247_0.inventory_type == "outfit" then
			for iter_247_0 = 1, #var_247_1.inventory_item_outfit_units do
				arg_247_0.unit = var_247_1.inventory_item_outfit_units[iter_247_0]

				flow_callback_material_dissolve(arg_247_0)
			end
		elseif arg_247_0.inventory_type == "stump" then
			for iter_247_1 = 1, #var_247_1.stump_items do
				arg_247_0.unit = var_247_1.stump_items[iter_247_1]

				flow_callback_material_dissolve(arg_247_0)
			end
		elseif arg_247_0.inventory_type == "helmet" then
			for iter_247_2 = 1, #var_247_1.inventory_item_helmet_units do
				arg_247_0.unit = var_247_1.inventory_item_helmet_units[iter_247_2]

				flow_callback_material_dissolve(arg_247_0)
			end
		elseif arg_247_0.inventory_type == "weapon" then
			for iter_247_3 = 1, #var_247_1.inventory_item_weapon_units do
				arg_247_0.unit = var_247_1.inventory_item_weapon_units[iter_247_3]

				flow_callback_material_dissolve(arg_247_0)
			end
		elseif arg_247_0.inventory_type == "skin" and var_247_1.inventory_item_skin_unit ~= nil then
			arg_247_0.unit = var_247_1.inventory_item_skin_unit

			flow_callback_material_dissolve(arg_247_0)
		end
	end
end

function do_material_fade(arg_248_0, arg_248_1, arg_248_2, arg_248_3, arg_248_4)
	Material.set_vector2(arg_248_0, arg_248_3, arg_248_4)
	Material.set_vector2(arg_248_0, arg_248_1, arg_248_2)
end

function flow_callback_material_fade(arg_249_0)
	fassert(arg_249_0.unit, "[flow_callback_material_fade] You need to specify the Unit")
	fassert(arg_249_0.duration, "[flow_callback_material_fade] You need to specify duration")

	local var_249_0 = arg_249_0.timer_var_name or "fade_timer"
	local var_249_1 = World.time(Application.main_world())
	local var_249_2 = Vector2(var_249_1, var_249_1 + arg_249_0.duration)
	local var_249_3 = arg_249_0.fade_range_var_name or "fade_interval"
	local var_249_4 = Vector2(arg_249_0.fade_range_from or 1, arg_249_0.fade_range_to or 0)
	local var_249_5 = arg_249_0.unit
	local var_249_6
	local var_249_7 = arg_249_0.mesh_name

	if var_249_7 then
		fassert(Unit.has_mesh(var_249_5, var_249_7), string.format("[flow_callback_material_fade] The mesh %s doesn't exist in unit %s", var_249_7, tostring(var_249_5)))

		var_249_6 = Unit.mesh(var_249_5, var_249_7)
	end

	local var_249_8
	local var_249_9 = arg_249_0.material_name

	if var_249_6 and var_249_9 then
		fassert(Mesh.has_material(var_249_6, var_249_9), string.format("[flow_callback_material_fade] The material %s doesn't exist for mesh %s", var_249_7, var_249_9))

		var_249_8 = Mesh.material(var_249_6, var_249_9)
	end

	if var_249_6 and var_249_8 then
		do_material_fade(var_249_8, var_249_0, var_249_2, var_249_3, var_249_4)
	elseif var_249_6 then
		local var_249_10 = Mesh.num_materials(var_249_6)

		for iter_249_0 = 0, var_249_10 - 1 do
			do_material_fade(Mesh.material(var_249_6, iter_249_0), var_249_0, var_249_2, var_249_3, var_249_4)
		end
	elseif var_249_9 then
		local var_249_11 = Unit.num_meshes(var_249_5)

		for iter_249_1 = 0, var_249_11 - 1 do
			local var_249_12 = Unit.mesh(var_249_5, iter_249_1)

			if Mesh.has_material(var_249_12, var_249_9) then
				do_material_fade(Mesh.material(var_249_12, var_249_9), var_249_0, var_249_2, var_249_3, var_249_4)
			end
		end
	else
		local var_249_13 = Unit.num_meshes(var_249_5)

		for iter_249_2 = 0, var_249_13 - 1 do
			local var_249_14 = Unit.mesh(var_249_5, iter_249_2)
			local var_249_15 = Mesh.num_materials(var_249_14)

			for iter_249_3 = 0, var_249_15 - 1 do
				do_material_fade(Mesh.material(var_249_14, iter_249_3), var_249_0, var_249_2, var_249_3, var_249_4)
			end
		end
	end
end

function flow_callback_material_fade_chr(arg_250_0)
	fassert(arg_250_0.unit, "[flow_callback_material_fade_chr] You need to specify the Unit")
	fassert(arg_250_0.duration, "[flow_callback_material_fade_chr] You need to specify duration")
	flow_callback_material_fade(arg_250_0)

	local var_250_0 = arg_250_0.unit

	arg_250_0.mesh_name = nil

	local var_250_1 = ScriptUnit.has_extension(var_250_0, "ai_inventory_system")

	if var_250_1 ~= nil then
		for iter_250_0 = 1, #var_250_1.stump_items do
			arg_250_0.unit = var_250_1.stump_items[iter_250_0]

			flow_callback_material_fade(arg_250_0)
		end

		for iter_250_1 = 1, #var_250_1.inventory_item_outfit_units do
			arg_250_0.unit = var_250_1.inventory_item_outfit_units[iter_250_1]

			flow_callback_material_fade(arg_250_0)
		end

		for iter_250_2 = 1, #var_250_1.inventory_item_helmet_units do
			arg_250_0.unit = var_250_1.inventory_item_helmet_units[iter_250_2]

			flow_callback_material_fade(arg_250_0)
		end

		if var_250_1.inventory_item_skin_unit ~= nil then
			arg_250_0.unit = var_250_1.inventory_item_skin_unit

			flow_callback_material_fade(arg_250_0)
		end
	end
end

function flow_callback_material_fade_chr_inventory(arg_251_0)
	fassert(arg_251_0.unit, "[flow_callback_material_fade_chr_inventory] You need to specify the Unit")
	fassert(arg_251_0.duration, "[flow_callback_material_fade_chr_inventory] You need to specify duration")
	fassert(arg_251_0.inventory_type, "[flow_callback_material_fade_chr_inventory] You need to specify inventory type")

	local var_251_0 = arg_251_0.unit

	arg_251_0.mesh_name = nil

	local var_251_1 = ScriptUnit.has_extension(var_251_0, "ai_inventory_system")

	if var_251_1 ~= nil then
		if arg_251_0.inventory_type == "outfit" then
			for iter_251_0 = 1, #var_251_1.inventory_item_outfit_units do
				arg_251_0.unit = var_251_1.inventory_item_outfit_units[iter_251_0]

				flow_callback_material_fade(arg_251_0)
			end
		elseif arg_251_0.inventory_type == "weapon" then
			for iter_251_1 = 1, #var_251_1.inventory_item_weapon_units do
				arg_251_0.unit = var_251_1.inventory_item_weapon_units[iter_251_1]

				flow_callback_material_fade(arg_251_0)
			end
		elseif arg_251_0.inventory_type == "stump" then
			for iter_251_2 = 1, #var_251_1.stump_items do
				arg_251_0.unit = var_251_1.stump_items[iter_251_2]

				flow_callback_material_fade(arg_251_0)
			end
		elseif arg_251_0.inventory_type == "helmet" then
			for iter_251_3 = 1, #var_251_1.inventory_item_helmet_units do
				arg_251_0.unit = var_251_1.inventory_item_helmet_units[iter_251_3]

				flow_callback_material_fade(arg_251_0)
			end
		elseif arg_251_0.inventory_type == "skin" and var_251_1.inventory_item_skin_unit ~= nil then
			arg_251_0.unit = var_251_1.inventory_item_skin_unit

			flow_callback_material_fade(arg_251_0)
		end
	end
end

function flow_callback_visibility_chr_inventory(arg_252_0)
	fassert(arg_252_0.unit, "[flow_callback_visibility_chr_inventory] You need to specify the Unit")

	local var_252_0 = arg_252_0.unit
	local var_252_1 = arg_252_0.visibility
	local var_252_2 = ScriptUnit.has_extension(var_252_0, "ai_inventory_system")

	if var_252_2 ~= nil then
		for iter_252_0 = 1, #var_252_2.inventory_item_outfit_units do
			local var_252_3 = var_252_2.inventory_item_outfit_units[iter_252_0]

			Unit.set_unit_visibility(var_252_3, var_252_1)
			print("Hide " .. Unit.debug_name(var_252_3))
		end

		for iter_252_1 = 1, #var_252_2.inventory_item_weapon_units do
			local var_252_4 = var_252_2.inventory_item_weapon_units[iter_252_1]

			Unit.set_unit_visibility(var_252_4, var_252_1)
			print("Hide " .. Unit.debug_name(var_252_4))
		end

		for iter_252_2 = 1, #var_252_2.stump_items do
			local var_252_5 = var_252_2.stump_items[iter_252_2]

			Unit.set_unit_visibility(var_252_5, var_252_1)
			print("Hide " .. Unit.debug_name(var_252_5))
		end

		for iter_252_3 = 1, #var_252_2.inventory_item_helmet_units do
			local var_252_6 = var_252_2.inventory_item_helmet_units[iter_252_3]

			Unit.set_unit_visibility(var_252_6, var_252_1)
			print("Hide " .. Unit.debug_name(var_252_6))
		end

		if var_252_2.inventory_item_skin_unit ~= nil then
			local var_252_7 = var_252_2.inventory_item_skin_unit

			Unit.set_unit_visibility(var_252_7, var_252_1)
		end
	end
end

function flow_callback_get_chr_inventory_skin_unit(arg_253_0)
	fassert(arg_253_0.unit, "[flow_callback_get_chr_inventory_skin_unit] You need to specify the Unit")

	local var_253_0 = arg_253_0.unit
	local var_253_1 = ScriptUnit.has_extension(var_253_0, "ai_inventory_system")
	local var_253_2

	if var_253_1 ~= nil and var_253_1.inventory_item_skin_unit ~= nil then
		var_253_2 = var_253_1.inventory_item_skin_unit
	end

	fassert(var_253_2, "[flow_callback_get_chr_inventory_skin_unit] No skin found for unit ", tostring(var_253_0))

	var_0_0.skin_unit = var_253_2

	return var_0_0
end

function start_material_fade(arg_254_0, arg_254_1, arg_254_2, arg_254_3, arg_254_4, arg_254_5, arg_254_6, arg_254_7, arg_254_8)
	if arg_254_5 and arg_254_6 then
		Material.set_scalar(arg_254_0, arg_254_5, arg_254_6)
	end

	if arg_254_7 and arg_254_8 then
		Material.set_scalar(arg_254_0, arg_254_7, arg_254_8)
	end

	Material.set_scalar(arg_254_0, arg_254_1, arg_254_2)
	Material.set_vector2(arg_254_0, arg_254_3, arg_254_4)
end

function flow_callback_start_fade(arg_255_0)
	fassert(arg_255_0.unit, "[flow_callback_start_fade] You need to specify the Unit")
	fassert(arg_255_0.duration, "[flow_callback_start_fade] You need to specify duration")
	fassert(arg_255_0.fade_switch, "[flow_callback_start_fade] You need to specify whether to fade in or out (0 or 1)")

	local var_255_0 = World.time(Application.main_world())
	local var_255_1 = Vector2(var_255_0, var_255_0 + arg_255_0.duration)
	local var_255_2 = math.floor(arg_255_0.fade_switch + 0.5)
	local var_255_3 = arg_255_0.fade_switch_name or "fade_switch"
	local var_255_4 = arg_255_0.start_end_time_name or "start_end_time"
	local var_255_5 = arg_255_0.unit
	local var_255_6
	local var_255_7 = arg_255_0.mesh_name
	local var_255_8 = arg_255_0.start_fade_value_name or nil
	local var_255_9 = arg_255_0.start_fade_value or nil
	local var_255_10 = arg_255_0.end_fade_value_name or nil
	local var_255_11 = arg_255_0.end_fade_value or nil

	if var_255_7 then
		fassert(Unit.has_mesh(var_255_5, var_255_7), string.format("[flow_callback_start_fade] The mesh %s doesn't exist in unit %s", var_255_7, tostring(var_255_5)))

		var_255_6 = Unit.mesh(var_255_5, var_255_7)
	end

	local var_255_12
	local var_255_13 = arg_255_0.material_name

	if var_255_6 and var_255_13 then
		fassert(Mesh.has_material(var_255_6, var_255_13), string.format("[flow_callback_start_fade] The material %s doesn't exist for mesh %s", var_255_7, var_255_13))

		var_255_12 = Mesh.material(var_255_6, var_255_13)
	end

	if var_255_6 and var_255_12 then
		start_material_fade(var_255_12, var_255_3, var_255_2, var_255_4, var_255_1, var_255_8, var_255_9, var_255_10, var_255_11)
	elseif var_255_6 then
		local var_255_14 = Mesh.num_materials(var_255_6)

		for iter_255_0 = 0, var_255_14 - 1 do
			local var_255_15 = Mesh.material(var_255_6, iter_255_0)

			start_material_fade(var_255_15, var_255_3, var_255_2, var_255_4, var_255_1, var_255_8, var_255_9, var_255_10, var_255_11)
		end
	elseif var_255_13 then
		local var_255_16 = Unit.num_meshes(var_255_5)

		for iter_255_1 = 0, var_255_16 - 1 do
			local var_255_17 = Unit.mesh(var_255_5, iter_255_1)

			if Mesh.has_material(var_255_17, var_255_13) then
				local var_255_18 = Mesh.material(var_255_17, var_255_13)

				start_material_fade(var_255_18, var_255_3, var_255_2, var_255_4, var_255_1, var_255_8, var_255_9, var_255_10, var_255_11)
			end
		end
	else
		local var_255_19 = Unit.num_meshes(var_255_5)

		for iter_255_2 = 0, var_255_19 - 1 do
			local var_255_20 = Unit.mesh(var_255_5, iter_255_2)
			local var_255_21 = Mesh.num_materials(var_255_20)

			for iter_255_3 = 0, var_255_21 - 1 do
				local var_255_22 = Mesh.material(var_255_20, iter_255_3)

				start_material_fade(var_255_22, var_255_3, var_255_2, var_255_4, var_255_1, var_255_8, var_255_9, var_255_10, var_255_11)
			end
		end
	end
end

function flow_callback_force_death_end(arg_256_0)
	if Managers.state.network.is_server and ScriptUnit.has_extension(arg_256_0.unit, "death_system") then
		ScriptUnit.extension(arg_256_0.unit, "death_system"):force_end()
	end
end

function flow_callback_chr_editor_inventory_spawn(arg_257_0)
	return {
		spawn = true
	}
end

function flow_callback_chr_editor_inventory_unspawn(arg_258_0)
	return {
		unspawn = true
	}
end

function flow_callback_chr_editor_inventory_drop(arg_259_0)
	return {
		dropped = true
	}
end

function flow_callback_chr_enemy_inventory_send_event(arg_260_0)
	fassert(arg_260_0.unit, "[flow_callback_chr_enemy_inventory_send_event] You need to specify the Unit")
	fassert(arg_260_0.event, "[flow_callback_chr_enemy_inventory_send_event] You need to specify an event name")

	local var_260_0 = arg_260_0.unit
	local var_260_1 = arg_260_0.event
	local var_260_2 = ScriptUnit.has_extension(var_260_0, "ai_inventory_system")

	if var_260_2 ~= nil then
		for iter_260_0 = 1, #var_260_2.stump_items do
			Unit.flow_event(var_260_2.stump_items[iter_260_0], var_260_1)
		end

		for iter_260_1 = 1, #var_260_2.inventory_item_units do
			Unit.flow_event(var_260_2.inventory_item_units[iter_260_1], var_260_1)
		end
	end
end

function flow_callback_unit_spawner_spawn_local_unit(arg_261_0)
	local var_261_0 = arg_261_0.unit
	local var_261_1 = arg_261_0.position or Vector3(0, 0, 0)
	local var_261_2 = arg_261_0.rotation or Quaternion.identity()
	local var_261_3 = arg_261_0.scale or Vector3(1, 1, 1)
	local var_261_4 = Matrix4x4.from_quaternion_position(var_261_2, var_261_1)

	Matrix4x4.set_scale(var_261_4, var_261_3)

	local var_261_5 = Managers.state.unit_spawner:spawn_local_unit(var_261_0, var_261_4)

	return {
		spawned = true,
		spawned_unit = var_261_5
	}
end

function flow_callback_unit_spawner_mark_for_deletion(arg_262_0)
	if not var_0_1(arg_262_0.unit) then
		return
	end

	fassert(Managers.state.network.is_server or not NetworkUnit.is_network_unit(arg_262_0.unit), "'flow_callback_unit_spawner_mark_for_deletion' can only delete units spawned locally on client")
	Managers.state.unit_spawner:mark_for_deletion(arg_262_0.unit)
end

function flow_callback_breakable_object_destroyed(arg_263_0)
	local var_263_0 = arg_263_0.unit

	if var_0_1(var_263_0) then
		if Unit.get_data(var_263_0, "destroyed_dynamic") then
			return
		end

		local var_263_1 = Managers.player:statistics_db()
		local var_263_2 = Managers.player:local_player()

		if not var_263_2 then
			return
		end

		local var_263_3 = var_263_2:stats_id()

		var_263_1:increment_stat(var_263_3, "dynamic_objects_destroyed")
		Unit.set_data(var_263_0, "destroyed_dynamic", true)
	end
end

function flow_callback_send_local_system_message(arg_264_0)
	local var_264_0 = arg_264_0.message
	local var_264_1 = true

	Managers.chat:add_local_system_message(1, var_264_0, var_264_1)
end

function flow_callback_localize_string(arg_265_0)
	var_0_0.value = Localize(arg_265_0.string)

	return var_0_0
end

function flow_callback_increment_player_stat(arg_266_0)
	local var_266_0 = Managers.player:local_player()

	if not var_266_0 then
		return
	end

	local var_266_1 = Managers.player:statistics_db()
	local var_266_2 = var_266_0:stats_id()
	local var_266_3 = arg_266_0.stat_name
	local var_266_4 = string.split(var_266_3, "|")

	var_266_1:increment_stat(var_266_2, unpack(var_266_4))
end

local var_0_7 = {
	"rpc_increment_stat",
	"rpc_increment_stat_2",
	"rpc_increment_stat_3"
}

function flow_callback_increment_all_players_stats(arg_267_0)
	local var_267_0 = Managers.player:local_player()

	if not var_267_0 then
		return
	end

	local var_267_1 = Managers.player:statistics_db()
	local var_267_2 = var_267_0:stats_id()
	local var_267_3 = arg_267_0.stat_name
	local var_267_4, var_267_5 = string.split(var_267_3, "|")

	var_267_1:increment_stat(var_267_2, unpack(var_267_4))

	local var_267_6 = var_0_7[var_267_5]

	fassert(var_267_6, "Syncing incrementing stat with %s number of arguments is not supported")

	for iter_267_0 = 1, var_267_5 do
		var_267_4[iter_267_0] = NetworkLookup.statistics[var_267_3]
	end

	Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", unpack(var_267_4))
end

function flow_callback_set_player_stat(arg_268_0)
	local var_268_0 = Managers.player:local_player()

	if not var_268_0 then
		return
	end

	local var_268_1 = Managers.player:statistics_db()
	local var_268_2 = var_268_0:stats_id()
	local var_268_3 = arg_268_0.stat_name
	local var_268_4 = arg_268_0.stat_value
	local var_268_5, var_268_6 = string.split(var_268_3, "|")

	var_268_5[var_268_6 + 1] = var_268_4

	var_268_1:set_stat(var_268_2, unpack(var_268_5))
end

function flow_callback_add_subtitle(arg_269_0)
	local var_269_0 = arg_269_0.speaker
	local var_269_1 = arg_269_0.subtitle

	Managers.state.entity:system("hud_system"):add_subtitle(var_269_0, var_269_1)
end

function flow_callback_remove_subtitle(arg_270_0)
	local var_270_0 = arg_270_0.speaker

	Managers.state.entity:system("hud_system"):remove_subtitle(var_270_0)
end

function flow_callback_fade_in_game_logo(arg_271_0)
	local var_271_0 = arg_271_0.time
	local var_271_1 = Managers.state.entity:system("cutscene_system")

	if var_271_1 then
		var_271_1:fade_game_logo(true, var_271_0)
	end
end

function flow_callback_fade_out_game_logo(arg_272_0)
	local var_272_0 = arg_272_0.time
	local var_272_1 = Managers.state.entity:system("cutscene_system")

	if var_272_1 then
		var_272_1:fade_game_logo(false, var_272_0)
	end
end

function flow_callback_register_main_path_obstacle(arg_273_0)
	local var_273_0 = Managers.state.conflict

	if var_273_0 then
		local var_273_1 = arg_273_0.unit
		local var_273_2 = arg_273_0.unit_node
		local var_273_3 = Unit.world_position(var_273_1, Unit.node(var_273_1, var_273_2))
		local var_273_4, var_273_5 = Unit.box(var_273_1)
		local var_273_6 = Vector3.distance_squared(Vector3(0, 0, 0), var_273_5)

		var_273_0:register_main_path_obstacle(Vector3Box(var_273_3), var_273_6)
	end
end

function flow_callback_enter_post_game(arg_274_0)
	local var_274_0 = Managers.state.network.network_server

	if var_274_0 then
		var_274_0:enter_post_game()
		print("flow_callback_enter_post_game")
	end
end

function flow_query_settings_data(arg_275_0)
	local var_275_0 = arg_275_0.setting

	if not GameSettingsDevelopment then
		print("No GameSettingsDevelopment, running in editor")

		return
	end

	local var_275_1 = GameSettingsDevelopment[var_275_0]

	var_0_0.value = var_275_1

	return var_0_0
end

function flow_callback_survival_handler(arg_276_0)
	fassert(arg_276_0.name, "[flow_callback_survival_handler] You need to specify the name of the waves preset found in survival settings")
	fassert(SurvivalSettings[arg_276_0.name], "Could not find the waves preset you specified, you sure it's the same as in survival settings?")

	local var_276_0 = SurvivalSettings.wave + 1
	local var_276_1 = SurvivalSettings.memory
	local var_276_2 = SurvivalSettings.templates
	local var_276_3 = SurvivalSettings[arg_276_0.name].waves[var_276_0]
	local var_276_4
	local var_276_5 = true
	local var_276_6 = false

	if var_276_3 ~= nil then
		for iter_276_0, iter_276_1 in ipairs(var_276_3) do
			local var_276_7 = math.random(1, #var_276_2[iter_276_1])

			if var_276_1[var_276_2[iter_276_1][var_276_7]] ~= true then
				var_276_1[var_276_2[iter_276_1][var_276_7]] = true
				var_276_4 = var_276_2[iter_276_1][var_276_7]
			else
				var_276_5 = false

				for iter_276_2 = 1, #var_276_2[iter_276_1] do
					if iter_276_2 ~= var_276_7 then
						var_276_5 = true
						var_276_1[var_276_2[iter_276_1][iter_276_2]] = true
						var_276_4 = var_276_2[iter_276_1][iter_276_2]

						break
					end
				end
			end
		end

		if var_276_3.reset ~= nil then
			for iter_276_3, iter_276_4 in ipairs(var_276_3.reset) do
				for iter_276_5 = 1, #var_276_2[iter_276_4] do
					var_276_1[var_276_2[iter_276_4][iter_276_5]] = nil
				end
			end
		end

		if var_276_5 and (Managers.player.is_server or LEVEL_EDITOR_TEST) then
			TerrorEventMixer.start_random_event(var_276_4)
		end
	end

	local var_276_8 = var_276_0
	local var_276_9 = #SurvivalSettings[arg_276_0.name].waves

	if var_276_0 >= #SurvivalSettings[arg_276_0.name].waves then
		SurvivalSettings.memory = {}
		var_276_0 = SurvivalSettings.re_loop_wave
	end

	SurvivalSettings.wave = var_276_0

	return {
		current_wave = var_276_8,
		total_num_waves = var_276_9,
		last_wave = var_276_6
	}
end

function flow_callback_survival_handler_reset(arg_277_0)
	local var_277_0 = {}
	local var_277_1 = arg_277_0.difficulty
	local var_277_2 = SurvivalStartWaveByDifficulty[var_277_1]

	SurvivalSettings.initial_wave = var_277_2
	SurvivalSettings.wave = var_277_2
	SurvivalSettings.memory = var_277_0

	return {
		initial_wave = var_277_2 + 1
	}
end

function flow_callback_set_difficulty(arg_278_0)
	Managers.state.difficulty:set_difficulty(arg_278_0.difficulty, 0)
end

function flow_callback_show_difficulty(arg_279_0)
	fassert(arg_279_0.difficulty, "No difficulty set")

	local var_279_0 = Managers.player:local_player().player_unit

	if var_0_1(var_279_0) then
		ScriptUnit.extension(var_279_0, "hud_system"):set_current_location(Localize("dlc1_2_survival_difficulty_increase") .. " " .. Localize("difficulty_" .. arg_279_0.difficulty))
	end
end

function flow_callback_get_difficulty(arg_280_0)
	local var_280_0
	local var_280_1
	local var_280_2
	local var_280_3
	local var_280_4
	local var_280_5
	local var_280_6
	local var_280_7
	local var_280_8 = Managers.state.difficulty:get_difficulty()

	if var_280_8 == "easy" then
		var_280_0 = true
	end

	if var_280_8 == "normal" then
		var_280_1 = true
	end

	if var_280_8 == "hard" then
		var_280_2 = true
	end

	if var_280_8 == "cataclysm" then
		var_280_3 = true
	end

	if var_280_8 == "harder" then
		var_280_4 = true
	end

	if var_280_8 == "cataclysm_2" then
		var_280_6 = true
	end

	if var_280_8 == "hardest" then
		var_280_5 = true
	end

	if var_280_8 == "cataclysm_3" then
		var_280_7 = true
	end

	var_0_0.easy = var_280_0
	var_0_0.normal = var_280_1
	var_0_0.hard = var_280_2
	var_0_0.cataclysm = var_280_3
	var_0_0.harder = var_280_4
	var_0_0.cataclysm_2 = var_280_6
	var_0_0.hardest = var_280_5
	var_0_0.cataclysm_3 = var_280_7
	var_0_0.difficulty = var_280_8

	return var_0_0
end

function flow_callback_enable_end_level_area(arg_281_0)
	local var_281_0 = Managers.state.game_mode

	if var_281_0.is_server then
		local var_281_1 = arg_281_0.unit
		local var_281_2 = arg_281_0.object
		local var_281_3 = -arg_281_0.left_back_down_extents
		local var_281_4 = arg_281_0.right_forward_up_extents

		var_281_0:activate_end_level_area(var_281_1, var_281_2, var_281_3, var_281_4)
	end
end

function flow_callback_debug_end_level_area(arg_282_0)
	local var_282_0 = Managers.state.game_mode

	if var_282_0.is_server then
		local var_282_1 = arg_282_0.unit
		local var_282_2 = arg_282_0.object
		local var_282_3 = -arg_282_0.left_back_down_extents
		local var_282_4 = arg_282_0.right_forward_up_extents

		var_282_0:debug_end_level_area(var_282_1, var_282_2, var_282_3, var_282_4)
	end
end

function flow_callback_disable_end_level_area(arg_283_0)
	local var_283_0 = Managers.state.game_mode

	if var_283_0.is_server then
		var_283_0:disable_end_level_area(arg_283_0.unit)
	end
end

function flow_callback_disable_lose_condition()
	Managers.state.game_mode:disable_lose_condition()
end

local var_0_8 = {}

function flow_callback_broadphase_deal_damage(arg_285_0)
	fassert(Managers.state.network.is_server, "Only deal damage on server.")

	local var_285_0 = "torso"
	local var_285_1
	local var_285_2 = arg_285_0.position
	local var_285_3 = arg_285_0.radius
	local var_285_4 = arg_285_0.attacker_unit
	local var_285_5 = arg_285_0.hazard_type
	local var_285_6

	if var_0_1(var_285_4) then
		local var_285_7 = Unit.world_rotation(var_285_4, 0)
		local var_285_8 = arg_285_0.direction

		var_285_6 = Quaternion.right(var_285_7) * var_285_8.x + Quaternion.forward(var_285_7) * var_285_8.y + Quaternion.up(var_285_7) * var_285_8.z
	else
		var_285_6 = arg_285_0.direction
	end

	local var_285_9 = EnvironmentalHazards[var_285_5]

	if arg_285_0.hits_enemies then
		local var_285_10 = Managers.time:time("game")
		local var_285_11 = var_285_5
		local var_285_12 = Managers.state.difficulty:get_difficulty_rank()
		local var_285_13 = var_285_9.enemy.difficulty_power_level[var_285_12] or var_285_9.enemy.difficulty_power_level[2] or DefaultPowerLevel
		local var_285_14 = var_285_9.enemy.damage_profile or "default"
		local var_285_15 = DamageProfileTemplates[var_285_14]
		local var_285_16
		local var_285_17 = 0
		local var_285_18 = false
		local var_285_19 = var_285_9.enemy.can_damage
		local var_285_20 = var_285_9.enemy.can_stagger
		local var_285_21 = false
		local var_285_22 = false
		local var_285_23 = AiUtils.broadphase_query(var_285_2, var_285_3, var_0_8)

		for iter_285_0 = 1, var_285_23 do
			local var_285_24 = var_0_8[iter_285_0]

			DamageUtils.server_apply_hit(var_285_10, var_285_4, var_285_24, var_285_0, nil, Vector3.normalize(var_285_6), var_285_1, var_285_11, var_285_13, var_285_15, var_285_16, var_285_17, var_285_18, var_285_19, var_285_20, var_285_21, var_285_22)
		end
	end

	local var_285_25 = arg_285_0.hits_human_players
	local var_285_26 = arg_285_0.hits_bot_players

	if var_285_25 or var_285_26 and var_285_9.player then
		local var_285_27 = var_285_9.player
		local var_285_28 = var_285_27.action_data
		local var_285_29 = Managers.state.difficulty:get_difficulty()
		local var_285_30 = var_285_27.difficulty_damage[var_285_29]

		for iter_285_1, iter_285_2 in pairs(Managers.player:players()) do
			local var_285_31 = iter_285_2:is_player_controlled()
			local var_285_32 = iter_285_2.player_unit

			if var_285_26 and not var_285_31 or var_285_25 and var_285_31 and var_0_1(var_285_32) and var_285_3 > Vector3.distance(var_285_2, POSITION_LOOKUP[var_285_32]) then
				AiUtils.damage_target(var_285_32, var_285_4, var_285_28, var_285_30, var_285_5)
			end
		end
	end
end

function flow_callback_broadphase_deal_damage_debug(arg_286_0)
	local var_286_0 = arg_286_0.hits_enemies
	local var_286_1 = arg_286_0.hits_human_players
	local var_286_2 = arg_286_0.hits_bot_players

	if var_286_0 then
		QuickDrawerStay:sphere(arg_286_0.position, arg_286_0.radius, Color(255, 0, 0))
	end

	if var_286_1 then
		QuickDrawerStay:sphere(arg_286_0.position, arg_286_0.radius + 0.01, Color(0, 255, 0))
	end

	if var_286_2 then
		QuickDrawerStay:sphere(arg_286_0.position, arg_286_0.radius + 0.02, Color(0, 0, 255))
	end
end

function flow_callback_set_particles_light_intensity_exponent(arg_287_0)
	local var_287_0 = arg_287_0.exponent
	local var_287_1 = arg_287_0.id
	local var_287_2 = Application.flow_callback_context_world()

	World.set_particles_light_intensity_exponent(var_287_2, var_287_1, var_287_0)
end

function flow_callback_set_camera_far_range(arg_288_0)
	if DEDICATED_SERVER then
		return
	end

	local var_288_0 = arg_288_0.world_name
	local var_288_1 = arg_288_0.viewport_name
	local var_288_2 = arg_288_0.far_range
	local var_288_3 = Managers.world:world(var_288_0)

	fassert(var_288_3, "[flow_callback_set_camera_far_range] There is currently no world called %s", var_288_0)

	local var_288_4 = World.get_data(var_288_3, "viewports")[var_288_1]

	fassert(var_288_3, "[flow_callback_set_camera_far_range] There is currently no viewport called %s in world %s", var_288_1, var_288_0)
	fassert(var_288_2, "[flow_callback_set_camera_far_range] No far range provided", var_288_2)

	local var_288_5 = ScriptViewport.camera(var_288_4)

	Camera.set_data(var_288_5, "far_range", var_288_2)
end

function flow_callback_barrel_explode(arg_289_0)
	local var_289_0 = arg_289_0.unit
	local var_289_1 = ScriptUnit.extension(var_289_0, "health_system")

	var_289_1:set_max_health(1)
	var_289_1:add_damage(var_289_0, 1, "full", "grenade", Unit.world_position(var_289_0, 0), Vector3(1, 0, 0), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
end

function flow_callback_kill_unit(arg_290_0)
	local var_290_0 = arg_290_0.unit
	local var_290_1 = ScriptUnit.extension(var_290_0, "health_system")

	var_290_1:set_max_health(1)
	var_290_1:add_damage(var_290_0, 1, "full", "forced", Unit.local_position(var_290_0, 0), Vector3(0, 0, 1), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
end

function flow_callback_set_mutator_active(arg_291_0)
	local var_291_0 = arg_291_0.mutator
	local var_291_1 = arg_291_0.active
	local var_291_2 = Managers.state.game_mode._mutator_handler

	if var_291_1 then
		var_291_2:initialize_mutators({
			var_291_0
		})
		var_291_2:activate_mutator(var_291_0, nil, "activated_by_flow")
	else
		var_291_2:deactivate_mutator(var_291_0)
	end
end

function flow_callback_set_deus_curse_active(arg_292_0)
	if not Managers.player.is_server then
		return
	end

	local var_292_0 = Managers.mechanism:game_mechanism()
	local var_292_1 = var_292_0.get_current_node_curse and var_292_0:get_current_node_curse()

	if not var_292_1 then
		return
	end

	local var_292_2 = arg_292_0.active
	local var_292_3 = Managers.state.game_mode._mutator_handler

	if var_292_2 == var_292_3:has_activated_mutator(var_292_1) then
		return
	end

	if var_292_2 then
		var_292_3:initialize_mutators({
			var_292_1
		})
		var_292_3:activate_mutator(var_292_1, nil, "activated_by_flow")
	else
		var_292_3:deactivate_mutator(var_292_1)
	end
end

function flow_callback_set_game_mode_variable(arg_293_0)
	local var_293_0 = arg_293_0.variable
	local var_293_1 = arg_293_0.value

	Managers.state.game_mode:game_mode()[var_293_0] = var_293_1
end

function flow_callback_print_callstack(arg_294_0)
	return
end

function flow_callback_activate_payload(arg_295_0)
	local var_295_0 = arg_295_0.payload_unit

	ScriptUnit.extension(var_295_0, "payload_system"):activate()
end

function flow_callback_deactivate_payload(arg_296_0)
	local var_296_0 = arg_296_0.payload_unit
	local var_296_1 = ScriptUnit.extension(var_296_0, "payload_system")
	local var_296_2 = arg_296_0.force_stop

	var_296_1:deactivate(var_296_2)
end

function flow_callback_activate_end_zone(arg_297_0)
	local var_297_0 = arg_297_0.unit
	local var_297_1 = arg_297_0.activate

	ScriptUnit.extension(var_297_0, "end_zone_system"):activation_allowed(var_297_1)
end

function flow_callback_tutorial_restrict_camera_rotation(arg_298_0)
	local var_298_0 = arg_298_0.angle
	local var_298_1 = arg_298_0.restrict
	local var_298_2 = Managers.player:local_player()

	fassert(var_298_2, "[flow_callback_restrict_camera_rotation] The local player is not available")

	local var_298_3 = var_298_2.player_unit

	fassert(var_0_1(var_298_3), "[flow_callback_restrict_camera_rotation] The local player unit hasn't spawned yet or has been removed")

	local var_298_4 = ScriptUnit.extension(var_298_3, "first_person_system")

	if var_298_1 then
		fassert(var_298_0, "[flow_callback_restrict_camera_rotation] You need to specify an angle when turning on rotation restriction")
	end

	var_298_4:tutorial_restrict_camera_rotation(var_298_1, var_298_0)
end

function flow_callback_prioritize_objective_tooltips(arg_299_0)
	local var_299_0 = arg_299_0.objective_tooltip_name
	local var_299_1 = arg_299_0.reset

	fassert(var_299_0 or var_299_1, "[flow_callback_prioritize_objective_tooltips] You need to provide objective_tooltip_name and/or reset")
	Managers.state.entity:system("tutorial_system"):prioritize_objective_tooltip(var_299_0, var_299_1)
end

local function var_0_9(arg_300_0, arg_300_1)
	arg_300_1 = arg_300_1 or "\n"

	local var_300_0 = {}
	local var_300_1 = 1

	while true do
		local var_300_2, var_300_3 = arg_300_0:find(arg_300_1, var_300_1)

		if not var_300_2 then
			table.insert(var_300_0, arg_300_0:sub(var_300_1))

			break
		end

		table.insert(var_300_0, arg_300_0:sub(var_300_1, var_300_2 - 1))

		var_300_1 = var_300_3 + 1
	end

	return var_300_0
end

function flow_callback_link_objects_in_units_and_store(arg_301_0)
	local var_301_0 = arg_301_0.parent_unit
	local var_301_1 = arg_301_0.child_unit
	local var_301_2 = var_0_9(arg_301_0.parent_nodes, ";")
	local var_301_3 = var_0_9(arg_301_0.child_nodes, ";")
	local var_301_4 = Unit.world(var_301_0)
	local var_301_5 = Script.index_offset()

	for iter_301_0 = 1, #var_301_2 - 1 do
		local var_301_6 = Unit.node(var_301_0, var_301_2[iter_301_0])
		local var_301_7 = var_301_3[iter_301_0]
		local var_301_8

		if string.find(var_301_7, "Index(.)") then
			var_301_8 = tonumber(string.match(var_301_7, "%d+") + var_301_5)
		else
			var_301_8 = Unit.node(var_301_1, var_301_7)
		end

		World.link_unit(var_301_4, var_301_1, var_301_8, var_301_0, var_301_6)

		if arg_301_0.parent_lod_object and arg_301_0.child_lod_object and Unit.has_lod_object(var_301_0, arg_301_0.parent_lod_object) and Unit.has_lod_object(var_301_1, arg_301_0.child_lod_object) then
			local var_301_9 = Unit.lod_object(var_301_0, arg_301_0.parent_lod_object)
			local var_301_10 = Unit.lod_object(var_301_1, arg_301_0.child_lod_object)

			LODObject.set_bounding_volume(var_301_10, LODObject.bounding_volume(var_301_9))
			World.link_unit(var_301_4, var_301_1, LODObject.node(var_301_10), var_301_0, LODObject.node(var_301_9))
		end
	end

	local var_301_11 = Unit.get_data(var_301_0, "flow_unit_attachments") or {}

	table.insert(var_301_11, var_301_1)
	Unit.set_data(var_301_0, "flow_unit_attachments", var_301_11)

	return {
		linked = true
	}
end

function flow_callback_unlink_objects_in_units_and_remove(arg_302_0)
	local var_302_0 = arg_302_0.parent_unit
	local var_302_1 = arg_302_0.child_unit
	local var_302_2 = Unit.world(var_302_0)

	World.unlink_unit(var_302_2, var_302_1)

	local var_302_3 = Unit.get_data(var_302_0, "flow_unit_attachments") or {}
	local var_302_4 = table.find(var_302_3, var_302_1)

	if var_302_4 then
		table.remove(var_302_3, var_302_4)
	end

	Unit.set_data(var_302_0, "flow_unit_attachments", var_302_3)

	return {
		unlinked = true
	}
end

function flow_callback_attach_unit(arg_303_0)
	local var_303_0 = AttachmentNodeLinking
	local var_303_1 = var_0_9(arg_303_0.node_link_template, "/")

	if not var_303_1 then
		print("No attachment node linking defined in flow!")

		return
	end

	for iter_303_0, iter_303_1 in ipairs(var_303_1) do
		var_303_0 = var_303_0[iter_303_1]
	end

	if type(var_303_0) ~= "table" then
		print("No attachment node linking with name %s", tostring(arg_303_0.node_link_template))

		return
	end

	local var_303_2 = arg_303_0.parent_unit
	local var_303_3 = arg_303_0.child_unit
	local var_303_4 = Script.index_offset()
	local var_303_5 = Unit.world(var_303_2)

	for iter_303_2, iter_303_3 in ipairs(var_303_0) do
		local var_303_6 = iter_303_3.source
		local var_303_7 = iter_303_3.target
		local var_303_8 = type(var_303_6) == "string" and Unit.node(var_303_2, var_303_6) or var_303_6 + var_303_4
		local var_303_9 = type(var_303_7) == "string" and Unit.node(var_303_3, var_303_7) or var_303_7 + var_303_4

		World.link_unit(var_303_5, var_303_3, var_303_9, var_303_2, var_303_8)
	end

	if arg_303_0.link_lod_groups and Unit.num_lod_objects(var_303_2) ~= 0 and Unit.num_lod_objects(var_303_3) ~= 0 then
		local var_303_10 = Unit.lod_object(var_303_2, var_303_4)
		local var_303_11 = Unit.lod_object(var_303_3, var_303_4)

		LODObject.set_bounding_volume(var_303_11, LODObject.bounding_volume(var_303_10))
		World.link_unit(var_303_5, var_303_3, LODObject.node(var_303_11), var_303_2, LODObject.node(var_303_10))
	end

	if arg_303_0.store_in_parent then
		local var_303_12 = Unit.get_data(var_303_2, "flow_unit_attachments") or {}

		table.insert(var_303_12, var_303_3)
		Unit.set_data(var_303_2, "flow_unit_attachments", var_303_12)
	end

	return {
		linked = true
	}
end

function flow_callback_unattach_unit(arg_304_0)
	local var_304_0 = arg_304_0.parent_unit
	local var_304_1 = arg_304_0.child_unit
	local var_304_2 = Unit.world(var_304_0)

	World.unlink_unit(var_304_2, var_304_1)

	local var_304_3 = Unit.get_data(var_304_0, "flow_unit_attachments") or {}
	local var_304_4 = table.find(var_304_3, var_304_1)

	if var_304_4 then
		table.remove(var_304_3, var_304_4)
	end

	Unit.set_data(var_304_0, "flow_unit_attachments", var_304_3)

	return {
		unlinked = true
	}
end

function flow_callback_attach_player_item(arg_305_0)
	return
end

function flow_callback_remove_player_items(arg_306_0)
	return
end

function flow_callback_attach_weapon_display(arg_307_0)
	return
end

function flow_callback_trigger_event_on_attachments(arg_308_0)
	local var_308_0 = Unit.get_data(arg_308_0.unit, "flow_unit_attachments") or {}

	for iter_308_0 = 1, #var_308_0 do
		Unit.flow_event(var_308_0[iter_308_0], arg_308_0.event)
	end

	return {
		triggered = true
	}
end

function flow_callback_is_character_alive(arg_309_0)
	local var_309_0 = arg_309_0.unit

	if HEALTH_ALIVE[var_309_0] then
		var_0_0.out_value = true

		return var_0_0
	end

	var_0_0.out_value = false

	return var_0_0
end

function flow_callback_is_leader(arg_310_0)
	local var_310_0 = Managers.party:leader()
	local var_310_1 = Network.peer_id() == var_310_0

	return {
		yes = var_310_1,
		no = not var_310_1
	}
end

function flow_callback_enforce_player_positions(arg_311_0)
	if not Managers.player.is_server then
		print("flow_callback_enforce_player_positions() run on client, doing nothing")

		return
	end

	local var_311_0 = arg_311_0.volume_name
	local var_311_1 = arg_311_0.force
	local var_311_2

	if var_311_1 == "inside" then
		var_311_2 = true
	elseif var_311_1 == "outside" then
		var_311_2 = false
	else
		ferror("Trying to enforce players position with unknown state %s", tostring(var_311_1))
	end

	local var_311_3 = Application.flow_callback_context_world()
	local var_311_4 = LevelHelper:current_level(var_311_3)
	local var_311_5 = Managers.player
	local var_311_6 = Managers.state.entity:system("health_system")
	local var_311_7
	local var_311_8 = Managers.state.side:get_side_from_name("heroes")
	local var_311_9 = var_311_8.PLAYER_UNITS
	local var_311_10 = var_311_8.PLAYER_POSITIONS

	for iter_311_0, iter_311_1 in pairs(var_311_9) do
		local var_311_11 = var_311_10[iter_311_0]

		if Level.is_point_inside_volume(var_311_4, var_311_0, var_311_11) == var_311_2 then
			var_311_7 = var_311_11
		else
			local var_311_12 = ScriptUnit.extension(iter_311_1, "status_system")

			if var_311_12:is_disabled() and not var_311_12:is_ready_for_assisted_respawn() and not var_311_12:is_dead() then
				var_311_6:suicide(iter_311_1)
			end
		end
	end

	local var_311_13 = var_311_8.PLAYER_AND_BOT_UNITS
	local var_311_14 = var_311_8.PLAYER_AND_BOT_POSITIONS

	for iter_311_2, iter_311_3 in pairs(var_311_13) do
		local var_311_15 = var_311_5:owner(iter_311_3)

		if var_311_15 and not var_311_15:is_player_controlled() then
			local var_311_16 = var_311_14[iter_311_2]

			if not (Level.is_point_inside_volume(var_311_4, var_311_0, var_311_16) == var_311_2) then
				local var_311_17 = ScriptUnit.extension(iter_311_3, "status_system")
				local var_311_18 = var_311_17:is_disabled()
				local var_311_19 = var_311_17:is_ready_for_assisted_respawn()
				local var_311_20 = var_311_17:is_dead()

				if var_311_18 and not var_311_19 and not var_311_20 then
					var_311_6:suicide(iter_311_3)
				elseif not var_311_19 and not var_311_20 and var_311_7 then
					local var_311_21 = ScriptUnit.extension(iter_311_3, "locomotion_system")
					local var_311_22 = var_311_21:current_rotation()

					var_311_21:teleport_to(var_311_7, var_311_22)
				end
			end
		end
	end

	if var_311_7 then
		Managers.state.game_mode:teleport_despawned_players(var_311_7)
	end
end

function flow_callback_tutorial_enable_equipment(arg_312_0)
	local var_312_0 = arg_312_0.enable
	local var_312_1 = arg_312_0.wield_anim
	local var_312_2 = Managers.player:local_player()

	fassert(var_312_2, "[flow_callback_tutorial_enable_equipment] The local player is not available")

	local var_312_3 = var_312_2.player_unit

	fassert(var_0_1(var_312_3), "[flow_callback_tutorial_enable_equipment ]gloThe local player unit hasn't spawned yet or has been removed")

	local var_312_4 = ScriptUnit.extension(var_312_3, "first_person_system")

	var_312_4:tutorial_show_first_person_units(var_312_0)

	local var_312_5 = {
		action_two_release = true,
		action_inspect = true,
		action_three = true,
		action_one_hold = true,
		action_inspect_hold = true,
		action_one_release = true,
		action_three_hold = true,
		character_inspecting = true,
		action_three_release = true,
		action_two = true,
		action_one = true,
		action_two_hold = true
	}
	local var_312_6 = ScriptUnit.extension(var_312_3, "input_system")

	if var_312_0 then
		if var_312_1 then
			local var_312_7 = var_312_4:get_first_person_unit()

			Unit.animation_event(var_312_7, var_312_1)
		end

		local var_312_8 = var_312_6:disallowed_input_table()

		for iter_312_0, iter_312_1 in pairs(var_312_5) do
			var_312_8[iter_312_0] = nil
		end

		Managers.state.game_mode:game_mode():disable_hud(false)
	else
		local var_312_9 = var_312_6:disallowed_input_table()

		table.merge(var_312_9, var_312_5)
		var_312_6:set_disallowed_inputs(var_312_9)
		Managers.state.game_mode:game_mode():disable_hud(true)
	end
end

function flow_callbacks_add_tutorial_animation_hook(arg_313_0)
	local var_313_0 = arg_313_0.animation_hook
	local var_313_1 = arg_313_0.animation_hook_free_text

	var_313_0 = var_313_1 ~= "" and var_313_1 or var_313_0

	fassert(var_313_0 and PauseEvents.animation_hook_templates[var_313_0], "[flow_callbacks] There is no animation hook called: %s", tostring(var_313_0))

	local var_313_2 = table.clone(PauseEvents.animation_hook_templates[var_313_0])

	Managers.state.entity:system("play_go_tutorial_system"):add_animation_hook(var_313_2)
end

function flow_callbacks_trigger_pause_event(arg_314_0)
	local var_314_0 = arg_314_0.pause_event_name
	local var_314_1 = arg_314_0.look_position

	fassert(var_314_0 and PauseEvents.pause_events[var_314_0], "[flow_callbacks] There is not pause events called: %s", tostring(var_314_0))

	local var_314_2 = table.clone(PauseEvents.pause_events[var_314_0])

	Managers.state.entity:system("play_go_tutorial_system"):trigger_pause_event(var_314_2, var_314_1)
end

function flow_callbacks_add_tutorial_equipment(arg_315_0)
	local var_315_0 = arg_315_0.slot_name
	local var_315_1 = arg_315_0.item_name
	local var_315_2 = arg_315_0.starting_ammo and math.floor(arg_315_0.starting_ammo) or 0

	fassert(var_315_1 and ItemMasterList[var_315_1], "[flow_callbacks_add_tutorial_equipment] There is no item called %s in ItemMasterList", tostring(var_315_1))

	local var_315_3 = ItemMasterList[var_315_1]
	local var_315_4 = Managers.player:local_player().player_unit
	local var_315_5 = ScriptUnit.extension(var_315_4, "inventory_system")

	var_315_5:add_equipment(var_315_0, var_315_3, nil, nil, var_315_2)

	if var_315_0 == "slot_melee" then
		var_315_5:wield("slot_melee")
	else
		var_315_5:wield("slot_ranged")
	end
end

local function var_0_10(arg_316_0, arg_316_1, arg_316_2)
	if arg_316_2 then
		local var_316_0 = arg_316_0:disallowed_input_table()

		for iter_316_0, iter_316_1 in pairs(arg_316_1) do
			var_316_0[iter_316_0] = nil
		end

		arg_316_0:set_disallowed_inputs(var_316_0)
		arg_316_0:set_allowed_inputs(arg_316_1)
	else
		local var_316_1 = arg_316_0:disallowed_input_table()

		table.merge(var_316_1, arg_316_1)
		arg_316_0:set_disallowed_inputs(var_316_1)
	end
end

function flow_callbacks_tutorial_inputs_enabled(arg_317_0)
	local var_317_0 = Managers.player:local_player()

	fassert(var_317_0, "[flow_callbacks_tutorial_inputs_enabled] The local player is not available")

	local var_317_1 = var_317_0.player_unit

	fassert(var_0_1(var_317_1), "[flow_callbacks_tutorial_inputs_enabled] The local player unit hasn't spawned yet or has been removed")

	local var_317_2 = arg_317_0.move
	local var_317_3 = arg_317_0.jump_dodge
	local var_317_4 = arg_317_0.attack
	local var_317_5 = arg_317_0.block
	local var_317_6 = arg_317_0.career_ability
	local var_317_7 = arg_317_0.weapon_switch
	local var_317_8 = {
		move_back_pressed = true,
		move_forward_pressed = true,
		move_right = true,
		move_controller = true,
		move_right_pressed = true,
		move_left = true,
		move_forward = true,
		move_back = true,
		move_left_pressed = true
	}
	local var_317_9 = {
		jump_only = true,
		dodge = true,
		jump_1 = true,
		dodge_hold = true,
		jump_2 = true
	}
	local var_317_10 = {
		action_one_softbutton_gamepad = true,
		action_one_mouse = true,
		action_one_hold = true,
		action_one_release = true,
		action_one = true
	}
	local var_317_11 = {
		action_two_hold = true,
		action_two = true
	}
	local var_317_12 = {
		action_career_release = true,
		action_career = true,
		action_career_hold = true
	}
	local var_317_13 = {
		wield_switch = true,
		wield_2 = true,
		wield_next = true,
		wield_5 = true,
		wield_prev = true,
		wield_0 = true,
		wield_8 = true,
		wield_3 = true,
		wield_switch_2 = true,
		wield_6 = true,
		wield_switch_1 = true,
		wield_1 = true,
		wield_9 = true,
		wield_4 = true,
		wield_scroll = true,
		wield_7 = true
	}
	local var_317_14 = ScriptUnit.extension(var_317_1, "input_system")

	var_0_10(var_317_14, var_317_8, var_317_2)
	var_0_10(var_317_14, var_317_9, var_317_3)
	var_0_10(var_317_14, var_317_10, var_317_4)
	var_0_10(var_317_14, var_317_11, var_317_5)
	var_0_10(var_317_14, var_317_12, var_317_6)
	var_0_10(var_317_14, var_317_13, var_317_7)
end

function flow_callbacks_tutorial_enable_weapon_switching(arg_318_0)
	local var_318_0 = arg_318_0.enable
	local var_318_1 = Managers.player:local_player()

	fassert(var_318_1, "[flow_callbacks_tutorial_enable_weapon_switching] The local player is not available")

	local var_318_2 = var_318_1.player_unit

	fassert(var_0_1(var_318_2), "[flow_callbacks_tutorial_enable_weapon_switching] The local player unit hasn't spawned yet or has been removed")

	local var_318_3 = {
		wield_switch = true,
		wield_2 = true,
		wield_next = true,
		wield_5 = true,
		wield_prev = true,
		wield_0 = true,
		wield_8 = true,
		wield_3 = true,
		wield_switch_2 = true,
		wield_6 = true,
		wield_switch_1 = true,
		wield_1 = true,
		wield_9 = true,
		wield_4 = true,
		wield_scroll = true,
		wield_7 = true
	}
	local var_318_4 = ScriptUnit.extension(var_318_2, "input_system")

	if var_318_0 then
		local var_318_5 = var_318_4:disallowed_input_table()

		for iter_318_0, iter_318_1 in pairs(var_318_3) do
			var_318_5[iter_318_0] = nil
		end
	else
		local var_318_6 = var_318_4:disallowed_input_table()

		table.merge(var_318_6, var_318_3)
		var_318_4:set_disallowed_inputs(var_318_6)
	end
end

function flow_callbacks_tutorial_enable_career_skill(arg_319_0)
	local var_319_0 = arg_319_0.enable
	local var_319_1 = Managers.player:local_player().player_unit
	local var_319_2 = ScriptUnit.extension(var_319_1, "career_system")

	if not var_319_0 then
		var_319_2:start_activated_ability_cooldown(1, 0)
		var_319_2:set_activated_ability_cooldown_paused(1)
	else
		var_319_2:set_activated_ability_cooldown_unpaused(1)
		var_319_2:reduce_activated_ability_cooldown_percent(1, 1)
	end
end

function flow_callback_enable_bot_loot(arg_320_0)
	local var_320_0 = arg_320_0.enable
	local var_320_1 = Managers.state.entity:system("play_go_tutorial_system")

	if var_320_1 then
		var_320_1:enable_bot_loot(var_320_0)
	end
end

function flow_callback_enable_bot_portrait(arg_321_0)
	local var_321_0 = arg_321_0.bot_display_name

	Managers.state.entity:system("play_go_tutorial_system"):set_bot_portrait_enabled(var_321_0)
end

function flow_callback_set_player_invincibility(arg_322_0)
	if not Managers.player.is_server then
		return
	end

	local var_322_0 = arg_322_0.player_unit
	local var_322_1 = arg_322_0.invincible

	if var_0_1(var_322_0) then
		local var_322_2 = ScriptUnit.has_extension(var_322_0, "health_system")

		fassert(var_322_2, "Tried to set invincibility on unit %s from flow but the unit has no health extension", var_322_0)

		var_322_2.is_invincible = var_322_1
	end
end

function flow_callback_switch_player_class(arg_323_0)
	local var_323_0 = arg_323_0.player_unit
	local var_323_1 = arg_323_0.profile_name

	if not var_323_1 then
		local var_323_2 = Managers.player:unit_owner(var_323_0)
		local var_323_3 = var_323_2:network_id()
		local var_323_4 = var_323_2:local_player_id()
		local var_323_5 = Managers.party:get_party_from_player_id(var_323_3, var_323_4)
		local var_323_6 = Managers.state.side.side_by_party[var_323_5].available_profiles or PROFILES_BY_AFFILIATION.heroes

		for iter_323_0 = 1, #var_323_6 do
			var_323_1 = var_323_6[iter_323_0]

			break
		end
	end

	if var_323_1 then
		local var_323_7 = FindProfileIndex(var_323_1)
		local var_323_8 = SPProfiles[var_323_7].careers
		local var_323_9 = var_323_8[script_data.wanted_career_index] or var_323_8[1]
		local var_323_10 = true

		if var_323_9.display_name == "vs_undecided" then
			return
		end

		Managers.state.network:request_profile(1, var_323_1, var_323_9.display_name, var_323_10)
	end
end

function flow_callback_switch_player_party(arg_324_0)
	local var_324_0 = arg_324_0.party_id

	if var_324_0 then
		local var_324_1 = tonumber(var_324_0)
		local var_324_2 = Managers.party:get_party(var_324_1)

		if var_324_2 and var_324_2.num_open_slots + var_324_2.num_bots > 0 then
			print("Debug switching wanted party to:", var_324_1)

			local var_324_3 = Managers.player:local_player()
			local var_324_4 = var_324_3:local_player_id()
			local var_324_5 = var_324_3:network_id()
			local var_324_6 = Managers.mechanism:current_mechanism_name()
			local var_324_7 = Managers.state.side.side_by_party[var_324_2]

			Managers.party:request_join_party(var_324_5, var_324_4, var_324_1)

			if var_324_3 and var_324_3:needs_despawn() then
				Managers.state.spawn:delayed_despawn(var_324_3)
			end

			local var_324_8 = Managers.state.entity:system("camera_system")

			if var_324_2.name == "spectators" then
				local var_324_9 = PROFILES_BY_NAME.spectator

				var_324_8:initialize_camera_states(var_324_3, var_324_9.index, 1)
			else
				local var_324_10 = FindProfileIndex("witch_hunter")

				var_324_8:initialize_camera_states(var_324_3, var_324_10, 1)
			end

			local var_324_11 = Managers.state.side:sides()
			local var_324_12
			local var_324_13

			for iter_324_0 = 1, #var_324_11 do
				local var_324_14 = var_324_11[iter_324_0]
				local var_324_15 = string.format("%s_%s", var_324_6, var_324_14:name())
				local var_324_16 = var_324_14 == var_324_7

				Managers.state.game_mode:set_object_set_enabled(var_324_15, var_324_16)
			end
		end
	end
end

function flow_callback_set_player_in_hanging_cage(arg_325_0)
	local var_325_0 = arg_325_0.idle_animation
	local var_325_1 = arg_325_0.falling_animation
	local var_325_2 = arg_325_0.landing_animation
	local var_325_3 = arg_325_0.player_unit
	local var_325_4 = arg_325_0.cage_unit
	local var_325_5 = arg_325_0.state

	if var_0_1(var_325_3) then
		local var_325_6 = ScriptUnit.has_extension(var_325_3, "status_system")

		fassert(var_325_6, "Tried to set in_hanging_cage status on unit %s from flow but the unit has no status extension", var_325_3)
		fassert(var_325_5, "Need to set in_hanging_cage state!")

		local var_325_7 = var_325_6.in_hanging_cage_animations or {
			idle = var_325_0,
			falling = var_325_1,
			landing = var_325_2
		}

		var_325_6:set_in_hanging_cage(true, var_325_4, var_325_5, var_325_7)
	end
end

function flow_callback_set_player_fall_height(arg_326_0)
	local var_326_0 = arg_326_0.unit
	local var_326_1 = ScriptUnit.has_extension(var_326_0, "status_system")

	if var_326_1 then
		if var_326_1.is_husk then
			if BUILD == "release" then
				Crashify.print_exception("flow_callbacks", "Trying to set falling height on unit not owned")
			else
				ferror("Trying to set falling height on unit not owned")
			end
		else
			var_326_1:set_falling_height(true)
		end
	end
end

function flow_callback_set_local_player_gravity_scale(arg_327_0)
	local var_327_0 = arg_327_0.gravity_scale or 1
	local var_327_1 = Managers.player:human_and_bot_players()

	for iter_327_0, iter_327_1 in pairs(var_327_1) do
		if iter_327_1.local_player or iter_327_1.bot_player and iter_327_1.is_server then
			local var_327_2 = iter_327_1.player_unit
			local var_327_3 = ScriptUnit.has_extension(var_327_2, "locomotion_system")

			if var_327_3 and var_327_3.set_script_driven_gravity_scale then
				var_327_3:set_script_driven_gravity_scale(var_327_0)
			end
		end
	end
end

function flow_callback_enable_generic_unit_aim_extension(arg_328_0)
	local var_328_0 = arg_328_0.unit
	local var_328_1 = arg_328_0.enable
	local var_328_2 = ScriptUnit.has_extension(var_328_0, "aim_system")

	if var_328_2 then
		var_328_2:set_enabled(var_328_1)
	end
end

function flow_callbacks_players_not_in_end_zone()
	var_0_0.witch_hunter = false
	var_0_0.bright_wizard = false
	var_0_0.dwarf_ranger = false
	var_0_0.wood_elf = false
	var_0_0.empire_soldier = false
	var_0_0.empire_soldier_tutorial = false

	local var_329_0 = 0
	local var_329_1 = Managers.player:human_and_bot_players()

	for iter_329_0, iter_329_1 in pairs(var_329_1) do
		local var_329_2 = iter_329_1.player_unit

		if Unit.alive(var_329_2) then
			local var_329_3 = ScriptUnit.extension(var_329_2, "status_system"):is_in_end_zone()
			local var_329_4 = iter_329_1:profile_display_name()

			if not var_329_3 and var_329_4 then
				var_329_0 = var_329_0 + 1
				var_0_0[var_329_4] = true
			end
		end
	end

	var_0_0.outside_count = var_329_0

	return var_0_0
end

function flow_callback_store_parent(arg_330_0)
	local var_330_0 = arg_330_0.parent_unit
	local var_330_1 = arg_330_0.child_unit

	Unit.set_data(var_330_1, "parent_ref", var_330_0)
end

function flow_callback_stored_parent(arg_331_0)
	local var_331_0 = arg_331_0.child_unit
	local var_331_1 = Unit.get_data(var_331_0, "parent_ref")

	return {
		parent_unit = var_331_1
	}
end

function flow_callback_set_unit_enabled(arg_332_0)
	local var_332_0 = arg_332_0.unit

	if not var_0_1(var_332_0) then
		Crashify.print_exception("Deleted Unit", "referenced in flow")

		return
	end

	if arg_332_0.enabled then
		Unit.set_unit_visibility(var_332_0, true)
		Unit.enable_physics(var_332_0)
		Unit.enable_animation_state_machine(var_332_0)
	else
		Unit.set_unit_visibility(var_332_0, false)

		local var_332_1 = Managers.state.entity:system("projectile_linker_system")

		if var_332_1 ~= nil then
			var_332_1:clear_linked_projectiles(var_332_0)
		end

		Unit.disable_physics(var_332_0)

		if Unit.has_animation_state_machine(var_332_0) then
			Unit.disable_animation_state_machine(var_332_0)
		end
	end
end

function flow_callback_register_looping_event_timer(arg_333_0)
	Managers.state.game_mode:register_looping_event_timer(arg_333_0.unique_id, arg_333_0.time, arg_333_0.level_event_name)
end

function flow_callback_unregister_looping_event_timer(arg_334_0)
	Managers.state.game_mode:unregister_looping_event_timer(arg_334_0.unique_id)
end

function flow_callback_rpc_clients_level_event(arg_335_0)
	if Managers.state.game_mode then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_trigger_level_event", arg_335_0.level_event_name)
	end
end

function flow_callback_set_unit_physics(arg_336_0)
	if arg_336_0.physics then
		Unit.enable_physics(arg_336_0.unit)
	else
		Unit.disable_physics(arg_336_0.unit)
	end
end

function flow_callback_specific_pickup_gizmo_spawned(arg_337_0)
	local var_337_0 = Managers.state.entity:system("pickup_system")

	if var_337_0 then
		var_337_0:specific_pickup_gizmo_spawned(arg_337_0.unit)
	end
end

function flow_callback_set_unit_faded_status(arg_338_0)
	local var_338_0 = arg_338_0.unit
	local var_338_1 = arg_338_0.faded
	local var_338_2 = ScriptUnit.extension(var_338_0, "status_system")

	if var_338_2 then
		var_338_2:set_invisible(var_338_1, nil, "flow_faded")
	end
end

function flow_callback_get_level_seed(arg_339_0)
	return {
		seed = Managers.mechanism:get_level_seed()
	}
end

function flow_callback_predict_hitscan(arg_340_0)
	local var_340_0 = arg_340_0.player_unit
	local var_340_1 = arg_340_0.range or 10
	local var_340_2 = arg_340_0.spread or 0
	local var_340_3 = {
		success = false
	}
	local var_340_4 = Managers.world and Managers.world:has_world(LevelHelper.INGAME_WORLD_NAME) and Managers.world:world(LevelHelper.INGAME_WORLD_NAME)

	if not var_340_4 then
		return var_340_3
	end

	local var_340_5 = World.get_data(var_340_4, "physics_world")

	if not var_340_5 then
		return var_340_3
	end

	local var_340_6 = Managers.state.network
	local var_340_7 = var_340_6:game()
	local var_340_8 = var_340_6:unit_game_object_id(var_340_0)

	if var_340_7 and var_340_8 then
		local var_340_9 = GameSession.game_object_field(var_340_7, var_340_8, "aim_direction")
		local var_340_10 = GameSession.game_object_field(var_340_7, var_340_8, "aim_position")
		local var_340_11 = math.random() * math.rad(var_340_2)
		local var_340_12 = math.random() * math.rad(var_340_2)
		local var_340_13 = Quaternion.rotate(Quaternion(Vector3.up(), var_340_11), var_340_9)
		local var_340_14 = Quaternion.rotate(Quaternion(Vector3.right(), var_340_12), var_340_13)
		local var_340_15 = PhysicsWorld.immediate_raycast_actors(var_340_5, var_340_10, var_340_14, var_340_1, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
		local var_340_16 = 1
		local var_340_17 = 2

		var_340_3.end_position = var_340_15 and var_340_15[1][var_340_16] or var_340_10 + var_340_14 * var_340_1
		var_340_3.success = true
		var_340_3.distance = var_340_15 and var_340_15[1][var_340_17] or var_340_1
	end

	return var_340_3
end

function flow_callback_spawn_defenders_ward(arg_341_0)
	Managers.state.event:trigger("spawn_defenders", arg_341_0.num_defenders)
end

function flow_callback_cog_collision(arg_342_0)
	local var_342_0 = arg_342_0.touching_actor
	local var_342_1 = Actor.velocity(var_342_0)

	if not var_342_0 then
		return
	end

	if Vector3.length(var_342_1) <= 0.1 then
		return
	end

	local var_342_2 = arg_342_0.touching_unit
	local var_342_3 = arg_342_0.unit
	local var_342_4 = ScriptUnit.extension(var_342_3, "pickup_system").owner_peer_id
	local var_342_5 = Network.peer_id()

	if var_342_4 == Network.peer_id() then
		Managers.state.achievement:trigger_event("on_trail_cog_strike", var_342_2)
	end

	if Managers.state.network.is_server then
		local var_342_6 = var_342_2
		local var_342_7 = POSITION_LOOKUP[var_342_3]
		local var_342_8 = Vector3.flat(var_342_7)
		local var_342_9 = POSITION_LOOKUP[var_342_6]
		local var_342_10 = Vector3.flat(var_342_9)
		local var_342_11 = "torso"
		local var_342_12 = "trail_cog"
		local var_342_13 = EnvironmentalHazards[var_342_12]
		local var_342_14 = var_342_12
		local var_342_15
		local var_342_16 = Vector3.normalize(var_342_10 - var_342_8)
		local var_342_17 = var_342_13.enemy.damage_profile or "default"
		local var_342_18 = DamageProfileTemplates[var_342_17]
		local var_342_19
		local var_342_20 = 0
		local var_342_21 = false
		local var_342_22 = true
		local var_342_23 = true
		local var_342_24 = false
		local var_342_25 = false
		local var_342_26 = Managers.state.difficulty:get_difficulty_rank()
		local var_342_27 = var_342_13.enemy.difficulty_power_level[var_342_26] or var_342_13.enemy.difficulty_power_level[2] or DefaultPowerLevel
		local var_342_28 = Managers.time:time("game")

		DamageUtils.server_apply_hit(var_342_28, var_342_3, var_342_6, var_342_11, nil, var_342_16, var_342_15, var_342_14, var_342_27, var_342_18, var_342_19, var_342_20, var_342_21, var_342_22, var_342_23, var_342_24, var_342_25)
	end
end

function flow_callback_reset_cog_collision_stat()
	local var_343_0 = Managers.state.network.is_server

	Managers.state.achievement:trigger_event("on_trail_cog_reset_stat")
end

function flow_callback_environment_hazard_damage_collision(arg_344_0)
	if Managers.state.network.is_server then
		local var_344_0 = arg_344_0.touching_unit
		local var_344_1 = arg_344_0.unit
		local var_344_2 = arg_344_0.hazard_type
		local var_344_3 = POSITION_LOOKUP[var_344_1] or Unit.world_position(var_344_1, 0)
		local var_344_4 = Vector3.flat(var_344_3)
		local var_344_5 = POSITION_LOOKUP[var_344_0]
		local var_344_6 = Vector3.flat(var_344_5)
		local var_344_7 = "full"
		local var_344_8 = EnvironmentalHazards[var_344_2]
		local var_344_9 = var_344_2
		local var_344_10 = true
		local var_344_11 = Vector3.normalize(var_344_6 - var_344_4)
		local var_344_12 = var_344_8.enemy.damage_profile or "default"
		local var_344_13 = DamageProfileTemplates[var_344_12]
		local var_344_14
		local var_344_15 = 0
		local var_344_16 = false
		local var_344_17 = true
		local var_344_18 = true
		local var_344_19 = false

		if not arg_344_0.shield_breaking_hit then
			local var_344_20 = true
		end

		local var_344_21 = Managers.state.difficulty:get_difficulty_rank()
		local var_344_22 = var_344_8.enemy.difficulty_power_level[var_344_21] or var_344_8.enemy.difficulty_power_level[2] or DefaultPowerLevel
		local var_344_23 = Managers.time:time("game")
		local var_344_24 = ScriptUnit.extension(var_344_0, "health_system")
		local var_344_25 = var_344_8.enemy.difficulty_damage[var_344_21] or var_344_8.enemy.difficulty_damage[2]

		var_344_24:add_damage(var_344_0, var_344_25, var_344_7, "cutting", var_344_5, var_344_11, "wounded_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

		if var_344_24:is_dead() then
			local var_344_26 = ({
				"dismember_torso",
				"dismember_head",
				"explode_body"
			})[math.random(1, 3)]

			Unit.flow_event(var_344_0, var_344_26)
		else
			DamageUtils.stagger_ai(var_344_23, var_344_13, var_344_14, var_344_22, var_344_0, var_344_1, var_344_7, var_344_11, var_344_15, var_344_16, var_344_19, var_344_9)
		end
	end
end

function flow_callback_hazard_push_damage_player_and_husks(arg_345_0)
	if Managers.player.is_server and DamageUtils.is_player_unit(arg_345_0.touching_unit) then
		local var_345_0 = arg_345_0.unit
		local var_345_1 = arg_345_0.touching_unit
		local var_345_2 = arg_345_0.push_multiplier
		local var_345_3 = arg_345_0.damage
		local var_345_4 = POSITION_LOOKUP[var_345_0] or Unit.world_position(var_345_0, 0)
		local var_345_5 = Vector3.flat(var_345_4)
		local var_345_6 = POSITION_LOOKUP[var_345_1]
		local var_345_7 = Vector3.flat(var_345_6)

		if var_0_1(var_345_1) and var_345_3 then
			local var_345_8 = "full"
			local var_345_9 = "forced"
			local var_345_10 = Vector3.up()

			ScriptUnit.extension(var_345_1, "health_system"):add_damage(var_345_1, var_345_3, var_345_8, var_345_9, var_345_6, var_345_10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local var_345_11 = Vector3.normalize(var_345_7 - var_345_5) * var_345_2

		ScriptUnit.extension(var_345_1, "locomotion_system"):add_external_velocity(var_345_11)
	end
end

function flow_callback_push_nearby_players(arg_346_0)
	local var_346_0 = arg_346_0.source_unit
	local var_346_1 = Unit.local_position(var_346_0, 0)
	local var_346_2 = (arg_346_0.range or 5)^2
	local var_346_3 = arg_346_0.force or 5
	local var_346_4 = arg_346_0.local_player_only
	local var_346_5 = Quaternion.forward(Unit.local_rotation(var_346_0, 0)) * var_346_3

	if var_346_4 then
		local var_346_6 = Managers.player:local_player()
		local var_346_7 = var_346_6 and var_346_6.player_unit

		if var_346_7 and var_346_2 > Vector3.distance_squared(POSITION_LOOKUP[var_346_7], var_346_1) then
			ScriptUnit.extension(var_346_7, "locomotion_system"):add_external_velocity(var_346_5, var_346_3)
		end
	else
		local var_346_8 = Managers.player:players()

		for iter_346_0, iter_346_1 in pairs(var_346_8) do
			local var_346_9 = iter_346_1.player_unit

			if var_346_9 and var_346_2 > Vector3.distance_squared(POSITION_LOOKUP[var_346_9], var_346_1) then
				ScriptUnit.extension(var_346_9, "locomotion_system"):add_external_velocity(var_346_5, var_346_3)
			end
		end
	end
end

function flow_callback_start_disrupt_ritual(arg_347_0)
	fassert(arg_347_0.unit, "[flow_callbacks] DISRUPT RITUAL: No level unit name provided [required]")
	fassert(arg_347_0.volume_name, "[flow_callbacks] DISRUPT RITUAL: No volume name provided [required]")
	fassert(arg_347_0.num_progression_events > 1, "[flow_callbacks] DISRUPT RITUAL: num_progession_events have to be atleast 2: one for start and one for end [required]")
	fassert(arg_347_0.num_progression_events, "[flow_callbacks] DISRUPT RITUAL: No num progression events provided [required]")
	fassert(arg_347_0.tick_length, "[flow_callbacks] DISRUPT RITUAL: No tick length provided [required]")
	fassert(arg_347_0.damage_per_tick, "[flow_callbacks] DISRUPT RITUAL: No damage per tick provided [required]")
	fassert(arg_347_0.heal_per_tick, "[flow_callbacks] DISRUPT RITUAL: No heal per tick provided [required]")
	Managers.state.event:trigger("start_disrupt_ritual", arg_347_0.unit, arg_347_0.volume_name, arg_347_0.volume_type, arg_347_0.num_progression_events, arg_347_0.tick_length, arg_347_0.damage_per_tick, arg_347_0.heal_per_tick)
end

function flow_callback_spawn_sofia_defenders(arg_348_0)
	if not Managers.player.is_server then
		return
	end

	local var_348_0 = arg_348_0.unit
	local var_348_1 = {
		arg_348_0.spawn_position1,
		arg_348_0.spawn_position2,
		arg_348_0.spawn_position3
	}

	ScriptUnit.extension(var_348_0, "ward_system"):spawn_sofia_defenders(var_348_1)
end

function flow_callback_spawn_skulls_tower_end(arg_349_0)
	if not Managers.player.is_server then
		return
	end

	local var_349_0 = arg_349_0.num_skulls
	local var_349_1 = {}
	local var_349_2 = Unit.world_position(arg_349_0.sofia_unit, 0)

	var_349_1.sofia_unit_pos = Vector3Box(var_349_2)

	var_349_1.spawned_func = function (arg_350_0, arg_350_1, arg_350_2)
		local var_350_0 = BLACKBOARDS[arg_350_0]

		if var_350_0 then
			var_350_0.sofia_unit_pos = arg_350_2.sofia_unit_pos
		end
	end

	var_349_1.prepare_func = function (arg_351_0, arg_351_1)
		local var_351_0 = false

		arg_351_0.modify_extension_init_data(arg_351_0, var_351_0, arg_351_1)
	end

	local var_349_3 = Vector3.up()
	local var_349_4 = Vector3.right()
	local var_349_5 = Quaternion.identity()
	local var_349_6 = Vector3(0, 0, 3)
	local var_349_7 = 0.1
	local var_349_8 = math.pi * 2 / var_349_0

	for iter_349_0 = 1, var_349_0 do
		local var_349_9 = Quaternion.rotate(Quaternion(var_349_3, var_349_8 * iter_349_0), var_349_4) * var_349_7 + var_349_6
		local var_349_10 = var_349_2 + var_349_6
		local var_349_11 = "fx/ethereal_skulls_teleport_01"

		if var_349_11 then
			local var_349_12 = NetworkLookup.effects[var_349_11]
			local var_349_13 = 0
			local var_349_14 = Quaternion.identity()

			Managers.state.network:rpc_play_particle_effect(nil, var_349_12, NetworkConstants.invalid_game_object_id, var_349_13, var_349_10, var_349_14, false)
		end

		Managers.state.conflict:spawn_queued_unit(Breeds.tower_homing_skull, Vector3Box(var_349_10), QuaternionBox(var_349_5), nil, "spawn_idle", nil, var_349_1)
	end
end

function flow_callback_trigger_sofia_explosion(arg_352_0)
	local var_352_0 = {
		enemy_damage = arg_352_0.enemy_damage
	}

	Managers.state.event:trigger("on_failed_guardians_event", var_352_0)
end

function flow_callback_spawn_magic_missile_two_targets(arg_353_0)
	local var_353_0 = arg_353_0.unit
	local var_353_1 = arg_353_0.first_character
	local var_353_2 = arg_353_0.second_character

	assert(var_353_1, "[flow_callback_spawn_two_targets_vfx_projectile_tower] assign a first_character")

	local var_353_3

	if Unit.get_data(var_353_1, "visible") then
		var_353_3 = var_353_1
	else
		assert(var_353_2, "[flow_callback_spawn_two_targets_vfx_projectile_tower] first_character is not visible and second_character is not assigned")

		var_353_3 = var_353_2
	end

	local var_353_4 = arg_353_0.spawn_node_name
	local var_353_5 = arg_353_0.target_node_name
	local var_353_6 = arg_353_0.optional_second_target
	local var_353_7 = arg_353_0.optional_second_target_node_name
	local var_353_8 = arg_353_0.speed
	local var_353_9 = arg_353_0.trajectory_template_name
	local var_353_10 = arg_353_0.impact_with_last_target
	local var_353_11 = arg_353_0.character_name

	assert(var_353_9, "[flow_callback_spawn_two_targets_vfx_projectile_tower] needs a trajectory_template_name choosen")
	assert(var_353_3, "[flow_callback_spawn_two_targets_vfx_projectile_tower] assign a target")
	assert(var_353_11, "[flow_callback_spawn_two_targets_vfx_projectile_tower] assign character name")

	local var_353_12 = Projectiles.vfx_scripted_projectile_unit
	local var_353_13 = var_353_12.name
	local var_353_14 = var_353_12.gravity_settings
	local var_353_15 = var_353_12.angle
	local var_353_16 = var_353_12.impact_template_name
	local var_353_17 = var_353_12.impact_collision_filter
	local var_353_18 = var_353_12.radius
	local var_353_19 = var_353_12.only_one_impact
	local var_353_20

	if var_353_11 == "sofia" then
		var_353_20 = ProjectileUnits.sofia_vfx_scripted_projectile_unit
	else
		var_353_20 = ProjectileUnits.olesya_vfx_scripted_projectile_unit
	end

	local var_353_21 = var_353_20.projectile_unit_name
	local var_353_22 = Unit.node(var_353_0, var_353_4) or 0
	local var_353_23 = Unit.world_position(var_353_0, var_353_22)
	local var_353_24 = Unit.local_rotation(var_353_0, 0)
	local var_353_25 = Unit.node(var_353_3, var_353_5) or 0
	local var_353_26 = Unit.world_position(var_353_3, var_353_25)
	local var_353_27 = Vector3.normalize(var_353_26 - var_353_23)
	local var_353_28 = var_353_23 + var_353_27 * 0.25
	local var_353_29 = {
		(Vector3Box(var_353_26))
	}
	local var_353_30 = {
		var_353_3
	}

	if Unit.alive(var_353_6) then
		local var_353_31 = Unit.node(var_353_6, var_353_7) or 0
		local var_353_32 = Unit.world_position(var_353_6, var_353_31)

		var_353_29[2] = Vector3Box(var_353_32)
		var_353_30[2] = var_353_6
	end

	local var_353_33 = {
		projectile_locomotion_system = {
			angle = var_353_15,
			speed = var_353_8,
			target_vector = var_353_27,
			target_positions = var_353_29,
			target_units = var_353_30,
			initial_position = var_353_28,
			trajectory_template_name = var_353_9,
			gravity_settings = var_353_14,
			impact_with_last_target = var_353_10
		},
		projectile_impact_system = {
			sphere_radius = var_353_18,
			only_one_impact = var_353_19,
			collision_filter = var_353_17
		},
		projectile_system = {
			impact_template_name = var_353_16
		}
	}

	Managers.state.unit_spawner:spawn_local_unit_with_extensions(var_353_21, var_353_13, var_353_33, var_353_28, var_353_24)
end

function flow_callback_set_rotating_hazard_state(arg_354_0)
	if not Managers.state.network.is_server then
		return
	end

	local var_354_0 = arg_354_0.unit
	local var_354_1 = ScriptUnit.has_extension(var_354_0, "props_system")

	if var_354_1 then
		local var_354_2 = arg_354_0.state

		if var_354_2 == "start" then
			var_354_1:start(false)
		elseif var_354_2 == "restart" then
			var_354_1:start(true)
		elseif var_354_2 == "pause" then
			var_354_1:pause()
		elseif var_354_2 == "stop" then
			var_354_1:stop()
		end
	end
end

function flow_callback_trigger_event_on_all_sub_levels(arg_355_0)
	local var_355_0 = arg_355_0.event_name

	if not var_355_0 then
		return
	end

	local var_355_1 = Application.flow_callback_context_level()

	if not var_355_1 then
		return
	end

	local var_355_2 = Level.get_data(var_355_1, "sub_levels")

	if var_355_2 then
		for iter_355_0, iter_355_1 in pairs(var_355_2) do
			Level.trigger_event(iter_355_1, var_355_0)
		end
	end
end

function flow_callback_trigger_event_on_sub_level(arg_356_0)
	local var_356_0 = arg_356_0.event_name

	if not var_356_0 then
		return
	end

	local var_356_1 = Application.flow_callback_context_level()

	if not var_356_1 then
		return
	end

	local var_356_2 = Level.get_data(var_356_1, "sub_levels")

	if var_356_2 then
		local var_356_3 = var_356_2[arg_356_0.sub_level_name]

		if var_356_3 then
			Level.trigger_event(var_356_3, var_356_0)
		end
	end
end

function flow_callback_trigger_event_of_parent_level(arg_357_0)
	local var_357_0 = arg_357_0.event_name

	if not var_357_0 then
		return
	end

	local var_357_1 = Application.flow_callback_context_level()

	if not var_357_1 then
		return
	end

	local var_357_2 = Level.get_data(var_357_1, "parent_level")

	if not var_357_2 then
		return
	end

	Level.trigger_event(var_357_2, var_357_0)
end

function flow_callback_trigger_event_on_context_level(arg_358_0)
	local var_358_0 = arg_358_0.event_name

	if not var_358_0 then
		return
	end

	local var_358_1 = Application.flow_callback_context_level()

	if not var_358_1 then
		return
	end

	Level.trigger_event(var_358_1, var_358_0)
end

function flow_callback_get_intro_wwise_id(arg_359_0)
	local var_359_0 = Application.flow_callback_context_level()

	if not var_359_0 then
		return
	end

	var_0_0.wwise_id = Level.get_data(var_359_0, "intro_wwise_id") or 0

	return var_0_0
end

function flow_callback_on_tower_skull_found(arg_360_0)
	Managers.state.achievement:trigger_event("on_tower_skull_found")
end

function flow_callback_tower_wall_illusion_found(arg_361_0)
	Managers.state.achievement:trigger_event("tower_wall_illusion_found", arg_361_0.index)
end

function flow_callback_update_tower_invisible_bridge_challenge(arg_362_0)
	Managers.state.achievement:trigger_event("update_tower_invisible_bridge_challenge", arg_362_0.succeeded)
end

function flow_callback_note_puzzle_solved(arg_363_0)
	Managers.state.achievement:trigger_event("tower_note_puzzle")
end

function flow_callback_tower_potion_created(arg_364_0)
	Managers.state.achievement:trigger_event("tower_potion_created", arg_364_0.type)
end

function flow_callback_tower_time_challenge_done(arg_365_0)
	return
end

function tower_guardian_of_lustria_challenge_done(arg_366_0)
	Managers.state.achievement:trigger_event("tower_enable_guardian_of_lustria")
end

function flow_callback_tower_skulls_set_target(arg_367_0)
	Managers.state.event:trigger("set_tower_skulls_target", arg_367_0.unit, true)
end

function flow_callback_tower_barrel_achievement(arg_368_0)
	local var_368_0 = arg_368_0.event_name

	Managers.state.achievement:trigger_event("tower_barrels", var_368_0, arg_368_0.unit)
end

function flow_callback_tower_barrel_challenge_done(arg_369_0)
	Managers.state.achievement:trigger_event("tower_barrels", "done")
end

function flow_callback_once_in_play_session(arg_370_0)
	local var_370_0 = arg_370_0.key

	script_data.once_in_play_session = script_data.once_in_play_session or {}
	var_0_0.out = not script_data.once_in_play_session[var_370_0]
	script_data.once_in_play_session[var_370_0] = true

	return var_0_0
end

function flow_callback_trigger_gameplay_start(arg_371_0)
	Managers.state.achievement:trigger_event("gameplay_start")
end

function flow_callback_dwarf_emote_achievement(arg_372_0)
	Managers.state.achievement:trigger_event("dwarf_valaya_emote", arg_372_0.is_inside)
end

function flow_callback_complete_dwarf_barrel_challenge(arg_373_0)
	Managers.state.achievement:trigger_event("dwarf_barrel_carry", true)
end

function flow_callback_complete_dwarf_rune_challenge(arg_374_0)
	Managers.state.achievement:trigger_event("dwarf_rune")
end

function flow_callback_complete_dwarf_bell_challenge(arg_375_0)
	Managers.state.achievement:trigger_event("dwarf_bells")
end

function flow_callback_update_dwarf_pressure_challenge(arg_376_0)
	Managers.state.achievement:trigger_event("dwarf_pressure", arg_376_0.start_timer)
end

function flow_callback_progress_dwarf_towers_challenge(arg_377_0)
	Managers.state.achievement:trigger_event("progress_dwarf_towers_challenge")
end

function flow_callback_progress_dwarf_chain_speed_challenge(arg_378_0)
	Managers.state.achievement:trigger_event("progress_dwarf_chain_speed_challenge")
end

function flow_callback_complete_dwarf_jump_puzzle_challenge(arg_379_0)
	Managers.state.achievement:trigger_event("complete_dwarf_jump_puzzle_challenge")
end

function flow_callback_update_dwarf_pressure_pad_challenge(arg_380_0)
	Managers.state.achievement:trigger_event("dwarf_pressure_pad", arg_380_0.unit, arg_380_0.is_on_pad, arg_380_0.complete_challenge)
end

function flow_callback_complete_dwarf_crows_challenge(arg_381_0)
	Managers.state.achievement:trigger_event("dwarf_crows")
end

function flow_callback_update_big_jump_challenge(arg_382_0)
	Managers.state.achievement:trigger_event("dwarf_big_jump", arg_382_0.is_landing)
end

function flow_callback_complete_dwarf_speedrun_challenge(arg_383_0)
	Managers.state.achievement:trigger_event("dwarf_speedrun_end")
end

function flow_callback_start_dwarf_speedrun_challenge(arg_384_0)
	Managers.state.achievement:trigger_event("dwarf_speedrun_start")
end

function flow_callback_carousel_set_time(arg_385_0)
	if not Managers.player.is_server then
		return
	end

	Managers.mechanism:game_mechanism():win_conditions():set_time(arg_385_0.time)
end

function flow_callback_carousel_get_current_set(arg_386_0)
	assert(Managers.mechanism:current_mechanism_name() == "versus", "[flow_callback_carousel_get_current_set]: current mechanism has to be 'versus' ")

	return {
		set = Managers.mechanism:game_mechanism():get_current_set()
	}
end

function flow_callback_carousel_force_start_round(arg_387_0)
	assert(Managers.mechanism:current_mechanism_name() == "versus", "[flow_callback_carousel_force_start_round]: current mechanism has to be 'versus' ")

	local var_387_0 = Managers.state.entity

	if var_387_0 and var_387_0:system("round_started_system") then
		var_387_0:system("round_started_system"):force_start_round()
	end
end

function flow_set_numeric_flow_variable(arg_388_0)
	local var_388_0 = arg_388_0.unit
	local var_388_1 = arg_388_0.name
	local var_388_2 = arg_388_0.value

	Unit.set_flow_variable(var_388_0, var_388_1, var_388_2)
end

function flow_callback_set_faction_memory(arg_389_0)
	Managers.state.entity:system("dialogue_system"):set_faction_memory(arg_389_0.faction, arg_389_0.key, arg_389_0.value)
end

function flow_callback_set_user_memory(arg_390_0)
	Managers.state.entity:system("dialogue_system"):set_user_memory(arg_390_0.unit, arg_390_0.key, arg_390_0.value)
end

function flow_callback_set_user_context(arg_391_0)
	Managers.state.entity:system("dialogue_system"):set_user_context(arg_391_0.unit, arg_391_0.key, arg_391_0.value)
end

function flow_callback_set_global_context(arg_392_0)
	Managers.state.entity:system("dialogue_system"):set_global_context(arg_392_0.key, arg_392_0.value)
end

function flow_callback_run_faction_op(arg_393_0)
	local var_393_0 = arg_393_0.unit
	local var_393_1 = arg_393_0.faction
	local var_393_2 = arg_393_0.argument_name
	local var_393_3 = arg_393_0.op
	local var_393_4 = arg_393_0.optional_argument_value

	Managers.state.entity:system("dialogue_system"):force_faction_op(var_393_0, var_393_1, var_393_2, var_393_3, var_393_4)
end

function flow_callback_lock_available_hero(arg_394_0)
	local var_394_0 = Managers.state.game_mode:lock_available_hero()

	assert(var_394_0, "[flow_callback_lock_available_hero] Couldn't find any available hero")

	var_0_0.locked_profile_index = var_394_0

	return var_0_0
end

function flow_callback_whaling_village_buboes_destroyed(arg_395_0)
	Managers.state.achievement:trigger_event("dwarf_feculent_buboes")
end

function flow_callback_whaling_village_statue_emote(arg_396_0)
	Managers.state.achievement:trigger_event("dwarf_statue_emote", arg_396_0.is_inside)
end

function flow_callback_whaling_village_go_fish(arg_397_0)
	Managers.state.achievement:trigger_event("dwarf_go_fish")
end

function flow_callback_whaling_village_elevator_speedrun(arg_398_0)
	Managers.state.achievement:trigger_event("dwarf_elevator_speedrun")
end

function flow_callback_termite_part_1_skaven_markings_challenge(arg_399_0)
	Managers.state.achievement:trigger_event("termite1_skaven_markings_challenge")
end

function flow_callback_termite_part_1_bell_challenge(arg_400_0)
	Managers.state.achievement:trigger_event("termite1_bell_challenge")
end

function flow_callback_termite_part_1_towers_challenge(arg_401_0)
	Managers.state.achievement:trigger_event("termite1_towers_challenge")
end

function flow_callback_termite_part_1_waystone_timer_challenge_easy(arg_402_0)
	Managers.state.achievement:trigger_event("termite1_waystone_timer_challenge_easy")
end

function flow_callback_termite_part_1_waystone_timer_challenge_hard(arg_403_0)
	Managers.state.achievement:trigger_event("termite1_waystone_timer_challenge_hard")
end

function flow_callback_termite_part_2_mushroom_challenge(arg_404_0)
	Managers.state.achievement:trigger_event("termite2_mushroom_challenge")
end

function flow_callback_termite_part_2_timer_challenge(arg_405_0)
	Managers.state.achievement:trigger_event("termite2_timer_challenge")
end

function flow_callback_termite_part_3_collectible_challenge(arg_406_0)
	Managers.state.achievement:trigger_event("termite3_collectible_challenge")
end

function flow_callback_termite_part_3_searchlight_challenge(arg_407_0)
	Managers.state.achievement:trigger_event("termite3_searchlight_challenge")
end

function flow_callback_termite_part_3_generator_challenge(arg_408_0)
	Managers.state.achievement:trigger_event("termite3_generator_challenge")
end

function flow_callback_termite_part_3_portal_challenge(arg_409_0)
	Managers.state.achievement:trigger_event("termite3_portal_challenge")
end

function flow_callback_divine_sink_ships_challenge(arg_410_0)
	Managers.state.achievement:trigger_event("divine_sink_ships_challenge", arg_410_0.challenge_start)
end

function flow_callback_divine_anchor_attached(arg_411_0)
	Managers.state.achievement:trigger_event("divine_anchor_attached")
end

function flow_callback_divine_anchor_destroyed(arg_412_0)
	Managers.state.achievement:trigger_event("divine_anchor_destroyed")
end

function flow_callback_divine_anchor_completed(arg_413_0)
	Managers.state.achievement:trigger_event("divine_anchor_challenge_completed")
end

function flow_callback_divine_nautical_miles_challenge(arg_414_0)
	Managers.state.achievement:trigger_event("divine_nautical_miles_challenge")
end

function flow_callback_divine_cannon_challenge(arg_415_0)
	Managers.state.achievement:trigger_event("divine_cannon_challenge")
end

function flow_callback_register_combination_puzzle(arg_416_0)
	local var_416_0 = arg_416_0.puzzle_group
	local var_416_1 = arg_416_0.puzzle_name or ""
	local var_416_2 = arg_416_0.puzzle_combination
	local var_416_3 = arg_416_0.ordered
	local var_416_4 = arg_416_0.completed_level_event
	local var_416_5 = arg_416_0.hot_join_sync_completion

	if not var_416_0 or not var_416_2 then
		return
	end

	local var_416_6 = Managers.state.entity
	local var_416_7 = var_416_6 and var_416_6:system("puzzle_system")

	if var_416_7 then
		var_416_7:register_puzzle(var_416_0, var_416_1, var_416_2, var_416_3, var_416_4, var_416_5)
	else
		ferror("Puzzle '%s' was registered before systems were created", var_416_0)
	end
end

function flow_callback_register_random_match_puzzle(arg_417_0)
	local var_417_0 = arg_417_0.puzzle_group
	local var_417_1 = arg_417_0.puzzle_name or ""
	local var_417_2 = arg_417_0.possible_values
	local var_417_3 = arg_417_0.num_needed_matches
	local var_417_4 = arg_417_0.completed_level_event
	local var_417_5 = arg_417_0.hot_join_sync_completion

	if not var_417_0 or not var_417_2 or not var_417_3 then
		return
	end

	local var_417_6 = 6
	local var_417_7 = string.split_deprecated(var_417_2, ",")
	local var_417_8 = Managers.mechanism:get_level_seed() + HashUtils.fnv32_hash(var_417_0) + HashUtils.fnv32_hash(var_417_1)
	local var_417_9 = FrameTable.alloc_table()

	for iter_417_0 = 1, math.min(var_417_3, var_417_6) do
		local var_417_10
		local var_417_11

		var_417_8, var_417_11 = Math.next_random(var_417_8, 1, #var_417_7)

		local var_417_12

		if table.contains(var_417_9, var_417_7[var_417_11]) then
			local var_417_13 = var_417_11

			repeat
				var_417_11 = math.index_wrapper(var_417_11 + 1, #var_417_7)
			until not table.contains(var_417_9, var_417_7[var_417_11]) or var_417_11 == var_417_13
		end

		var_417_9[iter_417_0] = var_417_7[var_417_11]
		var_0_0["chosen_value" .. iter_417_0] = var_417_7[var_417_11]
	end

	for iter_417_1 = var_417_3 + 1, var_417_6 do
		var_0_0["chosen_value" .. iter_417_1] = ""
	end

	local var_417_14 = table.concat(var_417_9, ",")
	local var_417_15 = false
	local var_417_16 = Managers.state.entity
	local var_417_17 = var_417_16 and var_417_16:system("puzzle_system")

	if var_417_17 then
		var_417_17:register_puzzle(var_417_0, var_417_1, var_417_14, var_417_15, var_417_4, var_417_5)
	end

	return var_0_0
end

function flow_callback_string_to_numeric(arg_418_0)
	local var_418_0 = tonumber(arg_418_0.string)

	var_0_0.value = var_418_0 or 0
	var_0_0.success = not not var_418_0

	return var_0_0
end

local var_0_11 = {
	True = true,
	TRUE = true,
	["true"] = true,
	False = false,
	["false"] = false,
	FALSE = false
}

function flow_callback_string_to_bool(arg_419_0)
	local var_419_0 = var_0_11[arg_419_0.string]

	var_0_0.value = var_419_0 or false
	var_0_0.success = var_419_0 ~= nil

	return var_0_0
end

function flow_callback_string_to_bool(arg_420_0)
	local var_420_0 = var_0_11[arg_420_0.string]

	var_0_0.value = var_420_0 or false
	var_0_0.success = var_420_0 ~= nil

	return var_0_0
end

function flow_callback_get_mechanism_name(arg_421_0)
	local var_421_0 = Managers.mechanism:current_mechanism_name()

	var_0_0.name = var_421_0

	return var_0_0
end

function flow_callbacks_flow_helper_register_check_unit_line_of_sight(arg_422_0)
	if not Managers.state.network then
		return
	end

	local var_422_0 = arg_422_0.owner_unit
	local var_422_1 = arg_422_0.raycast_from_unit
	local var_422_2 = arg_422_0.raycast_from_node and Unit.alive(var_422_1) and Unit.node(var_422_1, arg_422_0.raycast_from_node) or 0
	local var_422_3 = arg_422_0.unit_to_check
	local var_422_4 = arg_422_0.ignore_if_invisible
	local var_422_5 = arg_422_0.flow_event_enter
	local var_422_6 = arg_422_0.flow_event_leave
	local var_422_7 = arg_422_0.collision_filter
	local var_422_8 = arg_422_0.debug_draw

	Managers.state.flow_helper:register_line_of_sight_check(var_422_0, var_422_1, var_422_2, var_422_3, var_422_4, var_422_5, var_422_6, var_422_7, var_422_8)
end

function flow_callbacks_flow_helper_unregister_check_unit_line_of_sight(arg_423_0)
	if not Managers.state.network then
		return
	end

	local var_423_0 = arg_423_0.owner_unit
	local var_423_1 = arg_423_0.unit_to_check

	Managers.state.flow_helper:unregister_line_of_sight_check(var_423_0, var_423_1)
end

function flow_force_abort_interactable(arg_424_0)
	if not Managers.state.network or not Managers.state.network.is_server then
		return
	end

	local var_424_0 = arg_424_0.interactable_unit
	local var_424_1 = ScriptUnit.extension(var_424_0, "interactable_system"):is_being_interacted_with()

	if not var_424_1 then
		return
	end

	InteractionHelper:complete_interaction(var_424_1, var_424_0, InteractionResult.FAILURE)
end

function flow_callbacks_get_local_player_team_data(arg_425_0)
	var_0_0.party_name = "undecided"
	var_0_0.team_name = "undecided"

	local var_425_0 = Managers.player:local_player()

	if not var_425_0 then
		return var_0_0
	end

	local var_425_1 = Managers.party:get_party_from_unique_id(var_425_0:unique_id())

	if not var_425_1 then
		return var_0_0
	end

	var_0_0.party_name = var_425_1.name

	local var_425_2 = Managers.state.game_mode:setting("party_names_lookup_by_id")[var_425_1.party_id]

	var_0_0.team_name = var_425_2

	return var_0_0
end

function flow_callbacks_get_death_reaction_attacker_unit(arg_426_0)
	local var_426_0 = Managers.state.entity:system("death_system"):flow_get_killing_blow_attacker_unit()

	var_0_0.attacker_unit = Unit.alive(var_426_0) and var_426_0 or Unit.null_reference()

	return var_0_0
end

function flow_callbacks_get_owner_of_unit_that_occupied_objective_socket(arg_427_0)
	local var_427_0 = Managers.state.entity:system("objective_socket_system"):get_owner_of_unit_that_occupied_socket(arg_427_0.socket_unit, arg_427_0.socket_name)

	var_0_0.owner_unit = Unit.alive(var_427_0) and var_427_0 or Unit.null_reference()

	return var_0_0
end

function flow_query_is_special_event_active(arg_428_0)
	var_0_0.is_event_active = false

	local var_428_0 = Managers.backend:get_interface("live_events")

	if var_428_0 and var_428_0.get_active_events then
		local var_428_1 = var_428_0:get_active_events()

		if var_428_1 and #var_428_1 ~= 0 then
			var_0_0.is_event_active = true
		end
	end

	return var_0_0
end

function flow_query_global_listener(arg_429_0)
	local var_429_0 = arg_429_0.dialogue_profile

	if Managers.state.entity then
		local var_429_1 = Managers.state.entity:system("surrounding_aware_system")

		var_0_0.unit = var_429_1:query_global_listener(var_429_0) or Unit.null_reference()
	else
		var_0_0.unit = Unit.null_reference()
	end

	return var_0_0
end

function flow_callbacks_set_story_trigger_frozen(arg_430_0)
	local var_430_0 = arg_430_0.frozen
	local var_430_1 = Managers.state.entity

	if var_430_1 then
		local var_430_2 = var_430_1:system("dialogue_system")

		if var_430_0 then
			var_430_2:freeze_story_trigger()
		else
			var_430_2:unfreeze_story_trigger()
		end
	end
end

function flow_callbacks_teleport_non_character_elevator_units(arg_431_0)
	local var_431_0 = arg_431_0.transport_unit
	local var_431_1 = ScriptUnit.has_extension(var_431_0, "transportation_system")

	if var_431_1 then
		local var_431_2 = arg_431_0.to_reference_unit

		if Unit.alive(var_431_2) then
			var_431_1:teleport_non_character_elevator_units(var_431_2)
		end
	end
end

function flow_query_is_level_unit(arg_432_0)
	local var_432_0 = arg_432_0.unit
	local var_432_1 = Application.flow_callback_context_world()
	local var_432_2 = LevelHelper:current_level(var_432_1)
	local var_432_3 = Level.unit_index(var_432_2, var_432_0)

	var_0_0.is_level_unit = not not var_432_3

	return var_0_0
end

function flow_query_is_game_object_unit(arg_433_0)
	local var_433_0 = arg_433_0.unit
	local var_433_1 = Application.flow_callback_context_world()
	local var_433_2 = LevelHelper:current_level(var_433_1)
	local var_433_3 = Level.unit_index(var_433_2, var_433_0)

	var_0_0.is_game_object_unit = not var_433_3

	return var_0_0
end

function flow_wwise_set_state_synced(arg_434_0)
	if Managers.music then
		local var_434_0 = arg_434_0.music_player
		local var_434_1 = arg_434_0.group
		local var_434_2 = arg_434_0.state

		Managers.music:set_music_group_state(var_434_0, var_434_1, var_434_2)
	end
end

function flow_callback_string_or_default(arg_435_0)
	local var_435_0 = arg_435_0.string
	local var_435_1 = arg_435_0.default

	if not var_435_0 or var_435_0 == "" then
		var_0_0.out_string = var_435_1
	else
		var_0_0.out_string = var_435_0
	end

	return var_0_0
end

local var_0_12 = {}

function flow_callback_once_by_unit(arg_436_0)
	local var_436_0 = arg_436_0.unit
	local var_436_1 = Application.flow_callback_context_level()

	if not var_436_1 then
		var_0_0.out = false

		return var_0_0
	end

	if not var_0_12[var_436_1] then
		table.clear(var_0_12)

		var_0_12[var_436_1] = {}
	end

	if var_436_0 == Unit.null_reference() then
		var_0_0.out = false
	else
		var_0_0.out = not var_0_12[var_436_1][var_436_0]
		var_0_12[var_436_1][var_436_0] = true
	end

	return var_0_0
end
