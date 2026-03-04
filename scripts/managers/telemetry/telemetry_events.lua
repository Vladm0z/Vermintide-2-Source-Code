-- chunkname: @scripts/managers/telemetry/telemetry_events.lua

require("scripts/managers/telemetry/telemetry_settings")
require("scripts/managers/telemetry/telemetry_rpc_listener")
require("scripts/managers/telemetry/telemetry_event")

local var_0_0 = table.remove_empty_values(TelemetrySettings.source)

TelemetryEvents = class(TelemetryEvents)

function TelemetryEvents.init(arg_1_0, arg_1_1)
	arg_1_0._manager = arg_1_1
	arg_1_0.rpc_listener = TelemetryRPCListener:new(arg_1_0)
	arg_1_0._subject = {}

	if script_data.testify then
		arg_1_0._subject.machine_id = Application.machine_id and Application.machine_id()
		arg_1_0._subject.machine_name = script_data.machine_name
	end

	arg_1_0._session = {
		game = Application.guid()
	}
	arg_1_0._context = {}

	if IS_XB1 then
		var_0_0.console_type = XboxOne.console_type_string()
	elseif IS_PS4 then
		var_0_0.console_type = PS4.is_pro() and "pro" or "not_pro"
	end

	arg_1_0:game_startup()
end

function TelemetryEvents.destroy(arg_2_0)
	arg_2_0:game_shutdown()
end

function TelemetryEvents.game_startup(arg_3_0)
	local var_3_0 = arg_3_0:_create_event("game_startup")

	arg_3_0._manager:register_event(var_3_0)
end

function TelemetryEvents.game_shutdown(arg_4_0)
	local var_4_0 = arg_4_0:_create_event("game_shutdown")

	var_4_0:set_data({
		time_in_game = Application.time_since_launch()
	})
	arg_4_0._manager:register_event(var_4_0)
end

function TelemetryEvents.game_started(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:_create_event("game_started")
	local var_5_1 = {}

	table.keys(arg_5_1.mutators, var_5_1)
	table.sort(var_5_1)
	var_5_0:set_data({
		peer_type = arg_5_1.peer_type,
		country_code = arg_5_1.country_code,
		quick_game = arg_5_1.quick_game,
		game_mode = arg_5_1.game_mode,
		level_key = arg_5_1.level_key,
		difficulty = arg_5_1.difficulty,
		mutators = table.concat(var_5_1, ","),
		realm = arg_5_1.realm
	})
	arg_5_0._manager:register_event(var_5_0)
end

function TelemetryEvents.versus_round_started(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	local var_6_0 = arg_6_0:_create_event("versus_round_started")

	var_6_0:set_data({
		player_id = arg_6_1,
		game_round = arg_6_2,
		match_id = arg_6_3,
		slot_melee = arg_6_4,
		slot_ranged = arg_6_5,
		talents = arg_6_6
	})
	arg_6_0._manager:register_event(var_6_0)
end

function TelemetryEvents.versus_custom_game_settings(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_0:_create_event("versus_custom_game_settings")

	var_7_0:set_data({
		player_id = arg_7_1,
		match_id = arg_7_2,
		settings = arg_7_3,
		is_default_ruleset = arg_7_4,
		modified_settings = arg_7_5
	})
	arg_7_0._manager:register_event(var_7_0)
end

function TelemetryEvents.versus_round_ended(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0:_create_event("versus_round_end")

	var_8_0:set_data({
		score = arg_8_1,
		game_round = arg_8_2,
		match_id = arg_8_3
	})
	arg_8_0._manager:register_event(var_8_0)
end

function TelemetryEvents.versus_match_ended(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0:_create_event("versus_match_ended")

	var_9_0:set_data({
		match_id = arg_9_1,
		is_draw = arg_9_2,
		winning_team = arg_9_3
	})
	arg_9_0._manager:register_event(var_9_0)
end

function TelemetryEvents.versus_pactsworn_picking(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	local var_10_0 = arg_10_0:_create_event("versus_pactsworn_picking")

	var_10_0:set_data({
		match_id = arg_10_1,
		player_id = arg_10_2,
		career_options = arg_10_3,
		selected_career = arg_10_4,
		career_selection_time_elapsed = arg_10_5,
		platform = arg_10_6,
		build = arg_10_7
	})
	arg_10_0._manager:register_event(var_10_0)
end

function TelemetryEvents.versus_objective_started(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_0:_create_event("versus_objective_started")

	var_11_0:set_data({
		match_id = arg_11_1,
		objective_id = arg_11_2,
		round_id = arg_11_3,
		objective_name = arg_11_4
	})
	arg_11_0._manager:register_event(var_11_0)
end

function TelemetryEvents.versus_objective_section_completed(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	local var_12_0 = arg_12_0:_create_event("versus_objective_section_completed")

	var_12_0:set_data({
		match_id = arg_12_1,
		objective_id = arg_12_2,
		round_id = arg_12_3,
		objective_name = arg_12_4,
		num_sections_completed = arg_12_5,
		total_num_sections = arg_12_6
	})
	arg_12_0._manager:register_event(var_12_0)
end

function TelemetryEvents.versus_activated_ability(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_0:_create_event("versus_activated_ability")

	var_13_0:set_data({
		match_id = arg_13_1,
		game_round = arg_13_2,
		player_id = arg_13_3,
		ability_name = arg_13_4
	})
	arg_13_0._manager:register_event(var_13_0)
end

function TelemetryEvents.weave_activated(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0:_create_event("weave_activated")

	var_14_0:set_data({
		wind = arg_14_1,
		tier = arg_14_2
	})
	arg_14_0._manager:register_event(var_14_0)
end

function TelemetryEvents.round_started(arg_15_0)
	local var_15_0 = arg_15_0:_create_event("round_started")

	arg_15_0._manager:register_event(var_15_0)
end

function TelemetryEvents.objective_captured(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0:_create_event("objective_captured")

	var_16_0:set_data({
		remaining_time = arg_16_1
	})
	arg_16_0._manager:register_event(var_16_0)
end

function TelemetryEvents.badge_gained(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0:_create_event("badge_gained")

	var_17_0:set_data({
		badge_name = arg_17_1
	})
	arg_17_0._manager:register_event(var_17_0)
end

function TelemetryEvents.node_climb(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0:_create_event("node_climb")

	var_18_0:set_data({
		breed_name = arg_18_1,
		node_position = arg_18_2
	})
	arg_18_0._manager:register_event(var_18_0)
end

function TelemetryEvents.left_ghost_mode(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0:_create_event("left_ghost_mode")

	var_19_0:set_data({
		breed_name = arg_19_1,
		position = arg_19_2
	})
	arg_19_0._manager:register_event(var_19_0)
end

function TelemetryEvents.game_ended(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0:_create_event("game_ended")

	var_20_0:set_data({
		end_reason = arg_20_1
	})
	arg_20_0._manager:register_event(var_20_0)

	arg_20_0._session.server = nil
end

function TelemetryEvents.client_session_id(arg_21_0, arg_21_1)
	arg_21_0._session.client = arg_21_1
end

function TelemetryEvents.server_session_id(arg_22_0, arg_22_1)
	arg_22_0._session.server = arg_22_1
end

function TelemetryEvents.ai_died(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0:_create_event("ai_died")

	var_23_0:set_data({
		id = arg_23_1,
		breed = arg_23_2,
		position = arg_23_3
	})
	arg_23_0._manager:register_event(var_23_0)
end

function TelemetryEvents.ai_spawned(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = arg_24_0:_create_event("ai_spawned")
	local var_24_1 = {}

	if arg_24_4 then
		for iter_24_0 = 1, #arg_24_4 do
			var_24_1[arg_24_4[iter_24_0].name] = true
		end
	end

	var_24_0:set_data({
		id = arg_24_1,
		breed = arg_24_2,
		position = arg_24_3,
		enhancements = var_24_1
	})
	arg_24_0._manager:register_event(var_24_0)
end

function TelemetryEvents.ai_despawned(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = arg_25_0:_create_event("ai_despawned")

	var_25_0:set_data({
		breed = arg_25_1,
		position = arg_25_2,
		reason = arg_25_3 or "unknown"
	})
	arg_25_0._manager:register_event(var_25_0)
end

local function var_0_1()
	local var_26_0
	local var_26_1 = Managers.party:get_local_player_party()

	if var_26_1 then
		local var_26_2 = var_26_1.occupied_slots

		var_26_0 = table.select_array(var_26_2, function(arg_27_0, arg_27_1)
			local var_27_0 = arg_27_1.peer_id
			local var_27_1 = arg_27_1.local_player_id

			if var_27_0 and var_27_1 then
				return PlayerUtils.unique_player_id(var_27_0, var_27_1)
			end
		end)
	end

	return var_26_0 or {}
end

function TelemetryEvents.matchmaking_search(arg_28_0, arg_28_1, arg_28_2)
	if arg_28_1 and arg_28_1.remote then
		return
	end

	local var_28_0 = arg_28_0:_create_event("matchmaking")

	var_28_0:set_data(table.merge({
		state = "search",
		party_peers = var_0_1()
	}, arg_28_2))
	arg_28_0._manager:register_event(var_28_0)
end

function TelemetryEvents.matchmaking_search_timeout(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if arg_29_1 and arg_29_1.remote then
		return
	end

	local var_29_0 = arg_29_0:_create_event("matchmaking")

	var_29_0:set_data(table.merge({
		state = "search_timeout",
		time_taken = arg_29_2,
		party_peers = var_0_1()
	}, arg_29_3))
	arg_29_0._manager:register_event(var_29_0)
end

function TelemetryEvents.matchmaking_cancelled(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	if arg_30_1 and arg_30_1.remote then
		return
	end

	local var_30_0 = arg_30_0:_create_event("matchmaking")

	var_30_0:set_data(table.merge({
		state = "cancelled",
		time_taken = arg_30_2,
		party_peers = var_0_1()
	}, arg_30_3))
	arg_30_0._manager:register_event(var_30_0)
end

function TelemetryEvents.matchmaking_hosting(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	if arg_31_1 and arg_31_1.remote then
		return
	end

	local var_31_0 = arg_31_0:_create_event("matchmaking")

	var_31_0:set_data(table.merge({
		state = "hosting",
		time_taken = arg_31_2,
		party_peers = var_0_1()
	}, arg_31_3))
	arg_31_0._manager:register_event(var_31_0)
end

function TelemetryEvents.matchmaking_starting_game(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if arg_32_1 and arg_32_1.remote then
		return
	end

	local var_32_0 = arg_32_0:_create_event("matchmaking")

	var_32_0:set_data(table.merge({
		state = "starting_game",
		time_taken = arg_32_2,
		party_peers = var_0_1()
	}, arg_32_3))
	arg_32_0._manager:register_event(var_32_0)
end

function TelemetryEvents.matchmaking_player_joined(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	if arg_33_1 and arg_33_1.remote then
		return
	end

	local var_33_0 = arg_33_0:_create_event("matchmaking")

	var_33_0:set_data(table.merge({
		state = "player_joined",
		time_taken = arg_33_2,
		party_peers = var_0_1()
	}, arg_33_3))
	arg_33_0._manager:register_event(var_33_0)
end

function TelemetryEvents.pickup_spawned(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = arg_34_0:_create_event("pickup_spawned")

	var_34_0:set_data({
		pickup_name = arg_34_1,
		spawn_type = arg_34_2,
		position = arg_34_3
	})
	arg_34_0._manager:register_event(var_34_0)
end

function TelemetryEvents.pickup_destroyed(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = arg_35_0:_create_event("pickup_destroyed")

	var_35_0:set_data({
		pickup_name = arg_35_1,
		spawn_type = arg_35_2,
		position = arg_35_3
	})
	arg_35_0._manager:register_event(var_35_0)
end

function TelemetryEvents.player_ammo_depleted(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	if arg_36_1 and arg_36_1.remote then
		return
	end

	local var_36_0 = TelemetryEvent:new(var_0_0, {
		id = arg_36_1:telemetry_id()
	}, "player_ammo_depleted", arg_36_0._session)

	var_36_0:set_data({
		weapon_name = arg_36_2,
		position = arg_36_3
	})
	arg_36_0._manager:register_event(var_36_0)
end

function TelemetryEvents.player_ammo_refilled(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	if arg_37_1 and arg_37_1.remote then
		return
	end

	local var_37_0 = TelemetryEvent:new(var_0_0, {
		id = arg_37_1:telemetry_id()
	}, "player_ammo_refilled", arg_37_0._session)

	var_37_0:set_data({
		weapon_name = arg_37_2,
		position = arg_37_3
	})
	arg_37_0._manager:register_event(var_37_0)
end

function TelemetryEvents.player_damaged(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	if arg_38_1 and arg_38_1.remote then
		return
	end

	local var_38_0 = TelemetryEvent:new(var_0_0, {
		id = arg_38_1:telemetry_id()
	}, "player_damaged", arg_38_0._session)

	var_38_0:set_data({
		damage_type = arg_38_2,
		damage_source = arg_38_3,
		damage_amount = arg_38_4,
		position = arg_38_5
	})
	arg_38_0._manager:register_event(var_38_0)
end

function TelemetryEvents.local_player_damaged_player(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	if arg_39_1 and arg_39_1.remote then
		return
	end

	local var_39_0 = TelemetryEvent:new(var_0_0, {
		id = arg_39_1:telemetry_id()
	}, "local_player_damaged_player", arg_39_0._session)

	var_39_0:set_data({
		target_breed = arg_39_2,
		damage_amount = arg_39_3,
		attacker_position = arg_39_4,
		target_position = arg_39_5
	})
	arg_39_0._manager:register_event(var_39_0)
end

function TelemetryEvents.player_died(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	if arg_40_1 and arg_40_1.remote then
		return
	end

	local var_40_0 = TelemetryEvent:new(var_0_0, {
		id = arg_40_1:telemetry_id()
	}, "player_died", arg_40_0._session)

	var_40_0:set_data({
		damage_type = arg_40_2,
		damage_source = arg_40_3,
		position = arg_40_4
	})
	arg_40_0._manager:register_event(var_40_0)
end

function TelemetryEvents.local_player_killed_player(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if arg_41_1 and arg_41_1.remote then
		return
	end

	local var_41_0 = TelemetryEvent:new(var_0_0, {
		id = arg_41_1:telemetry_id()
	}, "local_player_killed_player", arg_41_0._session)

	var_41_0:set_data({
		position = arg_41_2,
		target_position = arg_41_3
	})
	arg_41_0._manager:register_event(var_41_0)
end

function TelemetryEvents.player_killed_ai(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7)
	if arg_42_1 and arg_42_1.remote then
		return
	end

	local var_42_0 = TelemetryEvent:new(var_0_0, {
		id = arg_42_1:telemetry_id()
	}, "player_killed_ai", arg_42_0._session)

	var_42_0:set_data({
		player_position = arg_42_2,
		victim_position = arg_42_3,
		breed = arg_42_4,
		weapon_name = arg_42_5,
		damage_type = arg_42_6,
		hit_zone = arg_42_7
	})
	arg_42_0._manager:register_event(var_42_0)
end

function TelemetryEvents.player_knocked_down(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if arg_43_1 and arg_43_1.remote then
		return
	end

	local var_43_0 = TelemetryEvent:new(var_0_0, {
		id = arg_43_1:telemetry_id()
	}, "player_knocked_down", arg_43_0._session)

	var_43_0:set_data({
		damage_type = arg_43_2,
		position = arg_43_3
	})
	arg_43_0._manager:register_event(var_43_0)
end

function TelemetryEvents.player_pickup(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	if arg_44_1 and arg_44_1.remote then
		return
	end

	local var_44_0 = TelemetryEvent:new(var_0_0, {
		id = arg_44_1:telemetry_id()
	}, "player_pickup", arg_44_0._session)

	var_44_0:set_data({
		pickup_name = arg_44_2,
		pickup_spawn_type = arg_44_3,
		position = arg_44_4
	})
	arg_44_0._manager:register_event(var_44_0)
end

function TelemetryEvents.player_revived(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	if not arg_45_1.remote then
		local var_45_0 = TelemetryEvent:new(var_0_0, {
			id = arg_45_1:telemetry_id()
		}, "player_revived_another_player", arg_45_0._session)

		var_45_0:set_data({
			position = arg_45_3
		})
		arg_45_0._manager:register_event(var_45_0)
	end

	if not arg_45_2.remote then
		local var_45_1 = TelemetryEvent:new(var_0_0, {
			id = arg_45_2:telemetry_id()
		}, "player_revived", arg_45_0._session)

		var_45_1:set_data({
			position = arg_45_3
		})
		arg_45_0._manager:register_event(var_45_1)
	end
end

function TelemetryEvents.player_spawned(arg_46_0, arg_46_1)
	if arg_46_1 and arg_46_1.remote then
		return
	end

	local var_46_0 = ScriptUnit.extension(arg_46_1.player_unit, "career_system")
	local var_46_1 = ScriptUnit.extension(arg_46_1.player_unit, "inventory_system"):equipment()
	local var_46_2 = var_46_1.slots.slot_melee
	local var_46_3 = var_46_1.slots.slot_ranged
	local var_46_4 = CosmeticUtils.get_cosmetic_slot(arg_46_1, "slot_melee")
	local var_46_5 = CosmeticUtils.get_cosmetic_slot(arg_46_1, "slot_ranged")
	local var_46_6 = CosmeticUtils.get_cosmetic_slot(arg_46_1, "slot_hat")
	local var_46_7 = CosmeticUtils.get_cosmetic_slot(arg_46_1, "slot_skin")
	local var_46_8 = CosmeticUtils.get_cosmetic_slot(arg_46_1, "slot_frame")
	local var_46_9 = {}

	if ScriptUnit.has_extension(arg_46_1.player_unit, "talent_system") then
		var_46_9 = ScriptUnit.extension(arg_46_1.player_unit, "talent_system"):get_talent_names()
	end

	local var_46_10 = TelemetryEvent:new(var_0_0, {
		id = arg_46_1:telemetry_id()
	}, "player_spawned", arg_46_0._session)

	var_46_10:set_data({
		hero = arg_46_1:profile_display_name(),
		career = arg_46_1:career_name(),
		human = arg_46_1.local_player == true,
		power_level = var_46_0:get_career_power_level(),
		slot_melee = var_46_2 and var_46_2.item_data.name,
		slot_melee_skin = var_46_4 and var_46_4.skin_name or "default",
		slot_ranged = var_46_3 and var_46_3.item_data.name,
		slot_ranged_skin = var_46_5 and var_46_5.skin_name or "default",
		slot_hat = var_46_6 and var_46_6.item_name,
		slot_skin = var_46_7 and var_46_7.item_name,
		slot_frame = var_46_8 and var_46_8.item_name,
		talents = var_46_9
	})
	arg_46_0._manager:register_event(var_46_10)
end

function TelemetryEvents.player_despawned(arg_47_0, arg_47_1)
	if arg_47_1 and arg_47_1.remote then
		return
	end

	local var_47_0 = TelemetryEvent:new(var_0_0, {
		id = arg_47_1:telemetry_id()
	}, "player_despawned", arg_47_0._session)

	arg_47_0._manager:register_event(var_47_0)
end

function TelemetryEvents.player_used_item(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	if arg_48_1 and arg_48_1.remote then
		return
	end

	local var_48_0 = TelemetryEvent:new(var_0_0, {
		id = arg_48_1:telemetry_id()
	}, "player_used_item", arg_48_0._session)

	var_48_0:set_data({
		item_name = arg_48_2,
		position = arg_48_3
	})
	arg_48_0._manager:register_event(var_48_0)
end

function TelemetryEvents.ping_used(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	if arg_49_1 and arg_49_1.remote then
		return
	end

	local var_49_0 = TelemetryEvent:new(var_0_0, {
		id = arg_49_1:telemetry_id()
	}, "ping_used", arg_49_0._session)

	var_49_0:set_data({
		ping_type = arg_49_2,
		ping_target = arg_49_3,
		player_position = arg_49_4
	})
	arg_49_0._manager:register_event(var_49_0)
end

function TelemetryEvents.tech_settings(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	local var_50_0 = arg_50_0:_create_event("tech_settings")

	var_50_0:set_data({
		resolution = arg_50_1,
		graphics_quality = arg_50_2,
		screen_mode = arg_50_3,
		rendering_backend = arg_50_4
	})
	arg_50_0._manager:register_event(var_50_0)
end

function TelemetryEvents.tech_system(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_0:_create_event("tech_system")

	var_51_0:set_data({
		system_info = arg_51_1,
		adapter_index = arg_51_2
	})
	arg_51_0._manager:register_event(var_51_0)
end

function TelemetryEvents.ui_settings(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0:_create_event("ui_menu_layout")

	var_52_0:set_data({
		use_pc_menu_layout = arg_52_1
	})
	arg_52_0._manager:register_event(var_52_0)
end

function TelemetryEvents.vo_event_played(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	local var_53_0 = arg_53_0:_create_event("vo_event_played")

	var_53_0:set_data({
		category = arg_53_1,
		dialogue = arg_53_2,
		sound_event = arg_53_3,
		unit_name = arg_53_4
	})
	arg_53_0._manager:register_event(var_53_0)
end

function TelemetryEvents.terror_event_started(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0:_create_event("terror_event_started")

	var_54_0:set_data({
		event_name = arg_54_1
	})
	arg_54_0._manager:register_event(var_54_0)
end

function TelemetryEvents.level_progression(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0:_create_event("level_progression")

	var_55_0:set_data({
		percent = arg_55_1
	})
	arg_55_0._manager:register_event(var_55_0)
end

function TelemetryEvents.memory_statistics(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = arg_56_0:_create_event("memory_statistics")

	var_56_0:set_data({
		memory_tree = arg_56_1,
		arg_56_2,
		tag = arg_56_3
	})
	arg_56_0._manager:register_event(var_56_0)
end

function TelemetryEvents.player_stuck(arg_57_0, arg_57_1, arg_57_2)
	if arg_57_1 and arg_57_1.remote then
		return
	end

	local var_57_0 = TelemetryEvent:new(var_0_0, {
		id = arg_57_1:telemetry_id()
	}, "player_stuck", arg_57_0._session)

	var_57_0:set_data({
		level_key = arg_57_2,
		position = Unit.local_position(arg_57_1.player_unit, 0),
		rotation = Unit.local_rotation(arg_57_1.player_unit, 0)
	})
	arg_57_0._manager:register_event(var_57_0)
end

function TelemetryEvents.fps(arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = arg_58_0:_create_event("fps")

	var_58_0:set_data({
		avg_fps = arg_58_1,
		histogram = arg_58_2
	})
	arg_58_0._manager:register_event(var_58_0)
end

function TelemetryEvents.fps_at_point(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	local var_59_0 = arg_59_0:_create_event("fps_at_point")

	var_59_0:set_data({
		point_id = arg_59_1,
		cam_pos = arg_59_2,
		cam_rot = arg_59_3,
		avg_fps = arg_59_4
	})
	arg_59_0._manager:register_event(var_59_0)
end

function TelemetryEvents.end_of_game_rewards(arg_60_0, arg_60_1)
	local var_60_0 = arg_60_0:_create_event("end_of_game_rewards")

	var_60_0:set_data({
		rewards = arg_60_1
	})
	arg_60_0._manager:register_event(var_60_0)
end

function TelemetryEvents.magic_item_level_upgraded(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	local var_61_0 = arg_61_0:_create_event("magic_item_level_upgraded")

	var_61_0:set_data({
		item_id = arg_61_1,
		essence_cost = arg_61_2,
		new_magic_level = arg_61_3
	})
	arg_61_0._manager:register_event(var_61_0)
end

function TelemetryEvents.store_opened(arg_62_0)
	local var_62_0 = arg_62_0:_create_event("store_opened")

	arg_62_0._manager:register_event(var_62_0)
end

function TelemetryEvents.store_closed(arg_63_0)
	local var_63_0 = arg_63_0:_create_event("store_closed")

	arg_63_0._manager:register_event(var_63_0)
end

function TelemetryEvents.store_breadcrumbs_changed(arg_64_0, arg_64_1, arg_64_2)
	local var_64_0 = {}
	local var_64_1 = {}

	for iter_64_0, iter_64_1 in ipairs(arg_64_1) do
		var_64_0[#var_64_0 + 1] = iter_64_1.content.page_name
		var_64_1[#var_64_1 + 1] = iter_64_1.content.text
	end

	if arg_64_2 and var_64_0[#var_64_0] == "item_details" then
		var_64_0[#var_64_0] = arg_64_2.product_id
	end

	local var_64_2 = arg_64_0:_create_event("store_breadcrumbs_changed")

	var_64_2:set_data({
		path = var_64_0,
		path_localized = var_64_1
	})
	arg_64_0._manager:register_event(var_64_2)
end

function TelemetryEvents.store_product_purchased(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_1.product_item or arg_65_1.item
	local var_65_1 = "SM"
	local var_65_2 = var_65_0 and var_65_0.regular_prices
	local var_65_3 = var_65_0 and var_65_0.current_prices

	for iter_65_0, iter_65_1 in pairs(DLCSettings.store.currency_ui_settings) do
		local var_65_4 = var_65_2[iter_65_0]
		local var_65_5 = var_65_3[iter_65_0]

		if var_65_4 and var_65_5 then
			var_65_1 = iter_65_0

			break
		end
	end

	local var_65_6 = var_65_3[var_65_1]
	local var_65_7 = var_65_2[var_65_1]
	local var_65_8 = {
		id = arg_65_1.product_id,
		type = var_65_0.data.item_type,
		current_price = var_65_6 or var_65_7,
		regular_price = var_65_7,
		currency = var_65_1
	}

	arg_65_0:_store_product_purchased(var_65_8)
end

local function var_0_2(arg_66_0)
	local var_66_0 = tonumber(arg_66_0.item.steam_price)
	local var_66_1 = arg_66_0.item.steam_data
	local var_66_2 = var_66_1.discount_is_active and var_66_1.discount_prices or var_66_1.regular_prices or {}

	for iter_66_0, iter_66_1 in pairs(var_66_2) do
		if var_66_0 == iter_66_1 then
			return iter_66_0
		end
	end
end

local function var_0_3(arg_67_0)
	local var_67_0 = var_0_2(arg_67_0)

	return arg_67_0.item.steam_data.regular_prices[var_67_0]
end

function TelemetryEvents.steam_store_product_purchased(arg_68_0, arg_68_1)
	local var_68_0 = arg_68_1.item.steam_data
	local var_68_1 = {
		id = arg_68_1.item.id,
		type = arg_68_1.item.data.item_type,
		current_price = tonumber(arg_68_1.item.steam_price),
		currency = var_68_0 and var_0_2(arg_68_1) or "?"
	}

	if var_68_0 and var_68_0.discount_is_active then
		var_68_1.discounted = true
		var_68_1.regular_price = var_0_3(arg_68_1)
	end

	arg_68_0:_store_product_purchased(var_68_1)
end

function TelemetryEvents._store_product_purchased(arg_69_0, arg_69_1)
	local var_69_0 = arg_69_0:_create_event("store_product_purchased")

	var_69_0:set_data(arg_69_1)
	arg_69_0._manager:register_event(var_69_0)
end

function TelemetryEvents.store_rewards_claimed(arg_70_0, arg_70_1, arg_70_2)
	local var_70_0 = arg_70_0:_create_event("store_rewards_claimed")
	local var_70_1 = arg_70_1

	if var_70_1.event_type == "personal_time_strike" then
		var_70_1.reward_index = var_70_1.total_claims or 0
	else
		var_70_1.reward_index = #var_70_1.rewards + (arg_70_2 or 0)
	end

	var_70_0:set_data(var_70_1)
	arg_70_0._manager:register_event(var_70_0)
end

function TelemetryEvents.player_joined(arg_71_0, arg_71_1, arg_71_2)
	local var_71_0 = TelemetryEvent:new(var_0_0, {
		id = arg_71_1:telemetry_id()
	}, "player_joined", arg_71_0._session)

	var_71_0:set_data({
		num_human_players = arg_71_2
	})
	arg_71_0._manager:register_event(var_71_0)
end

function TelemetryEvents.player_left(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = TelemetryEvent:new(var_0_0, {
		id = arg_72_1:telemetry_id()
	}, "player_left", arg_72_0._session)

	var_72_0:set_data({
		num_human_players = arg_72_2
	})
	arg_72_0._manager:register_event(var_72_0)
end

function TelemetryEvents.deus_run_started(arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5, arg_73_6, arg_73_7, arg_73_8)
	local var_73_0 = arg_73_0:_create_event("deus_run_started")

	var_73_0:set_data({
		run_id = arg_73_1,
		journey_name = arg_73_2,
		run_seed = arg_73_3,
		dominant_god = arg_73_4,
		difficulty = arg_73_5,
		is_weekly_expedition = arg_73_6,
		event_mutators = arg_73_7,
		event_boons = arg_73_8
	})
	arg_73_0._manager:register_event(var_73_0)
end

function TelemetryEvents.deus_run_ended(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0:_create_event("deus_run_ended")

	var_74_0:set_data(arg_74_1)
	arg_74_0._manager:register_event(var_74_0)
end

function TelemetryEvents.deus_level_started(arg_75_0, arg_75_1)
	local var_75_0 = arg_75_0:_create_event("deus_level_started")

	var_75_0:set_data(arg_75_1)
	arg_75_0._manager:register_event(var_75_0)
end

function TelemetryEvents.deus_level_ended(arg_76_0, arg_76_1)
	local var_76_0 = arg_76_0:_create_event("deus_level_ended")

	var_76_0:set_data(arg_76_1)
	arg_76_0._manager:register_event(var_76_0)
end

function TelemetryEvents.deus_coins_changed(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
	local var_77_0 = TelemetryEvent:new(var_0_0, {
		id = arg_77_1
	}, "deus_coins_changed", arg_77_0._session)

	var_77_0:set_data({
		run_id = arg_77_2,
		player_id = arg_77_1,
		coin_delta = arg_77_3,
		coin_description = arg_77_4
	})
	arg_77_0._manager:register_event(var_77_0)
end

function TelemetryEvents.deus_altar_passed(arg_78_0, arg_78_1)
	local var_78_0 = arg_78_0:_create_event("deus_altar_passed")

	var_78_0:set_data(arg_78_1)
	arg_78_0._manager:register_event(var_78_0)
end

function TelemetryEvents.cursed_chest_passed(arg_79_0, arg_79_1)
	local var_79_0 = arg_79_0:_create_event("cursed_chest_passed")

	var_79_0:set_data(arg_79_1)
	arg_79_0._manager:register_event(var_79_0)
end

function TelemetryEvents.store_node_traversed(arg_80_0, arg_80_1)
	local var_80_0 = arg_80_0:_create_event("store_node_traversed")

	var_80_0:set_data(arg_80_1)
	arg_80_0._manager:register_event(var_80_0)
end

function TelemetryEvents.network_ping(arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5, arg_81_6, arg_81_7, arg_81_8, arg_81_9)
	local var_81_0 = arg_81_0:_create_event("network_ping")

	var_81_0:set_data({
		avg = arg_81_1,
		std_dev = arg_81_2,
		p99 = arg_81_3,
		p95 = arg_81_4,
		p90 = arg_81_5,
		p75 = arg_81_6,
		p50 = arg_81_7,
		p25 = arg_81_8,
		observations = arg_81_9
	})
	arg_81_0._manager:register_event(var_81_0)
end

function TelemetryEvents.memory_usage(arg_82_0, arg_82_1, arg_82_2)
	local var_82_0 = arg_82_0:_create_event("memory_usage")

	var_82_0:set_data({
		index = arg_82_1,
		memory_usage = arg_82_2
	})
	arg_82_0._manager:register_event(var_82_0)
end

function TelemetryEvents.chat_message(arg_83_0, arg_83_1)
	local var_83_0 = Managers.player:local_player()

	if not var_83_0 then
		return
	end

	local var_83_1 = TelemetryEvent:new(var_0_0, {
		id = var_83_0:telemetry_id()
	}, "chat_message", arg_83_0._session)

	var_83_1:set_data({
		message_length = arg_83_1 and #arg_83_1 or 0
	})
	arg_83_0._manager:register_event(var_83_1)
end

function TelemetryEvents.twitch_mode_activated(arg_84_0)
	local var_84_0 = arg_84_0:_create_event("twitch_mode_activated")

	arg_84_0._manager:register_event(var_84_0)
end

function TelemetryEvents.twitch_poll_completed(arg_85_0, arg_85_1)
	local var_85_0 = arg_85_0:_create_event("twitch_poll_completed")

	var_85_0:set_data({
		type = arg_85_1.vote_type,
		templates = arg_85_1.vote_templates,
		winning_template = arg_85_1.winning_template_name,
		votes_cast = arg_85_1.options
	})
	arg_85_0._manager:register_event(var_85_0)
end

function TelemetryEvents.breed_position_desync(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
	local var_86_0 = arg_86_0:_create_event("breed_position_desync")

	var_86_0:set_data({
		source_position = arg_86_1,
		destination_position = arg_86_2,
		distance_sq = arg_86_3,
		breed = arg_86_4
	})
	arg_86_0._manager:register_event(var_86_0)
end

function TelemetryEvents.heartbeat(arg_87_0)
	local var_87_0 = arg_87_0:_create_event("heartbeat")

	arg_87_0._manager:register_event(var_87_0)
end

function TelemetryEvents.player_authenticated(arg_88_0, arg_88_1)
	arg_88_0._subject.id = arg_88_1

	local var_88_0 = arg_88_0:_create_event("player_authenticated")

	arg_88_0._manager:register_event(var_88_0)
end

function TelemetryEvents._create_event(arg_89_0, arg_89_1)
	return TelemetryEvent:new(var_0_0, arg_89_0._subject, arg_89_1, arg_89_0._session)
end

function TelemetryEvents.necromancer_used_command_item(arg_90_0, arg_90_1, arg_90_2)
	if arg_90_1 and not arg_90_1.local_player then
		return
	end

	local var_90_0 = TelemetryEvent:new(var_0_0, {
		id = arg_90_1:telemetry_id()
	}, "necromancer_used_command_item", arg_90_0._session)

	var_90_0:set_data({
		command_name = arg_90_2
	})
	arg_90_0._manager:register_event(var_90_0)
end

function TelemetryEvents.geheimnisnacht_hard_mode_toggled(arg_91_0, arg_91_1)
	local var_91_0 = arg_91_0:_create_event("geheimnisnacht_hard_mode_toggled")
	local var_91_1 = arg_91_1 and "activated" or "deactivated"

	var_91_0:set_data({
		state = var_91_1
	})
	arg_91_0._manager:register_event(var_91_0)
end

function TelemetryEvents.loadout_created(arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = arg_92_0:_create_event("loadout_created")

	var_92_0:set_data({
		num_loadouts = arg_92_1,
		max_num_loadouts = arg_92_2
	})
	arg_92_0._manager:register_event(var_92_0)
end

function TelemetryEvents.loadout_deleted(arg_93_0, arg_93_1, arg_93_2)
	local var_93_0 = arg_93_0:_create_event("loadout_deleted")

	var_93_0:set_data({
		num_loadouts = arg_93_1,
		max_num_loadouts = arg_93_2
	})
	arg_93_0._manager:register_event(var_93_0)
end

function TelemetryEvents.loadout_equipped(arg_94_0)
	local var_94_0 = arg_94_0:_create_event("loadout_equipped")

	arg_94_0._manager:register_event(var_94_0)
end

function TelemetryEvents.default_loadout_equipped(arg_95_0)
	local var_95_0 = arg_95_0:_create_event("default_loadout_equipped")

	arg_95_0._manager:register_event(var_95_0)
end

function TelemetryEvents.start_versus_experience(arg_96_0, arg_96_1, arg_96_2)
	local var_96_0 = arg_96_0:_create_event("start_versus_experience")

	var_96_0:set_data({
		start_experience = arg_96_2,
		start_level = arg_96_1
	})
	arg_96_0._manager:register_event(var_96_0)
end

function TelemetryEvents.versus_experience_gained(arg_97_0, arg_97_1)
	local var_97_0 = arg_97_0:_create_event("versus_experience_gained")

	var_97_0:set_data({
		versus_experience_gained = arg_97_1
	})
	arg_97_0._manager:register_event(var_97_0)
end

function TelemetryEvents.versus_level_gained(arg_98_0, arg_98_1, arg_98_2)
	local var_98_0 = arg_98_0:_create_event("versus_level_gained")

	var_98_0:set_data({
		old_versus_level = arg_98_1,
		new_versus_level = arg_98_2
	})
	arg_98_0._manager:register_event(var_98_0)
end

function TelemetryEvents.versus_currency_gained(arg_99_0, arg_99_1)
	local var_99_0 = arg_99_0:_create_event("versus_currency_gained")

	var_99_0:set_data({
		currency_gained = arg_99_1
	})
	arg_99_0._manager:register_event(var_99_0)
end
