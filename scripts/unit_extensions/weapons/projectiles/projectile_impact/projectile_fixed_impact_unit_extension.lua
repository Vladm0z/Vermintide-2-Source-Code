-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_fixed_impact_unit_extension.lua

ProjectileFixedImpactUnitExtension = class(ProjectileFixedImpactUnitExtension, ProjectileBaseImpactUnitExtension)

function ProjectileFixedImpactUnitExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	ProjectileFixedImpactUnitExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.owner_unit = arg_1_3.owner_unit

	local var_1_0 = Managers.player:owner(arg_1_0.owner_unit)

	arg_1_0.owner_is_local = var_1_0 and var_1_0.local_player or var_1_0 and var_1_0.bot_player or false
	arg_1_0.last_position = nil
	arg_1_0.impact_data = arg_1_3.impact_data
	arg_1_0._time_to_impact = arg_1_0.impact_data.time
end

function ProjectileFixedImpactUnitExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
end

function ProjectileFixedImpactUnitExtension.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	ProjectileFixedImpactUnitExtension.super.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	if not arg_3_0.is_server then
		return
	end

	if not arg_3_0.has_hit and arg_3_0._time_to_impact <= 0 then
		arg_3_0.has_hit = true

		local var_3_0 = arg_3_0.impact_data
		local var_3_1 = var_3_0.hit_unit
		local var_3_2 = var_3_0.position:unbox()
		local var_3_3 = var_3_0.direction:unbox()
		local var_3_4 = var_3_0.hit_normal:unbox()
		local var_3_5 = var_3_0.actor_index

		arg_3_0:impact(var_3_1, var_3_2, var_3_3, var_3_4, var_3_5)
	end

	arg_3_0._time_to_impact = arg_3_0._time_to_impact - arg_3_3
end
