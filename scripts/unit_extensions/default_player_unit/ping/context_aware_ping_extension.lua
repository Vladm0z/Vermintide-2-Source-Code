-- chunkname: @scripts/unit_extensions/default_player_unit/ping/context_aware_ping_extension.lua

local var_0_0 = 2
local var_0_1 = 2.5
local var_0_2 = 0.2
local var_0_3 = 0.15
local var_0_4 = 50

ContextAwarePingExtension = class(ContextAwarePingExtension)

function ContextAwarePingExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._physics_world = World.get_data(arg_1_0._world, "physics_world")
	arg_1_0._unit = arg_1_2
	arg_1_0._player = arg_1_3.player
	arg_1_0._ping_context = nil
	arg_1_0._social_wheel_context = nil
	arg_1_0._ping_position = Vector3Box()
	arg_1_0._num_free_events = var_0_0
	arg_1_0._num_free_combat_events = var_0_0
	arg_1_0._last_update_t = 0

	local var_1_0 = Managers.state.game_mode:settings().ping_mode

	if var_1_0 then
		arg_1_0._world_markers_enabled = var_1_0.world_markers
	else
		arg_1_0._world_markers_enabled = false
	end

	arg_1_0._double_press_start_time = nil
	arg_1_0._double_press_end_time = nil
	arg_1_0._double_press_listen_duration = 0.25
	arg_1_0._double_press_counter = 0
	arg_1_0._can_ping = false
	arg_1_0._listen_for_double_press = false
	arg_1_0._ping_system = Managers.state.entity:system("ping_system")
end

function ContextAwarePingExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._input_extension = ScriptUnit.extension(arg_2_2, "input_system")
	arg_2_0._first_person_extension = ScriptUnit.extension(arg_2_2, "first_person_system")
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
end

function ContextAwarePingExtension.ping_context(arg_3_0)
	return arg_3_0._ping_context
end

function ContextAwarePingExtension.social_wheel_context(arg_4_0)
	return arg_4_0._social_wheel_context
end

function ContextAwarePingExtension.destroy(arg_5_0)
	return
end

function ContextAwarePingExtension.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if arg_6_0._num_free_events < var_0_0 then
		local var_6_0 = (arg_6_5 - arg_6_0._last_update_t) / var_0_1

		arg_6_0._num_free_events = math.min(arg_6_0._num_free_events + var_6_0, var_0_0)
	end

	if arg_6_0._num_free_combat_events < var_0_0 then
		local var_6_1 = (arg_6_5 - arg_6_0._last_update_t) / var_0_2

		arg_6_0._num_free_combat_events = math.min(arg_6_0._num_free_combat_events + var_6_1, var_0_0)
	end

	arg_6_0:_handle_ping_input(arg_6_5, arg_6_3, arg_6_2, arg_6_1, arg_6_4)

	arg_6_0._last_update_t = arg_6_5
end

function ContextAwarePingExtension._have_free_events(arg_7_0)
	return arg_7_0._num_free_events > 0
end

function ContextAwarePingExtension._have_free_combat_events(arg_8_0)
	return arg_8_0._num_free_combat_events > 0
end

function ContextAwarePingExtension._consume_ping_event(arg_9_0)
	arg_9_0._num_free_events = arg_9_0._num_free_events - 1
end

function ContextAwarePingExtension._consume_combat_ping_event(arg_10_0)
	arg_10_0._num_free_combat_events = arg_10_0._num_free_combat_events - 1
end

function ContextAwarePingExtension.ping_attempt(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	if not IgnoreFreeEvents[arg_11_4] and not arg_11_0:_have_free_events() then
		if arg_11_4 ~= nil then
			local var_11_0 = Localize("social_wheel_too_many_messages_warning")

			Managers.chat:add_local_system_message(1, var_11_0, true)
		end

		return false
	elseif not IgnoreFreeCombatEvents[arg_11_4] and not arg_11_0:_have_free_combat_events() then
		return false
	end

	if not Unit.alive(arg_11_2) or LEVEL_EDITOR_TEST then
		return false
	end

	arg_11_5 = arg_11_4 ~= PingTypes.LOCAL_ONLY and arg_11_5 or NetworkLookup.social_wheel_events["n/a"]

	local var_11_1 = Managers.state.network
	local var_11_2 = var_11_1:unit_game_object_id(arg_11_1)
	local var_11_3, var_11_4 = var_11_1:game_object_or_level_id(arg_11_2)

	arg_11_4 = arg_11_4 or arg_11_0._world_markers_enabled and PingTypes.CONTEXT or PingTypes.PING_ONLY

	var_11_1.network_transmit:send_rpc_server("rpc_ping_unit", var_11_2, var_11_3, var_11_4, false, arg_11_4, arg_11_5)

	if not IgnoreFreeEvents[arg_11_4] then
		arg_11_0:_consume_ping_event()
	elseif not IgnoreFreeCombatEvents[arg_11_4] then
		arg_11_0:_consume_combat_ping_event()
	end

	return true
end

function ContextAwarePingExtension.ping_world_position_attempt(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	if not arg_12_0._world_markers_enabled then
		return
	end

	arg_12_4 = arg_12_4 or PingTypes.CONTEXT
	arg_12_6 = not not arg_12_6

	if not arg_12_0._world_markers_enabled then
		return
	end

	if arg_12_3 < (arg_12_0._world_marker_cooldown or 0) then
		return
	end

	if not arg_12_0:_have_free_events() then
		local var_12_0 = Localize("social_wheel_too_many_messages_warning")

		Managers.chat:add_local_system_message(1, var_12_0, true)

		return false
	elseif not arg_12_0:_have_free_combat_events() then
		return false
	end

	if LEVEL_EDITOR_TEST then
		return false
	end

	arg_12_0._world_marker_cooldown = arg_12_3 + var_0_3
	arg_12_5 = arg_12_5 or NetworkLookup.social_wheel_events["n/a"]

	local var_12_1 = Managers.state.network
	local var_12_2 = var_12_1:unit_game_object_id(arg_12_1)

	var_12_1.network_transmit:send_rpc_server("rpc_ping_world_position", var_12_2, arg_12_2, arg_12_4, arg_12_5, arg_12_6)

	if not IgnoreFreeEvents[arg_12_4] then
		arg_12_0:_consume_ping_event()
	elseif not IgnoreFreeCombatEvents[arg_12_4] then
		arg_12_0:_consume_combat_ping_event()
	end

	return true
end

function ContextAwarePingExtension.social_message_attempt(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if not arg_13_0:_have_free_events() then
		local var_13_0 = Localize("social_wheel_too_many_messages_warning")

		Managers.chat:add_local_system_message(1, var_13_0, true)

		return false
	end

	if LEVEL_EDITOR_TEST then
		return false
	end

	arg_13_2 = arg_13_2 or NetworkLookup.social_wheel_events["n/a"]

	local var_13_1 = Managers.state.network
	local var_13_2 = var_13_1:unit_game_object_id(arg_13_1)
	local var_13_3 = arg_13_3 and Unit.alive(arg_13_3) and var_13_1:unit_game_object_id(arg_13_3) or 0

	var_13_1.network_transmit:send_rpc_server("rpc_social_message", var_13_2, arg_13_2, var_13_3)
	arg_13_0:_consume_ping_event()

	return true
end

local var_0_5 = 1
local var_0_6 = 2
local var_0_7 = 4
local var_0_8 = {}

function ContextAwarePingExtension._check_raycast(arg_14_0, arg_14_1)
	local var_14_0
	local var_14_1
	local var_14_2
	local var_14_3
	local var_14_4
	local var_14_5 = Managers.state.entity:system("darkness_system")
	local var_14_6 = arg_14_0._first_person_extension
	local var_14_7 = var_14_6:current_position()
	local var_14_8 = var_14_6:current_rotation()
	local var_14_9 = Quaternion.forward(var_14_8)
	local var_14_10 = Quaternion.right(var_14_8)
	local var_14_11 = Quaternion.up(var_14_8)
	local var_14_12, var_14_13 = arg_14_0._physics_world:immediate_raycast(var_14_7, var_14_9, var_0_4, "all", "collision_filter", "filter_ray_ping")
	local var_14_14 = -math.huge
	local var_14_15 = 2000

	for iter_14_0 = 1, var_14_13 do
		local var_14_16 = var_14_12[iter_14_0]
		local var_14_17 = var_14_16[var_0_7]
		local var_14_18 = var_14_16[var_0_5]
		local var_14_19 = var_14_16[var_0_6]

		if var_14_17 then
			local var_14_20 = Actor.unit(var_14_17)

			if var_14_20 ~= arg_14_1 then
				local var_14_21 = ScriptUnit.has_extension(var_14_20, "ping_system")

				if var_14_21 then
					local var_14_22 = ScriptUnit.has_extension(var_14_20, "ghost_mode_system")

					if (not var_14_22 or not var_14_22:is_in_ghost_mode()) and var_14_19 > 0.05 then
						local var_14_23 = ScriptUnit.has_extension(var_14_20, "status_system")
						local var_14_24 = ScriptUnit.has_extension(var_14_20, "pickup_system")
						local var_14_25 = Unit.get_data(var_14_20, "breed")
						local var_14_26 = var_14_25 ~= nil
						local var_14_27 = HEALTH_ALIVE[var_14_20]
						local var_14_28
						local var_14_29

						if var_14_24 then
							local var_14_30, var_14_31 = Unit.box(var_14_20, true)

							var_14_28 = var_14_31.x * 0.75
							var_14_29 = var_14_31.z * 0.75
						elseif var_14_26 then
							var_14_29 = (var_14_25.aoe_height or DEFAULT_BREED_AOE_HEIGHT) * 0.5
							var_14_28 = var_14_25.aoe_radius or DEFAULT_BREED_AOE_RADIUS
						elseif var_14_23 then
							local var_14_32, var_14_33 = Unit.box(var_14_20, true)

							var_14_28 = var_14_33.x * 0.75
							var_14_29 = var_14_33.z
						else
							var_14_28 = 0.25
							var_14_29 = 0.25
						end

						local var_14_34 = var_14_18 - (Unit.local_position(var_14_20, 0) + Vector3(0, 0, var_14_29))
						local var_14_35 = math.abs(Vector3.dot(var_14_34, var_14_10))
						local var_14_36 = math.abs(Vector3.dot(var_14_34, var_14_11))
						local var_14_37 = 0.01
						local var_14_38 = var_14_35 <= var_14_28 + var_14_37 and var_14_36 <= var_14_29 + var_14_37
						local var_14_39

						if var_14_38 then
							var_14_39 = math.huge
						else
							local var_14_40 = math.atan(var_14_28 / var_14_19)
							local var_14_41 = math.atan(var_14_29 / var_14_19)
							local var_14_42 = math.atan(var_14_35 / var_14_19)
							local var_14_43 = math.atan(var_14_36 / var_14_19)

							var_14_39 = 1 / (math.max(var_14_42 - var_14_40, var_14_37) / math.log(var_14_40) * (math.max(var_14_43 - var_14_41, var_14_37) / math.log(var_14_40)))
						end

						local var_14_44 = var_14_26 and Managers.state.side:is_enemy(arg_14_0._unit, var_14_20)
						local var_14_45 = var_14_23 and var_14_23:is_disabled()

						if (var_14_21.always_pingable or var_14_24 or var_14_27 and (var_14_44 or var_14_45)) and not var_14_5:is_in_darkness(var_14_18) and var_14_14 < var_14_39 then
							var_14_0 = var_14_20
							var_14_2 = var_14_19
							var_14_14 = var_14_39
							var_14_4 = var_14_18
						end

						local var_14_46 = false

						if var_14_24 then
							local var_14_47 = var_14_24:get_pickup_settings()

							var_14_46 = var_14_47.slot_name or var_14_47.type == "ammo"
						end

						if (var_14_46 and var_14_19 <= INTERACT_RAY_DISTANCE or var_14_27 and var_14_23) and var_14_15 < var_14_39 then
							var_14_1 = var_14_20
							var_14_3 = var_14_19
							var_14_15 = var_14_39
						end
					end
				elseif Unit.get_data(var_14_20, "breed") then
					-- block empty
				else
					var_14_4 = var_14_18

					break
				end
			end
		end
	end

	if not var_14_0 and var_14_4 then
		local var_14_48 = Managers.state.side.side_by_unit[arg_14_0._unit]

		if var_14_48:name() == "dark_pact" then
			local var_14_49 = var_0_8
			local var_14_50 = 0
			local var_14_51 = var_14_48.ENEMY_PLAYER_AND_BOT_UNITS

			for iter_14_1 = 1, #var_14_51 do
				local var_14_52 = var_14_51[iter_14_1]
				local var_14_53 = POSITION_LOOKUP[var_14_52]

				if var_14_53 then
					local var_14_54 = var_14_53 + Vector3.up()

					if arg_14_0:_is_camera_looking_at_position(var_14_54, var_14_4, 0.075) then
						var_14_50 = var_14_50 + 1
						var_14_49[var_14_50] = var_14_52
					end
				end
			end

			local var_14_55
			local var_14_56 = math.huge

			for iter_14_2 = 1, var_14_50 do
				local var_14_57 = POSITION_LOOKUP[var_14_49[iter_14_2]]
				local var_14_58 = Vector3.distance_squared(var_14_57, var_14_7)

				if var_14_58 < var_14_56 then
					var_14_55 = var_14_49[iter_14_2]
					var_14_56 = var_14_58
				end
			end

			if var_14_55 then
				var_14_0 = var_14_55
				var_14_2 = math.sqrt(var_14_56)
			end
		end
	end

	return var_14_0, var_14_1, var_14_2, var_14_3, var_14_4
end

function ContextAwarePingExtension._is_camera_looking_at_position(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_0._first_person_extension:camera()

	if Camera.inside_frustum(var_15_0, arg_15_2) then
		local var_15_1 = ScriptCamera.world_to_screen_uv(var_15_0, arg_15_2)
		local var_15_2 = arg_15_3 * arg_15_3

		if Camera.inside_frustum(var_15_0, arg_15_1) then
			local var_15_3 = ScriptCamera.world_to_screen_uv(var_15_0, arg_15_1)

			if var_15_2 >= Vector3.distance_squared(var_15_3, var_15_1) then
				return true
			end
		end
	end
end

function ContextAwarePingExtension._handle_ping_input(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	if arg_16_0._ping_context and arg_16_0._can_ping then
		local var_16_0 = arg_16_0._ping_context
		local var_16_1 = arg_16_0._input_extension:get("ping_release")
		local var_16_2 = arg_16_0._input_extension:get("ping_hold")

		if var_16_1 or not var_16_2 then
			local var_16_3 = var_16_0.unit
			local var_16_4 = var_16_0.ping_type

			if arg_16_1 <= var_16_0.max_t then
				if Unit.alive(var_16_3) then
					arg_16_0:ping_attempt(arg_16_4, var_16_3, arg_16_1, var_16_4)
				elseif var_16_0.fallback_to_world_marker then
					local var_16_5

					arg_16_0:ping_world_position_attempt(arg_16_4, var_16_0.position:unbox(), arg_16_1, var_16_4 or PingTypes.CONTEXT, var_16_5, var_16_0.is_double_press)

					if Managers.state.game_mode:setting("allow_double_ping") then
						arg_16_0:_start_listen_for_double_press(arg_16_1)
					end
				end
			end

			arg_16_0._ping_context = nil
			arg_16_0._social_wheel_context = nil
			arg_16_0._can_ping = false
		end
	elseif arg_16_0._social_wheel_context then
		local var_16_6 = arg_16_0._input_extension:get("social_wheel_only_release")
		local var_16_7 = arg_16_0._input_extension:get("social_wheel_only_hold")
		local var_16_8 = arg_16_0._input_extension:get("weapon_poses_only_release")
		local var_16_9 = arg_16_0._input_extension:get("weapon_poses_only_hold")
		local var_16_10 = arg_16_0._input_extension:get("photomode_only_released")
		local var_16_11 = arg_16_0._input_extension:get("photomode_only_hold")

		if not arg_16_0._input_extension:get("ping_hold") or (var_16_6 or not var_16_7) and (var_16_8 or not var_16_9) and (var_16_10 or not var_16_11) then
			arg_16_0._social_wheel_context = nil
			arg_16_0._can_ping = false
		end
	elseif not arg_16_0._can_ping then
		local var_16_12 = arg_16_0._input_extension
		local var_16_13 = var_16_12:get("ping")
		local var_16_14 = var_16_12:get("ping_only")
		local var_16_15 = var_16_12:get("social_wheel_only")
		local var_16_16 = var_16_12:get("weapon_poses_only")
		local var_16_17 = var_16_12:get("photomode_only")
		local var_16_18

		if Managers.mechanism:current_mechanism_name() == "versus" then
			var_16_18 = var_16_12:get("ping_only_movement")
		end

		if var_16_13 or var_16_14 or var_16_18 or var_16_15 or var_16_16 or var_16_17 then
			local var_16_19, var_16_20, var_16_21, var_16_22, var_16_23 = arg_16_0:_check_raycast(arg_16_4)

			if var_16_14 then
				var_16_23 = nil
			end

			local var_16_24

			if var_16_23 then
				arg_16_0._ping_position:store(var_16_23)

				var_16_24 = arg_16_0._ping_position
			end

			local var_16_25 = arg_16_0._double_press_counter >= 1
			local var_16_26

			if not var_16_13 and arg_16_0._status_extension:is_ready_for_assisted_respawn() then
				local var_16_27 = Managers.input:get_service("Player")

				if var_16_27 then
					var_16_15 = var_16_27:get("ping")
				end
			elseif var_16_19 then
				local var_16_28 = ScriptUnit.has_extension(var_16_19, "status_system")

				if var_16_28 and var_16_28:is_knocked_down() then
					var_16_26 = PingTypes.UNIT_DOWNED
				end
			elseif not var_16_25 and var_16_23 and arg_16_0._ping_system:is_ping_cancel(arg_16_0._player:unique_id(), var_16_23) then
				var_16_26 = PingTypes.CANCEL
			end

			if var_16_14 and var_16_19 then
				arg_16_0:ping_attempt(arg_16_4, var_16_19, arg_16_1, var_16_26 or PingTypes.CONTEXT)
			end

			if var_16_13 then
				local var_16_29 = Application.user_setting("social_wheel_delay") or DefaultUserSettings.get("user_settings", "social_wheel_delay")

				arg_16_0._ping_context = {
					unit = var_16_19,
					max_t = arg_16_0:_get_ping_context_lifetime_t(arg_16_1, var_16_29),
					distance = var_16_21,
					position = var_16_24,
					ping_type = var_16_26,
					is_double_press = var_16_25,
					fallback_to_world_marker = var_16_18 and var_16_24
				}
				arg_16_0._social_wheel_context = {
					unit = var_16_20,
					ping_context_unit = var_16_19,
					min_t = arg_16_0:_get_ping_context_lifetime_t(arg_16_1, var_16_29),
					distance = var_16_22,
					position = var_16_24
				}

				if Managers.state.game_mode:setting("allow_double_ping") then
					arg_16_0:_start_listen_for_double_press(arg_16_1)
				end

				arg_16_0._can_ping = true
			elseif var_16_18 and var_16_23 then
				local var_16_30

				arg_16_0:ping_world_position_attempt(arg_16_4, var_16_23, arg_16_1, var_16_26 or PingTypes.CONTEXT, var_16_30, var_16_25)

				if Managers.state.game_mode:setting("allow_double_ping") then
					arg_16_0:_start_listen_for_double_press(arg_16_1)
				end
			end

			if var_16_15 then
				arg_16_0._social_wheel_context = {
					min_t = 0,
					unit = var_16_20,
					distance = var_16_22,
					position = var_16_24
				}
			end

			if var_16_16 then
				arg_16_0._social_wheel_context = {
					min_t = 0,
					show_poses = true
				}
			end

			if var_16_17 then
				arg_16_0._social_wheel_context = {
					min_t = 0,
					show_emotes = true,
					unit = var_16_20,
					distance = var_16_22,
					position = var_16_24
				}
			end
		end
	end

	if arg_16_0._listen_for_double_press then
		if arg_16_1 >= arg_16_0._double_press_end_time then
			arg_16_0:_reset_listen_for_double_press()
		elseif arg_16_0._input_extension:get("ping") or arg_16_0._input_extension:get("ping_only_movement") then
			arg_16_0._double_press_counter = arg_16_0._double_press_counter + 1

			arg_16_0:_start_listen_for_double_press(arg_16_1)
		end
	end
end

function ContextAwarePingExtension._start_listen_for_double_press(arg_17_0, arg_17_1)
	arg_17_0._listen_for_double_press = true
	arg_17_0._double_press_start_time = arg_17_1
	arg_17_0._double_press_end_time = arg_17_1 + arg_17_0._double_press_listen_duration
end

function ContextAwarePingExtension._reset_listen_for_double_press(arg_18_0)
	arg_18_0._double_press_start_time = nil
	arg_18_0._double_press_end_time = nil
	arg_18_0._double_press_counter = 0
	arg_18_0._listen_for_double_press = false
end

function ContextAwarePingExtension._get_ping_context_lifetime_t(arg_19_0, arg_19_1, arg_19_2)
	if Managers.state.game_mode:setting("extended_social_wheel_time") then
		return arg_19_1 + arg_19_2 + arg_19_0._double_press_listen_duration
	else
		return arg_19_1 + arg_19_2
	end
end
