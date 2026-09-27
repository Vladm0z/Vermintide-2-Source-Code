-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_ninja_vanish_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTNinjaVanishAction = class(BTNinjaVanishAction, BTNode)
BTNinjaVanishAction.name = "BTNinjaVanishAction"

local POSITION_LOOKUP = POSITION_LOOKUP
local script_data = script_data

BTNinjaVanishAction.init = function (arg_1_0, ...)
	-- function 1
	BTNinjaVanishAction.super.init(arg_1_0, ...)
end

local function fn(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if not script_data.debug_ai_movement then
		Debug.world_sticky_text(POSITION_LOOKUP[arg_2_0], arg_2_1, arg_2_2)
	end
end

BTNinjaVanishAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	arg_3_2.action = self._tree_node.action_data
	arg_3_2.vanish_timer = 0
	arg_3_2.skulk_pos = nil

	local find_escape_position = BTNinjaVanishAction.find_escape_position(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	if not find_escape_position then
		arg_3_2.vanish_pos = Vector3Box(find_escape_position)

		Managers.state.network:anim_event(arg_3_1, "foff_self")

		arg_3_2.vanish_timer = arg_3_3 + arg_3_2.action.foff_anim_length
	elseif arg_3_2.move_state ~= "idle" then
		Managers.state.network:anim_event(arg_3_1, "idle")

		arg_3_2.move_state = "idle"
	end
end

BTNinjaVanishAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.vanish_timer = nil
	arg_4_2.vanish_pos = nil
	arg_4_2.wait_one_frame = nil
	arg_4_2.ninja_vanish = false

	arg_4_2.navigation_extension:set_enabled(true)
end

BTNinjaVanishAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if arg_5_3 > arg_5_2.vanish_timer then
		if not arg_5_2.wait_one_frame then
			return "done"
		end

		if not arg_5_2.vanish_pos then
			BTNinjaVanishAction.vanish(arg_5_1, arg_5_2)
		end

		arg_5_2.wait_one_frame = true
	end

	return "running"
end

BTNinjaVanishAction.vanish = function (arg_6_0, arg_6_1)
	-- function 6
	local unbox = arg_6_1.vanish_pos:unbox()

	if not script_data.debug_ai_movement then
		QuickDrawerStay:cylinder(unbox, unbox + Vector3(0, 0, 17), 0.4, Color(200, 0, 131), 20)
		QuickDrawerStay:line(POSITION_LOOKUP[arg_6_0] + Vector3(0, 0, 4), unbox + Vector3(0, 0, 17), Color(200, 0, 131))
	end

	local network = Managers.state.network

	BTNinjaVanishAction.play_foff(arg_6_0, arg_6_1, network, POSITION_LOOKUP[arg_6_0], unbox)
	network:anim_event(arg_6_0, "idle")
	arg_6_1.locomotion_extension:teleport_to(unbox)
	arg_6_1.navigation_extension:move_to(unbox)
	arg_6_1.locomotion_extension:set_wanted_velocity(Vector3.zero())
	Managers.state.entity:system("ai_bot_group_system"):enemy_teleported(arg_6_0, unbox)
	Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_6_0)
end

BTNinjaVanishAction.play_foff = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local var_7_0 = NetworkLookup.effects[arg_7_1.action.effect_name]
	local unit_game_object_id = arg_7_2:unit_game_object_id(arg_7_0)
	local num = 0
	local identity = Quaternion.identity()

	arg_7_2:rpc_play_particle_effect(nil, var_7_0, NetworkConstants.invalid_game_object_id, num, arg_7_3, identity, false)
	arg_7_2:rpc_play_particle_effect(nil, var_7_0, NetworkConstants.invalid_game_object_id, num, arg_7_4, identity, false)
end

BTNinjaVanishAction.find_escape_position = function (arg_8_0, arg_8_1)
	-- function 8
	local var_8_0

	if not arg_8_1.action.stalk_lonliest_player then
		local side = arg_8_1.side
		local get_cluster_and_loneliness, var_8_3, var_8_4 = Managers.state.conflict:get_cluster_and_loneliness(7, side.ENEMY_PLAYER_POSITIONS, side.ENEMY_PLAYER_UNITS)

		var_8_0 = var_8_3
	else
		var_8_0 = POSITION_LOOKUP[arg_8_0]
	end

	local num = 0
	local var_8_6

	if not var_8_0 then
		local side_2 = arg_8_1.side

		num, var_8_6 = ConflictUtils.hidden_cover_points(var_8_0, side_2.ENEMY_PLAYER_POSITIONS, 15, 40)
	end

	if num > 0 then
		local var_8_8 = var_8_6[math.random(math.ceil(num / 2), num)]

		if not var_8_8 then
			return Unit.local_position(var_8_8, 0)
		end
	else
		local conflict = Managers.state.conflict
		local main_path_info = conflict.main_path_info
		local ahead_unit = main_path_info.ahead_unit

		if not POSITION_LOOKUP[ahead_unit] then
			local var_8_12 = conflict.main_path_player_info[ahead_unit]
			local point_on_mainpath, var_8_14 = MainPathUtils.point_on_mainpath(main_path_info.main_paths, var_8_12.travel_dist + 30 + math.random() * 10)

			return point_on_mainpath
		else
			return (MainPathUtils.closest_pos_at_main_path(main_path_info.main_paths, POSITION_LOOKUP[arg_8_0]))
		end
	end
end
