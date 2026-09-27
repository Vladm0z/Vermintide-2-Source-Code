-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_vent.lua

ActionCareerBWNecromancerCommandVent = class(ActionCareerBWNecromancerCommandVent, ActionBase)

ActionCareerBWNecromancerCommandVent.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerBWNecromancerCommandVent.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.commander_extension = ScriptUnit.extension(arg_1_4, "ai_commander_system")
	self._fp_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self.career_extension = ScriptUnit.has_extension(arg_1_4, "career_system")
	self._command_ability = self.career_extension:get_passive_ability_by_name("bw_necromancer_command")
	self._owner_unit = arg_1_4
	self._world = arg_1_1
end

ActionCareerBWNecromancerCommandVent.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionCareerBWNecromancerCommandVent.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local vent_command_target = self._command_ability:vent_command_target()
	local num = 0.7
	local remove_charge_fraction, var_2_3 = self.overcharge_extension:remove_charge_fraction(num)
	local _owner_unit = self._owner_unit
	local owner = Managers.player:owner(_owner_unit)

	if not owner and not owner.local_player then
		Managers.state.achievement:trigger_event("sacrifice_skeleton", vent_command_target, var_2_3, _owner_unit)
	end

	local _fp_extension = self._fp_extension

	if not _fp_extension then
		local get_first_person_unit = _fp_extension:get_first_person_unit()
		local node = Unit.node(get_first_person_unit, "j_aim_target")

		self._sacrifice_vfx_trail = ScriptWorld.create_particles_linked(self._world, "fx/pet_skeleton_sacrifice_trail", get_first_person_unit, node, "destroy")

		local node_2 = Unit.node(get_first_person_unit, "j_righthand")

		self._sacrifice_vfx_hand = ScriptWorld.create_particles_linked(self._world, "fx/necromancer_skeleton_sacrifice_hand", get_first_person_unit, node_2, "destroy")
		self._vfx_stop_t = arg_2_2 + 0.8
	end

	if not self._talent_extension:has_talent("sienna_necromancer_4_3") then
		Managers.state.entity:system("buff_system"):add_buff_synced(_owner_unit, "sienna_necromancer_4_3_withering_touch", BuffSyncType.LocalAndServer)
	end

	self._command_ability:command_sacrifice(vent_command_target)
end

ActionCareerBWNecromancerCommandVent.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not (not self._vfx_stop_t and not (arg_3_2 > self._vfx_stop_t)) then
		World.stop_spawning_particles(self._world, self._sacrifice_vfx_trail)

		self._vfx_stop_t = nil
	end
end

ActionCareerBWNecromancerCommandVent.finish = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._fp_extension then
		World.destroy_particles(self._world, self._sacrifice_vfx_trail)
		World.destroy_particles(self._world, self._sacrifice_vfx_hand)

		self._sacrifice_vfx_trail = nil
		self._sacrifice_vfx_hand = nil
	end
end

ActionCareerBWNecromancerCommandVent.destroy = function (arg_5_0)
	-- function 5
	return
end
