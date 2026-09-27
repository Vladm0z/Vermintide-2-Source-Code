-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_fixed_impact_unit_extension.lua

ProjectileFixedImpactUnitExtension = class(ProjectileFixedImpactUnitExtension, ProjectileBaseImpactUnitExtension)

ProjectileFixedImpactUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	ProjectileFixedImpactUnitExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self.is_server = Managers.player.is_server
	self.owner_unit = arg_1_3.owner_unit

	local owner = Managers.player:owner(self.owner_unit)
	local local_player

	if not owner then
		local_player = owner.local_player

		if not local_player then
			-- Nothing
		end
	end

	if not owner then
		local_player = owner.bot_player

		if not local_player then
			-- Nothing
		end
	end

	local_player = false

	::label_1_0::

	self.owner_is_local = local_player
	self.last_position = nil
	self.impact_data = arg_1_3.impact_data
	self._time_to_impact = self.impact_data.time
end

ProjectileFixedImpactUnitExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
end

ProjectileFixedImpactUnitExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	ProjectileFixedImpactUnitExtension.super.update(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	if not self.is_server then
		return
	end

	if not (self.has_hit or not (self._time_to_impact <= 0)) then
		self.has_hit = true

		local impact_data = self.impact_data
		local hit_unit = impact_data.hit_unit
		local unbox = impact_data.position:unbox()
		local unbox_2 = impact_data.direction:unbox()
		local unbox_3 = impact_data.hit_normal:unbox()
		local actor_index = impact_data.actor_index

		self:impact(hit_unit, unbox, unbox_2, unbox_3, actor_index)
	end

	self._time_to_impact = self._time_to_impact - arg_3_3
end
