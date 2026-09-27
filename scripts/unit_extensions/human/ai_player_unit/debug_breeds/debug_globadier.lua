-- chunkname: @scripts/unit_extensions/human/ai_player_unit/debug_breeds/debug_globadier.lua

local DebugGlobadier = DebugGlobadier

DebugGlobadier = DebugGlobadier or {}
DebugGlobadier = DebugGlobadier

DebugGlobadier.update = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local target_unit = arg_1_1.target_unit

	if not target_unit then
		return
	end

	local var_1_1 = POSITION_LOOKUP[target_unit]
	local num = Vector3.up() * 0.2
	local breed = arg_1_1.breed
	local skulk_approach = BreedActions.skaven_poison_wind_globadier.skulk_approach
	local advance_towards_players = BreedActions.skaven_poison_wind_globadier.advance_towards_players
	local skulk_init_distance = skulk_approach.skulk_init_distance
	local commit_distance = BreedActions.skaven_poison_wind_globadier.skulk_approach.commit_distance
	local skulk_data = arg_1_1.skulk_data

	skulk_data = not skulk_data and arg_1_1.skulk_data.radius

	QuickDrawer:circle(var_1_1 + num, skulk_init_distance, Vector3.up(), Colors.get("light_green"))
	QuickDrawer:circle(var_1_1 + num, commit_distance, Vector3.up(), Colors.get("medium_orchid"))

	if not skulk_data then
		QuickDrawer:circle(var_1_1 + num, skulk_init_distance, Vector3.up(), Colors.get("light_green"))
	end

	local round_with_precision

	if not arg_1_1.target_dist then
		round_with_precision = math.round_with_precision(arg_1_1.target_dist, 2)

		if not round_with_precision then
			-- Nothing
		end
	end

	round_with_precision = "-"

	do
		local round_with_precision_2
	end

	::label_1_0::

	if not arg_1_1.wanted_distance then
		round_with_precision_2 = math.round_with_precision(arg_1_1.wanted_distance, 2)

		if not round_with_precision_2 then
			-- Nothing
		end
	end

	round_with_precision_2 = "-"

	::label_1_1::

	local total_slots_count = arg_1_1.total_slots_count
	local action = arg_1_1.action

	action = not action and arg_1_1.action.name

	local str = "-"
	local var_1_14
	local str_2 = "-"
	local str_3 = "-"
	local advance_towards_players_2 = arg_1_1.advance_towards_players

	if not advance_towards_players_2 then
		local slot_count_time_modifier = advance_towards_players.slot_count_time_modifier
		local slot_count_distance_modifier = advance_towards_players.slot_count_distance_modifier
		local round_with_precision_3 = math.round_with_precision(math.max(advance_towards_players_2.time_until_first_throw - advance_towards_players_2.timer, 0), 2)

		var_1_14 = advance_towards_players_2.time_until_first_throw + slot_count_time_modifier * total_slots_count
		var_1_14 = math.max(var_1_14 - advance_towards_players_2.timer, 0)
		var_1_14 = math.round_with_precision(var_1_14, 2)
		str = var_1_14 or "-"

		if round_with_precision_3 ~= var_1_14 then
			str = var_1_14 .. " [" .. round_with_precision_3 .. "]"
		end

		str_3 = advance_towards_players_2.throw_at_distance

		if not str_3 then
			local num_2 = advance_towards_players.time_before_throw_distance_modifier * advance_towards_players_2.time_before_throw_timer

			str_3 = str_3 + advance_towards_players.slot_count_distance_modifier * total_slots_count + num_2

			local target_dist = arg_1_1.target_dist

			str_2 = math.max(target_dist - str_3, 0)
			str_2 = math.round_with_precision(str_2, 2)
			str_3 = math.round_with_precision(str_3, 2)

			local round_with_precision_4 = math.round_with_precision(advance_towards_players_2.throw_at_distance, 2)

			if round_with_precision_4 ~= str_3 then
				str_3 = str_3 .. " [" .. round_with_precision_4 .. "]"
			end
		end
	end

	local str_4 = "-"
	local throw_globe_data = arg_1_1.throw_globe_data

	if not throw_globe_data then
		local next_throw_at = throw_globe_data.next_throw_at

		if not next_throw_at then
			str_4 = math.max(next_throw_at - arg_1_2, 0)
			str_4 = math.round_with_precision(str_4, 2)
		end
	end

	local var_1_27

	if action == "skulk_approach" then
		var_1_27 = "lurking"
	elseif not (action ~= "advance_towards_players" or not (var_1_14 > 0)) then
		var_1_27 = "approach"
	elseif not (action == "advance_towards_players" or action == "throw_poison_globe" or action == "observe_poison_wind" or action ~= "suicide_run") then
		var_1_27 = "combat"
	end

	DebugGlobadier.debug_hud_print("poison wind globadier:", nil, 1)
	DebugGlobadier.debug_hud_print("in_state:", var_1_27, 3)
	DebugGlobadier.debug_hud_print("ai_node:", action, 4)
	DebugGlobadier.debug_hud_print("target_distance:", round_with_precision, 5)
	DebugGlobadier.debug_hud_print("wanted_distance:", round_with_precision_2, 6)
	DebugGlobadier.debug_hud_print("throw_at_distance:", str_3, 7)
	DebugGlobadier.debug_hud_print("slot_count:", total_slots_count, 8, true)
	DebugGlobadier.debug_hud_print("time_until_first_throw:", str, 9, var_1_14 == 0)
	DebugGlobadier.debug_hud_print("time_until_next_throw:", str_4, 10, str_4 == 0 or str_4 == "-")
	DebugGlobadier.debug_hud_print("distance_until_throw:", str_2, 11, str_2 == 0 or str_2 == "-")
	DebugGlobadier.debug_hud_background(11)
end

local num = 16
local str = "arial"
local str_2 = "materials/fonts/" .. str
local num_2 = 17

DebugGlobadier.debug_hud_print = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local gui = Debug.gui
	local num_3 = 220 - arg_2_2 * num_2
	local var_2_2 = Vector3(20, num_3, 100)
	local get = Colors.get("steel_blue")

	Gui.text(gui, arg_2_0, str_2, num, str, var_2_2, get)

	if not arg_2_1 then
		return
	end

	local get_2 = Colors.get("light_green")

	if arg_2_3 == false then
		get_2 = Colors.get("crimson")
	elseif arg_2_3 == nil then
		get_2 = Colors.get("steel_blue")
	end

	local num_4 = 100
	local var_2_6 = Vector3(160, num_3, 100)

	Gui.text(gui, arg_2_1, str_2, num, str, var_2_6, get_2)
end

DebugGlobadier.debug_hud_background = function (arg_3_0)
	-- function 3
	local gui = Debug.gui
	local num = 300
	local num_3 = arg_3_0 * num_2 + 30
	local num_4 = 200 - arg_3_0 * num_2
	local var_3_4 = Vector3(10, num_4, 90)
	local var_3_5 = Vector3(num, num_3, 0)
	local get_color_with_alpha = Colors.get_color_with_alpha("black", 150)

	Gui.rect(gui, var_3_4, var_3_5, get_color_with_alpha)
end
