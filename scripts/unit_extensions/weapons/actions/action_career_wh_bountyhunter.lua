-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_wh_bountyhunter.lua

ActionCareerWHBountyhunter = class(ActionCareerWHBountyhunter, ActionBountyHunterHandgun)

ActionCareerWHBountyhunter.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerWHBountyhunter.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
end

ActionCareerWHBountyhunter.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	local talent_extension = self.talent_extension

	if not talent_extension:has_talent("victor_bountyhunter_activated_ability_railgun") then
		arg_2_5.upper_barrel = "railgun"
		arg_2_5.lower_barrel = "railgun"
	elseif not talent_extension:has_talent("victor_bountyhunter_activated_ability_blast_shotgun") then
		arg_2_5.upper_barrel = "shotgun"
		arg_2_5.lower_barrel = "shotgun"
	else
		arg_2_5.upper_barrel = "railgun"
		arg_2_5.lower_barrel = "shotgun"
	end

	self.career_extension:reduce_activated_ability_cooldown_percent(-1)
	ActionCareerWHBountyhunter.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	self:_play_vo()

	self.start_activated_ability_cooldown_t = 0.1

	ScriptUnit.extension(self.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end

ActionCareerWHBountyhunter.client_owner_post_update = function (self, arg_3_1, ...)
	-- function 3
	if not self.start_activated_ability_cooldown_t then
		self.start_activated_ability_cooldown_t = self.start_activated_ability_cooldown_t - arg_3_1

		if self.start_activated_ability_cooldown_t <= 0 then
			local flag = true

			self.career_extension:start_activated_ability_cooldown(1, 0, 0, flag)

			self.start_activated_ability_cooldown_t = nil
		end
	end

	ActionCareerWHBountyhunter.super.client_owner_post_update(self, arg_3_1, ...)
end

ActionCareerWHBountyhunter.finish = function (self, arg_4_1)
	-- function 4
	ActionCareerWHBountyhunter.super.finish(self, arg_4_1)

	local talent_extension = self.talent_extension
	local inventory_extension = self.inventory_extension

	if not talent_extension:has_talent("victor_bountyhunter_activated_ability_reload", "witch_hunter", true) then
		local str = "slot_ranged"
		local get_slot_data = inventory_extension:get_slot_data(str)
		local right_unit_1p = get_slot_data.right_unit_1p
		local left_unit_1p = get_slot_data.left_unit_1p
		local has_extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")
		local has_extension_2 = ScriptUnit.has_extension(left_unit_1p, "ammo_system")
		local flag = has_extension or has_extension_2

		if not flag then
			flag:instant_reload(true)
		end
	end

	self.inventory_extension:wield_previous_non_level_slot()
end

ActionCareerWHBountyhunter._play_vo = function (self)
	-- function 5
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
