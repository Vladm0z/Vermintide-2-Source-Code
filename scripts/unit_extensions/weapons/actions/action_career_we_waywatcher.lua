-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_we_waywatcher.lua

ActionCareerWEWaywatcher = class(ActionCareerWEWaywatcher, ActionTrueFlightBow)

ActionCareerWEWaywatcher.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerWEWaywatcher.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
end

ActionCareerWEWaywatcher.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionCareerWEWaywatcher.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	self:_play_vo()

	self._cooldown_started = false

	ScriptUnit.extension(self.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end

ActionCareerWEWaywatcher.finish = function (self, arg_3_1)
	-- function 3
	ActionCareerWEWaywatcher.super.finish(self, arg_3_1)

	if not self._cooldown_started then
		self._cooldown_started = true

		self.career_extension:start_activated_ability_cooldown()
	end

	self.inventory_extension:wield_previous_non_level_slot()
end

ActionCareerWEWaywatcher._play_vo = function (self)
	-- function 4
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

ActionCareerWEWaywatcher._restore_ammo = function (self)
	-- function 5
	local owner_unit = self.owner_unit
	local str = "slot_ranged"
	local get_slot_data = ScriptUnit.extension(owner_unit, "inventory_system"):get_slot_data(str)
	local right_unit_1p = get_slot_data.right_unit_1p
	local left_unit_1p = get_slot_data.left_unit_1p
	local has_extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")
	local has_extension_2 = ScriptUnit.has_extension(left_unit_1p, "ammo_system")
	local flag = has_extension or has_extension_2
	local num = 0.2
	local max = math.max(math.round(flag:max_ammo() * num), 1)

	if not flag then
		flag:add_ammo_to_reserve(max)
	end
end
