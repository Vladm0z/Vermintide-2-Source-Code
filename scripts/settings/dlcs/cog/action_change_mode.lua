-- chunkname: @scripts/settings/dlcs/cog/action_change_mode.lua

ActionChangeMode = class(ActionChangeMode, ActionBase)

ActionChangeMode.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionChangeMode.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
end

ActionChangeMode.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}

	ActionChangeMode.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_0.weapon_extension:set_mode(arg_2_1.next_weapon_mode)
	arg_2_0:_play_additional_animation(arg_2_1.custom_start_anim_data)
end

ActionChangeMode.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

ActionChangeMode.finish = function (arg_4_0, arg_4_1)
	ActionChangeMode.super.finish(arg_4_0, arg_4_1)
	arg_4_0:_play_additional_animation(arg_4_0.current_action.custom_finish_anim_data)
end
