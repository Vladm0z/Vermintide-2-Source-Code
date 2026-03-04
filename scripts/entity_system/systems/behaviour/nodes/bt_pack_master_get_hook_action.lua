-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_get_hook_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterGetHookAction = class(BTPackMasterGetHookAction, BTNode)
BTPackMasterGetHookAction.name = "BTPackMasterGetHookAction"

local var_0_0 = 10
local var_0_1 = 1
local var_0_2 = 2

function BTPackMasterGetHookAction.init(arg_1_0, ...)
	BTPackMasterGetHookAction.super.init(arg_1_0, ...)

	arg_1_0.navigation_group_manager = Managers.state.conflict.navigation_group_manager
end

function BTPackMasterGetHookAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if not arg_2_2.best_cover then
		arg_2_2.end_time = arg_2_3 + 10

		arg_2_2.navigation_extension:move_to(POSITION_LOOKUP[arg_2_1])
	end

	Managers.state.network:anim_event(arg_2_1, "run_away")

	arg_2_2.move_state = "moving"
end

function BTPackMasterGetHookAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_4 == "done" then
		AiUtils.show_polearm(arg_3_1, true)

		arg_3_2.needs_hook = nil
		arg_3_2.best_cover = nil
		arg_3_2.best_cover_score = nil
	end

	Managers.state.network:anim_event(arg_3_1, "move_fwd")
end

function BTPackMasterGetHookAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = ConflictUtils.average_player_position()

	if var_4_0 == nil then
		return "failed"
	end

	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local var_4_2 = arg_4_2.nav_world

	if arg_4_2.navigation_extension:has_reached_destination(1) then
		if arg_4_3 > arg_4_2.end_time then
			return "done"
		end

		arg_4_0:find_hidden_cover(var_4_1, var_4_0, arg_4_2)

		if not arg_4_2.best_cover then
			return "done"
		end

		if arg_4_2.best_cover_score < 0 then
			return "done"
		end

		arg_4_2.navigation_extension:move_to(arg_4_2.best_cover:unbox())
	end

	if script_data.debug_ai_movement and arg_4_2.best_cover then
		local var_4_3 = arg_4_2.best_cover:unbox()
		local var_4_4 = var_4_3 + Vector3(0, 0, 15)

		QuickDrawer:sphere(var_4_3, 0.75, Color(255, 0, 150), 6)
		QuickDrawer:line(var_4_3, var_4_4, Color(255, 0, 150))
		QuickDrawer:sphere(var_4_4, 0.75, Color(255, 0, 150), 6)
	end

	return "running"
end

function BTPackMasterGetHookAction.find_hidden_cover(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_3.best_cover_score = -math.huge
	arg_5_3.best_cover = nil

	local var_5_0 = FrameTable.alloc_table()
	local var_5_1 = Vector3.normalize(arg_5_1 - arg_5_2)
	local var_5_2 = 19
	local var_5_3 = 5
	local var_5_4 = Unit.local_position
	local var_5_5 = Vector3.distance_squared
	local var_5_6 = Vector3.distance
	local var_5_7 = Vector3.normalize
	local var_5_8 = Vector3.dot
	local var_5_9 = math.max
	local var_5_10 = Managers.state.conflict.level_analysis.cover_points_broadphase
	local var_5_11 = Broadphase.query(var_5_10, arg_5_1, var_5_2, var_5_0)
	local var_5_12 = var_5_3 * var_5_3
	local var_5_13 = var_5_2 * var_5_2

	if script_data.debug_ai_movement then
		QuickDrawerStay:sphere(arg_5_2, 2, Colors.get("cyan"))
		QuickDrawerStay:vector(arg_5_2, var_5_1 * 4, Colors.get("cyan"))
	end

	local var_5_14 = math.min(var_5_11, 15)

	for iter_5_0 = 1, var_5_14 do
		local var_5_15 = var_5_0[iter_5_0]
		local var_5_16 = var_5_4(var_5_15, 0)
		local var_5_17 = var_5_5(var_5_16, arg_5_1)

		if var_5_12 <= var_5_17 and var_5_17 < var_5_13 then
			local var_5_18 = Unit.local_rotation(var_5_15, 0)
			local var_5_19 = var_5_16 - arg_5_1
			local var_5_20 = var_5_8(var_5_19, var_5_1)
			local var_5_21 = var_5_8(Quaternion.forward(var_5_18), -var_5_1)

			if var_5_20 > arg_5_3.best_cover_score and var_5_21 > 0 then
				arg_5_3.best_cover_score = var_5_20
				arg_5_3.best_cover = Vector3Box(var_5_16)
			end

			if script_data.debug_ai_movement then
				local var_5_22 = Color(255, 255 * var_5_9(-var_5_20, 0), 255 * var_5_9(var_5_20, 0), 255 * var_5_9(0, var_5_21))

				QuickDrawerStay:sphere(var_5_16, 1, var_5_22)
				QuickDrawerStay:line(var_5_16 + Vector3(0, 0, 1), var_5_16 + Quaternion.forward(var_5_18) * 2 + Vector3(0, 0, 1), var_5_22)
			end
		end
	end
end
