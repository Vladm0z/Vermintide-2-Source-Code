-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_single_target.lua

ActionCareerBWNecromancerSingleTarget = class(ActionCareerBWNecromancerSingleTarget, ActionBase)

ActionCareerBWNecromancerSingleTarget.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerBWNecromancerSingleTarget.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self._owner_unit = arg_1_4
end

ActionCareerBWNecromancerSingleTarget.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	ActionCareerBWNecromancerSingleTarget.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	if not arg_2_3 then
		self:_play_vo()

		self.target = arg_2_3.target

		local target = self.target
		local _owner_unit = self._owner_unit

		Managers.state.entity:system("buff_system"):add_buff(target, "sienna_necromancer_career_skill_on_hit_damage", _owner_unit, false)

		if not self._talent_extension:has_talent("sienna_necromancer_5_1") then
			-- Nothing
		end

		self._career_extension:start_activated_ability_cooldown()
	end
end

ActionCareerBWNecromancerSingleTarget.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

ActionCareerBWNecromancerSingleTarget.finish = function (self, arg_4_1)
	-- function 4
	self._inventory_extension:wield_previous_non_level_slot()
end

ActionCareerBWNecromancerSingleTarget._play_vo = function (self)
	-- function 5
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
