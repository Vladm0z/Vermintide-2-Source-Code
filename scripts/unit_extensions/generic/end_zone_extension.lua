-- chunkname: @scripts/unit_extensions/generic/end_zone_extension.lua

require("scripts/settings/end_zone_settings")

local var_0_0 = script_data.testify and require("scripts/unit_extensions/generic/end_zone_extension_testify")

EndZoneExtension = class(EndZoneExtension)

EndZoneExtension.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._unit = arg_1_2
	arg_1_0._world = arg_1_1.world
	arg_1_0._extension_init_context = arg_1_1
	arg_1_0._activated = false
	arg_1_0._activation_allowed = false
	arg_1_0._closest_player = math.huge
	arg_1_0._state = "_idle"
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._state_data = {}
	arg_1_0._player_distances = {}
	arg_1_0._current_volume_id = nil
	arg_1_0._current_id_index = 0
	arg_1_0._is_start_waystone = false
	arg_1_0._current_end_zone_hidden_long_timer = arg_1_0:end_zone_hidden_long_timer()
	arg_1_0._current_end_zone_visible_long_timer = arg_1_0:end_zone_visible_long_timer()
	arg_1_0._end_zone_timer_started = false
	arg_1_0._end_zone_time_since_notify = arg_1_0:end_zone_long_timer_settings().notify_long_interval
	arg_1_0._visible_from_start = Unit.get_data(arg_1_2, "visible_from_start") or true
	arg_1_0._waystone_type = Unit.get_data(arg_1_2, "waystone_type")
	arg_1_0.waystone_size = arg_1_0._waystone_type == 3 and 3.8 or EndZoneSettings.size
	arg_1_0._always_activated = Unit.get_data(arg_1_2, "always_activated")
	arg_1_0._activation_name = Unit.get_data(arg_1_2, "activation_name") or ""
	arg_1_0._side = Managers.state.side:get_side_from_name("heroes")

	if Unit.get_data(arg_1_0._unit, "game_start_waystone") then
		arg_1_0._is_start_waystone = true
		arg_1_0._game_start_time = Unit.get_data(arg_1_0._unit, "game_start_time")
	end

	arg_1_0._disable_complete_level = Unit.get_data(arg_1_0._unit, "disable_complete_level")
	arg_1_0._disable_check_joining_players = Unit.get_data(arg_1_0._unit, "disable_check_joining_players")

	local var_1_0 = Unit.node(arg_1_0._unit, "ap_dome_scaler")

	Unit.set_local_scale(arg_1_0._unit, var_1_0, Vector3(0, 0, 0))

	if Unit.has_visibility_group(arg_1_0._unit, "dome") then
		Unit.set_visibility(arg_1_0._unit, "dome", false)
	end

	arg_1_0:_set_light_intensity(0)
	Managers.state.network.network_transmit.network_event_delegate:register(arg_1_0, "rpc_activate_end_zone")

	arg_1_0._nav_world_available = not LevelHelper:current_level_settings(arg_1_0._world).no_bots_allowed

	if not arg_1_0._visible_from_start then
		Unit.set_unit_visibility(arg_1_2, false)
	end
end

EndZoneExtension.extensions_ready = function (arg_2_0)
	Managers.state.event:register(arg_2_0, "activate_waystone_portal", "activate_waystone_portal")
end

EndZoneExtension.destroy = function (arg_3_0)
	Managers.state.event:unregister("activate_waystone_portal", arg_3_0)
end

EndZoneExtension.activate_waystone_portal = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._unit
	local var_4_1 = Unit.get_data(var_4_0, "waystone_type")

	if not var_4_1 then
		return
	end

	local var_4_2 = var_4_1 == arg_4_1 and "activate" or "deactivate"

	Unit.flow_event(var_4_0, var_4_2)
end

EndZoneExtension.rpc_activate_end_zone = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_2 ~= arg_5_0._waystone_type then
		return
	end

	if arg_5_0._activation_name ~= arg_5_5 then
		return
	end

	local var_5_0 = Managers.state.game_mode:game_mode_key()

	arg_5_0:_trigger_vo(var_5_0, "activate")

	local var_5_1 = NetworkLookup.weave_winds[arg_5_4]

	if var_5_1 ~= "none" then
		Unit.flow_event(arg_5_0._unit, var_5_1)
	end

	if arg_5_0._activated and not arg_5_3 then
		arg_5_0:_deactivate_volume()
	elseif not arg_5_0._activated and arg_5_3 then
		arg_5_0:_activate_volume()

		if not arg_5_0._visible_from_start then
			Unit.set_unit_visibility(arg_5_0._unit, true)
		end
	end

	arg_5_0._activated = arg_5_3
end

EndZoneExtension._trigger_vo = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = EndZoneSettings.ingame_vo[arg_6_1]

	if var_6_0 then
		local var_6_1 = var_6_0[arg_6_2]

		if var_6_1 then
			if type(var_6_1) == "table" then
				local var_6_2 = Managers.mechanism:get_level_seed()
				local var_6_3, var_6_4 = Math.next_random(var_6_2, #var_6_1)
				local var_6_5 = var_6_1[var_6_4]

				Managers.music:trigger_event(var_6_5)
			else
				Managers.music:trigger_event(var_6_1)
			end
		end
	end
end

EndZoneExtension.activated = function (arg_7_0)
	return arg_7_0._activated
end

EndZoneExtension._set_light_intensity = function (arg_8_0, arg_8_1)
	local var_8_0 = Unit.num_lights(arg_8_0._unit)

	for iter_8_0 = 0, var_8_0 - 1 do
		local var_8_1 = Unit.light(arg_8_0._unit, iter_8_0)

		Light.set_intensity(var_8_1, arg_8_1)
	end
end

EndZoneExtension.end_time = function (arg_9_0)
	return arg_9_0._game_start_time or EndZoneSettings.end_zone_timer
end

EndZoneExtension.end_time_left = function (arg_10_0)
	return arg_10_0._state_data.end_zone_timer or arg_10_0:end_time()
end

EndZoneExtension.end_zone_long_timer_settings = function (arg_11_0)
	return EndZoneSettings.end_zone_long_timer_settings
end

EndZoneExtension.end_zone_hidden_long_timer = function (arg_12_0)
	return EndZoneSettings.end_zone_long_timer_settings.hidden_timer
end

EndZoneExtension.end_zone_visible_long_timer = function (arg_13_0)
	return EndZoneSettings.end_zone_long_timer_settings.visible_timer
end

EndZoneExtension.end_long_time_left = function (arg_14_0)
	return arg_14_0._state_data.end_zone_long_timer or arg_14_0:end_long_time()
end

EndZoneExtension.update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	arg_15_0:_reset_distances()
	arg_15_0:_check_proximity()
	arg_15_0:_update_state(arg_15_3, arg_15_5)

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_15_0)
	end
end

EndZoneExtension.activation_allowed = function (arg_16_0, arg_16_1)
	arg_16_0._activation_allowed = arg_16_1
end

EndZoneExtension._activate = function (arg_17_0, arg_17_1)
	if not arg_17_0._is_server then
		return
	end

	if not arg_17_0._activated and arg_17_1 then
		arg_17_0:_activate_volume()

		if not arg_17_0._visible_from_start then
			Unit.set_unit_visibility(arg_17_0._unit, true)
		end

		local var_17_0 = arg_17_0:_get_wind_name() or "none"
		local var_17_1 = NetworkLookup.weave_winds[var_17_0]

		if var_17_0 ~= "none" then
			Unit.flow_event(arg_17_0._unit, var_17_0)
		end

		local var_17_2 = Managers.state.game_mode:game_mode_key()

		arg_17_0:_trigger_vo(var_17_2, "activate")
		Managers.state.network.network_transmit:send_rpc_clients("rpc_activate_end_zone", arg_17_0._waystone_type, true, var_17_1, arg_17_0._activation_name)
	elseif arg_17_0._activated and not arg_17_1 then
		arg_17_0:_deactivate_volume()
		Managers.state.network.network_transmit:send_rpc_clients("rpc_activate_end_zone", arg_17_0._waystone_type, false, 1, arg_17_0._activation_name)

		local var_17_3 = arg_17_0._player_distances

		for iter_17_0, iter_17_1 in pairs(var_17_3) do
			if Unit.alive(iter_17_0) then
				ScriptUnit.extension(iter_17_0, "status_system"):set_in_end_zone(false, arg_17_0._unit)
			end
		end
	end

	arg_17_0._activated = arg_17_1
end

EndZoneExtension._get_wind_name = function (arg_18_0)
	local var_18_0
	local var_18_1 = Managers.weave:get_next_weave()

	if var_18_1 then
		var_18_0 = WeaveSettings.templates[var_18_1].wind
	end

	return var_18_0
end

EndZoneExtension._activate_volume = function (arg_19_0)
	arg_19_0:_deactivate_volume(arg_19_0._current_volume_id)

	local var_19_0 = Unit.get_data(arg_19_0._unit, "shading_environment")
	local var_19_1 = Unit.get_data(arg_19_0._unit, "volume_name")

	arg_19_0._current_id_index = arg_19_0._current_id_index + 1
	arg_19_0._current_volume_id = "end_zone_id_" .. arg_19_0._current_id_index

	Managers.state.event:trigger("register_environment_volume", var_19_1, var_19_0, 999, 0.1, false, 1, Unit.local_position(arg_19_0._unit, 0), arg_19_0.waystone_size, arg_19_0._current_volume_id)

	if arg_19_0._is_server and arg_19_0._nav_world_available then
		local var_19_2 = Managers.state.entity:system("volume_system")

		fassert(var_19_2.nav_tag_volume_handler ~= nil, "Cannot activate end_zone at Level Load (before nav_tag_volume_handler has been set)! LD, please use the coop_round_started event or activate it at a later point!")

		local var_19_3 = "end_zone"
		local var_19_4 = Unit.local_position(arg_19_0._unit, 0)

		arg_19_0._nav_tag_volume_id = var_19_2:create_nav_tag_volume_from_data(var_19_4, arg_19_0.waystone_size, var_19_3)
	end
end

EndZoneExtension._deactivate_volume = function (arg_20_0)
	if arg_20_0._current_volume_id then
		Managers.state.event:trigger("unregister_environment_volume", arg_20_0._current_volume_id)

		arg_20_0._current_volume_id = nil
	end

	if arg_20_0._nav_tag_volume_id then
		Managers.state.entity:system("volume_system"):destroy_nav_tag_volume(arg_20_0._nav_tag_volume_id)

		arg_20_0._nav_tag_volume_id = nil
	end
end

EndZoneExtension._reset_distances = function (arg_21_0)
	arg_21_0._closest_player = math.huge

	table.clear(arg_21_0._player_distances)
end

EndZoneExtension._check_proximity = function (arg_22_0)
	local var_22_0 = Unit.local_position(arg_22_0._unit, 0)
	local var_22_1
	local var_22_2
	local var_22_3 = arg_22_0._side

	if global_is_inside_inn then
		var_22_1 = var_22_3.PLAYER_UNITS
		var_22_2 = var_22_3.PLAYER_AND_BOT_UNITS
	else
		var_22_1 = var_22_3.PLAYER_UNITS
		var_22_2 = var_22_3.PLAYER_AND_BOT_UNITS
	end

	for iter_22_0, iter_22_1 in pairs(var_22_2) do
		local var_22_4 = POSITION_LOOKUP[iter_22_1]

		if var_22_4 then
			local var_22_5 = Vector3.distance_squared(var_22_0, var_22_4)

			arg_22_0._closest_player = var_22_5 < arg_22_0._closest_player and var_22_5 or arg_22_0._closest_player

			if table.contains(var_22_1, iter_22_1) then
				arg_22_0._player_distances[iter_22_1] = var_22_5
			end
		end
	end
end

EndZoneExtension._update_state = function (arg_23_0, arg_23_1, arg_23_2)
	if arg_23_0._is_server then
		if arg_23_0._activation_allowed then
			local var_23_0 = Managers.state.game_mode:evaluate_end_zone_activation_conditions()

			if var_23_0 and not arg_23_0._activated then
				arg_23_0:_activate(true)
			elseif not var_23_0 and arg_23_0._activated then
				arg_23_0:_activate(false)
			end
		elseif arg_23_0._activated then
			arg_23_0:_activate(false)
		end
	else
		local var_23_1 = true
	end

	arg_23_0[arg_23_0._state](arg_23_0, arg_23_1, arg_23_2, arg_23_0._state_data)
end

EndZoneExtension.hot_join_sync = function (arg_24_0, arg_24_1)
	if arg_24_0._activated then
		local var_24_0 = arg_24_0:_get_wind_name() or "none"
		local var_24_1 = NetworkLookup.weave_winds[var_24_0]
		local var_24_2 = PEER_ID_TO_CHANNEL[arg_24_1]

		RPC.rpc_activate_end_zone(var_24_2, arg_24_0._waystone_type, true, var_24_1, arg_24_0._activation_name)
	end
end

EndZoneExtension.destroy = function (arg_25_0)
	Managers.state.network.network_transmit.network_event_delegate:unregister(arg_25_0)

	if arg_25_0._nav_tag_volume_id then
		Managers.state.entity:system("volume_system"):destroy_nav_tag_volume(arg_25_0._nav_tag_volume_id)
	end
end

EndZoneExtension._idle = function (arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0._activated then
		return
	end

	if arg_26_0._always_activated or arg_26_0._closest_player <= EndZoneSettings.activate_size^2 then
		arg_26_0._state_data = {
			timer = 0
		}
		arg_26_0._state = "_open"

		Unit.flow_event(arg_26_0._unit, "opening_end_zone")

		if Unit.has_visibility_group(arg_26_0._unit, "dome") then
			Unit.set_visibility(arg_26_0._unit, "dome", true)
		end
	end
end

EndZoneExtension._open = function (arg_27_0, arg_27_1, arg_27_2)
	if arg_27_0._activated and (arg_27_0._always_activated or arg_27_0._closest_player <= EndZoneSettings.activate_size^2) then
		local var_27_0 = EndZoneSettings.animation_time or 0.5

		arg_27_0._state_data.timer = math.clamp(arg_27_0._state_data.timer + arg_27_1, 0, var_27_0)

		local var_27_1 = math.smoothstep(arg_27_0._state_data.timer / var_27_0, 0, 1)
		local var_27_2 = Unit.node(arg_27_0._unit, "ap_dome_scaler")

		Unit.set_local_scale(arg_27_0._unit, var_27_2, Vector3(var_27_1, var_27_1, var_27_1))
		arg_27_0:_set_light_intensity(var_27_1^3)

		if var_27_1 == 1 then
			arg_27_0._state_data.end_zone_timer = arg_27_0:end_time()
			arg_27_0._state_data.end_zone_hidden_long_timer = arg_27_0:end_zone_hidden_long_timer()
			arg_27_0._state_data.end_zone_visible_long_timer = arg_27_0:end_zone_visible_long_timer()
			arg_27_0._state = "_end_mission_check"
		end
	else
		arg_27_0._state = "_close"

		Unit.flow_event(arg_27_0._unit, "closing_end_zone")
	end
end

EndZoneExtension._close = function (arg_28_0, arg_28_1, arg_28_2)
	if arg_28_0._activated and (arg_28_0._always_activated or arg_28_0._closest_player <= EndZoneSettings.activate_size^2) then
		arg_28_0._state = "_open"

		Unit.flow_event(arg_28_0._unit, "opening_end_zone")
	else
		local var_28_0 = EndZoneSettings.animation_time or 0.5

		arg_28_0._state_data.timer = math.clamp(arg_28_0._state_data.timer - arg_28_1, 0, var_28_0)

		local var_28_1 = math.smoothstep(arg_28_0._state_data.timer / var_28_0, 0, 1)
		local var_28_2 = Unit.node(arg_28_0._unit, "ap_dome_scaler")

		Unit.set_local_scale(arg_28_0._unit, var_28_2, Vector3(var_28_1, var_28_1, var_28_1))
		arg_28_0:_set_light_intensity(var_28_1^3)

		if var_28_1 == 0 then
			arg_28_0._state = "_idle"

			if Unit.has_visibility_group(arg_28_0._unit, "dome") then
				Unit.set_visibility(arg_28_0._unit, "dome", false)
			end
		end
	end
end

EndZoneExtension._check_end_mission_all_inside = function (arg_29_0, arg_29_1, arg_29_2)
	if arg_29_0._is_start_waystone and not arg_29_0:_all_players_joined() then
		arg_29_0._state_data.end_zone_timer = arg_29_0:end_time()

		return
	end

	if arg_29_2 then
		arg_29_0._state_data.end_zone_timer = math.clamp(arg_29_0:end_time_left() - arg_29_1, 0, arg_29_0:end_time())

		if arg_29_0:end_time_left() <= 0 and not arg_29_0._disable_complete_level then
			Managers.state.game_mode:complete_level()
		end
	else
		arg_29_0._state_data.end_zone_timer = arg_29_0:end_time()
	end
end

EndZoneExtension._check_end_mission_any_inside = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	if Managers.state.game_mode:game_mode_key() == "weave" or arg_30_2 or arg_30_0._is_start_waystone then
		return
	end

	local var_30_0 = arg_30_0:end_zone_long_timer_settings()

	if not arg_30_3 then
		if arg_30_0._end_zone_timer_started then
			arg_30_0._state_data.end_zone_hidden_long_timer = var_30_0.hidden_timer
			arg_30_0._state_data.end_zone_visible_long_timer = var_30_0.visible_timer
			arg_30_0._end_zone_timer_started = false
			arg_30_0._end_zone_time_since_notify = 5
		end

		return
	end

	arg_30_0._end_zone_timer_started = true

	local var_30_1 = arg_30_0._state_data.end_zone_hidden_long_timer
	local var_30_2 = arg_30_0._state_data.end_zone_visible_long_timer

	if var_30_1 > 0 then
		arg_30_0._state_data.end_zone_hidden_long_timer = var_30_1 - arg_30_1
	elseif var_30_2 > 0 then
		arg_30_0._end_zone_time_since_notify = arg_30_0._end_zone_time_since_notify + arg_30_1

		local var_30_3 = var_30_2 - arg_30_1

		if var_30_3 > var_30_0.notify_interval_threshold then
			if arg_30_0._end_zone_time_since_notify >= var_30_0.notify_long_interval then
				local var_30_4 = math.round_to_closest_multiple(var_30_3, 5)

				Managers.chat:send_system_chat_message(1, "end_game_timer_system_message", var_30_4, false, true)

				arg_30_0._end_zone_time_since_notify = 0
			end
		elseif arg_30_0._end_zone_time_since_notify >= var_30_0.notify_short_interval then
			local var_30_5 = math.round_to_closest_multiple(var_30_3, 1)

			Managers.chat:send_system_chat_message(1, "end_game_timer_system_message", var_30_5, false, true)

			arg_30_0._end_zone_time_since_notify = 0
		end

		arg_30_0._state_data.end_zone_visible_long_timer = var_30_3
	elseif not arg_30_0._disable_complete_level then
		local var_30_6 = Managers.state.entity:system("mission_system")

		for iter_30_0, iter_30_1 in pairs(arg_30_4) do
			local var_30_7 = ScriptUnit.extension(iter_30_1, "inventory_system")

			if var_30_7:has_inventory_item("slot_potion", "wpn_grimoire_01") then
				var_30_6:update_mission("grimoire_hidden_mission", false, arg_30_1, true)
			end

			if var_30_7:has_inventory_item("slot_healthkit", "wpn_side_objective_tome_01") then
				var_30_6:update_mission("tome_bonus_mission", false, arg_30_1, true)
			end
		end

		Managers.state.game_mode:complete_level()

		arg_30_0._disable_complete_level = true
	end
end

EndZoneExtension._end_mission_check = function (arg_31_0, arg_31_1, arg_31_2)
	if arg_31_0._activated and (arg_31_0._always_activated or arg_31_0._closest_player <= EndZoneSettings.activate_size^2) then
		local var_31_0
		local var_31_1 = false
		local var_31_2 = FrameTable.alloc_table()

		if arg_31_0._is_server then
			local var_31_3 = Managers.state.entity:system("buff_system")

			for iter_31_0, iter_31_1 in pairs(arg_31_0._player_distances) do
				if Unit.alive(iter_31_0) then
					local var_31_4 = ScriptUnit.extension(iter_31_0, "status_system")

					if iter_31_1 > arg_31_0.waystone_size^2 then
						if not var_31_4:is_disabled_non_temporarily() then
							var_31_0 = false
							var_31_2[#var_31_2] = iter_31_0
						end

						var_31_4:set_in_end_zone(false, arg_31_0._unit)
					else
						var_31_1 = true

						if var_31_0 == nil then
							var_31_0 = true
						end

						local var_31_5 = "end_zone_invincibility"
						local var_31_6 = ScriptUnit.extension(iter_31_0, "buff_system")
						local var_31_7 = var_31_6 and var_31_6:has_buff_type(var_31_5)

						if var_31_6 and not var_31_7 then
							var_31_3:add_buff(iter_31_0, var_31_5, iter_31_0, false)
						end

						var_31_4:set_in_end_zone(true, arg_31_0._unit)
					end
				end
			end

			arg_31_0:_check_end_mission_all_inside(arg_31_1, var_31_0)
			arg_31_0:_check_end_mission_any_inside(arg_31_1, var_31_0, var_31_1, var_31_2)
		else
			local var_31_8

			for iter_31_2, iter_31_3 in pairs(arg_31_0._player_distances) do
				if Unit.alive(iter_31_2) then
					local var_31_9 = ScriptUnit.extension(iter_31_2, "status_system")

					if not var_31_9:is_disabled() and not var_31_9:is_in_end_zone() then
						var_31_8 = false
					elseif var_31_8 == nil then
						var_31_8 = true
					end
				end
			end

			if arg_31_0._is_start_waystone then
				if var_31_8 and arg_31_0:_all_players_joined() then
					arg_31_0._state_data.end_zone_timer = math.clamp(arg_31_0:end_time_left() - arg_31_1, 0, arg_31_0:end_time())
				else
					arg_31_0._state_data.end_zone_timer = arg_31_0:end_time()
				end
			elseif var_31_8 then
				arg_31_0._state_data.end_zone_timer = math.clamp(arg_31_0:end_time_left() - arg_31_1, 0, arg_31_0:end_time())
			else
				arg_31_0._state_data.end_zone_timer = arg_31_0:end_time()
			end
		end
	else
		arg_31_0._state = "_close"

		Unit.flow_event(arg_31_0._unit, "closing_end_zone")
	end
end

EndZoneExtension._all_players_joined = function (arg_32_0)
	if arg_32_0._disable_check_joining_players then
		return true
	end

	if not Managers.matchmaking:are_all_players_spawned() then
		return false
	end

	return true
end
