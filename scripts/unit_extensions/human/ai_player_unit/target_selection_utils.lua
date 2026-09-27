-- chunkname: @scripts/unit_extensions/human/ai_player_unit/target_selection_utils.lua

local HEALTH_ALIVE = HEALTH_ALIVE
local unit_knocked_down = AiUtils.unit_knocked_down
local distance = Vector3.distance
local POSITION_LOOKUP = POSITION_LOOKUP
local AI_TARGET_UNITS = AI_TARGET_UNITS
local AI_UTILS = AI_UTILS
local extension = ScriptUnit.extension
local tbl = {}

function get_ai_vs_ai_target(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local minion_detection_radius = arg_1_2.minion_detection_radius

	if not minion_detection_radius then
		minion_detection_radius = arg_1_2.detection_radius
		minion_detection_radius = minion_detection_radius or 7
	end

	if AiUtils.broadphase_query(arg_1_0, minion_detection_radius, tbl, arg_1_1.enemy_broadphase_categories) > 0 then
		local var_1_1 = tbl[1]
		local var_1_2 = distance(arg_1_0, POSITION_LOOKUP[var_1_1])

		return var_1_1, var_1_2
	end
end

PerceptionUtils.pick_closest_target = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0 = POSITION_LOOKUP[arg_2_0]
	local var_2_1
	local huge = math.huge
	local side = arg_2_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[v] then
			local var_2_7 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
			local distance = Vector3.distance(var_2_0, var_2_7)

			if not (not (distance < arg_2_2.detection_radius) or not (distance < huge)) then
				huge = distance
				var_2_1 = v
			end
		end
	end

	return var_2_1, huge
end

PerceptionUtils.pick_closest_target_with_filter = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = POSITION_LOOKUP[arg_3_0]
	local var_3_1
	local huge = math.huge
	local var_3_3 = AiUtils[arg_3_2.is_of_interest_func]
	local side = arg_3_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_3_8 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_3_8] and not var_3_3(var_3_8, arg_3_0) then
			local var_3_9 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
			local distance = Vector3.distance(var_3_0, var_3_9)

			if not (not (distance < arg_3_2.detection_radius) or not (distance < huge)) then
				huge = distance
				var_3_1 = var_3_8
			end
		end
	end

	return var_3_1, huge
end

local tbl_2 = {}

PerceptionUtils.pick_closest_vortex_target = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = POSITION_LOOKUP[arg_4_0]
	local var_4_1
	local huge = math.huge
	local vortex_data = arg_4_1.vortex_data
	local players_ejected

	if not vortex_data then
		players_ejected = vortex_data.players_ejected

		if not players_ejected then
			-- Nothing
		end
	end

	players_ejected = tbl_2

	::label_4_0::

	local side = arg_4_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_4_9 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_4_9] and players_ejected[var_4_9] or not AiUtils.is_of_interest_to_vortex(var_4_9) then
			local var_4_10 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
			local distance = Vector3.distance(var_4_0, var_4_10)

			if not (not (distance < arg_4_2.detection_radius) or not (distance < huge)) then
				huge = distance
				var_4_1 = var_4_9
			end
		end
	end

	return var_4_1, huge
end

PerceptionUtils.pick_boss_sorcerer_target = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = POSITION_LOOKUP[arg_5_0]
	local var_5_1
	local huge = math.huge
	local side = arg_5_1.side
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local recent_attacker_unit = arg_5_1.recent_attacker_unit

	if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[recent_attacker_unit] then
		local var_5_6 = POSITION_LOOKUP[recent_attacker_unit]
		local distance = Vector3.distance(var_5_0, var_5_6)

		return recent_attacker_unit, distance
	end

	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_5_10 = AiUtils[arg_5_2.is_of_interest_func]

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[v] and not var_5_10(v) then
			local var_5_11 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
			local distance_2 = Vector3.distance(var_5_0, var_5_11)

			if not (not (distance_2 < arg_5_2.detection_radius) or not (distance_2 < huge)) then
				huge = distance_2
				var_5_1 = v
			end
		end
	end

	return var_5_1, huge
end

PerceptionUtils.pick_closest_target_infinte_range = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = POSITION_LOOKUP[arg_6_0]
	local var_6_1
	local huge = math.huge
	local side = arg_6_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[v] then
			local var_6_7 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
			local distance = Vector3.distance(var_6_0, var_6_7)

			if distance < huge then
				huge = distance
				var_6_1 = v
			end
		end
	end

	return var_6_1, huge
end

PerceptionUtils.healthy_players = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local special_targets = arg_7_1.group_blackboard.special_targets
	local distance = Vector3.distance
	local num = -1000
	local var_7_3
	local var_7_4 = POSITION_LOOKUP[arg_7_0]
	local perception_weights = arg_7_2.perception_weights
	local max_distance = perception_weights.max_distance
	local side = arg_7_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_7_10 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local num_2 = 0

		if not AiUtils.is_of_interest_to_gutter_runner(arg_7_0, var_7_10, arg_7_1) then
			local var_7_12 = special_targets[var_7_10]

			if not var_7_12 then
				if var_7_12 == arg_7_0 then
					num_2 = num_2 + perception_weights.sticky_bonus
				else
					num_2 = num_2 + perception_weights.dog_pile_penalty
				end
			end

			local var_7_13 = distance(ENEMY_PLAYER_AND_BOT_POSITIONS[i], var_7_4)

			if var_7_13 < max_distance then
				num_2 = num_2 + math.clamp(1 - var_7_13 / max_distance, 0, 1) * perception_weights.distance_weight
			end

			if num < num_2 then
				var_7_3 = var_7_10
				num = num_2
			end
		end
	end

	return var_7_3
end

PerceptionUtils.pick_ninja_skulking_target = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return PerceptionUtils.pick_solitary_target(arg_8_0, arg_8_1, arg_8_2)
end

PerceptionUtils.pick_ninja_approach_target = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local target_unit = arg_9_1.target_unit

	if not arg_9_1.jump_data and not arg_9_1.jump_data.target_unit then
		return arg_9_1.jump_data.target_unit, arg_9_1.target_dist, 100
	end

	local side = arg_9_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_9_5
	local huge = math.huge
	local num = 0
	local special_targets = arg_9_1.group_blackboard.special_targets
	local var_9_9 = POSITION_LOOKUP[arg_9_0]

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_9_10 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local extension = ScriptUnit.extension(var_9_10, "status_system")

		if not (not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_9_10] and extension:is_disabled()) then
			local var_9_12 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
			local distance = Vector3.distance(var_9_9, var_9_12)

			if distance < huge then
				if not (not target_unit and target_unit == var_9_10 or not (distance < arg_9_2.approaching_switch_radius)) then
					huge = distance
					var_9_5 = var_9_10
					num = 10
				end
			elseif not special_targets[var_9_10] then
				arg_9_1.secondary_target = var_9_10
			end
		else
			arg_9_1.secondary_target = var_9_10
		end
	end

	return var_9_5, huge, num
end

PerceptionUtils.pick_solitary_target = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0 = POSITION_LOOKUP[arg_10_0]
	local var_10_1
	local huge = math.huge
	local num = 0

	if not arg_10_1.jump_data and not arg_10_1.jump_data.target_unit then
		return arg_10_1.jump_data.target_unit, arg_10_1.target_dist, 100
	end

	local target_unit = arg_10_1.target_unit

	if not ALIVE[target_unit] then
		local extension = ScriptUnit.extension(target_unit, "status_system")
		local is_pounced_down = extension:is_pounced_down()

		is_pounced_down = not is_pounced_down and extension:get_pouncer_unit() == arg_10_0

		if not is_pounced_down then
			return target_unit, arg_10_1.target_dist, 100
		end
	end

	local ENEMY_PLAYER_AND_BOT_UNITS = arg_10_1.side.ENEMY_PLAYER_AND_BOT_UNITS
	local var_10_8
	local count = #ENEMY_PLAYER_AND_BOT_UNITS

	if count == 1 then
		var_10_8 = ENEMY_PLAYER_AND_BOT_UNITS[1]
		num = 5
	elseif count <= 2 then
		var_10_8 = PerceptionUtils.healthy_players(arg_10_0, arg_10_1, arg_10_2)

		if not var_10_8 then
			num = 5
		end
	else
		local side = arg_10_1.side
		local var_10_11
		local var_10_12
		local get_cluster_and_loneliness, var_10_14, var_10_15

		get_cluster_and_loneliness, var_10_14, var_10_15, var_10_8 = Managers.state.conflict:get_cluster_and_loneliness(10, side.ENEMY_PLAYER_POSITIONS, side.ENEMY_PLAYER_UNITS)

		if not (var_10_15 > 4) or not AiUtils.is_of_interest_to_gutter_runner(arg_10_0, var_10_8, arg_10_1) then
			if var_10_15 > 15 then
				num = 10
			elseif not (not (var_10_15 > 10) or not (arg_10_1.total_slots_count >= 3)) then
				num = 5
			elseif not (not (var_10_15 > 4) or not (arg_10_1.total_slots_count >= 6)) then
				num = 5
			else
				num = 1
			end
		else
			var_10_8 = PerceptionUtils.healthy_players(arg_10_0, arg_10_1, arg_10_2)

			if not var_10_8 then
				num = 5
			end
		end
	end

	if not var_10_8 then
		huge = Vector3.distance(var_10_0, POSITION_LOOKUP[var_10_8])
		var_10_1 = var_10_8

		if huge < 10 then
			num = 10
		end
	end

	return var_10_1, huge, num
end

local num = 2.5
local num_2 = 2.5
local num_3 = 600
local num_4 = 5.0625
local num_5 = 4
local num_6 = 0.25
local num_7 = 5

local function fn(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local get_data = Unit.get_data(arg_11_0, "target_type")

	if not get_data then
		-- Nothing
	end

	::label_11_0::

	local perception_exceptions = arg_11_4.perception_exceptions

	perception_exceptions = not perception_exceptions and arg_11_4.perception_exceptions[get_data]

	::label_11_1::

	if not perception_exceptions then
		return
	end

	local num_7 = 0
	local num_8 = 0
	local flag = false
	local flag_2 = not arg_11_2 and arg_11_2 == arg_11_0

	if not ScriptUnit.has_extension(arg_11_0, "ai_slot_system") then
		if not ScriptUnit.extension(arg_11_0, "ai_slot_system").valid_target then
			return
		end

		local use_slot_type = arg_11_4.use_slot_type
		local system = Managers.state.entity:system("ai_slot_system")
		local total_slots_count = system:total_slots_count(arg_11_0, use_slot_type)

		num_7 = system:slots_count(arg_11_0, use_slot_type)
		num_8 = system:disabled_slots_count(arg_11_0, use_slot_type)
		flag = num_8 == total_slots_count

		local has_extension = ScriptUnit.has_extension(arg_11_0, "status_system")

		if not (not (not has_extension and has_extension:get_is_on_ladder()) and not (num_7 > (not flag_2 and total_slots_count and total_slots_count - 1))) then
			flag = true
		end
	end

	local var_11_10 = POSITION_LOOKUP[arg_11_0]

	if not var_11_10 then
		return
	end

	local distance_squared = Vector3.distance_squared(arg_11_3, var_11_10)
	local aggro_modifier = ScriptUnit.extension(arg_11_0, "aggro_system").aggro_modifier
	local var_11_13 = unit_knocked_down(arg_11_0)

	if not (not (distance_squared < num_4) or var_11_13) then
		num_7 = math.max(num_7 - 4, 0)
	end

	local target_stickyness_modifier = arg_11_4.target_stickyness_modifier

	target_stickyness_modifier = target_stickyness_modifier or -5

	if distance_squared > num_5 then
		target_stickyness_modifier = target_stickyness_modifier * 0.5
	end

	local num_9 = num_7 * num
	local num_10 = distance_squared * num_6
	local flag_3 = arg_11_0 ~= arg_11_1 or not target_stickyness_modifier or 0
	local flag_4

	flag_4 = not var_11_13 and 5 and 0

	local flag_5 = not flag_2 and arg_11_5 and 0
	local num_11 = num_8 * num_2
	local var_11_21

	if not flag then
		var_11_21 = num_3

		if not var_11_21 then
			-- Nothing
		end
	end

	var_11_21 = 0

	::label_11_2::

	return num_9 + num_10 + num_11 + var_11_21 + flag_3 + flag_5 + flag_4 + aggro_modifier, distance_squared
end

local tbl_3 = {
	[0] = 0,
	4,
	9,
	16,
	25,
	36
}

local function fn_2(self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local lean_dogpile = self.lean_dogpile
	local var_12_1

	if not USE_ENGINE_SLOID_SYSTEM then
		var_12_1 = Managers.state.conflict.dogpiled_attackers_on_unit[arg_12_3]
	else
		var_12_1 = Managers.state.conflict.gathering.dogpiled_attackers_on_unit[arg_12_3]
	end

	if not (not var_12_1 and var_12_1[arg_12_2]) then
		lean_dogpile = lean_dogpile - 1
	end

	local var_12_2 = tbl_3[lean_dogpile]

	var_12_2 = var_12_2 or 64

	local var_12_3 = POSITION_LOOKUP[arg_12_3]
	local distance_squared = Vector3.distance_squared(arg_12_1, var_12_3)

	return var_12_2 + distance_squared, distance_squared
end

local num_8 = 0.5

function tprint(arg_13_0, arg_13_1, ...)
	-- function 13
	if arg_13_0 == script_data.debug_unit then
		printf(arg_13_1, ...)
	end
end

local function fn_3(self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	local breed = self.breed
	local override_detection_radius = self.override_detection_radius

	if not override_detection_radius then
		override_detection_radius = self.detection_radius

		if not override_detection_radius then
			override_detection_radius = breed.minion_detection_radius

			if not override_detection_radius then
				override_detection_radius = breed.detection_radius
				override_detection_radius = override_detection_radius or 7
			end
		end
	end

	local var_14_2
	local var_14_3
	local lean_unit_list = self.lean_unit_list
	local var_14_5
	local var_14_6
	local var_14_7
	local next_lean_index = self.next_lean_index

	if self.next_lean_index <= 0 then
		local broadphase_query = AiUtils.broadphase_query(arg_14_1, override_detection_radius, tbl, arg_14_2.enemy_broadphase_categories)

		if broadphase_query > 0 then
			local var_14_10

			if math.random() < 0.9 then
				var_14_10 = math.min(broadphase_query, 5)
			else
				var_14_10 = math.min(broadphase_query, 12)
			end

			for i = 1, var_14_10 do
				lean_unit_list[i] = tbl[i]
			end

			self.next_lean_index = 1
			lean_unit_list.size = var_14_10
			var_14_3 = lean_unit_list[1]
		end
	else
		var_14_3 = lean_unit_list[next_lean_index]

		local num = next_lean_index + 1
		local flag

		flag = not (num >= lean_unit_list.size) or not 0 or num
		self.next_lean_index = flag
	end

	local huge = math.huge
	local var_14_14
	local var_14_15
	local target_unit = self.target_unit

	if not HEALTH_ALIVE[target_unit] then
		local var_14_17 = BLACKBOARDS[target_unit]

		if not var_14_17 and not var_14_17.lean_dogpile then
			huge = fn_2(var_14_17, arg_14_1, arg_14_3, target_unit) * num_8
			var_14_15 = target_unit
		end
	end

	if not (not HEALTH_ALIVE[var_14_3] and var_14_3 ~= var_14_15) then
		-- Nothing
	else
		local var_14_18 = BLACKBOARDS[var_14_3]

		if not arg_14_6[var_14_18.breed.name] then
			-- Nothing
		elseif var_14_18.lean_dogpile >= var_14_18.crowded_slots then
			-- Nothing
		else
			local var_14_19 = POSITION_LOOKUP[var_14_3]
			local var_14_20 = fn_2(var_14_18, arg_14_1, arg_14_3, var_14_3)

			if var_14_20 < huge then
				if not arg_14_4 then
					local node = Unit.node(arg_14_3, "j_head")
					local world_position = Unit.world_position(arg_14_3, node)

					if not AiUtils.line_of_sight_from_random_point(world_position, var_14_3) then
						goto label_14_0
					end
				end

				huge = var_14_20
				var_14_15 = var_14_3
			end
		end
	end

	::label_14_0::

	if not var_14_15 then
		return var_14_15, huge * 0.95
	else
		return nil, math.huge
	end
end

PerceptionUtils.horde_pick_closest_target_with_spillover = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	fassert(ScriptUnit.has_extension(arg_15_0, "ai_slot_system"), "Error! Trying to use slot_system perception for non-slot system unit!")

	local var_15_0 = POSITION_LOOKUP[arg_15_0]
	local target_unit = arg_15_1.target_unit
	local var_15_2
	local huge = math.huge
	local side = arg_15_1.side
	local AI_TARGET_UNITS = side.AI_TARGET_UNITS
	local perception_previous_attacker_stickyness_value = arg_15_2.perception_previous_attacker_stickyness_value
	local previous_attacker = arg_15_1.previous_attacker
	local var_15_8
	local flag = false
	local override_targets = arg_15_1.override_targets
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local enemy_units_lookup = side.enemy_units_lookup

	for k, v in pairs(override_targets) do
		local has_extension = ScriptUnit.has_extension(k, "status_system")
		local var_15_14

		if not has_extension then
			var_15_14 = VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[k]
		else
			var_15_14 = not enemy_units_lookup[k] and HEALTH_ALIVE[k]
		end

		local has_extension_2 = ScriptUnit.has_extension(k, "status_system")

		if not var_15_14 and v < arg_15_3 or not has_extension_2 or not has_extension_2:is_disabled() then
			override_targets[k] = nil
		else
			local var_15_16
			local var_15_17

			if not has_extension then
				var_15_16, var_15_17 = fn(k, target_unit, previous_attacker, var_15_0, arg_15_2, perception_previous_attacker_stickyness_value)
			else
				local var_15_18 = BLACKBOARDS[k]

				var_15_16, var_15_17 = fn_2(var_15_18, var_15_0, arg_15_0, k)
			end

			if not (not var_15_16 and not (var_15_16 < huge)) then
				huge = var_15_16
				var_15_2 = k
				var_15_8 = var_15_17
				flag = true
			end
		end
	end

	arg_15_1.using_override_target = flag

	if not flag then
		local var_15_19

		var_15_2, var_15_19 = fn_3(arg_15_1, var_15_0, side, arg_15_0, false, arg_15_3, arg_15_2.infighting.ignored_breed_filter)

		for i, v_2 in ipairs(AI_TARGET_UNITS) do
			local var_15_20, var_15_21 = fn(v_2, target_unit, previous_attacker, var_15_0, arg_15_2, perception_previous_attacker_stickyness_value)

			if not ((not not AiUtils.is_unwanted_target(side, v_2) or not var_15_20) and var_15_20 < var_15_19) then
				var_15_19 = var_15_20
				var_15_2 = v_2
				var_15_8 = var_15_21
			end
		end
	end

	return var_15_2, var_15_8
end

PerceptionUtils.pick_closest_target_near_detection_source_position = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local side = arg_16_1.side
	local var_16_1
	local detection_source_pos = arg_16_1.detection_source_pos

	if not detection_source_pos then
		var_16_1 = detection_source_pos:unbox()
	else
		var_16_1 = POSITION_LOOKUP[arg_16_0]
	end

	local var_16_3 = fn_3(arg_16_1, var_16_1, side, arg_16_0, true, arg_16_3, arg_16_2.infighting.ignored_breed_filter)
	local var_16_4 = POSITION_LOOKUP[var_16_3]
	local flag = not var_16_4 and Vector3.distance_squared(var_16_1, var_16_4)

	return var_16_3, flag
end

PerceptionUtils.pick_best_target_near_commander_target = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local commander_target = arg_17_1.commander_target

	if not HEALTH_ALIVE[commander_target] then
		arg_17_1.override_target_selection_name = nil

		return
	end

	local side = arg_17_1.side
	local var_17_2 = POSITION_LOOKUP[commander_target]
	local var_17_3 = fn_3(arg_17_1, var_17_2, side, arg_17_0, true, arg_17_3, arg_17_2.infighting.ignored_breed_filter)
	local var_17_4 = POSITION_LOOKUP[var_17_3]
	local flag = not var_17_4 and Vector3.distance_squared(var_17_2, var_17_4)

	return var_17_3, flag
end

PerceptionUtils.attack_commander_target_with_fallback = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local commander_target = arg_18_1.commander_target

	if not HEALTH_ALIVE[commander_target] then
		arg_18_1.override_target_selection_name = nil

		return
	end

	local var_18_1 = BLACKBOARDS[commander_target]

	if not var_18_1.lean_dogpile then
		local lean_dogpile = var_18_1.lean_dogpile
		local flag

		flag = arg_18_1.target_unit ~= commander_target or not 1 or 0

		if lean_dogpile - flag >= var_18_1.crowded_slots then
			return PerceptionUtils.pick_best_target_near_commander_target(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		end
	end

	return commander_target
end

local function fn_4(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10)
	-- function 19
	local get_data = Unit.get_data(arg_19_1, "target_type")

	if not get_data then
		-- Nothing
	end

	::label_19_0::

	local perception_exceptions = arg_19_6.perception_exceptions

	perception_exceptions = not perception_exceptions and arg_19_6.perception_exceptions[get_data]

	::label_19_1::

	if not perception_exceptions then
		return
	end

	local var_19_2 = POSITION_LOOKUP[arg_19_1]

	if not var_19_2 then
		return
	end

	local distance_squared = Vector3.distance_squared(arg_19_4, var_19_2)

	if not (not arg_19_2 and not arg_19_10 and not arg_19_10[arg_19_1]) then
		if not (arg_19_1 == arg_19_2 or not (arg_19_7 < distance_squared)) then
			return
		end

		if not (arg_19_9 or AiUtils.line_of_sight_from_random_point(arg_19_5, arg_19_1)) then
			return
		end
	end

	local num_8 = 0
	local num_9 = 0
	local flag = false
	local flag_2 = not arg_19_3 and arg_19_3 == arg_19_1
	local num_10 = 0
	local has_extension = ScriptUnit.has_extension(arg_19_1, "ai_slot_system")

	if not has_extension then
		local var_19_10 = BLACKBOARDS[arg_19_1]

		if not (not (not var_19_10 and var_19_10.is_player) and has_extension.valid_target) then
			return
		end

		local use_slot_type = arg_19_6.use_slot_type
		local system = Managers.state.entity:system("ai_slot_system")
		local total_slots_count = system:total_slots_count(arg_19_1, use_slot_type)

		num_8 = system:slots_count(arg_19_1, use_slot_type)
		num_9 = system:disabled_slots_count(arg_19_1, use_slot_type)
		flag = num_9 == total_slots_count

		local has_extension_2 = ScriptUnit.has_extension(arg_19_1, "status_system")

		if not (not (not has_extension_2 and has_extension_2:get_is_on_ladder()) and not (num_8 > (not flag_2 and total_slots_count and total_slots_count - 1))) then
			flag = true
		end

		local get_combo_target_count

		if not has_extension_2 then
			get_combo_target_count = has_extension_2:get_combo_target_count()

			if not get_combo_target_count then
				-- Nothing
			end
		end

		get_combo_target_count = 0

		::label_19_2::

		num_10 = get_combo_target_count * num_7
	end

	local has_extension_3 = ScriptUnit.has_extension(arg_19_1, "aggro_system")
	local aggro_modifier

	if not has_extension_3 then
		aggro_modifier = has_extension_3.aggro_modifier

		if not aggro_modifier then
			-- Nothing
		end
	end

	aggro_modifier = 0

	::label_19_3::

	local var_19_18 = unit_knocked_down(arg_19_1)

	if not (not (distance_squared < num_4) or var_19_18) then
		num_8 = math.max(num_8 - 4, 0)
	end

	local target_stickyness_modifier = arg_19_6.target_stickyness_modifier

	target_stickyness_modifier = target_stickyness_modifier or -5

	if distance_squared > num_5 then
		target_stickyness_modifier = target_stickyness_modifier * 0.5
	end

	local num_11 = num_8 * num
	local num_12 = distance_squared * num_6
	local flag_3 = arg_19_1 ~= arg_19_2 or not target_stickyness_modifier or 0
	local flag_4

	flag_4 = not var_19_18 and 5 and 0

	local flag_5 = not flag_2 and arg_19_8 and 0
	local num_13 = num_9 * num_2
	local var_19_26

	if not flag then
		var_19_26 = num_3

		if not var_19_26 then
			-- Nothing
		end
	end

	var_19_26 = 0

	::label_19_4::

	return num_11 + num_13 + var_19_26 + num_12 + flag_3 + flag_5 + flag_4 + aggro_modifier + num_10, distance_squared
end

PerceptionUtils.pick_closest_target_with_spillover = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	fassert(ScriptUnit.has_extension(arg_20_0, "ai_slot_system"), "Error! Trying to use slot_system perception for non-slot system unit!")

	local var_20_0
	local during_horde_detection_radius = arg_20_2.during_horde_detection_radius
	local flag = false

	if not during_horde_detection_radius and not Managers.state.conflict:has_horde() then
		var_20_0 = 45
		flag = true
	else
		var_20_0 = arg_20_2.detection_radius
	end

	local var_20_3 = POSITION_LOOKUP
	local num = var_20_0 * var_20_0
	local var_20_5 = var_20_3[arg_20_0]
	local target_unit = arg_20_1.target_unit
	local var_20_7
	local huge = math.huge
	local var_20_9
	local side = arg_20_1.side
	local AI_TARGET_UNITS = side.AI_TARGET_UNITS
	local perception_previous_attacker_stickyness_value = arg_20_2.perception_previous_attacker_stickyness_value
	local previous_attacker = arg_20_1.previous_attacker
	local world_position = Unit.world_position(arg_20_0, Unit.node(arg_20_0, "j_head"))
	local flag_2 = false
	local override_targets = arg_20_1.override_targets
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local enemy_units_lookup = side.enemy_units_lookup

	for k, v in pairs(override_targets) do
		local has_extension = ScriptUnit.has_extension(k, "status_system")
		local var_20_20 = has_extension
		local var_20_21

		if not var_20_20 then
			var_20_21 = VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[k]
		else
			var_20_21 = not enemy_units_lookup[k] and HEALTH_ALIVE[k]
		end

		if not var_20_21 and v < arg_20_3 or not has_extension or not has_extension:is_disabled() then
			override_targets[k] = nil
		else
			local var_20_22
			local var_20_23

			if not var_20_20 then
				var_20_22, var_20_23 = fn_4(arg_20_0, k, target_unit, previous_attacker, var_20_5, world_position, arg_20_2, num, perception_previous_attacker_stickyness_value, flag)
			else
				local var_20_24 = BLACKBOARDS[k]

				var_20_22, var_20_23 = fn_2(var_20_24, var_20_5, arg_20_0, k)
			end

			if not (not var_20_22 and not (var_20_22 < huge)) then
				huge = var_20_22
				var_20_7 = k
				var_20_9 = var_20_23
				flag_2 = true
			end
		end
	end

	arg_20_1.using_override_target = flag_2

	if not flag_2 then
		local var_20_25

		var_20_7, var_20_25 = fn_3(arg_20_1, var_20_5, side, arg_20_0, true, arg_20_3, arg_20_2.infighting.ignored_breed_filter)

		local count = #AI_TARGET_UNITS
		local has_extension_2 = ScriptUnit.has_extension(arg_20_0, "ai_group_system")
		local var_20_28

		if not has_extension_2 and not has_extension_2.use_patrol_perception then
			var_20_28 = has_extension_2.group.target_units
		end

		for k_2 = 1, count do
			local var_20_29 = AI_TARGET_UNITS[k_2]

			if not AiUtils.is_unwanted_target(side, var_20_29) then
				local var_20_30, var_20_31 = fn_4(arg_20_0, var_20_29, target_unit, previous_attacker, var_20_5, world_position, arg_20_2, num, perception_previous_attacker_stickyness_value, flag, var_20_28)

				if not (not var_20_30 and not (var_20_30 < var_20_25)) then
					var_20_25 = var_20_30
					var_20_7 = var_20_29
					var_20_9 = var_20_31
				end
			end
		end
	end

	return var_20_7, var_20_9
end

local num_9 = 0

PerceptionUtils.patrol_passive_target_selection = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local num = arg_21_2.patrol_detection_radius * arg_21_2.patrol_detection_radius
	local var_21_1 = POSITION_LOOKUP[arg_21_0]
	local previous_attacker = arg_21_1.previous_attacker
	local target_unit = arg_21_1.target_unit

	target_unit = target_unit or previous_attacker

	local var_21_4
	local huge = math.huge
	local num_2 = 0
	local side = arg_21_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local count = #ENEMY_PLAYER_AND_BOT_UNITS
	local group = ScriptUnit.extension(arg_21_0, "ai_group_system").group
	local target_units = group.target_units
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local VALID_ENEMY_PLAYERS_AND_BOTS = side.VALID_ENEMY_PLAYERS_AND_BOTS

	if not target_unit and not HEALTH_ALIVE[target_unit] and not VALID_ENEMY_PLAYERS_AND_BOTS[target_unit] and not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[target_unit] then
		target_units[target_unit] = true

		local var_21_14 = POSITION_LOOKUP[target_unit]

		for i = 1, count do
			repeat
				local var_21_15 = ENEMY_PLAYER_AND_BOT_UNITS[i]

				if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_21_15] then
					break
				end

				if not (not ScriptUnit.has_extension(var_21_15, "ai_slot_system") and ScriptUnit.extension(var_21_15, "ai_slot_system").valid_target) then
					break
				end

				if false then
					break
				end

				local var_21_16 = POSITION_LOOKUP[var_21_15]

				if num > Vector3.distance_squared(var_21_14, var_21_16) then
					target_units[var_21_15] = true
				end
			until true
		end
	end

	for j = 1, count do
		repeat
			local var_21_17 = ENEMY_PLAYER_AND_BOT_UNITS[j]

			if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_21_17] then
				break
			end

			if not (not ScriptUnit.has_extension(var_21_17, "ai_slot_system") and ScriptUnit.extension(var_21_17, "ai_slot_system").valid_target) then
				break
			end

			if false then
				break
			end

			local var_21_18 = POSITION_LOOKUP[var_21_17]
			local bot_player = Managers.player:owner(var_21_17).bot_player
			local distance_squared = Vector3.distance_squared(var_21_1, var_21_18)
			local num_3 = 0.5

			if distance_squared < num then
				local anchor_direction = arg_21_1.anchor_direction
				local unbox

				if not anchor_direction then
					unbox = anchor_direction:unbox()

					if not unbox then
						-- Nothing
					end
				end

				unbox = Quaternion.forward(Unit.world_rotation(arg_21_0, 0))

				::label_21_0::

				local normalize = Vector3.normalize(unbox)
				local normalize_2 = Vector3.normalize(var_21_18 - var_21_1)

				if not (not (num_3 < Vector3.dot(normalize_2, normalize)) or not bot_player or not (distance_squared < arg_21_2.panic_close_detection_radius_sq)) then
					local get_data = World.get_data(Unit.world(var_21_17), "physics_world")

					if not PerceptionUtils.raycast_spine_to_spine(arg_21_0, var_21_17, get_data) then
						target_units[var_21_17] = true

						local var_21_27 = var_21_17
						local var_21_28 = distance_squared
					end
				end
			end
		until true
	end

	if not (not group.in_combat and next(target_units)) then
		if not group.patrol_detection_radius then
			local num_4 = 1.5
		end

		local var_21_30, var_21_31 = fn_3(arg_21_1, var_21_1, side, arg_21_0, false, arg_21_3, arg_21_2.infighting.ignored_breed_filter)

		if not var_21_30 then
			target_units[var_21_30] = true
		end
	end

	return nil
end

PerceptionUtils.storm_patrol_death_squad_target_selection = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	fassert(ScriptUnit.has_extension(arg_22_0, "ai_slot_system"), "Error! Trying to use slot_system perception for non-slot system unit!")

	local detection_radius = arg_22_2.detection_radius
	local var_22_1 = POSITION_LOOKUP[arg_22_0]
	local world_position = Unit.world_position(arg_22_0, Unit.node(arg_22_0, "j_head"))
	local target_unit = arg_22_1.target_unit
	local previous_attacker = arg_22_1.previous_attacker
	local var_22_5
	local huge = math.huge
	local var_22_7
	local side = arg_22_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local group = ScriptUnit.extension(arg_22_0, "ai_group_system").group
	local target_units = group.target_units
	local system = Managers.state.entity:system("ai_slot_system")

	if not previous_attacker and target_units[previous_attacker] or not HEALTH_ALIVE[previous_attacker] then
		target_units[previous_attacker] = true
	end

	local count = #ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, count do
		local var_22_15 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not target_units[var_22_15] then
			local has_extension = ScriptUnit.has_extension(var_22_15, "ai_slot_system")

			if not has_extension and not has_extension.valid_target then
				local var_22_17 = POSITION_LOOKUP[var_22_15]

				if not (Vector3.distance_squared(var_22_1, var_22_17) < detection_radius * detection_radius) or not AiUtils.line_of_sight_from_random_point(world_position, var_22_15) then
					target_units[var_22_15] = true
				end
			end
		end
	end

	for k, v in pairs(target_units) do
		repeat
			local has_extension_2 = ScriptUnit.has_extension(k, "status_system")
			local var_22_19 = has_extension_2
			local num_2 = 0
			local num_3 = 0
			local num_4 = 0

			if not var_22_19 then
				if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[k] then
					target_units[k] = nil

					break
				end

				if has_extension_2.using_transport or not has_extension_2.spawn_grace then
					target_units[k] = nil

					break
				end

				if not ScriptUnit.has_extension(k, "ai_slot_system") then
					if not ScriptUnit.extension(k, "ai_slot_system").valid_target then
						break
					end

					num_4 = system:slots_count(k) * num
				end

				num_2 = ScriptUnit.extension(k, "aggro_system").aggro_modifier
				num_3 = not has_extension_2:is_knocked_down() and 5 and 0
			elseif not HEALTH_ALIVE[k] then
				target_units[k] = nil

				break
			end

			local var_22_23 = POSITION_LOOKUP[k]
			local num_5 = Vector3.distance_squared(var_22_1, var_22_23) * 0.1
			local flag

			flag = k ~= target_unit or not -5 or 0

			local num_6 = num_4 + num_5 + flag + num_3 + num_2

			if num_6 < huge then
				huge = num_6
				var_22_5 = k
			end
		until true
	end

	if not (not group.in_combat and next(target_units)) then
		local var_22_27

		var_22_5, var_22_27 = fn_3(arg_22_1, var_22_1, side, arg_22_0, false, arg_22_3, arg_22_2.infighting.ignored_breed_filter)

		if not var_22_5 then
			target_units[var_22_5] = true
		end
	end

	return var_22_5
end

PerceptionUtils.pick_encampment_target_idle = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local previous_attacker = arg_23_1.previous_attacker

	if previous_attacker or not arg_23_1.confirmed_player_sighting then
		local extension = ScriptUnit.extension(arg_23_0, "ai_group_system")

		AIGroupTemplates.encampment.wake_up_encampment(extension.group)

		if not previous_attacker then
			local distance = Vector3.distance(POSITION_LOOKUP[arg_23_0], POSITION_LOOKUP[previous_attacker])
			local num = 100

			return previous_attacker, distance, num
		end
	end
end

PerceptionUtils.pick_closest_target_with_spillover_wakeup_group = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local previous_attacker = arg_24_1.previous_attacker

	if previous_attacker or not arg_24_1._was_attacked then
		arg_24_1._was_attacked = true

		local extension = ScriptUnit.extension(arg_24_0, "ai_group_system")
		local template = extension.template

		AIGroupTemplates[template].wake_up_group(extension.group, previous_attacker)

		return PerceptionUtils.pick_closest_target_with_spillover(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	end
end

PerceptionUtils.pick_no_targets = function ()
	-- function 25
	return
end

PerceptionUtils.pick_player_controller_allied = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	local player_controller = arg_26_1.player_controller

	if not player_controller and not ALIVE[player_controller] then
		local var_26_1 = POSITION_LOOKUP[arg_26_0]
		local var_26_2 = POSITION_LOOKUP[player_controller]
		local distance = Vector3.distance(var_26_1, var_26_2)

		return player_controller, distance
	end
end

PerceptionUtils.pick_rat_ogre_target_idle = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local waiting = arg_27_1.waiting
	local side = arg_27_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_PLAYERS_AND_BOTS = side.VALID_ENEMY_PLAYERS_AND_BOTS

	if arg_27_3 > waiting.next_update_time then
		local count = #ENEMY_PLAYER_AND_BOT_UNITS

		if count <= 0 then
			return
		end

		waiting.next_player_unit_index = waiting.next_player_unit_index + 1

		if count < waiting.next_player_unit_index then
			waiting.next_player_unit_index = 1
		end

		local var_27_5 = ENEMY_PLAYER_AND_BOT_UNITS[waiting.next_player_unit_index]
		local var_27_6 = POSITION_LOOKUP[var_27_5]
		local var_27_7 = POSITION_LOOKUP[arg_27_0]
		local distance_squared = Vector3.distance_squared(var_27_7, var_27_6)

		if not (not VALID_ENEMY_PLAYERS_AND_BOTS[var_27_5] and not (distance_squared < arg_27_2.distance_sq_can_detect_target)) then
			local flag = true

			if not waiting.view_cone_dot then
				local forward = Quaternion.forward(Unit.local_rotation(arg_27_0, 0))
				local normalize = Vector3.normalize(var_27_6 - var_27_7)

				flag = Vector3.dot(normalize, forward) > waiting.view_cone_dot or distance_squared < arg_27_2.distance_sq_idle_auto_detect_target
			end

			if not flag then
				local get_data = World.get_data(Unit.world(var_27_5), "physics_world")

				if not PerceptionUtils.raycast_spine_to_spine(arg_27_0, var_27_5, get_data) then
					extension(arg_27_0, "ai_system"):set_perception(arg_27_2.perception, arg_27_2.target_selection_angry)
					Managers.state.conflict:add_angry_boss(1)

					arg_27_1.is_angry = true

					local num = 100
					local sqrt = math.sqrt(distance_squared)

					return var_27_5, sqrt, num
				end
			end
		end

		if not waiting.awake_on_players_passing then
			local conflict = Managers.state.conflict
			local ahead_unit = conflict.main_path_info.ahead_unit

			if not (not ahead_unit and not ALIVE[ahead_unit] and not VALID_ENEMY_PLAYERS_AND_BOTS[ahead_unit] and not (conflict.main_path_player_info[ahead_unit].travel_dist >= waiting.travel_dist)) then
				local distance = Vector3.distance(POSITION_LOOKUP[arg_27_0], POSITION_LOOKUP[ahead_unit])
				local num_2 = 100

				AiUtils.activate_unit(arg_27_1)

				return ahead_unit, distance, num_2
			end
		end

		local previous_attacker = arg_27_1.previous_attacker

		if not previous_attacker and VALID_ENEMY_PLAYERS_AND_BOTS[previous_attacker] and not arg_27_1.is_angry then
			extension(arg_27_0, "ai_system"):set_perception(arg_27_2.perception, arg_27_2.target_selection_angry)
			Managers.state.conflict:add_angry_boss(1)

			arg_27_1.is_angry = true

			local distance_2 = Vector3.distance(POSITION_LOOKUP[arg_27_0], POSITION_LOOKUP[previous_attacker])
			local num_3 = 100

			return previous_attacker, distance_2, num_3
		end

		waiting.next_update_time = arg_27_3 + 0.5
	end
end

local function fn_5(self)
	-- function 28
	for k, v in pairs(self) do
		self[k] = 0
	end
end

local tbl_4 = {}

PerceptionUtils.pick_rat_ogre_target_with_weights = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local distance = Vector3.distance
	local var_29_1
	local huge = math.huge
	local side = arg_29_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local valid_target_func = arg_29_1.valid_target_func

	valid_target_func = valid_target_func or GenericStatusExtension.is_ogre_target

	local count = #ENEMY_PLAYER_AND_BOT_UNITS
	local num = -1000
	local group_blackboard = arg_29_1.group_blackboard
	local flag = arg_29_1.spawn_type == "horde" or arg_29_1.spawn_type == "horde_hidden"
	local var_29_11 = POSITION_LOOKUP[arg_29_0]

	for i = 1, count do
		local var_29_12 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local num_2 = 0
		local huge_2 = math.huge
		local extension = ScriptUnit.extension(var_29_12, "status_system")

		if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_29_12] and not valid_target_func(extension) then
			local perception_weights = arg_29_2.perception_weights

			if arg_29_1.target_unit == var_29_12 then
				local num_3 = arg_29_3 - arg_29_1.target_unit_found_time

				if num_3 < perception_weights.target_stickyness_duration_a then
					num_2 = num_2 + perception_weights.target_stickyness_bonus_a
				elseif num_3 < perception_weights.target_stickyness_duration_b then
					num_2 = num_2 + (1 - num_3 / perception_weights.target_stickyness_duration_b) * perception_weights.target_stickyness_bonus_b
				end
			elseif not group_blackboard.special_targets[var_29_12] then
				arg_29_1.secondary_target = var_29_12
				num_2 = num_2 + perception_weights.targeted_by_other_special
			end

			local var_29_18 = POSITION_LOOKUP[var_29_12]
			local var_29_19 = distance(var_29_11, var_29_18)
			local flag_2 = var_29_19 < arg_29_2.detection_radius

			if not flag_2 then
				local clamp = math.clamp(1 - var_29_19 / perception_weights.max_distance, 0, 1)

				num_2 = num_2 + clamp * clamp * perception_weights.distance_weight
			end

			if flag or not arg_29_2.ignore_targets_outside_detection_radius and arg_29_1.target_unit or not flag_2 then
				if not (not perception_weights.target_staggered_you_bonus and not arg_29_1.pushing_unit and arg_29_1.pushing_unit ~= var_29_12) then
					num_2 = num_2 + perception_weights.target_staggered_you_bonus
					arg_29_1.target_unit_found_time = arg_29_3

					fn_5(arg_29_1.aggro_list)
				end

				local var_29_22 = arg_29_1.aggro_list[var_29_12]

				var_29_22 = var_29_22 or 0

				local is_disabled = extension:is_disabled()

				if not is_disabled then
					var_29_22 = var_29_22 * perception_weights.target_disabled_aggro_mul
					arg_29_1.aggro_list[var_29_12] = var_29_22
				end

				local num_4 = num_2 + var_29_22

				if not is_disabled then
					num_4 = num_4 * perception_weights.target_disabled_mul
				end

				if arg_29_3 - extension.last_catapulted_time < 5 then
					num_4 = num_4 * perception_weights.target_catapulted_mul
				end

				if not arg_29_1.target_outside_navmesh then
					num_4 = num_4 * perception_weights.target_outside_navmesh_mul
				end

				if num < num_4 then
					var_29_1 = var_29_12
					huge = var_29_19
					num = num_4
				end
			end
		end
	end

	if num < arg_29_2.infighting.trigger_minion_target_search then
		local var_29_25 = fn_3(arg_29_1, var_29_11, side, arg_29_0, true, arg_29_3, arg_29_2.infighting.ignored_breed_filter)

		if not var_29_25 then
			var_29_1, huge = var_29_25, distance(var_29_11, POSITION_LOOKUP[var_29_25])
		end
	end

	return var_29_1, huge
end

PerceptionUtils.pick_bestigor_target_with_weights = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	local distance = Vector3.distance
	local var_30_1
	local huge = math.huge
	local valid_target_func = arg_30_1.valid_target_func

	valid_target_func = valid_target_func or GenericStatusExtension.is_ogre_target

	local side = arg_30_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local count = #ENEMY_PLAYER_AND_BOT_UNITS
	local num = -1000
	local group_blackboard = arg_30_1.group_blackboard
	local extension = ScriptUnit.extension(arg_30_0, "ai_line_of_sight_system")
	local var_30_11
	local confirmed_player_sighting = arg_30_1.confirmed_player_sighting
	local var_30_13 = POSITION_LOOKUP[arg_30_0]

	if not (confirmed_player_sighting or not arg_30_1.next_los_check or not arg_30_1.next_los_check or not (arg_30_3 > arg_30_1.next_los_check)) then
		var_30_11 = FrameTable.alloc_table()

		for i = 1, count do
			local var_30_14 = ENEMY_PLAYER_AND_BOT_UNITS[i]

			var_30_11[var_30_14], arg_30_1.next_los_check = extension:has_line_of_sight(arg_30_0, arg_30_1, var_30_14, arg_30_2.detection_radius * arg_30_2.detection_radius), arg_30_3 + 0.5
		end
	end

	for j = 1, count do
		repeat
			local var_30_15 = ENEMY_PLAYER_AND_BOT_UNITS[j]

			if not (confirmed_player_sighting or not arg_30_1.previous_attacker or arg_30_1.previous_attacker == var_30_15) then
				if not (not var_30_11 and var_30_11[var_30_15]) then
					break
				elseif not var_30_11 then
					break
				end
			end

			local num_2 = 0
			local huge_2 = math.huge
			local extension_2 = ScriptUnit.extension(var_30_15, "status_system")

			if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_30_15] and not valid_target_func(extension_2) then
				local perception_weights = arg_30_2.perception_weights

				if arg_30_1.target_unit == var_30_15 then
					local num_3 = arg_30_3 - arg_30_1.target_unit_found_time

					if num_3 < perception_weights.target_stickyness_duration_a then
						num_2 = num_2 + perception_weights.target_stickyness_bonus_a
					elseif num_3 < perception_weights.target_stickyness_duration_b then
						num_2 = num_2 + (1 - num_3 / perception_weights.target_stickyness_duration_b) * perception_weights.target_stickyness_bonus_b
					end
				end

				local var_30_21 = POSITION_LOOKUP[var_30_15]
				local var_30_22 = distance(var_30_13, var_30_21)
				local flag = var_30_22 < arg_30_2.detection_radius

				if not flag then
					local clamp = math.clamp(1 - var_30_22 / perception_weights.max_distance, 0, 1)

					num_2 = num_2 + clamp * clamp * perception_weights.distance_weight
				end

				if not arg_30_2.ignore_targets_outside_detection_radius and arg_30_1.target_unit or not flag then
					local var_30_25 = arg_30_1.aggro_list[var_30_15]

					var_30_25 = var_30_25 or 0

					local is_disabled = extension_2:is_disabled()

					if not is_disabled then
						var_30_25 = var_30_25 * perception_weights.target_disabled_aggro_mul
						arg_30_1.aggro_list[var_30_15] = var_30_25
					end

					local num_4 = num_2 + var_30_25

					if not is_disabled then
						num_4 = num_4 * perception_weights.target_disabled_mul
					end

					if arg_30_3 - extension_2.last_catapulted_time < 5 then
						num_4 = num_4 * perception_weights.target_catapulted_mul
					end

					local num_charges_targeting_player = extension_2.num_charges_targeting_player

					if not (not perception_weights.target_targeted_by_other_charge and not num_charges_targeting_player and not (num_charges_targeting_player > 0) or var_30_15 == arg_30_1.attacking_target) then
						num_4 = num_4 * perception_weights.target_targeted_by_other_charge
					end

					if not (not extension_2:is_charged() and arg_30_1.target_unit == var_30_15) then
						num_4 = num_4 * perception_weights.target_is_charged
					end

					if not arg_30_1.target_outside_navmesh then
						num_4 = num_4 * perception_weights.target_outside_navmesh_mul
					end

					if num < num_4 then
						var_30_1 = var_30_15
						huge = var_30_22
						num = num_4
					end
				end
			end
		until true
	end

	local infighting = arg_30_2.infighting

	if num < infighting.trigger_minion_target_search then
		local var_30_30 = fn_3(arg_30_1, var_30_13, side, arg_30_0, true, arg_30_3, infighting.ignored_breed_filter)

		if not var_30_30 then
			var_30_1, huge = var_30_30, distance(var_30_13, POSITION_LOOKUP[var_30_30])
		end
	end

	return var_30_1, huge
end

PerceptionUtils.pick_chaos_troll_target_with_weights = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	if not arg_31_1.keep_target then
		return
	end

	local distance = Vector3.distance
	local var_31_1
	local huge = math.huge
	local valid_target_func = arg_31_1.valid_target_func

	valid_target_func = valid_target_func or GenericStatusExtension.is_ogre_target

	local side = arg_31_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local count = #ENEMY_PLAYER_AND_BOT_UNITS
	local num = -1000
	local group_blackboard = arg_31_1.group_blackboard
	local var_31_10 = POSITION_LOOKUP[arg_31_0]

	for i = 1, count do
		local var_31_11 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local num_2 = 0
		local extension = ScriptUnit.extension(var_31_11, "buff_system")
		local huge_2 = math.huge
		local extension_2 = ScriptUnit.extension(var_31_11, "status_system")

		if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_31_11] and not valid_target_func(extension_2) then
			local perception_weights = arg_31_2.perception_weights

			if arg_31_1.target_unit == var_31_11 then
				local num_3 = arg_31_3 - arg_31_1.target_unit_found_time

				if num_3 < perception_weights.target_stickyness_duration_a then
					num_2 = num_2 + perception_weights.target_stickyness_bonus_a
				elseif num_3 < perception_weights.target_stickyness_duration_b then
					num_2 = num_2 + (1 - num_3 / perception_weights.target_stickyness_duration_b) * perception_weights.target_stickyness_bonus_b
				end
			elseif not group_blackboard.special_targets[var_31_11] then
				arg_31_1.secondary_target = var_31_11
				num_2 = num_2 + perception_weights.targeted_by_other_special
			end

			local var_31_18 = POSITION_LOOKUP[var_31_11]
			local var_31_19 = distance(var_31_10, var_31_18)
			local flag = var_31_19 < arg_31_2.detection_radius

			if not flag then
				local clamp = math.clamp(1 - var_31_19 / perception_weights.max_distance, 0, 1)

				num_2 = num_2 + clamp * clamp * perception_weights.distance_weight
			end

			if not arg_31_2.ignore_targets_outside_detection_radius and arg_31_1.target_unit or not flag then
				if not (not perception_weights.target_staggered_you_bonus and not arg_31_1.pushing_unit and arg_31_1.pushing_unit ~= var_31_11) then
					num_2 = num_2 + perception_weights.target_staggered_you_bonus
					arg_31_1.target_unit_found_time = arg_31_3

					fn_5(arg_31_1.aggro_list)
				end

				local var_31_22 = arg_31_1.aggro_list[var_31_11]

				var_31_22 = var_31_22 or 0

				local is_ledge_hanging = extension_2.is_ledge_hanging

				is_ledge_hanging = is_ledge_hanging or extension_2.knocked_down

				if not is_ledge_hanging then
					var_31_22 = var_31_22 * perception_weights.target_disabled_aggro_mul
					arg_31_1.aggro_list[var_31_11] = var_31_22
				end

				local num_4 = num_2 + var_31_22

				if not extension:has_buff_type("troll_bile_face") then
					num_4 = num_4 * perception_weights.target_is_in_vomit_multiplier
				end

				if not is_ledge_hanging then
					num_4 = num_4 * perception_weights.target_disabled_mul
				end

				if arg_31_3 - extension_2.last_catapulted_time < 5 then
					num_4 = num_4 * perception_weights.target_catapulted_mul
				end

				if not arg_31_1.target_outside_navmesh then
					num_4 = num_4 * perception_weights.target_outside_navmesh_mul
				end

				if num < num_4 then
					var_31_1 = var_31_11
					huge = var_31_19
					num = num_4
				end
			end
		end
	end

	if num < arg_31_2.infighting.trigger_minion_target_search then
		local var_31_25 = fn_3(arg_31_1, var_31_10, side, arg_31_0, true, arg_31_3, arg_31_2.infighting.ignored_breed_filter)

		if not var_31_25 then
			var_31_1, huge = var_31_25, distance(var_31_10, POSITION_LOOKUP[var_31_25])
		end
	end

	return var_31_1, huge
end

PerceptionUtils.debug_ai_perception = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	-- function 32
	local num = 16
	local str = "arial"
	local str_2 = "materials/fonts/" .. str
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num_2 = 20
	local num_3 = arg_32_6 + 20
	local num_4 = 100
	local num_5 = 330
	local num_6 = 900

	arg_32_5 = arg_32_5 + num_2 + 20 + num_4
	arg_32_6 = arg_32_6 + num_3 + 20

	local var_32_10 = arg_32_6
	local get_color_with_alpha = Colors.get_color_with_alpha("lavender", 255)
	local var_32_12 = Color(255, 245, 100, 0)
	local _target_selection_func_name = arg_32_1._target_selection_func_name
	local _perception_func_name = arg_32_1._perception_func_name
	local str_3 = "client"
	local target_unit = arg_32_2.target_unit

	if not ALIVE[target_unit] then
		local owner = Managers.player:owner(target_unit)

		if not owner then
			local profile_index = owner:profile_index()
			local var_32_19 = SPProfiles[profile_index]

			str_3 = not var_32_19 and var_32_19.unit_name and "client"
		else
			str_3 = "AI"
		end
	end

	ScriptGUI.ictext(arg_32_4, res_w, res_h, "Perception: " .. arg_32_2.breed.name, str_2, num, str, arg_32_5 - 10, var_32_10, num_6, var_32_12)

	local num_7 = var_32_10 + 20

	ScriptGUI.ictext(arg_32_4, res_w, res_h, "target_unit: " .. str_3, str_2, num, str, arg_32_5 - 10, num_7, num_6, get_color_with_alpha)

	local num_8 = num_7 + 20

	ScriptGUI.ictext(arg_32_4, res_w, res_h, "perception func: " .. _perception_func_name, str_2, num, str, arg_32_5 - 10, num_8, num_6, get_color_with_alpha)

	local num_9 = num_8 + 20

	ScriptGUI.ictext(arg_32_4, res_w, res_h, "selection func: " .. _target_selection_func_name, str_2, num, str, arg_32_5 - 10, num_9, num_6, get_color_with_alpha)

	local num_10 = num_9 + 20

	ScriptGUI.icrect(arg_32_4, res_w, res_h, num_2, num_3, arg_32_5 + num_5, num_10, num_6 - 1, Color(200, 20, 20, 20))

	return num_10
end

PerceptionUtils.debug_rat_ogre_perception = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	-- function 33
	local num = 16
	local str = "arial"
	local str_2 = "materials/fonts/" .. str
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num_2 = 20
	local num_3 = arg_33_3 + 10
	local num_4 = 530
	local num_5 = 900

	arg_33_2 = arg_33_2 + num_2 + 20
	arg_33_3 = num_3 + 20

	local var_33_9 = arg_33_3
	local get_color_with_alpha = Colors.get_color_with_alpha("lavender", 255)
	local get_color_with_alpha_2 = Colors.get_color_with_alpha("orange", 255)

	ScriptGUI.ictext(arg_33_0, res_w, res_h, "Continious perception:", str_2, num, str, arg_33_2 - 10, var_33_9, num_5, get_color_with_alpha_2)

	local num_6 = var_33_9 + 20

	for k, v in pairs(tbl_4) do
		if not ALIVE[k] then
			local profile_index = Managers.player:owner(k):profile_index()
			local var_33_14 = SPProfiles[profile_index]
			local unit_name

			if not var_33_14 then
				unit_name = var_33_14.unit_name

				if not unit_name then
					-- Nothing
				end
			end

			unit_name = "client"

			::label_33_0::

			local var_33_16

			if not v["NOT VALID"] then
				var_33_16 = string.format("%s: NOT VALID TARGET", unit_name)
			else
				local str_3 = ""

				for k_2, v_2 in pairs(v) do
					if k_2 ~= "SUM" then
						str_3 = str_3 .. string.format("%s=%.1f, ", k_2, v_2)
					end
				end

				local format = string.format
				local str_4 = "%s:[%.1f] %s"
				local var_33_20 = unit_name
				local SUM = v.SUM

				SUM = SUM or 0
				var_33_16 = format(str_4, var_33_20, SUM, str_3)
			end

			ScriptGUI.ictext(arg_33_0, res_w, res_h, var_33_16, str_2, num, str, arg_33_2 - 10, num_6, num_5, get_color_with_alpha)

			num_6 = num_6 + 20
		else
			tbl_4[k] = nil
		end
	end

	ScriptGUI.icrect(arg_33_0, res_w, res_h, num_2, num_3, arg_33_2 + num_4, num_6, num_5 - 1, Color(200, 20, 20, 20))
end

PerceptionUtils.pick_pack_master_target = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	local is_of_interest_to_packmaster = AiUtils.is_of_interest_to_packmaster
	local var_34_1 = POSITION_LOOKUP[arg_34_0]
	local side = arg_34_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_34_5
	local huge = math.huge
	local huge_2 = math.huge

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not is_of_interest_to_packmaster(arg_34_0, v) then
			local var_34_8 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
			local distance_squared = Vector3.distance_squared(var_34_1, var_34_8)
			local var_34_10 = distance_squared

			if v == arg_34_1.target_unit then
				var_34_10 = distance_squared * 0.8
			end

			if var_34_10 < huge_2 then
				huge = distance_squared
				var_34_5 = v
				huge_2 = var_34_10
			end
		end
	end

	local sqrt = math.sqrt(huge)

	return var_34_5, sqrt
end

PerceptionUtils.pick_mutator_sorcerer_target = function (arg_35_0, arg_35_1, arg_35_2)
	-- function 35
	local is_of_interest_to_corruptor = AiUtils.is_of_interest_to_corruptor
	local var_35_1 = POSITION_LOOKUP[arg_35_0]
	local var_35_2
	local huge = math.huge
	local huge_2 = math.huge
	local time = Managers.time:time("game")
	local side = arg_35_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS

	if not (not is_of_interest_to_corruptor(arg_35_0, arg_35_1.target_unit) and not arg_35_1.target_stickyness_duration and not (time < arg_35_1.target_stickyness_duration)) then
		local distance = Vector3.distance(POSITION_LOOKUP[arg_35_1.target_unit], var_35_1)

		return arg_35_1.target_unit, distance
	end

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not is_of_interest_to_corruptor(arg_35_0, v) then
			local var_35_10 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
			local distance_squared = Vector3.distance_squared(var_35_1, var_35_10)
			local var_35_12 = distance_squared

			if not (not arg_35_1.corruptor_target and arg_35_1.corruptor_target ~= v) then
				local sqrt = math.sqrt(distance_squared)

				return arg_35_1.corruptor_target, sqrt
			end

			if var_35_12 < huge_2 then
				huge = distance_squared
				huge_2 = var_35_12
				var_35_2 = v
			end
		end
	end

	arg_35_1.closest_enemy_dist_sq = huge

	if var_35_2 ~= arg_35_1.target_unit then
		arg_35_1.target_stickyness_duration = time + 2
	end

	local sqrt_2 = math.sqrt(huge)

	return var_35_2, sqrt_2
end

PerceptionUtils.pick_corruptor_target = function (arg_36_0, arg_36_1, arg_36_2)
	-- function 36
	local side = arg_36_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local is_of_interest_to_corruptor = AiUtils.is_of_interest_to_corruptor
	local var_36_5 = POSITION_LOOKUP[arg_36_0]
	local var_36_6
	local huge = math.huge
	local huge_2 = math.huge

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[v] and not is_of_interest_to_corruptor(arg_36_0, v) then
			local var_36_9 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
			local distance_squared = Vector3.distance_squared(var_36_5, var_36_9)
			local var_36_11 = distance_squared

			if v == arg_36_1.target_unit then
				var_36_11 = distance_squared * 0.8
			end

			if not (not arg_36_1.corruptor_target and arg_36_1.corruptor_target ~= v) then
				local sqrt = math.sqrt(distance_squared)

				return arg_36_1.corruptor_target, sqrt
			end

			if var_36_11 < huge_2 then
				huge = distance_squared
				var_36_6 = v
				huge_2 = var_36_11
			end
		end
	end

	local sqrt_2 = math.sqrt(huge)

	return var_36_6, sqrt_2
end

PerceptionUtils.pick_tether_target = function (arg_37_0, arg_37_1, arg_37_2)
	-- function 37
	local side = Managers.state.side
	local var_37_1 = POSITION_LOOKUP[arg_37_0]
	local var_37_2
	local num = 0
	local alive_bosses = Managers.state.conflict:alive_bosses()

	for i = 1, #alive_bosses do
		local var_37_5 = alive_bosses[i]

		if not side:is_ally(arg_37_0, var_37_5) then
			local has_extension = ScriptUnit.has_extension(var_37_5, "health_system")
			local get_max_health

			if not has_extension then
				get_max_health = has_extension:get_max_health()

				if not get_max_health then
					-- Nothing
				end
			end

			get_max_health = 0

			::label_37_0::

			if num < get_max_health then
				var_37_2 = var_37_5
				num = get_max_health
			end
		end
	end

	if not var_37_2 then
		return var_37_2, Vector3.distance(var_37_1, POSITION_LOOKUP[var_37_2])
	end

	local var_37_8
	local huge = math.huge
	local players = Managers.player:players()

	for k, v in pairs(players) do
		local var_37_11 = POSITION_LOOKUP[v.player_unit]

		if not var_37_11 then
			local distance_squared = Vector3.distance_squared(var_37_11, var_37_1)

			if distance_squared < huge then
				var_37_8 = v.player_unit
				huge = distance_squared
			end
		end
	end

	return var_37_8, math.sqrt(huge)
end

function double_raycast(self, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	-- function 38
	if not self.line_of_sight_casts then
		self.line_of_sight_casts = {}
	end

	local var_38_0 = self.line_of_sight_casts[arg_38_3]

	if not var_38_0 then
		var_38_0 = table.clone(arg_38_2)
		self.line_of_sight_casts[arg_38_3] = var_38_0
	end

	local count = #var_38_0
	local num = var_38_0.current_index % count + 1

	var_38_0.current_index = num

	local var_38_3 = var_38_0[num]
	local node = Unit.node(arg_38_3, var_38_3)
	local world_position = Unit.world_position(arg_38_3, node)
	local num_2 = world_position - arg_38_1
	local normalize = Vector3.normalize(num_2)
	local length = Vector3.length(num_2)
	local str = "filter_ai_line_of_sight_check"
	local immediate_raycast, var_38_11 = PhysicsWorld.immediate_raycast(arg_38_4, arg_38_1, normalize, length, "closest", "collision_filter", str)

	if not immediate_raycast then
		var_38_0[var_38_3] = false
	else
		local immediate_raycast_2, var_38_13 = PhysicsWorld.immediate_raycast(arg_38_4, world_position, -normalize, length, "closest", "collision_filter", str)
		local var_38_14 = var_38_13

		if not immediate_raycast_2 then
			var_38_0[var_38_3] = false
		else
			var_38_0[var_38_3] = true
		end
	end

	for i = 1, count do
		local var_38_15 = var_38_0[(num - i) % count + 1]

		if not var_38_0[var_38_15] then
			return true, var_38_15
		end
	end

	return false
end

local function fn_6(arg_39_0)
	-- function 39
	local extension = ScriptUnit.extension(arg_39_0, "status_system")

	return not not extension:is_knocked_down() or not not extension:get_is_ledge_hanging() or not not extension:is_ready_for_assisted_respawn() or not extension:is_hanging_from_hook()
end

PerceptionUtils.pick_ratling_gun_target = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	-- function 40
	local world = arg_40_1.world
	local get_data = World.get_data(world, "physics_world")
	local target_unit = arg_40_1.target_unit
	local var_40_3 = Matrix4x4(0.73776, -0.374671, 0.561545, 0.655785, 0.59515, -0.464481, -0.160177, 0.710927, 0.684781, 0.203595, -0.422035, 0.525395)
	local var_40_4 = POSITION_LOOKUP[arg_40_0]
	local breed = arg_40_1.breed
	local var_40_6
	local huge = math.huge
	local var_40_8
	local var_40_9
	local flag = false
	local huge_2 = math.huge
	local side = arg_40_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[v] and not fn_6(v) then
			local num = POSITION_LOOKUP[v] - var_40_4
			local length_squared = Vector3.length_squared(num)
			local flag_2 = arg_40_2 == v
			local flag_3 = arg_40_1.taunt_unit == v

			if not flag_3 then
				length_squared = 0
			end

			local flag_4 = length_squared < huge

			if not flag_4 and flag_3 and not arg_40_3 and arg_40_3 < Vector3.dot(arg_40_4, Vector3.normalize(num)) and not flag_2 then
				local look = Quaternion.look(Vector3.flat(num), Vector3.up())
				local from_quaternion_position = Matrix4x4.from_quaternion_position(look, var_40_4)
				local translation = Matrix4x4.translation(Matrix4x4.multiply(var_40_3, from_quaternion_position))
				local var_40_23, var_40_24 = double_raycast(arg_40_1, translation, breed.line_of_sight_cast_template, v, get_data)

				if not flag_2 then
					flag = var_40_23
					var_40_9 = var_40_24
					huge_2 = length_squared
				end

				if not var_40_23 and not flag_4 then
					huge = length_squared
					var_40_6 = v
					var_40_8 = var_40_24
				end
			end
		end
	end

	return var_40_6, var_40_8, flag, var_40_9, huge, huge_2
end

PerceptionUtils.pick_warpfire_thrower_target = function (arg_41_0, arg_41_1, arg_41_2)
	-- function 41
	local world = arg_41_1.world
	local get_data = World.get_data(world, "physics_world")
	local target_unit = arg_41_1.target_unit
	local var_41_3 = Matrix4x4(0.73776, -0.374671, 0.561545, 0.655785, 0.59515, -0.464481, -0.160177, 0.710927, 0.684781, 0.203595, -0.422035, 0.525395)
	local var_41_4 = POSITION_LOOKUP[arg_41_0]
	local breed = arg_41_1.breed
	local var_41_6
	local huge = math.huge
	local var_41_8
	local var_41_9
	local flag = false
	local side = arg_41_1.side
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[v] and not fn_6(v) then
			local num = POSITION_LOOKUP[v] - var_41_4
			local length_squared = Vector3.length_squared(num)
			local flag_2 = arg_41_2 == v

			if not ((not (length_squared < breed.detection_radius) or length_squared < huge or not flag_2) and not (length_squared < breed.switch_target_radius * breed.switch_target_radius)) then
				local look = Quaternion.look(Vector3.flat(num), Vector3.up())
				local from_quaternion_position = Matrix4x4.from_quaternion_position(look, var_41_4)
				local translation = Matrix4x4.translation(Matrix4x4.multiply(var_41_3, from_quaternion_position))
				local var_41_20, var_41_21 = double_raycast(arg_41_1, translation, breed.line_of_sight_cast_template, v, get_data)

				if not flag_2 then
					flag = var_41_20
					var_41_9 = var_41_21
				end

				if not (not var_41_20 and not (length_squared < huge)) then
					huge = length_squared
					var_41_6 = v
					var_41_8 = var_41_21
				end
			end
		end
	end

	return var_41_6, var_41_8, flag, var_41_9
end

PerceptionUtils.raycast_spine_to_spine = function (arg_42_0, arg_42_1, arg_42_2)
	-- function 42
	if not ScriptUnit.has_extension(arg_42_1, "locomotion_system") then
		return true
	end

	local node

	if not Unit.has_node(arg_42_0, "camera_attach") then
		node = Unit.node(arg_42_0, "camera_attach")

		if not node then
			-- Nothing
		end
	end

	node = Unit.node(arg_42_0, "c_spine")

	do
		local node_2
	end

	::label_42_0::

	if not Unit.has_node(arg_42_1, "camera_attach") then
		node_2 = Unit.node(arg_42_1, "camera_attach")

		if not node_2 then
			-- Nothing
		end
	end

	node_2 = Unit.node(arg_42_1, "c_spine")

	::label_42_1::

	local world_position = Unit.world_position(arg_42_0, node)
	local num = Unit.world_position(arg_42_1, node_2) - world_position
	local normalize = Vector3.normalize(num)
	local num_2 = Vector3.length(num) + 2
	local immediate_raycast, var_42_7, var_42_8, var_42_9, var_42_10 = PhysicsWorld.immediate_raycast(arg_42_2, world_position, normalize, num_2, "closest", "collision_filter", "filter_ai_line_of_sight_check")

	if not var_42_10 then
		return Actor.unit(var_42_10) == arg_42_1
	else
		return true
	end
end

local num_10 = 1
local num_11 = 2
local num_12 = 3
local num_13 = 4

PerceptionUtils.is_position_in_line_of_sight = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	-- function 43
	arg_43_4 = arg_43_4 or "filter_ai_line_of_sight_check"

	local num = arg_43_2 - arg_43_1
	local normalize = Vector3.normalize(num)
	local length = Vector3.length(num)

	if Vector3.length(normalize) <= 0 then
		return false
	end

	local immediate_raycast, var_43_4, var_43_5, var_43_6, var_43_7 = PhysicsWorld.immediate_raycast(arg_43_3, arg_43_1, normalize, length, "closest", "collision_filter", arg_43_4)

	return not immediate_raycast, var_43_4
end

PerceptionUtils.is_boss_in_los = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local str = "filter_player_and_enemy_hit_box_check"
	local num = arg_44_2 - arg_44_1
	local normalize = Vector3.normalize(num)
	local length = Vector3.length(num)

	if Vector3.length(normalize) <= 0 then
		return false
	end

	local immediate_raycast = PhysicsWorld.immediate_raycast(arg_44_3, arg_44_1, normalize, length, "all", "collision_filter", str)
	local flag = false
	local var_44_6

	if not immediate_raycast then
		for i = 1, #immediate_raycast do
			local var_44_7 = immediate_raycast[i][num_13]
			local unit = Actor.unit(var_44_7)
			local get_data = Unit.get_data(unit, "breed")

			if not get_data and not get_data.boss then
				flag = true
				var_44_6 = immediate_raycast[i][num_10]

				break
			end
		end
	end

	return flag, var_44_6
end

PerceptionUtils.has_line_of_sight_to_any_player = function (arg_45_0, arg_45_1)
	-- function 45
	local var_45_0 = POSITION_LOOKUP[arg_45_0]
	local var_45_1 = BLACKBOARDS[arg_45_0]
	local get_data = World.get_data(var_45_1.world, "physics_world")
	local var_45_3 = Vector3(0, 0, arg_45_1 or 1)
	local ENEMY_PLAYER_AND_BOT_POSITIONS = var_45_1.side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for i = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
		local var_45_5 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]

		if not PerceptionUtils.is_position_in_line_of_sight(nil, var_45_0 + var_45_3, var_45_5 + var_45_3, get_data) then
			return true
		end
	end

	return false
end

PerceptionUtils.position_has_line_of_sight_to_any_player = function (arg_46_0)
	-- function 46
	local world = Managers.world
	local str = "level_world"
	local world_2 = world:world(str)
	local get_data = World.get_data(world_2, "physics_world")
	local var_46_4 = Vector3(0, 0, 1)
	local ENEMY_PLAYER_AND_BOT_POSITIONS = Managers.state.side:get_side_from_name("heroes").ENEMY_PLAYER_AND_BOT_POSITIONS

	for i = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
		local var_46_6 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]

		if not PerceptionUtils.is_position_in_line_of_sight(nil, arg_46_0, var_46_6 + var_46_4, get_data) then
			return true
		end
	end

	return false
end

PerceptionUtils.pick_area_target = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	-- function 47
	local var_47_0
	local num = 0
	local tbl = {}
	local ENEMY_PLAYER_AND_BOT_POSITIONS = arg_47_1.side.ENEMY_PLAYER_AND_BOT_POSITIONS

	if #ENEMY_PLAYER_AND_BOT_POSITIONS > 1 then
		tbl = PerceptionUtils._find_circles(arg_47_0, ENEMY_PLAYER_AND_BOT_POSITIONS, arg_47_3, arg_47_4)
	end

	if #tbl > 0 then
		local _pick_best_circle = PerceptionUtils._pick_best_circle(tbl, ENEMY_PLAYER_AND_BOT_POSITIONS, arg_47_3)

		var_47_0 = _pick_best_circle.pos
		num = _pick_best_circle.targets
	else
		var_47_0 = POSITION_LOOKUP[arg_47_1.target_unit]
		num = 1
	end

	if not Development.parameter("ai_debug_aoe_targeting") then
		PerceptionUtils.debug_draw_pick_area_target(tbl, var_47_0, arg_47_3, ENEMY_PLAYER_AND_BOT_POSITIONS)
	end

	return var_47_0, num
end

PerceptionUtils._find_circles = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	local var_48_0 = POSITION_LOOKUP[arg_48_0]
	local tbl = {}
	local tbl_2 = {}
	local count = #arg_48_1

	for i = 1, count do
		local var_48_4 = arg_48_1[i]

		if arg_48_3 >= Vector3.distance(var_48_0, var_48_4) then
			tbl_2[#tbl_2 + 1] = var_48_4
		end
	end

	for j = 1, #tbl_2 - 1 do
		for k = 2, #tbl_2 do
			if j < k then
				local var_48_5 = tbl_2[j]
				local var_48_6 = tbl_2[k]
				local distance = Vector3.distance(var_48_5, var_48_6)

				if distance < arg_48_2 * 2 then
					local num = var_48_5 + (var_48_6 - var_48_5) * 0.5
					local num_2 = distance / 2
					local var_48_10 = arg_48_2
					local sqrt = math.sqrt(arg_48_2^2 - num_2^2)
					local num_3 = var_48_6.x - var_48_5.x
					local num_4 = var_48_6.y - var_48_5.y
					local num_5 = num + Vector3.normalize(Vector3(-num_4, num_3, 0)) * sqrt
					local num_6 = num + Vector3.normalize(Vector3(num_4, -num_3, 0)) * sqrt

					tbl[#tbl + 1] = {
						targets = 0,
						pos = num_5,
						distance = Vector3.distance(num_5, var_48_0)
					}
					tbl[#tbl + 1] = {
						targets = 0,
						pos = num_6,
						distance = Vector3.distance(num_6, var_48_0)
					}
				end
			end
		end
	end

	return tbl
end

PerceptionUtils._pick_best_circle = function (self, arg_49_1, arg_49_2)
	-- function 49
	for i, v in ipairs(self) do
		for k, v_2 in pairs(arg_49_1) do
			if arg_49_2 >= math.round_with_precision(Vector3.distance(v.pos, v_2), 2) then
				v.targets = v.targets + 1
			end
		end
	end

	local num = 1

	for i4 = 2, #self do
		if self[i4].targets > self[num].targets then
			num = i4
		elseif not (self[i4].targets ~= self[num].targets or not (self[i4].distance < self[num].distance)) then
			num = i4
		end
	end

	return self[num]
end

PerceptionUtils.debug_draw_pick_area_target = function (self, arg_50_1, arg_50_2, arg_50_3)
	-- function 50
	local drawer = Managers.state.debug:drawer({
		mode = "retained",
		name = "pick_area_target"
	})
	local num = Vector3.up() * 0.3

	drawer:reset()

	for i = 1, #self, 2 do
		local var_50_2 = self[i]
		local var_50_3 = self[i + 1]
		local random = math.random(155)
		local random_2 = math.random(255)
		local random_3 = math.random(255)

		drawer:circle(var_50_2.pos + num, arg_50_2, Vector3.up(), Color(255, random, random_2, random_3), 100)
		drawer:circle(var_50_3.pos + num, arg_50_2, Vector3.up(), Color(255, random, random_2, random_3), 100)

		for j = 1, var_50_2.targets do
			drawer:circle(var_50_2.pos + num, 0.5 + j * 0.1, Vector3.up(), Color(255, random, random_2, random_3), 100)
		end

		for k = 1, var_50_3.targets do
			drawer:circle(var_50_3.pos + num, 0.5 + k * 0.1, Vector3.up(), Color(255, random, random_2, random_3), 100)
		end
	end

	for k_2, v in pairs(arg_50_3) do
		drawer:sphere(v + num, 0.1, Color(255, 230, 83, 230))
	end

	if not arg_50_1 then
		drawer:sphere(arg_50_1 + num, 0.2, Color(255, 255, 0, 0))
		drawer:circle(arg_50_1 + num, arg_50_2, Vector3.up(), Color(255, 255, 0, 0), 20)
	end
end

PerceptionUtils.debug_draw_throw_trajectory = function (self)
	-- function 51
	local drawer = Managers.state.debug:drawer({
		mode = "retained",
		name = "projectile_unit_debug"
	})

	for i = 1, #self do
		drawer:sphere(self[i], 0.05, Color(255, 255, 255, 255))
	end
end
