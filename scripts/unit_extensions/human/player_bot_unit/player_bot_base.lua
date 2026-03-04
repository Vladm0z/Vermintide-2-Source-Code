-- chunkname: @scripts/unit_extensions/human/player_bot_unit/player_bot_base.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_brain")

local var_0_0 = Unit.alive
local var_0_1 = BLACKBOARDS
local var_0_2 = 5
local var_0_3 = 4.5
local var_0_4 = 1.5
local var_0_5 = 15
local var_0_6 = -0.2
local var_0_7 = 1
local var_0_8 = 1.5
local var_0_9 = 9
local var_0_10 = 0.8
local var_0_11 = 0.25
local var_0_12 = BotConstants.default.FLAT_MOVE_TO_EPSILON
local var_0_13 = var_0_12^2
local var_0_14 = BotConstants.default.FLAT_MOVE_TO_PREVIOUS_POS_EPSILON^2
local var_0_15 = BotConstants.default.Z_MOVE_TO_EPSILON
local var_0_16 = 0.5
local var_0_17 = 0.1
local var_0_18 = 0.11
local var_0_19 = 0.25
local var_0_20 = 0.6
local var_0_21 = 0.8
local var_0_22 = 10
local var_0_23 = 0.75
local var_0_24 = 1
local var_0_25 = 0.01
local var_0_26

local function var_0_27(...)
	if var_0_26 == script_data.debug_unit and script_data.ai_bots_debug then
		print(...)
	end
end

local function var_0_28(...)
	if var_0_26 == script_data.debug_unit and script_data.ai_bots_debug then
		Debug.text(...)
	end
end

PlayerBotBase = class(PlayerBotBase)

local function var_0_29(arg_3_0)
	local var_3_0 = #arg_3_0
	local var_3_1 = -math.huge

	for iter_3_0 = 1, var_3_0 do
		local var_3_2 = arg_3_0[iter_3_0].weight

		if var_3_1 < var_3_2 then
			var_3_1 = var_3_2
		end
	end

	return var_3_1
end

PlayerBotBase.init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_1.world

	arg_4_0._world = var_4_0
	arg_4_0._unit = arg_4_2
	arg_4_0._nav_world = arg_4_3.nav_world
	arg_4_0._enemy_broadphase = Managers.state.entity:system("ai_system").broadphase

	local var_4_1 = Vector3Box(Vector3(0, 0, 0))

	var_4_1.value_stored = false
	arg_4_0.is_bot = true
	arg_4_0._t = 0
	arg_4_0._blackboard = {
		is_passive = true,
		target_ally_needs_aid = false,
		using_navigation_destination_override = false,
		re_evaluate_detection = Math.random() * 0.5,
		world = var_4_0,
		unit = arg_4_2,
		level = LevelHelper:current_level(arg_4_1.world),
		nav_world = arg_4_0._nav_world,
		node_data = {},
		running_nodes = {},
		proximite_enemies = {},
		follow = {
			needs_target_position_refresh = true,
			follow_timer = math.lerp(var_0_7, var_0_8, Math.random()),
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

	local var_4_2 = Vector3.up()
	local var_4_3 = {
		{
			weight = 0.5,
			direction = Vector3Box(Quaternion.forward(Quaternion(var_4_2, -math.pi * 4 / 8)))
		},
		{
			weight = 0.75,
			direction = Vector3Box(Quaternion.forward(Quaternion(var_4_2, -math.pi * 3 / 8)))
		},
		{
			weight = 1,
			direction = Vector3Box(Quaternion.forward(Quaternion(var_4_2, -math.pi * 2 / 8)))
		},
		{
			weight = 0.7,
			direction = Vector3Box(Quaternion.forward(Quaternion(var_4_2, -math.pi * 1 / 8)))
		},
		{
			weight = 0.6,
			direction = Vector3Box(Quaternion.forward(Quaternion(var_4_2, math.pi * 0 / 8)))
		},
		{
			weight = 0.7,
			direction = Vector3Box(Quaternion.forward(Quaternion(var_4_2, math.pi * 1 / 8)))
		},
		{
			weight = 1,
			direction = Vector3Box(Quaternion.forward(Quaternion(var_4_2, math.pi * 2 / 8)))
		},
		{
			weight = 0.75,
			direction = Vector3Box(Quaternion.forward(Quaternion(var_4_2, math.pi * 3 / 8)))
		},
		{
			weight = 0.5,
			direction = Vector3Box(Quaternion.forward(Quaternion(var_4_2, math.pi * 4 / 8)))
		}
	}

	arg_4_0._vortex_escape_directions = var_4_3
	arg_4_0._vortex_largest_weighted_distance_sq = var_0_29(var_4_3) * var_0_22^2
	arg_4_0._bot_profile = arg_4_3.bot_profile
	arg_4_0._player = arg_4_3.player

	Unit.set_data(arg_4_2, "bot", arg_4_0._bot_profile)
	Managers.player:assign_unit_ownership(arg_4_2, arg_4_0._player, true)
	Unit.set_flow_variable(arg_4_2, "is_bot", true)
	Unit.flow_event(arg_4_2, "character_vo_set")
	arg_4_0:_init_brain()

	arg_4_0._proximity_target_update_timer = -math.huge
	arg_4_0._pickup_search_timer = -math.huge
	arg_4_0._search_for_pickups_near_ally = false
	arg_4_0._interactable_timer = -math.huge
	arg_4_0._stay_near_player = false
	arg_4_0._stay_near_player_range = math.huge
	arg_4_0._attempted_enemy_paths = {}
	arg_4_0._attempted_ally_paths = {}
	arg_4_0._seen_by_players = {}
	arg_4_0._last_health_pickup_attempt = {
		blacklist = false,
		distance = 0,
		index = 1,
		path_failed = false,
		rotation = QuaternionBox(),
		path_position = Vector3Box()
	}
	arg_4_0._last_mule_pickup_attempt = {
		blacklist = false,
		distance = 0,
		index = 1,
		path_failed = false,
		rotation = QuaternionBox(),
		path_position = Vector3Box()
	}
end

PlayerBotBase.ranged_attack_started = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0._blackboard

	if arg_5_3 == "ratling_gun_fire" then
		var_5_0.taking_cover.threats[arg_5_1] = arg_5_2
	end
end

PlayerBotBase.ranged_attack_ended = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0._blackboard

	if arg_6_3 == "ratling_gun_fire" then
		var_6_0.taking_cover.threats[arg_6_1] = nil
	end
end

PlayerBotBase.hit_by_projectile = function (arg_7_0, arg_7_1)
	arg_7_0._blackboard.hit_by_projectile[arg_7_1] = arg_7_0._t
end

local var_0_30 = 5

PlayerBotBase.set_stay_near_player = function (arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 then
		arg_8_0._stay_near_player_range = arg_8_2 or var_0_30
	else
		arg_8_0._stay_near_player_range = math.huge
	end

	arg_8_0._stay_near_player = arg_8_1
end

PlayerBotBase.should_stay_near_player = function (arg_9_0)
	return arg_9_0._stay_near_player, arg_9_0._stay_near_player_range
end

PlayerBotBase.set_seen_by_player = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0._seen_by_players

	if arg_10_1 then
		var_10_0[arg_10_2] = arg_10_3
	else
		var_10_0[arg_10_2] = nil
	end
end

PlayerBotBase.extensions_ready = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._blackboard
	local var_11_1 = ScriptUnit.extension(arg_11_2, "input_system")
	local var_11_2 = ScriptUnit.extension(arg_11_2, "inventory_system")
	local var_11_3 = ScriptUnit.extension(arg_11_2, "overcharge_system")
	local var_11_4 = ScriptUnit.extension(arg_11_2, "ai_navigation_system")
	local var_11_5 = ScriptUnit.extension(arg_11_2, "first_person_system")
	local var_11_6 = ScriptUnit.extension(arg_11_2, "status_system")
	local var_11_7 = ScriptUnit.extension(arg_11_2, "interactor_system")
	local var_11_8 = ScriptUnit.extension(arg_11_2, "health_system")
	local var_11_9 = ScriptUnit.extension(arg_11_2, "ai_bot_group_system")
	local var_11_10 = ScriptUnit.extension(arg_11_2, "ai_system")
	local var_11_11 = ScriptUnit.extension(arg_11_2, "locomotion_system")
	local var_11_12 = ScriptUnit.extension(arg_11_2, "career_system")
	local var_11_13 = ScriptUnit.extension(arg_11_2, "ai_slot_system")
	local var_11_14 = ScriptUnit.extension(arg_11_2, "ai_commander_system")

	arg_11_0._health_extension = var_11_8
	arg_11_0._status_extension = var_11_6
	arg_11_0._locomotion_extension = var_11_11
	arg_11_0._navigation_extension = var_11_4
	var_11_0.input_extension = var_11_1
	var_11_0.inventory_extension = var_11_2
	var_11_0.overcharge_extension = var_11_3
	var_11_0.navigation_extension = var_11_4
	var_11_0.locomotion_extension = var_11_11
	var_11_0.first_person_extension = var_11_5
	var_11_0.status_extension = var_11_6
	var_11_0.interaction_extension = var_11_7
	var_11_0.health_extension = var_11_8
	var_11_0.ai_bot_group_extension = var_11_9
	var_11_0.ai_extension = var_11_10
	var_11_0.career_extension = var_11_12
	var_11_0.ai_slot_extension = var_11_13
	var_11_0.ai_commander_extension = var_11_14
	var_11_0.side = Managers.state.side.side_by_unit[arg_11_2]
end

PlayerBotBase._init_brain = function (arg_12_0)
	arg_12_0._brain = AIBrain:new(arg_12_0._world, arg_12_0._unit, arg_12_0._blackboard, arg_12_0._bot_profile, arg_12_0._bot_profile.behavior)
end

PlayerBotBase.brain = function (arg_13_0)
	return arg_13_0._brain
end

PlayerBotBase.profile = function (arg_14_0)
	return arg_14_0._bot_profile
end

PlayerBotBase.blackboard = function (arg_15_0)
	return arg_15_0._blackboard
end

PlayerBotBase.update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	arg_16_0._t = arg_16_5

	local var_16_0 = arg_16_0._status_extension
	local var_16_1 = arg_16_0._locomotion_extension
	local var_16_2 = HEALTH_ALIVE[arg_16_0._unit]
	local var_16_3 = var_16_0:is_ready_for_assisted_respawn()
	local var_16_4 = var_16_1:is_linked_movement()

	if var_16_2 and not var_16_3 and not var_16_4 then
		var_0_26 = arg_16_1

		arg_16_0:_update_blackboard(arg_16_3, arg_16_5)
		arg_16_0:_update_target_enemy(arg_16_3, arg_16_5)
		arg_16_0:_update_target_ally(arg_16_3, arg_16_5)
		arg_16_0:_update_liquid_escape()
		arg_16_0:_update_vortex_escape()
		arg_16_0:_update_pickups(arg_16_3, arg_16_5)
		arg_16_0:_update_interactables(arg_16_3, arg_16_5)
		arg_16_0:_update_weapon_loadout_data(false)
		arg_16_0:_update_best_weapon()
		arg_16_0:_update_reload()
		arg_16_0._brain:update(arg_16_1, arg_16_5, arg_16_3)

		local var_16_5, var_16_6, var_16_7 = var_16_1:get_moving_platform()

		if var_16_0:is_disabled() or var_16_5 and not var_16_7 then
			arg_16_0._navigation_extension:teleport(POSITION_LOOKUP[arg_16_1])
		elseif var_16_1:is_on_ground() then
			arg_16_0:_update_movement_target(arg_16_3, arg_16_5)
		end

		arg_16_0:_update_attack_request(arg_16_5)
	end
end

PlayerBotBase._update_blackboard = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._blackboard
	local var_17_1 = arg_17_0._status_extension
	local var_17_2 = arg_17_0._locomotion_extension

	var_17_0.is_knocked_down = var_17_1:is_knocked_down()
	var_17_0.is_grabbed_by_pack_master = var_17_1:is_grabbed_by_pack_master()
	var_17_0.is_pounced_down = var_17_1:is_pounced_down()
	var_17_0.is_hanging_from_hook = var_17_1:is_hanging_from_hook()
	var_17_0.is_ledge_hanging = var_17_1:get_is_ledge_hanging()

	local var_17_3, var_17_4, var_17_5 = var_17_2:get_moving_platform()

	var_17_0.is_transported = var_17_1:is_using_transport() or var_17_3 and not var_17_5
	var_17_0.is_grabbed_by_chaos_spawn = var_17_1:is_grabbed_by_chaos_spawn()

	local var_17_6 = arg_17_0._unit
	local var_17_7 = var_17_0.target_unit

	if ALIVE[var_17_7] then
		var_17_0.target_dist = Vector3.distance(POSITION_LOOKUP[var_17_7], POSITION_LOOKUP[var_17_6])
	else
		var_17_0.target_dist = math.huge
		var_17_0.target_unit = nil
	end

	for iter_17_0, iter_17_1 in pairs(var_17_0.utility_actions) do
		iter_17_1.time_since_last = arg_17_2 - iter_17_1.last_time
	end
end

PlayerBotBase._update_target_enemy = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = POSITION_LOOKUP[arg_18_0._unit]

	arg_18_0:_update_slot_target(arg_18_1, arg_18_2, var_18_0)
	arg_18_0:_update_proximity_target(arg_18_1, arg_18_2, var_18_0)

	local var_18_1 = arg_18_0._blackboard
	local var_18_2 = var_18_1.target_unit
	local var_18_3 = var_18_1.slot_target_enemy
	local var_18_4 = var_18_1.proximity_target_enemy
	local var_18_5 = var_18_1.priority_target_enemy
	local var_18_6 = var_18_1.urgent_target_enemy
	local var_18_7 = var_18_1.opportunity_target_enemy
	local var_18_8 = var_18_1.proximity_target_distance + (var_18_4 == var_18_2 and var_0_6 or 0)
	local var_18_9 = var_18_1.priority_target_distance + (var_18_5 == var_18_2 and var_0_6 or 0)
	local var_18_10 = var_18_1.urgent_target_distance + (var_18_6 == var_18_2 and var_0_6 or 0)
	local var_18_11 = var_18_1.opportunity_target_distance + (var_18_7 == var_18_2 and var_0_6 or 0)
	local var_18_12 = var_18_3 and Vector3.length(POSITION_LOOKUP[var_18_3] - var_18_0) + (var_18_3 == var_18_2 and var_0_6 or 0)

	if var_18_5 and var_18_9 < 3 then
		var_18_1.target_unit = var_18_5
	elseif var_18_6 and var_18_10 < 3 then
		var_18_1.target_unit = var_18_6
	elseif var_18_7 and var_18_11 < 3 then
		var_18_1.target_unit = var_18_7
	elseif var_18_3 and var_18_12 < 3 then
		var_18_1.target_unit = var_18_3
	elseif var_18_4 and var_18_8 < 2 then
		var_18_1.target_unit = var_18_4
	elseif var_18_4 and var_18_1.proximity_target_is_player and var_18_8 < 10 then
		var_18_1.target_unit = var_18_4
	elseif var_18_5 then
		var_18_1.target_unit = var_18_5
	elseif var_18_6 then
		var_18_1.target_unit = var_18_6
	elseif var_18_7 then
		var_18_1.target_unit = var_18_7
	elseif var_18_3 then
		var_18_1.target_unit = var_18_3
	elseif var_18_1.target_unit then
		var_18_1.target_unit = nil
	end
end

local var_0_31 = {}

PlayerBotBase._update_proximity_target = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = arg_19_0._blackboard

	if arg_19_2 > arg_19_0._proximity_target_update_timer then
		local var_19_1 = arg_19_0._unit

		arg_19_0._proximity_target_update_timer = arg_19_2 + 0.25 + Math.random() * 0.15

		local var_19_2 = var_19_0.proximite_enemies

		table.clear(var_19_2)

		local var_19_3 = var_0_2

		var_19_0.aggressive_mode = false
		var_19_0.force_aid = false

		local var_19_4

		if ALIVE[var_19_0.target_ally_unit] and var_19_0.target_ally_needs_aid and arg_19_0:within_aid_range(var_19_0) then
			var_19_4 = POSITION_LOOKUP[var_19_0.target_ally_unit]

			local var_19_5 = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(var_19_1, var_19_0.target_ally_unit)
			local var_19_6 = var_19_0.current_interaction_unit == var_19_0.target_ally_unit

			if var_19_5 and var_19_6 then
				var_19_3 = var_0_4
				var_19_0.force_aid = true
			elseif var_19_5 then
				var_19_3 = var_0_3
				var_19_0.force_aid = true
			else
				var_19_0.aggressive_mode = true
				var_19_3 = var_0_5
			end
		else
			var_19_4 = arg_19_3
		end

		local var_19_7 = var_19_0.side
		local var_19_8 = Broadphase.query(arg_19_0._enemy_broadphase, var_19_4, var_19_3, var_0_31, var_19_7.enemy_broadphase_categories)
		local var_19_9 = math.huge
		local var_19_10
		local var_19_11 = math.huge

		for iter_19_0, iter_19_1 in pairs(var_19_7.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS) do
			var_19_8 = var_19_8 + 1
			var_0_31[var_19_8] = iter_19_0
		end

		local var_19_12 = 1

		for iter_19_2 = 1, var_19_8 do
			local var_19_13 = var_0_31[iter_19_2]

			if HEALTH_ALIVE[var_19_13] then
				local var_19_14 = POSITION_LOOKUP[var_19_13] - var_19_4

				if arg_19_0:_target_valid(var_19_13, var_19_14) then
					var_19_2[var_19_12] = var_19_13
					var_19_12 = var_19_12 + 1

					local var_19_15 = Vector3.length(var_19_14)
					local var_19_16 = var_19_15 + (var_19_13 == var_19_0.target_unit and var_0_6 or 0)

					if var_19_16 < var_19_9 then
						var_19_10 = var_19_13
						var_19_9 = var_19_16
						var_19_11 = var_19_15
					end
				end
			end
		end

		if var_19_0.proximity_target_enemy or var_19_10 then
			var_19_0.proximity_target_enemy = var_19_10
			var_19_0.proximity_target_is_player = var_19_7.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_19_10] ~= nil
		end

		var_19_0.proximity_target_distance = var_19_11
	elseif var_19_0.proximity_target_enemy and not ALIVE[var_19_0.proximity_target_enemy] then
		var_19_0.proximity_target_enemy = nil
		var_19_0.proximity_target_distance = math.huge
		var_19_0.proximity_target_is_player = nil
	end
end

local var_0_32 = math.sin(math.pi * 0.25)

PlayerBotBase._target_valid = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = var_0_1[arg_20_1]

	if not var_20_0 or var_20_0.breed.not_bot_target then
		return false
	end

	if ScriptUnit.has_extension(arg_20_1, "ai_group_system") and not var_20_0.target_unit then
		return false
	end

	local var_20_1 = Vector3.dot(Vector3.up(), Vector3.normalize(arg_20_2))

	if var_20_1 > var_0_32 or var_20_1 < -var_0_32 then
		return false
	end

	return true
end

PlayerBotBase._update_slot_target = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0._blackboard
	local var_21_1 = arg_21_0._unit
	local var_21_2 = var_21_0.target_unit
	local var_21_3 = arg_21_3
	local var_21_4 = arg_21_0:_get_closest_target_in_slot(var_21_3, var_21_1, var_21_2, true)

	if var_21_4 then
		var_21_0.slot_target_enemy = var_21_4

		return
	end

	local var_21_5 = var_21_0.target_ally_unit

	if ALIVE[var_21_5] then
		local var_21_6 = arg_21_0:_get_closest_target_in_slot(var_21_3, var_21_5, var_21_2)

		if var_21_6 then
			var_21_0.slot_target_enemy = var_21_6

			return
		end
	end

	local var_21_7 = Managers.state.side.side_by_unit[var_21_1].PLAYER_AND_BOT_UNITS
	local var_21_8
	local var_21_9 = math.huge

	for iter_21_0 = 1, #var_21_7 do
		local var_21_10 = var_21_7[iter_21_0]

		if var_21_10 ~= var_21_5 and var_21_10 ~= var_21_1 then
			local var_21_11, var_21_12 = arg_21_0:_get_closest_target_in_slot(var_21_3, var_21_10, var_21_2)

			if var_21_12 < var_21_9 then
				var_21_8 = var_21_11
				var_21_9 = var_21_12
			end
		end
	end

	if var_21_8 then
		var_21_0.slot_target_enemy = var_21_8

		return
	end

	if var_21_0.slot_target_enemy then
		var_21_0.slot_target_enemy = nil
	end
end

local var_0_33 = -1
local var_0_34 = table.keys(SlotTypeSettings)

PlayerBotBase._get_closest_target_in_slot = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = Managers.state.entity:system("ai_slot_system")
	local var_22_1
	local var_22_2 = math.huge

	for iter_22_0 = 1, #var_0_34 do
		local var_22_3 = var_0_34[iter_22_0]
		local var_22_4 = var_22_0:get_target_unit_slot_data(arg_22_2, var_22_3)

		if var_22_4 then
			for iter_22_1, iter_22_2 in pairs(var_22_4) do
				local var_22_5 = iter_22_2.ai_unit

				if HEALTH_ALIVE[var_22_5] then
					local var_22_6 = Vector3.length(POSITION_LOOKUP[var_22_5] - arg_22_1)

					if var_22_5 == arg_22_3 then
						var_22_6 = var_22_6 + var_0_6
					end

					if arg_22_4 and Unit.get_data(var_22_5, "breed").is_bot_threat then
						var_22_6 = var_22_6 + var_0_33
					end

					if var_22_6 < var_22_2 then
						var_22_1 = var_22_5
						var_22_2 = var_22_6
					end
				end
			end
		end
	end

	return var_22_1, var_22_2
end

PlayerBotBase._alter_target_position = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	local var_23_0
	local var_23_1

	if arg_23_5 == "ledge" then
		local var_23_2 = Unit.local_rotation(arg_23_3, 0)

		var_23_0 = arg_23_4 - Vector3.normalize(Vector3.flat(Quaternion.forward(var_23_2))) * 0.5
	elseif arg_23_5 == "in_need_of_heal" or arg_23_5 == "can_accept_grenade" or arg_23_5 == "can_accept_potion" or arg_23_5 == "can_accept_heal_item" then
		local var_23_3 = ScriptUnit.extension(arg_23_3, "locomotion_system"):average_velocity()

		if Vector3.length_squared(var_23_3) > 2.25 then
			var_23_0 = arg_23_4 + var_23_3
		else
			var_23_0 = arg_23_4 + Vector3.normalize(arg_23_2 - arg_23_4)
		end
	elseif arg_23_5 == "knocked_down" and arg_23_0._blackboard.aggressive_mode then
		var_23_0 = arg_23_4 + Vector3.normalize(arg_23_2 - arg_23_4) * INTERACT_RAY_DISTANCE
	elseif arg_23_5 == "in_need_of_attention_stop" then
		var_23_0 = Vector3(arg_23_2.x, arg_23_2.y, arg_23_2.z)
		var_23_1 = true
	else
		var_23_0 = Vector3(arg_23_4.x, arg_23_4.y, arg_23_4.z) + Vector3.normalize(arg_23_2 - arg_23_4) * INTERACT_RAY_DISTANCE
	end

	if var_23_1 then
		return var_23_0, var_23_1
	end

	local var_23_4 = 0.5
	local var_23_5 = 3
	local var_23_6, var_23_7 = GwNavQueries.triangle_from_position(arg_23_1, var_23_0, var_23_4, var_23_5)

	if var_23_6 then
		var_23_0.z = var_23_7

		return var_23_0
	else
		local var_23_8 = 2
		local var_23_9 = GwNavQueries.inside_position_from_outside_position(arg_23_1, arg_23_4, var_23_4, var_23_5, var_23_8, 0.1)

		if var_23_9 then
			return var_23_9
		else
			return arg_23_4
		end
	end
end

PlayerBotBase._find_target_position_on_nav_mesh = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = 0.5
	local var_24_1 = 0.5
	local var_24_2, var_24_3 = GwNavQueries.triangle_from_position(arg_24_1, arg_24_2, var_24_0, var_24_1)

	if var_24_2 then
		return Vector3(arg_24_2.x, arg_24_2.y, var_24_3)
	else
		local var_24_4 = 2.5
		local var_24_5 = GwNavQueries.inside_position_from_outside_position(arg_24_1, arg_24_2, var_24_0, var_24_1, var_24_4, 0.1)

		if var_24_5 then
			return var_24_5
		else
			return arg_24_2
		end
	end
end

PlayerBotBase._update_target_ally = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._unit
	local var_25_1 = arg_25_0._blackboard
	local var_25_2 = arg_25_0._bot_profile
	local var_25_3
	local var_25_4
	local var_25_5
	local var_25_6

	if var_25_1.target_unit and var_25_1.target_unit == var_25_1.priority_target_enemy then
		var_25_3 = var_25_1.priority_target_disabled_ally
		var_25_4 = Vector3.distance(POSITION_LOOKUP[var_25_0], POSITION_LOOKUP[var_25_3])
	else
		var_25_3, var_25_4, var_25_5, var_25_6 = arg_25_0:_select_ally_by_utility(var_25_0, var_25_1, var_25_2, arg_25_2)
	end

	local var_25_7 = var_25_3 and var_25_1.target_ally_unit ~= var_25_3

	var_25_1.target_ally_unit = var_25_3 or nil
	var_25_1.ally_distance = var_25_4

	if (var_25_7 or var_25_1.target_ally_unit) and var_25_5 then
		if (not var_25_1.target_ally_needs_aid or var_25_7) and var_25_5 ~= "in_need_of_attention_look" then
			local var_25_8 = var_25_1.follow

			if var_25_8 then
				var_25_8.needs_target_position_refresh = true
			end
		end

		var_25_1.target_ally_needs_aid = true
		var_25_1.target_ally_need_type = var_25_5
	elseif var_25_1.target_ally_needs_aid then
		var_25_1.target_ally_needs_aid = false
		var_25_1.target_ally_need_type = nil
	end

	local var_25_9 = var_25_1.input_extension

	if var_25_6 then
		var_25_9:set_look_at_player(var_25_3, false)
	else
		var_25_9:set_look_at_player(nil)
	end

	local var_25_10 = var_25_1.target_ally_need_type == "knocked_down" or var_25_1.target_ally_need_type == "ledge" or var_25_1.target_ally_need_type == "hook"

	if var_25_1.target_ally_needs_aid and var_25_10 then
		Managers.state.entity:system("ai_bot_group_system"):register_ally_needs_aid_priority(var_25_0, var_25_1.target_ally_unit)
	end
end

local var_0_35 = math.degrees_to_radians(30)
local var_0_36 = 3.5

PlayerBotBase._player_needs_attention = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	local var_26_0 = arg_26_0._seen_by_players[arg_26_2]
	local var_26_1 = arg_26_4:equipment().wielded_slot
	local var_26_2 = arg_26_4:get_slot_data(var_26_1)

	if not var_26_0 or arg_26_3.target_unit or var_26_2 == nil then
		return false, 0
	end

	local var_26_3 = arg_26_3.status_extension:is_wounded()
	local var_26_4 = arg_26_3.health_extension:current_permanent_health_percent()
	local var_26_5 = arg_26_4:get_item_template(var_26_2)
	local var_26_6 = var_26_5.can_heal_other
	local var_26_7 = var_26_5.can_give_other
	local var_26_8 = not arg_26_3.inventory_extension:get_slot_data(var_26_1)
	local var_26_9 = var_26_7 and var_26_8
	local var_26_10 = var_26_6 and (var_26_3 or var_26_4 < var_0_21)
	local var_26_11 = POSITION_LOOKUP[arg_26_1] - POSITION_LOOKUP[arg_26_2]
	local var_26_12 = Vector3.normalize(var_26_11)
	local var_26_13 = arg_26_5:current_velocity()
	local var_26_14 = Vector3.normalize(var_26_13)
	local var_26_15 = Vector3.length_squared(var_26_13)
	local var_26_16 = arg_26_3.locomotion_extension:current_velocity()
	local var_26_17 = Vector3.normalize(var_26_16)
	local var_26_18 = Vector3.length_squared(var_26_16)
	local var_26_19 = Vector3.dot(var_26_12, var_26_14) > var_0_35
	local var_26_20

	if var_26_18 > 0.01 then
		var_26_20 = Vector3.dot(var_26_12, var_26_17) <= var_0_35
	else
		var_26_20 = false
	end

	local var_26_21
	local var_26_22
	local var_26_23 = var_0_36

	if var_26_19 and var_26_1 == "slot_healthkit" and (var_26_10 or var_26_9) then
		var_26_22 = 0.5 - (1 - var_26_4) * 0.2
		var_26_21 = 0.25
		var_26_23 = var_26_23 + math.sqrt(var_26_15)
	elseif math.min(var_26_18, var_26_15) > 0.01 or var_26_20 then
		var_26_22 = math.huge
		var_26_21 = 0.5
	elseif var_26_18 <= 0.01 and var_26_15 <= 0.01 then
		var_26_22 = 0.3
		var_26_21 = 0.25
	else
		var_26_22 = 1.25
		var_26_21 = 0.5
	end

	local var_26_24 = Vector3.length_squared(var_26_11)

	if var_26_24 > var_26_23^2 or var_26_24 <= 0.25 then
		var_26_22 = math.huge
	end

	local var_26_25 = Managers.state.entity:system("ai_bot_group_system")
	local var_26_26 = var_26_25:get_ammo_pickup_order_unit(arg_26_1) ~= nil or var_26_25:has_pending_pickup_order(arg_26_1)
	local var_26_27 = arg_26_6 - var_26_0

	if var_26_22 < var_26_27 and not var_26_26 then
		local var_26_28 = math.clamp(var_26_27, 0, 2)

		return "stop", var_26_28
	elseif var_26_21 < var_26_27 then
		local var_26_29 = math.clamp(var_26_27, 0, 0.5)

		return "look_at", var_26_29
	end
end

PlayerBotBase._calculate_healing_item_utility = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if arg_27_3 then
		return 1 - (arg_27_2 and arg_27_1 - 0.5 or arg_27_1)
	else
		return 1 - (arg_27_2 and arg_27_1 * 0.33 or arg_27_1)
	end
end

PlayerBotBase._select_ally_by_utility = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = POSITION_LOOKUP[arg_28_1]
	local var_28_1
	local var_28_2 = math.huge
	local var_28_3 = math.huge
	local var_28_4
	local var_28_5 = false
	local var_28_6 = ScriptUnit.extension(arg_28_1, "buff_system")
	local var_28_7 = arg_28_2.inventory_extension
	local var_28_8 = var_28_7:get_slot_data("slot_healthkit")
	local var_28_9 = false
	local var_28_10 = false
	local var_28_11 = 0

	if var_28_8 then
		local var_28_12 = arg_28_0._status_extension:is_wounded()
		local var_28_13 = var_28_7:get_item_template(var_28_8)
		local var_28_14 = var_28_6:has_buff_type("trait_necklace_no_healing_health_regen")

		var_28_9 = var_28_13.can_heal_other
		var_28_10 = var_28_13.can_give_other

		if not var_28_14 or var_28_12 then
			local var_28_15 = arg_28_0._health_extension:current_permanent_health_percent()

			var_28_11 = arg_28_0:_calculate_healing_item_utility(var_28_15, var_28_12, var_28_10) + var_0_17
		end
	end

	local var_28_16 = false
	local var_28_17 = var_28_7:get_slot_data("slot_grenade")

	if var_28_17 then
		var_28_16 = var_28_7:get_item_template(var_28_17).can_give_other
	end

	local var_28_18 = false
	local var_28_19 = var_28_7:get_slot_data("slot_potion")

	if var_28_19 then
		var_28_18 = var_28_7:get_item_template(var_28_19).can_give_other
	end

	local var_28_20 = Managers.state.conflict
	local var_28_21 = var_28_20:get_player_unit_segment(arg_28_1) or 1
	local var_28_22 = Managers.state.side.side_by_unit[arg_28_1].PLAYER_AND_BOT_UNITS

	for iter_28_0 = 1, #var_28_22 do
		local var_28_23 = var_28_22[iter_28_0]

		if var_28_23 ~= arg_28_1 and HEALTH_ALIVE[var_28_23] then
			local var_28_24 = ScriptUnit.extension(var_28_23, "status_system")
			local var_28_25 = 0
			local var_28_26 = false

			if not var_28_24:is_ready_for_assisted_respawn() and not var_28_24.near_vortex and var_28_21 <= (var_28_20:get_player_unit_segment(var_28_23) or 1) then
				local var_28_27 = not Managers.player:owner(var_28_23):is_player_controlled()
				local var_28_28 = var_28_27 and 0 or var_0_18
				local var_28_29

				if var_28_24:is_knocked_down() then
					var_28_29 = "knocked_down"
					var_28_25 = 200
				elseif var_28_24:get_is_ledge_hanging() and not var_28_24:is_pulled_up() then
					var_28_29 = "ledge"
					var_28_25 = 200
				elseif var_28_24:is_hanging_from_hook() then
					var_28_29 = "hook"
					var_28_25 = 200
				else
					local var_28_30 = var_28_23 and ScriptUnit.extension(var_28_23, "career_system")
					local var_28_31 = true

					if var_28_30 and var_28_30:career_name() == "wh_zealot" and var_28_24:num_wounds_remaining() > 1 then
						var_28_31 = false
					end

					local var_28_32 = ScriptUnit.extension(var_28_23, "health_system"):current_permanent_health_percent()
					local var_28_33 = ScriptUnit.extension(var_28_23, "buff_system"):has_buff_type("trait_necklace_no_healing_health_regen")
					local var_28_34 = ScriptUnit.extension(var_28_23, "inventory_system")
					local var_28_35 = ScriptUnit.extension(var_28_23, "locomotion_system")
					local var_28_36 = var_28_24:is_wounded()
					local var_28_37 = arg_28_0:_calculate_healing_item_utility(var_28_32, var_28_36, var_28_10) + var_28_28
					local var_28_38 = var_28_11 < var_28_37
					local var_28_39, var_28_40 = arg_28_0:_player_needs_attention(arg_28_1, var_28_23, arg_28_2, var_28_34, var_28_35, arg_28_4)

					if var_28_9 and (var_28_32 < var_0_19 or var_28_36) and var_28_38 and var_28_31 then
						var_28_29 = "in_need_of_heal"
						var_28_25 = 70 + var_28_37 * 15
					elseif var_28_10 and (not var_28_33 or var_28_36) and (var_28_32 < var_0_20 or var_28_36) and not var_28_34:get_slot_data("slot_healthkit") and var_28_38 then
						var_28_29 = "can_accept_heal_item"
						var_28_25 = 70 + var_28_37 * 10
					elseif var_28_16 and (not var_28_34:get_slot_data("slot_grenade") or var_28_34:can_store_additional_item("slot_grenade")) and not var_28_27 then
						var_28_29 = "can_accept_grenade"
						var_28_25 = 70
					elseif var_28_18 and (not var_28_34:get_slot_data("slot_potion") or var_28_34:can_store_additional_item("slot_potion")) and not var_28_27 then
						var_28_29 = "can_accept_potion"
						var_28_25 = 70
					elseif var_28_39 == "stop" then
						var_28_29 = "in_need_of_attention_stop"
						var_28_26 = true
						var_28_25 = 5 + var_28_40
					elseif var_28_39 == "look_at" then
						var_28_29 = "in_need_of_attention_look"
						var_28_26 = true
						var_28_25 = 2 + var_28_40
					end
				end

				if var_28_29 or not var_28_27 then
					local var_28_41 = POSITION_LOOKUP[var_28_23]
					local var_28_42, var_28_43 = arg_28_0:_ally_path_allowed(arg_28_1, var_28_23, arg_28_4)

					if var_28_42 then
						if not var_28_43 then
							var_28_29 = nil
						elseif var_28_29 then
							local var_28_44 = var_28_20:alive_bosses()
							local var_28_45 = #var_28_44

							for iter_28_1 = 1, var_28_45 do
								local var_28_46 = var_28_44[iter_28_1]
								local var_28_47 = POSITION_LOOKUP[var_28_46]
								local var_28_48 = Vector3.distance_squared(var_28_0, var_28_47)
								local var_28_49 = var_0_1[var_28_46]

								if (var_28_49.override_target_unit or var_28_49.target_unit) == arg_28_1 and var_28_48 < 10 then
									var_28_29 = nil
									var_28_25 = 0

									break
								end
							end
						end

						if not var_28_27 then
							var_28_25 = var_28_25 * 1.5
						end

						if var_28_29 or not var_28_27 then
							local var_28_50 = Vector3.distance(var_28_0, var_28_41)
							local var_28_51 = var_28_50 - var_28_25

							if var_28_51 < var_28_2 then
								var_28_2 = var_28_51
								var_28_3 = var_28_50
								var_28_1 = var_28_23
								var_28_4 = var_28_29
								var_28_5 = var_28_26
							end
						end
					end
				end
			end
		end
	end

	return var_28_1, var_28_3, var_28_4, var_28_5
end

PlayerBotBase.within_aid_range = function (arg_29_0, arg_29_1)
	if arg_29_1.target_ally_needs_aid then
		local var_29_0 = POSITION_LOOKUP[arg_29_0._unit]
		local var_29_1 = POSITION_LOOKUP[arg_29_1.target_ally_unit]

		if Vector3.distance_squared(var_29_0, var_29_1) <= var_0_2^2 then
			return true
		end
	end

	return false
end

PlayerBotBase._update_liquid_escape = function (arg_30_0)
	local var_30_0 = arg_30_0._unit
	local var_30_1 = arg_30_0._blackboard
	local var_30_2 = arg_30_0._status_extension
	local var_30_3 = var_30_2:is_in_liquid()
	local var_30_4 = var_30_1.use_liquid_escape_destination
	local var_30_5 = var_30_1.navigation_extension
	local var_30_6 = var_30_2:is_disabled()

	if var_30_3 and not var_30_6 and (not var_30_4 or var_30_5:destination_reached()) then
		local var_30_7 = var_30_2.in_liquid_unit
		local var_30_8, var_30_9 = ScriptUnit.extension(var_30_7, "area_damage_system"):get_rim_nodes()
		local var_30_10 = POSITION_LOOKUP[var_30_0]
		local var_30_11 = math.huge
		local var_30_12

		if var_30_9 then
			local var_30_13 = #var_30_8

			for iter_30_0 = 1, var_30_13 do
				local var_30_14 = var_30_8[iter_30_0]:unbox()
				local var_30_15 = Vector3.distance_squared(var_30_10, var_30_14)

				if var_30_15 < var_30_11 then
					var_30_12 = var_30_14
					var_30_11 = var_30_15
				end
			end
		else
			for iter_30_1, iter_30_2 in pairs(var_30_8) do
				local var_30_16 = iter_30_2.position:unbox()
				local var_30_17 = Vector3.distance_squared(var_30_10, var_30_16)

				if var_30_17 < var_30_11 then
					var_30_12 = var_30_16
					var_30_11 = var_30_17
				end
			end
		end

		if var_30_12 then
			var_30_1.navigation_liquid_escape_destination_override:store(var_30_12)

			var_30_1.use_liquid_escape_destination = true
		end
	elseif var_30_4 and (var_30_6 or not var_30_3) then
		var_30_1.use_liquid_escape_destination = false
	end
end

PlayerBotBase._should_re_evaluate_vortex_escape = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	local var_31_0 = false
	local var_31_1

	if ALIVE[arg_31_4] then
		var_31_1 = not ScriptUnit.extension(arg_31_4, "ai_supplementary_system"):is_position_inside(arg_31_1, var_0_22)
	else
		var_31_1 = true
	end

	if not var_31_1 then
		local var_31_2 = Vector3.distance_squared(arg_31_2, arg_31_1)
		local var_31_3 = arg_31_3:destination_reached()

		var_31_0 = var_31_2 >= var_0_24 or var_31_3 and var_31_2 >= var_0_25
	end

	return var_31_0, var_31_1
end

PlayerBotBase._find_vortex_escape_destination = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	local var_32_0
	local var_32_1
	local var_32_2 = arg_32_0._vortex_escape_directions
	local var_32_3 = #var_32_2

	for iter_32_0 = 1, var_32_3 do
		local var_32_4 = var_32_2[iter_32_0]
		local var_32_5 = var_32_4.weight
		local var_32_6 = var_32_5^2
		local var_32_7 = Quaternion.rotate(arg_32_2, var_32_4.direction:unbox())
		local var_32_8, var_32_9 = GwNavQueries.raycast(arg_32_3, arg_32_1, arg_32_1 + var_32_7 * var_0_22, arg_32_4)
		local var_32_10 = Vector3.distance_squared(arg_32_1, var_32_9) * var_32_6

		if arg_32_5 < var_32_10 then
			var_32_0 = var_32_5
			arg_32_5 = var_32_10
			var_32_1 = var_32_9

			if arg_32_6 <= var_32_10 + 0.0001 then
				break
			end
		end
	end

	return var_32_1, var_32_0, arg_32_5
end

PlayerBotBase._update_vortex_escape = function (arg_33_0)
	local var_33_0 = arg_33_0._unit
	local var_33_1 = arg_33_0._blackboard
	local var_33_2 = POSITION_LOOKUP[var_33_0]
	local var_33_3 = arg_33_0._status_extension
	local var_33_4 = var_33_3.near_vortex
	local var_33_5 = var_33_1.use_vortex_escape_destination
	local var_33_6 = var_33_1.navigation_extension
	local var_33_7 = var_33_3:is_disabled()
	local var_33_8 = false
	local var_33_9 = false

	if var_33_5 then
		local var_33_10 = var_33_1.vortex_escape_unit
		local var_33_11 = var_33_1.navigation_vortex_escape_previous_evaluation_position:unbox()

		var_33_8, var_33_9 = arg_33_0:_should_re_evaluate_vortex_escape(var_33_2, var_33_11, var_33_6, var_33_10)
	end

	if not var_33_7 and (var_33_8 or var_33_4 and not var_33_5) then
		var_33_1.navigation_vortex_escape_previous_evaluation_position:store(var_33_2)

		local var_33_12 = arg_33_0._locomotion_extension
		local var_33_13 = var_33_1.nav_world

		if var_33_12:is_on_ground() and GwNavQueries.triangle_from_position(var_33_13, var_33_2, 0.25, 0.25) then
			local var_33_14 = -math.huge
			local var_33_15 = arg_33_0._vortex_largest_weighted_distance_sq

			if var_33_8 then
				local var_33_16 = var_33_1.navigation_vortex_escape_destination_override:unbox()
				local var_33_17 = (var_33_1.navigation_vortex_escape_weight + var_0_23)^2

				var_33_14 = Vector3.distance_squared(var_33_2, var_33_16) * var_33_17

				if var_33_15 <= var_33_14 then
					return
				end
			end

			local var_33_18 = var_33_3.near_vortex_unit or var_33_1.vortex_escape_unit
			local var_33_19 = var_33_2 - POSITION_LOOKUP[var_33_18]
			local var_33_20 = Quaternion.look(var_33_19, Vector3.up())
			local var_33_21 = var_33_6:traverse_logic()
			local var_33_22, var_33_23, var_33_24 = arg_33_0:_find_vortex_escape_destination(var_33_2, var_33_20, var_33_13, var_33_21, var_33_14, var_33_15)

			if var_33_22 then
				var_33_1.use_vortex_escape_destination = true

				var_33_1.navigation_vortex_escape_destination_override:store(var_33_22)

				var_33_1.navigation_vortex_escape_weight = var_33_23
				var_33_1.vortex_escape_unit = var_33_18
			end
		end
	elseif var_33_5 and (var_33_7 or var_33_9 or not var_33_4 and var_33_6:destination_reached()) then
		var_33_1.use_vortex_escape_destination = false
		var_33_1.vortex_escape_unit = nil
	end
end

PlayerBotBase._update_attack_request = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._blackboard
	local var_34_1 = AiUtils.get_bot_weapon_extension(var_34_0)

	if var_34_1 then
		var_34_1:update_bot_attack_request(arg_34_1)
	end
end

PlayerBotBase._update_pickups = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0._unit
	local var_35_1 = arg_35_0._blackboard

	var_35_1.needs_ammo = false
	var_35_1.has_ammo_missing = false

	local var_35_2 = var_35_1.priority_target_enemy or var_35_1.target_unit
	local var_35_3 = ALIVE[var_35_2] and 0.1 or 0.9
	local var_35_4, var_35_5 = var_35_1.inventory_extension:current_ammo_status("slot_ranged")

	if var_35_4 and var_35_4 < var_35_5 then
		var_35_1.needs_ammo = Managers.state.entity:system("ai_bot_group_system"):get_ammo_pickup_order_unit(var_35_0) ~= nil or var_35_3 > var_35_4 / var_35_5
		var_35_1.has_ammo_missing = var_35_4 ~= var_35_5
	end
end

local var_0_37 = {}

PlayerBotBase._update_interactables = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0._blackboard

	if arg_36_2 > arg_36_0._interactable_timer then
		arg_36_0._interactable_timer = arg_36_2 + 0.2 + Math.random() * 0.15

		if var_36_0.interaction_unit and ScriptUnit.has_extension(var_36_0.interaction_unit, "door_system") and var_36_0.interaction_unit ~= var_36_0.target_ally_unit then
			var_36_0.interaction_unit = nil
			var_36_0.interaction_type = nil
		end

		if var_36_0.navigation_extension:destination_reached() then
			return
		end

		local var_36_1 = POSITION_LOOKUP[arg_36_0._unit]
		local var_36_2 = Managers.state.entity:system("door_system"):get_doors(var_36_1, 1.5, var_0_37)
		local var_36_3
		local var_36_4 = math.huge
		local var_36_5

		for iter_36_0 = 1, var_36_2 do
			local var_36_6 = var_0_37[iter_36_0]

			if ScriptUnit.has_extension(var_36_6, "interactable_system") and not ScriptUnit.extension(var_36_6, "door_system"):is_open() then
				local var_36_7 = POSITION_LOOKUP[var_36_6] or Unit.world_position(var_36_6, 0)
				local var_36_8 = Vector3.distance_squared(var_36_1, var_36_7)

				if var_36_8 < var_36_4 then
					var_36_4 = var_36_8
					var_36_3 = var_36_6
					var_36_5 = "door"
				end
			end
		end

		if var_36_3 then
			var_36_0.interaction_unit = var_36_3
			var_36_0.interaction_type = var_36_5
		end
	elseif var_0_0(var_36_0.interaction_unit) then
		local var_36_9 = ScriptUnit.has_extension(var_36_0.interaction_unit, "door_system")

		if var_36_9 and var_36_9:is_open() then
			var_36_0.interaction_unit = nil
			var_36_0.interaction_type = nil
		end
	elseif var_36_0.interaction_unit then
		var_36_0.interaction_unit = nil
		var_36_0.interaction_type = nil
	end
end

local var_0_38 = {}

PlayerBotBase._find_cover = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	local var_37_0 = Vector3.zero()

	for iter_37_0, iter_37_1 in pairs(arg_37_1) do
		local var_37_1 = POSITION_LOOKUP[iter_37_0]

		var_0_38[#var_0_38 + 1] = var_37_1

		local var_37_2 = Vector3.flat(arg_37_2 - var_37_1)

		var_37_0 = var_37_0 + Vector3.normalize(var_37_2)
		arg_37_4 = math.min(arg_37_4, 0.5 * Vector3.length(var_37_2))
	end

	local var_37_3 = arg_37_2 + (arg_37_3 - arg_37_4) * var_37_0
	local var_37_4, var_37_5 = ConflictUtils.hidden_cover_points(var_37_3, var_0_38, 0, arg_37_3, -0.9)

	table.clear(var_0_38)

	return var_37_4, var_37_5
end

local var_0_39 = {}

local function var_0_40(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	local var_38_0 = arg_38_2 - arg_38_0
	local var_38_1 = Vector3.normalize(arg_38_1 - arg_38_0)
	local var_38_2 = Vector3.dot(var_38_0, var_38_1)

	if var_38_2 <= 0 or arg_38_4 < var_38_2 then
		return false
	end

	if Vector3.length(var_38_0 - var_38_2 * var_38_1) > math.min(var_38_2, arg_38_3) then
		return false
	else
		return true
	end
end

PlayerBotBase._in_line_of_fire = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	local var_39_0 = false
	local var_39_1 = false
	local var_39_2 = 2.5
	local var_39_3 = 6
	local var_39_4 = 40

	for iter_39_0, iter_39_1 in pairs(arg_39_3) do
		local var_39_5 = arg_39_4[iter_39_0]

		if ALIVE[iter_39_1] and (iter_39_1 == arg_39_1 or var_0_40(POSITION_LOOKUP[iter_39_0], POSITION_LOOKUP[iter_39_1], arg_39_2, var_39_5 and var_39_3 or var_39_2, var_39_4)) then
			var_0_39[iter_39_0] = iter_39_1
			var_39_0 = var_39_0 or not var_39_5
			var_39_1 = true
		end
	end

	for iter_39_2, iter_39_3 in pairs(arg_39_4) do
		if not var_0_39[iter_39_2] then
			var_39_0 = true

			break
		end
	end

	table.clear(arg_39_4)

	for iter_39_4, iter_39_5 in pairs(var_0_39) do
		arg_39_4[iter_39_4] = iter_39_5
	end

	table.clear(var_0_39)

	return var_39_1, var_39_0
end

function to_hash(arg_40_0)
	return arg_40_0.x + arg_40_0.y * 10000 + arg_40_0.z * 0.0001
end

PlayerBotBase.cb_cover_point_path_result = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if not arg_41_2 then
		local var_41_0 = arg_41_0._blackboard.taking_cover

		var_41_0.failed_cover_points[arg_41_1] = true

		table.clear(var_41_0.active_threats)
	end
end

PlayerBotBase._update_cover = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	local var_42_0
	local var_42_1, var_42_2 = arg_42_0:_in_line_of_fire(arg_42_1, arg_42_2, arg_42_4.threats, arg_42_4.active_threats)
	local var_42_3 = Managers.state.entity:system("ai_bot_group_system")

	if var_42_1 and var_42_2 then
		local var_42_4 = arg_42_4.fails
		local var_42_5 = math.min(5 + var_42_4 * 5, 40)
		local var_42_6 = var_42_5 * 0.4
		local var_42_7, var_42_8 = arg_42_0:_find_cover(arg_42_4.active_threats, arg_42_2, var_42_5, var_42_6)
		local var_42_9
		local var_42_10
		local var_42_11
		local var_42_12

		for iter_42_0 = 1, var_42_7 do
			local var_42_13 = var_42_8[iter_42_0]
			local var_42_14 = Unit.local_position(var_42_13, 0)

			if not arg_42_4.failed_cover_points[to_hash(var_42_14)] then
				if var_42_3:in_cover(var_42_13) then
					var_42_12 = var_42_12 or var_42_14
					var_42_11 = var_42_11 or var_42_13
				else
					var_42_9 = var_42_14
					var_42_10 = var_42_13

					break
				end
			end
		end

		var_42_9 = var_42_9 or var_42_12
		var_42_10 = var_42_10 or var_42_11

		if var_42_9 then
			var_42_0 = var_42_9

			arg_42_4.cover_position:store(var_42_0)

			arg_42_4.cover_unit = var_42_10
			arg_42_4.fails = 0

			var_42_3:set_in_cover(arg_42_1, var_42_10)
		else
			arg_42_4.fails = arg_42_4.fails + 1

			table.clear(arg_42_4.active_threats)
		end
	elseif not var_42_1 and var_42_2 then
		arg_42_4.cover_position:store(Vector3.invalid_vector())

		arg_42_4.cover_unit = nil
		arg_42_4.fails = 0
		arg_42_5.needs_target_position_refresh = true

		var_42_3:set_in_cover(arg_42_1, nil)
	elseif var_42_1 then
		var_42_0 = arg_42_4.cover_position:unbox()
	end

	local var_42_15 = arg_42_3.ranged_obstruction_by_static
	local var_42_16 = var_42_15 and var_42_15.unit

	if arg_42_4.active_threats[var_42_16] then
		arg_42_3.ranged_obstruction_by_static = nil
	end

	return var_42_0
end

PlayerBotBase.new_destination_distance_check = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	local var_43_0 = arg_43_3 - arg_43_2
	local var_43_1 = math.abs(var_43_0.z) > var_0_15 or Vector3.length_squared(Vector3.flat(var_43_0)) > var_0_13

	if arg_43_4:destination_reached() then
		local var_43_2 = arg_43_1 - arg_43_4:position_when_destination_reached()
		local var_43_3 = math.abs(var_43_2.z) > var_0_15 or Vector3.length_squared(Vector3.flat(var_43_2)) > var_0_14
		local var_43_4 = arg_43_3 - arg_43_1
		local var_43_5 = math.abs(var_43_4.z) > var_0_15 or Vector3.length_squared(Vector3.flat(var_43_4)) > var_0_13

		return (var_43_3 or var_43_1) and var_43_5
	else
		return var_43_1
	end
end

local var_0_41 = 15
local var_0_42 = 2

PlayerBotBase._update_movement_target = function (arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_0._unit
	local var_44_1 = POSITION_LOOKUP[var_44_0]
	local var_44_2 = arg_44_0._blackboard
	local var_44_3 = var_44_2.input_extension:avoiding_aoe_threat()
	local var_44_4 = var_44_2.navigation_destination_override
	local var_44_5 = var_44_2.melee and var_44_2.melee.engage_position_set and var_44_4:unbox()
	local var_44_6 = var_44_2.shoot and var_44_2.shoot.disengage_position_set and var_44_4:unbox()
	local var_44_7 = var_44_2.activate_ability_data and var_44_2.activate_ability_data.move_to_position_set and var_44_4:unbox()
	local var_44_8 = var_44_2.use_liquid_escape_destination and var_44_2.navigation_liquid_escape_destination_override:unbox()
	local var_44_9 = var_44_2.use_vortex_escape_destination and var_44_2.navigation_vortex_escape_destination_override:unbox()
	local var_44_10 = false
	local var_44_11 = var_44_2.follow
	local var_44_12 = var_44_2.taking_cover
	local var_44_13 = arg_44_0:_update_cover(var_44_0, var_44_1, var_44_2, var_44_12, var_44_11)
	local var_44_14
	local var_44_15 = arg_44_0._nav_world
	local var_44_16 = var_44_2.target_ally_unit
	local var_44_17 = var_44_2.target_ally_need_type
	local var_44_18 = true

	if ALIVE[var_44_16] then
		local var_44_19 = ScriptUnit.extension(var_44_16, "status_system"):get_inside_transport_unit()

		if var_0_0(var_44_19) and not var_44_2.target_ally_needs_aid then
			var_44_2.ally_inside_transport_unit = var_44_19

			if ScriptUnit.extension(var_44_2.ally_inside_transport_unit, "transportation_system").story_state == "stopped_beginning" then
				var_44_14 = LocomotionUtils.new_goal_in_transport(var_44_15, var_44_0, var_44_16)
			end
		elseif var_44_2.ally_inside_transport_unit then
			var_44_2.ally_inside_transport_unit = nil
		elseif not var_44_17 or var_44_17 == "in_need_of_attention_stop" or var_44_17 == "in_need_of_attention_look" then
			var_44_18 = ScriptUnit.extension(var_44_16, "locomotion_system").has_moved_from_start_position
		end
	else
		var_44_2.ally_inside_transport_unit = nil
	end

	local var_44_20 = var_44_2.navigation_extension
	local var_44_21 = var_44_20:destination()
	local var_44_22 = var_44_2.ai_bot_group_extension
	local var_44_23, var_44_24 = var_44_22:get_hold_position()
	local var_44_25 = var_44_23 and var_44_23 - var_44_21
	local var_44_26 = var_44_25 and math.abs(var_44_25.z)
	local var_44_27 = var_44_25 and Vector3.length_squared(Vector3.flat(var_44_25))
	local var_44_28 = var_44_25 and (var_44_26 > var_0_16 or var_44_24 < var_44_27)
	local var_44_29 = not var_44_9 and var_44_2.vortex_exist and not var_44_20:is_path_safe_from_vortex(var_0_41, var_0_42)

	if var_44_28 then
		var_44_20:move_to(var_44_23)

		var_44_2.using_navigation_destination_override = true
	elseif var_44_29 then
		local var_44_30 = var_44_20:path_callback()

		if var_44_30 then
			var_44_30(false, var_44_21, true)
		end

		var_44_20:stop()

		if var_44_5 then
			var_44_2.melee.engage_position_set = false
		end

		if var_44_6 then
			var_44_2.shoot.disengage_position_set = false
		end

		if var_44_7 then
			var_44_2.activate_ability_data.move_to_position_set = false
		end
	elseif not var_44_3 and (var_44_9 or var_44_8 or var_44_13 or var_44_5 or var_44_6 or var_44_7) then
		local var_44_31 = var_44_14 or var_44_9 or var_44_8 or var_44_13 or var_44_5 or var_44_6 or var_44_7
		local var_44_32 = var_44_31 - var_44_21

		if (var_44_23 == nil or var_44_24 >= Vector3.distance_squared(var_44_23, var_44_31)) and (math.abs(var_44_32.z) > var_0_15 or Vector3.length(Vector3.flat(var_44_32)) > var_0_12) then
			if var_44_5 and var_44_2.melee.stop_at_current_position or var_44_6 and var_44_2.shoot.stop_at_current_position then
				var_44_20:stop()
			else
				local var_44_33 = not var_44_14 and var_44_13 and callback(arg_44_0, "cb_cover_point_path_result", to_hash(var_44_31)) or nil

				var_44_20:move_to(var_44_31, var_44_33)
			end

			var_44_2.using_navigation_destination_override = true
		end
	else
		var_44_11.follow_timer = var_44_11.follow_timer - arg_44_1

		local var_44_34 = var_44_2.interaction_extension:is_interacting()
		local var_44_35 = var_44_17 == "in_need_of_attention_stop"

		if not var_44_11.needs_target_position_refresh and (var_44_11.follow_timer < 0 or var_44_35 or var_44_2.target_ally_needs_aid and not var_44_34 and var_44_20:destination_reached()) then
			var_44_11.needs_target_position_refresh = true
		end

		local var_44_36 = Managers.state.entity:system("ai_bot_group_system")
		local var_44_37 = var_44_36:get_ammo_pickup_order_unit(var_44_0) ~= nil or var_44_36:has_pending_pickup_order(var_44_0)

		if var_44_11.needs_target_position_refresh and (var_44_18 or var_44_37) then
			local var_44_38
			local var_44_39
			local var_44_40 = var_44_2.follow.goal_selection_func
			local var_44_41
			local var_44_42 = var_44_2.target_unit
			local var_44_43 = var_44_2.priority_target_enemy
			local var_44_44 = var_44_36:get_pickup_order(var_44_0, "slot_healthkit")
			local var_44_45 = var_44_44 and var_44_44.unit or nil
			local var_44_46 = var_44_36:get_pickup_order(var_44_0, "slot_potion")
			local var_44_47 = var_44_46 and var_44_46.unit or nil

			if var_44_2.revive_with_urgent_target and var_44_2.target_ally_needs_aid and var_44_17 ~= "in_need_of_attention_look" then
				var_44_38, var_44_39 = arg_44_0:_alter_target_position(var_44_15, var_44_1, var_44_16, POSITION_LOOKUP[var_44_16], var_44_17)
				var_44_2.interaction_unit = var_44_16

				var_44_2.target_ally_aid_destination:store(var_44_38)

				var_44_41 = callback(arg_44_0, "cb_ally_path_result", var_44_16)
			elseif var_44_43 and var_44_42 ~= var_44_43 and arg_44_0:_enemy_path_allowed(var_44_43) then
				var_44_38 = arg_44_0:_find_target_position_on_nav_mesh(var_44_15, POSITION_LOOKUP[var_44_43])
				var_44_41 = callback(arg_44_0, "cb_enemy_path_result", var_44_43)
			elseif var_44_42 and (var_44_42 == var_44_43 or var_44_42 == var_44_2.urgent_target_enemy) and arg_44_0:_enemy_path_allowed(var_44_42) and not var_44_2.input_extension:avoiding_aoe_threat() then
				var_44_38 = arg_44_0:_find_target_position_on_nav_mesh(var_44_15, POSITION_LOOKUP[var_44_42])
				var_44_41 = callback(arg_44_0, "cb_enemy_path_result", var_44_42)
			elseif var_44_2.target_ally_needs_aid and var_44_17 ~= "in_need_of_attention_look" then
				var_44_38, var_44_39 = arg_44_0:_alter_target_position(var_44_15, var_44_1, var_44_16, POSITION_LOOKUP[var_44_16], var_44_17)
				var_44_2.interaction_unit = var_44_16

				var_44_2.target_ally_aid_destination:store(var_44_38)

				var_44_41 = callback(arg_44_0, "cb_ally_path_result", var_44_16)
			elseif var_44_40 and ALIVE[var_44_16] then
				var_44_38 = LocomotionUtils[var_44_40](var_44_15, var_44_0, var_44_16)
			elseif var_0_0(var_44_2.health_pickup) and var_44_2.allowed_to_take_health_pickup and arg_44_2 < var_44_2.health_pickup_valid_until and (arg_44_0._last_health_pickup_attempt.unit ~= var_44_2.health_pickup or not arg_44_0._last_health_pickup_attempt.blacklist or var_44_45 == var_44_2.health_pickup) then
				local var_44_48 = var_44_2.health_pickup

				var_44_38 = arg_44_0:_find_pickup_position_on_navmesh(var_44_15, var_44_1, var_44_48, arg_44_0._last_health_pickup_attempt)

				local var_44_49 = var_44_48 == var_44_45

				if var_44_38 then
					var_44_41 = callback(arg_44_0, "cb_health_pickup_path_result", var_44_48)
					var_44_2.interaction_unit = var_44_48
				elseif var_44_49 then
					var_44_2.interaction_unit = var_44_48
					var_44_2.forced_pickup_unit = var_44_48
				end
			elseif var_0_0(var_44_2.mule_pickup) and (arg_44_0._last_mule_pickup_attempt.unit ~= var_44_2.mule_pickup or not arg_44_0._last_mule_pickup_attempt.blacklist or var_44_47 == var_44_2.mule_pickup) then
				local var_44_50 = var_44_2.mule_pickup

				var_44_38 = arg_44_0:_find_pickup_position_on_navmesh(var_44_15, var_44_1, var_44_50, arg_44_0._last_mule_pickup_attempt)

				local var_44_51 = var_44_50 == var_44_47

				if var_44_38 then
					var_44_41 = callback(arg_44_0, "cb_mule_pickup_path_result", var_44_50)
					var_44_2.interaction_unit = var_44_50
				elseif var_44_51 then
					var_44_2.interaction_unit = var_44_50
					var_44_2.forced_pickup_unit = var_44_50
				end
			end

			if not var_44_38 and var_0_0(var_44_2.ammo_pickup) and var_44_2.has_ammo_missing and arg_44_2 < var_44_2.ammo_pickup_valid_until then
				local var_44_52 = POSITION_LOOKUP[var_44_2.ammo_pickup]
				local var_44_53 = Vector3.normalize(var_44_1 - var_44_52)
				local var_44_54 = 0.5
				local var_44_55 = 1.5
				local var_44_56 = INTERACT_RAY_DISTANCE - 0.3
				local var_44_57 = 0

				var_44_38 = arg_44_0:_find_position_on_navmesh(var_44_15, var_44_52, var_44_52 + var_44_53, var_44_54, var_44_55, var_44_56, var_44_57)

				if var_44_38 then
					var_44_2.interaction_unit = var_44_2.ammo_pickup
				end
			end

			if var_44_23 and var_44_38 and var_44_24 < Vector3.distance_squared(var_44_23, var_44_38) then
				var_44_38 = nil
			end

			if not var_44_38 and not var_44_3 then
				var_44_38 = var_44_22.data.follow_position
				var_44_10 = true
			end

			if var_44_39 then
				var_44_20:stop()
			elseif var_44_38 then
				var_44_2.moving_toward_follow_position = var_44_10
				var_44_11.needs_target_position_refresh = false
				var_44_11.follow_timer = math.lerp(var_0_7, var_0_8, Math.random())

				var_44_11.target_position:store(var_44_38)

				if arg_44_0:new_destination_distance_check(var_44_1, var_44_21, var_44_38, var_44_20) then
					var_44_20:move_to(var_44_38, var_44_41)
				end

				var_44_2.using_navigation_destination_override = false
			end
		end

		if var_44_2.using_navigation_destination_override then
			var_44_20:move_to(var_44_11.target_position:unbox())

			var_44_2.using_navigation_destination_override = false
		end

		local var_44_58 = var_44_20:current_goal()
		local var_44_59 = Managers.state.entity:system("area_damage_system")

		if var_44_58 and var_44_59:is_position_in_liquid(var_44_58, BotNavTransitionManager.NAV_COST_MAP_LAYERS) then
			var_44_20:stop()
		end
	end
end

local var_0_43 = {
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
	local var_45_0 = 1.5
	local var_45_1 = 2.2
	local var_45_2 = 0.1
	local var_45_3 = INTERACT_RAY_DISTANCE - 0.3
	local var_45_4 = #var_0_43
	local var_45_5 = POSITION_LOOKUP[arg_45_3]

	if arg_45_4.unit ~= arg_45_3 then
		arg_45_4.unit = arg_45_3
		arg_45_4.index = 1
		arg_45_4.distance = 0
		arg_45_4.path_failed = true

		arg_45_4.rotation:store(Quaternion.look(Vector3.flat(arg_45_2 - var_45_5), Vector3.up()))

		arg_45_4.blacklist = false
	end

	if arg_45_4.path_failed then
		local var_45_6 = arg_45_4.index
		local var_45_7 = arg_45_4.rotation:unbox()
		local var_45_8 = arg_45_4.distance
		local var_45_9

		while var_45_6 <= var_45_4 and not var_45_9 do
			local var_45_10 = Quaternion.multiply(var_0_43[var_45_6]:unbox(), var_45_7)
			local var_45_11 = Quaternion.forward(var_45_10)

			var_45_8 = math.min(var_45_8 + var_45_2, 1)

			local var_45_12 = var_45_5 + var_45_11 * (var_45_8 * var_45_3)
			local var_45_13, var_45_14 = GwNavQueries.triangle_from_position(arg_45_1, var_45_12, var_45_0, var_45_1)

			if var_45_13 then
				var_45_12.z = var_45_14

				if var_45_8 >= 0.8 then
					var_45_9 = var_45_12
				else
					local var_45_15 = var_45_12 + (1 - var_45_8) * var_45_11 * var_45_3
					local var_45_16, var_45_17 = GwNavQueries.raycast(arg_45_1, var_45_12, var_45_15)

					if var_45_16 then
						var_45_9 = var_45_15
						var_45_8 = 1
					else
						var_45_9 = 0.1 * var_45_12 + var_45_17 * 0.9
						var_45_8 = Vector3.dot(Vector3.flat(var_45_9 - var_45_5), var_45_11)
					end
				end
			end

			if var_45_8 >= 1 - var_0_12 then
				var_45_6 = var_45_6 + 1
				var_45_8 = 0
			end
		end

		arg_45_4.distance = var_45_8
		arg_45_4.index = var_45_6

		if var_45_9 then
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
	local var_46_0, var_46_1 = GwNavQueries.triangle_from_position(arg_46_1, arg_46_3, arg_46_4, arg_46_5)

	if var_46_0 then
		return Vector3(arg_46_3.x, arg_46_3.y, var_46_1)
	else
		local var_46_2, var_46_3 = GwNavQueries.triangle_from_position(arg_46_1, arg_46_2, arg_46_4, arg_46_5)
		local var_46_4 = var_46_3

		if var_46_2 then
			return Vector3(arg_46_3.x, arg_46_3.y, var_46_4)
		else
			return GwNavQueries.inside_position_from_outside_position(arg_46_1, arg_46_2, arg_46_4, arg_46_5, arg_46_6, arg_46_7)
		end
	end
end

PlayerBotBase.unit_removed_from_game = function (arg_47_0)
	return
end

PlayerBotBase.destroy = function (arg_48_0)
	arg_48_0._brain:destroy()

	if arg_48_0._blackboard.taking_cover.cover_unit then
		Managers.state.entity:system("ai_bot_group_system"):set_in_cover(arg_48_0._unit, nil)
	end
end

PlayerBotBase._debug_draw_update = function (arg_49_0, arg_49_1)
	if script_data.debug_behaviour_trees then
		arg_49_0._brain:debug_draw_behaviours()
	end

	local var_49_0 = "bot_debug" .. arg_49_0._player.player_name
	local var_49_1 = Managers.state.debug:drawer({
		mode = "immediate",
		name = var_49_0
	})
	local var_49_2 = Unit.local_position(arg_49_0._unit, 0) + Vector3.up() * 2
	local var_49_3 = arg_49_0._player.color:unbox()

	var_49_1:sphere(var_49_2, 0.25, var_49_3)

	local var_49_4 = arg_49_0._blackboard
	local var_49_5 = var_49_4.target_unit
	local var_49_6 = var_49_4.target_ally_unit
	local var_49_7 = arg_49_0._player:local_player_id() * 0.05

	if ALIVE[var_49_5] then
		local var_49_8 = Unit.world_pose(var_49_5, 0)
		local var_49_9 = 1.5 + var_49_7

		Matrix4x4.set_translation(var_49_8, POSITION_LOOKUP[var_49_5] + Vector3.up() * var_49_9)
		var_49_1:line(var_49_2, Unit.world_position(var_49_5, 0) + Vector3(0, 0, 1.5), Color(125, 255, 0, 0))
		var_49_1:box(var_49_8, Vector3(0.5 + var_49_7, 0.5 + var_49_7, var_49_9), var_49_3)
	end

	if ALIVE[var_49_6] then
		var_49_1:circle(POSITION_LOOKUP[var_49_6] + Vector3(0, 0, 0.2), 0.6 + var_49_7, Vector3.up(), var_49_3, 16)
	end

	arg_49_0._brain:debug_draw_current_behavior()
end

PlayerBotBase.clear_failed_paths = function (arg_50_0)
	table.clear(arg_50_0._attempted_ally_paths)
	table.clear(arg_50_0._attempted_enemy_paths)
end

PlayerBotBase.cb_enemy_path_result = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
	if arg_51_4 then
		return
	end

	local var_51_0 = arg_51_0._attempted_enemy_paths
	local var_51_1 = var_51_0[arg_51_1]

	if not var_51_1 then
		var_51_1 = {
			last_path_destination = Vector3Box()
		}
		var_51_0[arg_51_1] = var_51_1
	end

	local var_51_2 = not arg_51_2

	if var_51_2 then
		arg_51_0._blackboard.follow.needs_target_position_refresh = true
	end

	var_51_1.failed = var_51_2

	var_51_1.last_path_destination:store(arg_51_3)

	for iter_51_0, iter_51_1 in pairs(var_51_0) do
		if not var_0_0(iter_51_0) then
			var_51_0[iter_51_0] = nil
		end
	end
end

PlayerBotBase._enemy_path_allowed = function (arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0._attempted_enemy_paths[arg_52_1]
	local var_52_1 = POSITION_LOOKUP[arg_52_1]

	if var_52_0 and var_52_0.failed and Vector3.distance_squared(var_52_1, var_52_0.last_path_destination:unbox()) < var_0_9 and math.abs(var_52_1.z - var_52_0.last_path_destination:unbox().z) < var_0_10 then
		return false
	end

	return true
end

PlayerBotBase.cb_health_pickup_path_result = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	if arg_53_4 then
		return
	end

	if arg_53_1 == arg_53_0._last_health_pickup_attempt.unit then
		arg_53_0._last_health_pickup_attempt.path_failed = not arg_53_2
	end
end

PlayerBotBase.cb_mule_pickup_path_result = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	if arg_54_4 then
		return
	end

	if arg_54_1 == arg_54_0._last_mule_pickup_attempt.unit then
		arg_54_0._last_mule_pickup_attempt.path_failed = not arg_54_2
	end
end

PlayerBotBase.cb_ally_path_result = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	local var_55_0 = arg_55_0._attempted_ally_paths
	local var_55_1 = var_55_0[arg_55_1]

	if not var_55_1 then
		var_55_1 = {
			last_path_destination = Vector3Box()
		}
		var_55_0[arg_55_1] = var_55_1
	end

	local var_55_2 = not arg_55_2

	var_55_1.failed = var_55_2

	var_55_1.last_path_destination:store(arg_55_3)

	var_55_1.forced_callback = arg_55_4

	if var_55_2 then
		var_55_1.ignore_ally_from = Managers.time:time("game")
	else
		var_55_1.ignore_ally_from = -math.huge
	end

	for iter_55_0, iter_55_1 in pairs(var_55_0) do
		if not var_0_0(iter_55_0) then
			var_55_0[iter_55_0] = nil
		end
	end
end

local var_0_44 = 25
local var_0_45 = 225
local var_0_46 = 3
local var_0_47 = 12

PlayerBotBase._ally_path_allowed = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = arg_56_0._attempted_ally_paths[arg_56_2]

	if var_56_0 and var_56_0.failed then
		local var_56_1 = POSITION_LOOKUP[arg_56_1]
		local var_56_2 = POSITION_LOOKUP[arg_56_2]
		local var_56_3 = Vector3.distance_squared(var_56_1, var_56_2)
		local var_56_4 = math.inv_lerp_clamped(var_0_44, var_0_45, var_56_3)
		local var_56_5 = math.lerp(var_0_46, var_0_47, var_56_4)

		if arg_56_3 > var_56_0.ignore_ally_from + var_56_5 then
			return true, true
		end

		local var_56_6 = Managers.state.conflict
		local var_56_7 = var_56_6:get_player_unit_segment(arg_56_0._unit) or -1
		local var_56_8 = var_56_6:get_player_unit_segment(arg_56_2) or -1
		local var_56_9
		local var_56_10 = var_56_7 < var_56_8 and 1 or var_56_8 < var_56_7 and 10 or 5

		if arg_56_3 > var_56_0.ignore_ally_from + var_56_10 then
			local var_56_11 = var_56_0.last_path_destination:unbox()
			local var_56_12 = Vector3.distance_squared(var_56_2, var_56_11) > var_0_11
			local var_56_13 = var_56_0.forced_callback

			return true, var_56_12 or var_56_13
		else
			return false, false
		end
	else
		return true, true
	end
end

local function var_0_48(arg_57_0)
	if not arg_57_0 then
		return 1, 0, 1, 0
	end

	local var_57_0 = math.huge
	local var_57_1 = -math.huge
	local var_57_2 = 1
	local var_57_3 = 1

	for iter_57_0 = 1, #arg_57_0 do
		local var_57_4 = arg_57_0[iter_57_0]

		if var_57_4.input and var_57_4.action ~= nil and var_57_4.sub_action ~= nil and string.find(var_57_4.input, "action_one") then
			local var_57_5 = var_57_4.start_time

			if var_57_5 < var_57_0 then
				var_57_0 = var_57_5
				var_57_2 = iter_57_0
			end

			if var_57_1 < var_57_5 then
				var_57_1 = var_57_5
				var_57_3 = iter_57_0
			end
		end
	end

	return var_57_2, var_57_0, var_57_3, var_57_1
end

PlayerBotBase._update_weapon_metadata = function (arg_58_0, arg_58_1)
	local var_58_0 = arg_58_1 and arg_58_1.attack_meta_data

	if var_58_0 and not arg_58_1._precalculated_metadata then
		print("updating bot weapon metadata for weapon:", arg_58_1 and arg_58_1.name)

		local var_58_1 = WeaponUtils.get_used_actions(arg_58_1)

		if var_58_1.action_one then
			local var_58_2 = arg_58_1.actions.action_one
			local var_58_3 = 0
			local var_58_4 = 6
			local var_58_5 = {
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
			local var_58_6 = {
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

			for iter_58_0, iter_58_1 in pairs(var_58_1.action_one) do
				local var_58_7 = var_58_2[iter_58_0]

				if ActionUtils.is_melee_start_sub_action(var_58_7) then
					local var_58_8 = var_58_7.allowed_chain_actions
					local var_58_9 = var_58_7.anim_time_scale or 1
					local var_58_10, var_58_11, var_58_12, var_58_13 = var_0_48(var_58_8)

					var_58_5.total_chain_time = var_58_5.total_chain_time + var_58_11 * var_58_9
					var_58_6.total_chain_time = var_58_6.total_chain_time + var_58_13 * var_58_9

					local var_58_14 = var_58_8[var_58_10].action
					local var_58_15 = var_58_8[var_58_10].sub_action
					local var_58_16 = arg_58_1.actions[var_58_14][var_58_15]
					local var_58_17 = var_58_16.anim_time_scale or 1
					local var_58_18, var_58_19 = var_0_48(var_58_16.allowed_chain_actions)

					var_58_5.total_chain_time = var_58_5.total_chain_time + var_58_19 * var_58_17

					local var_58_20 = ActionUtils.get_performance_scores_for_sub_action(var_58_16)
					local var_58_21 = var_58_8[var_58_12].action
					local var_58_22 = var_58_8[var_58_12].sub_action
					local var_58_23 = arg_58_1.actions[var_58_21][var_58_22]
					local var_58_24 = var_58_23.anim_time_scale or 1
					local var_58_25, var_58_26 = var_0_48(var_58_23.allowed_chain_actions)

					var_58_6.total_chain_time = var_58_6.total_chain_time + var_58_26 * var_58_24

					local var_58_27 = ActionUtils.get_performance_scores_for_sub_action(var_58_23)

					if var_58_20 and var_58_27 then
						for iter_58_2 = 1, var_58_4 do
							var_58_5.armor_mods[iter_58_2] = var_58_5.armor_mods[iter_58_2] + var_58_20[iter_58_2]
							var_58_6.armor_mods[iter_58_2] = var_58_6.armor_mods[iter_58_2] + var_58_27[iter_58_2]
						end

						var_58_3 = var_58_3 + 1
					end
				end
			end

			local var_58_28 = var_58_0.tap_attack

			if var_58_28 then
				for iter_58_3 = 1, #var_58_5.armor_mods do
					var_58_5.armor_mods[iter_58_3] = var_58_5.armor_mods[iter_58_3] / var_58_3
				end

				var_58_28.armor_modifiers = var_58_5.armor_mods
				var_58_28.speed_mod = 1 / math.clamp(var_58_5.total_chain_time / var_58_3, 0.1, 10)
			end

			local var_58_29 = var_58_0.hold_attack

			if var_58_29 then
				for iter_58_4 = 1, #var_58_6.armor_mods do
					var_58_6.armor_mods[iter_58_4] = var_58_6.armor_mods[iter_58_4] / var_58_3
				end

				var_58_29.armor_modifiers = var_58_6.armor_mods
				var_58_29.speed_mod = 1 / math.clamp(var_58_6.total_chain_time / var_58_3, 0.1, 10)
			end
		end

		arg_58_1._precalculated_metadata = true
	end
end

PlayerBotBase._update_weapon_loadout_data = function (arg_59_0, arg_59_1)
	local var_59_0 = arg_59_0._blackboard
	local var_59_1 = var_59_0.inventory_extension
	local var_59_2 = var_59_1:recently_acquired("slot_melee")
	local var_59_3 = var_59_1:recently_acquired("slot_ranged")

	if var_59_2 or var_59_3 or arg_59_1 then
		local var_59_4 = var_59_1:get_slot_data("slot_melee")
		local var_59_5 = var_59_4 and var_59_1:get_item_template(var_59_4)
		local var_59_6 = var_59_5 and var_59_5.buff_type
		local var_59_7 = var_59_1:get_slot_data("slot_ranged")
		local var_59_8 = var_59_7 and var_59_1:get_item_template(var_59_7)
		local var_59_9 = var_59_8 and var_59_8.buff_type

		if MeleeBuffTypes[var_59_6] and MeleeBuffTypes[var_59_9] then
			var_59_0.double_weapons = "slot_melee"
		elseif RangedBuffTypes[var_59_6] and RangedBuffTypes[var_59_9] then
			var_59_0.double_weapons = "slot_ranged"
		else
			var_59_0.double_weapons = nil
		end

		arg_59_0:_update_weapon_metadata(var_59_5)
		arg_59_0:_update_weapon_metadata(var_59_8)
	end
end

PlayerBotBase._update_best_weapon = function (arg_60_0)
	local var_60_0 = arg_60_0._blackboard

	if not var_60_0.double_weapons then
		return
	end

	local var_60_1 = AiUtils.get_combat_conditions(var_60_0)
	local var_60_2 = var_60_0.weapon_scores or {}
	local var_60_3 = var_60_2.slot_melee or {}
	local var_60_4 = var_60_2.slot_ranged or {}
	local var_60_5 = var_60_0.inventory_extension
	local var_60_6 = var_60_5:get_slot_data("slot_melee")
	local var_60_7 = var_60_5:get_item_template(var_60_6)

	var_60_3.input, var_60_3.meta, var_60_3.score = AiUtils.get_melee_weapon_score(var_60_1, var_60_7)
	var_60_3.score = var_60_3.score

	local var_60_8 = var_60_5:get_slot_data("slot_ranged")
	local var_60_9 = var_60_5:get_item_template(var_60_8)

	var_60_4.input, var_60_4.meta, var_60_4.score = AiUtils.get_melee_weapon_score(var_60_1, var_60_9)
	var_60_4.score = var_60_4.score
	var_60_2.slot_melee = var_60_3
	var_60_2.slot_ranged = var_60_4
	var_60_0.weapon_scores = var_60_2
end

PlayerBotBase._update_reload = function (arg_61_0)
	local var_61_0 = arg_61_0._blackboard
	local var_61_1 = var_61_0.inventory_extension
	local var_61_2 = var_61_1:get_slot_data("slot_ranged")
	local var_61_3 = var_61_2 and var_61_2.right_unit_1p
	local var_61_4 = var_61_2 and var_61_2.left_unit_1p
	local var_61_5 = GearUtils.get_ammo_extension(var_61_3, var_61_4)
	local var_61_6

	if var_61_5 then
		local var_61_7

		if var_61_1:has_unique_ammo_type_weapon_equipped() then
			var_61_7 = var_61_5:total_remaining_ammo() < var_61_5:max_ammo()
		else
			var_61_7 = not var_61_5:clip_full() and (var_61_5:remaining_ammo() > 0 or var_61_5:infinite_ammo())
		end

		if var_61_7 then
			var_61_6 = "slot_ranged"
		end
	end

	if var_61_6 == nil then
		local var_61_8 = var_61_0.career_extension

		if var_61_8 and var_61_8:career_name() == "dr_engineer" and var_61_8:current_ability_cooldown() > 0 and #var_61_0.proximite_enemies == 0 then
			var_61_6 = "slot_career_skill_weapon"
		end
	end

	var_61_0.wanted_slot_to_reload = var_61_6
end
