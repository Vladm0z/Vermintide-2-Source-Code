-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_skulk_around_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSkulkAroundAction = class(BTSkulkAroundAction, BTNode)
BTSkulkAroundAction.name = "BTSkulkAroundAction"

local var_0_0 = POSITION_LOOKUP
local var_0_1 = script_data

function BTSkulkAroundAction.init(arg_1_0, ...)
	BTSkulkAroundAction.super.init(arg_1_0, ...)
end

local function var_0_2(arg_2_0, arg_2_1, arg_2_2)
	if var_0_1.debug_ai_movement then
		Debug.world_sticky_text(var_0_0[arg_2_0], arg_2_1, arg_2_2)
	end
end

function BTSkulkAroundAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if not arg_3_2.skulk_data then
		arg_3_2.skulk_data = {}
	end

	local var_3_0 = arg_3_2.skulk_data

	LocomotionUtils.set_animation_driven_movement(arg_3_1, false)

	local var_3_1 = Managers.state.network

	Managers.state.network:anim_event(arg_3_1, "idle")

	arg_3_2.move_state = "idle"

	arg_3_2.navigation_extension:set_max_speed(arg_3_2.breed.run_speed)
	arg_3_2.locomotion_extension:set_rotation_speed(5)

	if var_3_0.skulk_pos then
		local var_3_2 = var_3_0.skulk_pos:unbox()

		arg_3_2.navigation_extension:move_to(var_3_2)
	else
		local var_3_3 = arg_3_0:get_new_skulk_goal(arg_3_1, arg_3_2)

		var_3_0.skulk_pos = Vector3Box(var_3_3)

		arg_3_2.navigation_extension:move_to(var_3_3)
	end

	if not var_3_0.attack_timer or arg_3_3 > var_3_0.attack_timer then
		var_3_0.attack_timer = arg_3_3 + math.random(25, 30)
	end
end

function BTSkulkAroundAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(var_4_0)

	if arg_4_2.approach_target then
		arg_4_2.skulk_data.attack_timer = nil
	end
end

function BTSkulkAroundAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.skulk_data

	if arg_5_2.navigation_extension:is_following_path() then
		if arg_5_2.move_state ~= "moving" then
			Managers.state.network:anim_event(arg_5_1, "move_fwd")

			arg_5_2.move_state = "moving"
		end
	else
		if arg_5_2.l ~= "idle" then
			Managers.state.network:anim_event(arg_5_1, "idle")

			arg_5_2.move_state = "idle"
		end

		if arg_5_2.no_path_found then
			local var_5_1 = arg_5_0:get_new_skulk_goal(arg_5_1, arg_5_2)

			var_5_0.skulk_pos = Vector3Box(var_5_1)

			arg_5_2.navigation_extension:move_to(var_5_1)
		end
	end

	if not var_5_0.skulk_pos then
		return "done"
	end

	if arg_5_3 > var_5_0.attack_timer then
		arg_5_2.approach_target = true

		return "failed"
	end

	if PerceptionUtils.special_opportunity(arg_5_1, arg_5_2) > 0 then
		arg_5_2.approach_target = true

		return "failed"
	end

	local var_5_2 = POSITION_LOOKUP[arg_5_1]
	local var_5_3 = var_5_0.skulk_pos:unbox()

	if Vector3.distance_squared(var_5_2, var_5_3) < 1 then
		var_5_0.skulk_pos = nil

		return "done"
	end

	return "running"
end

function BTSkulkAroundAction.get_new_skulk_goal(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.state.conflict
	local var_6_1 = var_6_0.level_analysis:get_main_paths()
	local var_6_2, var_6_3, var_6_4 = MainPathUtils.closest_pos_at_main_path(var_6_1, POSITION_LOOKUP[arg_6_1])
	local var_6_5 = Managers.state.conflict.main_path_info
	local var_6_6 = Managers.state.conflict.main_path_player_info
	local var_6_7
	local var_6_8
	local var_6_9

	if var_6_4 >= var_6_5.ahead_percent then
		local var_6_10 = POSITION_LOOKUP[var_6_5.ahead_unit]

		var_6_9 = 30
		var_6_8 = var_6_6[var_6_5.ahead_unit].travel_dist
	elseif var_6_4 <= var_6_5.behind_percent then
		local var_6_11 = POSITION_LOOKUP[var_6_5.behind_unit]

		var_6_9 = -20
		var_6_8 = var_6_6[var_6_5.behind_unit].travel_dist
	else
		local var_6_12 = POSITION_LOOKUP[var_6_5.ahead_unit]

		var_6_9 = 30
		var_6_8 = var_6_6[var_6_5.ahead_unit].travel_dist
	end

	local var_6_13 = var_6_8 + var_6_9

	if not MainPathUtils.point_on_mainpath(var_6_1, var_6_13) then
		var_6_13 = var_6_8 - var_6_9

		local var_6_14 = MainPathUtils.point_on_mainpath(var_6_1, var_6_13)
	end

	local var_6_15 = var_6_0.spawn_zone_baker
	local var_6_16 = math.clamp(math.floor((var_6_13 + 5) / 10), 1, #var_6_15.zones)
	local var_6_17 = var_6_15.zones[var_6_16]
	local var_6_18
	local var_6_19 = var_6_17.nearby_islands

	if var_6_19 then
		var_6_18 = var_6_19[math.random(1, #var_6_19)].sub[1]
	else
		local var_6_20 = #var_6_17.sub
		local var_6_21 = math.clamp(var_6_20, 1, 2)

		var_6_18 = var_6_17.sub[var_6_21]
	end

	local var_6_22 = var_6_18[math.random(1, #var_6_18)]
	local var_6_23 = var_6_15.spawn_pos_lookup[var_6_22]

	while not var_6_23 do
		local var_6_24 = var_6_18[math.random(1, #var_6_18)]

		var_6_23 = var_6_15.spawn_pos_lookup[var_6_24]
	end

	return (Vector3(var_6_23[1], var_6_23[2], var_6_23[3]))
end
