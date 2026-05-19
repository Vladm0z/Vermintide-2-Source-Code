-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pick_up_standard_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPickupStandardAction = class(BTPickupStandardAction, BTNode)

function BTPickupStandardAction.init(arg_1_0, ...)
	BTPickupStandardAction.super.init(arg_1_0, ...)
end

BTPickupStandardAction.name = "BTPickupStandardAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function BTPickupStandardAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_2.action = arg_3_0._tree_node.action_data
	arg_3_2.active_node = BTPickupStandardAction

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	local var_3_0 = Unit.local_position(arg_3_2.standard_unit, 0)

	arg_3_2.navigation_extension:move_to(var_3_0)

	arg_3_2.standard_position_boxed = Vector3Box(var_3_0)
	arg_3_2.anim_cb_picked_up_standard = nil
	arg_3_2.moving_to_pick_up_standard = true

	Managers.state.network:anim_event(arg_3_1, "move_start_fwd")

	local var_3_1 = ScriptUnit.has_extension(arg_3_1, "ai_inventory_system")
	local var_3_2 = 2

	var_3_1:unwield_set(var_3_2)

	arg_3_2.move_state = "moving"
end

function BTPickupStandardAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
	local var_4_1 = arg_4_2.navigation_extension

	var_4_1:set_enabled(true)
	var_4_1:set_max_speed(var_4_0)

	arg_4_2.active_node = nil
	arg_4_2.action = nil
	arg_4_2.picking_up_standard = nil
	arg_4_2.standard_position_boxed = nil
	arg_4_2.anim_cb_picked_up_standard = nil
	arg_4_2.moving_to_pick_up_standard = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

	arg_4_2.move_state = "idle"
end

function BTPickupStandardAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_2.anim_cb_picked_up_standard then
		return "done"
	end

	local var_5_0 = arg_5_2.standard_position_boxed:unbox()
	local var_5_1 = POSITION_LOOKUP[arg_5_1]

	if Vector3.distance(var_5_0, var_5_1) < 1.5 and not arg_5_2.picking_up_standard then
		arg_5_2.locomotion_extension:use_lerp_rotation(false)

		local var_5_2 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.standard_unit)

		arg_5_2.locomotion_extension:set_wanted_rotation(var_5_2)

		arg_5_2.picking_up_standard = true

		arg_5_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
		Managers.state.network:anim_event(arg_5_1, var_0_0(arg_5_2.action.pick_up_standard_animation))
		arg_5_2.navigation_extension:set_enabled(false)
	end

	return "running"
end

function BTPickupStandardAction.anim_cb_pick_up_standard(arg_6_0, arg_6_1, arg_6_2)
	AiUtils.kill_unit(arg_6_2.standard_unit, arg_6_2.standard_unit, nil, nil, nil, "suicide")

	arg_6_2.standard_unit = nil
	arg_6_2.has_placed_standard = nil

	local var_6_0 = ScriptUnit.has_extension(arg_6_1, "ai_inventory_system")
	local var_6_1 = 1

	var_6_0:wield_item_set(var_6_1, true)

	arg_6_2.inventory_item_set = var_6_1

	if not arg_6_2.triggered_standard_chanting_sound then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_6_2.action.chanting_sound_event, arg_6_1)

		arg_6_2.triggered_standard_chanting_sound = true
	end
end
