-- chunkname: @scripts/unit_extensions/level/payload_extension.lua

require("scripts/settings/payload_speed_settings")
require("foundation/scripts/util/spline_curve")

local var_0_0 = 100
local var_0_1 = 0.5
local var_0_2 = 0.1
local var_0_3 = 0.01

PayloadExtension = class(PayloadExtension)

PayloadExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world
	local var_1_1 = Managers.state.network

	arg_1_0._unit = arg_1_2
	arg_1_0._world = var_1_0
	arg_1_0._is_server = Managers.player.is_server
	arg_1_0._game = var_1_1:game()
	arg_1_0._network_manager = var_1_1
	arg_1_0._extra_joint = nil

	local var_1_2 = LevelHelper:current_level(var_1_0)

	arg_1_0._level_unit_index = Level.unit_index(var_1_2, arg_1_2)
	arg_1_0._last_synched_spline_values = {
		last_synch_time = 0,
		error_compensation_speed = 0,
		spline_index = 1,
		subdivision_index = 1,
		spline_t = 0
	}
	arg_1_0._stop_command_given = false
	arg_1_0._activated = true
	arg_1_0._started = false
	arg_1_0._use_statemachine = false
	arg_1_0._speed_var_index = 0

	if Unit.has_data(arg_1_2, "payload_statemachine_speed_var") then
		local var_1_3 = Unit.get_data(arg_1_2, "payload_statemachine_speed_var")

		if Unit.animation_has_variable(arg_1_2, var_1_3) then
			arg_1_0._speed_var_index = Unit.animation_find_variable(arg_1_2, var_1_3)
			arg_1_0._use_statemachine = true
		end
	end

	local var_1_4 = Unit.get_data(arg_1_2, "wheel_diameter")
	local var_1_5 = 60

	if Unit.has_data(arg_1_2, "payload_wheel_frames") then
		var_1_5 = Unit.get_data(arg_1_2, "payload_wheel_frames")

		if var_1_5 == 0 then
			var_1_5 = 60
		end
	end

	arg_1_0._anim_speed = 30 / var_1_5 * var_1_4 * math.pi
	arg_1_0._anim_group = "wheels"

	if Unit.has_data(arg_1_2, "wheel_anim_group") then
		arg_1_0._anim_group = Unit.get_data(arg_1_2, "wheel_anim_group")
	end

	if not DEDICATED_SERVER then
		local var_1_6 = Unit.get_data(arg_1_2, "hazard_type")
		local var_1_7 = Managers.player:local_player()
		local var_1_8 = Managers.player:statistics_db()
		local var_1_9 = var_1_7:stats_id()

		if var_1_6 == "sled" and (var_1_8:get_persistent_stat(var_1_9, "trail_sleigher") <= 50 or false) then
			Managers.state.event:register(arg_1_0, "on_killed", "increment_kill_stat")
		end
	end

	arg_1_0._side = Managers.state.side:get_side_from_name("heroes")
	arg_1_0._enemy_broadphase_categories = arg_1_0._side.enemy_broadphase_categories
end

PayloadExtension.activate = function (arg_2_0)
	arg_2_0._activated = true
end

PayloadExtension.deactivate = function (arg_3_0, arg_3_1)
	arg_3_0._activated = false
	arg_3_0._stop_command_given = arg_3_1
end

PayloadExtension.destroy = function (arg_4_0)
	Managers.state.event:unregister("on_killed", arg_4_0)
end

PayloadExtension.extensions_ready = function (arg_5_0)
	return
end

PayloadExtension.hot_join_sync = function (arg_6_0, arg_6_1)
	return
end

PayloadExtension.init_payload = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._unit

	arg_7_0._spline_curve = arg_7_0:_init_movement_spline(arg_7_0._world, var_7_0, arg_7_1)

	local var_7_1 = Unit.get_data(var_7_0, "extra_spline_joint")

	if var_7_1 then
		local var_7_2 = arg_7_0:_init_movement_spline(arg_7_0._world, var_7_0, arg_7_1)
		local var_7_3 = Unit.node(var_7_0, var_7_1)
		local var_7_4 = Vector3.distance(Vector3.flat(Unit.world_position(var_7_0, var_7_3)), Vector3.flat(Unit.local_position(var_7_0, 0)))
		local var_7_5 = Quaternion.forward(Unit.local_rotation(var_7_0, 0)) * var_7_4
		local var_7_6 = var_7_2:movement()
		local var_7_7 = var_7_4 / 1

		var_7_6:set_speed(1)

		while var_7_7 > 0 do
			local var_7_8 = var_7_6:_current_spline_subdivision().length

			if var_7_8 <= var_7_7 then
				var_7_6:update(var_7_8)

				var_7_7 = var_7_7 - var_7_8
			else
				var_7_6:update(var_7_7)

				var_7_7 = 0
			end
		end

		arg_7_0._extra_joint = {
			spline = var_7_2,
			node = var_7_3
		}
	end

	if arg_7_0._is_server then
		arg_7_0:_create_game_object()
	end
end

PayloadExtension.movement = function (arg_8_0)
	return arg_8_0._spline_curve:movement()
end

PayloadExtension._push_player = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._unit
	local var_9_1 = POSITION_LOOKUP[var_9_0]
	local var_9_2, var_9_3 = Unit.box(var_9_0, true)
	local var_9_4 = POSITION_LOOKUP[arg_9_1]
	local var_9_5 = var_9_3 * 1.2

	if math.point_is_inside_oobb(var_9_4, var_9_2, var_9_5) then
		local var_9_6 = Vector3.flat(var_9_1)
		local var_9_7 = Vector3.flat(var_9_4)
		local var_9_8 = Vector3.normalize(var_9_7 - var_9_6) * arg_9_2

		ScriptUnit.extension(arg_9_1, "locomotion_system"):add_external_velocity(var_9_8)
	end
end

local var_0_4 = {}
local var_0_5 = {}

PayloadExtension._hit_enemies = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._unit
	local var_10_1 = POSITION_LOOKUP[var_10_0]
	local var_10_2 = Vector3.flat(var_10_1)
	local var_10_3, var_10_4 = Unit.box(var_10_0, true)
	local var_10_5 = Vector3.normalize(Matrix4x4.forward(var_10_3))
	local var_10_6 = var_10_4.x > var_10_4.y and var_10_4.x or var_10_4.y

	var_10_6 = var_10_6 > var_10_4.z and var_10_6 or var_10_4.z

	local var_10_7 = var_10_6 * 2
	local var_10_8 = var_10_4 * 1.2
	local var_10_9 = var_10_4 * 2
	local var_10_10 = Unit.get_data(var_10_0, "hazard_type") or "payload"
	local var_10_11 = EnvironmentalHazards[var_10_10]
	local var_10_12 = "torso"
	local var_10_13
	local var_10_14 = var_10_10
	local var_10_15 = Managers.state.difficulty:get_difficulty_rank()
	local var_10_16 = var_10_11.enemy.difficulty_power_level[var_10_15] or var_10_11.enemy.difficulty_power_level[2] or DefaultPowerLevel
	local var_10_17 = var_10_11.enemy.damage_profile or "default"
	local var_10_18 = DamageProfileTemplates[var_10_17]
	local var_10_19
	local var_10_20 = 0
	local var_10_21 = false
	local var_10_22 = var_10_11.enemy.can_damage or false
	local var_10_23 = var_10_11.enemy.can_stagger or true
	local var_10_24 = false
	local var_10_25 = false
	local var_10_26 = AiUtils.broadphase_query(var_10_1, var_10_7, var_0_4, arg_10_0._enemy_broadphase_categories)

	for iter_10_0 = 1, var_10_26 do
		local var_10_27 = var_0_4[iter_10_0]
		local var_10_28 = POSITION_LOOKUP[var_10_27]
		local var_10_29 = math.point_is_inside_oobb(var_10_28, var_10_3, var_10_8)
		local var_10_30 = math.point_is_inside_oobb(var_10_28, var_10_3, var_10_9)

		if var_10_29 and not var_0_5[var_10_27] then
			var_0_5[var_10_27] = true

			local var_10_31 = 0.5

			if Vector3.dot(var_10_5, var_10_28 - var_10_1) > 0 and arg_10_1 > 2 then
				var_10_31 = arg_10_1 * 1.3
			end

			local var_10_32 = var_10_16 * var_10_31
			local var_10_33 = Vector3.flat(var_10_28)
			local var_10_34 = Vector3.normalize(var_10_33 - var_10_2)

			DamageUtils.server_apply_hit(arg_10_2, var_10_0, var_10_27, var_10_12, nil, var_10_34, var_10_13, var_10_14, var_10_32, var_10_18, var_10_19, var_10_20, var_10_21, var_10_22, var_10_23, var_10_24, var_10_25)
		elseif not var_10_29 and var_10_30 and var_0_5[var_10_27] then
			var_0_5[var_10_27] = false
		end
	end
end

PayloadExtension.update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0, var_11_1 = arg_11_0:_players_in_proximity()
	local var_11_2 = var_11_0 > 0
	local var_11_3 = arg_11_0._unit
	local var_11_4 = Managers.state.network:game()
	local var_11_5 = arg_11_0._id
	local var_11_6 = 0
	local var_11_7 = arg_11_0._spline_curve
	local var_11_8 = arg_11_0._spline_curve:movement()
	local var_11_9 = var_11_8:_current_spline().metadata
	local var_11_10 = var_11_8:current_spline_index()

	if var_11_5 and var_11_4 then
		if arg_11_0._is_server then
			local var_11_11 = var_11_9.speed_settings
			local var_11_12 = var_11_2 and var_11_11.pushed or var_11_11.not_pushed
			local var_11_13 = (var_11_12.bonus_speed_per_player or 0) * var_11_0
			local var_11_14 = var_11_12.speed + var_11_13
			local var_11_15 = var_11_12.acceleration

			if var_11_14 > 0 and arg_11_0._previous_status == "end" or var_11_14 < 0 and arg_11_0._previous_status == "start" or not arg_11_0._activated then
				var_11_14 = 0
			end

			local var_11_16 = false
			local var_11_17 = var_11_8:speed()
			local var_11_18 = var_11_14 - var_11_17

			if arg_11_0._stop_command_given then
				arg_11_0._stop_command_given = false
				var_11_6 = 0
			elseif var_11_18 > 0 then
				var_11_6 = math.min(var_11_17 + var_11_15 * arg_11_3, var_11_14)
			elseif var_11_18 < 0 then
				var_11_6 = math.max(var_11_17 - var_11_15 * arg_11_3, var_11_14)
			else
				var_11_6 = var_11_14
			end

			if var_11_17 > 0 and var_11_6 < 0 then
				Unit.flow_event(var_11_3, "lua_start_moving_backwards")
			end

			GameSession.set_game_object_field(var_11_4, var_11_5, "speed", var_11_6)

			local var_11_19 = var_11_8:current_subdivision_index()
			local var_11_20 = var_11_8:current_t()

			GameSession.set_game_object_field(var_11_4, var_11_5, "spline_index", var_11_10)
			GameSession.set_game_object_field(var_11_4, var_11_5, "subdivision_index", var_11_19)
			GameSession.set_game_object_field(var_11_4, var_11_5, "spline_t", var_11_20)

			local var_11_21 = var_11_9.flow_event_data
			local var_11_22 = var_11_21.flow_event
			local var_11_23 = var_11_21.event_thrown
			local var_11_24 = math.abs(var_11_6)

			if var_11_2 and var_11_24 > 0.1 then
				for iter_11_0 = 1, var_11_0 do
					arg_11_0:_push_player(var_11_1[iter_11_0], var_11_24)
				end
			end

			if var_11_24 > 0 then
				arg_11_0:_hit_enemies(var_11_24, arg_11_5)
			end

			if var_11_10 ~= arg_11_0._previous_spline_index and var_11_22 and not var_11_23 then
				LevelHelper:flow_event(arg_11_0._world, var_11_22)

				var_11_21.event_thrown = true

				local var_11_25 = arg_11_0._network_manager
				local var_11_26 = var_11_25.network_transmit
				local var_11_27 = var_11_25:game_object_or_level_id(var_11_3)

				var_11_26:send_rpc_clients("rpc_payload_flow_event", var_11_27, var_11_10)
			end
		else
			local var_11_28 = arg_11_0:_error_speed_calculation(arg_11_3, arg_11_5, var_11_4, var_11_5, var_11_8)

			var_11_6 = GameSession.game_object_field(var_11_4, var_11_5, "speed") + var_11_28
		end
	end

	var_11_8:set_speed(var_11_6)

	local var_11_29 = var_11_8:update(arg_11_3, arg_11_5)

	if arg_11_0._state ~= "stopped" and math.abs(var_11_6) < var_0_3 then
		arg_11_0._state = "stopped"

		Unit.flow_event(var_11_3, "lua_stopped")
	elseif arg_11_0._state ~= "moving" and math.abs(var_11_6) >= var_0_3 then
		if not arg_11_0._started then
			Unit.flow_event(var_11_3, "lua_start")

			arg_11_0._started = true
		end

		arg_11_0._state = "moving"

		Unit.flow_event(var_11_3, "lua_moving")
	elseif var_11_29 == "end" and arg_11_0._previous_status ~= "end" then
		Unit.flow_event(var_11_3, "lua_end")
	end

	arg_11_0._previous_status = var_11_29
	arg_11_0._previous_spline_index = var_11_10

	if arg_11_0._use_statemachine then
		Unit.animation_set_variable(arg_11_0._unit, arg_11_0._speed_var_index, var_11_6 / arg_11_0._anim_speed)
	else
		Unit.set_simple_animation_speed(arg_11_0._unit, var_11_6 / arg_11_0._anim_speed, arg_11_0._anim_group)
	end

	Unit.set_local_position(var_11_3, 0, var_11_8:current_position())

	local var_11_30 = var_11_8:current_tangent_direction()
	local var_11_31 = Quaternion.look(var_11_30, Vector3.up())

	Unit.set_local_rotation(var_11_3, 0, var_11_31)

	if arg_11_0._extra_joint then
		local var_11_32 = Quaternion.inverse(var_11_31)
		local var_11_33 = arg_11_0._extra_joint.spline:movement()

		var_11_33:set_speed(var_11_6)
		var_11_33:update(arg_11_3, arg_11_5)

		local var_11_34 = arg_11_0._extra_joint.node
		local var_11_35 = var_11_33:current_tangent_direction()
		local var_11_36 = Quaternion.rotate(var_11_32, var_11_35)
		local var_11_37 = Quaternion.look(var_11_36, Vector3.up())

		Unit.set_local_rotation(var_11_3, var_11_34, var_11_37)
	end
end

PayloadExtension.payload_flow_event = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._spline_curve:splines()[arg_12_1].metadata.flow_event_data.flow_event

	LevelHelper:flow_event(arg_12_0._world, var_12_0)
end

local var_0_6 = {}

PayloadExtension._players_in_proximity = function (arg_13_0)
	local var_13_0 = arg_13_0._side.PLAYER_UNITS
	local var_13_1 = #var_13_0
	local var_13_2 = POSITION_LOOKUP
	local var_13_3 = Unit.world_position(arg_13_0._unit, 0)
	local var_13_4 = 0

	for iter_13_0 = 1, var_13_1 do
		local var_13_5 = var_13_0[iter_13_0]
		local var_13_6 = var_13_2[var_13_5]
		local var_13_7 = Vector3.distance(var_13_6, var_13_3)
		local var_13_8 = ScriptUnit.extension(var_13_5, "status_system")

		if var_13_7 < 5 and not var_13_8:is_disabled() then
			var_13_4 = var_13_4 + 1
			var_0_6[var_13_4] = var_13_5
		end
	end

	return var_13_4, var_0_6
end

PayloadExtension._error_speed_calculation = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = GameSession.game_object_field(arg_14_3, arg_14_4, "spline_index")
	local var_14_1 = GameSession.game_object_field(arg_14_3, arg_14_4, "subdivision_index")
	local var_14_2 = GameSession.game_object_field(arg_14_3, arg_14_4, "spline_t")
	local var_14_3 = arg_14_0._last_synched_spline_values

	if var_14_3.spline_index ~= var_14_0 or var_14_3.subdivision_index ~= var_14_1 or var_14_3.spline_t ~= var_14_2 then
		local var_14_4 = arg_14_5:current_spline_index()
		local var_14_5 = arg_14_5:current_subdivision_index()
		local var_14_6 = arg_14_5:current_t()
		local var_14_7 = arg_14_5:distance(var_14_4, var_14_5, var_14_6, var_14_0, var_14_1, var_14_2)

		var_14_3.spline_index = var_14_0
		var_14_3.subdivision_index = var_14_1
		var_14_3.spline_t = var_14_2
		var_14_3.error_compensation_speed = var_14_7 / var_0_1
		var_14_3.last_synch_time = arg_14_2
	elseif arg_14_2 - var_14_3.last_synch_time >= var_0_1 then
		var_14_3.error_compensation_speed = 0
	end

	return var_14_3.error_compensation_speed
end

PayloadExtension.set_game_object_id = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._game
	local var_15_1 = GameSession.game_object_field(var_15_0, arg_15_1, "spline_index")
	local var_15_2 = GameSession.game_object_field(var_15_0, arg_15_1, "subdivision_index")
	local var_15_3 = GameSession.game_object_field(var_15_0, arg_15_1, "spline_t")
	local var_15_4 = GameSession.game_object_field(var_15_0, arg_15_1, "speed")
	local var_15_5 = arg_15_0._spline_curve:movement()

	var_15_5:set_spline_index(var_15_1, var_15_2, var_15_3)
	var_15_5:set_speed(var_15_4)

	arg_15_0._id = arg_15_1
end

local var_0_7 = {}

PayloadExtension._init_movement_spline = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = Unit.get_data(arg_16_2, "spline_name")
	local var_16_1 = LevelHelper:current_level(arg_16_1)
	local var_16_2 = Level.spline(var_16_1, var_16_0)

	fassert(#var_16_2 > 0, "Could not find spline called %s for Payload unit in level, wrong name? or payload unit is used as a prop unintentionally", var_16_0)

	local var_16_3 = SplineCurve:new(var_16_2, "Bezier", "SplineMovementHermiteInterpolatedMetered", var_16_0, 10)
	local var_16_4 = var_16_3:splines()

	table.clear(var_0_7)

	if arg_16_3 then
		for iter_16_0 = 1, #arg_16_3 do
			local var_16_5 = arg_16_3[iter_16_0]
			local var_16_6 = Unit.world_position(var_16_5, 0)
			local var_16_7 = math.huge
			local var_16_8

			for iter_16_1, iter_16_2 in ipairs(var_16_4) do
				local var_16_9 = iter_16_2.points
				local var_16_10 = var_16_9[1]:unbox()
				local var_16_11 = Vector3.distance(var_16_6, var_16_10)

				if var_16_11 < var_16_7 then
					var_16_7 = var_16_11
					var_16_8 = var_16_9[1]
				end

				if iter_16_1 == #var_16_4 then
					local var_16_12 = var_16_9[4]:unbox()
					local var_16_13 = Vector3.distance(var_16_6, var_16_12)

					if var_16_13 < var_16_7 then
						var_16_7 = var_16_13
						var_16_8 = var_16_9[4]
					end
				end
			end

			var_0_7[var_16_8] = var_16_5
		end
	end

	local var_16_14 = "flat"

	for iter_16_3, iter_16_4 in ipairs(var_16_4) do
		local var_16_15 = iter_16_4.points[1]
		local var_16_16 = var_0_7[var_16_15]
		local var_16_17

		if var_16_16 then
			local var_16_18 = Unit.get_data(var_16_16, "speed_setting")
			local var_16_19 = Unit.get_data(var_16_16, "flow_event")

			var_16_14 = var_16_18 ~= "" and var_16_18 or var_16_14
			var_16_17 = var_16_19 ~= "" and var_16_19
		end

		local var_16_20 = PayloadSpeedSettings[var_16_14]

		iter_16_4.metadata = {
			speed_settings = var_16_20,
			flow_event_data = {
				event_thrown = false,
				flow_event = var_16_17
			}
		}
	end

	return var_16_3
end

PayloadExtension._create_game_object = function (arg_17_0)
	local var_17_0 = arg_17_0._unit
	local var_17_1 = arg_17_0._spline_curve:movement()
	local var_17_2 = var_17_1:current_spline_index()
	local var_17_3 = var_17_1:current_subdivision_index()
	local var_17_4 = var_17_1:current_t()
	local var_17_5 = var_17_1:speed()
	local var_17_6 = {
		go_type = NetworkLookup.go_types.payload,
		level_unit_index = arg_17_0._level_unit_index,
		spline_index = var_17_2,
		subdivision_index = var_17_3,
		spline_t = var_17_4,
		speed = var_17_5
	}
	local var_17_7 = callback(arg_17_0, "cb_game_session_disconnect")

	arg_17_0._id = arg_17_0._network_manager:create_game_object("payload", var_17_6, var_17_7)
end

PayloadExtension.cb_game_session_disconnect = function (arg_18_0)
	arg_18_0._game = nil
end

PayloadExtension.started = function (arg_19_0)
	return arg_19_0._started
end

PayloadExtension.finished = function (arg_20_0)
	return arg_20_0._previous_status == "end"
end

PayloadExtension.increment_kill_stat = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	if arg_21_4 == arg_21_0._unit then
		local var_21_0 = Managers.player:local_player()
		local var_21_1 = Managers.player:statistics_db()
		local var_21_2 = var_21_0:stats_id()

		var_21_1:increment_stat(var_21_2, "trail_sleigher")
	end
end
