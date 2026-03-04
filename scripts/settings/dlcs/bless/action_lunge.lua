-- chunkname: @scripts/settings/dlcs/bless/action_lunge.lua

ActionLunge = class(ActionLunge, ActionSweep)

ActionLunge.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionLunge.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	arg_1_0._first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
end

ActionLunge.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_0._status_extension

	if var_2_0.do_lunge then
		return
	end

	local var_2_1 = arg_2_1.lunge_settings

	var_2_0.do_lunge = {
		allow_rotation = false,
		noclip = false,
		dodge = false,
		initial_speed = var_2_1.initial_speed,
		falloff_to_speed = var_2_1.falloff_to_speed,
		duration = var_2_1.duration,
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

	ActionLunge.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
end
