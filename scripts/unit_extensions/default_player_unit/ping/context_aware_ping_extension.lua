-- chunkname: @scripts/unit_extensions/default_player_unit/ping/context_aware_ping_extension.lua

local num = 2
local num_2 = 2.5
local num_3 = 0.2
local num_4 = 0.15
local num_5 = 50

ContextAwarePingExtension = class(ContextAwarePingExtension)

ContextAwarePingExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._physics_world = World.get_data(self._world, "physics_world")
	self._unit = arg_1_2
	self._player = arg_1_3.player
	self._ping_context = nil
	self._social_wheel_context = nil
	self._ping_position = Vector3Box()
	self._num_free_events = num
	self._num_free_combat_events = num
	self._last_update_t = 0

	local ping_mode = Managers.state.game_mode:settings().ping_mode

	if not ping_mode then
		self._world_markers_enabled = ping_mode.world_markers
	else
		self._world_markers_enabled = false
	end

	self._double_press_start_time = nil
	self._double_press_end_time = nil
	self._double_press_listen_duration = 0.25
	self._double_press_counter = 0
	self._can_ping = false
	self._listen_for_double_press = false
	self._ping_system = Managers.state.entity:system("ping_system")
end

ContextAwarePingExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._input_extension = ScriptUnit.extension(arg_2_2, "input_system")
	self._first_person_extension = ScriptUnit.extension(arg_2_2, "first_person_system")
	self._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
end

ContextAwarePingExtension.ping_context = function (self)
	-- function 3
	return self._ping_context
end

ContextAwarePingExtension.social_wheel_context = function (self)
	-- function 4
	return self._social_wheel_context
end

ContextAwarePingExtension.destroy = function (arg_5_0)
	-- function 5
	return
end

ContextAwarePingExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	if self._num_free_events < num then
		local num_4 = (arg_6_5 - self._last_update_t) / num_2

		self._num_free_events = math.min(self._num_free_events + num_4, num)
	end

	if self._num_free_combat_events < num then
		local num_5 = (arg_6_5 - self._last_update_t) / num_3

		self._num_free_combat_events = math.min(self._num_free_combat_events + num_5, num)
	end

	self:_handle_ping_input(arg_6_5, arg_6_3, arg_6_2, arg_6_1, arg_6_4)

	self._last_update_t = arg_6_5
end

ContextAwarePingExtension._have_free_events = function (self)
	-- function 7
	return self._num_free_events > 0
end

ContextAwarePingExtension._have_free_combat_events = function (self)
	-- function 8
	return self._num_free_combat_events > 0
end

ContextAwarePingExtension._consume_ping_event = function (self)
	-- function 9
	self._num_free_events = self._num_free_events - 1
end

ContextAwarePingExtension._consume_combat_ping_event = function (self)
	-- function 10
	self._num_free_combat_events = self._num_free_combat_events - 1
end

ContextAwarePingExtension.ping_attempt = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	if not (IgnoreFreeEvents[arg_11_4] or self:_have_free_events()) then
		if arg_11_4 ~= nil then
			local var_11_0 = Localize("social_wheel_too_many_messages_warning")

			Managers.chat:add_local_system_message(1, var_11_0, true)
		end

		return false
	elseif not (IgnoreFreeCombatEvents[arg_11_4] or self:_have_free_combat_events()) then
		return false
	end

	if not Unit.alive(arg_11_2) and not LEVEL_EDITOR_TEST then
		return false
	end

	arg_11_5 = arg_11_4 == PingTypes.LOCAL_ONLY or not arg_11_5 or NetworkLookup.social_wheel_events["n/a"]

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_11_1)
	local game_object_or_level_id, var_11_4 = network:game_object_or_level_id(arg_11_2)

	arg_11_4 = arg_11_4 or not self._world_markers_enabled or PingTypes.CONTEXT or PingTypes.PING_ONLY

	network.network_transmit:send_rpc_server("rpc_ping_unit", unit_game_object_id, game_object_or_level_id, var_11_4, false, arg_11_4, arg_11_5)

	if not IgnoreFreeEvents[arg_11_4] then
		self:_consume_ping_event()
	elseif not IgnoreFreeCombatEvents[arg_11_4] then
		self:_consume_combat_ping_event()
	end

	return true
end

ContextAwarePingExtension.ping_world_position_attempt = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	if not self._world_markers_enabled then
		return
	end

	arg_12_4 = arg_12_4 or PingTypes.CONTEXT
	arg_12_6 = not not arg_12_6

	if not self._world_markers_enabled then
		return
	end

	local _world_marker_cooldown = self._world_marker_cooldown

	_world_marker_cooldown = _world_marker_cooldown or 0

	if arg_12_3 < _world_marker_cooldown then
		return
	end

	if not self:_have_free_events() then
		local var_12_1 = Localize("social_wheel_too_many_messages_warning")

		Managers.chat:add_local_system_message(1, var_12_1, true)

		return false
	elseif not self:_have_free_combat_events() then
		return false
	end

	if not LEVEL_EDITOR_TEST then
		return false
	end

	self._world_marker_cooldown = arg_12_3 + num_4
	arg_12_5 = arg_12_5 or NetworkLookup.social_wheel_events["n/a"]

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_12_1)

	network.network_transmit:send_rpc_server("rpc_ping_world_position", unit_game_object_id, arg_12_2, arg_12_4, arg_12_5, arg_12_6)

	if not IgnoreFreeEvents[arg_12_4] then
		self:_consume_ping_event()
	elseif not IgnoreFreeCombatEvents[arg_12_4] then
		self:_consume_combat_ping_event()
	end

	return true
end

ContextAwarePingExtension.social_message_attempt = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not self:_have_free_events() then
		local var_13_0 = Localize("social_wheel_too_many_messages_warning")

		Managers.chat:add_local_system_message(1, var_13_0, true)

		return false
	end

	if not LEVEL_EDITOR_TEST then
		return false
	end

	arg_13_2 = arg_13_2 or NetworkLookup.social_wheel_events["n/a"]

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_13_1)
	local unit_game_object_id_2

	if not arg_13_3 and not Unit.alive(arg_13_3) then
		unit_game_object_id_2 = network:unit_game_object_id(arg_13_3)

		if not unit_game_object_id_2 then
			-- Nothing
		end
	end

	unit_game_object_id_2 = 0

	::label_13_0::

	network.network_transmit:send_rpc_server("rpc_social_message", unit_game_object_id, arg_13_2, unit_game_object_id_2)
	self:_consume_ping_event()

	return true
end

local num_6 = 1
local num_7 = 2
local num_8 = 4
local tbl = {}

ContextAwarePingExtension._check_raycast = function (self, arg_14_1)
	-- function 14
	local var_14_0
	local var_14_1
	local var_14_2
	local var_14_3
	local var_14_4
	local system = Managers.state.entity:system("darkness_system")
	local _first_person_extension = self._first_person_extension
	local current_position = _first_person_extension:current_position()
	local current_rotation = _first_person_extension:current_rotation()
	local forward = Quaternion.forward(current_rotation)
	local right = Quaternion.right(current_rotation)
	local up = Quaternion.up(current_rotation)
	local immediate_raycast, var_14_13 = self._physics_world:immediate_raycast(current_position, forward, num_5, "all", "collision_filter", "filter_ray_ping")
	local num = -math.huge
	local num_2 = 2000

	for i = 1, var_14_13 do
		local var_14_16 = immediate_raycast[i]
		local var_14_17 = var_14_16[num_8]
		local var_14_18 = var_14_16[num_6]
		local var_14_19 = var_14_16[num_7]

		if not var_14_17 then
			local unit = Actor.unit(var_14_17)

			if unit ~= arg_14_1 then
				local has_extension = ScriptUnit.has_extension(unit, "ping_system")

				if not has_extension then
					local has_extension_2 = ScriptUnit.has_extension(unit, "ghost_mode_system")

					if not (not has_extension_2 and has_extension_2:is_in_ghost_mode() and not (var_14_19 > 0.05)) then
						local has_extension_3 = ScriptUnit.has_extension(unit, "status_system")
						local has_extension_4 = ScriptUnit.has_extension(unit, "pickup_system")
						local get_data = Unit.get_data(unit, "breed")
						local flag = get_data ~= nil
						local var_14_27 = HEALTH_ALIVE[unit]
						local var_14_28
						local var_14_29

						if not has_extension_4 then
							local box, var_14_31 = Unit.box(unit, true)

							var_14_28 = var_14_31.x * 0.75
							var_14_29 = var_14_31.z * 0.75
						elseif not flag then
							local aoe_height = get_data.aoe_height

							aoe_height = aoe_height or DEFAULT_BREED_AOE_HEIGHT
							var_14_29 = aoe_height * 0.5
							var_14_28 = get_data.aoe_radius or DEFAULT_BREED_AOE_RADIUS
						elseif not has_extension_3 then
							local box_2, var_14_34 = Unit.box(unit, true)

							var_14_28 = var_14_34.x * 0.75
							var_14_29 = var_14_34.z
						else
							var_14_28 = 0.25
							var_14_29 = 0.25
						end

						local num_3 = var_14_18 - (Unit.local_position(unit, 0) + Vector3(0, 0, var_14_29))
						local abs = math.abs(Vector3.dot(num_3, right))
						local abs_2 = math.abs(Vector3.dot(num_3, up))
						local num_4 = 0.01
						local flag_2 = not (abs <= var_14_28 + num_4) or abs_2 <= var_14_29 + num_4
						local var_14_40

						if not flag_2 then
							var_14_40 = math.huge
						else
							local atan = math.atan(var_14_28 / var_14_19)
							local atan_2 = math.atan(var_14_29 / var_14_19)
							local atan_3 = math.atan(abs / var_14_19)
							local atan_4 = math.atan(abs_2 / var_14_19)

							var_14_40 = 1 / (math.max(atan_3 - atan, num_4) / math.log(atan) * (math.max(atan_4 - atan_2, num_4) / math.log(atan)))
						end

						local flag_3 = not flag and Managers.state.side:is_enemy(self._unit, unit)
						local flag_4 = not has_extension_3 and has_extension_3:is_disabled()

						if not ((has_extension.always_pingable or has_extension_4 or not var_14_27 and flag_3 and not flag_4) and system:is_in_darkness(var_14_18) or not (num < var_14_40)) then
							var_14_0 = unit
							var_14_2 = var_14_19
							num = var_14_40
							var_14_4 = var_14_18
						end

						local flag_5 = false

						if not has_extension_4 then
							local get_pickup_settings = has_extension_4:get_pickup_settings()

							flag_5 = get_pickup_settings.slot_name or get_pickup_settings.type == "ammo"
						end

						if not ((not flag_5 and var_14_19 <= INTERACT_RAY_DISTANCE and not var_14_27 or not has_extension_3) and not (num_2 < var_14_40)) then
							var_14_1 = unit
							var_14_3 = var_14_19
							num_2 = var_14_40
						end
					end
				elseif not Unit.get_data(unit, "breed") then
					-- Nothing
				else
					var_14_4 = var_14_18

					break
				end
			end
		end
	end

	if var_14_0 or not var_14_4 then
		local var_14_49 = Managers.state.side.side_by_unit[self._unit]

		if var_14_49:name() == "dark_pact" then
			local var_14_50 = tbl
			local num_9 = 0
			local ENEMY_PLAYER_AND_BOT_UNITS = var_14_49.ENEMY_PLAYER_AND_BOT_UNITS

			for j = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
				local var_14_53 = ENEMY_PLAYER_AND_BOT_UNITS[j]
				local var_14_54 = POSITION_LOOKUP[var_14_53]

				if not var_14_54 then
					local num_10 = var_14_54 + Vector3.up()

					if not self:_is_camera_looking_at_position(num_10, var_14_4, 0.075) then
						num_9 = num_9 + 1
						var_14_50[num_9] = var_14_53
					end
				end
			end

			local var_14_56
			local huge = math.huge

			for k = 1, num_9 do
				local var_14_58 = POSITION_LOOKUP[var_14_50[k]]
				local distance_squared = Vector3.distance_squared(var_14_58, current_position)

				if distance_squared < huge then
					var_14_56 = var_14_50[k]
					huge = distance_squared
				end
			end

			if not var_14_56 then
				var_14_0 = var_14_56
				var_14_2 = math.sqrt(huge)
			end
		end
	end

	return var_14_0, var_14_1, var_14_2, var_14_3, var_14_4
end

ContextAwarePingExtension._is_camera_looking_at_position = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local camera = self._first_person_extension:camera()

	if not Camera.inside_frustum(camera, arg_15_2) then
		local world_to_screen_uv = ScriptCamera.world_to_screen_uv(camera, arg_15_2)
		local num = arg_15_3 * arg_15_3

		if not Camera.inside_frustum(camera, arg_15_1) then
			local world_to_screen_uv_2 = ScriptCamera.world_to_screen_uv(camera, arg_15_1)

			if num >= Vector3.distance_squared(world_to_screen_uv_2, world_to_screen_uv) then
				return true
			end
		end
	end
end

ContextAwarePingExtension._handle_ping_input = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	if not self._ping_context and not self._can_ping then
		local _ping_context = self._ping_context
		local get = self._input_extension:get("ping_release")
		local get_2 = self._input_extension:get("ping_hold")

		if not (get or get_2) then
			local unit = _ping_context.unit
			local ping_type = _ping_context.ping_type

			if arg_16_1 <= _ping_context.max_t then
				if not Unit.alive(unit) then
					self:ping_attempt(arg_16_4, unit, arg_16_1, ping_type)
				elseif not _ping_context.fallback_to_world_marker then
					local var_16_5

					self:ping_world_position_attempt(arg_16_4, _ping_context.position:unbox(), arg_16_1, ping_type or PingTypes.CONTEXT, var_16_5, _ping_context.is_double_press)

					if not Managers.state.game_mode:setting("allow_double_ping") then
						self:_start_listen_for_double_press(arg_16_1)
					end
				end
			end

			self._ping_context = nil
			self._social_wheel_context = nil
			self._can_ping = false
		end
	elseif not self._social_wheel_context then
		local get_3 = self._input_extension:get("social_wheel_only_release")
		local get_4 = self._input_extension:get("social_wheel_only_hold")
		local get_5 = self._input_extension:get("weapon_poses_only_release")
		local get_6 = self._input_extension:get("weapon_poses_only_hold")
		local get_7 = self._input_extension:get("photomode_only_released")
		local get_8 = self._input_extension:get("photomode_only_hold")

		if not (not self._input_extension:get("ping_hold") and get_3 and not get_4 and get_5 and not get_6 and get_7 or get_8) then
			self._social_wheel_context = nil
			self._can_ping = false
		end
	elseif not self._can_ping then
		local _input_extension = self._input_extension
		local get_9 = _input_extension:get("ping")
		local get_10 = _input_extension:get("ping_only")
		local get_11 = _input_extension:get("social_wheel_only")
		local get_12 = _input_extension:get("weapon_poses_only")
		local get_13 = _input_extension:get("photomode_only")
		local var_16_18

		if Managers.mechanism:current_mechanism_name() == "versus" then
			var_16_18 = _input_extension:get("ping_only_movement")
		end

		if get_9 or get_10 or var_16_18 or get_11 or get_12 or not get_13 then
			local _check_raycast, var_16_20, var_16_21, var_16_22, var_16_23 = self:_check_raycast(arg_16_4)

			if not get_10 then
				var_16_23 = nil
			end

			local var_16_24

			if not var_16_23 then
				self._ping_position:store(var_16_23)

				var_16_24 = self._ping_position
			end

			local flag = self._double_press_counter >= 1
			local var_16_26

			if get_9 or not self._status_extension:is_ready_for_assisted_respawn() then
				local get_service = Managers.input:get_service("Player")

				if not get_service then
					get_11 = get_service:get("ping")
				end
			elseif not _check_raycast then
				local has_extension = ScriptUnit.has_extension(_check_raycast, "status_system")

				if not has_extension and not has_extension:is_knocked_down() then
					var_16_26 = PingTypes.UNIT_DOWNED
				end
			elseif (flag or not var_16_23) and not self._ping_system:is_ping_cancel(self._player:unique_id(), var_16_23) then
				var_16_26 = PingTypes.CANCEL
			end

			if not get_10 and not _check_raycast then
				self:ping_attempt(arg_16_4, _check_raycast, arg_16_1, var_16_26 or PingTypes.CONTEXT)
			end

			if not get_9 then
				local user_setting = Application.user_setting("social_wheel_delay")

				user_setting = user_setting or DefaultUserSettings.get("user_settings", "social_wheel_delay")
				self._ping_context = {
					unit = _check_raycast,
					max_t = self:_get_ping_context_lifetime_t(arg_16_1, user_setting),
					distance = var_16_21,
					position = var_16_24,
					ping_type = var_16_26,
					is_double_press = flag,
					fallback_to_world_marker = not var_16_18 and var_16_24
				}
				self._social_wheel_context = {
					unit = var_16_20,
					ping_context_unit = _check_raycast,
					min_t = self:_get_ping_context_lifetime_t(arg_16_1, user_setting),
					distance = var_16_22,
					position = var_16_24
				}

				if not Managers.state.game_mode:setting("allow_double_ping") then
					self:_start_listen_for_double_press(arg_16_1)
				end

				self._can_ping = true
			elseif not var_16_18 and not var_16_23 then
				local var_16_30

				self:ping_world_position_attempt(arg_16_4, var_16_23, arg_16_1, var_16_26 or PingTypes.CONTEXT, var_16_30, flag)

				if not Managers.state.game_mode:setting("allow_double_ping") then
					self:_start_listen_for_double_press(arg_16_1)
				end
			end

			if not get_11 then
				self._social_wheel_context = {
					min_t = 0,
					unit = var_16_20,
					distance = var_16_22,
					position = var_16_24
				}
			end

			if not get_12 then
				self._social_wheel_context = {
					min_t = 0,
					show_poses = true
				}
			end

			if not get_13 then
				self._social_wheel_context = {
					min_t = 0,
					show_emotes = true,
					unit = var_16_20,
					distance = var_16_22,
					position = var_16_24
				}
			end
		end
	end

	if not self._listen_for_double_press then
		if arg_16_1 >= self._double_press_end_time then
			self:_reset_listen_for_double_press()
		elseif self._input_extension:get("ping") or not self._input_extension:get("ping_only_movement") then
			self._double_press_counter = self._double_press_counter + 1

			self:_start_listen_for_double_press(arg_16_1)
		end
	end
end

ContextAwarePingExtension._start_listen_for_double_press = function (self, arg_17_1)
	-- function 17
	self._listen_for_double_press = true
	self._double_press_start_time = arg_17_1
	self._double_press_end_time = arg_17_1 + self._double_press_listen_duration
end

ContextAwarePingExtension._reset_listen_for_double_press = function (self)
	-- function 18
	self._double_press_start_time = nil
	self._double_press_end_time = nil
	self._double_press_counter = 0
	self._listen_for_double_press = false
end

ContextAwarePingExtension._get_ping_context_lifetime_t = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not Managers.state.game_mode:setting("extended_social_wheel_time") then
		return arg_19_1 + arg_19_2 + self._double_press_listen_duration
	else
		return arg_19_1 + arg_19_2
	end
end
