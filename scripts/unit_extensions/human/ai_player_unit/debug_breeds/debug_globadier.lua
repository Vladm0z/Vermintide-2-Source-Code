-- chunkname: @scripts/unit_extensions/human/ai_player_unit/debug_breeds/debug_globadier.lua

DebugGlobadier = DebugGlobadier or {}

DebugGlobadier.update = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.target_unit

	if not var_1_0 then
		return
	end

	local var_1_1 = POSITION_LOOKUP[var_1_0]
	local var_1_2 = Vector3.up() * 0.2
	local var_1_3 = arg_1_1.breed
	local var_1_4 = BreedActions.skaven_poison_wind_globadier.skulk_approach
	local var_1_5 = BreedActions.skaven_poison_wind_globadier.advance_towards_players
	local var_1_6 = var_1_4.skulk_init_distance
	local var_1_7 = BreedActions.skaven_poison_wind_globadier.skulk_approach.commit_distance
	local var_1_8 = arg_1_1.skulk_data and arg_1_1.skulk_data.radius

	QuickDrawer:circle(var_1_1 + var_1_2, var_1_6, Vector3.up(), Colors.get("light_green"))
	QuickDrawer:circle(var_1_1 + var_1_2, var_1_7, Vector3.up(), Colors.get("medium_orchid"))

	if var_1_8 then
		QuickDrawer:circle(var_1_1 + var_1_2, var_1_6, Vector3.up(), Colors.get("light_green"))
	end

	local var_1_9 = arg_1_1.target_dist and math.round_with_precision(arg_1_1.target_dist, 2) or "-"
	local var_1_10 = arg_1_1.wanted_distance and math.round_with_precision(arg_1_1.wanted_distance, 2) or "-"
	local var_1_11 = arg_1_1.total_slots_count
	local var_1_12 = arg_1_1.action and arg_1_1.action.name
	local var_1_13 = "-"
	local var_1_14
	local var_1_15 = "-"
	local var_1_16 = "-"
	local var_1_17 = arg_1_1.advance_towards_players

	if var_1_17 then
		local var_1_18 = var_1_5.slot_count_time_modifier
		local var_1_19 = var_1_5.slot_count_distance_modifier
		local var_1_20 = math.round_with_precision(math.max(var_1_17.time_until_first_throw - var_1_17.timer, 0), 2)

		var_1_14 = var_1_17.time_until_first_throw + var_1_18 * var_1_11
		var_1_14 = math.max(var_1_14 - var_1_17.timer, 0)
		var_1_14 = math.round_with_precision(var_1_14, 2)
		var_1_13 = var_1_14 or "-"

		if var_1_20 ~= var_1_14 then
			var_1_13 = var_1_14 .. " [" .. var_1_20 .. "]"
		end

		var_1_16 = var_1_17.throw_at_distance

		if var_1_16 then
			local var_1_21 = var_1_5.time_before_throw_distance_modifier * var_1_17.time_before_throw_timer

			var_1_16 = var_1_16 + var_1_5.slot_count_distance_modifier * var_1_11 + var_1_21

			local var_1_22 = arg_1_1.target_dist

			var_1_15 = math.max(var_1_22 - var_1_16, 0)
			var_1_15 = math.round_with_precision(var_1_15, 2)
			var_1_16 = math.round_with_precision(var_1_16, 2)

			local var_1_23 = math.round_with_precision(var_1_17.throw_at_distance, 2)

			if var_1_23 ~= var_1_16 then
				var_1_16 = var_1_16 .. " [" .. var_1_23 .. "]"
			end
		end
	end

	local var_1_24 = "-"
	local var_1_25 = arg_1_1.throw_globe_data

	if var_1_25 then
		local var_1_26 = var_1_25.next_throw_at

		if var_1_26 then
			var_1_24 = math.max(var_1_26 - arg_1_2, 0)
			var_1_24 = math.round_with_precision(var_1_24, 2)
		end
	end

	local var_1_27

	if var_1_12 == "skulk_approach" then
		var_1_27 = "lurking"
	elseif var_1_12 == "advance_towards_players" and var_1_14 > 0 then
		var_1_27 = "approach"
	elseif var_1_12 == "advance_towards_players" or var_1_12 == "throw_poison_globe" or var_1_12 == "observe_poison_wind" or var_1_12 == "suicide_run" then
		var_1_27 = "combat"
	end

	DebugGlobadier.debug_hud_print("poison wind globadier:", nil, 1)
	DebugGlobadier.debug_hud_print("in_state:", var_1_27, 3)
	DebugGlobadier.debug_hud_print("ai_node:", var_1_12, 4)
	DebugGlobadier.debug_hud_print("target_distance:", var_1_9, 5)
	DebugGlobadier.debug_hud_print("wanted_distance:", var_1_10, 6)
	DebugGlobadier.debug_hud_print("throw_at_distance:", var_1_16, 7)
	DebugGlobadier.debug_hud_print("slot_count:", var_1_11, 8, true)
	DebugGlobadier.debug_hud_print("time_until_first_throw:", var_1_13, 9, var_1_14 == 0)
	DebugGlobadier.debug_hud_print("time_until_next_throw:", var_1_24, 10, var_1_24 == 0 or var_1_24 == "-")
	DebugGlobadier.debug_hud_print("distance_until_throw:", var_1_15, 11, var_1_15 == 0 or var_1_15 == "-")
	DebugGlobadier.debug_hud_background(11)
end

local var_0_0 = 16
local var_0_1 = "arial"
local var_0_2 = "materials/fonts/" .. var_0_1
local var_0_3 = 17

DebugGlobadier.debug_hud_print = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Debug.gui
	local var_2_1 = 220 - arg_2_2 * var_0_3
	local var_2_2 = Vector3(20, var_2_1, 100)
	local var_2_3 = Colors.get("steel_blue")

	Gui.text(var_2_0, arg_2_0, var_0_2, var_0_0, var_0_1, var_2_2, var_2_3)

	if not arg_2_1 then
		return
	end

	local var_2_4 = Colors.get("light_green")

	if arg_2_3 == false then
		var_2_4 = Colors.get("crimson")
	elseif arg_2_3 == nil then
		var_2_4 = Colors.get("steel_blue")
	end

	local var_2_5 = 100
	local var_2_6 = Vector3(160, var_2_1, 100)

	Gui.text(var_2_0, arg_2_1, var_0_2, var_0_0, var_0_1, var_2_6, var_2_4)
end

DebugGlobadier.debug_hud_background = function (arg_3_0)
	local var_3_0 = Debug.gui
	local var_3_1 = 300
	local var_3_2 = arg_3_0 * var_0_3 + 30
	local var_3_3 = 200 - arg_3_0 * var_0_3
	local var_3_4 = Vector3(10, var_3_3, 90)
	local var_3_5 = Vector3(var_3_1, var_3_2, 0)
	local var_3_6 = Colors.get_color_with_alpha("black", 150)

	Gui.rect(var_3_0, var_3_4, var_3_5, var_3_6)
end
