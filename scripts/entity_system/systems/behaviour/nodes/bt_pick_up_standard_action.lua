-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pick_up_standard_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPickupStandardAction = class(BTPickupStandardAction, BTNode)

BTPickupStandardAction.init = function (arg_1_0, ...)
	-- function 1
	BTPickupStandardAction.super.init(arg_1_0, ...)
end

BTPickupStandardAction.name = "BTPickupStandardAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTPickupStandardAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	arg_3_2.action = self._tree_node.action_data
	arg_3_2.active_node = BTPickupStandardAction

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	local local_position = Unit.local_position(arg_3_2.standard_unit, 0)

	arg_3_2.navigation_extension:move_to(local_position)

	arg_3_2.standard_position_boxed = Vector3Box(local_position)
	arg_3_2.anim_cb_picked_up_standard = nil
	arg_3_2.moving_to_pick_up_standard = true

	Managers.state.network:anim_event(arg_3_1, "move_start_fwd")

	local has_extension = ScriptUnit.has_extension(arg_3_1, "ai_inventory_system")
	local num = 2

	has_extension:unwield_set(num)

	arg_3_2.move_state = "moving"
end

BTPickupStandardAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
	local navigation_extension = arg_4_2.navigation_extension

	navigation_extension:set_enabled(true)
	navigation_extension:set_max_speed(get_default_breed_move_speed)

	arg_4_2.active_node = nil
	arg_4_2.action = nil
	arg_4_2.picking_up_standard = nil
	arg_4_2.standard_position_boxed = nil
	arg_4_2.anim_cb_picked_up_standard = nil
	arg_4_2.moving_to_pick_up_standard = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

	arg_4_2.move_state = "idle"
end

BTPickupStandardAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not arg_5_2.anim_cb_picked_up_standard then
		return "done"
	end

	local unbox = arg_5_2.standard_position_boxed:unbox()
	local var_5_1 = POSITION_LOOKUP[arg_5_1]

	if not (not (Vector3.distance(unbox, var_5_1) < 1.5) or arg_5_2.picking_up_standard) then
		arg_5_2.locomotion_extension:use_lerp_rotation(false)

		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.standard_unit)

		arg_5_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)

		arg_5_2.picking_up_standard = true

		arg_5_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
		Managers.state.network:anim_event(arg_5_1, fn(arg_5_2.action.pick_up_standard_animation))
		arg_5_2.navigation_extension:set_enabled(false)
	end

	return "running"
end

BTPickupStandardAction.anim_cb_pick_up_standard = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	AiUtils.kill_unit(arg_6_2.standard_unit, arg_6_2.standard_unit, nil, nil, nil, "suicide")

	arg_6_2.standard_unit = nil
	arg_6_2.has_placed_standard = nil

	local has_extension = ScriptUnit.has_extension(arg_6_1, "ai_inventory_system")
	local num = 1

	has_extension:wield_item_set(num, true)

	arg_6_2.inventory_item_set = num

	if not arg_6_2.triggered_standard_chanting_sound then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_6_2.action.chanting_sound_event, arg_6_1)

		arg_6_2.triggered_standard_chanting_sound = true
	end
end
