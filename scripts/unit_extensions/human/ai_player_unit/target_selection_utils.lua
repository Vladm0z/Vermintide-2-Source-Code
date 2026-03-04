-- chunkname: @scripts/unit_extensions/human/ai_player_unit/target_selection_utils.lua

local var_0_0 = HEALTH_ALIVE
local var_0_1 = AiUtils.unit_knocked_down
local var_0_2 = Vector3.distance
local var_0_3 = POSITION_LOOKUP
local var_0_4 = AI_TARGET_UNITS
local var_0_5 = AI_UTILS
local var_0_6 = ScriptUnit.extension
local var_0_7 = {}

function get_ai_vs_ai_target(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_2.minion_detection_radius or arg_1_2.detection_radius or 7

	if AiUtils.broadphase_query(arg_1_0, var_1_0, var_0_7, arg_1_1.enemy_broadphase_categories) > 0 then
		local var_1_1 = var_0_7[1]
		local var_1_2 = var_0_2(arg_1_0, var_0_3[var_1_1])

		return var_1_1, var_1_2
	end
end

function PerceptionUtils.pick_closest_target(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = var_0_3[arg_2_0]
	local var_2_1
	local var_2_2 = math.huge
	local var_2_3 = arg_2_1.side
	local var_2_4 = var_2_3.ENEMY_PLAYER_AND_BOT_UNITS
	local var_2_5 = var_2_3.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_2_6 = var_2_3.ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_2_0, iter_2_1 in ipairs(var_2_4) do
		if var_2_5[iter_2_1] then
			local var_2_7 = var_2_6[iter_2_0]
			local var_2_8 = Vector3.distance(var_2_0, var_2_7)

			if var_2_8 < arg_2_2.detection_radius and var_2_8 < var_2_2 then
				var_2_2 = var_2_8
				var_2_1 = iter_2_1
			end
		end
	end

	return var_2_1, var_2_2
end

function PerceptionUtils.pick_closest_target_with_filter(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = var_0_3[arg_3_0]
	local var_3_1
	local var_3_2 = math.huge
	local var_3_3 = AiUtils[arg_3_2.is_of_interest_func]
	local var_3_4 = arg_3_1.side
	local var_3_5 = var_3_4.ENEMY_PLAYER_AND_BOT_UNITS
	local var_3_6 = var_3_4.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_3_7 = var_3_4.ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_3_0 = 1, #var_3_5 do
		local var_3_8 = var_3_5[iter_3_0]

		if var_3_6[var_3_8] and var_3_3(var_3_8, arg_3_0) then
			local var_3_9 = var_3_7[iter_3_0]
			local var_3_10 = Vector3.distance(var_3_0, var_3_9)

			if var_3_10 < arg_3_2.detection_radius and var_3_10 < var_3_2 then
				var_3_2 = var_3_10
				var_3_1 = var_3_8
			end
		end
	end

	return var_3_1, var_3_2
end

local var_0_8 = {}

function PerceptionUtils.pick_closest_vortex_target(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = var_0_3[arg_4_0]
	local var_4_1
	local var_4_2 = math.huge
	local var_4_3 = arg_4_1.vortex_data
	local var_4_4 = var_4_3 and var_4_3.players_ejected or var_0_8
	local var_4_5 = arg_4_1.side
	local var_4_6 = var_4_5.ENEMY_PLAYER_AND_BOT_UNITS
	local var_4_7 = var_4_5.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_4_8 = var_4_5.ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_4_0 = 1, #var_4_6 do
		local var_4_9 = var_4_6[iter_4_0]

		if var_4_7[var_4_9] and not var_4_4[var_4_9] and AiUtils.is_of_interest_to_vortex(var_4_9) then
			local var_4_10 = var_4_8[iter_4_0]
			local var_4_11 = Vector3.distance(var_4_0, var_4_10)

			if var_4_11 < arg_4_2.detection_radius and var_4_11 < var_4_2 then
				var_4_2 = var_4_11
				var_4_1 = var_4_9
			end
		end
	end

	return var_4_1, var_4_2
end

function PerceptionUtils.pick_boss_sorcerer_target(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = var_0_3[arg_5_0]
	local var_5_1
	local var_5_2 = math.huge
	local var_5_3 = arg_5_1.side
	local var_5_4 = var_5_3.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_5_5 = arg_5_1.recent_attacker_unit

	if var_5_4[var_5_5] then
		local var_5_6 = var_0_3[var_5_5]
		local var_5_7 = Vector3.distance(var_5_0, var_5_6)

		return var_5_5, var_5_7
	end

	local var_5_8 = var_5_3.ENEMY_PLAYER_AND_BOT_UNITS
	local var_5_9 = var_5_3.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_5_10 = AiUtils[arg_5_2.is_of_interest_func]

	for iter_5_0, iter_5_1 in ipairs(var_5_8) do
		if var_5_4[iter_5_1] and var_5_10(iter_5_1) then
			local var_5_11 = var_5_9[iter_5_0]
			local var_5_12 = Vector3.distance(var_5_0, var_5_11)

			if var_5_12 < arg_5_2.detection_radius and var_5_12 < var_5_2 then
				var_5_2 = var_5_12
				var_5_1 = iter_5_1
			end
		end
	end

	return var_5_1, var_5_2
end

function PerceptionUtils.pick_closest_target_infinte_range(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = var_0_3[arg_6_0]
	local var_6_1
	local var_6_2 = math.huge
	local var_6_3 = arg_6_1.side
	local var_6_4 = var_6_3.ENEMY_PLAYER_AND_BOT_UNITS
	local var_6_5 = var_6_3.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_6_6 = var_6_3.ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_6_0, iter_6_1 in ipairs(var_6_4) do
		if var_6_5[iter_6_1] then
			local var_6_7 = var_6_6[iter_6_0]
			local var_6_8 = Vector3.distance(var_6_0, var_6_7)

			if var_6_8 < var_6_2 then
				var_6_2 = var_6_8
				var_6_1 = iter_6_1
			end
		end
	end

	return var_6_1, var_6_2
end

function PerceptionUtils.healthy_players(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1.group_blackboard.special_targets
	local var_7_1 = Vector3.distance
	local var_7_2 = -1000
	local var_7_3
	local var_7_4 = var_0_3[arg_7_0]
	local var_7_5 = arg_7_2.perception_weights
	local var_7_6 = var_7_5.max_distance
	local var_7_7 = arg_7_1.side
	local var_7_8 = var_7_7.ENEMY_PLAYER_AND_BOT_UNITS
	local var_7_9 = var_7_7.ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_7_0 = 1, #var_7_8 do
		local var_7_10 = var_7_8[iter_7_0]
		local var_7_11 = 0

		if AiUtils.is_of_interest_to_gutter_runner(arg_7_0, var_7_10, arg_7_1) then
			local var_7_12 = var_7_0[var_7_10]

			if var_7_12 then
				if var_7_12 == arg_7_0 then
					var_7_11 = var_7_11 + var_7_5.sticky_bonus
				else
					var_7_11 = var_7_11 + var_7_5.dog_pile_penalty
				end
			end

			local var_7_13 = var_7_1(var_7_9[iter_7_0], var_7_4)

			if var_7_13 < var_7_6 then
				var_7_11 = var_7_11 + math.clamp(1 - var_7_13 / var_7_6, 0, 1) * var_7_5.distance_weight
			end

			if var_7_2 < var_7_11 then
				var_7_3 = var_7_10
				var_7_2 = var_7_11
			end
		end
	end

	return var_7_3
end

function PerceptionUtils.pick_ninja_skulking_target(arg_8_0, arg_8_1, arg_8_2)
	return PerceptionUtils.pick_solitary_target(arg_8_0, arg_8_1, arg_8_2)
end

function PerceptionUtils.pick_ninja_approach_target(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1.target_unit

	if arg_9_1.jump_data and arg_9_1.jump_data.target_unit then
		return arg_9_1.jump_data.target_unit, arg_9_1.target_dist, 100
	end

	local var_9_1 = arg_9_1.side
	local var_9_2 = var_9_1.ENEMY_PLAYER_AND_BOT_UNITS
	local var_9_3 = var_9_1.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_9_4 = var_9_1.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_9_5
	local var_9_6 = math.huge
	local var_9_7 = 0
	local var_9_8 = arg_9_1.group_blackboard.special_targets
	local var_9_9 = var_0_3[arg_9_0]

	for iter_9_0 = 1, #var_9_2 do
		local var_9_10 = var_9_2[iter_9_0]
		local var_9_11 = ScriptUnit.extension(var_9_10, "status_system")

		if var_9_3[var_9_10] and not var_9_11:is_disabled() then
			local var_9_12 = var_9_4[iter_9_0]
			local var_9_13 = Vector3.distance(var_9_9, var_9_12)

			if var_9_13 < var_9_6 then
				if not var_9_0 or var_9_0 == var_9_10 or var_9_13 < arg_9_2.approaching_switch_radius then
					var_9_6 = var_9_13
					var_9_5 = var_9_10
					var_9_7 = 10
				end
			elseif var_9_8[var_9_10] then
				arg_9_1.secondary_target = var_9_10
			end
		else
			arg_9_1.secondary_target = var_9_10
		end
	end

	return var_9_5, var_9_6, var_9_7
end

function PerceptionUtils.pick_solitary_target(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = var_0_3[arg_10_0]
	local var_10_1
	local var_10_2 = math.huge
	local var_10_3 = 0

	if arg_10_1.jump_data and arg_10_1.jump_data.target_unit then
		return arg_10_1.jump_data.target_unit, arg_10_1.target_dist, 100
	end

	local var_10_4 = arg_10_1.target_unit

	if ALIVE[var_10_4] then
		local var_10_5 = ScriptUnit.extension(var_10_4, "status_system")

		if var_10_5:is_pounced_down() and var_10_5:get_pouncer_unit() == arg_10_0 then
			return var_10_4, arg_10_1.target_dist, 100
		end
	end

	local var_10_6 = arg_10_1.side.ENEMY_PLAYER_AND_BOT_UNITS
	local var_10_7
	local var_10_8 = #var_10_6

	if var_10_8 == 1 then
		var_10_7 = var_10_6[1]
		var_10_3 = 5
	elseif var_10_8 <= 2 then
		var_10_7 = PerceptionUtils.healthy_players(arg_10_0, arg_10_1, arg_10_2)

		if var_10_7 then
			var_10_3 = 5
		end
	else
		local var_10_9 = arg_10_1.side
		local var_10_10
		local var_10_11
		local var_10_12, var_10_13, var_10_14

		var_10_12, var_10_13, var_10_14, var_10_7 = Managers.state.conflict:get_cluster_and_loneliness(10, var_10_9.ENEMY_PLAYER_POSITIONS, var_10_9.ENEMY_PLAYER_UNITS)

		if var_10_14 > 4 and AiUtils.is_of_interest_to_gutter_runner(arg_10_0, var_10_7, arg_10_1) then
			if var_10_14 > 15 then
				var_10_3 = 10
			elseif var_10_14 > 10 and arg_10_1.total_slots_count >= 3 then
				var_10_3 = 5
			elseif var_10_14 > 4 and arg_10_1.total_slots_count >= 6 then
				var_10_3 = 5
			else
				var_10_3 = 1
			end
		else
			var_10_7 = PerceptionUtils.healthy_players(arg_10_0, arg_10_1, arg_10_2)

			if var_10_7 then
				var_10_3 = 5
			end
		end
	end

	if var_10_7 then
		var_10_2 = Vector3.distance(var_10_0, var_0_3[var_10_7])
		var_10_1 = var_10_7

		if var_10_2 < 10 then
			var_10_3 = 10
		end
	end

	return var_10_1, var_10_2, var_10_3
end

local var_0_9 = 2.5
local var_0_10 = 2.5
local var_0_11 = 600
local var_0_12 = 5.0625
local var_0_13 = 4
local var_0_14 = 0.25
local var_0_15 = 5

local function var_0_16(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = Unit.get_data(arg_11_0, "target_type")

	if var_11_0 and arg_11_4.perception_exceptions and arg_11_4.perception_exceptions[var_11_0] then
		return
	end

	local var_11_1 = 0
	local var_11_2 = 0
	local var_11_3 = false
	local var_11_4 = arg_11_2 and arg_11_2 == arg_11_0

	if ScriptUnit.has_extension(arg_11_0, "ai_slot_system") then
		if not ScriptUnit.extension(arg_11_0, "ai_slot_system").valid_target then
			return
		end

		local var_11_5 = arg_11_4.use_slot_type
		local var_11_6 = Managers.state.entity:system("ai_slot_system")
		local var_11_7 = var_11_6:total_slots_count(arg_11_0, var_11_5)

		var_11_1 = var_11_6:slots_count(arg_11_0, var_11_5)
		var_11_2 = var_11_6:disabled_slots_count(arg_11_0, var_11_5)
		var_11_3 = var_11_2 == var_11_7

		local var_11_8 = ScriptUnit.has_extension(arg_11_0, "status_system")

		if var_11_8 and var_11_8:get_is_on_ladder() and var_11_1 > (var_11_4 and var_11_7 or var_11_7 - 1) then
			var_11_3 = true
		end
	end

	local var_11_9 = var_0_3[arg_11_0]

	if not var_11_9 then
		return
	end

	local var_11_10 = Vector3.distance_squared(arg_11_3, var_11_9)
	local var_11_11 = ScriptUnit.extension(arg_11_0, "aggro_system").aggro_modifier
	local var_11_12 = var_0_1(arg_11_0)

	if var_11_10 < var_0_12 and not var_11_12 then
		var_11_1 = math.max(var_11_1 - 4, 0)
	end

	local var_11_13 = arg_11_4.target_stickyness_modifier or -5

	if var_11_10 > var_0_13 then
		var_11_13 = var_11_13 * 0.5
	end

	local var_11_14 = var_11_1 * var_0_9
	local var_11_15 = var_11_10 * var_0_14
	local var_11_16 = arg_11_0 == arg_11_1 and var_11_13 or 0
	local var_11_17 = var_11_12 and 5 or 0
	local var_11_18 = var_11_4 and arg_11_5 or 0
	local var_11_19 = var_11_2 * var_0_10
	local var_11_20 = var_11_3 and var_0_11 or 0

	return var_11_14 + var_11_15 + var_11_19 + var_11_20 + var_11_16 + var_11_18 + var_11_17 + var_11_11, var_11_10
end

local var_0_17 = {
	[0] = 0,
	4,
	9,
	16,
	25,
	36
}

local function var_0_18(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0.lean_dogpile
	local var_12_1

	if USE_ENGINE_SLOID_SYSTEM then
		var_12_1 = Managers.state.conflict.dogpiled_attackers_on_unit[arg_12_3]
	else
		var_12_1 = Managers.state.conflict.gathering.dogpiled_attackers_on_unit[arg_12_3]
	end

	if var_12_1 and var_12_1[arg_12_2] then
		var_12_0 = var_12_0 - 1
	end

	local var_12_2 = var_0_17[var_12_0] or 64
	local var_12_3 = var_0_3[arg_12_3]
	local var_12_4 = Vector3.distance_squared(arg_12_1, var_12_3)

	return var_12_2 + var_12_4, var_12_4
end

local var_0_19 = 0.5

function tprint(arg_13_0, arg_13_1, ...)
	if arg_13_0 == script_data.debug_unit then
		printf(arg_13_1, ...)
	end
end

local function var_0_20(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	local var_14_0 = arg_14_0.breed
	local var_14_1 = arg_14_0.override_detection_radius or arg_14_0.detection_radius or var_14_0.minion_detection_radius or var_14_0.detection_radius or 7
	local var_14_2
	local var_14_3
	local var_14_4 = arg_14_0.lean_unit_list
	local var_14_5
	local var_14_6
	local var_14_7
	local var_14_8 = arg_14_0.next_lean_index

	if arg_14_0.next_lean_index <= 0 then
		local var_14_9 = AiUtils.broadphase_query(arg_14_1, var_14_1, var_0_7, arg_14_2.enemy_broadphase_categories)

		if var_14_9 > 0 then
			local var_14_10

			if math.random() < 0.9 then
				var_14_10 = math.min(var_14_9, 5)
			else
				var_14_10 = math.min(var_14_9, 12)
			end

			for iter_14_0 = 1, var_14_10 do
				var_14_4[iter_14_0] = var_0_7[iter_14_0]
			end

			arg_14_0.next_lean_index = 1
			var_14_4.size = var_14_10
			var_14_3 = var_14_4[1]
		end
	else
		var_14_3 = var_14_4[var_14_8]

		local var_14_11 = var_14_8 + 1

		arg_14_0.next_lean_index = var_14_11 >= var_14_4.size and 0 or var_14_11
	end

	local var_14_12 = math.huge
	local var_14_13
	local var_14_14
	local var_14_15 = arg_14_0.target_unit

	if var_0_0[var_14_15] then
		local var_14_16 = BLACKBOARDS[var_14_15]

		if var_14_16 and var_14_16.lean_dogpile then
			var_14_12 = var_0_18(var_14_16, arg_14_1, arg_14_3, var_14_15) * var_0_19
			var_14_14 = var_14_15
		end
	end

	if not var_0_0[var_14_3] or var_14_3 == var_14_14 then
		-- block empty
	else
		local var_14_17 = BLACKBOARDS[var_14_3]

		if arg_14_6[var_14_17.breed.name] then
			-- block empty
		elseif var_14_17.lean_dogpile >= var_14_17.crowded_slots then
			-- block empty
		else
			local var_14_18 = var_0_3[var_14_3]
			local var_14_19 = var_0_18(var_14_17, arg_14_1, arg_14_3, var_14_3)

			if var_14_19 < var_14_12 then
				if arg_14_4 then
					local var_14_20 = Unit.node(arg_14_3, "j_head")
					local var_14_21 = Unit.world_position(arg_14_3, var_14_20)

					if not AiUtils.line_of_sight_from_random_point(var_14_21, var_14_3) then
						goto label_14_0
					end
				end

				var_14_12 = var_14_19
				var_14_14 = var_14_3
			end
		end
	end

	::label_14_0::

	if var_14_14 then
		return var_14_14, var_14_12 * 0.95
	else
		return nil, math.huge
	end
end

function PerceptionUtils.horde_pick_closest_target_with_spillover(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	fassert(ScriptUnit.has_extension(arg_15_0, "ai_slot_system"), "Error! Trying to use slot_system perception for non-slot system unit!")

	local var_15_0 = var_0_3[arg_15_0]
	local var_15_1 = arg_15_1.target_unit
	local var_15_2
	local var_15_3 = math.huge
	local var_15_4 = arg_15_1.side
	local var_15_5 = var_15_4.AI_TARGET_UNITS
	local var_15_6 = arg_15_2.perception_previous_attacker_stickyness_value
	local var_15_7 = arg_15_1.previous_attacker
	local var_15_8
	local var_15_9 = false
	local var_15_10 = arg_15_1.override_targets
	local var_15_11 = var_15_4.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_15_12 = var_15_4.enemy_units_lookup

	for iter_15_0, iter_15_1 in pairs(var_15_10) do
		local var_15_13 = ScriptUnit.has_extension(iter_15_0, "status_system")
		local var_15_14

		if var_15_13 then
			var_15_14 = var_15_11[iter_15_0]
		else
			var_15_14 = var_15_12[iter_15_0] and var_0_0[iter_15_0]
		end

		local var_15_15 = ScriptUnit.has_extension(iter_15_0, "status_system")

		if not var_15_14 or iter_15_1 < arg_15_3 or var_15_15 and var_15_15:is_disabled() then
			var_15_10[iter_15_0] = nil
		else
			local var_15_16
			local var_15_17

			if var_15_13 then
				var_15_16, var_15_17 = var_0_16(iter_15_0, var_15_1, var_15_7, var_15_0, arg_15_2, var_15_6)
			else
				local var_15_18 = BLACKBOARDS[iter_15_0]

				var_15_16, var_15_17 = var_0_18(var_15_18, var_15_0, arg_15_0, iter_15_0)
			end

			if var_15_16 and var_15_16 < var_15_3 then
				var_15_3 = var_15_16
				var_15_2 = iter_15_0
				var_15_8 = var_15_17
				var_15_9 = true
			end
		end
	end

	arg_15_1.using_override_target = var_15_9

	if not var_15_9 then
		local var_15_19

		var_15_2, var_15_19 = var_0_20(arg_15_1, var_15_0, var_15_4, arg_15_0, false, arg_15_3, arg_15_2.infighting.ignored_breed_filter)

		for iter_15_2, iter_15_3 in ipairs(var_15_5) do
			local var_15_20, var_15_21 = var_0_16(iter_15_3, var_15_1, var_15_7, var_15_0, arg_15_2, var_15_6)

			if not AiUtils.is_unwanted_target(var_15_4, iter_15_3) and var_15_20 and var_15_20 < var_15_19 then
				var_15_19 = var_15_20
				var_15_2 = iter_15_3
				var_15_8 = var_15_21
			end
		end
	end

	return var_15_2, var_15_8
end

function PerceptionUtils.pick_closest_target_near_detection_source_position(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_1.side
	local var_16_1
	local var_16_2 = arg_16_1.detection_source_pos

	if var_16_2 then
		var_16_1 = var_16_2:unbox()
	else
		var_16_1 = var_0_3[arg_16_0]
	end

	local var_16_3 = var_0_20(arg_16_1, var_16_1, var_16_0, arg_16_0, true, arg_16_3, arg_16_2.infighting.ignored_breed_filter)
	local var_16_4 = var_0_3[var_16_3]
	local var_16_5 = var_16_4 and Vector3.distance_squared(var_16_1, var_16_4)

	return var_16_3, var_16_5
end

function PerceptionUtils.pick_best_target_near_commander_target(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_1.commander_target

	if not var_0_0[var_17_0] then
		arg_17_1.override_target_selection_name = nil

		return
	end

	local var_17_1 = arg_17_1.side
	local var_17_2 = var_0_3[var_17_0]
	local var_17_3 = var_0_20(arg_17_1, var_17_2, var_17_1, arg_17_0, true, arg_17_3, arg_17_2.infighting.ignored_breed_filter)
	local var_17_4 = var_0_3[var_17_3]
	local var_17_5 = var_17_4 and Vector3.distance_squared(var_17_2, var_17_4)

	return var_17_3, var_17_5
end

function PerceptionUtils.attack_commander_target_with_fallback(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_1.commander_target

	if not var_0_0[var_18_0] then
		arg_18_1.override_target_selection_name = nil

		return
	end

	local var_18_1 = BLACKBOARDS[var_18_0]

	if var_18_1.lean_dogpile and var_18_1.lean_dogpile - (arg_18_1.target_unit == var_18_0 and 1 or 0) >= var_18_1.crowded_slots then
		return PerceptionUtils.pick_best_target_near_commander_target(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	end

	return var_18_0
end

local function var_0_21(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10)
	local var_19_0 = Unit.get_data(arg_19_1, "target_type")

	if var_19_0 and arg_19_6.perception_exceptions and arg_19_6.perception_exceptions[var_19_0] then
		return
	end

	local var_19_1 = var_0_3[arg_19_1]

	if not var_19_1 then
		return
	end

	local var_19_2 = Vector3.distance_squared(arg_19_4, var_19_1)

	if not arg_19_2 or arg_19_10 and not arg_19_10[arg_19_1] then
		if arg_19_1 ~= arg_19_2 and arg_19_7 < var_19_2 then
			return
		end

		if not arg_19_9 and not AiUtils.line_of_sight_from_random_point(arg_19_5, arg_19_1) then
			return
		end
	end

	local var_19_3 = 0
	local var_19_4 = 0
	local var_19_5 = false
	local var_19_6 = arg_19_3 and arg_19_3 == arg_19_1
	local var_19_7 = 0
	local var_19_8 = ScriptUnit.has_extension(arg_19_1, "ai_slot_system")

	if var_19_8 then
		local var_19_9 = BLACKBOARDS[arg_19_1]

		if var_19_9 and var_19_9.is_player and not var_19_8.valid_target then
			return
		end

		local var_19_10 = arg_19_6.use_slot_type
		local var_19_11 = Managers.state.entity:system("ai_slot_system")
		local var_19_12 = var_19_11:total_slots_count(arg_19_1, var_19_10)

		var_19_3 = var_19_11:slots_count(arg_19_1, var_19_10)
		var_19_4 = var_19_11:disabled_slots_count(arg_19_1, var_19_10)
		var_19_5 = var_19_4 == var_19_12

		local var_19_13 = ScriptUnit.has_extension(arg_19_1, "status_system")

		if var_19_13 and var_19_13:get_is_on_ladder() and var_19_3 > (var_19_6 and var_19_12 or var_19_12 - 1) then
			var_19_5 = true
		end

		var_19_7 = (var_19_13 and var_19_13:get_combo_target_count() or 0) * var_0_15
	end

	local var_19_14 = ScriptUnit.has_extension(arg_19_1, "aggro_system")
	local var_19_15 = var_19_14 and var_19_14.aggro_modifier or 0
	local var_19_16 = var_0_1(arg_19_1)

	if var_19_2 < var_0_12 and not var_19_16 then
		var_19_3 = math.max(var_19_3 - 4, 0)
	end

	local var_19_17 = arg_19_6.target_stickyness_modifier or -5

	if var_19_2 > var_0_13 then
		var_19_17 = var_19_17 * 0.5
	end

	local var_19_18 = var_19_3 * var_0_9
	local var_19_19 = var_19_2 * var_0_14
	local var_19_20 = arg_19_1 == arg_19_2 and var_19_17 or 0
	local var_19_21 = var_19_16 and 5 or 0
	local var_19_22 = var_19_6 and arg_19_8 or 0
	local var_19_23 = var_19_4 * var_0_10
	local var_19_24 = var_19_5 and var_0_11 or 0

	return var_19_18 + var_19_23 + var_19_24 + var_19_19 + var_19_20 + var_19_22 + var_19_21 + var_19_15 + var_19_7, var_19_2
end

function PerceptionUtils.pick_closest_target_with_spillover(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	fassert(ScriptUnit.has_extension(arg_20_0, "ai_slot_system"), "Error! Trying to use slot_system perception for non-slot system unit!")

	local var_20_0
	local var_20_1 = arg_20_2.during_horde_detection_radius
	local var_20_2 = false

	if var_20_1 and Managers.state.conflict:has_horde() then
		var_20_0 = 45
		var_20_2 = true
	else
		var_20_0 = arg_20_2.detection_radius
	end

	local var_20_3 = var_0_3
	local var_20_4 = var_20_0 * var_20_0
	local var_20_5 = var_20_3[arg_20_0]
	local var_20_6 = arg_20_1.target_unit
	local var_20_7
	local var_20_8 = math.huge
	local var_20_9
	local var_20_10 = arg_20_1.side
	local var_20_11 = var_20_10.AI_TARGET_UNITS
	local var_20_12 = arg_20_2.perception_previous_attacker_stickyness_value
	local var_20_13 = arg_20_1.previous_attacker
	local var_20_14 = Unit.world_position(arg_20_0, Unit.node(arg_20_0, "j_head"))
	local var_20_15 = false
	local var_20_16 = arg_20_1.override_targets
	local var_20_17 = var_20_10.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_20_18 = var_20_10.enemy_units_lookup

	for iter_20_0, iter_20_1 in pairs(var_20_16) do
		local var_20_19 = ScriptUnit.has_extension(iter_20_0, "status_system")
		local var_20_20 = var_20_19
		local var_20_21

		if var_20_20 then
			var_20_21 = var_20_17[iter_20_0]
		else
			var_20_21 = var_20_18[iter_20_0] and var_0_0[iter_20_0]
		end

		if not var_20_21 or iter_20_1 < arg_20_3 or var_20_19 and var_20_19:is_disabled() then
			var_20_16[iter_20_0] = nil
		else
			local var_20_22
			local var_20_23

			if var_20_20 then
				var_20_22, var_20_23 = var_0_21(arg_20_0, iter_20_0, var_20_6, var_20_13, var_20_5, var_20_14, arg_20_2, var_20_4, var_20_12, var_20_2)
			else
				local var_20_24 = BLACKBOARDS[iter_20_0]

				var_20_22, var_20_23 = var_0_18(var_20_24, var_20_5, arg_20_0, iter_20_0)
			end

			if var_20_22 and var_20_22 < var_20_8 then
				var_20_8 = var_20_22
				var_20_7 = iter_20_0
				var_20_9 = var_20_23
				var_20_15 = true
			end
		end
	end

	arg_20_1.using_override_target = var_20_15

	if not var_20_15 then
		local var_20_25

		var_20_7, var_20_25 = var_0_20(arg_20_1, var_20_5, var_20_10, arg_20_0, true, arg_20_3, arg_20_2.infighting.ignored_breed_filter)

		local var_20_26 = #var_20_11
		local var_20_27 = ScriptUnit.has_extension(arg_20_0, "ai_group_system")
		local var_20_28

		if var_20_27 and var_20_27.use_patrol_perception then
			var_20_28 = var_20_27.group.target_units
		end

		for iter_20_2 = 1, var_20_26 do
			local var_20_29 = var_20_11[iter_20_2]

			if not AiUtils.is_unwanted_target(var_20_10, var_20_29) then
				local var_20_30, var_20_31 = var_0_21(arg_20_0, var_20_29, var_20_6, var_20_13, var_20_5, var_20_14, arg_20_2, var_20_4, var_20_12, var_20_2, var_20_28)

				if var_20_30 and var_20_30 < var_20_25 then
					var_20_25 = var_20_30
					var_20_7 = var_20_29
					var_20_9 = var_20_31
				end
			end
		end
	end

	return var_20_7, var_20_9
end

local var_0_22 = 0

function PerceptionUtils.patrol_passive_target_selection(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_2.patrol_detection_radius * arg_21_2.patrol_detection_radius
	local var_21_1 = var_0_3[arg_21_0]
	local var_21_2 = arg_21_1.previous_attacker
	local var_21_3 = arg_21_1.target_unit or var_21_2
	local var_21_4
	local var_21_5 = math.huge
	local var_21_6 = 0
	local var_21_7 = arg_21_1.side
	local var_21_8 = var_21_7.ENEMY_PLAYER_AND_BOT_UNITS
	local var_21_9 = #var_21_8
	local var_21_10 = ScriptUnit.extension(arg_21_0, "ai_group_system").group
	local var_21_11 = var_21_10.target_units
	local var_21_12 = var_21_7.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_21_13 = var_21_7.VALID_ENEMY_PLAYERS_AND_BOTS

	if var_21_3 and var_0_0[var_21_3] and (not var_21_13[var_21_3] or var_21_12[var_21_3]) then
		var_21_11[var_21_3] = true

		local var_21_14 = var_0_3[var_21_3]

		for iter_21_0 = 1, var_21_9 do
			repeat
				local var_21_15 = var_21_8[iter_21_0]

				if not var_21_12[var_21_15] then
					break
				end

				if not ScriptUnit.has_extension(var_21_15, "ai_slot_system") or not ScriptUnit.extension(var_21_15, "ai_slot_system").valid_target then
					break
				end

				if false then
					break
				end

				local var_21_16 = var_0_3[var_21_15]

				if var_21_0 > Vector3.distance_squared(var_21_14, var_21_16) then
					var_21_11[var_21_15] = true
				end
			until true
		end
	end

	for iter_21_1 = 1, var_21_9 do
		repeat
			local var_21_17 = var_21_8[iter_21_1]

			if not var_21_12[var_21_17] then
				break
			end

			if not ScriptUnit.has_extension(var_21_17, "ai_slot_system") or not ScriptUnit.extension(var_21_17, "ai_slot_system").valid_target then
				break
			end

			if false then
				break
			end

			local var_21_18 = var_0_3[var_21_17]
			local var_21_19 = Managers.player:owner(var_21_17).bot_player
			local var_21_20 = Vector3.distance_squared(var_21_1, var_21_18)
			local var_21_21 = 0.5

			if var_21_20 < var_21_0 then
				local var_21_22 = arg_21_1.anchor_direction
				local var_21_23 = var_21_22 and var_21_22:unbox() or Quaternion.forward(Unit.world_rotation(arg_21_0, 0))
				local var_21_24 = Vector3.normalize(var_21_23)
				local var_21_25 = Vector3.normalize(var_21_18 - var_21_1)

				if var_21_21 < Vector3.dot(var_21_25, var_21_24) and not var_21_19 or var_21_20 < arg_21_2.panic_close_detection_radius_sq then
					local var_21_26 = World.get_data(Unit.world(var_21_17), "physics_world")

					if PerceptionUtils.raycast_spine_to_spine(arg_21_0, var_21_17, var_21_26) then
						var_21_11[var_21_17] = true

						local var_21_27 = var_21_17
						local var_21_28 = var_21_20
					end
				end
			end
		until true
	end

	if var_21_10.in_combat and not next(var_21_11) then
		if not var_21_10.patrol_detection_radius then
			local var_21_29 = 1.5
		end

		local var_21_30, var_21_31 = var_0_20(arg_21_1, var_21_1, var_21_7, arg_21_0, false, arg_21_3, arg_21_2.infighting.ignored_breed_filter)

		if var_21_30 then
			var_21_11[var_21_30] = true
		end
	end

	return nil
end

function PerceptionUtils.storm_patrol_death_squad_target_selection(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	fassert(ScriptUnit.has_extension(arg_22_0, "ai_slot_system"), "Error! Trying to use slot_system perception for non-slot system unit!")

	local var_22_0 = arg_22_2.detection_radius
	local var_22_1 = var_0_3[arg_22_0]
	local var_22_2 = Unit.world_position(arg_22_0, Unit.node(arg_22_0, "j_head"))
	local var_22_3 = arg_22_1.target_unit
	local var_22_4 = arg_22_1.previous_attacker
	local var_22_5
	local var_22_6 = math.huge
	local var_22_7
	local var_22_8 = arg_22_1.side
	local var_22_9 = var_22_8.ENEMY_PLAYER_AND_BOT_UNITS
	local var_22_10 = var_22_8.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_22_11 = ScriptUnit.extension(arg_22_0, "ai_group_system").group
	local var_22_12 = var_22_11.target_units
	local var_22_13 = Managers.state.entity:system("ai_slot_system")

	if var_22_4 and not var_22_12[var_22_4] and var_0_0[var_22_4] then
		var_22_12[var_22_4] = true
	end

	local var_22_14 = #var_22_9

	for iter_22_0 = 1, var_22_14 do
		local var_22_15 = var_22_9[iter_22_0]

		if not var_22_12[var_22_15] then
			local var_22_16 = ScriptUnit.has_extension(var_22_15, "ai_slot_system")

			if var_22_16 and var_22_16.valid_target then
				local var_22_17 = var_0_3[var_22_15]

				if Vector3.distance_squared(var_22_1, var_22_17) < var_22_0 * var_22_0 and AiUtils.line_of_sight_from_random_point(var_22_2, var_22_15) then
					var_22_12[var_22_15] = true
				end
			end
		end
	end

	for iter_22_1, iter_22_2 in pairs(var_22_12) do
		repeat
			local var_22_18 = ScriptUnit.has_extension(iter_22_1, "status_system")
			local var_22_19 = var_22_18
			local var_22_20 = 0
			local var_22_21 = 0
			local var_22_22 = 0

			if var_22_19 then
				if not var_22_10[iter_22_1] then
					var_22_12[iter_22_1] = nil

					break
				end

				if var_22_18.using_transport or var_22_18.spawn_grace then
					var_22_12[iter_22_1] = nil

					break
				end

				if ScriptUnit.has_extension(iter_22_1, "ai_slot_system") then
					if not ScriptUnit.extension(iter_22_1, "ai_slot_system").valid_target then
						break
					end

					var_22_22 = var_22_13:slots_count(iter_22_1) * var_0_9
				end

				var_22_20 = ScriptUnit.extension(iter_22_1, "aggro_system").aggro_modifier
				var_22_21 = var_22_18:is_knocked_down() and 5 or 0
			elseif not var_0_0[iter_22_1] then
				var_22_12[iter_22_1] = nil

				break
			end

			local var_22_23 = var_0_3[iter_22_1]
			local var_22_24 = Vector3.distance_squared(var_22_1, var_22_23) * 0.1
			local var_22_25 = iter_22_1 == var_22_3 and -5 or 0
			local var_22_26 = var_22_22 + var_22_24 + var_22_25 + var_22_21 + var_22_20

			if var_22_26 < var_22_6 then
				var_22_6 = var_22_26
				var_22_5 = iter_22_1
			end
		until true
	end

	if var_22_11.in_combat and not next(var_22_12) then
		local var_22_27

		var_22_5, var_22_27 = var_0_20(arg_22_1, var_22_1, var_22_8, arg_22_0, false, arg_22_3, arg_22_2.infighting.ignored_breed_filter)

		if var_22_5 then
			var_22_12[var_22_5] = true
		end
	end

	return var_22_5
end

function PerceptionUtils.pick_encampment_target_idle(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_1.previous_attacker

	if var_23_0 or arg_23_1.confirmed_player_sighting then
		local var_23_1 = ScriptUnit.extension(arg_23_0, "ai_group_system")

		AIGroupTemplates.encampment.wake_up_encampment(var_23_1.group)

		if var_23_0 then
			local var_23_2 = Vector3.distance(var_0_3[arg_23_0], var_0_3[var_23_0])
			local var_23_3 = 100

			return var_23_0, var_23_2, var_23_3
		end
	end
end

function PerceptionUtils.pick_closest_target_with_spillover_wakeup_group(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_1.previous_attacker

	if var_24_0 or arg_24_1._was_attacked then
		arg_24_1._was_attacked = true

		local var_24_1 = ScriptUnit.extension(arg_24_0, "ai_group_system")
		local var_24_2 = var_24_1.template

		AIGroupTemplates[var_24_2].wake_up_group(var_24_1.group, var_24_0)

		return PerceptionUtils.pick_closest_target_with_spillover(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	end
end

function PerceptionUtils.pick_no_targets()
	return
end

function PerceptionUtils.pick_player_controller_allied(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = arg_26_1.player_controller

	if var_26_0 and ALIVE[var_26_0] then
		local var_26_1 = var_0_3[arg_26_0]
		local var_26_2 = var_0_3[var_26_0]
		local var_26_3 = Vector3.distance(var_26_1, var_26_2)

		return var_26_0, var_26_3
	end
end

function PerceptionUtils.pick_rat_ogre_target_idle(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_1.waiting
	local var_27_1 = arg_27_1.side
	local var_27_2 = var_27_1.ENEMY_PLAYER_AND_BOT_UNITS
	local var_27_3 = var_27_1.VALID_ENEMY_PLAYERS_AND_BOTS

	if arg_27_3 > var_27_0.next_update_time then
		local var_27_4 = #var_27_2

		if var_27_4 <= 0 then
			return
		end

		var_27_0.next_player_unit_index = var_27_0.next_player_unit_index + 1

		if var_27_4 < var_27_0.next_player_unit_index then
			var_27_0.next_player_unit_index = 1
		end

		local var_27_5 = var_27_2[var_27_0.next_player_unit_index]
		local var_27_6 = var_0_3[var_27_5]
		local var_27_7 = var_0_3[arg_27_0]
		local var_27_8 = Vector3.distance_squared(var_27_7, var_27_6)

		if var_27_3[var_27_5] and var_27_8 < arg_27_2.distance_sq_can_detect_target then
			local var_27_9 = true

			if var_27_0.view_cone_dot then
				local var_27_10 = Quaternion.forward(Unit.local_rotation(arg_27_0, 0))
				local var_27_11 = Vector3.normalize(var_27_6 - var_27_7)

				var_27_9 = Vector3.dot(var_27_11, var_27_10) > var_27_0.view_cone_dot or var_27_8 < arg_27_2.distance_sq_idle_auto_detect_target
			end

			if var_27_9 then
				local var_27_12 = World.get_data(Unit.world(var_27_5), "physics_world")

				if PerceptionUtils.raycast_spine_to_spine(arg_27_0, var_27_5, var_27_12) then
					var_0_6(arg_27_0, "ai_system"):set_perception(arg_27_2.perception, arg_27_2.target_selection_angry)
					Managers.state.conflict:add_angry_boss(1)

					arg_27_1.is_angry = true

					local var_27_13 = 100
					local var_27_14 = math.sqrt(var_27_8)

					return var_27_5, var_27_14, var_27_13
				end
			end
		end

		if var_27_0.awake_on_players_passing then
			local var_27_15 = Managers.state.conflict
			local var_27_16 = var_27_15.main_path_info.ahead_unit

			if var_27_16 and ALIVE[var_27_16] and var_27_3[var_27_16] and var_27_15.main_path_player_info[var_27_16].travel_dist >= var_27_0.travel_dist then
				local var_27_17 = Vector3.distance(var_0_3[arg_27_0], var_0_3[var_27_16])
				local var_27_18 = 100

				AiUtils.activate_unit(arg_27_1)

				return var_27_16, var_27_17, var_27_18
			end
		end

		local var_27_19 = arg_27_1.previous_attacker

		if var_27_19 and var_27_3[var_27_19] or arg_27_1.is_angry then
			var_0_6(arg_27_0, "ai_system"):set_perception(arg_27_2.perception, arg_27_2.target_selection_angry)
			Managers.state.conflict:add_angry_boss(1)

			arg_27_1.is_angry = true

			local var_27_20 = Vector3.distance(var_0_3[arg_27_0], var_0_3[var_27_19])
			local var_27_21 = 100

			return var_27_19, var_27_20, var_27_21
		end

		var_27_0.next_update_time = arg_27_3 + 0.5
	end
end

local function var_0_23(arg_28_0)
	for iter_28_0, iter_28_1 in pairs(arg_28_0) do
		arg_28_0[iter_28_0] = 0
	end
end

local var_0_24 = {}

function PerceptionUtils.pick_rat_ogre_target_with_weights(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = Vector3.distance
	local var_29_1
	local var_29_2 = math.huge
	local var_29_3 = arg_29_1.side
	local var_29_4 = var_29_3.ENEMY_PLAYER_AND_BOT_UNITS
	local var_29_5 = var_29_3.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_29_6 = arg_29_1.valid_target_func or GenericStatusExtension.is_ogre_target
	local var_29_7 = #var_29_4
	local var_29_8 = -1000
	local var_29_9 = arg_29_1.group_blackboard
	local var_29_10 = arg_29_1.spawn_type == "horde" or arg_29_1.spawn_type == "horde_hidden"
	local var_29_11 = var_0_3[arg_29_0]

	for iter_29_0 = 1, var_29_7 do
		local var_29_12 = var_29_4[iter_29_0]
		local var_29_13 = 0
		local var_29_14 = math.huge
		local var_29_15 = ScriptUnit.extension(var_29_12, "status_system")

		if var_29_5[var_29_12] and var_29_6(var_29_15) then
			local var_29_16 = arg_29_2.perception_weights

			if arg_29_1.target_unit == var_29_12 then
				local var_29_17 = arg_29_3 - arg_29_1.target_unit_found_time

				if var_29_17 < var_29_16.target_stickyness_duration_a then
					var_29_13 = var_29_13 + var_29_16.target_stickyness_bonus_a
				elseif var_29_17 < var_29_16.target_stickyness_duration_b then
					var_29_13 = var_29_13 + (1 - var_29_17 / var_29_16.target_stickyness_duration_b) * var_29_16.target_stickyness_bonus_b
				end
			elseif var_29_9.special_targets[var_29_12] then
				arg_29_1.secondary_target = var_29_12
				var_29_13 = var_29_13 + var_29_16.targeted_by_other_special
			end

			local var_29_18 = var_0_3[var_29_12]
			local var_29_19 = var_29_0(var_29_11, var_29_18)
			local var_29_20 = var_29_19 < arg_29_2.detection_radius

			if var_29_20 then
				local var_29_21 = math.clamp(1 - var_29_19 / var_29_16.max_distance, 0, 1)

				var_29_13 = var_29_13 + var_29_21 * var_29_21 * var_29_16.distance_weight
			end

			if var_29_10 or not arg_29_2.ignore_targets_outside_detection_radius or arg_29_1.target_unit or var_29_20 then
				if var_29_16.target_staggered_you_bonus and arg_29_1.pushing_unit and arg_29_1.pushing_unit == var_29_12 then
					var_29_13 = var_29_13 + var_29_16.target_staggered_you_bonus
					arg_29_1.target_unit_found_time = arg_29_3

					var_0_23(arg_29_1.aggro_list)
				end

				local var_29_22 = arg_29_1.aggro_list[var_29_12] or 0
				local var_29_23 = var_29_15:is_disabled()

				if var_29_23 then
					var_29_22 = var_29_22 * var_29_16.target_disabled_aggro_mul
					arg_29_1.aggro_list[var_29_12] = var_29_22
				end

				local var_29_24 = var_29_13 + var_29_22

				if var_29_23 then
					var_29_24 = var_29_24 * var_29_16.target_disabled_mul
				end

				if arg_29_3 - var_29_15.last_catapulted_time < 5 then
					var_29_24 = var_29_24 * var_29_16.target_catapulted_mul
				end

				if arg_29_1.target_outside_navmesh then
					var_29_24 = var_29_24 * var_29_16.target_outside_navmesh_mul
				end

				if var_29_8 < var_29_24 then
					var_29_1 = var_29_12
					var_29_2 = var_29_19
					var_29_8 = var_29_24
				end
			end
		end
	end

	if var_29_8 < arg_29_2.infighting.trigger_minion_target_search then
		local var_29_25 = var_0_20(arg_29_1, var_29_11, var_29_3, arg_29_0, true, arg_29_3, arg_29_2.infighting.ignored_breed_filter)

		if var_29_25 then
			var_29_1, var_29_2 = var_29_25, var_29_0(var_29_11, var_0_3[var_29_25])
		end
	end

	return var_29_1, var_29_2
end

function PerceptionUtils.pick_bestigor_target_with_weights(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = Vector3.distance
	local var_30_1
	local var_30_2 = math.huge
	local var_30_3 = arg_30_1.valid_target_func or GenericStatusExtension.is_ogre_target
	local var_30_4 = arg_30_1.side
	local var_30_5 = var_30_4.ENEMY_PLAYER_AND_BOT_UNITS
	local var_30_6 = var_30_4.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_30_7 = #var_30_5
	local var_30_8 = -1000
	local var_30_9 = arg_30_1.group_blackboard
	local var_30_10 = ScriptUnit.extension(arg_30_0, "ai_line_of_sight_system")
	local var_30_11
	local var_30_12 = arg_30_1.confirmed_player_sighting
	local var_30_13 = var_0_3[arg_30_0]

	if not var_30_12 and (not arg_30_1.next_los_check or arg_30_1.next_los_check and arg_30_3 > arg_30_1.next_los_check) then
		var_30_11 = FrameTable.alloc_table()

		for iter_30_0 = 1, var_30_7 do
			local var_30_14 = var_30_5[iter_30_0]

			var_30_11[var_30_14], arg_30_1.next_los_check = var_30_10:has_line_of_sight(arg_30_0, arg_30_1, var_30_14, arg_30_2.detection_radius * arg_30_2.detection_radius), arg_30_3 + 0.5
		end
	end

	for iter_30_1 = 1, var_30_7 do
		repeat
			local var_30_15 = var_30_5[iter_30_1]

			if not var_30_12 and (not arg_30_1.previous_attacker or arg_30_1.previous_attacker ~= var_30_15) then
				if var_30_11 and not var_30_11[var_30_15] then
					break
				elseif not var_30_11 then
					break
				end
			end

			local var_30_16 = 0
			local var_30_17 = math.huge
			local var_30_18 = ScriptUnit.extension(var_30_15, "status_system")

			if var_30_6[var_30_15] and var_30_3(var_30_18) then
				local var_30_19 = arg_30_2.perception_weights

				if arg_30_1.target_unit == var_30_15 then
					local var_30_20 = arg_30_3 - arg_30_1.target_unit_found_time

					if var_30_20 < var_30_19.target_stickyness_duration_a then
						var_30_16 = var_30_16 + var_30_19.target_stickyness_bonus_a
					elseif var_30_20 < var_30_19.target_stickyness_duration_b then
						var_30_16 = var_30_16 + (1 - var_30_20 / var_30_19.target_stickyness_duration_b) * var_30_19.target_stickyness_bonus_b
					end
				end

				local var_30_21 = var_0_3[var_30_15]
				local var_30_22 = var_30_0(var_30_13, var_30_21)
				local var_30_23 = var_30_22 < arg_30_2.detection_radius

				if var_30_23 then
					local var_30_24 = math.clamp(1 - var_30_22 / var_30_19.max_distance, 0, 1)

					var_30_16 = var_30_16 + var_30_24 * var_30_24 * var_30_19.distance_weight
				end

				if not arg_30_2.ignore_targets_outside_detection_radius or arg_30_1.target_unit or var_30_23 then
					local var_30_25 = arg_30_1.aggro_list[var_30_15] or 0
					local var_30_26 = var_30_18:is_disabled()

					if var_30_26 then
						var_30_25 = var_30_25 * var_30_19.target_disabled_aggro_mul
						arg_30_1.aggro_list[var_30_15] = var_30_25
					end

					local var_30_27 = var_30_16 + var_30_25

					if var_30_26 then
						var_30_27 = var_30_27 * var_30_19.target_disabled_mul
					end

					if arg_30_3 - var_30_18.last_catapulted_time < 5 then
						var_30_27 = var_30_27 * var_30_19.target_catapulted_mul
					end

					local var_30_28 = var_30_18.num_charges_targeting_player

					if var_30_19.target_targeted_by_other_charge and var_30_28 and var_30_28 > 0 and var_30_15 ~= arg_30_1.attacking_target then
						var_30_27 = var_30_27 * var_30_19.target_targeted_by_other_charge
					end

					if var_30_18:is_charged() and arg_30_1.target_unit ~= var_30_15 then
						var_30_27 = var_30_27 * var_30_19.target_is_charged
					end

					if arg_30_1.target_outside_navmesh then
						var_30_27 = var_30_27 * var_30_19.target_outside_navmesh_mul
					end

					if var_30_8 < var_30_27 then
						var_30_1 = var_30_15
						var_30_2 = var_30_22
						var_30_8 = var_30_27
					end
				end
			end
		until true
	end

	local var_30_29 = arg_30_2.infighting

	if var_30_8 < var_30_29.trigger_minion_target_search then
		local var_30_30 = var_0_20(arg_30_1, var_30_13, var_30_4, arg_30_0, true, arg_30_3, var_30_29.ignored_breed_filter)

		if var_30_30 then
			var_30_1, var_30_2 = var_30_30, var_30_0(var_30_13, var_0_3[var_30_30])
		end
	end

	return var_30_1, var_30_2
end

function PerceptionUtils.pick_chaos_troll_target_with_weights(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	if arg_31_1.keep_target then
		return
	end

	local var_31_0 = Vector3.distance
	local var_31_1
	local var_31_2 = math.huge
	local var_31_3 = arg_31_1.valid_target_func or GenericStatusExtension.is_ogre_target
	local var_31_4 = arg_31_1.side
	local var_31_5 = var_31_4.ENEMY_PLAYER_AND_BOT_UNITS
	local var_31_6 = var_31_4.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_31_7 = #var_31_5
	local var_31_8 = -1000
	local var_31_9 = arg_31_1.group_blackboard
	local var_31_10 = var_0_3[arg_31_0]

	for iter_31_0 = 1, var_31_7 do
		local var_31_11 = var_31_5[iter_31_0]
		local var_31_12 = 0
		local var_31_13 = ScriptUnit.extension(var_31_11, "buff_system")
		local var_31_14 = math.huge
		local var_31_15 = ScriptUnit.extension(var_31_11, "status_system")

		if var_31_6[var_31_11] and var_31_3(var_31_15) then
			local var_31_16 = arg_31_2.perception_weights

			if arg_31_1.target_unit == var_31_11 then
				local var_31_17 = arg_31_3 - arg_31_1.target_unit_found_time

				if var_31_17 < var_31_16.target_stickyness_duration_a then
					var_31_12 = var_31_12 + var_31_16.target_stickyness_bonus_a
				elseif var_31_17 < var_31_16.target_stickyness_duration_b then
					var_31_12 = var_31_12 + (1 - var_31_17 / var_31_16.target_stickyness_duration_b) * var_31_16.target_stickyness_bonus_b
				end
			elseif var_31_9.special_targets[var_31_11] then
				arg_31_1.secondary_target = var_31_11
				var_31_12 = var_31_12 + var_31_16.targeted_by_other_special
			end

			local var_31_18 = var_0_3[var_31_11]
			local var_31_19 = var_31_0(var_31_10, var_31_18)
			local var_31_20 = var_31_19 < arg_31_2.detection_radius

			if var_31_20 then
				local var_31_21 = math.clamp(1 - var_31_19 / var_31_16.max_distance, 0, 1)

				var_31_12 = var_31_12 + var_31_21 * var_31_21 * var_31_16.distance_weight
			end

			if not arg_31_2.ignore_targets_outside_detection_radius or arg_31_1.target_unit or var_31_20 then
				if var_31_16.target_staggered_you_bonus and arg_31_1.pushing_unit and arg_31_1.pushing_unit == var_31_11 then
					var_31_12 = var_31_12 + var_31_16.target_staggered_you_bonus
					arg_31_1.target_unit_found_time = arg_31_3

					var_0_23(arg_31_1.aggro_list)
				end

				local var_31_22 = arg_31_1.aggro_list[var_31_11] or 0
				local var_31_23 = var_31_15.is_ledge_hanging or var_31_15.knocked_down

				if var_31_23 then
					var_31_22 = var_31_22 * var_31_16.target_disabled_aggro_mul
					arg_31_1.aggro_list[var_31_11] = var_31_22
				end

				local var_31_24 = var_31_12 + var_31_22

				if var_31_13:has_buff_type("troll_bile_face") then
					var_31_24 = var_31_24 * var_31_16.target_is_in_vomit_multiplier
				end

				if var_31_23 then
					var_31_24 = var_31_24 * var_31_16.target_disabled_mul
				end

				if arg_31_3 - var_31_15.last_catapulted_time < 5 then
					var_31_24 = var_31_24 * var_31_16.target_catapulted_mul
				end

				if arg_31_1.target_outside_navmesh then
					var_31_24 = var_31_24 * var_31_16.target_outside_navmesh_mul
				end

				if var_31_8 < var_31_24 then
					var_31_1 = var_31_11
					var_31_2 = var_31_19
					var_31_8 = var_31_24
				end
			end
		end
	end

	if var_31_8 < arg_31_2.infighting.trigger_minion_target_search then
		local var_31_25 = var_0_20(arg_31_1, var_31_10, var_31_4, arg_31_0, true, arg_31_3, arg_31_2.infighting.ignored_breed_filter)

		if var_31_25 then
			var_31_1, var_31_2 = var_31_25, var_31_0(var_31_10, var_0_3[var_31_25])
		end
	end

	return var_31_1, var_31_2
end

function PerceptionUtils.debug_ai_perception(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	local var_32_0 = 16
	local var_32_1 = "arial"
	local var_32_2 = "materials/fonts/" .. var_32_1
	local var_32_3 = RESOLUTION_LOOKUP.res_w
	local var_32_4 = RESOLUTION_LOOKUP.res_h
	local var_32_5 = 20
	local var_32_6 = arg_32_6 + 20
	local var_32_7 = 100
	local var_32_8 = 330
	local var_32_9 = 900

	arg_32_5 = arg_32_5 + var_32_5 + 20 + var_32_7
	arg_32_6 = arg_32_6 + var_32_6 + 20

	local var_32_10 = arg_32_6
	local var_32_11 = Colors.get_color_with_alpha("lavender", 255)
	local var_32_12 = Color(255, 245, 100, 0)
	local var_32_13 = arg_32_1._target_selection_func_name
	local var_32_14 = arg_32_1._perception_func_name
	local var_32_15 = "client"
	local var_32_16 = arg_32_2.target_unit

	if ALIVE[var_32_16] then
		local var_32_17 = Managers.player:owner(var_32_16)

		if var_32_17 then
			local var_32_18 = var_32_17:profile_index()
			local var_32_19 = SPProfiles[var_32_18]

			var_32_15 = var_32_19 and var_32_19.unit_name or "client"
		else
			var_32_15 = "AI"
		end
	end

	ScriptGUI.ictext(arg_32_4, var_32_3, var_32_4, "Perception: " .. arg_32_2.breed.name, var_32_2, var_32_0, var_32_1, arg_32_5 - 10, var_32_10, var_32_9, var_32_12)

	local var_32_20 = var_32_10 + 20

	ScriptGUI.ictext(arg_32_4, var_32_3, var_32_4, "target_unit: " .. var_32_15, var_32_2, var_32_0, var_32_1, arg_32_5 - 10, var_32_20, var_32_9, var_32_11)

	local var_32_21 = var_32_20 + 20

	ScriptGUI.ictext(arg_32_4, var_32_3, var_32_4, "perception func: " .. var_32_14, var_32_2, var_32_0, var_32_1, arg_32_5 - 10, var_32_21, var_32_9, var_32_11)

	local var_32_22 = var_32_21 + 20

	ScriptGUI.ictext(arg_32_4, var_32_3, var_32_4, "selection func: " .. var_32_13, var_32_2, var_32_0, var_32_1, arg_32_5 - 10, var_32_22, var_32_9, var_32_11)

	local var_32_23 = var_32_22 + 20

	ScriptGUI.icrect(arg_32_4, var_32_3, var_32_4, var_32_5, var_32_6, arg_32_5 + var_32_8, var_32_23, var_32_9 - 1, Color(200, 20, 20, 20))

	return var_32_23
end

function PerceptionUtils.debug_rat_ogre_perception(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	local var_33_0 = 16
	local var_33_1 = "arial"
	local var_33_2 = "materials/fonts/" .. var_33_1
	local var_33_3 = RESOLUTION_LOOKUP.res_w
	local var_33_4 = RESOLUTION_LOOKUP.res_h
	local var_33_5 = 20
	local var_33_6 = arg_33_3 + 10
	local var_33_7 = 530
	local var_33_8 = 900

	arg_33_2 = arg_33_2 + var_33_5 + 20
	arg_33_3 = var_33_6 + 20

	local var_33_9 = arg_33_3
	local var_33_10 = Colors.get_color_with_alpha("lavender", 255)
	local var_33_11 = Colors.get_color_with_alpha("orange", 255)

	ScriptGUI.ictext(arg_33_0, var_33_3, var_33_4, "Continious perception:", var_33_2, var_33_0, var_33_1, arg_33_2 - 10, var_33_9, var_33_8, var_33_11)

	local var_33_12 = var_33_9 + 20

	for iter_33_0, iter_33_1 in pairs(var_0_24) do
		if ALIVE[iter_33_0] then
			local var_33_13 = Managers.player:owner(iter_33_0):profile_index()
			local var_33_14 = SPProfiles[var_33_13]
			local var_33_15 = var_33_14 and var_33_14.unit_name or "client"
			local var_33_16

			if iter_33_1["NOT VALID"] then
				var_33_16 = string.format("%s: NOT VALID TARGET", var_33_15)
			else
				local var_33_17 = ""

				for iter_33_2, iter_33_3 in pairs(iter_33_1) do
					if iter_33_2 ~= "SUM" then
						var_33_17 = var_33_17 .. string.format("%s=%.1f, ", iter_33_2, iter_33_3)
					end
				end

				var_33_16 = string.format("%s:[%.1f] %s", var_33_15, iter_33_1.SUM or 0, var_33_17)
			end

			ScriptGUI.ictext(arg_33_0, var_33_3, var_33_4, var_33_16, var_33_2, var_33_0, var_33_1, arg_33_2 - 10, var_33_12, var_33_8, var_33_10)

			var_33_12 = var_33_12 + 20
		else
			var_0_24[iter_33_0] = nil
		end
	end

	ScriptGUI.icrect(arg_33_0, var_33_3, var_33_4, var_33_5, var_33_6, arg_33_2 + var_33_7, var_33_12, var_33_8 - 1, Color(200, 20, 20, 20))
end

function PerceptionUtils.pick_pack_master_target(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = AiUtils.is_of_interest_to_packmaster
	local var_34_1 = var_0_3[arg_34_0]
	local var_34_2 = arg_34_1.side
	local var_34_3 = var_34_2.ENEMY_PLAYER_AND_BOT_UNITS
	local var_34_4 = var_34_2.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_34_5
	local var_34_6 = math.huge
	local var_34_7 = math.huge

	for iter_34_0, iter_34_1 in ipairs(var_34_3) do
		if var_34_0(arg_34_0, iter_34_1) then
			local var_34_8 = var_34_4[iter_34_0]
			local var_34_9 = Vector3.distance_squared(var_34_1, var_34_8)
			local var_34_10 = var_34_9

			if iter_34_1 == arg_34_1.target_unit then
				var_34_10 = var_34_9 * 0.8
			end

			if var_34_10 < var_34_7 then
				var_34_6 = var_34_9
				var_34_5 = iter_34_1
				var_34_7 = var_34_10
			end
		end
	end

	local var_34_11 = math.sqrt(var_34_6)

	return var_34_5, var_34_11
end

function PerceptionUtils.pick_mutator_sorcerer_target(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = AiUtils.is_of_interest_to_corruptor
	local var_35_1 = var_0_3[arg_35_0]
	local var_35_2
	local var_35_3 = math.huge
	local var_35_4 = math.huge
	local var_35_5 = Managers.time:time("game")
	local var_35_6 = arg_35_1.side
	local var_35_7 = var_35_6.ENEMY_PLAYER_AND_BOT_UNITS
	local var_35_8 = var_35_6.ENEMY_PLAYER_AND_BOT_POSITIONS

	if var_35_0(arg_35_0, arg_35_1.target_unit) and arg_35_1.target_stickyness_duration and var_35_5 < arg_35_1.target_stickyness_duration then
		local var_35_9 = Vector3.distance(var_0_3[arg_35_1.target_unit], var_35_1)

		return arg_35_1.target_unit, var_35_9
	end

	for iter_35_0, iter_35_1 in ipairs(var_35_7) do
		if var_35_0(arg_35_0, iter_35_1) then
			local var_35_10 = var_35_8[iter_35_0]
			local var_35_11 = Vector3.distance_squared(var_35_1, var_35_10)
			local var_35_12 = var_35_11

			if arg_35_1.corruptor_target and arg_35_1.corruptor_target == iter_35_1 then
				local var_35_13 = math.sqrt(var_35_11)

				return arg_35_1.corruptor_target, var_35_13
			end

			if var_35_12 < var_35_4 then
				var_35_3 = var_35_11
				var_35_4 = var_35_12
				var_35_2 = iter_35_1
			end
		end
	end

	arg_35_1.closest_enemy_dist_sq = var_35_3

	if var_35_2 ~= arg_35_1.target_unit then
		arg_35_1.target_stickyness_duration = var_35_5 + 2
	end

	local var_35_14 = math.sqrt(var_35_3)

	return var_35_2, var_35_14
end

function PerceptionUtils.pick_corruptor_target(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_1.side
	local var_36_1 = var_36_0.ENEMY_PLAYER_AND_BOT_UNITS
	local var_36_2 = var_36_0.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_36_3 = var_36_0.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_36_4 = AiUtils.is_of_interest_to_corruptor
	local var_36_5 = var_0_3[arg_36_0]
	local var_36_6
	local var_36_7 = math.huge
	local var_36_8 = math.huge

	for iter_36_0, iter_36_1 in ipairs(var_36_1) do
		if var_36_2[iter_36_1] and var_36_4(arg_36_0, iter_36_1) then
			local var_36_9 = var_36_3[iter_36_0]
			local var_36_10 = Vector3.distance_squared(var_36_5, var_36_9)
			local var_36_11 = var_36_10

			if iter_36_1 == arg_36_1.target_unit then
				var_36_11 = var_36_10 * 0.8
			end

			if arg_36_1.corruptor_target and arg_36_1.corruptor_target == iter_36_1 then
				local var_36_12 = math.sqrt(var_36_10)

				return arg_36_1.corruptor_target, var_36_12
			end

			if var_36_11 < var_36_8 then
				var_36_7 = var_36_10
				var_36_6 = iter_36_1
				var_36_8 = var_36_11
			end
		end
	end

	local var_36_13 = math.sqrt(var_36_7)

	return var_36_6, var_36_13
end

function PerceptionUtils.pick_tether_target(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = Managers.state.side
	local var_37_1 = var_0_3[arg_37_0]
	local var_37_2
	local var_37_3 = 0
	local var_37_4 = Managers.state.conflict:alive_bosses()

	for iter_37_0 = 1, #var_37_4 do
		local var_37_5 = var_37_4[iter_37_0]

		if var_37_0:is_ally(arg_37_0, var_37_5) then
			local var_37_6 = ScriptUnit.has_extension(var_37_5, "health_system")
			local var_37_7 = var_37_6 and var_37_6:get_max_health() or 0

			if var_37_3 < var_37_7 then
				var_37_2 = var_37_5
				var_37_3 = var_37_7
			end
		end
	end

	if var_37_2 then
		return var_37_2, Vector3.distance(var_37_1, var_0_3[var_37_2])
	end

	local var_37_8
	local var_37_9 = math.huge
	local var_37_10 = Managers.player:players()

	for iter_37_1, iter_37_2 in pairs(var_37_10) do
		local var_37_11 = var_0_3[iter_37_2.player_unit]

		if var_37_11 then
			local var_37_12 = Vector3.distance_squared(var_37_11, var_37_1)

			if var_37_12 < var_37_9 then
				var_37_8 = iter_37_2.player_unit
				var_37_9 = var_37_12
			end
		end
	end

	return var_37_8, math.sqrt(var_37_9)
end

function double_raycast(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	if not arg_38_0.line_of_sight_casts then
		arg_38_0.line_of_sight_casts = {}
	end

	local var_38_0 = arg_38_0.line_of_sight_casts[arg_38_3]

	if not var_38_0 then
		var_38_0 = table.clone(arg_38_2)
		arg_38_0.line_of_sight_casts[arg_38_3] = var_38_0
	end

	local var_38_1 = #var_38_0
	local var_38_2 = var_38_0.current_index % var_38_1 + 1

	var_38_0.current_index = var_38_2

	local var_38_3 = var_38_0[var_38_2]
	local var_38_4 = Unit.node(arg_38_3, var_38_3)
	local var_38_5 = Unit.world_position(arg_38_3, var_38_4)
	local var_38_6 = var_38_5 - arg_38_1
	local var_38_7 = Vector3.normalize(var_38_6)
	local var_38_8 = Vector3.length(var_38_6)
	local var_38_9 = "filter_ai_line_of_sight_check"
	local var_38_10, var_38_11 = PhysicsWorld.immediate_raycast(arg_38_4, arg_38_1, var_38_7, var_38_8, "closest", "collision_filter", var_38_9)

	if var_38_10 then
		var_38_0[var_38_3] = false
	else
		local var_38_12, var_38_13 = PhysicsWorld.immediate_raycast(arg_38_4, var_38_5, -var_38_7, var_38_8, "closest", "collision_filter", var_38_9)
		local var_38_14 = var_38_13

		if var_38_12 then
			var_38_0[var_38_3] = false
		else
			var_38_0[var_38_3] = true
		end
	end

	for iter_38_0 = 1, var_38_1 do
		local var_38_15 = var_38_0[(var_38_2 - iter_38_0) % var_38_1 + 1]

		if var_38_0[var_38_15] then
			return true, var_38_15
		end
	end

	return false
end

local function var_0_25(arg_39_0)
	local var_39_0 = ScriptUnit.extension(arg_39_0, "status_system")

	return not var_39_0:is_knocked_down() and not var_39_0:get_is_ledge_hanging() and not var_39_0:is_ready_for_assisted_respawn() and not var_39_0:is_hanging_from_hook()
end

function PerceptionUtils.pick_ratling_gun_target(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	local var_40_0 = arg_40_1.world
	local var_40_1 = World.get_data(var_40_0, "physics_world")
	local var_40_2 = arg_40_1.target_unit
	local var_40_3 = Matrix4x4(0.73776, -0.374671, 0.561545, 0.655785, 0.59515, -0.464481, -0.160177, 0.710927, 0.684781, 0.203595, -0.422035, 0.525395)
	local var_40_4 = var_0_3[arg_40_0]
	local var_40_5 = arg_40_1.breed
	local var_40_6
	local var_40_7 = math.huge
	local var_40_8
	local var_40_9
	local var_40_10 = false
	local var_40_11 = math.huge
	local var_40_12 = arg_40_1.side
	local var_40_13 = var_40_12.ENEMY_PLAYER_AND_BOT_UNITS
	local var_40_14 = var_40_12.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS

	for iter_40_0, iter_40_1 in ipairs(var_40_13) do
		if var_40_14[iter_40_1] and var_0_25(iter_40_1) then
			local var_40_15 = var_0_3[iter_40_1] - var_40_4
			local var_40_16 = Vector3.length_squared(var_40_15)
			local var_40_17 = arg_40_2 == iter_40_1
			local var_40_18 = arg_40_1.taunt_unit == iter_40_1

			if var_40_18 then
				var_40_16 = 0
			end

			local var_40_19 = var_40_16 < var_40_7

			if var_40_19 and (var_40_18 or not arg_40_3 or arg_40_3 < Vector3.dot(arg_40_4, Vector3.normalize(var_40_15))) or var_40_17 then
				local var_40_20 = Quaternion.look(Vector3.flat(var_40_15), Vector3.up())
				local var_40_21 = Matrix4x4.from_quaternion_position(var_40_20, var_40_4)
				local var_40_22 = Matrix4x4.translation(Matrix4x4.multiply(var_40_3, var_40_21))
				local var_40_23, var_40_24 = double_raycast(arg_40_1, var_40_22, var_40_5.line_of_sight_cast_template, iter_40_1, var_40_1)

				if var_40_17 then
					var_40_10 = var_40_23
					var_40_9 = var_40_24
					var_40_11 = var_40_16
				end

				if var_40_23 and var_40_19 then
					var_40_7 = var_40_16
					var_40_6 = iter_40_1
					var_40_8 = var_40_24
				end
			end
		end
	end

	return var_40_6, var_40_8, var_40_10, var_40_9, var_40_7, var_40_11
end

function PerceptionUtils.pick_warpfire_thrower_target(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_1.world
	local var_41_1 = World.get_data(var_41_0, "physics_world")
	local var_41_2 = arg_41_1.target_unit
	local var_41_3 = Matrix4x4(0.73776, -0.374671, 0.561545, 0.655785, 0.59515, -0.464481, -0.160177, 0.710927, 0.684781, 0.203595, -0.422035, 0.525395)
	local var_41_4 = var_0_3[arg_41_0]
	local var_41_5 = arg_41_1.breed
	local var_41_6
	local var_41_7 = math.huge
	local var_41_8
	local var_41_9
	local var_41_10 = false
	local var_41_11 = arg_41_1.side
	local var_41_12 = var_41_11.ENEMY_PLAYER_AND_BOT_UNITS
	local var_41_13 = var_41_11.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS

	for iter_41_0, iter_41_1 in ipairs(var_41_12) do
		if var_41_13[iter_41_1] and var_0_25(iter_41_1) then
			local var_41_14 = var_0_3[iter_41_1] - var_41_4
			local var_41_15 = Vector3.length_squared(var_41_14)
			local var_41_16 = arg_41_2 == iter_41_1

			if var_41_15 < var_41_5.detection_radius and (var_41_15 < var_41_7 or var_41_16) and var_41_15 < var_41_5.switch_target_radius * var_41_5.switch_target_radius then
				local var_41_17 = Quaternion.look(Vector3.flat(var_41_14), Vector3.up())
				local var_41_18 = Matrix4x4.from_quaternion_position(var_41_17, var_41_4)
				local var_41_19 = Matrix4x4.translation(Matrix4x4.multiply(var_41_3, var_41_18))
				local var_41_20, var_41_21 = double_raycast(arg_41_1, var_41_19, var_41_5.line_of_sight_cast_template, iter_41_1, var_41_1)

				if var_41_16 then
					var_41_10 = var_41_20
					var_41_9 = var_41_21
				end

				if var_41_20 and var_41_15 < var_41_7 then
					var_41_7 = var_41_15
					var_41_6 = iter_41_1
					var_41_8 = var_41_21
				end
			end
		end
	end

	return var_41_6, var_41_8, var_41_10, var_41_9
end

function PerceptionUtils.raycast_spine_to_spine(arg_42_0, arg_42_1, arg_42_2)
	if not ScriptUnit.has_extension(arg_42_1, "locomotion_system") then
		return true
	end

	local var_42_0 = Unit.has_node(arg_42_0, "camera_attach") and Unit.node(arg_42_0, "camera_attach") or Unit.node(arg_42_0, "c_spine")
	local var_42_1 = Unit.has_node(arg_42_1, "camera_attach") and Unit.node(arg_42_1, "camera_attach") or Unit.node(arg_42_1, "c_spine")
	local var_42_2 = Unit.world_position(arg_42_0, var_42_0)
	local var_42_3 = Unit.world_position(arg_42_1, var_42_1) - var_42_2
	local var_42_4 = Vector3.normalize(var_42_3)
	local var_42_5 = Vector3.length(var_42_3) + 2
	local var_42_6, var_42_7, var_42_8, var_42_9, var_42_10 = PhysicsWorld.immediate_raycast(arg_42_2, var_42_2, var_42_4, var_42_5, "closest", "collision_filter", "filter_ai_line_of_sight_check")

	if var_42_10 then
		return Actor.unit(var_42_10) == arg_42_1
	else
		return true
	end
end

local var_0_26 = 1
local var_0_27 = 2
local var_0_28 = 3
local var_0_29 = 4

function PerceptionUtils.is_position_in_line_of_sight(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	arg_43_4 = arg_43_4 or "filter_ai_line_of_sight_check"

	local var_43_0 = arg_43_2 - arg_43_1
	local var_43_1 = Vector3.normalize(var_43_0)
	local var_43_2 = Vector3.length(var_43_0)

	if Vector3.length(var_43_1) <= 0 then
		return false
	end

	local var_43_3, var_43_4, var_43_5, var_43_6, var_43_7 = PhysicsWorld.immediate_raycast(arg_43_3, arg_43_1, var_43_1, var_43_2, "closest", "collision_filter", arg_43_4)

	return not var_43_3, var_43_4
end

function PerceptionUtils.is_boss_in_los(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = "filter_player_and_enemy_hit_box_check"
	local var_44_1 = arg_44_2 - arg_44_1
	local var_44_2 = Vector3.normalize(var_44_1)
	local var_44_3 = Vector3.length(var_44_1)

	if Vector3.length(var_44_2) <= 0 then
		return false
	end

	local var_44_4 = PhysicsWorld.immediate_raycast(arg_44_3, arg_44_1, var_44_2, var_44_3, "all", "collision_filter", var_44_0)
	local var_44_5 = false
	local var_44_6

	if var_44_4 then
		for iter_44_0 = 1, #var_44_4 do
			local var_44_7 = var_44_4[iter_44_0][var_0_29]
			local var_44_8 = Actor.unit(var_44_7)
			local var_44_9 = Unit.get_data(var_44_8, "breed")

			if var_44_9 and var_44_9.boss then
				var_44_5 = true
				var_44_6 = var_44_4[iter_44_0][var_0_26]

				break
			end
		end
	end

	return var_44_5, var_44_6
end

function PerceptionUtils.has_line_of_sight_to_any_player(arg_45_0, arg_45_1)
	local var_45_0 = var_0_3[arg_45_0]
	local var_45_1 = BLACKBOARDS[arg_45_0]
	local var_45_2 = World.get_data(var_45_1.world, "physics_world")
	local var_45_3 = Vector3(0, 0, arg_45_1 or 1)
	local var_45_4 = var_45_1.side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_45_0 = 1, #var_45_4 do
		local var_45_5 = var_45_4[iter_45_0]

		if PerceptionUtils.is_position_in_line_of_sight(nil, var_45_0 + var_45_3, var_45_5 + var_45_3, var_45_2) then
			return true
		end
	end

	return false
end

function PerceptionUtils.position_has_line_of_sight_to_any_player(arg_46_0)
	local var_46_0 = Managers.world
	local var_46_1 = "level_world"
	local var_46_2 = var_46_0:world(var_46_1)
	local var_46_3 = World.get_data(var_46_2, "physics_world")
	local var_46_4 = Vector3(0, 0, 1)
	local var_46_5 = Managers.state.side:get_side_from_name("heroes").ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_46_0 = 1, #var_46_5 do
		local var_46_6 = var_46_5[iter_46_0]

		if PerceptionUtils.is_position_in_line_of_sight(nil, arg_46_0, var_46_6 + var_46_4, var_46_3) then
			return true
		end
	end

	return false
end

function PerceptionUtils.pick_area_target(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	local var_47_0
	local var_47_1 = 0
	local var_47_2 = {}
	local var_47_3 = arg_47_1.side.ENEMY_PLAYER_AND_BOT_POSITIONS

	if #var_47_3 > 1 then
		var_47_2 = PerceptionUtils._find_circles(arg_47_0, var_47_3, arg_47_3, arg_47_4)
	end

	if #var_47_2 > 0 then
		local var_47_4 = PerceptionUtils._pick_best_circle(var_47_2, var_47_3, arg_47_3)

		var_47_0 = var_47_4.pos
		var_47_1 = var_47_4.targets
	else
		var_47_0 = var_0_3[arg_47_1.target_unit]
		var_47_1 = 1
	end

	if Development.parameter("ai_debug_aoe_targeting") then
		PerceptionUtils.debug_draw_pick_area_target(var_47_2, var_47_0, arg_47_3, var_47_3)
	end

	return var_47_0, var_47_1
end

function PerceptionUtils._find_circles(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0 = var_0_3[arg_48_0]
	local var_48_1 = {}
	local var_48_2 = {}
	local var_48_3 = #arg_48_1

	for iter_48_0 = 1, var_48_3 do
		local var_48_4 = arg_48_1[iter_48_0]

		if arg_48_3 >= Vector3.distance(var_48_0, var_48_4) then
			var_48_2[#var_48_2 + 1] = var_48_4
		end
	end

	for iter_48_1 = 1, #var_48_2 - 1 do
		for iter_48_2 = 2, #var_48_2 do
			if iter_48_1 < iter_48_2 then
				local var_48_5 = var_48_2[iter_48_1]
				local var_48_6 = var_48_2[iter_48_2]
				local var_48_7 = Vector3.distance(var_48_5, var_48_6)

				if var_48_7 < arg_48_2 * 2 then
					local var_48_8 = var_48_5 + (var_48_6 - var_48_5) * 0.5
					local var_48_9 = var_48_7 / 2
					local var_48_10 = arg_48_2
					local var_48_11 = math.sqrt(arg_48_2^2 - var_48_9^2)
					local var_48_12 = var_48_6.x - var_48_5.x
					local var_48_13 = var_48_6.y - var_48_5.y
					local var_48_14 = var_48_8 + Vector3.normalize(Vector3(-var_48_13, var_48_12, 0)) * var_48_11
					local var_48_15 = var_48_8 + Vector3.normalize(Vector3(var_48_13, -var_48_12, 0)) * var_48_11

					var_48_1[#var_48_1 + 1] = {
						targets = 0,
						pos = var_48_14,
						distance = Vector3.distance(var_48_14, var_48_0)
					}
					var_48_1[#var_48_1 + 1] = {
						targets = 0,
						pos = var_48_15,
						distance = Vector3.distance(var_48_15, var_48_0)
					}
				end
			end
		end
	end

	return var_48_1
end

function PerceptionUtils._pick_best_circle(arg_49_0, arg_49_1, arg_49_2)
	for iter_49_0, iter_49_1 in ipairs(arg_49_0) do
		for iter_49_2, iter_49_3 in pairs(arg_49_1) do
			if arg_49_2 >= math.round_with_precision(Vector3.distance(iter_49_1.pos, iter_49_3), 2) then
				iter_49_1.targets = iter_49_1.targets + 1
			end
		end
	end

	local var_49_0 = 1

	for iter_49_4 = 2, #arg_49_0 do
		if arg_49_0[iter_49_4].targets > arg_49_0[var_49_0].targets then
			var_49_0 = iter_49_4
		elseif arg_49_0[iter_49_4].targets == arg_49_0[var_49_0].targets and arg_49_0[iter_49_4].distance < arg_49_0[var_49_0].distance then
			var_49_0 = iter_49_4
		end
	end

	return arg_49_0[var_49_0]
end

function PerceptionUtils.debug_draw_pick_area_target(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = Managers.state.debug:drawer({
		mode = "retained",
		name = "pick_area_target"
	})
	local var_50_1 = Vector3.up() * 0.3

	var_50_0:reset()

	for iter_50_0 = 1, #arg_50_0, 2 do
		local var_50_2 = arg_50_0[iter_50_0]
		local var_50_3 = arg_50_0[iter_50_0 + 1]
		local var_50_4 = math.random(155)
		local var_50_5 = math.random(255)
		local var_50_6 = math.random(255)

		var_50_0:circle(var_50_2.pos + var_50_1, arg_50_2, Vector3.up(), Color(255, var_50_4, var_50_5, var_50_6), 100)
		var_50_0:circle(var_50_3.pos + var_50_1, arg_50_2, Vector3.up(), Color(255, var_50_4, var_50_5, var_50_6), 100)

		for iter_50_1 = 1, var_50_2.targets do
			var_50_0:circle(var_50_2.pos + var_50_1, 0.5 + iter_50_1 * 0.1, Vector3.up(), Color(255, var_50_4, var_50_5, var_50_6), 100)
		end

		for iter_50_2 = 1, var_50_3.targets do
			var_50_0:circle(var_50_3.pos + var_50_1, 0.5 + iter_50_2 * 0.1, Vector3.up(), Color(255, var_50_4, var_50_5, var_50_6), 100)
		end
	end

	for iter_50_3, iter_50_4 in pairs(arg_50_3) do
		var_50_0:sphere(iter_50_4 + var_50_1, 0.1, Color(255, 230, 83, 230))
	end

	if arg_50_1 then
		var_50_0:sphere(arg_50_1 + var_50_1, 0.2, Color(255, 255, 0, 0))
		var_50_0:circle(arg_50_1 + var_50_1, arg_50_2, Vector3.up(), Color(255, 255, 0, 0), 20)
	end
end

function PerceptionUtils.debug_draw_throw_trajectory(arg_51_0)
	local var_51_0 = Managers.state.debug:drawer({
		mode = "retained",
		name = "projectile_unit_debug"
	})

	for iter_51_0 = 1, #arg_51_0 do
		var_51_0:sphere(arg_51_0[iter_51_0], 0.05, Color(255, 255, 255, 255))
	end
end
