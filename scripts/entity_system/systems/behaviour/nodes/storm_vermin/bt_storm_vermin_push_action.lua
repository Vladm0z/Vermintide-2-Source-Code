-- chunkname: @scripts/entity_system/systems/behaviour/nodes/storm_vermin/bt_storm_vermin_push_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTStormVerminPushAction = class(BTStormVerminPushAction, BTNode)

BTStormVerminPushAction.init = function (arg_1_0, ...)
	-- function 1
	BTStormVerminPushAction.super.init(arg_1_0, ...)
end

BTStormVerminPushAction.name = "BTStormVerminPushAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTStormVerminPushAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTStormVerminPushAction
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.attack_token = true

	local network = Managers.state.network
	local navigation_extension = arg_3_2.navigation_extension

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local target_unit = arg_3_2.target_unit

	arg_3_2.attacking_target = target_unit
	arg_3_2.move_state = "attacking"

	local var_3_4 = fn(action_data.attack_anim)

	network:anim_event(arg_3_1, var_3_4)

	arg_3_2.spawn_to_running = nil
	arg_3_2.wake_up_push = 0

	if not action_data.attack_finished_duration then
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local var_3_6 = action_data.attack_finished_duration[get_difficulty]

		if not var_3_6 then
			arg_3_2.attack_finished_t = arg_3_3 + Math.random_range(var_3_6[1], var_3_6[2])
		end
	end

	AiUtils.add_attack_intensity(target_unit, action_data, arg_3_2)
end

BTStormVerminPushAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.navigation_extension:set_enabled(true)

	arg_4_2.active_node = nil
	arg_4_2.attack_aborted = nil
	arg_4_2.attacking_target = nil
	arg_4_2.attack_finished = nil
	arg_4_2.attack_anim = nil
	arg_4_2.attack_finished_t = nil
	arg_4_2.attack_token = nil
end

BTStormVerminPushAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not arg_5_2.attack_aborted then
		Managers.state.network:anim_event(arg_5_1, "idle")

		return "done"
	elseif not arg_5_2.attack_finished_t and arg_5_3 > arg_5_2.attack_finished_t and arg_5_2.attack_finished and arg_5_2.attack_finished_t or not arg_5_2.attack_finished then
		return "done"
	else
		self:attack(arg_5_1, arg_5_3, arg_5_4, arg_5_2)

		return "running"
	end
end

BTStormVerminPushAction.attack = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local locomotion_extension = arg_6_4.locomotion_extension
	local attacking_target = arg_6_4.attacking_target

	if not Unit.alive(attacking_target) then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_6_1, attacking_target)

		locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	end
end

BTStormVerminPushAction.anim_cb_stormvermin_push = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not (not DamageUtils.check_distance(arg_7_2.action, arg_7_2, arg_7_1, arg_7_3) and DamageUtils.check_infront(arg_7_1, arg_7_3)) then
		return
	end

	local action = arg_7_2.action

	AiUtils.damage_target(arg_7_3, arg_7_1, action, action.damage)

	local has_extension = ScriptUnit.has_extension(arg_7_3, "status_system")

	if not (not has_extension and has_extension:is_disabled()) then
		StatusUtils.set_pushed_network(arg_7_3, true)

		local num = Quaternion.forward(Unit.local_rotation(arg_7_1, 0)) * action.impact_push_speed

		ScriptUnit.extension(arg_7_3, "locomotion_system"):add_external_velocity(num, action.max_impact_push_speed)
	end
end

BTStormVerminPushAction.anim_cb_attack_finished = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	arg_8_2.attack_finished = true
end
