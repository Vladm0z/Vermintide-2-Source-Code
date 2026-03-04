-- chunkname: @scripts/unit_extensions/generic/generic_death_extension.lua

require("scripts/unit_extensions/generic/death_reactions")

GenericDeathExtension = class(GenericDeathExtension)

GenericDeathExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.network_type = arg_1_3.is_husk

	local var_1_0 = arg_1_3.is_husk or not Managers.player.is_server

	arg_1_0.is_husk = var_1_0
	arg_1_0.network_type = var_1_0 and "husk" or "unit"
	arg_1_0.is_alive = true
	arg_1_0.unit = arg_1_2
	arg_1_0.extension_init_data = arg_1_3
	arg_1_0.wall_nail_data = {}
	arg_1_0.second_hit_ragdoll = not arg_1_3.disable_second_hit_ragdoll
end

GenericDeathExtension.freeze = function (arg_2_0)
	arg_2_0.play_effect = nil
	arg_2_0.despawn_after_time = nil
end

GenericDeathExtension.override_death_behavior = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.despawn_after_time = arg_3_1
	arg_3_0.play_effect = arg_3_2
end

GenericDeathExtension.force_end = function (arg_4_0)
	if not arg_4_0.death_is_done and Unit.alive(arg_4_0.unit) and not arg_4_0.is_alive then
		Managers.state.unit_spawner:mark_for_deletion(arg_4_0.unit)

		arg_4_0.death_is_done = true
	end
end

GenericDeathExtension.is_wall_nailed = function (arg_5_0)
	return next(arg_5_0.wall_nail_data) and true or false
end

GenericDeathExtension.nailing_hit = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	fassert(Vector3.is_valid(arg_6_2), "Attack direction is not valid.")

	local var_6_0 = arg_6_0.wall_nail_data

	var_6_0[arg_6_1] = var_6_0[arg_6_1] or {
		attack_direction = Vector3Box(arg_6_2),
		hit_speed = arg_6_3
	}
end

GenericDeathExtension.enable_second_hit_ragdoll = function (arg_7_0)
	arg_7_0.second_hit_ragdoll = true
end

GenericDeathExtension.second_hit_ragdoll_allowed = function (arg_8_0)
	return arg_8_0.second_hit_ragdoll
end

GenericDeathExtension.has_death_started = function (arg_9_0)
	return arg_9_0.death_has_started
end
