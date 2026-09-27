-- chunkname: @scripts/unit_extensions/weapons/projectiles/generic_impact_projectile_unit_extension.lua

GenericImpactProjectileUnitExtension = class(GenericImpactProjectileUnitExtension)

GenericImpactProjectileUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.owner_unit = arg_1_3.owner_unit
	self.damage_source = arg_1_3.damage_source
	self.impact_template_name = arg_1_3.impact_template_name

	assert(self.impact_template_name)

	self.is_server = Managers.player.is_server
	self.network_manager = Managers.state.network
	self.explosion_template_name = arg_1_3.explosion_template_name

	Unit.flow_event(arg_1_2, "lua_projectile_init")
end

GenericImpactProjectileUnitExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
	self.impact_extension = ScriptUnit.has_extension(arg_2_2, "projectile_impact_system")
end

GenericImpactProjectileUnitExtension.destroy = function (self)
	-- function 3
	Unit.flow_event(self.unit, "lua_projectile_end")
end

GenericImpactProjectileUnitExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local impact_extension = self.impact_extension

	if not impact_extension then
		return
	end

	local recent_impacts, var_4_2 = impact_extension:recent_impacts()

	if var_4_2 == 0 then
		return
	end

	self:_execute_impact(recent_impacts, var_4_2, 1)

	if self.impact_template_name == "vfx_impact" then
		return
	end

	local UNIT = ProjectileImpactDataIndex.UNIT
	local POSITION = ProjectileImpactDataIndex.POSITION
	local DIRECTION = ProjectileImpactDataIndex.DIRECTION
	local NORMAL = ProjectileImpactDataIndex.NORMAL
	local ACTOR_INDEX = ProjectileImpactDataIndex.ACTOR_INDEX
	local STRIDE = ProjectileImpactDataIndex.STRIDE
	local network_manager = self.network_manager
	local unit_game_object_id = network_manager:unit_game_object_id(self.unit)
	local num = var_4_2 / STRIDE

	for i = 1, num do
		local num_2 = (i - 1) * STRIDE
		local var_4_13 = recent_impacts[num_2 + UNIT]
		local unbox = recent_impacts[num_2 + POSITION]:unbox()
		local unbox_2 = recent_impacts[num_2 + DIRECTION]:unbox()
		local unbox_3 = recent_impacts[num_2 + NORMAL]:unbox()
		local var_4_17 = recent_impacts[num_2 + ACTOR_INDEX]
		local game_object_or_level_id, var_4_19 = network_manager:game_object_or_level_id(var_4_13)
		local var_4_20
		local var_4_21

		if not var_4_19 then
			var_4_20, var_4_21 = NetworkConstants.game_object_id_max, game_object_or_level_id
		elseif not game_object_or_level_id then
			var_4_20, var_4_21 = game_object_or_level_id, 0
		end

		if not game_object_or_level_id then
			if not self.is_server then
				network_manager.network_transmit:send_rpc_clients("rpc_generic_impact_projectile_impact", unit_game_object_id, var_4_20, var_4_21, unbox, unbox_2, unbox_3, var_4_17, num)
			else
				network_manager.network_transmit:send_rpc_server("rpc_generic_impact_projectile_impact", unit_game_object_id, var_4_20, var_4_21, unbox, unbox_2, unbox_3, var_4_17, num)
			end
		end
	end
end

GenericImpactProjectileUnitExtension._execute_impact = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local var_5_0 = ProjectileTemplates.impact_templates[self.impact_template_name]
	local get_template = ExplosionUtils.get_template(self.explosion_template_name)
	local flag = false

	if not self.is_server then
		flag = var_5_0.server.execute(self.world, self.damage_source, self.unit, arg_5_1, arg_5_2, self.owner_unit, get_template, arg_5_3)
	end

	local execute = var_5_0.client.execute(self.world, self.damage_source, self.unit, arg_5_1, arg_5_2, self.owner_unit, get_template, arg_5_3)

	if flag or not execute then
		self.locomotion_extension:stop()
	end
end

local tbl = {
	[ProjectileImpactDataIndex.POSITION] = Vector3Box(),
	[ProjectileImpactDataIndex.DIRECTION] = Vector3Box(),
	[ProjectileImpactDataIndex.NORMAL] = Vector3Box()
}

GenericImpactProjectileUnitExtension.impact = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	-- function 6
	tbl[ProjectileImpactDataIndex.UNIT] = arg_6_1

	tbl[ProjectileImpactDataIndex.POSITION]:store(arg_6_2)
	tbl[ProjectileImpactDataIndex.DIRECTION]:store(arg_6_3)
	tbl[ProjectileImpactDataIndex.NORMAL]:store(arg_6_4)

	tbl[ProjectileImpactDataIndex.ACTOR_INDEX] = arg_6_5

	self:_execute_impact(tbl, ProjectileImpactDataIndex.STRIDE, arg_6_6)
end

local tbl_2 = {}

GenericImpactProjectileUnitExtension.force_impact = function (self, arg_7_1, arg_7_2)
	-- function 7
	local locomotion_extension = self.locomotion_extension

	tbl_2[ProjectileImpactDataIndex.POSITION] = Vector3Box(arg_7_2)

	local var_7_1 = ProjectileTemplates.impact_templates[self.impact_template_name]
	local get_template = ExplosionUtils.get_template(self.explosion_template_name)
	local flag = false

	if not self.is_server then
		flag = var_7_1.server.execute(self.world, self.damage_source, arg_7_1, tbl_2, 1, self.owner_unit, get_template)
	end

	local execute = var_7_1.client.execute(self.world, self.damage_source, arg_7_1, tbl_2, 1, self.owner_unit, get_template)

	if flag or not execute then
		locomotion_extension:stop()
	end
end
