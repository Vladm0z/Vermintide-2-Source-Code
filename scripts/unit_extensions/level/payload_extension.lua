-- chunkname: @scripts/unit_extensions/level/payload_extension.lua

require("scripts/settings/payload_speed_settings")
require("foundation/scripts/util/spline_curve")

local num = 100
local num_2 = 0.5
local num_3 = 0.1
local num_4 = 0.01

PayloadExtension = class(PayloadExtension)

PayloadExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world
	local network = Managers.state.network

	self._unit = arg_1_2
	self._world = world
	self._is_server = Managers.player.is_server
	self._game = network:game()
	self._network_manager = network
	self._extra_joint = nil

	local current_level = LevelHelper:current_level(world)

	self._level_unit_index = Level.unit_index(current_level, arg_1_2)
	self._last_synched_spline_values = {
		last_synch_time = 0,
		error_compensation_speed = 0,
		spline_index = 1,
		subdivision_index = 1,
		spline_t = 0
	}
	self._stop_command_given = false
	self._activated = true
	self._started = false
	self._use_statemachine = false
	self._speed_var_index = 0

	if not Unit.has_data(arg_1_2, "payload_statemachine_speed_var") then
		local get_data = Unit.get_data(arg_1_2, "payload_statemachine_speed_var")

		if not Unit.animation_has_variable(arg_1_2, get_data) then
			self._speed_var_index = Unit.animation_find_variable(arg_1_2, get_data)
			self._use_statemachine = true
		end
	end

	local get_data_2 = Unit.get_data(arg_1_2, "wheel_diameter")
	local num = 60

	if not Unit.has_data(arg_1_2, "payload_wheel_frames") then
		num = Unit.get_data(arg_1_2, "payload_wheel_frames")

		if num == 0 then
			num = 60
		end
	end

	self._anim_speed = 30 / num * get_data_2 * math.pi
	self._anim_group = "wheels"

	if not Unit.has_data(arg_1_2, "wheel_anim_group") then
		self._anim_group = Unit.get_data(arg_1_2, "wheel_anim_group")
	end

	if not DEDICATED_SERVER then
		local get_data_3 = Unit.get_data(arg_1_2, "hazard_type")
		local local_player = Managers.player:local_player()
		local statistics_db = Managers.player:statistics_db()
		local stats_id = local_player:stats_id()

		if not (get_data_3 ~= "sled" or statistics_db:get_persistent_stat(stats_id, "trail_sleigher") <= 50 or true) then
			Managers.state.event:register(self, "on_killed", "increment_kill_stat")
		end
	end

	self._side = Managers.state.side:get_side_from_name("heroes")
	self._enemy_broadphase_categories = self._side.enemy_broadphase_categories
end

PayloadExtension.activate = function (self)
	-- function 2
	self._activated = true
end

PayloadExtension.deactivate = function (self, arg_3_1)
	-- function 3
	self._activated = false
	self._stop_command_given = arg_3_1
end

PayloadExtension.destroy = function (arg_4_0)
	-- function 4
	Managers.state.event:unregister("on_killed", arg_4_0)
end

PayloadExtension.extensions_ready = function (arg_5_0)
	-- function 5
	return
end

PayloadExtension.hot_join_sync = function (arg_6_0, arg_6_1)
	-- function 6
	return
end

PayloadExtension.init_payload = function (self, arg_7_1)
	-- function 7
	local _unit = self._unit

	self._spline_curve = self:_init_movement_spline(self._world, _unit, arg_7_1)

	local get_data = Unit.get_data(_unit, "extra_spline_joint")

	if not get_data then
		local _init_movement_spline = self:_init_movement_spline(self._world, _unit, arg_7_1)
		local node = Unit.node(_unit, get_data)
		local distance = Vector3.distance(Vector3.flat(Unit.world_position(_unit, node)), Vector3.flat(Unit.local_position(_unit, 0)))
		local num = Quaternion.forward(Unit.local_rotation(_unit, 0)) * distance
		local movement = _init_movement_spline:movement()
		local num_2 = distance / 1

		movement:set_speed(1)

		while num_2 > 0 do
			local length = movement:_current_spline_subdivision().length

			if length <= num_2 then
				movement:update(length)

				num_2 = num_2 - length
			else
				movement:update(num_2)

				num_2 = 0
			end
		end

		self._extra_joint = {
			spline = _init_movement_spline,
			node = node
		}
	end

	if not self._is_server then
		self:_create_game_object()
	end
end

PayloadExtension.movement = function (self)
	-- function 8
	return self._spline_curve:movement()
end

PayloadExtension._push_player = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _unit = self._unit
	local var_9_1 = POSITION_LOOKUP[_unit]
	local box, var_9_3 = Unit.box(_unit, true)
	local var_9_4 = POSITION_LOOKUP[arg_9_1]
	local num = var_9_3 * 1.2

	if not math.point_is_inside_oobb(var_9_4, box, num) then
		local flat = Vector3.flat(var_9_1)
		local flat_2 = Vector3.flat(var_9_4)
		local num_2 = Vector3.normalize(flat_2 - flat) * arg_9_2

		ScriptUnit.extension(arg_9_1, "locomotion_system"):add_external_velocity(num_2)
	end
end

local tbl = {}
local tbl_2 = {}

PayloadExtension._hit_enemies = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _unit = self._unit
	local var_10_1 = POSITION_LOOKUP[_unit]
	local flat = Vector3.flat(var_10_1)
	local box, var_10_4 = Unit.box(_unit, true)
	local normalize = Vector3.normalize(Matrix4x4.forward(box))
	local x

	if var_10_4.x > var_10_4.y then
		x = var_10_4.x

		if not x then
			-- Nothing
		end
	end

	x = var_10_4.y

	::label_10_0::

	x = not (x > var_10_4.z) or not x or var_10_4.z

	local num = x * 2
	local num_2 = var_10_4 * 1.2
	local num_3 = var_10_4 * 2
	local flag = Unit.get_data(_unit, "hazard_type") or "payload"
	local var_10_11 = EnvironmentalHazards[flag]
	local str = "torso"
	local var_10_13
	local var_10_14 = flag
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_10_16 = var_10_11.enemy.difficulty_power_level[get_difficulty_rank]

	if not var_10_16 then
		var_10_16 = var_10_11.enemy.difficulty_power_level[2]
		var_10_16 = var_10_16 or DefaultPowerLevel
	end

	local damage_profile = var_10_11.enemy.damage_profile

	damage_profile = damage_profile or "default"

	local var_10_18 = DamageProfileTemplates[damage_profile]
	local var_10_19
	local num_4 = 0
	local flag_2 = false
	local can_damage = var_10_11.enemy.can_damage

	can_damage = can_damage or false

	local can_stagger = var_10_11.enemy.can_stagger

	can_stagger = can_stagger or true

	local flag_3 = false
	local flag_4 = false
	local broadphase_query = AiUtils.broadphase_query(var_10_1, num, tbl, self._enemy_broadphase_categories)

	for i = 1, broadphase_query do
		local var_10_27 = tbl[i]
		local var_10_28 = POSITION_LOOKUP[var_10_27]
		local point_is_inside_oobb = math.point_is_inside_oobb(var_10_28, box, num_2)
		local point_is_inside_oobb_2 = math.point_is_inside_oobb(var_10_28, box, num_3)

		if not (not point_is_inside_oobb and tbl_2[var_10_27]) then
			tbl_2[var_10_27] = true

			local num_5 = 0.5

			if not (not (Vector3.dot(normalize, var_10_28 - var_10_1) > 0) and not (arg_10_1 > 2)) then
				num_5 = arg_10_1 * 1.3
			end

			local num_6 = var_10_16 * num_5
			local flat_2 = Vector3.flat(var_10_28)
			local normalize_2 = Vector3.normalize(flat_2 - flat)

			DamageUtils.server_apply_hit(arg_10_2, _unit, var_10_27, str, nil, normalize_2, var_10_13, var_10_14, num_6, var_10_18, var_10_19, num_4, flag_2, can_damage, can_stagger, flag_3, flag_4)
		elseif (point_is_inside_oobb or not point_is_inside_oobb_2) and not tbl_2[var_10_27] then
			tbl_2[var_10_27] = false
		end
	end
end

PayloadExtension.update = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local _players_in_proximity, var_11_1 = self:_players_in_proximity()
	local flag = _players_in_proximity > 0
	local _unit = self._unit
	local game = Managers.state.network:game()
	local _id = self._id
	local num = 0
	local _spline_curve = self._spline_curve
	local movement = self._spline_curve:movement()
	local metadata = movement:_current_spline().metadata
	local current_spline_index = movement:current_spline_index()

	if not _id and not game then
		if not self._is_server then
			local speed_settings = metadata.speed_settings
			local pushed

			if not flag then
				pushed = speed_settings.pushed

				if not pushed then
					-- Nothing
				end
			end

			pushed = speed_settings.not_pushed

			::label_11_0::

			local bonus_speed_per_player = pushed.bonus_speed_per_player

			bonus_speed_per_player = bonus_speed_per_player or 0

			local num_2 = bonus_speed_per_player * _players_in_proximity
			local num_3 = pushed.speed + num_2
			local acceleration = pushed.acceleration

			if not ((not (num_3 > 0) or self._previous_status ~= "end" or not (num_3 < 0)) and (self._previous_status ~= "start" or self._activated)) then
				num_3 = 0
			end

			local flag_2 = false
			local speed = movement:speed()
			local num_5 = num_3 - speed

			if not self._stop_command_given then
				self._stop_command_given = false
				num = 0
			elseif num_5 > 0 then
				num = math.min(speed + acceleration * arg_11_3, num_3)
			elseif num_5 < 0 then
				num = math.max(speed - acceleration * arg_11_3, num_3)
			else
				num = num_3
			end

			if not (not (speed > 0) or not (num < 0)) then
				Unit.flow_event(_unit, "lua_start_moving_backwards")
			end

			GameSession.set_game_object_field(game, _id, "speed", num)

			local current_subdivision_index = movement:current_subdivision_index()
			local current_t = movement:current_t()

			GameSession.set_game_object_field(game, _id, "spline_index", current_spline_index)
			GameSession.set_game_object_field(game, _id, "subdivision_index", current_subdivision_index)
			GameSession.set_game_object_field(game, _id, "spline_t", current_t)

			local flow_event_data = metadata.flow_event_data
			local flow_event = flow_event_data.flow_event
			local event_thrown = flow_event_data.event_thrown
			local abs = math.abs(num)

			if not (not flag and not (abs > 0.1)) then
				for i = 1, _players_in_proximity do
					self:_push_player(var_11_1[i], abs)
				end
			end

			if abs > 0 then
				self:_hit_enemies(abs, arg_11_5)
			end

			if not ((current_spline_index == self._previous_spline_index or not flow_event) and event_thrown) then
				LevelHelper:flow_event(self._world, flow_event)

				flow_event_data.event_thrown = true

				local _network_manager = self._network_manager
				local network_transmit = _network_manager.network_transmit
				local game_object_or_level_id = _network_manager:game_object_or_level_id(_unit)

				network_transmit:send_rpc_clients("rpc_payload_flow_event", game_object_or_level_id, current_spline_index)
			end
		else
			local _error_speed_calculation = self:_error_speed_calculation(arg_11_3, arg_11_5, game, _id, movement)

			num = GameSession.game_object_field(game, _id, "speed") + _error_speed_calculation
		end
	end

	movement:set_speed(num)

	local update = movement:update(arg_11_3, arg_11_5)

	if not (self._state == "stopped" or not (math.abs(num) < num_4)) then
		self._state = "stopped"

		Unit.flow_event(_unit, "lua_stopped")
	elseif not (self._state == "moving" or not (math.abs(num) >= num_4)) then
		if not self._started then
			Unit.flow_event(_unit, "lua_start")

			self._started = true
		end

		self._state = "moving"

		Unit.flow_event(_unit, "lua_moving")
	elseif not (update ~= "end" or self._previous_status == "end") then
		Unit.flow_event(_unit, "lua_end")
	end

	self._previous_status = update
	self._previous_spline_index = current_spline_index

	if not self._use_statemachine then
		Unit.animation_set_variable(self._unit, self._speed_var_index, num / self._anim_speed)
	else
		Unit.set_simple_animation_speed(self._unit, num / self._anim_speed, self._anim_group)
	end

	Unit.set_local_position(_unit, 0, movement:current_position())

	local current_tangent_direction = movement:current_tangent_direction()
	local look = Quaternion.look(current_tangent_direction, Vector3.up())

	Unit.set_local_rotation(_unit, 0, look)

	if not self._extra_joint then
		local inverse = Quaternion.inverse(look)
		local movement_2 = self._extra_joint.spline:movement()

		movement_2:set_speed(num)
		movement_2:update(arg_11_3, arg_11_5)

		local node = self._extra_joint.node
		local current_tangent_direction_2 = movement_2:current_tangent_direction()
		local rotate = Quaternion.rotate(inverse, current_tangent_direction_2)
		local look_2 = Quaternion.look(rotate, Vector3.up())

		Unit.set_local_rotation(_unit, node, look_2)
	end
end

PayloadExtension.payload_flow_event = function (self, arg_12_1)
	-- function 12
	local flow_event = self._spline_curve:splines()[arg_12_1].metadata.flow_event_data.flow_event

	LevelHelper:flow_event(self._world, flow_event)
end

local tbl_3 = {}

PayloadExtension._players_in_proximity = function (self)
	-- function 13
	local PLAYER_UNITS = self._side.PLAYER_UNITS
	local count = #PLAYER_UNITS
	local POSITION_LOOKUP = POSITION_LOOKUP
	local world_position = Unit.world_position(self._unit, 0)
	local num = 0

	for i = 1, count do
		local var_13_5 = PLAYER_UNITS[i]
		local var_13_6 = POSITION_LOOKUP[var_13_5]
		local distance = Vector3.distance(var_13_6, world_position)
		local extension = ScriptUnit.extension(var_13_5, "status_system")

		if not (not (distance < 5) or extension:is_disabled()) then
			num = num + 1
			tbl_3[num] = var_13_5
		end
	end

	return num, tbl_3
end

PayloadExtension._error_speed_calculation = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local game_object_field = GameSession.game_object_field(arg_14_3, arg_14_4, "spline_index")
	local game_object_field_2 = GameSession.game_object_field(arg_14_3, arg_14_4, "subdivision_index")
	local game_object_field_3 = GameSession.game_object_field(arg_14_3, arg_14_4, "spline_t")
	local _last_synched_spline_values = self._last_synched_spline_values

	if not (_last_synched_spline_values.spline_index ~= game_object_field or _last_synched_spline_values.subdivision_index ~= game_object_field_2 or _last_synched_spline_values.spline_t == game_object_field_3) then
		local current_spline_index = arg_14_5:current_spline_index()
		local current_subdivision_index = arg_14_5:current_subdivision_index()
		local current_t = arg_14_5:current_t()
		local distance = arg_14_5:distance(current_spline_index, current_subdivision_index, current_t, game_object_field, game_object_field_2, game_object_field_3)

		_last_synched_spline_values.spline_index = game_object_field
		_last_synched_spline_values.subdivision_index = game_object_field_2
		_last_synched_spline_values.spline_t = game_object_field_3
		_last_synched_spline_values.error_compensation_speed = distance / num_2
		_last_synched_spline_values.last_synch_time = arg_14_2
	elseif arg_14_2 - _last_synched_spline_values.last_synch_time >= num_2 then
		_last_synched_spline_values.error_compensation_speed = 0
	end

	return _last_synched_spline_values.error_compensation_speed
end

PayloadExtension.set_game_object_id = function (self, arg_15_1)
	-- function 15
	local _game = self._game
	local game_object_field = GameSession.game_object_field(_game, arg_15_1, "spline_index")
	local game_object_field_2 = GameSession.game_object_field(_game, arg_15_1, "subdivision_index")
	local game_object_field_3 = GameSession.game_object_field(_game, arg_15_1, "spline_t")
	local game_object_field_4 = GameSession.game_object_field(_game, arg_15_1, "speed")
	local movement = self._spline_curve:movement()

	movement:set_spline_index(game_object_field, game_object_field_2, game_object_field_3)
	movement:set_speed(game_object_field_4)

	self._id = arg_15_1
end

local tbl_4 = {}

PayloadExtension._init_movement_spline = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local get_data = Unit.get_data(arg_16_2, "spline_name")
	local current_level = LevelHelper:current_level(arg_16_1)
	local spline = Level.spline(current_level, get_data)

	fassert(#spline > 0, "Could not find spline called %s for Payload unit in level, wrong name? or payload unit is used as a prop unintentionally", get_data)

	local var_16_3 = SplineCurve:new(spline, "Bezier", "SplineMovementHermiteInterpolatedMetered", get_data, 10)
	local splines = var_16_3:splines()

	table.clear(tbl_4)

	if not arg_16_3 then
		for i = 1, #arg_16_3 do
			local var_16_5 = arg_16_3[i]
			local world_position = Unit.world_position(var_16_5, 0)
			local huge = math.huge
			local var_16_8

			for i_2, v in ipairs(splines) do
				local points = v.points
				local unbox = points[1]:unbox()
				local distance = Vector3.distance(world_position, unbox)

				if distance < huge then
					huge = distance
					var_16_8 = points[1]
				end

				if i_2 == #splines then
					local unbox_2 = points[4]:unbox()
					local distance_2 = Vector3.distance(world_position, unbox_2)

					if distance_2 < huge then
						huge = distance_2
						var_16_8 = points[4]
					end
				end
			end

			tbl_4[var_16_8] = var_16_5
		end
	end

	local str = "flat"

	for i_3, v_2 in ipairs(splines) do
		local var_16_15 = v_2.points[1]
		local var_16_16 = tbl_4[var_16_15]
		local var_16_17

		if not var_16_16 then
			local get_data_2 = Unit.get_data(var_16_16, "speed_setting")
			local get_data_3 = Unit.get_data(var_16_16, "flow_event")

			str = get_data_2 == "" or not get_data_2 or str
			var_16_17 = get_data_3 == "" or get_data_3
		end

		local var_16_20 = PayloadSpeedSettings[str]

		v_2.metadata = {
			speed_settings = var_16_20,
			flow_event_data = {
				event_thrown = false,
				flow_event = var_16_17
			}
		}
	end

	return var_16_3
end

PayloadExtension._create_game_object = function (self)
	-- function 17
	local _unit = self._unit
	local movement = self._spline_curve:movement()
	local current_spline_index = movement:current_spline_index()
	local current_subdivision_index = movement:current_subdivision_index()
	local current_t = movement:current_t()
	local speed = movement:speed()
	local tbl = {
		go_type = NetworkLookup.go_types.payload,
		level_unit_index = self._level_unit_index,
		spline_index = current_spline_index,
		subdivision_index = current_subdivision_index,
		spline_t = current_t,
		speed = speed
	}
	local var_17_7 = callback(self, "cb_game_session_disconnect")

	self._id = self._network_manager:create_game_object("payload", tbl, var_17_7)
end

PayloadExtension.cb_game_session_disconnect = function (self)
	-- function 18
	self._game = nil
end

PayloadExtension.started = function (self)
	-- function 19
	return self._started
end

PayloadExtension.finished = function (self)
	-- function 20
	return self._previous_status == "end"
end

PayloadExtension.increment_kill_stat = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	if arg_21_4 == self._unit then
		local local_player = Managers.player:local_player()
		local statistics_db = Managers.player:statistics_db()
		local stats_id = local_player:stats_id()

		statistics_db:increment_stat(stats_id, "trail_sleigher")
	end
end
