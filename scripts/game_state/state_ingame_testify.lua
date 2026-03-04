-- chunkname: @scripts/game_state/state_ingame_testify.lua

require("scripts/settings/dlcs/morris/deus_power_up_testify")

local function var_0_0(arg_1_0)
	local var_1_0 = ScriptUnit.extension(arg_1_0, "character_state_machine_system").state_machine.state_current.name

	return var_1_0 == "knocked_down" or var_1_0 == "pounced_down" or var_1_0 == "grabbed_by_pack_master" or var_1_0 == "grabbed_by_tentacle"
end

local function var_0_1(arg_2_0, arg_2_1)
	if not arg_2_0 then
		return false
	end

	if not Unit.alive(arg_2_0) then
		Testify:_print("Unit %s not alive, teleportation cancelled", Unit.debug_name(arg_2_0))

		return false
	end

	if not DEDICATED_SERVER and var_0_0(arg_2_0) then
		Testify:_print("Unit %s in blocking state, teleportation cancelled", Unit.debug_name(arg_2_0))

		return false
	end

	Testify:_print("Teleporting player to %s", tostring(arg_2_1))
	Mover.set_position(Unit.mover(arg_2_0), arg_2_1)

	return true
end

local function var_0_2(arg_3_0)
	if arg_3_0 == nil then
		return false
	end

	ScriptUnit.extension(arg_3_0, "health_system").is_invincible = true

	return true
end

local function var_0_3()
	return os.time()
end

return {
	load_level = function (arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1.level_key
		local var_5_1 = arg_5_1.environment_variation_id or 0

		Managers.mechanism:debug_load_level(var_5_0, var_5_1)
	end,
	wait_for_state_ingame_reached = function ()
		return
	end,
	get_level_weather_variations = function (arg_7_0, arg_7_1)
		return LevelSettings[arg_7_1].environment_variations
	end,
	wait_for_player_to_spawn = function ()
		local var_8_0 = Managers.player:local_player()

		if not Unit.alive(var_8_0.player_unit) then
			return Testify.RETRY
		end
	end,
	wait_for_bots_to_spawn = function ()
		for iter_9_0, iter_9_1 in pairs(Managers.player:bots()) do
			if not Unit.alive(iter_9_1.player_unit) then
				return Testify.RETRY
			end
		end
	end,
	request_profiles = function (arg_10_0, arg_10_1)
		local var_10_0 = {}

		for iter_10_0, iter_10_1 in pairs(SPProfiles) do
			if iter_10_1.affiliation == arg_10_1 then
				local var_10_1 = {}

				for iter_10_2, iter_10_3 in ipairs(iter_10_1.careers) do
					var_10_1[iter_10_2] = iter_10_3.display_name
				end

				var_10_0[#var_10_0 + 1] = {
					name = iter_10_1.display_name,
					careers = var_10_1
				}
			end
		end

		return var_10_0
	end,
	set_player_profile = function (arg_11_0, arg_11_1)
		Managers.state.network:request_profile(1, arg_11_1.profile_name, arg_11_1.career_name, true)

		return Testify.RETRY
	end,
	set_bot_profile = function (arg_12_0, arg_12_1)
		script_data.allow_same_bots = true
		script_data.wanted_bot_profile = arg_12_1.profile_name

		local var_12_0 = FindProfileIndex(arg_12_1.profile_name)
		local var_12_1 = career_index_from_name(var_12_0, arg_12_1.career_name)

		script_data.wanted_bot_career_index = var_12_1
	end,
	enable_bots = function ()
		script_data.ai_bots_disabled = false
	end,
	disable_bots = function ()
		script_data.ai_bots_disabled = true
	end,
	add_all_hats = function ()
		for iter_15_0, iter_15_1 in ipairs(DebugScreen.console_settings) do
			if iter_15_1.title == "Add All Hat Items" then
				iter_15_1.func()

				return
			end
		end
	end,
	add_all_weapon_skins = function ()
		for iter_16_0, iter_16_1 in ipairs(DebugScreen.console_settings) do
			if iter_16_1.title == "Add All Weapon Skins" then
				iter_16_1.func()

				return
			end
		end
	end,
	get_available_deus_talent_power_up_tests = function ()
		local var_17_0 = {}

		for iter_17_0, iter_17_1 in pairs(DeusPowerUps) do
			for iter_17_2, iter_17_3 in pairs(iter_17_1) do
				local var_17_1 = DeusPowerUpTests[iter_17_2] or DeusPowerUpTests.default

				if iter_17_3.talent then
					var_17_0[iter_17_0] = var_17_0[iter_17_0] or {}
					var_17_0[iter_17_0][iter_17_2] = var_17_1
				end
			end
		end

		return var_17_0
	end,
	get_available_deus_generic_power_up_tests = function ()
		local var_18_0 = {}

		for iter_18_0, iter_18_1 in pairs(DeusPowerUps) do
			for iter_18_2, iter_18_3 in pairs(iter_18_1) do
				local var_18_1 = DeusPowerUpTests[iter_18_2] or DeusPowerUpTests.default

				if not iter_18_3.talent then
					var_18_0[iter_18_0] = var_18_0[iter_18_0] or {}
					var_18_0[iter_18_0][iter_18_2] = var_18_1
				end
			end
		end

		return var_18_0
	end,
	activate_bots_deus_power_up = function (arg_19_0, arg_19_1)
		local var_19_0 = arg_19_1.power_up_name
		local var_19_1 = arg_19_1.rarity
		local var_19_2 = DeusPowerUpUtils.generate_specific_power_up(var_19_0, var_19_1)
		local var_19_3 = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local var_19_4 = Managers.state.entity:system("buff_system")
		local var_19_5 = Managers.backend:get_talents_interface()
		local var_19_6 = Managers.backend:get_interface("deus")

		for iter_19_0, iter_19_1 in pairs(Managers.player:bots()) do
			local var_19_7 = iter_19_1:local_player_id()

			var_19_3:add_power_ups({
				var_19_2
			}, var_19_7, false)
		end
	end,
	activate_player_deus_power_up = function (arg_20_0, arg_20_1)
		local var_20_0 = arg_20_1.power_up_name
		local var_20_1 = arg_20_1.rarity
		local var_20_2 = DeusPowerUpUtils.generate_specific_power_up(var_20_0, var_20_1)
		local var_20_3 = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local var_20_4 = Managers.player:local_player():local_player_id()

		var_20_3:add_power_ups({
			var_20_2
		}, var_20_4, false)
	end,
	reset_deus_power_ups = function ()
		local var_21_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local var_21_1 = var_21_0:get_own_peer_id()
		local var_21_2 = Managers.player:human_and_bot_players()

		for iter_21_0, iter_21_1 in pairs(var_21_2) do
			local var_21_3 = iter_21_1:local_player_id()
			local var_21_4 = iter_21_1:profile_index()
			local var_21_5 = iter_21_1:career_index()

			var_21_0:reset_power_ups(var_21_1, var_21_3, var_21_4, var_21_5)
		end
	end,
	set_script_data = function (arg_22_0, arg_22_1)
		table.merge(script_data, arg_22_1)
	end,
	wait_for_inventory_to_be_loaded = function ()
		local var_23_0 = Managers.player:local_player()

		if ScriptUnit.extension(var_23_0.player_unit, "inventory_system"):resyncing_loadout() then
			return Testify.RETRY
		end
	end,
	wait_for_players_inventory_ready = function ()
		for iter_24_0, iter_24_1 in pairs(Managers.player:players()) do
			local var_24_0 = ScriptUnit.extension(iter_24_1.player_unit, "inventory_system")

			if not var_24_0 or not var_24_0:can_wield() then
				return Testify.RETRY
			end
		end
	end,
	player_wield_weapon = function (arg_25_0, arg_25_1)
		local var_25_0 = Managers.player:local_player()

		ScriptUnit.extension(var_25_0.player_unit, "inventory_system"):testify_wield_weapon(arg_25_1)
	end,
	bot_wield_weapon = function (arg_26_0, arg_26_1)
		for iter_26_0, iter_26_1 in pairs(Managers.player:bots()) do
			ScriptUnit.extension(iter_26_1.player_unit, "inventory_system"):testify_wield_weapon(arg_26_1)
		end
	end,
	set_game_mode_to_weave = function (arg_27_0)
		if Managers.state.game_mode:game_mode_key() ~= "weave" then
			Managers.mechanism:choose_next_state("weave")
			Managers.mechanism:progress_state()
		end
	end,
	load_weave = function (arg_28_0, arg_28_1)
		local var_28_0 = WeaveSettings.templates[arg_28_1].objectives[1].level_id
		local var_28_1 = Managers.level_transition_handler

		var_28_1:set_next_level(var_28_0)
		var_28_1:promote_next_level_data()
	end,
	make_game_ready_for_next_weave = function (arg_29_0)
		if not arg_29_0.is_in_inn then
			return Testify.RETRY
		end
	end,
	set_camera_to_observe_first_bot = function ()
		local var_30_0 = Managers.player:bots()

		if Unit.alive(var_30_0[1].player_unit) then
			local var_30_1 = Managers.player:local_player()

			CharacterStateHelper.change_camera_state(var_30_1, "observer")
		end

		return Testify.RETRY
	end,
	update_camera_to_follow_first_bot_rotation = function ()
		local var_31_0 = Managers.player:local_player().camera_follow_unit
		local var_31_1 = Managers.player:bots()[1].player_unit

		if var_31_1 then
			local var_31_2 = Unit.local_rotation(var_31_1, 0)

			Unit.set_local_rotation(var_31_0, 0, var_31_2)
		end
	end,
	teleport_player_to_main_path_point = function (arg_32_0, arg_32_1)
		local var_32_0 = Managers.player:local_player().player_unit
		local var_32_1 = MainPathUtils.point_on_mainpath(nil, arg_32_1)

		var_0_1(var_32_0, var_32_1 + Vector3(0, 0, 1))
	end,
	closest_travel_distance_to_player = function ()
		local var_33_0 = Managers.player:local_player().player_unit
		local var_33_1, var_33_2 = MainPathUtils.closest_pos_at_main_path(nil, POSITION_LOOKUP[var_33_0])

		return var_33_2
	end,
	teleport_player_to_position = function (arg_34_0, arg_34_1)
		local var_34_0 = Managers.player:local_player().player_unit

		var_0_1(var_34_0, arg_34_1:unbox() + Vector3(0, 0, 1))
	end,
	teleport_all_players_to_position = function (arg_35_0, arg_35_1)
		local var_35_0 = Managers.state.network

		for iter_35_0, iter_35_1 in pairs(Managers.player:players()) do
			if iter_35_1.player_unit then
				local var_35_1 = ScriptUnit.extension(iter_35_1.player_unit, "locomotion_system")
				local var_35_2 = var_35_1:current_rotation()

				if iter_35_1.remote then
					local var_35_3 = var_35_0:unit_game_object_id(iter_35_1.player_unit)
					local var_35_4 = Quaternion.yaw(var_35_2)

					var_35_0.network_transmit:send_rpc_clients("rpc_teleport_unit_with_yaw_rotation", var_35_3, arg_35_1:unbox() + Vector3(0, 0, 1), var_35_4)
				else
					var_35_1:teleport_to(arg_35_1:unbox() + Vector3(0, 0, 1), var_35_2)
				end
			end
		end
	end,
	teleport_player_randomly_on_main_path = function ()
		local var_36_0 = Managers.player:local_player().player_unit
		local var_36_1 = math.random(1, EngineOptimized.main_path_total_length())
		local var_36_2 = MainPathUtils.point_on_mainpath(nil, var_36_1)

		var_0_1(var_36_0, var_36_2 + Vector3(0, 0, 1))
	end,
	set_player_unit_not_visible = function ()
		local var_37_0 = Managers.player:local_player()

		if Unit.alive(var_37_0.player_unit) then
			return Testify.RETRY
		end
	end,
	teleport_bots_forward_on_main_path_if_blocked = function (arg_38_0, arg_38_1)
		local var_38_0 = arg_38_1.bots_stuck_data
		local var_38_1 = arg_38_1.main_path_point
		local var_38_2 = arg_38_1.bots_blocked_time_before_teleportation or 6

		for iter_38_0, iter_38_1 in pairs(Managers.player:bots()) do
			local var_38_3 = iter_38_1.player_unit

			if not Unit.alive(var_38_3) or var_0_0(var_38_3) then
				Testify:_print("Bot unit has been removed or is in a blocking state. Cannot teleport it.")
			else
				local var_38_4 = var_38_0[iter_38_0]
				local var_38_5 = POSITION_LOOKUP[var_38_3]
				local var_38_6 = var_38_4[1]:unbox()

				if Vector3.distance_squared(var_38_6, var_38_5) < (arg_38_1.bots_blocked_distance or 2) then
					local var_38_7 = var_38_4[2]

					if var_38_2 < var_0_3() - var_38_7 then
						local var_38_8 = MainPathUtils.point_on_mainpath(nil, var_38_1)

						if var_38_8 then
							var_38_8.z = var_38_8.z + 1

							Testify:_print("The bot %s has almost not moved since %ss. Teleporting bot to x:%s, y:%s, z:%s", iter_38_0, var_38_2, var_38_8.x, var_38_8.y, var_38_8.z)
							var_0_1(var_38_3, var_38_8)
							Mover.set_position(Unit.mover(var_38_3), var_38_8)
						end
					end
				else
					var_38_4[1]:store(var_38_5)

					var_38_4[2] = var_0_3()
				end
			end
		end
	end,
	are_bots_blocked = function (arg_39_0, arg_39_1)
		local var_39_0 = arg_39_1.bots_stuck_data
		local var_39_1 = arg_39_1.bots_blocked_time_before_teleportation or 6

		for iter_39_0, iter_39_1 in pairs(Managers.player:bots()) do
			local var_39_2 = iter_39_1.player_unit

			if var_39_2 then
				local var_39_3 = var_39_0[iter_39_0]
				local var_39_4 = Mover.position(Unit.mover(var_39_2))

				if Vector3.distance_squared(var_39_3[1]:unbox(), var_39_4) < 2 then
					if var_39_1 < var_0_3() - var_39_3[2] then
						var_39_3[1]:store(Vector3(-999, -999, -999))

						var_39_3[2] = var_0_3()

						return true
					end
				else
					var_39_3[1]:store(var_39_4)

					var_39_3[2] = var_0_3()
				end
			end
		end

		return false
	end,
	make_players_invicible = function ()
		for iter_40_0, iter_40_1 in pairs(Managers.player:players()) do
			var_0_2(iter_40_1.player_unit)
		end
	end,
	make_player_and_two_bots_invicible = function ()
		local var_41_0 = Managers.player:bots()

		var_0_2(var_41_0[1].player_unit)
		var_0_2(var_41_0[2].player_unit)
		var_0_2(Managers.player:local_player().player_unit)
	end,
	post_telemetry_events = function ()
		Managers.telemetry:post_batch()
	end,
	get_main_path_points = function (arg_43_0, arg_43_1)
		local var_43_0 = EngineOptimized.main_path_total_length()
		local var_43_1 = {}

		for iter_43_0 = 1, arg_43_1 do
			var_43_1[iter_43_0] = math.floor(var_43_0 * iter_43_0 / arg_43_1)
		end

		return var_43_1
	end,
	set_difficulty = function (arg_44_0, arg_44_1)
		local var_44_0 = 0

		Managers.state.difficulty:set_difficulty(arg_44_1, var_44_0)
	end,
	get_player_current_position = function ()
		local var_45_0, var_45_1 = next(Managers.player._human_players)

		return POSITION_LOOKUP[var_45_1.player_unit]
	end,
	is_unit_alive = function (arg_46_0, arg_46_1)
		return HEALTH_ALIVE[arg_46_1] or false
	end,
	get_unit_health_values = function (arg_47_0, arg_47_1)
		local var_47_0
		local var_47_1 = ScriptUnit.has_extension(arg_47_1, "health_system")

		if var_47_1 then
			var_47_0 = {
				current_health = var_47_1:current_health(),
				max_health = var_47_1:get_max_health()
			}
		end

		return var_47_0
	end,
	kill_unit = function (arg_48_0, arg_48_1)
		local var_48_0 = "forced"
		local var_48_1 = Vector3(0, 0, -1)

		AiUtils.kill_unit(arg_48_1, nil, nil, var_48_0, var_48_1)
	end,
	add_buffs_to_heroes = function (arg_49_0, arg_49_1)
		local var_49_0 = Managers.state.side:get_side_from_name("heroes")

		for iter_49_0, iter_49_1 in pairs(var_49_0.PLAYER_AND_BOT_UNITS) do
			for iter_49_2, iter_49_3 in ipairs(arg_49_1) do
				ScriptUnit.extension(iter_49_1, "buff_system"):add_buff(iter_49_3)
			end
		end
	end,
	fail_test = function (arg_50_0, arg_50_1)
		assert(false, arg_50_1)
	end
}
