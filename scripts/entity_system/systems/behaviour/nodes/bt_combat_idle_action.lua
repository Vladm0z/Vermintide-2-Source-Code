-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_combat_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCombatIdleAction = class(BTCombatIdleAction, BTNode)

function BTCombatIdleAction.init(arg_1_0, ...)
	BTCombatIdleAction.super.init(arg_1_0, ...)
end

BTCombatIdleAction.name = "BTCombatIdleAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function BTCombatIdleAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0:_check_if_should_idle(arg_3_1, arg_3_2)
	arg_3_2.navigation_extension:set_enabled(true)
end

function BTCombatIdleAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.combat_idling = nil
end

local var_0_1 = 0.0001

function BTCombatIdleAction._check_if_should_idle(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_2.combat_idling then
		local var_5_0 = arg_5_2.locomotion_extension

		if Vector3.length_squared(var_5_0:current_velocity()) < var_0_1 then
			arg_5_2.combat_idling = true

			arg_5_0:_init_idle_anim(arg_5_1, arg_5_2)
		end
	end
end

function BTCombatIdleAction._init_idle_anim(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.state.network
	local var_6_1 = "idle"
	local var_6_2 = arg_6_0._tree_node.action_data

	arg_6_2.action = var_6_2

	if var_6_2 and var_6_2.alerted_anims and arg_6_2.confirmed_player_sighting then
		var_6_1 = var_6_2.alerted_anims[math.random(1, #var_6_2.alerted_anims)]
	elseif var_6_2 and var_6_2.idle_animation then
		var_6_1 = var_0_0(var_6_2.idle_animation)
	elseif arg_6_2.is_passive and arg_6_2.spawn_type ~= "horde" and arg_6_2.spawn_type ~= "horde_hidden" then
		if var_6_2 and var_6_2.animations then
			local var_6_3 = var_6_2.animations
			local var_6_4 = var_6_2.anim_cycle_index % #var_6_3 + 1

			var_6_1 = var_6_3[var_6_4]
			var_6_2.anim_cycle_index = var_6_4
		end
	elseif var_6_2 and var_6_2.combat_animations then
		local var_6_5 = var_6_2.combat_animations
		local var_6_6 = var_6_2.anim_cycle_index % #var_6_5 + 1

		var_6_1 = var_6_5[var_6_6]
		var_6_2.anim_cycle_index = var_6_6
	end

	local var_6_7 = arg_6_2.optional_spawn_data
	local var_6_8 = var_6_7 and var_6_7.idle_animation

	if var_6_8 and var_6_8 ~= "" then
		var_6_1 = var_6_8
	end

	if arg_6_2.move_state ~= "idle" or var_6_2 and var_6_2.force_idle_animation then
		var_6_0:anim_event(arg_6_1, var_6_1)

		arg_6_2.move_state = "idle"
	end

	arg_6_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

local var_0_2 = Unit.alive

function BTCombatIdleAction.run(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	arg_7_0:_check_if_should_idle(arg_7_1, arg_7_2)

	local var_7_0 = arg_7_2.target_unit

	if var_0_2(var_7_0) then
		local var_7_1 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, var_7_0)

		arg_7_2.locomotion_extension:set_wanted_rotation(var_7_1)
	end

	return "running"
end
