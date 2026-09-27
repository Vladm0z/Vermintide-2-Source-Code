-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_skulk_around_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSkulkAroundAction = class(BTSkulkAroundAction, BTNode)
BTSkulkAroundAction.name = "BTSkulkAroundAction"

local POSITION_LOOKUP = POSITION_LOOKUP
local script_data = script_data

BTSkulkAroundAction.init = function (arg_1_0, ...)
	-- function 1
	BTSkulkAroundAction.super.init(arg_1_0, ...)
end

local function fn(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if not script_data.debug_ai_movement then
		Debug.world_sticky_text(POSITION_LOOKUP[arg_2_0], arg_2_1, arg_2_2)
	end
end

BTSkulkAroundAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	if not arg_3_2.skulk_data then
		arg_3_2.skulk_data = {}
	end

	local skulk_data = arg_3_2.skulk_data

	LocomotionUtils.set_animation_driven_movement(arg_3_1, false)

	local network = Managers.state.network

	Managers.state.network:anim_event(arg_3_1, "idle")

	arg_3_2.move_state = "idle"

	arg_3_2.navigation_extension:set_max_speed(arg_3_2.breed.run_speed)
	arg_3_2.locomotion_extension:set_rotation_speed(5)

	if not skulk_data.skulk_pos then
		local unbox = skulk_data.skulk_pos:unbox()

		arg_3_2.navigation_extension:move_to(unbox)
	else
		local get_new_skulk_goal = self:get_new_skulk_goal(arg_3_1, arg_3_2)

		skulk_data.skulk_pos = Vector3Box(get_new_skulk_goal)

		arg_3_2.navigation_extension:move_to(get_new_skulk_goal)
	end

	if not (not skulk_data.attack_timer and not (arg_3_3 > skulk_data.attack_timer)) then
		skulk_data.attack_timer = arg_3_3 + math.random(25, 30)
	end
end

BTSkulkAroundAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(get_default_breed_move_speed)

	if not arg_4_2.approach_target then
		arg_4_2.skulk_data.attack_timer = nil
	end
end

BTSkulkAroundAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local skulk_data = arg_5_2.skulk_data

	if not arg_5_2.navigation_extension:is_following_path() then
		if arg_5_2.move_state ~= "moving" then
			Managers.state.network:anim_event(arg_5_1, "move_fwd")

			arg_5_2.move_state = "moving"
		end
	else
		if arg_5_2.l ~= "idle" then
			Managers.state.network:anim_event(arg_5_1, "idle")

			arg_5_2.move_state = "idle"
		end

		if not arg_5_2.no_path_found then
			local get_new_skulk_goal = self:get_new_skulk_goal(arg_5_1, arg_5_2)

			skulk_data.skulk_pos = Vector3Box(get_new_skulk_goal)

			arg_5_2.navigation_extension:move_to(get_new_skulk_goal)
		end
	end

	if not skulk_data.skulk_pos then
		return "done"
	end

	if arg_5_3 > skulk_data.attack_timer then
		arg_5_2.approach_target = true

		return "failed"
	end

	if PerceptionUtils.special_opportunity(arg_5_1, arg_5_2) > 0 then
		arg_5_2.approach_target = true

		return "failed"
	end

	local var_5_2 = POSITION_LOOKUP[arg_5_1]
	local unbox = skulk_data.skulk_pos:unbox()

	if Vector3.distance_squared(var_5_2, unbox) < 1 then
		skulk_data.skulk_pos = nil

		return "done"
	end

	return "running"
end

BTSkulkAroundAction.get_new_skulk_goal = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local conflict = Managers.state.conflict
	local get_main_paths = conflict.level_analysis:get_main_paths()
	local closest_pos_at_main_path, var_6_3, var_6_4 = MainPathUtils.closest_pos_at_main_path(get_main_paths, POSITION_LOOKUP[arg_6_1])
	local main_path_info = Managers.state.conflict.main_path_info
	local main_path_player_info = Managers.state.conflict.main_path_player_info
	local var_6_7
	local var_6_8
	local var_6_9

	if var_6_4 >= main_path_info.ahead_percent then
		local var_6_10 = POSITION_LOOKUP[main_path_info.ahead_unit]

		var_6_9 = 30
		var_6_8 = main_path_player_info[main_path_info.ahead_unit].travel_dist
	elseif var_6_4 <= main_path_info.behind_percent then
		local var_6_11 = POSITION_LOOKUP[main_path_info.behind_unit]

		var_6_9 = -20
		var_6_8 = main_path_player_info[main_path_info.behind_unit].travel_dist
	else
		local var_6_12 = POSITION_LOOKUP[main_path_info.ahead_unit]

		var_6_9 = 30
		var_6_8 = main_path_player_info[main_path_info.ahead_unit].travel_dist
	end

	local num = var_6_8 + var_6_9

	if not MainPathUtils.point_on_mainpath(get_main_paths, num) then
		num = var_6_8 - var_6_9

		local point_on_mainpath = MainPathUtils.point_on_mainpath(get_main_paths, num)
	end

	local spawn_zone_baker = conflict.spawn_zone_baker
	local clamp = math.clamp(math.floor((num + 5) / 10), 1, #spawn_zone_baker.zones)
	local var_6_17 = spawn_zone_baker.zones[clamp]
	local var_6_18
	local nearby_islands = var_6_17.nearby_islands

	if not nearby_islands then
		var_6_18 = nearby_islands[math.random(1, #nearby_islands)].sub[1]
	else
		local count = #var_6_17.sub
		local clamp_2 = math.clamp(count, 1, 2)

		var_6_18 = var_6_17.sub[clamp_2]
	end

	local var_6_22 = var_6_18[math.random(1, #var_6_18)]
	local var_6_23 = spawn_zone_baker.spawn_pos_lookup[var_6_22]

	while not var_6_23 do
		local var_6_24 = var_6_18[math.random(1, #var_6_18)]

		var_6_23 = spawn_zone_baker.spawn_pos_lookup[var_6_24]
	end

	return (Vector3(var_6_23[1], var_6_23[2], var_6_23[3]))
end
