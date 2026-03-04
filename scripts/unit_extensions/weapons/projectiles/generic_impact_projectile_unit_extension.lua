-- chunkname: @scripts/unit_extensions/weapons/projectiles/generic_impact_projectile_unit_extension.lua

GenericImpactProjectileUnitExtension = class(GenericImpactProjectileUnitExtension)

GenericImpactProjectileUnitExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.owner_unit = arg_1_3.owner_unit
	arg_1_0.damage_source = arg_1_3.damage_source
	arg_1_0.impact_template_name = arg_1_3.impact_template_name

	assert(arg_1_0.impact_template_name)

	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.explosion_template_name = arg_1_3.explosion_template_name

	Unit.flow_event(arg_1_2, "lua_projectile_init")
end

GenericImpactProjectileUnitExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
	arg_2_0.impact_extension = ScriptUnit.has_extension(arg_2_2, "projectile_impact_system")
end

GenericImpactProjectileUnitExtension.destroy = function (arg_3_0)
	Unit.flow_event(arg_3_0.unit, "lua_projectile_end")
end

GenericImpactProjectileUnitExtension.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.impact_extension

	if not var_4_0 then
		return
	end

	local var_4_1, var_4_2 = var_4_0:recent_impacts()

	if var_4_2 == 0 then
		return
	end

	arg_4_0:_execute_impact(var_4_1, var_4_2, 1)

	if arg_4_0.impact_template_name == "vfx_impact" then
		return
	end

	local var_4_3 = ProjectileImpactDataIndex.UNIT
	local var_4_4 = ProjectileImpactDataIndex.POSITION
	local var_4_5 = ProjectileImpactDataIndex.DIRECTION
	local var_4_6 = ProjectileImpactDataIndex.NORMAL
	local var_4_7 = ProjectileImpactDataIndex.ACTOR_INDEX
	local var_4_8 = ProjectileImpactDataIndex.STRIDE
	local var_4_9 = arg_4_0.network_manager
	local var_4_10 = var_4_9:unit_game_object_id(arg_4_0.unit)
	local var_4_11 = var_4_2 / var_4_8

	for iter_4_0 = 1, var_4_11 do
		local var_4_12 = (iter_4_0 - 1) * var_4_8
		local var_4_13 = var_4_1[var_4_12 + var_4_3]
		local var_4_14 = var_4_1[var_4_12 + var_4_4]:unbox()
		local var_4_15 = var_4_1[var_4_12 + var_4_5]:unbox()
		local var_4_16 = var_4_1[var_4_12 + var_4_6]:unbox()
		local var_4_17 = var_4_1[var_4_12 + var_4_7]
		local var_4_18, var_4_19 = var_4_9:game_object_or_level_id(var_4_13)
		local var_4_20
		local var_4_21

		if var_4_19 then
			var_4_20, var_4_21 = NetworkConstants.game_object_id_max, var_4_18
		elseif var_4_18 then
			var_4_20, var_4_21 = var_4_18, 0
		end

		if var_4_18 then
			if arg_4_0.is_server then
				var_4_9.network_transmit:send_rpc_clients("rpc_generic_impact_projectile_impact", var_4_10, var_4_20, var_4_21, var_4_14, var_4_15, var_4_16, var_4_17, var_4_11)
			else
				var_4_9.network_transmit:send_rpc_server("rpc_generic_impact_projectile_impact", var_4_10, var_4_20, var_4_21, var_4_14, var_4_15, var_4_16, var_4_17, var_4_11)
			end
		end
	end
end

GenericImpactProjectileUnitExtension._execute_impact = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = ProjectileTemplates.impact_templates[arg_5_0.impact_template_name]
	local var_5_1 = ExplosionUtils.get_template(arg_5_0.explosion_template_name)
	local var_5_2 = false

	if arg_5_0.is_server then
		var_5_2 = var_5_0.server.execute(arg_5_0.world, arg_5_0.damage_source, arg_5_0.unit, arg_5_1, arg_5_2, arg_5_0.owner_unit, var_5_1, arg_5_3)
	end

	local var_5_3 = var_5_0.client.execute(arg_5_0.world, arg_5_0.damage_source, arg_5_0.unit, arg_5_1, arg_5_2, arg_5_0.owner_unit, var_5_1, arg_5_3)

	if var_5_2 or var_5_3 then
		arg_5_0.locomotion_extension:stop()
	end
end

local var_0_0 = {
	[ProjectileImpactDataIndex.POSITION] = Vector3Box(),
	[ProjectileImpactDataIndex.DIRECTION] = Vector3Box(),
	[ProjectileImpactDataIndex.NORMAL] = Vector3Box()
}

GenericImpactProjectileUnitExtension.impact = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	var_0_0[ProjectileImpactDataIndex.UNIT] = arg_6_1

	var_0_0[ProjectileImpactDataIndex.POSITION]:store(arg_6_2)
	var_0_0[ProjectileImpactDataIndex.DIRECTION]:store(arg_6_3)
	var_0_0[ProjectileImpactDataIndex.NORMAL]:store(arg_6_4)

	var_0_0[ProjectileImpactDataIndex.ACTOR_INDEX] = arg_6_5

	arg_6_0:_execute_impact(var_0_0, ProjectileImpactDataIndex.STRIDE, arg_6_6)
end

local var_0_1 = {}

GenericImpactProjectileUnitExtension.force_impact = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.locomotion_extension

	var_0_1[ProjectileImpactDataIndex.POSITION] = Vector3Box(arg_7_2)

	local var_7_1 = ProjectileTemplates.impact_templates[arg_7_0.impact_template_name]
	local var_7_2 = ExplosionUtils.get_template(arg_7_0.explosion_template_name)
	local var_7_3 = false

	if arg_7_0.is_server then
		var_7_3 = var_7_1.server.execute(arg_7_0.world, arg_7_0.damage_source, arg_7_1, var_0_1, 1, arg_7_0.owner_unit, var_7_2)
	end

	local var_7_4 = var_7_1.client.execute(arg_7_0.world, arg_7_0.damage_source, arg_7_1, var_0_1, 1, arg_7_0.owner_unit, var_7_2)

	if var_7_3 or var_7_4 then
		var_7_0:stop()
	end
end
