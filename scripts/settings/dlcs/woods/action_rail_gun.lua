-- chunkname: @scripts/settings/dlcs/woods/action_rail_gun.lua

ActionRailGun = class(ActionRailGun, ActionRangedBase)

function ActionRailGun.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionRailGun.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

function ActionRailGun.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionRailGun.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local var_2_0 = arg_2_1.on_shoot_particle_fx

	if var_2_0 and not arg_2_0.is_bot then
		local var_2_1 = arg_2_0.first_person_unit
		local var_2_2 = var_2_0.node_name

		arg_2_0._on_shoot_particle_fx_node = Unit.has_node(var_2_1, var_2_2) and Unit.node(var_2_1, var_2_2) or 0
		arg_2_0._on_shoot_particle_fx = var_2_0
	end
end

function ActionRailGun.shoot(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._on_shoot_particle_fx

	if var_3_0 and not arg_3_0.is_bot then
		local var_3_1 = arg_3_0.first_person_unit
		local var_3_2 = Unit.world_position(var_3_1, arg_3_0._on_shoot_particle_fx_node)

		World.create_particles(arg_3_0.world, var_3_0.effect, var_3_2)
	end

	return ActionRailGun.super.shoot(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
end

function ActionRailGun.finish(arg_4_0, arg_4_1)
	ActionRailGun.super.finish(arg_4_0, arg_4_1)
	arg_4_0:_proc_spell_used(arg_4_0.owner_buff_extension)
end
