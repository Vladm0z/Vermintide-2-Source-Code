-- chunkname: @scripts/unit_extensions/generic/end_zone_extension.lua

require("scripts/settings/end_zone_settings")

local testify = script_data.testify

testify = not testify and require("scripts/unit_extensions/generic/end_zone_extension_testify")
EndZoneExtension = class(EndZoneExtension)

EndZoneExtension.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._unit = arg_1_2
	self._world = arg_1_1.world
	self._extension_init_context = arg_1_1
	self._activated = false
	self._activation_allowed = false
	self._closest_player = math.huge
	self._state = "_idle"
	self._is_server = arg_1_1.is_server
	self._state_data = {}
	self._player_distances = {}
	self._current_volume_id = nil
	self._current_id_index = 0
	self._is_start_waystone = false
	self._current_end_zone_hidden_long_timer = self:end_zone_hidden_long_timer()
	self._current_end_zone_visible_long_timer = self:end_zone_visible_long_timer()
	self._end_zone_timer_started = false
	self._end_zone_time_since_notify = self:end_zone_long_timer_settings().notify_long_interval

	local get_data = Unit.get_data(arg_1_2, "visible_from_start")

	get_data = get_data or true
	self._visible_from_start = get_data
	self._waystone_type = Unit.get_data(arg_1_2, "waystone_type")

	local flag

	flag = self._waystone_type ~= 3 or not 3.8 or EndZoneSettings.size
	self.waystone_size = flag
	self._always_activated = Unit.get_data(arg_1_2, "always_activated")

	local get_data_2 = Unit.get_data(arg_1_2, "activation_name")

	get_data_2 = get_data_2 or ""
	self._activation_name = get_data_2
	self._side = Managers.state.side:get_side_from_name("heroes")

	if not Unit.get_data(self._unit, "game_start_waystone") then
		self._is_start_waystone = true
		self._game_start_time = Unit.get_data(self._unit, "game_start_time")
	end

	self._disable_complete_level = Unit.get_data(self._unit, "disable_complete_level")
	self._disable_check_joining_players = Unit.get_data(self._unit, "disable_check_joining_players")

	local node = Unit.node(self._unit, "ap_dome_scaler")

	Unit.set_local_scale(self._unit, node, Vector3(0, 0, 0))

	if not Unit.has_visibility_group(self._unit, "dome") then
		Unit.set_visibility(self._unit, "dome", false)
	end

	self:_set_light_intensity(0)
	Managers.state.network.network_transmit.network_event_delegate:register(self, "rpc_activate_end_zone")

	self._nav_world_available = not LevelHelper:current_level_settings(self._world).no_bots_allowed

	if not self._visible_from_start then
		Unit.set_unit_visibility(arg_1_2, false)
	end
end

EndZoneExtension.extensions_ready = function (arg_2_0)
	-- function 2
	Managers.state.event:register(arg_2_0, "activate_waystone_portal", "activate_waystone_portal")
end

EndZoneExtension.destroy = function (arg_3_0)
	-- function 3
	Managers.state.event:unregister("activate_waystone_portal", arg_3_0)
end

EndZoneExtension.activate_waystone_portal = function (self, arg_4_1)
	-- function 4
	local _unit = self._unit
	local get_data = Unit.get_data(_unit, "waystone_type")

	if not get_data then
		return
	end

	local flag

	flag = get_data ~= arg_4_1 or not "activate" or "deactivate"

	Unit.flow_event(_unit, flag)
end

EndZoneExtension.rpc_activate_end_zone = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if arg_5_2 ~= self._waystone_type then
		return
	end

	if self._activation_name ~= arg_5_5 then
		return
	end

	local game_mode_key = Managers.state.game_mode:game_mode_key()

	self:_trigger_vo(game_mode_key, "activate")

	local var_5_1 = NetworkLookup.weave_winds[arg_5_4]

	if var_5_1 ~= "none" then
		Unit.flow_event(self._unit, var_5_1)
	end

	if not (not self._activated and arg_5_3) then
		self:_deactivate_volume()
	elseif self._activated or not arg_5_3 then
		self:_activate_volume()

		if not self._visible_from_start then
			Unit.set_unit_visibility(self._unit, true)
		end
	end

	self._activated = arg_5_3
end

EndZoneExtension._trigger_vo = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = EndZoneSettings.ingame_vo[arg_6_1]

	if not var_6_0 then
		local var_6_1 = var_6_0[arg_6_2]

		if not var_6_1 then
			if type(var_6_1) == "table" then
				local get_level_seed = Managers.mechanism:get_level_seed()
				local next_random, var_6_4 = Math.next_random(get_level_seed, #var_6_1)
				local var_6_5 = var_6_1[var_6_4]

				Managers.music:trigger_event(var_6_5)
			else
				Managers.music:trigger_event(var_6_1)
			end
		end
	end
end

EndZoneExtension.activated = function (self)
	-- function 7
	return self._activated
end

EndZoneExtension._set_light_intensity = function (self, arg_8_1)
	-- function 8
	local num_lights = Unit.num_lights(self._unit)

	for i = 0, num_lights - 1 do
		local light = Unit.light(self._unit, i)

		Light.set_intensity(light, arg_8_1)
	end
end

EndZoneExtension.end_time = function (self)
	-- function 9
	local _game_start_time = self._game_start_time

	_game_start_time = _game_start_time or EndZoneSettings.end_zone_timer

	return _game_start_time
end

EndZoneExtension.end_time_left = function (self)
	-- function 10
	local end_zone_timer = self._state_data.end_zone_timer

	end_zone_timer = end_zone_timer or self:end_time()

	return end_zone_timer
end

EndZoneExtension.end_zone_long_timer_settings = function (arg_11_0)
	-- function 11
	return EndZoneSettings.end_zone_long_timer_settings
end

EndZoneExtension.end_zone_hidden_long_timer = function (arg_12_0)
	-- function 12
	return EndZoneSettings.end_zone_long_timer_settings.hidden_timer
end

EndZoneExtension.end_zone_visible_long_timer = function (arg_13_0)
	-- function 13
	return EndZoneSettings.end_zone_long_timer_settings.visible_timer
end

EndZoneExtension.end_long_time_left = function (self)
	-- function 14
	local end_zone_long_timer = self._state_data.end_zone_long_timer

	end_zone_long_timer = end_zone_long_timer or self:end_long_time()

	return end_zone_long_timer
end

EndZoneExtension.update = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	self:_reset_distances()
	self:_check_proximity()
	self:_update_state(arg_15_3, arg_15_5)

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

EndZoneExtension.activation_allowed = function (self, arg_16_1)
	-- function 16
	self._activation_allowed = arg_16_1
end

EndZoneExtension._activate = function (self, arg_17_1)
	-- function 17
	if not self._is_server then
		return
	end

	if self._activated or not arg_17_1 then
		self:_activate_volume()

		if not self._visible_from_start then
			Unit.set_unit_visibility(self._unit, true)
		end

		local _get_wind_name = self:_get_wind_name()

		_get_wind_name = _get_wind_name or "none"

		local var_17_1 = NetworkLookup.weave_winds[_get_wind_name]

		if _get_wind_name ~= "none" then
			Unit.flow_event(self._unit, _get_wind_name)
		end

		local game_mode_key = Managers.state.game_mode:game_mode_key()

		self:_trigger_vo(game_mode_key, "activate")
		Managers.state.network.network_transmit:send_rpc_clients("rpc_activate_end_zone", self._waystone_type, true, var_17_1, self._activation_name)
	elseif not (not self._activated and arg_17_1) then
		self:_deactivate_volume()
		Managers.state.network.network_transmit:send_rpc_clients("rpc_activate_end_zone", self._waystone_type, false, 1, self._activation_name)

		local _player_distances = self._player_distances

		for k, v in pairs(_player_distances) do
			if not Unit.alive(k) then
				ScriptUnit.extension(k, "status_system"):set_in_end_zone(false, self._unit)
			end
		end
	end

	self._activated = arg_17_1
end

EndZoneExtension._get_wind_name = function (arg_18_0)
	-- function 18
	local var_18_0
	local get_next_weave = Managers.weave:get_next_weave()

	if not get_next_weave then
		var_18_0 = WeaveSettings.templates[get_next_weave].wind
	end

	return var_18_0
end

EndZoneExtension._activate_volume = function (self)
	-- function 19
	self:_deactivate_volume(self._current_volume_id)

	local get_data = Unit.get_data(self._unit, "shading_environment")
	local get_data_2 = Unit.get_data(self._unit, "volume_name")

	self._current_id_index = self._current_id_index + 1
	self._current_volume_id = "end_zone_id_" .. self._current_id_index

	Managers.state.event:trigger("register_environment_volume", get_data_2, get_data, 999, 0.1, false, 1, Unit.local_position(self._unit, 0), self.waystone_size, self._current_volume_id)

	if not self._is_server and not self._nav_world_available then
		local system = Managers.state.entity:system("volume_system")

		fassert(system.nav_tag_volume_handler ~= nil, "Cannot activate end_zone at Level Load (before nav_tag_volume_handler has been set)! LD, please use the coop_round_started event or activate it at a later point!")

		local str = "end_zone"
		local local_position = Unit.local_position(self._unit, 0)

		self._nav_tag_volume_id = system:create_nav_tag_volume_from_data(local_position, self.waystone_size, str)
	end
end

EndZoneExtension._deactivate_volume = function (self)
	-- function 20
	if not self._current_volume_id then
		Managers.state.event:trigger("unregister_environment_volume", self._current_volume_id)

		self._current_volume_id = nil
	end

	if not self._nav_tag_volume_id then
		Managers.state.entity:system("volume_system"):destroy_nav_tag_volume(self._nav_tag_volume_id)

		self._nav_tag_volume_id = nil
	end
end

EndZoneExtension._reset_distances = function (self)
	-- function 21
	self._closest_player = math.huge

	table.clear(self._player_distances)
end

EndZoneExtension._check_proximity = function (self)
	-- function 22
	local local_position = Unit.local_position(self._unit, 0)
	local var_22_1
	local var_22_2
	local _side = self._side

	if not global_is_inside_inn then
		var_22_1 = _side.PLAYER_UNITS
		var_22_2 = _side.PLAYER_AND_BOT_UNITS
	else
		var_22_1 = _side.PLAYER_UNITS
		var_22_2 = _side.PLAYER_AND_BOT_UNITS
	end

	for k, v in pairs(var_22_2) do
		local var_22_4 = POSITION_LOOKUP[v]

		if not var_22_4 then
			local distance_squared = Vector3.distance_squared(local_position, var_22_4)

			self._closest_player = not (distance_squared < self._closest_player) or not distance_squared or self._closest_player

			if not table.contains(var_22_1, v) then
				self._player_distances[v] = distance_squared
			end
		end
	end
end

EndZoneExtension._update_state = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not self._is_server then
		if not self._activation_allowed then
			local evaluate_end_zone_activation_conditions = Managers.state.game_mode:evaluate_end_zone_activation_conditions()

			if not (not evaluate_end_zone_activation_conditions and self._activated) then
				self:_activate(true)
			elseif evaluate_end_zone_activation_conditions or not self._activated then
				self:_activate(false)
			end
		elseif not self._activated then
			self:_activate(false)
		end
	else
		local flag = true
	end

	self[self._state](self, arg_23_1, arg_23_2, self._state_data)
end

EndZoneExtension.hot_join_sync = function (self, arg_24_1)
	-- function 24
	if not self._activated then
		local _get_wind_name = self:_get_wind_name()

		_get_wind_name = _get_wind_name or "none"

		local var_24_1 = NetworkLookup.weave_winds[_get_wind_name]
		local var_24_2 = PEER_ID_TO_CHANNEL[arg_24_1]

		RPC.rpc_activate_end_zone(var_24_2, self._waystone_type, true, var_24_1, self._activation_name)
	end
end

EndZoneExtension.destroy = function (self)
	-- function 25
	Managers.state.network.network_transmit.network_event_delegate:unregister(self)

	if not self._nav_tag_volume_id then
		Managers.state.entity:system("volume_system"):destroy_nav_tag_volume(self._nav_tag_volume_id)
	end
end

EndZoneExtension._idle = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not self._activated then
		return
	end

	if not (self._always_activated or not (self._closest_player <= EndZoneSettings.activate_size^2)) then
		self._state_data = {
			timer = 0
		}
		self._state = "_open"

		Unit.flow_event(self._unit, "opening_end_zone")

		if not Unit.has_visibility_group(self._unit, "dome") then
			Unit.set_visibility(self._unit, "dome", true)
		end
	end
end

EndZoneExtension._open = function (self, arg_27_1, arg_27_2)
	-- function 27
	if not (not self._activated and self._always_activated or not (self._closest_player <= EndZoneSettings.activate_size^2)) then
		local animation_time = EndZoneSettings.animation_time

		animation_time = animation_time or 0.5
		self._state_data.timer = math.clamp(self._state_data.timer + arg_27_1, 0, animation_time)

		local smoothstep = math.smoothstep(self._state_data.timer / animation_time, 0, 1)
		local node = Unit.node(self._unit, "ap_dome_scaler")

		Unit.set_local_scale(self._unit, node, Vector3(smoothstep, smoothstep, smoothstep))
		self:_set_light_intensity(smoothstep^3)

		if smoothstep == 1 then
			self._state_data.end_zone_timer = self:end_time()
			self._state_data.end_zone_hidden_long_timer = self:end_zone_hidden_long_timer()
			self._state_data.end_zone_visible_long_timer = self:end_zone_visible_long_timer()
			self._state = "_end_mission_check"
		end
	else
		self._state = "_close"

		Unit.flow_event(self._unit, "closing_end_zone")
	end
end

EndZoneExtension._close = function (self, arg_28_1, arg_28_2)
	-- function 28
	if not (not self._activated and self._always_activated or not (self._closest_player <= EndZoneSettings.activate_size^2)) then
		self._state = "_open"

		Unit.flow_event(self._unit, "opening_end_zone")
	else
		local animation_time = EndZoneSettings.animation_time

		animation_time = animation_time or 0.5
		self._state_data.timer = math.clamp(self._state_data.timer - arg_28_1, 0, animation_time)

		local smoothstep = math.smoothstep(self._state_data.timer / animation_time, 0, 1)
		local node = Unit.node(self._unit, "ap_dome_scaler")

		Unit.set_local_scale(self._unit, node, Vector3(smoothstep, smoothstep, smoothstep))
		self:_set_light_intensity(smoothstep^3)

		if smoothstep == 0 then
			self._state = "_idle"

			if not Unit.has_visibility_group(self._unit, "dome") then
				Unit.set_visibility(self._unit, "dome", false)
			end
		end
	end
end

EndZoneExtension._check_end_mission_all_inside = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not (not self._is_start_waystone and self:_all_players_joined()) then
		self._state_data.end_zone_timer = self:end_time()

		return
	end

	if not arg_29_2 then
		self._state_data.end_zone_timer = math.clamp(self:end_time_left() - arg_29_1, 0, self:end_time())

		if not (not (self:end_time_left() <= 0) or self._disable_complete_level) then
			Managers.state.game_mode:complete_level()
		end
	else
		self._state_data.end_zone_timer = self:end_time()
	end
end

EndZoneExtension._check_end_mission_any_inside = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	-- function 30
	if Managers.state.game_mode:game_mode_key() == "weave" or arg_30_2 or not self._is_start_waystone then
		return
	end

	local end_zone_long_timer_settings = self:end_zone_long_timer_settings()

	if not arg_30_3 then
		if not self._end_zone_timer_started then
			self._state_data.end_zone_hidden_long_timer = end_zone_long_timer_settings.hidden_timer
			self._state_data.end_zone_visible_long_timer = end_zone_long_timer_settings.visible_timer
			self._end_zone_timer_started = false
			self._end_zone_time_since_notify = 5
		end

		return
	end

	self._end_zone_timer_started = true

	local end_zone_hidden_long_timer = self._state_data.end_zone_hidden_long_timer
	local end_zone_visible_long_timer = self._state_data.end_zone_visible_long_timer

	if end_zone_hidden_long_timer > 0 then
		self._state_data.end_zone_hidden_long_timer = end_zone_hidden_long_timer - arg_30_1
	elseif end_zone_visible_long_timer > 0 then
		self._end_zone_time_since_notify = self._end_zone_time_since_notify + arg_30_1

		local num = end_zone_visible_long_timer - arg_30_1

		if num > end_zone_long_timer_settings.notify_interval_threshold then
			if self._end_zone_time_since_notify >= end_zone_long_timer_settings.notify_long_interval then
				local round_to_closest_multiple = math.round_to_closest_multiple(num, 5)

				Managers.chat:send_system_chat_message(1, "end_game_timer_system_message", round_to_closest_multiple, false, true)

				self._end_zone_time_since_notify = 0
			end
		elseif self._end_zone_time_since_notify >= end_zone_long_timer_settings.notify_short_interval then
			local round_to_closest_multiple_2 = math.round_to_closest_multiple(num, 1)

			Managers.chat:send_system_chat_message(1, "end_game_timer_system_message", round_to_closest_multiple_2, false, true)

			self._end_zone_time_since_notify = 0
		end

		self._state_data.end_zone_visible_long_timer = num
	elseif not self._disable_complete_level then
		local system = Managers.state.entity:system("mission_system")

		for k, v in pairs(arg_30_4) do
			local extension = ScriptUnit.extension(v, "inventory_system")

			if not extension:has_inventory_item("slot_potion", "wpn_grimoire_01") then
				system:update_mission("grimoire_hidden_mission", false, arg_30_1, true)
			end

			if not extension:has_inventory_item("slot_healthkit", "wpn_side_objective_tome_01") then
				system:update_mission("tome_bonus_mission", false, arg_30_1, true)
			end
		end

		Managers.state.game_mode:complete_level()

		self._disable_complete_level = true
	end
end

EndZoneExtension._end_mission_check = function (self, arg_31_1, arg_31_2)
	-- function 31
	if not (not self._activated and self._always_activated or not (self._closest_player <= EndZoneSettings.activate_size^2)) then
		local var_31_0
		local flag = false
		local alloc_table = FrameTable.alloc_table()

		if not self._is_server then
			local system = Managers.state.entity:system("buff_system")

			for k, v in pairs(self._player_distances) do
				if not Unit.alive(k) then
					local extension = ScriptUnit.extension(k, "status_system")

					if v > self.waystone_size^2 then
						if not extension:is_disabled_non_temporarily() then
							var_31_0 = false
							alloc_table[#alloc_table] = k
						end

						extension:set_in_end_zone(false, self._unit)
					else
						flag = true

						if var_31_0 == nil then
							var_31_0 = true
						end

						local str = "end_zone_invincibility"
						local extension_2 = ScriptUnit.extension(k, "buff_system")
						local flag_2 = not extension_2 and extension_2:has_buff_type(str)

						if not (not extension_2 and flag_2) then
							system:add_buff(k, str, k, false)
						end

						extension:set_in_end_zone(true, self._unit)
					end
				end
			end

			self:_check_end_mission_all_inside(arg_31_1, var_31_0)
			self:_check_end_mission_any_inside(arg_31_1, var_31_0, flag, alloc_table)
		else
			local var_31_8

			for k_2, v_2 in pairs(self._player_distances) do
				if not Unit.alive(k_2) then
					local extension_3 = ScriptUnit.extension(k_2, "status_system")

					if not (extension_3:is_disabled() or extension_3:is_in_end_zone()) then
						var_31_8 = false
					elseif var_31_8 == nil then
						var_31_8 = true
					end
				end
			end

			if not self._is_start_waystone then
				if not var_31_8 and not self:_all_players_joined() then
					self._state_data.end_zone_timer = math.clamp(self:end_time_left() - arg_31_1, 0, self:end_time())
				else
					self._state_data.end_zone_timer = self:end_time()
				end
			elseif not var_31_8 then
				self._state_data.end_zone_timer = math.clamp(self:end_time_left() - arg_31_1, 0, self:end_time())
			else
				self._state_data.end_zone_timer = self:end_time()
			end
		end
	else
		self._state = "_close"

		Unit.flow_event(self._unit, "closing_end_zone")
	end
end

EndZoneExtension._all_players_joined = function (self)
	-- function 32
	if not self._disable_check_joining_players then
		return true
	end

	if not Managers.matchmaking:are_all_players_spawned() then
		return false
	end

	return true
end
