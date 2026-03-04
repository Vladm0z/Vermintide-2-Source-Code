-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_ninja_vanish_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTNinjaVanishAction = class(BTNinjaVanishAction, BTNode)
BTNinjaVanishAction.name = "BTNinjaVanishAction"

local var_0_0 = POSITION_LOOKUP
local var_0_1 = script_data

BTNinjaVanishAction.init = function (arg_1_0, ...)
	BTNinjaVanishAction.super.init(arg_1_0, ...)
end

local function var_0_2(arg_2_0, arg_2_1, arg_2_2)
	if var_0_1.debug_ai_movement then
		Debug.world_sticky_text(var_0_0[arg_2_0], arg_2_1, arg_2_2)
	end
end

BTNinjaVanishAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_2.action = arg_3_0._tree_node.action_data
	arg_3_2.vanish_timer = 0
	arg_3_2.skulk_pos = nil

	local var_3_0 = BTNinjaVanishAction.find_escape_position(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	if var_3_0 then
		arg_3_2.vanish_pos = Vector3Box(var_3_0)

		Managers.state.network:anim_event(arg_3_1, "foff_self")

		arg_3_2.vanish_timer = arg_3_3 + arg_3_2.action.foff_anim_length
	elseif arg_3_2.move_state ~= "idle" then
		Managers.state.network:anim_event(arg_3_1, "idle")

		arg_3_2.move_state = "idle"
	end
end

BTNinjaVanishAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.vanish_timer = nil
	arg_4_2.vanish_pos = nil
	arg_4_2.wait_one_frame = nil
	arg_4_2.ninja_vanish = false

	arg_4_2.navigation_extension:set_enabled(true)
end

BTNinjaVanishAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_3 > arg_5_2.vanish_timer then
		if arg_5_2.wait_one_frame then
			return "done"
		end

		if arg_5_2.vanish_pos then
			BTNinjaVanishAction.vanish(arg_5_1, arg_5_2)
		end

		arg_5_2.wait_one_frame = true
	end

	return "running"
end

BTNinjaVanishAction.vanish = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.vanish_pos:unbox()

	if var_0_1.debug_ai_movement then
		QuickDrawerStay:cylinder(var_6_0, var_6_0 + Vector3(0, 0, 17), 0.4, Color(200, 0, 131), 20)
		QuickDrawerStay:line(var_0_0[arg_6_0] + Vector3(0, 0, 4), var_6_0 + Vector3(0, 0, 17), Color(200, 0, 131))
	end

	local var_6_1 = Managers.state.network

	BTNinjaVanishAction.play_foff(arg_6_0, arg_6_1, var_6_1, var_0_0[arg_6_0], var_6_0)
	var_6_1:anim_event(arg_6_0, "idle")
	arg_6_1.locomotion_extension:teleport_to(var_6_0)
	arg_6_1.navigation_extension:move_to(var_6_0)
	arg_6_1.locomotion_extension:set_wanted_velocity(Vector3.zero())
	Managers.state.entity:system("ai_bot_group_system"):enemy_teleported(arg_6_0, var_6_0)
	Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_6_0)
end

BTNinjaVanishAction.play_foff = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = NetworkLookup.effects[arg_7_1.action.effect_name]
	local var_7_1 = arg_7_2:unit_game_object_id(arg_7_0)
	local var_7_2 = 0
	local var_7_3 = Quaternion.identity()

	arg_7_2:rpc_play_particle_effect(nil, var_7_0, NetworkConstants.invalid_game_object_id, var_7_2, arg_7_3, var_7_3, false)
	arg_7_2:rpc_play_particle_effect(nil, var_7_0, NetworkConstants.invalid_game_object_id, var_7_2, arg_7_4, var_7_3, false)
end

BTNinjaVanishAction.find_escape_position = function (arg_8_0, arg_8_1)
	local var_8_0

	if arg_8_1.action.stalk_lonliest_player then
		local var_8_1 = arg_8_1.side
		local var_8_2, var_8_3, var_8_4 = Managers.state.conflict:get_cluster_and_loneliness(7, var_8_1.ENEMY_PLAYER_POSITIONS, var_8_1.ENEMY_PLAYER_UNITS)

		var_8_0 = var_8_3
	else
		var_8_0 = var_0_0[arg_8_0]
	end

	local var_8_5 = 0
	local var_8_6

	if var_8_0 then
		local var_8_7 = arg_8_1.side

		var_8_5, var_8_6 = ConflictUtils.hidden_cover_points(var_8_0, var_8_7.ENEMY_PLAYER_POSITIONS, 15, 40)
	end

	if var_8_5 > 0 then
		local var_8_8 = var_8_6[math.random(math.ceil(var_8_5 / 2), var_8_5)]

		if var_8_8 then
			return Unit.local_position(var_8_8, 0)
		end
	else
		local var_8_9 = Managers.state.conflict
		local var_8_10 = var_8_9.main_path_info
		local var_8_11 = var_8_10.ahead_unit

		if var_0_0[var_8_11] then
			local var_8_12 = var_8_9.main_path_player_info[var_8_11]
			local var_8_13, var_8_14 = MainPathUtils.point_on_mainpath(var_8_10.main_paths, var_8_12.travel_dist + 30 + math.random() * 10)

			return var_8_13
		else
			return (MainPathUtils.closest_pos_at_main_path(var_8_10.main_paths, var_0_0[arg_8_0]))
		end
	end
end
