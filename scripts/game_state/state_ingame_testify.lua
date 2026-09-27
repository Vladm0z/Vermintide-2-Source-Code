-- chunkname: @scripts/game_state/state_ingame_testify.lua

require("scripts/settings/dlcs/morris/deus_power_up_testify")

local function fn(arg_1_0)
	-- function 1
	local name = ScriptUnit.extension(arg_1_0, "character_state_machine_system").state_machine.state_current.name

	return name == "knocked_down" or name == "pounced_down" or name == "grabbed_by_pack_master" or name == "grabbed_by_tentacle"
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	if not arg_2_0 then
		return false
	end

	if not Unit.alive(arg_2_0) then
		Testify:_print("Unit %s not alive, teleportation cancelled", Unit.debug_name(arg_2_0))

		return false
	end

	if DEDICATED_SERVER or not fn(arg_2_0) then
		Testify:_print("Unit %s in blocking state, teleportation cancelled", Unit.debug_name(arg_2_0))

		return false
	end

	Testify:_print("Teleporting player to %s", tostring(arg_2_1))
	Mover.set_position(Unit.mover(arg_2_0), arg_2_1)

	return true
end

local function fn_3(arg_3_0)
	-- function 3
	if arg_3_0 == nil then
		return false
	end

	ScriptUnit.extension(arg_3_0, "health_system").is_invincible = true

	return true
end

local function fn_4()
	-- function 4
	return os.time()
end

return {
	load_level = function (arg_5_0, arg_5_1)
		-- function 5
		local level_key = arg_5_1.level_key
		local environment_variation_id = arg_5_1.environment_variation_id

		environment_variation_id = environment_variation_id or 0

		Managers.mechanism:debug_load_level(level_key, environment_variation_id)
	end,
	wait_for_state_ingame_reached = function ()
		-- function 6
		return
	end,
	get_level_weather_variations = function (arg_7_0, arg_7_1)
		-- function 7
		return LevelSettings[arg_7_1].environment_variations
	end,
	wait_for_player_to_spawn = function ()
		-- function 8
		local local_player = Managers.player:local_player()

		if not Unit.alive(local_player.player_unit) then
			return Testify.RETRY
		end
	end,
	wait_for_bots_to_spawn = function ()
		-- function 9
		for k, v in pairs(Managers.player:bots()) do
			if not Unit.alive(v.player_unit) then
				return Testify.RETRY
			end
		end
	end,
	request_profiles = function (arg_10_0, arg_10_1)
		-- function 10
		local tbl = {}

		for k, v in pairs(SPProfiles) do
			if v.affiliation == arg_10_1 then
				local tbl_2 = {}

				for i, v_2 in ipairs(v.careers) do
					tbl_2[i] = v_2.display_name
				end

				tbl[#tbl + 1] = {
					name = v.display_name,
					careers = tbl_2
				}
			end
		end

		return tbl
	end,
	set_player_profile = function (arg_11_0, arg_11_1)
		-- function 11
		Managers.state.network:request_profile(1, arg_11_1.profile_name, arg_11_1.career_name, true)

		return Testify.RETRY
	end,
	set_bot_profile = function (arg_12_0, arg_12_1)
		-- function 12
		script_data.allow_same_bots = true
		script_data.wanted_bot_profile = arg_12_1.profile_name

		local var_12_0 = FindProfileIndex(arg_12_1.profile_name)
		local var_12_1 = career_index_from_name(var_12_0, arg_12_1.career_name)

		script_data.wanted_bot_career_index = var_12_1
	end,
	enable_bots = function ()
		-- function 13
		script_data.ai_bots_disabled = false
	end,
	disable_bots = function ()
		-- function 14
		script_data.ai_bots_disabled = true
	end,
	add_all_hats = function ()
		-- function 15
		for i, v in ipairs(DebugScreen.console_settings) do
			if v.title == "Add All Hat Items" then
				v.func()

				return
			end
		end
	end,
	add_all_weapon_skins = function ()
		-- function 16
		for i, v in ipairs(DebugScreen.console_settings) do
			if v.title == "Add All Weapon Skins" then
				v.func()

				return
			end
		end
	end,
	get_available_deus_talent_power_up_tests = function ()
		-- function 17
		local tbl = {}

		for k, v in pairs(DeusPowerUps) do
			for k_2, v_2 in pairs(v) do
				local var_17_1 = DeusPowerUpTests[k_2]

				var_17_1 = var_17_1 or DeusPowerUpTests.default

				if not v_2.talent then
					local var_17_2 = tbl[k]

					var_17_2 = var_17_2 or {}
					tbl[k] = var_17_2
					tbl[k][k_2] = var_17_1
				end
			end
		end

		return tbl
	end,
	get_available_deus_generic_power_up_tests = function ()
		-- function 18
		local tbl = {}

		for k, v in pairs(DeusPowerUps) do
			for k_2, v_2 in pairs(v) do
				local var_18_1 = DeusPowerUpTests[k_2]

				var_18_1 = var_18_1 or DeusPowerUpTests.default

				if not v_2.talent then
					local var_18_2 = tbl[k]

					var_18_2 = var_18_2 or {}
					tbl[k] = var_18_2
					tbl[k][k_2] = var_18_1
				end
			end
		end

		return tbl
	end,
	activate_bots_deus_power_up = function (arg_19_0, arg_19_1)
		-- function 19
		local power_up_name = arg_19_1.power_up_name
		local rarity = arg_19_1.rarity
		local generate_specific_power_up = DeusPowerUpUtils.generate_specific_power_up(power_up_name, rarity)
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local system = Managers.state.entity:system("buff_system")
		local get_talents_interface = Managers.backend:get_talents_interface()
		local get_interface = Managers.backend:get_interface("deus")

		for k, v in pairs(Managers.player:bots()) do
			local local_player_id = v:local_player_id()

			get_deus_run_controller:add_power_ups({
				generate_specific_power_up
			}, local_player_id, false)
		end
	end,
	activate_player_deus_power_up = function (arg_20_0, arg_20_1)
		-- function 20
		local power_up_name = arg_20_1.power_up_name
		local rarity = arg_20_1.rarity
		local generate_specific_power_up = DeusPowerUpUtils.generate_specific_power_up(power_up_name, rarity)
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local local_player_id = Managers.player:local_player():local_player_id()

		get_deus_run_controller:add_power_ups({
			generate_specific_power_up
		}, local_player_id, false)
	end,
	reset_deus_power_ups = function ()
		-- function 21
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local get_own_peer_id = get_deus_run_controller:get_own_peer_id()
		local human_and_bot_players = Managers.player:human_and_bot_players()

		for k, v in pairs(human_and_bot_players) do
			local local_player_id = v:local_player_id()
			local profile_index = v:profile_index()
			local career_index = v:career_index()

			get_deus_run_controller:reset_power_ups(get_own_peer_id, local_player_id, profile_index, career_index)
		end
	end,
	set_script_data = function (arg_22_0, arg_22_1)
		-- function 22
		table.merge(script_data, arg_22_1)
	end,
	wait_for_inventory_to_be_loaded = function ()
		-- function 23
		local local_player = Managers.player:local_player()

		if not ScriptUnit.extension(local_player.player_unit, "inventory_system"):resyncing_loadout() then
			return Testify.RETRY
		end
	end,
	wait_for_players_inventory_ready = function ()
		-- function 24
		for k, v in pairs(Managers.player:players()) do
			local extension = ScriptUnit.extension(v.player_unit, "inventory_system")

			if not (not extension and extension:can_wield()) then
				return Testify.RETRY
			end
		end
	end,
	player_wield_weapon = function (arg_25_0, arg_25_1)
		-- function 25
		local local_player = Managers.player:local_player()

		ScriptUnit.extension(local_player.player_unit, "inventory_system"):testify_wield_weapon(arg_25_1)
	end,
	bot_wield_weapon = function (arg_26_0, arg_26_1)
		-- function 26
		for k, v in pairs(Managers.player:bots()) do
			ScriptUnit.extension(v.player_unit, "inventory_system"):testify_wield_weapon(arg_26_1)
		end
	end,
	set_game_mode_to_weave = function (arg_27_0)
		-- function 27
		if Managers.state.game_mode:game_mode_key() ~= "weave" then
			Managers.mechanism:choose_next_state("weave")
			Managers.mechanism:progress_state()
		end
	end,
	load_weave = function (arg_28_0, arg_28_1)
		-- function 28
		local level_id = WeaveSettings.templates[arg_28_1].objectives[1].level_id
		local level_transition_handler = Managers.level_transition_handler

		level_transition_handler:set_next_level(level_id)
		level_transition_handler:promote_next_level_data()
	end,
	make_game_ready_for_next_weave = function (self)
		-- function 29
		if not self.is_in_inn then
			return Testify.RETRY
		end
	end,
	set_camera_to_observe_first_bot = function ()
		-- function 30
		local bots = Managers.player:bots()

		if not Unit.alive(bots[1].player_unit) then
			local local_player = Managers.player:local_player()

			CharacterStateHelper.change_camera_state(local_player, "observer")
		end

		return Testify.RETRY
	end,
	update_camera_to_follow_first_bot_rotation = function ()
		-- function 31
		local camera_follow_unit = Managers.player:local_player().camera_follow_unit
		local player_unit = Managers.player:bots()[1].player_unit

		if not player_unit then
			local local_rotation = Unit.local_rotation(player_unit, 0)

			Unit.set_local_rotation(camera_follow_unit, 0, local_rotation)
		end
	end,
	teleport_player_to_main_path_point = function (arg_32_0, arg_32_1)
		-- function 32
		local player_unit = Managers.player:local_player().player_unit
		local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, arg_32_1)

		fn_2(player_unit, point_on_mainpath + Vector3(0, 0, 1))
	end,
	closest_travel_distance_to_player = function ()
		-- function 33
		local player_unit = Managers.player:local_player().player_unit
		local closest_pos_at_main_path, var_33_2 = MainPathUtils.closest_pos_at_main_path(nil, POSITION_LOOKUP[player_unit])

		return var_33_2
	end,
	teleport_player_to_position = function (arg_34_0, arg_34_1)
		-- function 34
		local player_unit = Managers.player:local_player().player_unit

		fn_2(player_unit, arg_34_1:unbox() + Vector3(0, 0, 1))
	end,
	teleport_all_players_to_position = function (arg_35_0, arg_35_1)
		-- function 35
		local network = Managers.state.network

		for k, v in pairs(Managers.player:players()) do
			if not v.player_unit then
				local extension = ScriptUnit.extension(v.player_unit, "locomotion_system")
				local current_rotation = extension:current_rotation()

				if not v.remote then
					local unit_game_object_id = network:unit_game_object_id(v.player_unit)
					local yaw = Quaternion.yaw(current_rotation)

					network.network_transmit:send_rpc_clients("rpc_teleport_unit_with_yaw_rotation", unit_game_object_id, arg_35_1:unbox() + Vector3(0, 0, 1), yaw)
				else
					extension:teleport_to(arg_35_1:unbox() + Vector3(0, 0, 1), current_rotation)
				end
			end
		end
	end,
	teleport_player_randomly_on_main_path = function ()
		-- function 36
		local player_unit = Managers.player:local_player().player_unit
		local random = math.random(1, EngineOptimized.main_path_total_length())
		local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, random)

		fn_2(player_unit, point_on_mainpath + Vector3(0, 0, 1))
	end,
	set_player_unit_not_visible = function ()
		-- function 37
		local local_player = Managers.player:local_player()

		if not Unit.alive(local_player.player_unit) then
			return Testify.RETRY
		end
	end,
	teleport_bots_forward_on_main_path_if_blocked = function (arg_38_0, arg_38_1)
		-- function 38
		local bots_stuck_data = arg_38_1.bots_stuck_data
		local main_path_point = arg_38_1.main_path_point
		local bots_blocked_time_before_teleportation = arg_38_1.bots_blocked_time_before_teleportation

		bots_blocked_time_before_teleportation = bots_blocked_time_before_teleportation or 6

		for k, v in pairs(Managers.player:bots()) do
			local player_unit = v.player_unit

			if not Unit.alive(player_unit) and not fn(player_unit) then
				Testify:_print("Bot unit has been removed or is in a blocking state. Cannot teleport it.")
			else
				local var_38_4 = bots_stuck_data[k]
				local var_38_5 = POSITION_LOOKUP[player_unit]
				local unbox = var_38_4[1]:unbox()
				local distance_squared = Vector3.distance_squared(unbox, var_38_5)
				local bots_blocked_distance = arg_38_1.bots_blocked_distance

				bots_blocked_distance = bots_blocked_distance or 2

				if distance_squared < bots_blocked_distance then
					local var_38_9 = var_38_4[2]

					if bots_blocked_time_before_teleportation < fn_4() - var_38_9 then
						local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, main_path_point)

						if not point_on_mainpath then
							point_on_mainpath.z = point_on_mainpath.z + 1

							Testify:_print("The bot %s has almost not moved since %ss. Teleporting bot to x:%s, y:%s, z:%s", k, bots_blocked_time_before_teleportation, point_on_mainpath.x, point_on_mainpath.y, point_on_mainpath.z)
							fn_2(player_unit, point_on_mainpath)
							Mover.set_position(Unit.mover(player_unit), point_on_mainpath)
						end
					end
				else
					var_38_4[1]:store(var_38_5)

					var_38_4[2] = fn_4()
				end
			end
		end
	end,
	are_bots_blocked = function (arg_39_0, arg_39_1)
		-- function 39
		local bots_stuck_data = arg_39_1.bots_stuck_data
		local bots_blocked_time_before_teleportation = arg_39_1.bots_blocked_time_before_teleportation

		bots_blocked_time_before_teleportation = bots_blocked_time_before_teleportation or 6

		for k, v in pairs(Managers.player:bots()) do
			local player_unit = v.player_unit

			if not player_unit then
				local var_39_3 = bots_stuck_data[k]
				local position = Mover.position(Unit.mover(player_unit))

				if Vector3.distance_squared(var_39_3[1]:unbox(), position) < 2 then
					if bots_blocked_time_before_teleportation < fn_4() - var_39_3[2] then
						var_39_3[1]:store(Vector3(-999, -999, -999))

						var_39_3[2] = fn_4()

						return true
					end
				else
					var_39_3[1]:store(position)

					var_39_3[2] = fn_4()
				end
			end
		end

		return false
	end,
	make_players_invicible = function ()
		-- function 40
		for k, v in pairs(Managers.player:players()) do
			fn_3(v.player_unit)
		end
	end,
	make_player_and_two_bots_invicible = function ()
		-- function 41
		local bots = Managers.player:bots()

		fn_3(bots[1].player_unit)
		fn_3(bots[2].player_unit)
		fn_3(Managers.player:local_player().player_unit)
	end,
	post_telemetry_events = function ()
		-- function 42
		Managers.telemetry:post_batch()
	end,
	get_main_path_points = function (arg_43_0, arg_43_1)
		-- function 43
		local main_path_total_length = EngineOptimized.main_path_total_length()
		local tbl = {}

		for i = 1, arg_43_1 do
			tbl[i] = math.floor(main_path_total_length * i / arg_43_1)
		end

		return tbl
	end,
	set_difficulty = function (arg_44_0, arg_44_1)
		-- function 44
		local num = 0

		Managers.state.difficulty:set_difficulty(arg_44_1, num)
	end,
	get_player_current_position = function ()
		-- function 45
		local var_45_0, var_45_1 = next(Managers.player._human_players)

		return POSITION_LOOKUP[var_45_1.player_unit]
	end,
	is_unit_alive = function (arg_46_0, arg_46_1)
		-- function 46
		local var_46_0 = HEALTH_ALIVE[arg_46_1]

		var_46_0 = var_46_0 or false

		return var_46_0
	end,
	get_unit_health_values = function (arg_47_0, arg_47_1)
		-- function 47
		local var_47_0
		local has_extension = ScriptUnit.has_extension(arg_47_1, "health_system")

		if not has_extension then
			var_47_0 = {
				current_health = has_extension:current_health(),
				max_health = has_extension:get_max_health()
			}
		end

		return var_47_0
	end,
	kill_unit = function (arg_48_0, arg_48_1)
		-- function 48
		local str = "forced"
		local var_48_1 = Vector3(0, 0, -1)

		AiUtils.kill_unit(arg_48_1, nil, nil, str, var_48_1)
	end,
	add_buffs_to_heroes = function (arg_49_0, arg_49_1)
		-- function 49
		local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

		for k, v in pairs(get_side_from_name.PLAYER_AND_BOT_UNITS) do
			for i, v_2 in ipairs(arg_49_1) do
				ScriptUnit.extension(v, "buff_system"):add_buff(v_2)
			end
		end
	end,
	fail_test = function (arg_50_0, arg_50_1)
		-- function 50
		assert(false, arg_50_1)
	end
}
