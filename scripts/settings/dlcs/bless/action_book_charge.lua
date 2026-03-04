-- chunkname: @scripts/settings/dlcs/bless/action_book_charge.lua

ActionBookCharge = class(ActionBookCharge, ActionMeleeStart)

local var_0_0 = Unit.set_flow_variable
local var_0_1 = Unit.flow_event

ActionBookCharge.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionBookCharge.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	arg_1_0.owner_unit = arg_1_4

	local var_1_0, var_1_1 = arg_1_0.inventory_extension:get_all_weapon_unit()

	arg_1_0._left_hand_unit = var_1_0
	arg_1_0._right_hand_unit = var_1_1
	arg_1_0._current_segment = -1
	arg_1_0._sfx_active = false
	arg_1_0._charge_sfx = false
end

local function var_0_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_1
	local var_2_1 = ActionUtils.get_action_time_scale(arg_2_2, arg_2_0)

	if arg_2_4 then
		var_2_0 = var_2_0 * var_2_1
	else
		var_2_0 = var_2_0 * (1 / var_2_1)
	end

	return var_2_0
end

ActionBookCharge.client_owner_start_action = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	ActionBookCharge.super.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	arg_3_0.charge = arg_3_0.weapon_extension:get_custom_data("charge")

	local var_3_0 = arg_3_0.owner_unit
	local var_3_1 = ScriptUnit.extension(var_3_0, "buff_system")

	arg_3_0.charge_speed = var_0_2(arg_3_1, arg_3_1.charge_speed or 0.3, var_3_0, var_3_1, true)
	arg_3_0.initial_charge_delay = var_0_2(arg_3_1, arg_3_1.initial_charge_delay or 0, var_3_0, var_3_1, false)
	arg_3_0.start_time = arg_3_2

	arg_3_0:_update_visual_charge(arg_3_0.charge)
end

ActionBookCharge.client_owner_post_update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	ActionBookCharge.super.client_owner_post_update(arg_4_0, arg_4_1, arg_4_2, arg_4_3)

	if arg_4_2 < arg_4_0.start_time + arg_4_0.initial_charge_delay then
		return
	end

	if arg_4_0.charge < 1 and not arg_4_0._sfx_active then
		arg_4_0._sfx_active = true

		arg_4_0.first_person_extension:play_hud_sound_event("priest_melee_book_charge")
	end

	arg_4_0.charge = arg_4_0.charge + arg_4_0.charge_speed * arg_4_1

	arg_4_0.weapon_extension:set_custom_data("charge", arg_4_0.charge)
	arg_4_0:_update_visual_charge(arg_4_0.charge)
end

ActionBookCharge._update_visual_charge = function (arg_5_0, arg_5_1)
	if arg_5_0._right_hand_unit then
		local var_5_0 = math.clamp(arg_5_1, 0, 1)

		var_0_0(arg_5_0._right_hand_unit, "current_charge", var_5_0)
		var_0_1(arg_5_0._right_hand_unit, "lua_update_charge")
	end

	local var_5_1 = arg_5_0.inventory_extension

	if arg_5_1 >= 1 and not arg_5_0._charge_sfx then
		arg_5_0._charge_sfx = true

		arg_5_0.first_person_extension:play_hud_sound_event("priest_melee_book_charge_end")

		arg_5_0._sfx_active = false
	elseif arg_5_1 < 1 and arg_5_0._charge_sfx then
		arg_5_0._charge_sfx = false
	end
end

ActionBookCharge.finish = function (arg_6_0, arg_6_1)
	ActionChangeMode.super.finish(arg_6_0, arg_6_1)

	if arg_6_0.charge < 1 then
		arg_6_0._sfx_active = false

		arg_6_0.first_person_extension:play_hud_sound_event("priest_melee_book_charge_stop")
	end
end
