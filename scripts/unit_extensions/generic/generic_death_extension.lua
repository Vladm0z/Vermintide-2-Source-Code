-- chunkname: @scripts/unit_extensions/generic/generic_death_extension.lua

require("scripts/unit_extensions/generic/death_reactions")

GenericDeathExtension = class(GenericDeathExtension)

function GenericDeathExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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

function GenericDeathExtension.freeze(arg_2_0)
	arg_2_0.play_effect = nil
	arg_2_0.despawn_after_time = nil
end

function GenericDeathExtension.override_death_behavior(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.despawn_after_time = arg_3_1
	arg_3_0.play_effect = arg_3_2
end

function GenericDeathExtension.force_end(arg_4_0)
	if not arg_4_0.death_is_done and Unit.alive(arg_4_0.unit) and not arg_4_0.is_alive then
		Managers.state.unit_spawner:mark_for_deletion(arg_4_0.unit)

		arg_4_0.death_is_done = true
	end
end

function GenericDeathExtension.is_wall_nailed(arg_5_0)
	return next(arg_5_0.wall_nail_data) and true or false
end

function GenericDeathExtension.nailing_hit(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	fassert(Vector3.is_valid(arg_6_2), "Attack direction is not valid.")

	local var_6_0 = arg_6_0.wall_nail_data

	var_6_0[arg_6_1] = var_6_0[arg_6_1] or {
		attack_direction = Vector3Box(arg_6_2),
		hit_speed = arg_6_3
	}
end

function GenericDeathExtension.enable_second_hit_ragdoll(arg_7_0)
	arg_7_0.second_hit_ragdoll = true
end

function GenericDeathExtension.second_hit_ragdoll_allowed(arg_8_0)
	return arg_8_0.second_hit_ragdoll
end

function GenericDeathExtension.has_death_started(arg_9_0)
	return arg_9_0.death_has_started
end
