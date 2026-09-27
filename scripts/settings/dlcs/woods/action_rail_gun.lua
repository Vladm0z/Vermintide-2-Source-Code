-- chunkname: @scripts/settings/dlcs/woods/action_rail_gun.lua

ActionRailGun = class(ActionRailGun, ActionRangedBase)

ActionRailGun.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionRailGun.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

ActionRailGun.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionRailGun.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local on_shoot_particle_fx = arg_2_1.on_shoot_particle_fx

	if not (not on_shoot_particle_fx and self.is_bot) then
		local first_person_unit = self.first_person_unit
		local node_name = on_shoot_particle_fx.node_name
		local node

		if not Unit.has_node(first_person_unit, node_name) then
			node = Unit.node(first_person_unit, node_name)

			if not node then
				-- Nothing
			end
		end

		node = 0

		::label_2_0::

		self._on_shoot_particle_fx_node = node
		self._on_shoot_particle_fx = on_shoot_particle_fx
	end
end

ActionRailGun.shoot = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local _on_shoot_particle_fx = self._on_shoot_particle_fx

	if not _on_shoot_particle_fx and not not self.is_bot then
		local first_person_unit = self.first_person_unit
		local world_position = Unit.world_position(first_person_unit, self._on_shoot_particle_fx_node)

		World.create_particles(self.world, _on_shoot_particle_fx.effect, world_position)
	end

	return ActionRailGun.super.shoot(self, arg_3_1, arg_3_2, arg_3_3)
end

ActionRailGun.finish = function (self, arg_4_1)
	-- function 4
	ActionRailGun.super.finish(self, arg_4_1)
	self:_proc_spell_used(self.owner_buff_extension)
end
