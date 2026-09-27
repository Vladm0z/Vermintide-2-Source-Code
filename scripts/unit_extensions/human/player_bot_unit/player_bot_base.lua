-- chunkname: @scripts/unit_extensions/human/player_bot_unit/player_bot_base.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_brain")

local alive = Unit.alive
local BLACKBOARDS = BLACKBOARDS
local num = 5
local num_2 = 4.5
local num_3 = 1.5
local num_4 = 15
local num_5 = -0.2
local num_6 = 1
local num_7 = 1.5
local num_8 = 9
local num_9 = 0.8
local num_10 = 0.25
local FLAT_MOVE_TO_EPSILON = BotConstants.default.FLAT_MOVE_TO_EPSILON
local num_11 = FLAT_MOVE_TO_EPSILON^2
local num_12 = BotConstants.default.FLAT_MOVE_TO_PREVIOUS_POS_EPSILON^2
local Z_MOVE_TO_EPSILON = BotConstants.default.Z_MOVE_TO_EPSILON
local num_13 = 0.5
local num_14 = 0.1
local num_15 = 0.11
local num_16 = 0.25
local num_17 = 0.6
local num_18 = 0.8
local num_19 = 10
local num_20 = 0.75
local num_21 = 1
local num_22 = 0.01
local var_0_26

local function fn(...)
	-- function 1
	if var_0_26 ~= script_data.debug_unit or not script_data.ai_bots_debug then
		print(...)
	end
end

local function fn_2(...)
	-- function 2
	if var_0_26 ~= script_data.debug_unit or not script_data.ai_bots_debug then
		Debug.text(...)
	end
end

PlayerBotBase = class(PlayerBotBase)

local function fn_3(self)
	-- function 3
	local count = #self
	local num = -math.huge

	for i = 1, count do
		local weight = self[i].weight

		if num < weight then
			num = weight
		end
	end

	return num
end

PlayerBotBase.init = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local world = arg_4_1.world

	self._world = world
	self._unit = arg_4_2
	self._nav_world = arg_4_3.nav_world
	self._enemy_broadphase = Managers.state.entity:system("ai_system").broadphase

	local var_4_1 = Vector3Box(Vector3(0, 0, 0))

	var_4_1.value_stored = false
	self.is_bot = true
	self._t = 0
	self._blackboard = {
		is_passive = true,
		target_ally_needs_aid = false,
		using_navigation_destination_override = false,
		re_evaluate_detection = Math.random() * 0.5,
		world = world,
		unit = arg_4_2,
		level = LevelHelper:current_level(arg_4_1.world),
		nav_world = self._nav_world,
		node_data = {},
		running_nodes = {},
		proximite_enemies = {},
		follow = {
			needs_target_position_refresh = true,
			follow_timer = math.lerp(num_6, num_7, Math.random()),
			target_position = Vector3Box(POSITION_LOOKUP[arg_4_2])
		},
		target_ally_aid_destination = Vector3Box(),
		navigation_destination_override = var_4_1,
		navigation_liquid_escape_destination_override = Vector3Box(),
		navigation_vortex_escape_destination_override = Vector3Box(),
		navigation_vortex_escape_previous_evaluation_position = Vector3Box(),
		activate_ability_data = {
			is_using_ability = false,
			aim_position = Vector3Box()
		},
		hit_by_projectile = {},
		proximity_target_distance = math.huge,
		urgent_target_distance = math.huge,
		opportunity_target_distance = math.huge,
		taking_cover = {
			fails = 0,
			threats = {},
			active_threats = {},
			cover_position = Vector3Box(Vector3.invalid_vector()),
			failed_cover_points = {}
		}
	}

	local up = Vector3.up()
	local tbl = {
		{
			weight = 0.5,
			direction = Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 4 / 8)))
		},
		{
			weight = 0.75,
			direction = Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 3 / 8)))
		},
		{
			weight = 1,
			direction = Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 2 / 8)))
		},
		{
			weight = 0.7,
			direction = Vector3Box(Quaternion.forward(Quaternion(up, -math.pi * 1 / 8)))
		},
		{
			weight = 0.6,
			direction = Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 0 / 8)))
		},
		{
			weight = 0.7,
			direction = Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 1 / 8)))
		},
		{
			weight = 1,
			direction = Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 2 / 8)))
		},
		{
			weight = 0.75,
			direction = Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 3 / 8)))
		},
		{
			weight = 0.5,
			direction = Vector3Box(Quaternion.forward(Quaternion(up, math.pi * 4 / 8)))
		}
	}

	self._vortex_escape_directions = tbl
	self._vortex_largest_weighted_distance_sq = fn_3(tbl) * num_19^2
	self._bot_profile = arg_4_3.bot_profile
	self._player = arg_4_3.player

	Unit.set_data(arg_4_2, "bot", self._bot_profile)
	Managers.player:assign_unit_ownership(arg_4_2, self._player, true)
	Unit.set_flow_variable(arg_4_2, "is_bot", true)
	Unit.flow_event(arg_4_2, "character_vo_set")
	self:_init_brain()

	self._proximity_target_update_timer = -math.huge
	self._pickup_search_timer = -math.huge
	self._search_for_pickups_near_ally = false
	self._interactable_timer = -math.huge
	self._stay_near_player = false
	self._stay_near_player_range = math.huge
	self._attempted_enemy_paths = {}
	self._attempted_ally_paths = {}
	self._seen_by_players = {}
	self._last_health_pickup_attempt = {
		blacklist = false,
		distance = 0,
		index = 1,
		path_failed = false,
		rotation = QuaternionBox(),
		path_position = Vector3Box()
	}
	self._last_mule_pickup_attempt = {
		blacklist = false,
		distance = 0,
		index = 1,
		path_failed = false,
		rotation = QuaternionBox(),
		path_position = Vector3Box()
	}
end

PlayerBotBase.ranged_attack_started = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local _blackboard = self._blackboard

	if arg_5_3 == "ratling_gun_fire" then
		_blackboard.taking_cover.threats[arg_5_1] = arg_5_2
	end
end

PlayerBotBase.ranged_attack_ended = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local _blackboard = self._blackboard

	if arg_6_3 == "ratling_gun_fire" then
		_blackboard.taking_cover.threats[arg_6_1] = nil
	end
end

PlayerBotBase.hit_by_projectile = function (self, arg_7_1)
	-- function 7
	self._blackboard.hit_by_projectile[arg_7_1] = self._t
end

local num_23 = 5

PlayerBotBase.set_stay_near_player = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not arg_8_1 then
		self._stay_near_player_range = arg_8_2 or num_23
	else
		self._stay_near_player_range = math.huge
	end

	self._stay_near_player = arg_8_1
end

PlayerBotBase.should_stay_near_player = function (self)
	-- function 9
	return self._stay_near_player, self._stay_near_player_range
end

PlayerBotBase.set_seen_by_player = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local _seen_by_players = self._seen_by_players

	if not arg_10_1 then
		_seen_by_players[arg_10_2] = arg_10_3
	else
		_seen_by_players[arg_10_2] = nil
	end
end

PlayerBotBase.extensions_ready = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _blackboard = self._blackboard
	local extension = ScriptUnit.extension(arg_11_2, "input_system")
	local extension_2 = ScriptUnit.extension(arg_11_2, "inventory_system")
	local extension_3 = ScriptUnit.extension(arg_11_2, "overcharge_system")
	local extension_4 = ScriptUnit.extension(arg_11_2, "ai_navigation_system")
	local extension_5 = ScriptUnit.extension(arg_11_2, "first_person_system")
	local extension_6 = ScriptUnit.extension(arg_11_2, "status_system")
	local extension_7 = ScriptUnit.extension(arg_11_2, "interactor_system")
	local extension_8 = ScriptUnit.extension(arg_11_2, "health_system")
	local extension_9 = ScriptUnit.extension(arg_11_2, "ai_bot_group_system")
	local extension_10 = ScriptUnit.extension(arg_11_2, "ai_system")
	local extension_11 = ScriptUnit.extension(arg_11_2, "locomotion_system")
	local extension_12 = ScriptUnit.extension(arg_11_2, "career_system")
	local extension_13 = ScriptUnit.extension(arg_11_2, "ai_slot_system")
	local extension_14 = ScriptUnit.extension(arg_11_2, "ai_commander_system")

	self._health_extension = extension_8
	self._status_extension = extension_6
	self._locomotion_extension = extension_11
	self._navigation_extension = extension_4
	_blackboard.input_extension = extension
	_blackboard.inventory_extension = extension_2
	_blackboard.overcharge_extension = extension_3
	_blackboard.navigation_extension = extension_4
	_blackboard.locomotion_extension = extension_11
	_blackboard.first_person_extension = extension_5
	_blackboard.status_extension = extension_6
	_blackboard.interaction_extension = extension_7
	_blackboard.health_extension = extension_8
	_blackboard.ai_bot_group_extension = extension_9
	_blackboard.ai_extension = extension_10
	_blackboard.career_extension = extension_12
	_blackboard.ai_slot_extension = extension_13
	_blackboard.ai_commander_extension = extension_14
	_blackboard.side = Managers.state.side.side_by_unit[arg_11_2]
end

PlayerBotBase._init_brain = function (self)
	-- function 12
	self._brain = AIBrain:new(self._world, self._unit, self._blackboard, self._bot_profile, self._bot_profile.behavior)
end

PlayerBotBase.brain = function (self)
	-- function 13
	return self._brain
end

PlayerBotBase.profile = function (self)
	-- function 14
	return self._bot_profile
end

PlayerBotBase.blackboard = function (self)
	-- function 15
	return self._blackboard
end

PlayerBotBase.update = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	self._t = arg_16_5

	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local var_16_2 = HEALTH_ALIVE[self._unit]
	local is_ready_for_assisted_respawn = _status_extension:is_ready_for_assisted_respawn()
	local is_linked_movement = _locomotion_extension:is_linked_movement()

	if not (not var_16_2 and is_ready_for_assisted_respawn or is_linked_movement) then
		var_0_26 = arg_16_1

		self:_update_blackboard(arg_16_3, arg_16_5)
		self:_update_target_enemy(arg_16_3, arg_16_5)
		self:_update_target_ally(arg_16_3, arg_16_5)
		self:_update_liquid_escape()
		self:_update_vortex_escape()
		self:_update_pickups(arg_16_3, arg_16_5)
		self:_update_interactables(arg_16_3, arg_16_5)
		self:_update_weapon_loadout_data(false)
		self:_update_best_weapon()
		self:_update_reload()
		self._brain:update(arg_16_1, arg_16_5, arg_16_3)

		local get_moving_platform, var_16_6, var_16_7 = _locomotion_extension:get_moving_platform()

		if not ((_status_extension:is_disabled() or not get_moving_platform) and var_16_7) then
			self._navigation_extension:teleport(POSITION_LOOKUP[arg_16_1])
		elseif not _locomotion_extension:is_on_ground() then
			self:_update_movement_target(arg_16_3, arg_16_5)
		end

		self:_update_attack_request(arg_16_5)
	end
end

PlayerBotBase._update_blackboard = function (self, arg_17_1, arg_17_2)
	-- function 17
	local _blackboard = self._blackboard
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension

	_blackboard.is_knocked_down = _status_extension:is_knocked_down()
	_blackboard.is_grabbed_by_pack_master = _status_extension:is_grabbed_by_pack_master()
	_blackboard.is_pounced_down = _status_extension:is_pounced_down()
	_blackboard.is_hanging_from_hook = _status_extension:is_hanging_from_hook()
	_blackboard.is_ledge_hanging = _status_extension:get_is_ledge_hanging()

	local get_moving_platform, var_17_4, var_17_5 = _locomotion_extension:get_moving_platform()

	_blackboard.is_transported = not get_moving_platform and not var_17_5 and _status_extension:is_using_transport()
	_blackboard.is_grabbed_by_chaos_spawn = _status_extension:is_grabbed_by_chaos_spawn()

	local _unit = self._unit
	local target_unit = _blackboard.target_unit

	if not ALIVE[target_unit] then
		_blackboard.target_dist = Vector3.distance(POSITION_LOOKUP[target_unit], POSITION_LOOKUP[_unit])
	else
		_blackboard.target_dist = math.huge
		_blackboard.target_unit = nil
	end

	for k, v in pairs(_blackboard.utility_actions) do
		v.time_since_last = arg_17_2 - v.last_time
	end
end

PlayerBotBase._update_target_enemy = function (self, arg_18_1, arg_18_2)
	-- function 18
	local var_18_0 = POSITION_LOOKUP[self._unit]

	self:_update_slot_target(arg_18_1, arg_18_2, var_18_0)
	self:_update_proximity_target(arg_18_1, arg_18_2, var_18_0)

	local _blackboard = self._blackboard
	local target_unit = _blackboard.target_unit
	local slot_target_enemy = _blackboard.slot_target_enemy
	local proximity_target_enemy = _blackboard.proximity_target_enemy
	local priority_target_enemy = _blackboard.priority_target_enemy
	local urgent_target_enemy = _blackboard.urgent_target_enemy
	local opportunity_target_enemy = _blackboard.opportunity_target_enemy
	local proximity_target_distance = _blackboard.proximity_target_distance
	local var_18_9

	if proximity_target_enemy == target_unit then
		var_18_9 = num_5

		if not var_18_9 then
			-- Nothing
		end
	end

	var_18_9 = 0

	::label_18_0::

	local num = proximity_target_distance + var_18_9
	local priority_target_distance = _blackboard.priority_target_distance
	local var_18_12

	if priority_target_enemy == target_unit then
		var_18_12 = num_5

		if not var_18_12 then
			-- Nothing
		end
	end

	var_18_12 = 0

	::label_18_1::

	local num_2 = priority_target_distance + var_18_12
	local urgent_target_distance = _blackboard.urgent_target_distance
	local var_18_15

	if urgent_target_enemy == target_unit then
		var_18_15 = num_5

		if not var_18_15 then
			-- Nothing
		end
	end

	var_18_15 = 0

	::label_18_2::

	local num_3 = urgent_target_distance + var_18_15
	local opportunity_target_distance = _blackboard.opportunity_target_distance
	local var_18_18

	if opportunity_target_enemy == target_unit then
		var_18_18 = num_5

		if not var_18_18 then
			-- Nothing
		end
	end

	var_18_18 = 0

	::label_18_3::

	local num_4 = opportunity_target_distance + var_18_18

	if not slot_target_enemy then
		-- Nothing
	end

	::label_18_4::

	do
		local length = Vector3.length(POSITION_LOOKUP[slot_target_enemy] - var_18_0)
		local var_18_21

		if slot_target_enemy == target_unit then
			var_18_21 = num_5

			if not var_18_21 then
				-- Nothing
			end
		end

		var_18_21 = 0

		::label_18_5::

		local num_6 = length + var_18_21
	end

	::label_18_6::

	if not (not priority_target_enemy and not (num_2 < 3)) then
		_blackboard.target_unit = priority_target_enemy
	elseif not (not urgent_target_enemy and not (num_3 < 3)) then
		_blackboard.target_unit = urgent_target_enemy
	elseif not (not opportunity_target_enemy and not (num_4 < 3)) then
		_blackboard.target_unit = opportunity_target_enemy
	elseif not (not slot_target_enemy and not (num_6 < 3)) then
		_blackboard.target_unit = slot_target_enemy
	elseif not (not proximity_target_enemy and not (num < 2)) then
		_blackboard.target_unit = proximity_target_enemy
	elseif not (not proximity_target_enemy and not _blackboard.proximity_target_is_player and not (num < 10)) then
		_blackboard.target_unit = proximity_target_enemy
	elseif not priority_target_enemy then
		_blackboard.target_unit = priority_target_enemy
	elseif not urgent_target_enemy then
		_blackboard.target_unit = urgent_target_enemy
	elseif not opportunity_target_enemy then
		_blackboard.target_unit = opportunity_target_enemy
	elseif not slot_target_enemy then
		_blackboard.target_unit = slot_target_enemy
	elseif not _blackboard.target_unit then
		_blackboard.target_unit = nil
	end
end

local tbl = {}

PlayerBotBase._update_proximity_target = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local _blackboard = self._blackboard

	if arg_19_2 > self._proximity_target_update_timer then
		local _unit = self._unit

		self._proximity_target_update_timer = arg_19_2 + 0.25 + Math.random() * 0.15

		local proximite_enemies = _blackboard.proximite_enemies

		table.clear(proximite_enemies)

		local var_19_3 = num

		_blackboard.aggressive_mode = false
		_blackboard.force_aid = false

		local var_19_4

		if not ALIVE[_blackboard.target_ally_unit] and not _blackboard.target_ally_needs_aid and not self:within_aid_range(_blackboard) then
			var_19_4 = POSITION_LOOKUP[_blackboard.target_ally_unit]

			local is_prioritized_ally = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(_unit, _blackboard.target_ally_unit)
			local flag = _blackboard.current_interaction_unit == _blackboard.target_ally_unit

			if not is_prioritized_ally and not flag then
				var_19_3 = num_3
				_blackboard.force_aid = true
			elseif not is_prioritized_ally then
				var_19_3 = num_2
				_blackboard.force_aid = true
			else
				_blackboard.aggressive_mode = true
				var_19_3 = num_4
			end
		else
			var_19_4 = arg_19_3
		end

		local side = _blackboard.side
		local query = Broadphase.query(self._enemy_broadphase, var_19_4, var_19_3, tbl, side.enemy_broadphase_categories)
		local huge = math.huge
		local var_19_10
		local huge_2 = math.huge

		for k, v in pairs(side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS) do
			query = query + 1
			tbl[query] = k
		end

		local num_6 = 1

		for k_2 = 1, query do
			local var_19_13 = tbl[k_2]

			if not HEALTH_ALIVE[var_19_13] then
				local num_7 = POSITION_LOOKUP[var_19_13] - var_19_4

				if not self:_target_valid(var_19_13, num_7) then
					proximite_enemies[num_6] = var_19_13
					num_6 = num_6 + 1

					local length = Vector3.length(num_7)
					local var_19_16

					if var_19_13 == _blackboard.target_unit then
						var_19_16 = num_5

						if not var_19_16 then
							-- Nothing
						end
					end

					var_19_16 = 0

					::label_19_0::

					local num_8 = length + var_19_16

					if num_8 < huge then
						var_19_10 = var_19_13
						huge = num_8
						huge_2 = length
					end
				end
			end
		end

		if _blackboard.proximity_target_enemy or not var_19_10 then
			_blackboard.proximity_target_enemy = var_19_10
			_blackboard.proximity_target_is_player = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_19_10] ~= nil
		end

		_blackboard.proximity_target_distance = huge_2
	elseif not (not _blackboard.proximity_target_enemy and ALIVE[_blackboard.proximity_target_enemy]) then
		_blackboard.proximity_target_enemy = nil
		_blackboard.proximity_target_distance = math.huge
		_blackboard.proximity_target_is_player = nil
	end
end

local sin = math.sin(math.pi * 0.25)

PlayerBotBase._target_valid = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local var_20_0 = BLACKBOARDS[arg_20_1]

	if not var_20_0 and not var_20_0.breed.not_bot_target then
		return false
	end

	if not (not ScriptUnit.has_extension(arg_20_1, "ai_group_system") and var_20_0.target_unit) then
		return false
	end

	local dot = Vector3.dot(Vector3.up(), Vector3.normalize(arg_20_2))

	if not (dot > sin or not (dot < -sin)) then
		return false
	end

	return true
end

PlayerBotBase._update_slot_target = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local _blackboard = self._blackboard
	local _unit = self._unit
	local target_unit = _blackboard.target_unit
	local var_21_3 = arg_21_3
	local _get_closest_target_in_slot = self:_get_closest_target_in_slot(var_21_3, _unit, target_unit, true)

	if not _get_closest_target_in_slot then
		_blackboard.slot_target_enemy = _get_closest_target_in_slot

		return
	end

	local target_ally_unit = _blackboard.target_ally_unit

	if not ALIVE[target_ally_unit] then
		local _get_closest_target_in_slot_2 = self:_get_closest_target_in_slot(var_21_3, target_ally_unit, target_unit)

		if not _get_closest_target_in_slot_2 then
			_blackboard.slot_target_enemy = _get_closest_target_in_slot_2

			return
		end
	end

	local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[_unit].PLAYER_AND_BOT_UNITS
	local var_21_8
	local huge = math.huge

	for i = 1, #PLAYER_AND_BOT_UNITS do
		local var_21_10 = PLAYER_AND_BOT_UNITS[i]

		if not (var_21_10 == target_ally_unit or var_21_10 == _unit) then
			local _get_closest_target_in_slot_3, var_21_12 = self:_get_closest_target_in_slot(var_21_3, var_21_10, target_unit)

			if var_21_12 < huge then
				var_21_8 = _get_closest_target_in_slot_3
				huge = var_21_12
			end
		end
	end

	if not var_21_8 then
		_blackboard.slot_target_enemy = var_21_8

		return
	end

	if not _blackboard.slot_target_enemy then
		_blackboard.slot_target_enemy = nil
	end
end

local num_24 = -1
local keys = table.keys(SlotTypeSettings)

PlayerBotBase._get_closest_target_in_slot = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local system = Managers.state.entity:system("ai_slot_system")
	local var_22_1
	local huge = math.huge

	for i = 1, #keys do
		local var_22_3 = keys[i]
		local get_target_unit_slot_data = system:get_target_unit_slot_data(arg_22_2, var_22_3)

		if not get_target_unit_slot_data then
			for k, v in pairs(get_target_unit_slot_data) do
				local ai_unit = v.ai_unit

				if not HEALTH_ALIVE[ai_unit] then
					local length = Vector3.length(POSITION_LOOKUP[ai_unit] - arg_22_1)

					if ai_unit == arg_22_3 then
						length = length + num_5
					end

					if not arg_22_4 and not Unit.get_data(ai_unit, "breed").is_bot_threat then
						length = length + num_24
					end

					if length < huge then
						var_22_1 = ai_unit
						huge = length
					end
				end
			end
		end
	end

	return var_22_1, huge
end

PlayerBotBase._alter_target_position = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	local var_23_0
	local var_23_1

	if arg_23_5 == "ledge" then
		local local_rotation = Unit.local_rotation(arg_23_3, 0)

		var_23_0 = arg_23_4 - Vector3.normalize(Vector3.flat(Quaternion.forward(local_rotation))) * 0.5
	elseif not (arg_23_5 == "in_need_of_heal" or arg_23_5 == "can_accept_grenade" or arg_23_5 == "can_accept_potion" or arg_23_5 ~= "can_accept_heal_item") then
		local average_velocity = ScriptUnit.extension(arg_23_3, "locomotion_system"):average_velocity()

		if Vector3.length_squared(average_velocity) > 2.25 then
			var_23_0 = arg_23_4 + average_velocity
		else
			var_23_0 = arg_23_4 + Vector3.normalize(arg_23_2 - arg_23_4)
		end
	elseif arg_23_5 ~= "knocked_down" or not self._blackboard.aggressive_mode then
		var_23_0 = arg_23_4 + Vector3.normalize(arg_23_2 - arg_23_4) * INTERACT_RAY_DISTANCE
	elseif arg_23_5 == "in_need_of_attention_stop" then
		var_23_0 = Vector3(arg_23_2.x, arg_23_2.y, arg_23_2.z)
		var_23_1 = true
	else
		var_23_0 = Vector3(arg_23_4.x, arg_23_4.y, arg_23_4.z) + Vector3.normalize(arg_23_2 - arg_23_4) * INTERACT_RAY_DISTANCE
	end

	if not var_23_1 then
		return var_23_0, var_23_1
	end

	local num = 0.5
	local num_2 = 3
	local triangle_from_position, var_23_7 = GwNavQueries.triangle_from_position(arg_23_1, var_23_0, num, num_2)

	if not triangle_from_position then
		var_23_0.z = var_23_7

		return var_23_0
	else
		local num_3 = 2
		local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(arg_23_1, arg_23_4, num, num_2, num_3, 0.1)

		if not inside_position_from_outside_position then
			return inside_position_from_outside_position
		else
			return arg_23_4
		end
	end
end

PlayerBotBase._find_target_position_on_nav_mesh = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local num = 0.5
	local num_2 = 0.5
	local triangle_from_position, var_24_3 = GwNavQueries.triangle_from_position(arg_24_1, arg_24_2, num, num_2)

	if not triangle_from_position then
		return Vector3(arg_24_2.x, arg_24_2.y, var_24_3)
	else
		local num_3 = 2.5
		local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(arg_24_1, arg_24_2, num, num_2, num_3, 0.1)

		if not inside_position_from_outside_position then
			return inside_position_from_outside_position
		else
			return arg_24_2
		end
	end
end

PlayerBotBase._update_target_ally = function (self, arg_25_1, arg_25_2)
	-- function 25
	local _unit = self._unit
	local _blackboard = self._blackboard
	local _bot_profile = self._bot_profile
	local var_25_3
	local var_25_4
	local var_25_5
	local var_25_6

	if not (not _blackboard.target_unit and _blackboard.target_unit ~= _blackboard.priority_target_enemy) then
		var_25_3 = _blackboard.priority_target_disabled_ally
		var_25_4 = Vector3.distance(POSITION_LOOKUP[_unit], POSITION_LOOKUP[var_25_3])
	else
		var_25_3, var_25_4, var_25_5, var_25_6 = self:_select_ally_by_utility(_unit, _blackboard, _bot_profile, arg_25_2)
	end

	local flag = not var_25_3 and _blackboard.target_ally_unit ~= var_25_3

	_blackboard.target_ally_unit = var_25_3 or nil
	_blackboard.ally_distance = var_25_4

	if flag or not _blackboard.target_ally_unit or not var_25_5 then
		if not (not _blackboard.target_ally_needs_aid and flag and var_25_5 == "in_need_of_attention_look") then
			local follow = _blackboard.follow

			if not follow then
				follow.needs_target_position_refresh = true
			end
		end

		_blackboard.target_ally_needs_aid = true
		_blackboard.target_ally_need_type = var_25_5
	elseif not _blackboard.target_ally_needs_aid then
		_blackboard.target_ally_needs_aid = false
		_blackboard.target_ally_need_type = nil
	end

	local input_extension = _blackboard.input_extension

	if not var_25_6 then
		input_extension:set_look_at_player(var_25_3, false)
	else
		input_extension:set_look_at_player(nil)
	end

	local flag_2 = _blackboard.target_ally_need_type == "knocked_down" or _blackboard.target_ally_need_type == "ledge" or _blackboard.target_ally_need_type == "hook"

	if not _blackboard.target_ally_needs_aid and not flag_2 then
		Managers.state.entity:system("ai_bot_group_system"):register_ally_needs_aid_priority(_unit, _blackboard.target_ally_unit)
	end
end

local degrees_to_radians = math.degrees_to_radians(30)
local num_25 = 3.5

PlayerBotBase._player_needs_attention = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	-- function 26
	local var_26_0 = self._seen_by_players[arg_26_2]
	local wielded_slot = arg_26_4:equipment().wielded_slot
	local get_slot_data = arg_26_4:get_slot_data(wielded_slot)

	if not (not var_26_0 and arg_26_3.target_unit or get_slot_data ~= nil) then
		return false, 0
	end

	local is_wounded = arg_26_3.status_extension:is_wounded()
	local current_permanent_health_percent = arg_26_3.health_extension:current_permanent_health_percent()
	local get_item_template = arg_26_4:get_item_template(get_slot_data)
	local can_heal_other = get_item_template.can_heal_other
	local can_give_other = get_item_template.can_give_other
	local flag = not arg_26_3.inventory_extension:get_slot_data(wielded_slot)
	local flag_2 = not can_give_other and flag
	local flag_3 = not can_heal_other and is_wounded or current_permanent_health_percent < num_18
	local num = POSITION_LOOKUP[arg_26_1] - POSITION_LOOKUP[arg_26_2]
	local normalize = Vector3.normalize(num)
	local current_velocity = arg_26_5:current_velocity()
	local normalize_2 = Vector3.normalize(current_velocity)
	local length_squared = Vector3.length_squared(current_velocity)
	local current_velocity_2 = arg_26_3.locomotion_extension:current_velocity()
	local normalize_3 = Vector3.normalize(current_velocity_2)
	local length_squared_2 = Vector3.length_squared(current_velocity_2)
	local flag_4 = Vector3.dot(normalize, normalize_2) > degrees_to_radians
	local var_26_20

	if length_squared_2 > 0.01 then
		var_26_20 = Vector3.dot(normalize, normalize_3) <= degrees_to_radians
	else
		var_26_20 = false
	end

	local var_26_21
	local var_26_22
	local var_26_23 = num_25

	if not flag_4 and wielded_slot ~= "slot_healthkit" or flag_3 or not flag_2 then
		var_26_22 = 0.5 - (1 - current_permanent_health_percent) * 0.2
		var_26_21 = 0.25
		var_26_23 = var_26_23 + math.sqrt(length_squared)
	elseif math.min(length_squared_2, length_squared) > 0.01 or not var_26_20 then
		var_26_22 = math.huge
		var_26_21 = 0.5
	elseif not (not (length_squared_2 <= 0.01) or not (length_squared <= 0.01)) then
		var_26_22 = 0.3
		var_26_21 = 0.25
	else
		var_26_22 = 1.25
		var_26_21 = 0.5
	end

	local length_squared_3 = Vector3.length_squared(num)

	if not (length_squared_3 > var_26_23^2 or not (length_squared_3 <= 0.25)) then
		var_26_22 = math.huge
	end

	local system = Managers.state.entity:system("ai_bot_group_system")
	local flag_5 = system:get_ammo_pickup_order_unit(arg_26_1) ~= nil or system:has_pending_pickup_order(arg_26_1)
	local num_2 = arg_26_6 - var_26_0

	if not (not (var_26_22 < num_2) or flag_5) then
		local clamp = math.clamp(num_2, 0, 2)

		return "stop", clamp
	elseif var_26_21 < num_2 then
		local clamp_2 = math.clamp(num_2, 0, 0.5)

		return "look_at", clamp_2
	end
end

PlayerBotBase._calculate_healing_item_utility = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	if not arg_27_3 then
		local num

		if not arg_27_2 then
			num = arg_27_1 - 0.5

			if not num then
				-- Nothing
			end
		end

		num = arg_27_1

		::label_27_0::

		return 1 - num
	else
		local num_2

		if not arg_27_2 then
			num_2 = arg_27_1 * 0.33

			if not num_2 then
				-- Nothing
			end
		end

		num_2 = arg_27_1

		::label_27_1::

		return 1 - num_2
	end
end

PlayerBotBase._select_ally_by_utility = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local var_28_0 = POSITION_LOOKUP[arg_28_1]
	local var_28_1
	local huge = math.huge
	local huge_2 = math.huge
	local var_28_4
	local flag = false
	local extension = ScriptUnit.extension(arg_28_1, "buff_system")
	local inventory_extension = arg_28_2.inventory_extension
	local get_slot_data = inventory_extension:get_slot_data("slot_healthkit")
	local flag_2 = false
	local flag_3 = false
	local num = 0

	if not get_slot_data then
		local is_wounded = self._status_extension:is_wounded()
		local get_item_template = inventory_extension:get_item_template(get_slot_data)
		local has_buff_type = extension:has_buff_type("trait_necklace_no_healing_health_regen")

		flag_2 = get_item_template.can_heal_other
		flag_3 = get_item_template.can_give_other

		if not has_buff_type and not is_wounded then
			local current_permanent_health_percent = self._health_extension:current_permanent_health_percent()

			num = self:_calculate_healing_item_utility(current_permanent_health_percent, is_wounded, flag_3) + num_14
		end
	end

	local flag_4 = false
	local get_slot_data_2 = inventory_extension:get_slot_data("slot_grenade")

	if not get_slot_data_2 then
		flag_4 = inventory_extension:get_item_template(get_slot_data_2).can_give_other
	end

	local flag_5 = false
	local get_slot_data_3 = inventory_extension:get_slot_data("slot_potion")

	if not get_slot_data_3 then
		flag_5 = inventory_extension:get_item_template(get_slot_data_3).can_give_other
	end

	local conflict = Managers.state.conflict
	local get_player_unit_segment = conflict:get_player_unit_segment(arg_28_1)

	get_player_unit_segment = get_player_unit_segment or 1

	local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_28_1].PLAYER_AND_BOT_UNITS

	for i = 1, #PLAYER_AND_BOT_UNITS do
		local var_28_23 = PLAYER_AND_BOT_UNITS[i]

		if var_28_23 == arg_28_1 or not HEALTH_ALIVE[var_28_23] then
			local extension_2 = ScriptUnit.extension(var_28_23, "status_system")
			local num_2 = 0
			local flag_6 = false

			if not (extension_2:is_ready_for_assisted_respawn() or extension_2.near_vortex) then
				local get_player_unit_segment_2 = conflict:get_player_unit_segment(var_28_23)

				get_player_unit_segment_2 = get_player_unit_segment_2 or 1

				if get_player_unit_segment <= get_player_unit_segment_2 then
					local flag_7 = not Managers.player:owner(var_28_23):is_player_controlled()
					local flag_8

					flag_8 = not flag_7 and 0 and num_15

					local var_28_30

					if not extension_2:is_knocked_down() then
						var_28_30 = "knocked_down"
						num_2 = 200
					elseif not (not extension_2:get_is_ledge_hanging() and extension_2:is_pulled_up()) then
						var_28_30 = "ledge"
						num_2 = 200
					elseif not extension_2:is_hanging_from_hook() then
						var_28_30 = "hook"
						num_2 = 200
					else
						local flag_9 = not var_28_23 and ScriptUnit.extension(var_28_23, "career_system")
						local flag_10 = true

						if not (not flag_9 and flag_9:career_name() ~= "wh_zealot" or not (extension_2:num_wounds_remaining() > 1)) then
							flag_10 = false
						end

						local current_permanent_health_percent_2 = ScriptUnit.extension(var_28_23, "health_system"):current_permanent_health_percent()
						local has_buff_type_2 = ScriptUnit.extension(var_28_23, "buff_system"):has_buff_type("trait_necklace_no_healing_health_regen")
						local extension_3 = ScriptUnit.extension(var_28_23, "inventory_system")
						local extension_4 = ScriptUnit.extension(var_28_23, "locomotion_system")
						local is_wounded_2 = extension_2:is_wounded()
						local num_3 = self:_calculate_healing_item_utility(current_permanent_health_percent_2, is_wounded_2, flag_3) + flag_8
						local flag_11 = num < num_3
						local _player_needs_attention, var_28_41 = self:_player_needs_attention(arg_28_1, var_28_23, arg_28_2, extension_3, extension_4, arg_28_4)

						if not flag_2 and (current_permanent_health_percent_2 < num_16 or not is_wounded_2 or not flag_11) and not flag_10 then
							var_28_30 = "in_need_of_heal"
							num_2 = 70 + num_3 * 15
						elseif not flag_3 and (not has_buff_type_2 and is_wounded_2 and current_permanent_health_percent_2 < num_17 or not is_wounded_2 and extension_3:get_slot_data("slot_healthkit")) or not flag_11 then
							var_28_30 = "can_accept_heal_item"
							num_2 = 70 + num_3 * 10
						elseif not (not flag_4 and not extension_3:get_slot_data("slot_grenade") and extension_3:can_store_additional_item("slot_grenade") and flag_7) then
							var_28_30 = "can_accept_grenade"
							num_2 = 70
						elseif not (not flag_5 and not extension_3:get_slot_data("slot_potion") and extension_3:can_store_additional_item("slot_potion") and flag_7) then
							var_28_30 = "can_accept_potion"
							num_2 = 70
						elseif _player_needs_attention == "stop" then
							var_28_30 = "in_need_of_attention_stop"
							flag_6 = true
							num_2 = 5 + var_28_41
						elseif _player_needs_attention == "look_at" then
							var_28_30 = "in_need_of_attention_look"
							flag_6 = true
							num_2 = 2 + var_28_41
						end
					end

					if not (var_28_30 or flag_7) then
						local var_28_42 = POSITION_LOOKUP[var_28_23]
						local _ally_path_allowed, var_28_44 = self:_ally_path_allowed(arg_28_1, var_28_23, arg_28_4)

						if not _ally_path_allowed then
							if not var_28_44 then
								var_28_30 = nil
							elseif not var_28_30 then
								local alive_bosses = conflict:alive_bosses()
								local count = #alive_bosses

								for j = 1, count do
									local var_28_47 = alive_bosses[j]
									local var_28_48 = POSITION_LOOKUP[var_28_47]
									local distance_squared = Vector3.distance_squared(var_28_0, var_28_48)
									local var_28_50 = BLACKBOARDS[var_28_47]
									local override_target_unit = var_28_50.override_target_unit

									override_target_unit = override_target_unit or var_28_50.target_unit

									if not (override_target_unit ~= arg_28_1 or not (distance_squared < 10)) then
										var_28_30 = nil
										num_2 = 0

										break
									end
								end
							end

							if not flag_7 then
								num_2 = num_2 * 1.5
							end

							if not (var_28_30 or flag_7) then
								local distance = Vector3.distance(var_28_0, var_28_42)
								local num_4 = distance - num_2

								if num_4 < huge then
									huge = num_4
									huge_2 = distance
									var_28_1 = var_28_23
									var_28_4 = var_28_30
									flag = flag_6
								end
							end
						end
					end
				end
			end
		end
	end

	return var_28_1, huge_2, var_28_4, flag
end

PlayerBotBase.within_aid_range = function (self, arg_29_1)
	-- function 29
	if not arg_29_1.target_ally_needs_aid then
		local var_29_0 = POSITION_LOOKUP[self._unit]
		local var_29_1 = POSITION_LOOKUP[arg_29_1.target_ally_unit]

		if Vector3.distance_squared(var_29_0, var_29_1) <= num^2 then
			return true
		end
	end

	return false
end

PlayerBotBase._update_liquid_escape = function (self)
	-- function 30
	local _unit = self._unit
	local _blackboard = self._blackboard
	local _status_extension = self._status_extension
	local is_in_liquid = _status_extension:is_in_liquid()
	local use_liquid_escape_destination = _blackboard.use_liquid_escape_destination
	local navigation_extension = _blackboard.navigation_extension
	local is_disabled = _status_extension:is_disabled()

	if (not is_in_liquid and is_disabled or not use_liquid_escape_destination) and not navigation_extension:destination_reached() then
		local in_liquid_unit = _status_extension.in_liquid_unit
		local get_rim_nodes, var_30_9 = ScriptUnit.extension(in_liquid_unit, "area_damage_system"):get_rim_nodes()
		local var_30_10 = POSITION_LOOKUP[_unit]
		local huge = math.huge
		local var_30_12

		if not var_30_9 then
			local count = #get_rim_nodes

			for i = 1, count do
				local unbox = get_rim_nodes[i]:unbox()
				local distance_squared = Vector3.distance_squared(var_30_10, unbox)

				if distance_squared < huge then
					var_30_12 = unbox
					huge = distance_squared
				end
			end
		else
			for k, v in pairs(get_rim_nodes) do
				local unbox_2 = v.position:unbox()
				local distance_squared_2 = Vector3.distance_squared(var_30_10, unbox_2)

				if distance_squared_2 < huge then
					var_30_12 = unbox_2
					huge = distance_squared_2
				end
			end
		end

		if not var_30_12 then
			_blackboard.navigation_liquid_escape_destination_override:store(var_30_12)

			_blackboard.use_liquid_escape_destination = true
		end
	elseif not (not use_liquid_escape_destination and is_disabled or is_in_liquid) then
		_blackboard.use_liquid_escape_destination = false
	end
end

PlayerBotBase._should_re_evaluate_vortex_escape = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	-- function 31
	local flag = false
	local var_31_1

	if not ALIVE[arg_31_4] then
		var_31_1 = not ScriptUnit.extension(arg_31_4, "ai_supplementary_system"):is_position_inside(arg_31_1, num_19)
	else
		var_31_1 = true
	end

	if not var_31_1 then
		local distance_squared = Vector3.distance_squared(arg_31_2, arg_31_1)
		local destination_reached = arg_31_3:destination_reached()

		flag = distance_squared >= num_21 or not destination_reached or distance_squared >= num_22
	end

	return flag, var_31_1
end

PlayerBotBase._find_vortex_escape_destination = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	-- function 32
	local var_32_0
	local var_32_1
	local _vortex_escape_directions = self._vortex_escape_directions
	local count = #_vortex_escape_directions

	for i = 1, count do
		local var_32_4 = _vortex_escape_directions[i]
		local weight = var_32_4.weight
		local num = weight^2
		local rotate = Quaternion.rotate(arg_32_2, var_32_4.direction:unbox())
		local raycast, var_32_9 = GwNavQueries.raycast(arg_32_3, arg_32_1, arg_32_1 + rotate * num_19, arg_32_4)
		local num_2 = Vector3.distance_squared(arg_32_1, var_32_9) * num

		if arg_32_5 < num_2 then
			var_32_0 = weight
			arg_32_5 = num_2
			var_32_1 = var_32_9

			if arg_32_6 <= num_2 + 0.0001 then
				break
			end
		end
	end

	return var_32_1, var_32_0, arg_32_5
end

PlayerBotBase._update_vortex_escape = function (self)
	-- function 33
	local _unit = self._unit
	local _blackboard = self._blackboard
	local var_33_2 = POSITION_LOOKUP[_unit]
	local _status_extension = self._status_extension
	local near_vortex = _status_extension.near_vortex
	local use_vortex_escape_destination = _blackboard.use_vortex_escape_destination
	local navigation_extension = _blackboard.navigation_extension
	local is_disabled = _status_extension:is_disabled()
	local flag = false
	local flag_2 = false

	if not use_vortex_escape_destination then
		local vortex_escape_unit = _blackboard.vortex_escape_unit
		local unbox = _blackboard.navigation_vortex_escape_previous_evaluation_position:unbox()

		flag, flag_2 = self:_should_re_evaluate_vortex_escape(var_33_2, unbox, navigation_extension, vortex_escape_unit)
	end

	if not ((is_disabled or flag or not near_vortex) and use_vortex_escape_destination) then
		_blackboard.navigation_vortex_escape_previous_evaluation_position:store(var_33_2)

		local _locomotion_extension = self._locomotion_extension
		local nav_world = _blackboard.nav_world

		if not _locomotion_extension:is_on_ground() and not GwNavQueries.triangle_from_position(nav_world, var_33_2, 0.25, 0.25) then
			local num = -math.huge
			local _vortex_largest_weighted_distance_sq = self._vortex_largest_weighted_distance_sq

			if not flag then
				local unbox_2 = _blackboard.navigation_vortex_escape_destination_override:unbox()
				local num_2 = (_blackboard.navigation_vortex_escape_weight + num_20)^2

				num = Vector3.distance_squared(var_33_2, unbox_2) * num_2

				if _vortex_largest_weighted_distance_sq <= num then
					return
				end
			end

			local near_vortex_unit = _status_extension.near_vortex_unit

			near_vortex_unit = near_vortex_unit or _blackboard.vortex_escape_unit

			local num_3 = var_33_2 - POSITION_LOOKUP[near_vortex_unit]
			local look = Quaternion.look(num_3, Vector3.up())
			local traverse_logic = navigation_extension:traverse_logic()
			local _find_vortex_escape_destination, var_33_23, var_33_24 = self:_find_vortex_escape_destination(var_33_2, look, nav_world, traverse_logic, num, _vortex_largest_weighted_distance_sq)

			if not _find_vortex_escape_destination then
				_blackboard.use_vortex_escape_destination = true

				_blackboard.navigation_vortex_escape_destination_override:store(_find_vortex_escape_destination)

				_blackboard.navigation_vortex_escape_weight = var_33_23
				_blackboard.vortex_escape_unit = near_vortex_unit
			end
		end
	elseif not use_vortex_escape_destination and is_disabled and flag_2 and near_vortex and not navigation_extension:destination_reached() then
		_blackboard.use_vortex_escape_destination = false
		_blackboard.vortex_escape_unit = nil
	end
end

PlayerBotBase._update_attack_request = function (self, arg_34_1)
	-- function 34
	local _blackboard = self._blackboard
	local get_bot_weapon_extension = AiUtils.get_bot_weapon_extension(_blackboard)

	if not get_bot_weapon_extension then
		get_bot_weapon_extension:update_bot_attack_request(arg_34_1)
	end
end

PlayerBotBase._update_pickups = function (self, arg_35_1, arg_35_2)
	-- function 35
	local _unit = self._unit
	local _blackboard = self._blackboard

	_blackboard.needs_ammo = false
	_blackboard.has_ammo_missing = false

	local priority_target_enemy = _blackboard.priority_target_enemy

	priority_target_enemy = priority_target_enemy or _blackboard.target_unit

	local flag

	flag = not ALIVE[priority_target_enemy] and 0.1 and 0.9

	local current_ammo_status, var_35_5 = _blackboard.inventory_extension:current_ammo_status("slot_ranged")

	if not (not current_ammo_status and not (current_ammo_status < var_35_5)) then
		_blackboard.needs_ammo = Managers.state.entity:system("ai_bot_group_system"):get_ammo_pickup_order_unit(_unit) ~= nil or flag > current_ammo_status / var_35_5
		_blackboard.has_ammo_missing = current_ammo_status ~= var_35_5
	end
end

local tbl_2 = {}

PlayerBotBase._update_interactables = function (self, arg_36_1, arg_36_2)
	-- function 36
	local _blackboard = self._blackboard

	if arg_36_2 > self._interactable_timer then
		self._interactable_timer = arg_36_2 + 0.2 + Math.random() * 0.15

		local interaction_unit = _blackboard.interaction_unit

		interaction_unit = not interaction_unit and ScriptUnit.has_extension(_blackboard.interaction_unit, "door_system")

		if not (not interaction_unit and _blackboard.interaction_unit == _blackboard.target_ally_unit) then
			_blackboard.interaction_unit = nil
			_blackboard.interaction_type = nil
		end

		if not _blackboard.navigation_extension:destination_reached() then
			return
		end

		local var_36_2 = POSITION_LOOKUP[self._unit]
		local get_doors = Managers.state.entity:system("door_system"):get_doors(var_36_2, 1.5, tbl_2)
		local var_36_4
		local huge = math.huge
		local var_36_6

		for i = 1, get_doors do
			local var_36_7 = tbl_2[i]

			if not (not ScriptUnit.has_extension(var_36_7, "interactable_system") and ScriptUnit.extension(var_36_7, "door_system"):is_open()) then
				local var_36_8 = POSITION_LOOKUP[var_36_7]

				var_36_8 = var_36_8 or Unit.world_position(var_36_7, 0)

				local distance_squared = Vector3.distance_squared(var_36_2, var_36_8)

				if distance_squared < huge then
					huge = distance_squared
					var_36_4 = var_36_7
					var_36_6 = "door"
				end
			end
		end

		if not var_36_4 then
			_blackboard.interaction_unit = var_36_4
			_blackboard.interaction_type = var_36_6
		end
	elseif not alive(_blackboard.interaction_unit) then
		local has_extension = ScriptUnit.has_extension(_blackboard.interaction_unit, "door_system")

		if not has_extension and not has_extension:is_open() then
			_blackboard.interaction_unit = nil
			_blackboard.interaction_type = nil
		end
	elseif not _blackboard.interaction_unit then
		_blackboard.interaction_unit = nil
		_blackboard.interaction_type = nil
	end
end

local tbl_3 = {}

PlayerBotBase._find_cover = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	-- function 37
	local zero = Vector3.zero()

	for k, v in pairs(arg_37_1) do
		local var_37_1 = POSITION_LOOKUP[k]

		tbl_3[#tbl_3 + 1] = var_37_1

		local flat = Vector3.flat(arg_37_2 - var_37_1)

		zero = zero + Vector3.normalize(flat)
		arg_37_4 = math.min(arg_37_4, 0.5 * Vector3.length(flat))
	end

	local num = arg_37_2 + (arg_37_3 - arg_37_4) * zero
	local hidden_cover_points, var_37_5 = ConflictUtils.hidden_cover_points(num, tbl_3, 0, arg_37_3, -0.9)

	table.clear(tbl_3)

	return hidden_cover_points, var_37_5
end

local tbl_4 = {}

local function fn_4(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	-- function 38
	local num = arg_38_2 - arg_38_0
	local normalize = Vector3.normalize(arg_38_1 - arg_38_0)
	local dot = Vector3.dot(num, normalize)

	if not (dot <= 0 or not (arg_38_4 < dot)) then
		return false
	end

	if Vector3.length(num - dot * normalize) > math.min(dot, arg_38_3) then
		return false
	else
		return true
	end
end

PlayerBotBase._in_line_of_fire = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	-- function 39
	local flag = false
	local flag_2 = false
	local num = 2.5
	local num_2 = 6
	local num_3 = 40

	for k, v in pairs(arg_39_3) do
		local var_39_5 = arg_39_4[k]

		if not ALIVE[v] and v == arg_39_1 and not fn_4(POSITION_LOOKUP[k], POSITION_LOOKUP[v], arg_39_2, not var_39_5 and num_2 and num, num_3) then
			tbl_4[k] = v
			flag = flag or not var_39_5
			flag_2 = true
		end
	end

	for k_2, v_2 in pairs(arg_39_4) do
		if not tbl_4[k_2] then
			flag = true

			break
		end
	end

	table.clear(arg_39_4)

	for k_3, v_3 in pairs(tbl_4) do
		arg_39_4[k_3] = v_3
	end

	table.clear(tbl_4)

	return flag_2, flag
end

function to_hash(self)
	-- function 40
	return self.x + self.y * 10000 + self.z * 0.0001
end

PlayerBotBase.cb_cover_point_path_result = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	if not arg_41_2 then
		local taking_cover = self._blackboard.taking_cover

		taking_cover.failed_cover_points[arg_41_1] = true

		table.clear(taking_cover.active_threats)
	end
end

PlayerBotBase._update_cover = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	-- function 42
	local var_42_0
	local _in_line_of_fire, var_42_2 = self:_in_line_of_fire(arg_42_1, arg_42_2, arg_42_4.threats, arg_42_4.active_threats)
	local system = Managers.state.entity:system("ai_bot_group_system")

	if not _in_line_of_fire and not var_42_2 then
		local fails = arg_42_4.fails
		local min = math.min(5 + fails * 5, 40)
		local num = min * 0.4
		local _find_cover, var_42_8 = self:_find_cover(arg_42_4.active_threats, arg_42_2, min, num)
		local var_42_9
		local var_42_10
		local var_42_11
		local var_42_12

		for i = 1, _find_cover do
			local var_42_13 = var_42_8[i]
			local local_position = Unit.local_position(var_42_13, 0)

			if not arg_42_4.failed_cover_points[to_hash(local_position)] then
				if not system:in_cover(var_42_13) then
					var_42_12 = var_42_12 or local_position
					var_42_11 = var_42_11 or var_42_13
				else
					var_42_9 = local_position
					var_42_10 = var_42_13

					break
				end
			end
		end

		var_42_9 = var_42_9 or var_42_12
		var_42_10 = var_42_10 or var_42_11

		if not var_42_9 then
			var_42_0 = var_42_9

			arg_42_4.cover_position:store(var_42_0)

			arg_42_4.cover_unit = var_42_10
			arg_42_4.fails = 0

			system:set_in_cover(arg_42_1, var_42_10)
		else
			arg_42_4.fails = arg_42_4.fails + 1

			table.clear(arg_42_4.active_threats)
		end
	elseif _in_line_of_fire or not var_42_2 then
		arg_42_4.cover_position:store(Vector3.invalid_vector())

		arg_42_4.cover_unit = nil
		arg_42_4.fails = 0
		arg_42_5.needs_target_position_refresh = true

		system:set_in_cover(arg_42_1, nil)
	elseif not _in_line_of_fire then
		var_42_0 = arg_42_4.cover_position:unbox()
	end

	local ranged_obstruction_by_static = arg_42_3.ranged_obstruction_by_static
	local flag = not ranged_obstruction_by_static and ranged_obstruction_by_static.unit

	if not arg_42_4.active_threats[flag] then
		arg_42_3.ranged_obstruction_by_static = nil
	end

	return var_42_0
end

PlayerBotBase.new_destination_distance_check = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	-- function 43
	local num = arg_43_3 - arg_43_2
	local flag = math.abs(num.z) > Z_MOVE_TO_EPSILON or Vector3.length_squared(Vector3.flat(num)) > num_11

	if not arg_43_4:destination_reached() then
		local num_2 = arg_43_1 - arg_43_4:position_when_destination_reached()
		local flag_2 = math.abs(num_2.z) > Z_MOVE_TO_EPSILON or Vector3.length_squared(Vector3.flat(num_2)) > num_12
		local num_3 = arg_43_3 - arg_43_1
		local flag_3 = math.abs(num_3.z) > Z_MOVE_TO_EPSILON or Vector3.length_squared(Vector3.flat(num_3)) > num_11

		return flag_2 or not flag or flag_3
	else
		return flag
	end
end

local num_26 = 15
local num_27 = 2

PlayerBotBase._update_movement_target = function (self, arg_44_1, arg_44_2)
	-- function 44
	local _unit = self._unit
	local var_44_1 = POSITION_LOOKUP[_unit]
	local _blackboard = self._blackboard
	local avoiding_aoe_threat = _blackboard.input_extension:avoiding_aoe_threat()
	local navigation_destination_override = _blackboard.navigation_destination_override
	local melee = _blackboard.melee

	if not melee then
		melee = _blackboard.melee.engage_position_set
		melee = not melee and navigation_destination_override:unbox()
	end

	local shoot = _blackboard.shoot

	if not shoot then
		shoot = _blackboard.shoot.disengage_position_set
		shoot = not shoot and navigation_destination_override:unbox()
	end

	local activate_ability_data = _blackboard.activate_ability_data

	if not activate_ability_data then
		activate_ability_data = _blackboard.activate_ability_data.move_to_position_set
		activate_ability_data = not activate_ability_data and navigation_destination_override:unbox()
	end

	local use_liquid_escape_destination = _blackboard.use_liquid_escape_destination

	use_liquid_escape_destination = not use_liquid_escape_destination and _blackboard.navigation_liquid_escape_destination_override:unbox()

	local use_vortex_escape_destination = _blackboard.use_vortex_escape_destination

	use_vortex_escape_destination = not use_vortex_escape_destination and _blackboard.navigation_vortex_escape_destination_override:unbox()

	local flag = false
	local follow = _blackboard.follow
	local taking_cover = _blackboard.taking_cover
	local _update_cover = self:_update_cover(_unit, var_44_1, _blackboard, taking_cover, follow)
	local var_44_14
	local _nav_world = self._nav_world
	local target_ally_unit = _blackboard.target_ally_unit
	local target_ally_need_type = _blackboard.target_ally_need_type
	local flag_2 = true

	if not ALIVE[target_ally_unit] then
		local get_inside_transport_unit = ScriptUnit.extension(target_ally_unit, "status_system"):get_inside_transport_unit()

		if not (not alive(get_inside_transport_unit) and _blackboard.target_ally_needs_aid) then
			_blackboard.ally_inside_transport_unit = get_inside_transport_unit

			if not (ScriptUnit.extension(_blackboard.ally_inside_transport_unit, "transportation_system").story_state == "stopped_beginning") then
				var_44_14 = LocomotionUtils.new_goal_in_transport(_nav_world, _unit, target_ally_unit)
			end
		elseif not _blackboard.ally_inside_transport_unit then
			_blackboard.ally_inside_transport_unit = nil
		elseif not (not target_ally_need_type and target_ally_need_type == "in_need_of_attention_stop" or target_ally_need_type ~= "in_need_of_attention_look") then
			flag_2 = ScriptUnit.extension(target_ally_unit, "locomotion_system").has_moved_from_start_position
		end
	else
		_blackboard.ally_inside_transport_unit = nil
	end

	local navigation_extension = _blackboard.navigation_extension
	local destination = navigation_extension:destination()
	local ai_bot_group_extension = _blackboard.ai_bot_group_extension
	local get_hold_position, var_44_24 = ai_bot_group_extension:get_hold_position()
	local flag_3 = not get_hold_position and get_hold_position - destination
	local flag_4 = not flag_3 and math.abs(flag_3.z)
	local flag_5 = not flag_3 and Vector3.length_squared(Vector3.flat(flag_3))
	local flag_6 = not flag_3 and flag_4 > num_13 and var_44_24 < flag_5
	local vortex_exist

	if not use_vortex_escape_destination then
		vortex_exist = _blackboard.vortex_exist

		if not vortex_exist then
			vortex_exist = not navigation_extension:is_path_safe_from_vortex(num_26, num_27)
		end
	else
		vortex_exist = false
	end

	if false then
		vortex_exist = true
	end

	if not flag_6 then
		navigation_extension:move_to(get_hold_position)

		_blackboard.using_navigation_destination_override = true
	elseif not vortex_exist then
		local path_callback = navigation_extension:path_callback()

		if not path_callback then
			path_callback(false, destination, true)
		end

		navigation_extension:stop()

		if not melee then
			_blackboard.melee.engage_position_set = false
		end

		if not shoot then
			_blackboard.shoot.disengage_position_set = false
		end

		if not activate_ability_data then
			_blackboard.activate_ability_data.move_to_position_set = false
		end
	elseif avoiding_aoe_threat or use_vortex_escape_destination or use_liquid_escape_destination or _update_cover or melee or shoot or not activate_ability_data then
		local flag_7 = var_44_14 or use_vortex_escape_destination or use_liquid_escape_destination or _update_cover or melee or shoot or activate_ability_data
		local num = flag_7 - destination

		if not (not (get_hold_position == nil or var_44_24 >= Vector3.distance_squared(get_hold_position, flag_7)) and math.abs(num.z) > Z_MOVE_TO_EPSILON or not (Vector3.length(Vector3.flat(num)) > FLAT_MOVE_TO_EPSILON)) then
			local stop_at_current_position

			if not melee then
				stop_at_current_position = _blackboard.melee.stop_at_current_position

				if not stop_at_current_position then
					-- Nothing
				end
			end

			stop_at_current_position = not shoot and _blackboard.shoot.stop_at_current_position

			::label_44_0::

			if not stop_at_current_position then
				navigation_extension:stop()
			else
				local var_44_34

				if var_44_14 or not _update_cover then
					var_44_34 = callback(self, "cb_cover_point_path_result", to_hash(flag_7))

					if not var_44_34 then
						-- Nothing
					end
				end

				var_44_34 = nil

				::label_44_1::

				navigation_extension:move_to(flag_7, var_44_34)
			end

			_blackboard.using_navigation_destination_override = true
		end
	else
		follow.follow_timer = follow.follow_timer - arg_44_1

		local is_interacting = _blackboard.interaction_extension:is_interacting()
		local flag_8 = target_ally_need_type == "in_need_of_attention_stop"

		if follow.needs_target_position_refresh or follow.follow_timer < 0 or flag_8 or not _blackboard.target_ally_needs_aid or is_interacting or not navigation_extension:destination_reached() then
			follow.needs_target_position_refresh = true
		end

		local system = Managers.state.entity:system("ai_bot_group_system")
		local flag_9 = system:get_ammo_pickup_order_unit(_unit) ~= nil or system:has_pending_pickup_order(_unit)

		if not follow.needs_target_position_refresh and flag_2 and not flag_9 then
			local var_44_39
			local var_44_40
			local goal_selection_func = _blackboard.follow.goal_selection_func
			local var_44_42
			local target_unit = _blackboard.target_unit
			local priority_target_enemy = _blackboard.priority_target_enemy
			local get_pickup_order = system:get_pickup_order(_unit, "slot_healthkit")
			local unit

			if not get_pickup_order then
				unit = get_pickup_order.unit

				if not unit then
					-- Nothing
				end
			end

			unit = nil

			::label_44_2::

			local get_pickup_order_2 = system:get_pickup_order(_unit, "slot_potion")
			local unit_2

			if not get_pickup_order_2 then
				unit_2 = get_pickup_order_2.unit

				if not unit_2 then
					-- Nothing
				end
			end

			unit_2 = nil

			::label_44_3::

			if not (not _blackboard.revive_with_urgent_target and not _blackboard.target_ally_needs_aid and target_ally_need_type == "in_need_of_attention_look") then
				var_44_39, var_44_40 = self:_alter_target_position(_nav_world, var_44_1, target_ally_unit, POSITION_LOOKUP[target_ally_unit], target_ally_need_type)
				_blackboard.interaction_unit = target_ally_unit

				_blackboard.target_ally_aid_destination:store(var_44_39)

				var_44_42 = callback(self, "cb_ally_path_result", target_ally_unit)
			elseif not priority_target_enemy and target_unit == priority_target_enemy or not self:_enemy_path_allowed(priority_target_enemy) then
				var_44_39 = self:_find_target_position_on_nav_mesh(_nav_world, POSITION_LOOKUP[priority_target_enemy])
				var_44_42 = callback(self, "cb_enemy_path_result", priority_target_enemy)
			elseif not (not target_unit and target_unit == priority_target_enemy and target_unit == _blackboard.urgent_target_enemy and not self:_enemy_path_allowed(target_unit) and _blackboard.input_extension:avoiding_aoe_threat()) then
				var_44_39 = self:_find_target_position_on_nav_mesh(_nav_world, POSITION_LOOKUP[target_unit])
				var_44_42 = callback(self, "cb_enemy_path_result", target_unit)
			elseif not (not _blackboard.target_ally_needs_aid and target_ally_need_type == "in_need_of_attention_look") then
				var_44_39, var_44_40 = self:_alter_target_position(_nav_world, var_44_1, target_ally_unit, POSITION_LOOKUP[target_ally_unit], target_ally_need_type)
				_blackboard.interaction_unit = target_ally_unit

				_blackboard.target_ally_aid_destination:store(var_44_39)

				var_44_42 = callback(self, "cb_ally_path_result", target_ally_unit)
			elseif not goal_selection_func and not ALIVE[target_ally_unit] then
				var_44_39 = LocomotionUtils[goal_selection_func](_nav_world, _unit, target_ally_unit)
			elseif not ((not alive(_blackboard.health_pickup) and not _blackboard.allowed_to_take_health_pickup and not (arg_44_2 < _blackboard.health_pickup_valid_until) or self._last_health_pickup_attempt.unit ~= _blackboard.health_pickup or not self._last_health_pickup_attempt.blacklist) and unit ~= _blackboard.health_pickup) then
				local health_pickup = _blackboard.health_pickup

				var_44_39 = self:_find_pickup_position_on_navmesh(_nav_world, var_44_1, health_pickup, self._last_health_pickup_attempt)

				local flag_10 = health_pickup == unit

				if not var_44_39 then
					var_44_42 = callback(self, "cb_health_pickup_path_result", health_pickup)
					_blackboard.interaction_unit = health_pickup
				elseif not flag_10 then
					_blackboard.interaction_unit = health_pickup
					_blackboard.forced_pickup_unit = health_pickup
				end
			elseif not ((not alive(_blackboard.mule_pickup) and self._last_mule_pickup_attempt.unit ~= _blackboard.mule_pickup or not self._last_mule_pickup_attempt.blacklist) and unit_2 ~= _blackboard.mule_pickup) then
				local mule_pickup = _blackboard.mule_pickup

				var_44_39 = self:_find_pickup_position_on_navmesh(_nav_world, var_44_1, mule_pickup, self._last_mule_pickup_attempt)

				local flag_11 = mule_pickup == unit_2

				if not var_44_39 then
					var_44_42 = callback(self, "cb_mule_pickup_path_result", mule_pickup)
					_blackboard.interaction_unit = mule_pickup
				elseif not flag_11 then
					_blackboard.interaction_unit = mule_pickup
					_blackboard.forced_pickup_unit = mule_pickup
				end
			end

			if not ((var_44_39 or not alive(_blackboard.ammo_pickup) or not _blackboard.has_ammo_missing) and not (arg_44_2 < _blackboard.ammo_pickup_valid_until)) then
				local var_44_53 = POSITION_LOOKUP[_blackboard.ammo_pickup]
				local normalize = Vector3.normalize(var_44_1 - var_44_53)
				local num_2 = 0.5
				local num_3 = 1.5
				local num_4 = INTERACT_RAY_DISTANCE - 0.3
				local num_5 = 0

				var_44_39 = self:_find_position_on_navmesh(_nav_world, var_44_53, var_44_53 + normalize, num_2, num_3, num_4, num_5)

				if not var_44_39 then
					_blackboard.interaction_unit = _blackboard.ammo_pickup
				end
			end

			if not (not get_hold_position and not var_44_39 and var_44_24 < Vector3.distance_squared(get_hold_position, var_44_39)) then
				var_44_39 = nil
			end

			if not (var_44_39 or avoiding_aoe_threat) then
				var_44_39 = ai_bot_group_extension.data.follow_position
				flag = true
			end

			if not var_44_40 then
				navigation_extension:stop()
			elseif not var_44_39 then
				_blackboard.moving_toward_follow_position = flag
				follow.needs_target_position_refresh = false
				follow.follow_timer = math.lerp(num_6, num_7, Math.random())

				follow.target_position:store(var_44_39)

				if not self:new_destination_distance_check(var_44_1, destination, var_44_39, navigation_extension) then
					navigation_extension:move_to(var_44_39, var_44_42)
				end

				_blackboard.using_navigation_destination_override = false
			end
		end

		if not _blackboard.using_navigation_destination_override then
			navigation_extension:move_to(follow.target_position:unbox())

			_blackboard.using_navigation_destination_override = false
		end

		local current_goal = navigation_extension:current_goal()
		local system_2 = Managers.state.entity:system("area_damage_system")

		if not current_goal and not system_2:is_position_in_liquid(current_goal, BotNavTransitionManager.NAV_COST_MAP_LAYERS) then
			navigation_extension:stop()
		end
	end
end

local tbl_5 = {
	QuaternionBox(Quaternion(Vector3.up(), 0)),
	QuaternionBox(Quaternion(Vector3.up(), math.pi * 0.25)),
	QuaternionBox(Quaternion(Vector3.up(), -math.pi * 0.25)),
	QuaternionBox(Quaternion(Vector3.up(), math.pi * 0.5)),
	QuaternionBox(Quaternion(Vector3.up(), -math.pi * 0.5)),
	QuaternionBox(Quaternion(Vector3.up(), math.pi * 0.75)),
	QuaternionBox(Quaternion(Vector3.up(), -math.pi * 0.75)),
	QuaternionBox(Quaternion(Vector3.up(), math.pi))
}

PlayerBotBase._find_pickup_position_on_navmesh = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
	-- function 45
	local num = 1.5
	local num_2 = 2.2
	local num_3 = 0.1
	local num_4 = INTERACT_RAY_DISTANCE - 0.3
	local count = #tbl_5
	local var_45_5 = POSITION_LOOKUP[arg_45_3]

	if arg_45_4.unit ~= arg_45_3 then
		arg_45_4.unit = arg_45_3
		arg_45_4.index = 1
		arg_45_4.distance = 0
		arg_45_4.path_failed = true

		arg_45_4.rotation:store(Quaternion.look(Vector3.flat(arg_45_2 - var_45_5), Vector3.up()))

		arg_45_4.blacklist = false
	end

	if not arg_45_4.path_failed then
		local index = arg_45_4.index
		local unbox = arg_45_4.rotation:unbox()
		local distance = arg_45_4.distance
		local var_45_9

		while not (not (index <= count) or var_45_9) do
			local multiply = Quaternion.multiply(tbl_5[index]:unbox(), unbox)
			local forward = Quaternion.forward(multiply)

			distance = math.min(distance + num_3, 1)

			local num_5 = var_45_5 + forward * (distance * num_4)
			local triangle_from_position, var_45_14 = GwNavQueries.triangle_from_position(arg_45_1, num_5, num, num_2)

			if not triangle_from_position then
				num_5.z = var_45_14

				if distance >= 0.8 then
					var_45_9 = num_5
				else
					local num_6 = num_5 + (1 - distance) * forward * num_4
					local raycast, var_45_17 = GwNavQueries.raycast(arg_45_1, num_5, num_6)

					if not raycast then
						var_45_9 = num_6
						distance = 1
					else
						var_45_9 = 0.1 * num_5 + var_45_17 * 0.9
						distance = Vector3.dot(Vector3.flat(var_45_9 - var_45_5), forward)
					end
				end
			end

			if distance >= 1 - FLAT_MOVE_TO_EPSILON then
				index = index + 1
				distance = 0
			end
		end

		arg_45_4.distance = distance
		arg_45_4.index = index

		if not var_45_9 then
			arg_45_4.path_failed = false

			arg_45_4.path_position:store(var_45_9)

			return var_45_9
		else
			arg_45_4.blacklist = true

			return
		end
	else
		return arg_45_4.path_position:unbox()
	end
end

PlayerBotBase._find_position_on_navmesh = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7)
	-- function 46
	local triangle_from_position, var_46_1 = GwNavQueries.triangle_from_position(arg_46_1, arg_46_3, arg_46_4, arg_46_5)

	if not triangle_from_position then
		return Vector3(arg_46_3.x, arg_46_3.y, var_46_1)
	else
		local triangle_from_position_2, var_46_3 = GwNavQueries.triangle_from_position(arg_46_1, arg_46_2, arg_46_4, arg_46_5)
		local var_46_4 = var_46_3

		if not triangle_from_position_2 then
			return Vector3(arg_46_3.x, arg_46_3.y, var_46_4)
		else
			return GwNavQueries.inside_position_from_outside_position(arg_46_1, arg_46_2, arg_46_4, arg_46_5, arg_46_6, arg_46_7)
		end
	end
end

PlayerBotBase.unit_removed_from_game = function (arg_47_0)
	-- function 47
	return
end

PlayerBotBase.destroy = function (self)
	-- function 48
	self._brain:destroy()

	if not self._blackboard.taking_cover.cover_unit then
		Managers.state.entity:system("ai_bot_group_system"):set_in_cover(self._unit, nil)
	end
end

PlayerBotBase._debug_draw_update = function (self, arg_49_1)
	-- function 49
	if not script_data.debug_behaviour_trees then
		self._brain:debug_draw_behaviours()
	end

	local str = "bot_debug" .. self._player.player_name
	local drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = str
	})
	local num = Unit.local_position(self._unit, 0) + Vector3.up() * 2
	local unbox = self._player.color:unbox()

	drawer:sphere(num, 0.25, unbox)

	local _blackboard = self._blackboard
	local target_unit = _blackboard.target_unit
	local target_ally_unit = _blackboard.target_ally_unit
	local num_2 = self._player:local_player_id() * 0.05

	if not ALIVE[target_unit] then
		local world_pose = Unit.world_pose(target_unit, 0)
		local num_3 = 1.5 + num_2

		Matrix4x4.set_translation(world_pose, POSITION_LOOKUP[target_unit] + Vector3.up() * num_3)
		drawer:line(num, Unit.world_position(target_unit, 0) + Vector3(0, 0, 1.5), Color(125, 255, 0, 0))
		drawer:box(world_pose, Vector3(0.5 + num_2, 0.5 + num_2, num_3), unbox)
	end

	if not ALIVE[target_ally_unit] then
		drawer:circle(POSITION_LOOKUP[target_ally_unit] + Vector3(0, 0, 0.2), 0.6 + num_2, Vector3.up(), unbox, 16)
	end

	self._brain:debug_draw_current_behavior()
end

PlayerBotBase.clear_failed_paths = function (self)
	-- function 50
	table.clear(self._attempted_ally_paths)
	table.clear(self._attempted_enemy_paths)
end

PlayerBotBase.cb_enemy_path_result = function (self, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
	-- function 51
	if not arg_51_4 then
		return
	end

	local _attempted_enemy_paths = self._attempted_enemy_paths
	local var_51_1 = _attempted_enemy_paths[arg_51_1]

	if not var_51_1 then
		var_51_1 = {
			last_path_destination = Vector3Box()
		}
		_attempted_enemy_paths[arg_51_1] = var_51_1
	end

	local flag = not arg_51_2

	if not flag then
		self._blackboard.follow.needs_target_position_refresh = true
	end

	var_51_1.failed = flag

	var_51_1.last_path_destination:store(arg_51_3)

	for k, v in pairs(_attempted_enemy_paths) do
		if not alive(k) then
			_attempted_enemy_paths[k] = nil
		end
	end
end

PlayerBotBase._enemy_path_allowed = function (self, arg_52_1)
	-- function 52
	local var_52_0 = self._attempted_enemy_paths[arg_52_1]
	local var_52_1 = POSITION_LOOKUP[arg_52_1]

	if not (not var_52_0 and not var_52_0.failed and not (Vector3.distance_squared(var_52_1, var_52_0.last_path_destination:unbox()) < num_8) or not (math.abs(var_52_1.z - var_52_0.last_path_destination:unbox().z) < num_9)) then
		return false
	end

	return true
end

PlayerBotBase.cb_health_pickup_path_result = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	-- function 53
	if not arg_53_4 then
		return
	end

	if arg_53_1 == self._last_health_pickup_attempt.unit then
		self._last_health_pickup_attempt.path_failed = not arg_53_2
	end
end

PlayerBotBase.cb_mule_pickup_path_result = function (self, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	-- function 54
	if not arg_54_4 then
		return
	end

	if arg_54_1 == self._last_mule_pickup_attempt.unit then
		self._last_mule_pickup_attempt.path_failed = not arg_54_2
	end
end

PlayerBotBase.cb_ally_path_result = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	-- function 55
	local _attempted_ally_paths = self._attempted_ally_paths
	local var_55_1 = _attempted_ally_paths[arg_55_1]

	if not var_55_1 then
		var_55_1 = {
			last_path_destination = Vector3Box()
		}
		_attempted_ally_paths[arg_55_1] = var_55_1
	end

	local flag = not arg_55_2

	var_55_1.failed = flag

	var_55_1.last_path_destination:store(arg_55_3)

	var_55_1.forced_callback = arg_55_4

	if not flag then
		var_55_1.ignore_ally_from = Managers.time:time("game")
	else
		var_55_1.ignore_ally_from = -math.huge
	end

	for k, v in pairs(_attempted_ally_paths) do
		if not alive(k) then
			_attempted_ally_paths[k] = nil
		end
	end
end

local num_28 = 25
local num_29 = 225
local num_30 = 3
local num_31 = 12

PlayerBotBase._ally_path_allowed = function (self, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	local var_56_0 = self._attempted_ally_paths[arg_56_2]

	if not var_56_0 and not var_56_0.failed then
		local var_56_1 = POSITION_LOOKUP[arg_56_1]
		local var_56_2 = POSITION_LOOKUP[arg_56_2]
		local distance_squared = Vector3.distance_squared(var_56_1, var_56_2)
		local inv_lerp_clamped = math.inv_lerp_clamped(num_28, num_29, distance_squared)
		local lerp = math.lerp(num_30, num_31, inv_lerp_clamped)

		if arg_56_3 > var_56_0.ignore_ally_from + lerp then
			return true, true
		end

		local conflict = Managers.state.conflict
		local get_player_unit_segment = conflict:get_player_unit_segment(self._unit)

		get_player_unit_segment = get_player_unit_segment or -1

		local get_player_unit_segment_2 = conflict:get_player_unit_segment(arg_56_2)

		get_player_unit_segment_2 = get_player_unit_segment_2 or -1

		local var_56_9
		local flag

		flag = (not (get_player_unit_segment < get_player_unit_segment_2) or not 1 or not (get_player_unit_segment_2 < get_player_unit_segment)) and (not 10 or 5)

		if not (arg_56_3 > var_56_0.ignore_ally_from + flag) then
			local unbox = var_56_0.last_path_destination:unbox()
			local flag_2 = Vector3.distance_squared(var_56_2, unbox) > num_10
			local forced_callback = var_56_0.forced_callback

			return true, flag_2 or forced_callback
		else
			return false, false
		end
	else
		return true, true
	end
end

local function fn_5(self)
	-- function 57
	if not self then
		return 1, 0, 1, 0
	end

	local huge = math.huge
	local num = -math.huge
	local num_2 = 1
	local num_3 = 1

	for i = 1, #self do
		local var_57_4 = self[i]

		if not var_57_4.input and var_57_4.action == nil and var_57_4.sub_action == nil or not string.find(var_57_4.input, "action_one") then
			local start_time = var_57_4.start_time

			if start_time < huge then
				huge = start_time
				num_2 = i
			end

			if num < start_time then
				num = start_time
				num_3 = i
			end
		end
	end

	return num_2, huge, num_3, num
end

PlayerBotBase._update_weapon_metadata = function (arg_58_0, arg_58_1)
	-- function 58
	local flag = not arg_58_1 and arg_58_1.attack_meta_data

	if not (not flag and arg_58_1._precalculated_metadata) then
		print("updating bot weapon metadata for weapon:", not arg_58_1 and arg_58_1.name)

		local get_used_actions = WeaponUtils.get_used_actions(arg_58_1)

		if not get_used_actions.action_one then
			local action_one = arg_58_1.actions.action_one
			local num = 0
			local num_2 = 6
			local tbl = {
				total_chain_time = 0,
				armor_mods = {
					0,
					0,
					0,
					0,
					0,
					0
				}
			}
			local tbl_2 = {
				total_chain_time = 0,
				armor_mods = {
					0,
					0,
					0,
					0,
					0,
					0
				}
			}

			for k, v in pairs(get_used_actions.action_one) do
				local var_58_7 = action_one[k]

				if not ActionUtils.is_melee_start_sub_action(var_58_7) then
					local allowed_chain_actions = var_58_7.allowed_chain_actions
					local anim_time_scale = var_58_7.anim_time_scale

					anim_time_scale = anim_time_scale or 1

					local var_58_10, var_58_11, var_58_12, var_58_13 = fn_5(allowed_chain_actions)

					tbl.total_chain_time = tbl.total_chain_time + var_58_11 * anim_time_scale
					tbl_2.total_chain_time = tbl_2.total_chain_time + var_58_13 * anim_time_scale

					local action = allowed_chain_actions[var_58_10].action
					local sub_action = allowed_chain_actions[var_58_10].sub_action
					local var_58_16 = arg_58_1.actions[action][sub_action]
					local flag_2 = var_58_16.anim_time_scale or 1
					local var_58_18, var_58_19 = fn_5(var_58_16.allowed_chain_actions)

					tbl.total_chain_time = tbl.total_chain_time + var_58_19 * flag_2

					local get_performance_scores_for_sub_action = ActionUtils.get_performance_scores_for_sub_action(var_58_16)
					local action_2 = allowed_chain_actions[var_58_12].action
					local sub_action_2 = allowed_chain_actions[var_58_12].sub_action
					local var_58_23 = arg_58_1.actions[action_2][sub_action_2]
					local flag_3 = var_58_23.anim_time_scale or 1
					local var_58_25, var_58_26 = fn_5(var_58_23.allowed_chain_actions)

					tbl_2.total_chain_time = tbl_2.total_chain_time + var_58_26 * flag_3

					local get_performance_scores_for_sub_action_2 = ActionUtils.get_performance_scores_for_sub_action(var_58_23)

					if not get_performance_scores_for_sub_action and not get_performance_scores_for_sub_action_2 then
						for k_2 = 1, num_2 do
							tbl.armor_mods[k_2] = tbl.armor_mods[k_2] + get_performance_scores_for_sub_action[k_2]
							tbl_2.armor_mods[k_2] = tbl_2.armor_mods[k_2] + get_performance_scores_for_sub_action_2[k_2]
						end

						num = num + 1
					end
				end
			end

			local tap_attack = flag.tap_attack

			if not tap_attack then
				for l = 1, #tbl.armor_mods do
					tbl.armor_mods[l] = tbl.armor_mods[l] / num
				end

				tap_attack.armor_modifiers = tbl.armor_mods
				tap_attack.speed_mod = 1 / math.clamp(tbl.total_chain_time / num, 0.1, 10)
			end

			local hold_attack = flag.hold_attack

			if not hold_attack then
				for i4 = 1, #tbl_2.armor_mods do
					tbl_2.armor_mods[i4] = tbl_2.armor_mods[i4] / num
				end

				hold_attack.armor_modifiers = tbl_2.armor_mods
				hold_attack.speed_mod = 1 / math.clamp(tbl_2.total_chain_time / num, 0.1, 10)
			end
		end

		arg_58_1._precalculated_metadata = true
	end
end

PlayerBotBase._update_weapon_loadout_data = function (self, arg_59_1)
	-- function 59
	local _blackboard = self._blackboard
	local inventory_extension = _blackboard.inventory_extension
	local recently_acquired = inventory_extension:recently_acquired("slot_melee")
	local recently_acquired_2 = inventory_extension:recently_acquired("slot_ranged")

	if recently_acquired or recently_acquired_2 or not arg_59_1 then
		local get_slot_data = inventory_extension:get_slot_data("slot_melee")
		local flag = not get_slot_data and inventory_extension:get_item_template(get_slot_data)
		local flag_2 = not flag and flag.buff_type
		local get_slot_data_2 = inventory_extension:get_slot_data("slot_ranged")
		local flag_3 = not get_slot_data_2 and inventory_extension:get_item_template(get_slot_data_2)
		local flag_4 = not flag_3 and flag_3.buff_type

		if not MeleeBuffTypes[flag_2] and not MeleeBuffTypes[flag_4] then
			_blackboard.double_weapons = "slot_melee"
		elseif not RangedBuffTypes[flag_2] and not RangedBuffTypes[flag_4] then
			_blackboard.double_weapons = "slot_ranged"
		else
			_blackboard.double_weapons = nil
		end

		self:_update_weapon_metadata(flag)
		self:_update_weapon_metadata(flag_3)
	end
end

PlayerBotBase._update_best_weapon = function (self)
	-- function 60
	local _blackboard = self._blackboard

	if not _blackboard.double_weapons then
		return
	end

	local get_combat_conditions = AiUtils.get_combat_conditions(_blackboard)
	local weapon_scores = _blackboard.weapon_scores

	weapon_scores = weapon_scores or {}

	local slot_melee = weapon_scores.slot_melee

	slot_melee = slot_melee or {}

	local slot_ranged = weapon_scores.slot_ranged

	slot_ranged = slot_ranged or {}

	local inventory_extension = _blackboard.inventory_extension
	local get_slot_data = inventory_extension:get_slot_data("slot_melee")
	local get_item_template = inventory_extension:get_item_template(get_slot_data)

	slot_melee.input, slot_melee.meta, slot_melee.score = AiUtils.get_melee_weapon_score(get_combat_conditions, get_item_template)
	slot_melee.score = slot_melee.score

	local get_slot_data_2 = inventory_extension:get_slot_data("slot_ranged")
	local get_item_template_2 = inventory_extension:get_item_template(get_slot_data_2)

	slot_ranged.input, slot_ranged.meta, slot_ranged.score = AiUtils.get_melee_weapon_score(get_combat_conditions, get_item_template_2)
	slot_ranged.score = slot_ranged.score
	weapon_scores.slot_melee = slot_melee
	weapon_scores.slot_ranged = slot_ranged
	_blackboard.weapon_scores = weapon_scores
end

PlayerBotBase._update_reload = function (self)
	-- function 61
	local _blackboard = self._blackboard
	local inventory_extension = _blackboard.inventory_extension
	local get_slot_data = inventory_extension:get_slot_data("slot_ranged")
	local flag = not get_slot_data and get_slot_data.right_unit_1p
	local flag_2 = not get_slot_data and get_slot_data.left_unit_1p
	local get_ammo_extension = GearUtils.get_ammo_extension(flag, flag_2)
	local var_61_6

	if not get_ammo_extension then
		local var_61_7

		if not inventory_extension:has_unique_ammo_type_weapon_equipped() then
			var_61_7 = get_ammo_extension:total_remaining_ammo() < get_ammo_extension:max_ammo()
		else
			var_61_7 = not not get_ammo_extension:clip_full() or get_ammo_extension:remaining_ammo() > 0 or get_ammo_extension:infinite_ammo()
		end

		if not var_61_7 then
			var_61_6 = "slot_ranged"
		end
	end

	if var_61_6 == nil then
		local career_extension = _blackboard.career_extension

		if not (not career_extension and career_extension:career_name() ~= "dr_engineer" or not (career_extension:current_ability_cooldown() > 0) or #_blackboard.proximite_enemies ~= 0) then
			var_61_6 = "slot_career_skill_weapon"
		end
	end

	_blackboard.wanted_slot_to_reload = var_61_6
end
