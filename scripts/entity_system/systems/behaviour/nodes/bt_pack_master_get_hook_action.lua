-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_get_hook_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterGetHookAction = class(BTPackMasterGetHookAction, BTNode)
BTPackMasterGetHookAction.name = "BTPackMasterGetHookAction"

local num = 10
local num_2 = 1
local num_3 = 2

BTPackMasterGetHookAction.init = function (self, ...)
	-- function 1
	BTPackMasterGetHookAction.super.init(self, ...)

	self.navigation_group_manager = Managers.state.conflict.navigation_group_manager
end

BTPackMasterGetHookAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	if not arg_2_2.best_cover then
		arg_2_2.end_time = arg_2_3 + 10

		arg_2_2.navigation_extension:move_to(POSITION_LOOKUP[arg_2_1])
	end

	Managers.state.network:anim_event(arg_2_1, "run_away")

	arg_2_2.move_state = "moving"
end

BTPackMasterGetHookAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if arg_3_4 == "done" then
		AiUtils.show_polearm(arg_3_1, true)

		arg_3_2.needs_hook = nil
		arg_3_2.best_cover = nil
		arg_3_2.best_cover_score = nil
	end

	Managers.state.network:anim_event(arg_3_1, "move_fwd")
end

BTPackMasterGetHookAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local average_player_position = ConflictUtils.average_player_position()

	if average_player_position == nil then
		return "failed"
	end

	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local nav_world = arg_4_2.nav_world

	if not arg_4_2.navigation_extension:has_reached_destination(1) then
		if arg_4_3 > arg_4_2.end_time then
			return "done"
		end

		self:find_hidden_cover(var_4_1, average_player_position, arg_4_2)

		if not arg_4_2.best_cover then
			return "done"
		end

		if arg_4_2.best_cover_score < 0 then
			return "done"
		end

		arg_4_2.navigation_extension:move_to(arg_4_2.best_cover:unbox())
	end

	if not script_data.debug_ai_movement and not arg_4_2.best_cover then
		local unbox = arg_4_2.best_cover:unbox()
		local num = unbox + Vector3(0, 0, 15)

		QuickDrawer:sphere(unbox, 0.75, Color(255, 0, 150), 6)
		QuickDrawer:line(unbox, num, Color(255, 0, 150))
		QuickDrawer:sphere(num, 0.75, Color(255, 0, 150), 6)
	end

	return "running"
end

BTPackMasterGetHookAction.find_hidden_cover = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	arg_5_3.best_cover_score = -math.huge
	arg_5_3.best_cover = nil

	local alloc_table = FrameTable.alloc_table()
	local normalize = Vector3.normalize(arg_5_1 - arg_5_2)
	local num = 19
	local num_2 = 5
	local local_position = Unit.local_position
	local distance_squared = Vector3.distance_squared
	local distance = Vector3.distance
	local normalize_2 = Vector3.normalize
	local dot = Vector3.dot
	local max = math.max
	local cover_points_broadphase = Managers.state.conflict.level_analysis.cover_points_broadphase
	local query = Broadphase.query(cover_points_broadphase, arg_5_1, num, alloc_table)
	local num_3 = num_2 * num_2
	local num_4 = num * num

	if not script_data.debug_ai_movement then
		QuickDrawerStay:sphere(arg_5_2, 2, Colors.get("cyan"))
		QuickDrawerStay:vector(arg_5_2, normalize * 4, Colors.get("cyan"))
	end

	local min = math.min(query, 15)

	for i = 1, min do
		local var_5_15 = alloc_table[i]
		local var_5_16 = local_position(var_5_15, 0)
		local var_5_17 = distance_squared(var_5_16, arg_5_1)

		if not (not (num_3 <= var_5_17) or not (var_5_17 < num_4)) then
			local local_rotation = Unit.local_rotation(var_5_15, 0)
			local num_5 = var_5_16 - arg_5_1
			local var_5_20 = dot(num_5, normalize)
			local var_5_21 = dot(Quaternion.forward(local_rotation), -normalize)

			if not (not (var_5_20 > arg_5_3.best_cover_score) or not (var_5_21 > 0)) then
				arg_5_3.best_cover_score = var_5_20
				arg_5_3.best_cover = Vector3Box(var_5_16)
			end

			if not script_data.debug_ai_movement then
				local var_5_22 = Color(255, 255 * max(-var_5_20, 0), 255 * max(var_5_20, 0), 255 * max(0, var_5_21))

				QuickDrawerStay:sphere(var_5_16, 1, var_5_22)
				QuickDrawerStay:line(var_5_16 + Vector3(0, 0, 1), var_5_16 + Quaternion.forward(local_rotation) * 2 + Vector3(0, 0, 1), var_5_22)
			end
		end
	end
end
