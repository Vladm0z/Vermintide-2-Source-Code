-- chunkname: @scripts/utils/draw_ai_behavior.lua

require("scripts/utils/script_gui")

local num = 16
local num_2 = 22
local num_3 = 26
local str = "arial"
local str_2 = "materials/fonts/" .. str
local str_3 = "arial"
local str_4 = "materials/fonts/" .. str_3
local num_4 = 12
local num_5 = 100
local resolution, var_0_10 = Application.resolution()
local num_6 = 0.04
local num_7 = 160 / resolution
local num_8 = resolution * 1e-05
local num_9 = 2 / resolution
local num_10 = 5 / resolution
local num_11 = 15 / resolution
local num_12 = 3
local tbl = {}
local num_13 = 1
local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {
	num_6
}
local num_14 = num_6 * 0.5
local var_0_24 = num_6

DrawAiBehaviour = {}

local DrawAiBehaviour = DrawAiBehaviour

DrawAiBehaviour.winning_utility_value = 0
DrawAiBehaviour.circle_array = {}
DrawAiBehaviour.circle_array_index = 0
DrawAiBehaviour.circle_max_size = 12

local function fn(self, arg_1_1)
	-- function 1
	local attack_pattern_data = self.attack_pattern_data

	arg_1_1[1] = "State:" .. tostring(not attack_pattern_data and attack_pattern_data.state)

	return 1
end

local function fn_2(self, arg_2_1)
	-- function 2
	local tentacle_data = self.tentacle_data

	if not tentacle_data then
		arg_2_1[1] = "state:" .. tostring(tentacle_data.state) .. "/" .. tostring(tentacle_data.sub_state)
		arg_2_1[2] = "template: " .. tostring(tentacle_data.active_template_name)
		arg_2_1[3] = "mount: " .. tostring(tentacle_data.portal_spawn_type)
		arg_2_1[4] = "path: " .. tostring(tentacle_data.path_type)
	end

	return 4
end

local function fn_3(self, arg_3_1)
	-- function 3
	local portal_data = self.portal_data

	if not portal_data then
		local flag

		flag = not portal_data.portal_search_active and "searching" and "no search"

		local flag_2

		flag_2 = not self.portal_unit and "1" and "0"

		local search_counter = portal_data.search_counter
		local var_3_4 = tostring(portal_data.cover_point_index)

		arg_3_1[1] = flag .. " ,P:" .. flag_2 .. ",SC:" .. search_counter .. " ,Wi:" .. var_3_4
		arg_3_1[2] = "type=" .. tostring(portal_data.placement)

		return 2
	end

	local vortex_data = self.vortex_data

	if not vortex_data then
		local time = Managers.time:time("game")
		local format = string.format("spawn_timer: %.2f | %.2f", vortex_data.spawn_timer, time)

		arg_3_1[2], arg_3_1[1] = string.format("num_vortex_units: %d", #vortex_data.vortex_units), format

		return 2
	end

	return 0
end

local function fn_4(self, arg_4_1)
	-- function 4
	arg_4_1[1] = "phase=" .. tostring(self.phase)

	local str = "current_spell="
	local tostring = tostring
	local name

	if not self.current_spell then
		name = self.current_spell.name

		if not name then
			-- Nothing
		end
	end

	name = "nil"

	::label_4_0::

	arg_4_1[2] = str .. tostring(name)
	arg_4_1[3] = "spell count=" .. tostring(self.spell_count)
	arg_4_1[4] = "freeze spell casting=" .. tostring(self.freeze_spell_casting)

	return 4
end

local function fn_5(self, arg_5_1)
	-- function 5
	local jump_slam_data = self.jump_slam_data
	local flag = not jump_slam_data and jump_slam_data.landing_time

	if not flag then
		local time = Managers.time:time("game")

		arg_5_1[1] = string.format("landing_time= %.2f | %.2f", flag, time)

		return 1
	else
		return 0
	end
end

local tbl_5 = {
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
		fn
	},
	BTTentacleAttackAction = {
		fn_2
	},
	BTChaosSorcererSkulkApproachAction = {
		fn_3
	},
	BTVortexWanderAction = {
		"vortex_data"
	},
	BTInVortexAction = {
		"in_vortex_state"
	},
	BTChaosExaltedSorcererSkulkAction = {
		fn_4
	},
	BTJumpSlamAction = {
		fn_5
	}
}

local function fn_6()
	-- function 6
	DrawAiBehaviour.circle_array_index = 0

	table.clear(DrawAiBehaviour.circle_array)

	num_13 = 1
end

local function fn_7(arg_7_0)
	-- function 7
	DrawAiBehaviour.circle_array_index = DrawAiBehaviour.circle_array_index % DrawAiBehaviour.circle_max_size + 1
	DrawAiBehaviour.circle_array[DrawAiBehaviour.circle_array_index] = arg_7_0
end

local function fn_8(arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local circle_array = DrawAiBehaviour.circle_array
	local circle_array_index = DrawAiBehaviour.circle_array_index
	local circle_max_size = DrawAiBehaviour.circle_max_size
	local count = #circle_array
	local var_8_4 = arg_8_1
	local var_8_5 = arg_8_2

	ScriptGUI.icrect(arg_8_0, resolution, var_0_10, var_8_4 - 5, var_8_5 - 5, var_8_4 + 300, var_8_5 + count * 20 + 10, num_5, Color(100, 100, 100, 150))

	for i = 1, count do
		local var_8_6 = circle_array[circle_array_index]

		ScriptGUI.ictext(arg_8_0, resolution, var_0_10, var_8_6, str_2, num_3, str, var_8_4, var_8_5 + 20 * i, 400, Color(255, 220, 120))

		circle_array_index = (circle_array_index - 2) % circle_max_size + 1
	end
end

local function fn_9(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local var_9_0 = arg_9_1
	local var_9_1 = arg_9_2
	local var_9_2 = arg_9_2
	local num_3 = 1
	local unit = arg_9_3.unit

	if not Unit.alive(unit) then
		local system = Managers.state.entity:system("ai_system")
		local var_9_6 = Color(200, 200, 200)
		local var_9_7 = Color(240, 240, 140)
		local var_9_8 = Color(100, 190, 190)
		local var_9_9 = system.ai_units_perception[arg_9_3.unit]

		if not var_9_9 then
			local str_3 = ""
			local target_unit = arg_9_3.target_unit

			if not target_unit and not BLACKBOARDS[target_unit] then
				local str_4 = "u"
				local get_data = Unit.get_data(target_unit, "unique_id")
				local str_5 = ") "
				local name = BLACKBOARDS[target_unit].breed.name
				local str_6 = "  ("
				local flag

				flag = not HEALTH_ALIVE[target_unit] and "alive" and "dead"
				str_3 = str_4 .. get_data .. str_5 .. name .. str_6 .. flag .. ")"
			end

			var_9_2 = var_9_2 + 10

			ScriptGUI.ictext(arg_9_0, resolution, var_0_10, "normal:", str_2, num, str, var_9_0, var_9_2, 400, var_9_7)
			ScriptGUI.ictext(arg_9_0, resolution, var_0_10, str_3, str_2, num_4, str, var_9_0 + 70, var_9_2, 400, var_9_8)

			var_9_2 = var_9_2 + 17

			local str_7 = "p: " .. var_9_9._perception_func_name
			local str_8 = "t: " .. var_9_9._target_selection_func_name

			ScriptGUI.ictext(arg_9_0, resolution, var_0_10, str_7, str_2, num_2, str, var_9_0, var_9_2, 400, var_9_6)

			var_9_2 = var_9_2 + 20

			ScriptGUI.ictext(arg_9_0, resolution, var_0_10, str_8, str_2, num_2, str, var_9_0, var_9_2, 400, var_9_6)

			var_9_2 = var_9_2 + 18
		end

		if not system.ai_units_perception_continuous[arg_9_3.unit] then
			ScriptGUI.ictext(arg_9_0, resolution, var_0_10, "continious:", str_2, num, str, var_9_0, var_9_2, 400, var_9_7)

			local num_6 = var_9_2 + 17
			local perception_continuous = arg_9_3.breed.perception_continuous

			ScriptGUI.ictext(arg_9_0, resolution, var_0_10, perception_continuous, str_2, num_2, str, var_9_0, num_6, 400, var_9_6)

			local num_7 = num_6 + 20
		end

		local var_9_23 = system.ai_units_perception_prioritized[arg_9_3.unit]

		if not var_9_23 then
			var_9_2 = var_9_2 + 10

			ScriptGUI.ictext(arg_9_0, resolution, var_0_10, "prioritized:", str_2, num, str, var_9_0, var_9_2, 400, var_9_7)

			local str_9 = "p: " .. var_9_23._perception_func_name
			local str_10 = "t: " .. var_9_23._target_selection_func_name

			var_9_2 = var_9_2 + 20

			ScriptGUI.ictext(arg_9_0, resolution, var_0_10, str_9, str_2, num_2, str, var_9_0, var_9_2, 400, var_9_6)

			var_9_2 = var_9_2 + 20

			ScriptGUI.ictext(arg_9_0, resolution, var_0_10, str_10, str_2, num_2, str, var_9_0, var_9_2, 400, var_9_6)
		end

		local num_8 = var_9_2 + 25

		ScriptGUI.icrect(arg_9_0, resolution, var_0_10, var_9_0 - 5, var_9_1 - 5, var_9_0 + 380, num_8, num_5, Color(25, 70, 70, 100))
	end
end

local function fn_10(self, arg_10_1, arg_10_2)
	-- function 10
	if DrawAiBehaviour.last_blackboard ~= self or not self.reset_node_history then
		DrawAiBehaviour.last_blackboard = self
		DrawAiBehaviour.last_running_node = nil
		DrawAiBehaviour.running_node_switch = true
		self.reset_node_history = nil

		fn_6()
	end

	local running_nodes = self.running_nodes

	for k, v in pairs(running_nodes) do
		if v._identifier == arg_10_2 then
			if not arg_10_1 then
				if DrawAiBehaviour.running_node ~= arg_10_2 then
					DrawAiBehaviour.last_running_node = DrawAiBehaviour.running_node
					DrawAiBehaviour.running_node_switch = true

					fn_7(num_13 .. " " .. arg_10_2)

					num_13 = num_13 + 1
				else
					DrawAiBehaviour.running_node_switch = false
				end

				DrawAiBehaviour.running_node = arg_10_2
			end

			return arg_10_2
		end
	end
end

local function fn_11(arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local length = Utf8.length(arg_11_0)

	if arg_11_2 < length then
		return arg_11_0, length
	else
		return arg_11_1, arg_11_2
	end
end

local var_0_38 = getmetatable(Vector3Box(0, 0, 0))

local function fn_12(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8)
	-- function 12
	local num_2 = arg_12_3 + num_9
	local num_3 = arg_12_4 + num_6 * 0.8
	local num_4 = num / var_0_10
	local num_7 = num_5 + 1
	local name = arg_12_1.name
	local var_12_5 = Color(255, 0, 0, 0)
	local var_12_6 = tbl_5[name]
	local var_12_7
	local var_12_8
	local var_12_9
	local num_8 = 0
	local enter_hook = arg_12_1._tree_node.enter_hook

	if not enter_hook then
		var_12_9, num_8 = fn_11(enter_hook, var_12_9, num_8)
	end

	local leave_hook = arg_12_1._tree_node.leave_hook

	if not leave_hook then
		var_12_9, num_8 = fn_11(leave_hook, var_12_9, num_8)
	end

	if not var_12_6 then
		for i, v in ipairs(var_12_6) do
			if type(arg_12_2[v]) == "table" then
				arg_12_7 = arg_12_7 + num_4
				var_12_7 = string.format("[%s]", v)

				ScriptGUI.itext(arg_12_0, resolution, var_0_10, var_12_7, str_2, num, str, num_2, num_3 + arg_12_7, num_7, var_12_5)

				var_12_9, num_8 = fn_11(var_12_7, var_12_9, num_8)

				local var_12_13 = arg_12_2[v]

				for k, v_2 in pairs(var_12_13) do
					arg_12_7 = arg_12_7 + num_4

					if type(v_2) == "number" then
						var_12_7 = string.format("  > %s = %.2f", k, v_2)
					elseif getmetatable(v_2) == var_0_38 then
						var_12_7 = string.format("  > %s = Vector3Box(%.2f, %.2f, %.2f)", k, v_2.x, v_2.y, v_2.z)
					elseif type(v_2) ~= "userdata" then
						var_12_7 = string.format("  > %s = %s", k, tostring(v_2))
					else
						var_12_7 = string.format("  > %s = %s", k, type(v_2))
					end

					ScriptGUI.itext(arg_12_0, resolution, var_0_10, var_12_7, str_2, num, str, num_2, num_3 + arg_12_7, num_7, var_12_5)

					var_12_9, num_8 = fn_11(var_12_7, var_12_9, num_8)
				end
			elseif type(v) == "function" then
				local var_12_14 = v(arg_12_2, tbl)

				for i4 = 1, var_12_14 do
					arg_12_7 = arg_12_7 + num_4
					var_12_7 = tbl[i4]

					ScriptGUI.itext(arg_12_0, resolution, var_0_10, var_12_7, str_2, num, str, num_2, num_3 + arg_12_7, num_7, var_12_5)

					var_12_9, num_8 = fn_11(var_12_7, var_12_9, num_8)
				end
			else
				arg_12_7 = arg_12_7 + num_4

				local var_12_15 = arg_12_2[v]

				if type(var_12_15) == "number" then
					var_12_7 = string.format("%s = %.2f", v, var_12_15)
				else
					var_12_7 = string.format("%s = %s", v, tostring(var_12_15))
				end

				ScriptGUI.itext(arg_12_0, resolution, var_0_10, var_12_7, str_2, num, str, num_2, num_3 + arg_12_7, num_7, var_12_5)

				var_12_9, num_8 = fn_11(var_12_7, var_12_9, num_8)
			end
		end
	elseif not arg_12_5 then
		arg_12_7 = arg_12_7 + 5 / var_0_10

		local var_12_16 = Color(240, 255, 55, 100)

		for i_2, v_3 in ipairs(arg_12_5) do
			arg_12_7 = arg_12_7 + num_4

			ScriptGUI.itext(arg_12_0, resolution, var_0_10, v_3, str_2, num, str, num_2, num_3 + arg_12_7, num_7, var_12_16)

			var_12_9, num_8 = fn_11(v_3, var_12_9, num_8)
		end
	end

	if num_8 > 0 then
		local text_extents, var_12_18 = Gui.text_extents(arg_12_0, var_12_9, str_2, num)
		local num_10 = (var_12_18.x - text_extents.x) / resolution

		arg_12_6 = math.max(arg_12_6, num_10 + num_9)
	end

	return arg_12_6, arg_12_7
end

local function fn_13(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9)
	-- function 13
	local var_13_0 = Color(255, 240, 200, 10)
	local var_13_1 = Vector2(160, 100)
	local num = var_13_1.y + 40
	local num_2 = -215
	local var_13_4 = Vector3(arg_13_6 * resolution, (1 - arg_13_7 + num_6 - arg_13_8) * var_0_10, num_5 + 10)
	local num_3 = 0

	for k, v in pairs(arg_13_5) do
		if type(v) == "table" then
			local num_7 = var_13_4 + Vector3(0, num_2, 0)

			EditAiUtility.draw_utility_info(arg_13_0, v, nil, k, num_7, var_13_1, 1, "tiny")

			if not v.is_condition then
				EditAiUtility.draw_utility_condition(arg_13_0, arg_13_4, v, num_7, var_13_1, arg_13_1, Color(92, 28, 128, 44))
			else
				EditAiUtility.draw_utility_spline(arg_13_0, arg_13_9, v, nil, k, num_7, var_13_1, Color(92, 28, 128, 44), 1, 2)
				EditAiUtility.draw_realtime_utility(arg_13_0, arg_13_4, v, num_7, var_13_1, arg_13_1)
			end

			num_2 = num_2 - num
			num_3 = num_3 + 1
		end
	end

	local get_action_utility = Utility.get_action_utility(arg_13_3, arg_13_4, arg_13_1, arg_13_9)

	if not arg_13_2 and not DrawAiBehaviour.running_node_switch then
		DrawAiBehaviour.winning_utility_value = get_action_utility
	end

	local var_13_8

	if not arg_13_2 then
		var_13_8 = string.format("sum: %.1f, (%.1f)", get_action_utility, DrawAiBehaviour.winning_utility_value)
	else
		var_13_8 = string.format("sum: %.1f", get_action_utility)
	end

	ScriptGUI.text(arg_13_0, var_13_8, str_4, num_4, str_3, var_13_4 + Vector3(3, -102, 0), var_13_0)

	return num_3 * 0.1
end

local function fn_14(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8)
	-- function 14
	local num_2 = num / var_0_10
	local var_14_1 = arg_14_7
	local var_14_2 = arg_14_6

	arg_14_7 = var_14_1 + num_2

	ScriptGUI.itext(arg_14_0, resolution, var_0_10, arg_14_4, str_2, num, str, var_14_2, arg_14_7, num_5 + 11, Color(255, 255, 255, 255))

	arg_14_7 = arg_14_7 + num_2

	ScriptGUI.itext(arg_14_0, resolution, var_0_10, arg_14_5, str_2, num, str, var_14_2, arg_14_7, num_5 + 11, Color(255, 255, 255, 255))

	arg_14_7 = arg_14_7 + num_11

	ScriptGUI.irect(arg_14_0, resolution, var_0_10, var_14_2, var_14_1, var_14_2 + arg_14_2, arg_14_7, num_5 + 10, arg_14_8)

	local num_3 = arg_14_7 - var_14_1

	return arg_14_7, num_3
end

local function fn_15(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
	-- function 15
	local var_15_0

	if not arg_15_3 then
		var_15_0 = Color(200, 242, 152, 7)

		if tbl_2[arg_15_1] ~= num_12 then
			for k, v in pairs(tbl_2) do
				tbl_2[k] = v * 0.9
			end

			tbl_2[arg_15_1] = num_12
		end
	else
		local num_2 = 60
		local var_15_2 = tbl_2[arg_15_1]

		if not var_15_2 then
			local num_4 = var_15_2 - arg_15_8

			if num_4 <= 0 then
				tbl_2[arg_15_1] = nil
			else
				num_2 = math.lerp(60, 255, num_4 / num_12)
				tbl_2[arg_15_1] = num_4
			end
		end

		if not arg_15_1._children then
			var_15_0 = Color(200, 130, 170, num_2)
		else
			var_15_0 = Color(200, 30, 170, num_2)
		end
	end

	if arg_15_1._identifier == DrawAiBehaviour.last_running_node then
		ScriptGUI.irect(arg_15_0, resolution, var_0_10, arg_15_4 - num_10, arg_15_5 - num_10, arg_15_4 + arg_15_6 + num_10, arg_15_5 + num_6 + arg_15_7 + num_10, num_5 - 1, Color(255, 242, 152, 7))
	end

	ScriptGUI.itext(arg_15_0, resolution, var_0_10, arg_15_1.name, str_2, num, str, arg_15_4 + num_9, arg_15_5 + num_6 * 0.28, num_5 + 1, arg_15_9)

	local num_7 = arg_15_5 + num_6 + arg_15_7
	local var_15_5

	ScriptGUI.irect(arg_15_0, resolution, var_0_10, arg_15_4, arg_15_5, arg_15_4 + arg_15_6, num_7, num_5, var_15_0)
	ScriptGUI.itext(arg_15_0, resolution, var_0_10, arg_15_2, str_2, num_3, str, arg_15_4 + num_9, arg_15_5 + num_6 * 0.7, num_5 + 1, arg_15_9)

	local enter_hook = arg_15_1._tree_node.enter_hook

	if not enter_hook then
		local var_15_7

		num_7, var_15_7 = fn_14(arg_15_0, arg_15_1, arg_15_6, arg_15_7, "ENTER_HOOK:", enter_hook, arg_15_4, num_7, Color(200, 100, 100, 150))
		arg_15_7 = arg_15_7 + var_15_7
	end

	local leave_hook = arg_15_1._tree_node.leave_hook

	if not leave_hook then
		local var_15_9, var_15_10 = fn_14(arg_15_0, arg_15_1, arg_15_6, arg_15_7, "LEAVE_HOOK:", leave_hook, arg_15_4, num_7, Color(200, 150, 100, 150))

		arg_15_7 = arg_15_7 + var_15_10
	end

	return arg_15_7
end

local function fn_16(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11, arg_16_12, arg_16_13)
	-- function 16
	local var_16_0 = tbl_4[arg_16_5]

	var_16_0 = var_16_0 or 0

	local num = arg_16_7 + var_16_0 + num_14
	local var_16_2
	local var_16_3

	if arg_16_2.name == "BTSequence" then
		var_16_2 = arg_16_6
		var_16_3 = num + arg_16_11
	else
		var_16_2 = arg_16_6 - arg_16_10 * 0.5 + arg_16_8 * 0.5
		var_16_3 = num
	end

	local var_16_4 = var_16_2
	local var_16_5 = var_16_3
	local num_2 = arg_16_5 + 1
	local flag = arg_16_2.name == "BTUtilityNode"
	local var_16_8 = Color(150, 100, 255, 100)
	local var_16_9 = Color(150, 100, 50, 200)
	local num_3 = num_5 - 1
	local num_4 = arg_16_6 + arg_16_8 * 0.5
	local num_7 = arg_16_7 + num_6
	local num_9 = 6
	local num_10 = 2
	local num_11 = 0
	local num_12 = 0
	local num_13 = 0
	local num_15 = 0

	for k, v in pairs(arg_16_3) do
		local _identifier = v._identifier
		local w = tbl_3[_identifier].w
		local total_w = tbl_3[_identifier].total_w

		total_w = total_w or 0

		if arg_16_2.name ~= "BTSequence" then
			var_16_4 = var_16_4 + total_w * 0.5
		end

		local draw_tree, var_16_23, var_16_24, var_16_25 = DrawAiBehaviour.draw_tree(arg_16_0, arg_16_1, v, arg_16_4, num_2, arg_16_12, arg_16_13, var_16_4, var_16_5, flag)

		num_11 = math.max(num_11, draw_tree)
		num_13 = math.max(num_13, var_16_24)
		num_12 = math.max(num_12, var_16_25)
		num_15 = math.max(num_15, var_16_23)

		if arg_16_2.name == "BTSequence" then
			local var_16_26 = var_16_5
			local var_16_27 = Vector2(num_4, num_7)
			local var_16_28 = Vector2(num_4, var_16_26)

			ScriptGUI.hud_iline(arg_16_1, resolution, var_0_10, var_16_27, var_16_28, num_3, num_9, var_16_9)

			num_7 = var_16_26 + num_6 + var_16_24
			var_16_5 = var_16_5 + num_6 * 1.5 + var_16_24 + var_16_23
			num_9 = num_10
		else
			local var_16_29 = Vector2(arg_16_6 + arg_16_8 * 0.5, arg_16_7 + num_6)
			local var_16_30 = Vector2(var_16_4 + w * 0.5, num)

			ScriptGUI.hud_iline(arg_16_1, resolution, var_0_10, var_16_29, var_16_30, num_3, num_10, var_16_8)

			var_16_4 = var_16_4 + total_w * 0.5 + draw_tree
			var_16_4 = var_16_4 + w + num_8
		end
	end

	tbl_4[num_2] = num_6 + num_13

	local num_16 = 5 / resolution
	local num_17 = 5 / var_0_10
	local var_16_33 = Color(70, 55, 155, 200)
	local num_18 = var_16_2 - num_16
	local num_19 = num - num_17
	local var_16_36
	local var_16_37

	if arg_16_2.name == "BTSequence" then
		var_16_36 = var_16_2 + num_12 + num_16
		var_16_37 = var_16_5 + num_17 - num_6 * 0.5
		var_16_33 = Color(70, 150, 50, 200)
	else
		var_16_36 = var_16_4 + num_16 - num_8
		var_16_37 = var_16_5 + num_6 + num_13 + num_17
	end

	ScriptGUI.irect(arg_16_1, resolution, var_0_10, num_18, num_19, var_16_36, var_16_37, num_3, var_16_33)

	local num_20 = 0

	if arg_16_2.name == "BTSequence" then
		num_20 = var_16_5 - num
	else
		num_20 = var_16_5 - num_7 + num_15 + num_6
	end

	return num_11, num_20
end

DrawAiBehaviour.tree_width = function (arg_17_0, arg_17_1)
	-- function 17
	local _identifier = arg_17_1._identifier
	local name = arg_17_1.name
	local text_extents, var_17_3 = Gui.text_extents(arg_17_0, _identifier, str_2, num_3)
	local text_extents_2, var_17_5 = Gui.text_extents(arg_17_0, name, str_2, num)
	local num_2 = (var_17_3.x - text_extents.x) / resolution + num_9
	local num_4 = (var_17_5.x - text_extents_2.x) / resolution + num_9
	local max = math.max(num_7, num_2, num_4)

	tbl_3[_identifier] = {
		w = max
	}

	local _children = arg_17_1._children

	if not _children then
		local num_5 = 0
		local num_6 = 0

		for k, v in pairs(_children) do
			local tree_width, var_17_13 = DrawAiBehaviour.tree_width(arg_17_0, v)

			num_5 = num_5 + tree_width

			if arg_17_1.name ~= "BTSequence" then
				num_6 = num_6 + var_17_13
			end
		end

		tbl_3[_identifier].total_w = num_6

		return num_5, num_6
	else
		return 1, max
	end
end

DrawAiBehaviour.draw_tree = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9, arg_18_10)
	-- function 18
	local _identifier = arg_18_2._identifier
	local _children = arg_18_2._children
	local var_18_2 = fn_10(arg_18_3, _children, _identifier)

	if not script_data.hide_behavior_tree_node_history then
		fn_8(arg_18_1, 20, 400)
		fn_9(arg_18_1, 20, 300, arg_18_3)
	end

	local var_18_3 = tbl_3
	local w = var_18_3[_identifier].w
	local total_w = var_18_3[_identifier].total_w
	local var_18_6 = arg_18_7
	local var_18_7 = arg_18_8

	if arg_18_4 == 1 then
		var_18_7 = var_18_7 + var_0_24
	end

	local var_18_8 = _identifier
	local var_18_9 = Color(240, 255, 255, 255)
	local num = 0
	local var_18_11, var_18_12 = fn_12(arg_18_1, arg_18_2, arg_18_3, var_18_6, var_18_7, arg_18_10, w, num, var_18_9)
	local num_2 = 0
	local _tree_node = arg_18_2._tree_node
	local flag = not _tree_node and _tree_node.action_data
	local flag_2 = not flag and flag.considerations

	if not arg_18_9 and not _tree_node and not flag and not flag_2 then
		num_2 = fn_13(arg_18_1, arg_18_3, var_18_2, flag, var_18_8, flag_2, var_18_6, var_18_7, var_18_12, arg_18_5)
	end

	local var_18_17 = fn_15(arg_18_1, arg_18_2, var_18_8, var_18_2, var_18_6, var_18_7, var_18_11, var_18_12, arg_18_6, var_18_9)
	local num_3 = 0
	local num_4 = 0

	if not _children then
		num_3, num_4 = fn_16(arg_18_0, arg_18_1, arg_18_2, _children, arg_18_3, arg_18_4, var_18_6, var_18_7, var_18_11, var_18_17, total_w, num_2, arg_18_5, arg_18_6)
	end

	local num_5 = var_18_11 - var_18_3[_identifier].w

	return math.max(num_5, num_3), num_4, var_18_17, var_18_11
end
