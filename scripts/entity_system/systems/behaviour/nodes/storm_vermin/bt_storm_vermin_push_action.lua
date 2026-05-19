-- chunkname: @scripts/entity_system/systems/behaviour/nodes/storm_vermin/bt_storm_vermin_push_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTStormVerminPushAction = class(BTStormVerminPushAction, BTNode)

function BTStormVerminPushAction.init(arg_1_0, ...)
	BTStormVerminPushAction.super.init(arg_1_0, ...)
end

BTStormVerminPushAction.name = "BTStormVerminPushAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function BTStormVerminPushAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTStormVerminPushAction
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.attack_token = true

	local var_3_1 = Managers.state.network
	local var_3_2 = arg_3_2.navigation_extension

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_3_3 = arg_3_2.target_unit

	arg_3_2.attacking_target = var_3_3
	arg_3_2.move_state = "attacking"

	local var_3_4 = var_0_0(var_3_0.attack_anim)

	var_3_1:anim_event(arg_3_1, var_3_4)

	arg_3_2.spawn_to_running = nil
	arg_3_2.wake_up_push = 0

	if var_3_0.attack_finished_duration then
		local var_3_5 = Managers.state.difficulty:get_difficulty()
		local var_3_6 = var_3_0.attack_finished_duration[var_3_5]

		if var_3_6 then
			arg_3_2.attack_finished_t = arg_3_3 + Math.random_range(var_3_6[1], var_3_6[2])
		end
	end

	AiUtils.add_attack_intensity(var_3_3, var_3_0, arg_3_2)
end

function BTStormVerminPushAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.navigation_extension:set_enabled(true)

	arg_4_2.active_node = nil
	arg_4_2.attack_aborted = nil
	arg_4_2.attacking_target = nil
	arg_4_2.attack_finished = nil
	arg_4_2.attack_anim = nil
	arg_4_2.attack_finished_t = nil
	arg_4_2.attack_token = nil
end

function BTStormVerminPushAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_2.attack_aborted then
		Managers.state.network:anim_event(arg_5_1, "idle")

		return "done"
	elseif arg_5_2.attack_finished_t and arg_5_3 > arg_5_2.attack_finished_t and arg_5_2.attack_finished or not arg_5_2.attack_finished_t and arg_5_2.attack_finished then
		return "done"
	else
		arg_5_0:attack(arg_5_1, arg_5_3, arg_5_4, arg_5_2)

		return "running"
	end
end

function BTStormVerminPushAction.attack(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_4.locomotion_extension
	local var_6_1 = arg_6_4.attacking_target

	if Unit.alive(var_6_1) then
		local var_6_2 = LocomotionUtils.rotation_towards_unit_flat(arg_6_1, var_6_1)

		var_6_0:set_wanted_rotation(var_6_2)
	end
end

function BTStormVerminPushAction.anim_cb_stormvermin_push(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if not DamageUtils.check_distance(arg_7_2.action, arg_7_2, arg_7_1, arg_7_3) or not DamageUtils.check_infront(arg_7_1, arg_7_3) then
		return
	end

	local var_7_0 = arg_7_2.action

	AiUtils.damage_target(arg_7_3, arg_7_1, var_7_0, var_7_0.damage)

	local var_7_1 = ScriptUnit.has_extension(arg_7_3, "status_system")

	if var_7_1 and not var_7_1:is_disabled() then
		StatusUtils.set_pushed_network(arg_7_3, true)

		local var_7_2 = Quaternion.forward(Unit.local_rotation(arg_7_1, 0)) * var_7_0.impact_push_speed

		ScriptUnit.extension(arg_7_3, "locomotion_system"):add_external_velocity(var_7_2, var_7_0.max_impact_push_speed)
	end
end

function BTStormVerminPushAction.anim_cb_attack_finished(arg_8_0, arg_8_1, arg_8_2)
	arg_8_2.attack_finished = true
end
