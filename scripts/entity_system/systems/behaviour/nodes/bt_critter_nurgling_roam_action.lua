-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_critter_nurgling_roam_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCritterNurglingRoamAction = class(BTCritterNurglingRoamAction, BTNode)

BTCritterNurglingRoamAction.init = function (arg_1_0, ...)
	-- function 1
	BTCritterNurglingRoamAction.super.init(arg_1_0, ...)
end

BTCritterNurglingRoamAction.name = "BTCritterNurglingRoamAction"

BTCritterNurglingRoamAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.walk_speed)

	arg_2_2.action = self._tree_node.action_data

	self:start_idle_animation(arg_2_1, arg_2_2)
end

BTCritterNurglingRoamAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.navigation_extension:set_max_speed(arg_3_2.breed.run_speed)
	self:start_idle_animation(arg_3_1, arg_3_2)

	arg_3_2.move_pos = nil
	arg_3_2.idle = nil
	arg_3_2.wait_time = nil
	arg_3_2.action = nil
end

BTCritterNurglingRoamAction.run = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local action = arg_4_2.action
	local navigation_extension = arg_4_2.navigation_extension

	if not arg_4_2.move_pos then
		local find_move_pos = self:find_move_pos(arg_4_2, action)

		if not find_move_pos then
			arg_4_2.move_pos = Vector3Box(find_move_pos)

			navigation_extension:move_to(find_move_pos)
		end
	end

	if navigation_extension:number_failed_move_attempts() > 0 then
		arg_4_2.move_pos = nil

		if arg_4_2.move_state ~= "idle" then
			self:start_idle_animation(arg_4_1, arg_4_2)
		end

		return "running"
	end

	if not (not navigation_extension:is_following_path() and arg_4_2.move_state == "moving") then
		self:start_move_animation(arg_4_1, arg_4_2)
	end

	if not navigation_extension:has_reached_destination() then
		return self:try_exit_state(arg_4_1, arg_4_2, action, arg_4_3)
	end

	return "running"
end

BTCritterNurglingRoamAction.find_move_pos = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local find_move_pos = arg_5_2.find_move_pos
	local unbox = arg_5_1.altar_pos:unbox()

	return ConflictUtils.get_spawn_pos_on_circle(nav_world, unbox, find_move_pos.radius, find_move_pos.spread, find_move_pos.tries)
end

BTCritterNurglingRoamAction.start_move_animation = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	Managers.state.network:anim_event(arg_6_1, "walk")

	arg_6_2.move_state = "moving"
end

BTCritterNurglingRoamAction.start_idle_animation = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	Managers.state.network:anim_event(arg_7_1, "idle")

	arg_7_2.move_state = "idle"
end

BTCritterNurglingRoamAction.try_exit_state = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	if not self:has_overlap(arg_8_1, arg_8_2, arg_8_3) then
		arg_8_2.move_pos = nil

		return "running"
	end

	return "done"
end

local tbl = {}

BTCritterNurglingRoamAction.has_overlap = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	if not arg_9_2.move_pos then
		return true
	end

	return Broadphase.query(arg_9_2.group_blackboard.broadphase, arg_9_2.move_pos:unbox(), arg_9_3.check_overlap_radius, tbl) > 1
end
