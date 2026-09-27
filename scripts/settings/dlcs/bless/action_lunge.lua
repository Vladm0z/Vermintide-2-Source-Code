-- chunkname: @scripts/settings/dlcs/bless/action_lunge.lua

ActionLunge = class(ActionLunge, ActionSweep)

ActionLunge.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionLunge.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	self._first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
end

ActionLunge.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local _status_extension = self._status_extension

	if not _status_extension.do_lunge then
		return
	end

	local lunge_settings = arg_2_1.lunge_settings

	_status_extension.do_lunge = {
		allow_rotation = false,
		noclip = false,
		dodge = false,
		initial_speed = lunge_settings.initial_speed,
		falloff_to_speed = lunge_settings.falloff_to_speed,
		duration = lunge_settings.duration,
		damage = {
			offset_forward = 0.5,
			height = 1,
			depth_padding = 0.6,
			hit_zone_hit_name = "full",
			ignore_shield = true,
			collision_filter = "filter_explosion_overlap_no_player",
			power_level_multiplier = 1,
			interrupt_on_first_hit = true,
			damage_profile = "light_push",
			width = 2
		}
	}

	ActionLunge.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
end
