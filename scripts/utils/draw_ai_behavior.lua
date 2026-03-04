-- chunkname: @scripts/utils/draw_ai_behavior.lua

require("scripts/utils/script_gui")

local var_0_0 = 16
local var_0_1 = 22
local var_0_2 = 26
local var_0_3 = "arial"
local var_0_4 = "materials/fonts/" .. var_0_3
local var_0_5 = "arial"
local var_0_6 = "materials/fonts/" .. var_0_5
local var_0_7 = 12
local var_0_8 = 100
local var_0_9, var_0_10 = Application.resolution()
local var_0_11 = 0.04
local var_0_12 = 160 / var_0_9
local var_0_13 = var_0_9 * 1e-05
local var_0_14 = 2 / var_0_9
local var_0_15 = 5 / var_0_9
local var_0_16 = 15 / var_0_9
local var_0_17 = 3
local var_0_18 = {}
local var_0_19 = 1
local var_0_20 = {}
local var_0_21 = {}
local var_0_22 = {
	var_0_11
}
local var_0_23 = var_0_11 * 0.5
local var_0_24 = var_0_11

DrawAiBehaviour = {}

local var_0_25 = DrawAiBehaviour

var_0_25.winning_utility_value = 0
var_0_25.circle_array = {}
var_0_25.circle_array_index = 0
var_0_25.circle_max_size = 12

local function var_0_26(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.attack_pattern_data

	arg_1_1[1] = "State:" .. tostring(var_1_0 and var_1_0.state)

	return 1
end

local function var_0_27(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.tentacle_data

	if var_2_0 then
		arg_2_1[1] = "state:" .. tostring(var_2_0.state) .. "/" .. tostring(var_2_0.sub_state)
		arg_2_1[2] = "template: " .. tostring(var_2_0.active_template_name)
		arg_2_1[3] = "mount: " .. tostring(var_2_0.portal_spawn_type)
		arg_2_1[4] = "path: " .. tostring(var_2_0.path_type)
	end

	return 4
end

local function var_0_28(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.portal_data

	if var_3_0 then
		local var_3_1 = var_3_0.portal_search_active and "searching" or "no search"
		local var_3_2 = arg_3_0.portal_unit and "1" or "0"
		local var_3_3 = var_3_0.search_counter
		local var_3_4 = tostring(var_3_0.cover_point_index)

		arg_3_1[1] = var_3_1 .. " ,P:" .. var_3_2 .. ",SC:" .. var_3_3 .. " ,Wi:" .. var_3_4
		arg_3_1[2] = "type=" .. tostring(var_3_0.placement)

		return 2
	end

	local var_3_5 = arg_3_0.vortex_data

	if var_3_5 then
		local var_3_6 = Managers.time:time("game")
		local var_3_7 = string.format("spawn_timer: %.2f | %.2f", var_3_5.spawn_timer, var_3_6)

		arg_3_1[2], arg_3_1[1] = string.format("num_vortex_units: %d", #var_3_5.vortex_units), var_3_7

		return 2
	end

	return 0
end

local function var_0_29(arg_4_0, arg_4_1)
	arg_4_1[1] = "phase=" .. tostring(arg_4_0.phase)
	arg_4_1[2] = "current_spell=" .. tostring(arg_4_0.current_spell and arg_4_0.current_spell.name or "nil")
	arg_4_1[3] = "spell count=" .. tostring(arg_4_0.spell_count)
	arg_4_1[4] = "freeze spell casting=" .. tostring(arg_4_0.freeze_spell_casting)

	return 4
end

local function var_0_30(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.jump_slam_data
	local var_5_1 = var_5_0 and var_5_0.landing_time

	if var_5_1 then
		local var_5_2 = Managers.time:time("game")

		arg_5_1[1] = string.format("landing_time= %.2f | %.2f", var_5_1, var_5_2)

		return 1
	else
		return 0
	end
end

local var_0_31 = {
	BTFallAction = {
		"is_falling",
		"fall_done",
		"fall_state"
	},
	BTMoveToGoalAction = {
		"is_passive"
	},
	BTBossFollowAction = {
		"move_state"
	},
	BTMeleeSlamAction = {
		"move_state",
		"attack_anim",
		"attack_anim_driven"
	},
	BTTargetUnreachableAction = {
		"move_state",
		"target_dist"
	},
	BTCrazyJumpAction = {
		"jump_data"
	},
	BTSkulkAroundAction = {
		"in_los",
		"skulk_pos",
		"debug_state"
	},
	BTCirclePreyAction = {
		"move_state"
	},
	BTAttackAction = {
		"attacks_done",
		"target_dist",
		"slot_layer"
	},
	BTClanRatFollowAction = {
		"move_state",
		"using_smart_object"
	},
	BTCombatShoutAction = {
		"nav_target_dist_sq",
		"slot_layer"
	},
	BTClimbAction = {
		"is_in_smartobject_range",
		"is_climbing",
		"climb_state"
	},
	BTSkulkAroundAction = {
		"skulk_jump_tries"
	},
	BTPackMasterSkulkAroundAction = {
		"skulk_in_los",
		"skulk_dogpile",
		"skulk_time_left",
		"skulk_debug_state"
	},
	BTPackMasterDragAction = {
		"drag_check_index",
		"drag_check_time_debug"
	},
	BTSkulkApproachAction = {
		"target_dist"
	},
	BTSkulkIdleAction = {
		"skulk_data"
	},
	BTNinjaApproachAction = {
		"skulk_pos_is_jump_off_point"
	},
	BTTrollDownedAction = {
		"downed_state"
	},
	BTRatlingGunnerShootAction = {
		var_0_26
	},
	BTTentacleAttackAction = {
		var_0_27
	},
	BTChaosSorcererSkulkApproachAction = {
		var_0_28
	},
	BTVortexWanderAction = {
		"vortex_data"
	},
	BTInVortexAction = {
		"in_vortex_state"
	},
	BTChaosExaltedSorcererSkulkAction = {
		var_0_29
	},
	BTJumpSlamAction = {
		var_0_30
	}
}

local function var_0_32()
	var_0_25.circle_array_index = 0

	table.clear(var_0_25.circle_array)

	var_0_19 = 1
end

local function var_0_33(arg_7_0)
	var_0_25.circle_array_index = var_0_25.circle_array_index % var_0_25.circle_max_size + 1
	var_0_25.circle_array[var_0_25.circle_array_index] = arg_7_0
end

local function var_0_34(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = var_0_25.circle_array
	local var_8_1 = var_0_25.circle_array_index
	local var_8_2 = var_0_25.circle_max_size
	local var_8_3 = #var_8_0
	local var_8_4 = arg_8_1
	local var_8_5 = arg_8_2

	ScriptGUI.icrect(arg_8_0, var_0_9, var_0_10, var_8_4 - 5, var_8_5 - 5, var_8_4 + 300, var_8_5 + var_8_3 * 20 + 10, var_0_8, Color(100, 100, 100, 150))

	for iter_8_0 = 1, var_8_3 do
		local var_8_6 = var_8_0[var_8_1]

		ScriptGUI.ictext(arg_8_0, var_0_9, var_0_10, var_8_6, var_0_4, var_0_2, var_0_3, var_8_4, var_8_5 + 20 * iter_8_0, 400, Color(255, 220, 120))

		var_8_1 = (var_8_1 - 2) % var_8_2 + 1
	end
end

local function var_0_35(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_1
	local var_9_1 = arg_9_2
	local var_9_2 = arg_9_2
	local var_9_3 = 1
	local var_9_4 = arg_9_3.unit

	if Unit.alive(var_9_4) then
		local var_9_5 = Managers.state.entity:system("ai_system")
		local var_9_6 = Color(200, 200, 200)
		local var_9_7 = Color(240, 240, 140)
		local var_9_8 = Color(100, 190, 190)
		local var_9_9 = var_9_5.ai_units_perception[arg_9_3.unit]

		if var_9_9 then
			local var_9_10 = ""
			local var_9_11 = arg_9_3.target_unit

			if var_9_11 and BLACKBOARDS[var_9_11] then
				var_9_10 = "u" .. Unit.get_data(var_9_11, "unique_id") .. ") " .. BLACKBOARDS[var_9_11].breed.name .. "  (" .. (HEALTH_ALIVE[var_9_11] and "alive" or "dead") .. ")"
			end

			var_9_2 = var_9_2 + 10

			ScriptGUI.ictext(arg_9_0, var_0_9, var_0_10, "normal:", var_0_4, var_0_0, var_0_3, var_9_0, var_9_2, 400, var_9_7)
			ScriptGUI.ictext(arg_9_0, var_0_9, var_0_10, var_9_10, var_0_4, var_0_7, var_0_3, var_9_0 + 70, var_9_2, 400, var_9_8)

			var_9_2 = var_9_2 + 17

			local var_9_12 = "p: " .. var_9_9._perception_func_name
			local var_9_13 = "t: " .. var_9_9._target_selection_func_name

			ScriptGUI.ictext(arg_9_0, var_0_9, var_0_10, var_9_12, var_0_4, var_0_1, var_0_3, var_9_0, var_9_2, 400, var_9_6)

			var_9_2 = var_9_2 + 20

			ScriptGUI.ictext(arg_9_0, var_0_9, var_0_10, var_9_13, var_0_4, var_0_1, var_0_3, var_9_0, var_9_2, 400, var_9_6)

			var_9_2 = var_9_2 + 18
		end

		if var_9_5.ai_units_perception_continuous[arg_9_3.unit] then
			ScriptGUI.ictext(arg_9_0, var_0_9, var_0_10, "continious:", var_0_4, var_0_0, var_0_3, var_9_0, var_9_2, 400, var_9_7)

			local var_9_14 = var_9_2 + 17
			local var_9_15 = arg_9_3.breed.perception_continuous

			ScriptGUI.ictext(arg_9_0, var_0_9, var_0_10, var_9_15, var_0_4, var_0_1, var_0_3, var_9_0, var_9_14, 400, var_9_6)

			local var_9_16 = var_9_14 + 20
		end

		local var_9_17 = var_9_5.ai_units_perception_prioritized[arg_9_3.unit]

		if var_9_17 then
			var_9_2 = var_9_2 + 10

			ScriptGUI.ictext(arg_9_0, var_0_9, var_0_10, "prioritized:", var_0_4, var_0_0, var_0_3, var_9_0, var_9_2, 400, var_9_7)

			local var_9_18 = "p: " .. var_9_17._perception_func_name
			local var_9_19 = "t: " .. var_9_17._target_selection_func_name

			var_9_2 = var_9_2 + 20

			ScriptGUI.ictext(arg_9_0, var_0_9, var_0_10, var_9_18, var_0_4, var_0_1, var_0_3, var_9_0, var_9_2, 400, var_9_6)

			var_9_2 = var_9_2 + 20

			ScriptGUI.ictext(arg_9_0, var_0_9, var_0_10, var_9_19, var_0_4, var_0_1, var_0_3, var_9_0, var_9_2, 400, var_9_6)
		end

		local var_9_20 = var_9_2 + 25

		ScriptGUI.icrect(arg_9_0, var_0_9, var_0_10, var_9_0 - 5, var_9_1 - 5, var_9_0 + 380, var_9_20, var_0_8, Color(25, 70, 70, 100))
	end
end

local function var_0_36(arg_10_0, arg_10_1, arg_10_2)
	if var_0_25.last_blackboard ~= arg_10_0 or arg_10_0.reset_node_history then
		var_0_25.last_blackboard = arg_10_0
		var_0_25.last_running_node = nil
		var_0_25.running_node_switch = true
		arg_10_0.reset_node_history = nil

		var_0_32()
	end

	local var_10_0 = arg_10_0.running_nodes

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		if iter_10_1._identifier == arg_10_2 then
			if not arg_10_1 then
				if var_0_25.running_node ~= arg_10_2 then
					var_0_25.last_running_node = var_0_25.running_node
					var_0_25.running_node_switch = true

					var_0_33(var_0_19 .. " " .. arg_10_2)

					var_0_19 = var_0_19 + 1
				else
					var_0_25.running_node_switch = false
				end

				var_0_25.running_node = arg_10_2
			end

			return arg_10_2
		end
	end
end

local function var_0_37(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = UTF8Utils.string_length(arg_11_0)

	if arg_11_2 < var_11_0 then
		return arg_11_0, var_11_0
	else
		return arg_11_1, arg_11_2
	end
end

local var_0_38 = getmetatable(Vector3Box(0, 0, 0))

local function var_0_39(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8)
	local var_12_0 = arg_12_3 + var_0_14
	local var_12_1 = arg_12_4 + var_0_11 * 0.8
	local var_12_2 = var_0_0 / var_0_10
	local var_12_3 = var_0_8 + 1
	local var_12_4 = arg_12_1.name
	local var_12_5 = Color(255, 0, 0, 0)
	local var_12_6 = var_0_31[var_12_4]
	local var_12_7
	local var_12_8
	local var_12_9
	local var_12_10 = 0
	local var_12_11 = arg_12_1._tree_node.enter_hook

	if var_12_11 then
		var_12_9, var_12_10 = var_0_37(var_12_11, var_12_9, var_12_10)
	end

	local var_12_12 = arg_12_1._tree_node.leave_hook

	if var_12_12 then
		var_12_9, var_12_10 = var_0_37(var_12_12, var_12_9, var_12_10)
	end

	if var_12_6 then
		for iter_12_0, iter_12_1 in ipairs(var_12_6) do
			if type(arg_12_2[iter_12_1]) == "table" then
				arg_12_7 = arg_12_7 + var_12_2
				var_12_7 = string.format("[%s]", iter_12_1)

				ScriptGUI.itext(arg_12_0, var_0_9, var_0_10, var_12_7, var_0_4, var_0_0, var_0_3, var_12_0, var_12_1 + arg_12_7, var_12_3, var_12_5)

				var_12_9, var_12_10 = var_0_37(var_12_7, var_12_9, var_12_10)

				local var_12_13 = arg_12_2[iter_12_1]

				for iter_12_2, iter_12_3 in pairs(var_12_13) do
					arg_12_7 = arg_12_7 + var_12_2

					if type(iter_12_3) == "number" then
						var_12_7 = string.format("  > %s = %.2f", iter_12_2, iter_12_3)
					elseif getmetatable(iter_12_3) == var_0_38 then
						var_12_7 = string.format("  > %s = Vector3Box(%.2f, %.2f, %.2f)", iter_12_2, iter_12_3.x, iter_12_3.y, iter_12_3.z)
					elseif type(iter_12_3) ~= "userdata" then
						var_12_7 = string.format("  > %s = %s", iter_12_2, tostring(iter_12_3))
					else
						var_12_7 = string.format("  > %s = %s", iter_12_2, type(iter_12_3))
					end

					ScriptGUI.itext(arg_12_0, var_0_9, var_0_10, var_12_7, var_0_4, var_0_0, var_0_3, var_12_0, var_12_1 + arg_12_7, var_12_3, var_12_5)

					var_12_9, var_12_10 = var_0_37(var_12_7, var_12_9, var_12_10)
				end
			elseif type(iter_12_1) == "function" then
				local var_12_14 = iter_12_1(arg_12_2, var_0_18)

				for iter_12_4 = 1, var_12_14 do
					arg_12_7 = arg_12_7 + var_12_2
					var_12_7 = var_0_18[iter_12_4]

					ScriptGUI.itext(arg_12_0, var_0_9, var_0_10, var_12_7, var_0_4, var_0_0, var_0_3, var_12_0, var_12_1 + arg_12_7, var_12_3, var_12_5)

					var_12_9, var_12_10 = var_0_37(var_12_7, var_12_9, var_12_10)
				end
			else
				arg_12_7 = arg_12_7 + var_12_2

				local var_12_15 = arg_12_2[iter_12_1]

				if type(var_12_15) == "number" then
					var_12_7 = string.format("%s = %.2f", iter_12_1, var_12_15)
				else
					var_12_7 = string.format("%s = %s", iter_12_1, tostring(var_12_15))
				end

				ScriptGUI.itext(arg_12_0, var_0_9, var_0_10, var_12_7, var_0_4, var_0_0, var_0_3, var_12_0, var_12_1 + arg_12_7, var_12_3, var_12_5)

				var_12_9, var_12_10 = var_0_37(var_12_7, var_12_9, var_12_10)
			end
		end
	elseif arg_12_5 then
		arg_12_7 = arg_12_7 + 5 / var_0_10

		local var_12_16 = Color(240, 255, 55, 100)

		for iter_12_5, iter_12_6 in ipairs(arg_12_5) do
			arg_12_7 = arg_12_7 + var_12_2

			ScriptGUI.itext(arg_12_0, var_0_9, var_0_10, iter_12_6, var_0_4, var_0_0, var_0_3, var_12_0, var_12_1 + arg_12_7, var_12_3, var_12_16)

			var_12_9, var_12_10 = var_0_37(iter_12_6, var_12_9, var_12_10)
		end
	end

	if var_12_10 > 0 then
		local var_12_17, var_12_18 = Gui.text_extents(arg_12_0, var_12_9, var_0_4, var_0_0)
		local var_12_19 = (var_12_18.x - var_12_17.x) / var_0_9

		arg_12_6 = math.max(arg_12_6, var_12_19 + var_0_14)
	end

	return arg_12_6, arg_12_7
end

local function var_0_40(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9)
	local var_13_0 = Color(255, 240, 200, 10)
	local var_13_1 = Vector2(160, 100)
	local var_13_2 = var_13_1.y + 40
	local var_13_3 = -215
	local var_13_4 = Vector3(arg_13_6 * var_0_9, (1 - arg_13_7 + var_0_11 - arg_13_8) * var_0_10, var_0_8 + 10)
	local var_13_5 = 0

	for iter_13_0, iter_13_1 in pairs(arg_13_5) do
		if type(iter_13_1) == "table" then
			local var_13_6 = var_13_4 + Vector3(0, var_13_3, 0)

			EditAiUtility.draw_utility_info(arg_13_0, iter_13_1, nil, iter_13_0, var_13_6, var_13_1, 1, "tiny")

			if iter_13_1.is_condition then
				EditAiUtility.draw_utility_condition(arg_13_0, arg_13_4, iter_13_1, var_13_6, var_13_1, arg_13_1, Color(92, 28, 128, 44))
			else
				EditAiUtility.draw_utility_spline(arg_13_0, arg_13_9, iter_13_1, nil, iter_13_0, var_13_6, var_13_1, Color(92, 28, 128, 44), 1, 2)
				EditAiUtility.draw_realtime_utility(arg_13_0, arg_13_4, iter_13_1, var_13_6, var_13_1, arg_13_1)
			end

			var_13_3 = var_13_3 - var_13_2
			var_13_5 = var_13_5 + 1
		end
	end

	local var_13_7 = Utility.get_action_utility(arg_13_3, arg_13_4, arg_13_1, arg_13_9)

	if arg_13_2 and var_0_25.running_node_switch then
		var_0_25.winning_utility_value = var_13_7
	end

	local var_13_8

	if arg_13_2 then
		var_13_8 = string.format("sum: %.1f, (%.1f)", var_13_7, var_0_25.winning_utility_value)
	else
		var_13_8 = string.format("sum: %.1f", var_13_7)
	end

	ScriptGUI.text(arg_13_0, var_13_8, var_0_6, var_0_7, var_0_5, var_13_4 + Vector3(3, -102, 0), var_13_0)

	return var_13_5 * 0.1
end

local function var_0_41(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8)
	local var_14_0 = var_0_0 / var_0_10
	local var_14_1 = arg_14_7
	local var_14_2 = arg_14_6

	arg_14_7 = var_14_1 + var_14_0

	ScriptGUI.itext(arg_14_0, var_0_9, var_0_10, arg_14_4, var_0_4, var_0_0, var_0_3, var_14_2, arg_14_7, var_0_8 + 11, Color(255, 255, 255, 255))

	arg_14_7 = arg_14_7 + var_14_0

	ScriptGUI.itext(arg_14_0, var_0_9, var_0_10, arg_14_5, var_0_4, var_0_0, var_0_3, var_14_2, arg_14_7, var_0_8 + 11, Color(255, 255, 255, 255))

	arg_14_7 = arg_14_7 + var_0_16

	ScriptGUI.irect(arg_14_0, var_0_9, var_0_10, var_14_2, var_14_1, var_14_2 + arg_14_2, arg_14_7, var_0_8 + 10, arg_14_8)

	local var_14_3 = arg_14_7 - var_14_1

	return arg_14_7, var_14_3
end

local function var_0_42(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
	local var_15_0

	if arg_15_3 then
		var_15_0 = Color(200, 242, 152, 7)

		if var_0_20[arg_15_1] ~= var_0_17 then
			for iter_15_0, iter_15_1 in pairs(var_0_20) do
				var_0_20[iter_15_0] = iter_15_1 * 0.9
			end

			var_0_20[arg_15_1] = var_0_17
		end
	else
		local var_15_1 = 60
		local var_15_2 = var_0_20[arg_15_1]

		if var_15_2 then
			local var_15_3 = var_15_2 - arg_15_8

			if var_15_3 <= 0 then
				var_0_20[arg_15_1] = nil
			else
				var_15_1 = math.lerp(60, 255, var_15_3 / var_0_17)
				var_0_20[arg_15_1] = var_15_3
			end
		end

		if arg_15_1._children then
			var_15_0 = Color(200, 130, 170, var_15_1)
		else
			var_15_0 = Color(200, 30, 170, var_15_1)
		end
	end

	if arg_15_1._identifier == var_0_25.last_running_node then
		ScriptGUI.irect(arg_15_0, var_0_9, var_0_10, arg_15_4 - var_0_15, arg_15_5 - var_0_15, arg_15_4 + arg_15_6 + var_0_15, arg_15_5 + var_0_11 + arg_15_7 + var_0_15, var_0_8 - 1, Color(255, 242, 152, 7))
	end

	ScriptGUI.itext(arg_15_0, var_0_9, var_0_10, arg_15_1.name, var_0_4, var_0_0, var_0_3, arg_15_4 + var_0_14, arg_15_5 + var_0_11 * 0.28, var_0_8 + 1, arg_15_9)

	local var_15_4 = arg_15_5 + var_0_11 + arg_15_7
	local var_15_5

	ScriptGUI.irect(arg_15_0, var_0_9, var_0_10, arg_15_4, arg_15_5, arg_15_4 + arg_15_6, var_15_4, var_0_8, var_15_0)
	ScriptGUI.itext(arg_15_0, var_0_9, var_0_10, arg_15_2, var_0_4, var_0_2, var_0_3, arg_15_4 + var_0_14, arg_15_5 + var_0_11 * 0.7, var_0_8 + 1, arg_15_9)

	local var_15_6 = arg_15_1._tree_node.enter_hook

	if var_15_6 then
		local var_15_7

		var_15_4, var_15_7 = var_0_41(arg_15_0, arg_15_1, arg_15_6, arg_15_7, "ENTER_HOOK:", var_15_6, arg_15_4, var_15_4, Color(200, 100, 100, 150))
		arg_15_7 = arg_15_7 + var_15_7
	end

	local var_15_8 = arg_15_1._tree_node.leave_hook

	if var_15_8 then
		local var_15_9, var_15_10 = var_0_41(arg_15_0, arg_15_1, arg_15_6, arg_15_7, "LEAVE_HOOK:", var_15_8, arg_15_4, var_15_4, Color(200, 150, 100, 150))

		arg_15_7 = arg_15_7 + var_15_10
	end

	return arg_15_7
end

local function var_0_43(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11, arg_16_12, arg_16_13)
	local var_16_0 = arg_16_7 + (var_0_22[arg_16_5] or 0) + var_0_23
	local var_16_1
	local var_16_2

	if arg_16_2.name == "BTSequence" then
		var_16_1 = arg_16_6
		var_16_2 = var_16_0 + arg_16_11
	else
		var_16_1 = arg_16_6 - arg_16_10 * 0.5 + arg_16_8 * 0.5
		var_16_2 = var_16_0
	end

	local var_16_3 = var_16_1
	local var_16_4 = var_16_2
	local var_16_5 = arg_16_5 + 1
	local var_16_6 = arg_16_2.name == "BTUtilityNode"
	local var_16_7 = Color(150, 100, 255, 100)
	local var_16_8 = Color(150, 100, 50, 200)
	local var_16_9 = var_0_8 - 1
	local var_16_10 = arg_16_6 + arg_16_8 * 0.5
	local var_16_11 = arg_16_7 + var_0_11
	local var_16_12 = 6
	local var_16_13 = 2
	local var_16_14 = 0
	local var_16_15 = 0
	local var_16_16 = 0
	local var_16_17 = 0

	for iter_16_0, iter_16_1 in pairs(arg_16_3) do
		local var_16_18 = iter_16_1._identifier
		local var_16_19 = var_0_21[var_16_18].w
		local var_16_20 = var_0_21[var_16_18].total_w or 0

		if arg_16_2.name ~= "BTSequence" then
			var_16_3 = var_16_3 + var_16_20 * 0.5
		end

		local var_16_21, var_16_22, var_16_23, var_16_24 = var_0_25.draw_tree(arg_16_0, arg_16_1, iter_16_1, arg_16_4, var_16_5, arg_16_12, arg_16_13, var_16_3, var_16_4, var_16_6)

		var_16_14 = math.max(var_16_14, var_16_21)
		var_16_16 = math.max(var_16_16, var_16_23)
		var_16_15 = math.max(var_16_15, var_16_24)
		var_16_17 = math.max(var_16_17, var_16_22)

		if arg_16_2.name == "BTSequence" then
			local var_16_25 = var_16_4
			local var_16_26 = Vector2(var_16_10, var_16_11)
			local var_16_27 = Vector2(var_16_10, var_16_25)

			ScriptGUI.hud_iline(arg_16_1, var_0_9, var_0_10, var_16_26, var_16_27, var_16_9, var_16_12, var_16_8)

			var_16_11 = var_16_25 + var_0_11 + var_16_23
			var_16_4 = var_16_4 + var_0_11 * 1.5 + var_16_23 + var_16_22
			var_16_12 = var_16_13
		else
			local var_16_28 = Vector2(arg_16_6 + arg_16_8 * 0.5, arg_16_7 + var_0_11)
			local var_16_29 = Vector2(var_16_3 + var_16_19 * 0.5, var_16_0)

			ScriptGUI.hud_iline(arg_16_1, var_0_9, var_0_10, var_16_28, var_16_29, var_16_9, var_16_13, var_16_7)

			var_16_3 = var_16_3 + var_16_20 * 0.5 + var_16_21
			var_16_3 = var_16_3 + var_16_19 + var_0_13
		end
	end

	var_0_22[var_16_5] = var_0_11 + var_16_16

	local var_16_30 = 5 / var_0_9
	local var_16_31 = 5 / var_0_10
	local var_16_32 = Color(70, 55, 155, 200)
	local var_16_33 = var_16_1 - var_16_30
	local var_16_34 = var_16_0 - var_16_31
	local var_16_35
	local var_16_36

	if arg_16_2.name == "BTSequence" then
		var_16_35 = var_16_1 + var_16_15 + var_16_30
		var_16_36 = var_16_4 + var_16_31 - var_0_11 * 0.5
		var_16_32 = Color(70, 150, 50, 200)
	else
		var_16_35 = var_16_3 + var_16_30 - var_0_13
		var_16_36 = var_16_4 + var_0_11 + var_16_16 + var_16_31
	end

	ScriptGUI.irect(arg_16_1, var_0_9, var_0_10, var_16_33, var_16_34, var_16_35, var_16_36, var_16_9, var_16_32)

	local var_16_37 = 0

	if arg_16_2.name == "BTSequence" then
		var_16_37 = var_16_4 - var_16_0
	else
		var_16_37 = var_16_4 - var_16_11 + var_16_17 + var_0_11
	end

	return var_16_14, var_16_37
end

function var_0_25.tree_width(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1._identifier
	local var_17_1 = arg_17_1.name
	local var_17_2, var_17_3 = Gui.text_extents(arg_17_0, var_17_0, var_0_4, var_0_2)
	local var_17_4, var_17_5 = Gui.text_extents(arg_17_0, var_17_1, var_0_4, var_0_0)
	local var_17_6 = (var_17_3.x - var_17_2.x) / var_0_9 + var_0_14
	local var_17_7 = (var_17_5.x - var_17_4.x) / var_0_9 + var_0_14
	local var_17_8 = math.max(var_0_12, var_17_6, var_17_7)

	var_0_21[var_17_0] = {
		w = var_17_8
	}

	local var_17_9 = arg_17_1._children

	if var_17_9 then
		local var_17_10 = 0
		local var_17_11 = 0

		for iter_17_0, iter_17_1 in pairs(var_17_9) do
			local var_17_12, var_17_13 = var_0_25.tree_width(arg_17_0, iter_17_1)

			var_17_10 = var_17_10 + var_17_12

			if arg_17_1.name ~= "BTSequence" then
				var_17_11 = var_17_11 + var_17_13
			end
		end

		var_0_21[var_17_0].total_w = var_17_11

		return var_17_10, var_17_11
	else
		return 1, var_17_8
	end
end

function var_0_25.draw_tree(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9, arg_18_10)
	local var_18_0 = arg_18_2._identifier
	local var_18_1 = arg_18_2._children
	local var_18_2 = var_0_36(arg_18_3, var_18_1, var_18_0)

	if not script_data.hide_behavior_tree_node_history then
		var_0_34(arg_18_1, 20, 400)
		var_0_35(arg_18_1, 20, 300, arg_18_3)
	end

	local var_18_3 = var_0_21
	local var_18_4 = var_18_3[var_18_0].w
	local var_18_5 = var_18_3[var_18_0].total_w
	local var_18_6 = arg_18_7
	local var_18_7 = arg_18_8

	if arg_18_4 == 1 then
		var_18_7 = var_18_7 + var_0_24
	end

	local var_18_8 = var_18_0
	local var_18_9 = Color(240, 255, 255, 255)
	local var_18_10 = 0
	local var_18_11, var_18_12 = var_0_39(arg_18_1, arg_18_2, arg_18_3, var_18_6, var_18_7, arg_18_10, var_18_4, var_18_10, var_18_9)
	local var_18_13 = 0
	local var_18_14 = arg_18_2._tree_node
	local var_18_15 = var_18_14 and var_18_14.action_data
	local var_18_16 = var_18_15 and var_18_15.considerations

	if arg_18_9 and var_18_14 and var_18_15 and var_18_16 then
		var_18_13 = var_0_40(arg_18_1, arg_18_3, var_18_2, var_18_15, var_18_8, var_18_16, var_18_6, var_18_7, var_18_12, arg_18_5)
	end

	local var_18_17 = var_0_42(arg_18_1, arg_18_2, var_18_8, var_18_2, var_18_6, var_18_7, var_18_11, var_18_12, arg_18_6, var_18_9)
	local var_18_18 = 0
	local var_18_19 = 0

	if var_18_1 then
		var_18_18, var_18_19 = var_0_43(arg_18_0, arg_18_1, arg_18_2, var_18_1, arg_18_3, arg_18_4, var_18_6, var_18_7, var_18_11, var_18_17, var_18_5, var_18_13, arg_18_5, arg_18_6)
	end

	local var_18_20 = var_18_11 - var_18_3[var_18_0].w

	return math.max(var_18_20, var_18_18), var_18_19, var_18_17, var_18_11
end
