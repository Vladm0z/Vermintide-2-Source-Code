-- chunkname: @scripts/settings/dlcs/cog/action_change_mode.lua

ActionChangeMode = class(ActionChangeMode, ActionBase)

ActionChangeMode.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionChangeMode.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
end

ActionChangeMode.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	ActionChangeMode.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	self.weapon_extension:set_mode(arg_2_1.next_weapon_mode)
	self:_play_additional_animation(arg_2_1.custom_start_anim_data)
end

ActionChangeMode.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

ActionChangeMode.finish = function (self, arg_4_1)
	-- function 4
	ActionChangeMode.super.finish(self, arg_4_1)
	self:_play_additional_animation(self.current_action.custom_finish_anim_data)
end
