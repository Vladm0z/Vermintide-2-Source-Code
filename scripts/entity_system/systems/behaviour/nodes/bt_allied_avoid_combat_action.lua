-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_allied_avoid_combat_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTAlliedAvoidCombatAction = class(BTAlliedAvoidCombatAction, BTNode)

BTAlliedAvoidCombatAction.init = function (arg_1_0, ...)
	-- function 1
	BTAlliedAvoidCombatAction.super.init(arg_1_0, ...)
end

BTAlliedAvoidCombatAction.name = "BTAlliedAvoidCombatAction"

BTAlliedAvoidCombatAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.target_status_extension = ScriptUnit.extension(arg_2_2.player_controller_unit, "status_system")

	local var_2_0 = POSITION_LOOKUP[arg_2_1]
	local var_2_1 = POSITION_LOOKUP[arg_2_2.player_controller_unit]
	local flag = LocomotionUtils.pos_on_mesh(arg_2_2.nav_world, var_2_1, 1, 1) or var_2_0

	arg_2_2.wanted_flee_pos = Vector3Box(flag)

	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)
end

BTAlliedAvoidCombatAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(get_default_breed_move_speed)
	Unit.set_unit_visibility(arg_3_1, true)

	if not arg_3_2.player_controller_unit then
		local var_3_1 = POSITION_LOOKUP[arg_3_2.player_controller_unit]

		arg_3_2.locomotion_extension:teleport_to(var_3_1)
	end

	arg_3_2.wanted_flee_pos = nil
end

BTAlliedAvoidCombatAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local locomotion_extension = arg_4_2.locomotion_extension

	self:flee(arg_4_1, arg_4_3, arg_4_4, arg_4_2, locomotion_extension)

	return "running", "evaluate"
end

BTAlliedAvoidCombatAction._go_idle = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	arg_5_2.move_state = "idle"

	local action = arg_5_2.action
	local network = Managers.state.network
	local var_5_2 = network
	local anim_event = network.anim_event
	local var_5_4 = arg_5_1
	local idle_anim = action.idle_anim

	idle_anim = idle_anim or "idle"

	anim_event(var_5_2, var_5_4, idle_anim)
	Unit.set_unit_visibility(arg_5_1, false)
end

BTAlliedAvoidCombatAction._go_moving = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_2.move_state = "moving"

	Managers.state.network:anim_event(arg_6_1, arg_6_3.move_anim)
end

BTAlliedAvoidCombatAction.flee = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local action = arg_7_4.action
	local navigation_extension = arg_7_4.navigation_extension

	self:_move_to_flee_location(arg_7_1, arg_7_4, arg_7_2, arg_7_3)

	local num = navigation_extension:destination() - POSITION_LOOKUP[arg_7_1]

	Vector3.set_z(num, 0)

	local length_squared = Vector3.length_squared(num)
	local is_following_path = navigation_extension:is_following_path()

	if not ((arg_7_4.move_state == "moving" or not is_following_path) and not (length_squared > 0.25)) then
		self:_go_moving(arg_7_1, arg_7_4, action)
	elseif not (arg_7_4.move_state == "idle" or not is_following_path or not (length_squared < 0.04000000000000001)) then
		self:_go_idle(arg_7_1, arg_7_4, arg_7_5)
	end

	local target_status_extension = arg_7_4.target_status_extension

	target_status_extension = not target_status_extension and arg_7_4.target_status_extension:get_pacing_intensity()
	arg_7_4.target_is_in_combat = not target_status_extension and target_status_extension > 0
end

BTAlliedAvoidCombatAction._move_to_flee_location = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local navigation_extension = arg_8_2.navigation_extension
	local unbox = arg_8_2.wanted_flee_pos:unbox()

	navigation_extension:move_to(unbox)
end
