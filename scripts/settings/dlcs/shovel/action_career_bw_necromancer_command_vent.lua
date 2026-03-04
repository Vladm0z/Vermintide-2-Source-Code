-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_vent.lua

ActionCareerBWNecromancerCommandVent = class(ActionCareerBWNecromancerCommandVent, ActionBase)

ActionCareerBWNecromancerCommandVent.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerBWNecromancerCommandVent.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.commander_extension = ScriptUnit.extension(arg_1_4, "ai_commander_system")
	arg_1_0._fp_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0.career_extension = ScriptUnit.has_extension(arg_1_4, "career_system")
	arg_1_0._command_ability = arg_1_0.career_extension:get_passive_ability_by_name("bw_necromancer_command")
	arg_1_0._owner_unit = arg_1_4
	arg_1_0._world = arg_1_1
end

ActionCareerBWNecromancerCommandVent.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionCareerBWNecromancerCommandVent.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local var_2_0 = arg_2_0._command_ability:vent_command_target()
	local var_2_1 = 0.7
	local var_2_2, var_2_3 = arg_2_0.overcharge_extension:remove_charge_fraction(var_2_1)
	local var_2_4 = arg_2_0._owner_unit
	local var_2_5 = Managers.player:owner(var_2_4)

	if var_2_5 and var_2_5.local_player then
		Managers.state.achievement:trigger_event("sacrifice_skeleton", var_2_0, var_2_3, var_2_4)
	end

	local var_2_6 = arg_2_0._fp_extension

	if var_2_6 then
		local var_2_7 = var_2_6:get_first_person_unit()
		local var_2_8 = Unit.node(var_2_7, "j_aim_target")

		arg_2_0._sacrifice_vfx_trail = ScriptWorld.create_particles_linked(arg_2_0._world, "fx/pet_skeleton_sacrifice_trail", var_2_7, var_2_8, "destroy")

		local var_2_9 = Unit.node(var_2_7, "j_righthand")

		arg_2_0._sacrifice_vfx_hand = ScriptWorld.create_particles_linked(arg_2_0._world, "fx/necromancer_skeleton_sacrifice_hand", var_2_7, var_2_9, "destroy")
		arg_2_0._vfx_stop_t = arg_2_2 + 0.8
	end

	if arg_2_0._talent_extension:has_talent("sienna_necromancer_4_3") then
		Managers.state.entity:system("buff_system"):add_buff_synced(var_2_4, "sienna_necromancer_4_3_withering_touch", BuffSyncType.LocalAndServer)
	end

	if HEALTH_ALIVE[var_2_0] then
		arg_2_0._command_ability:command_sacrifice(var_2_0)
	end
end

ActionCareerBWNecromancerCommandVent.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_0._vfx_stop_t and arg_3_2 > arg_3_0._vfx_stop_t then
		World.stop_spawning_particles(arg_3_0._world, arg_3_0._sacrifice_vfx_trail)

		arg_3_0._vfx_stop_t = nil
	end
end

ActionCareerBWNecromancerCommandVent.finish = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._fp_extension then
		World.destroy_particles(arg_4_0._world, arg_4_0._sacrifice_vfx_trail)
		World.destroy_particles(arg_4_0._world, arg_4_0._sacrifice_vfx_hand)

		arg_4_0._sacrifice_vfx_trail = nil
		arg_4_0._sacrifice_vfx_hand = nil
	end
end

ActionCareerBWNecromancerCommandVent.destroy = function (arg_5_0)
	return
end
