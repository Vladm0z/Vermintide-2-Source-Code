-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_bw_scholar.lua

ActionCareerBWScholar = class(ActionCareerBWScholar, ActionTrueFlightBow)

ActionCareerBWScholar.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerBWScholar.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
end

ActionCareerBWScholar.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionCareerBWScholar.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	local talent_extension = self.talent_extension
	local owner_unit = self.owner_unit

	if not talent_extension:has_talent("sienna_scholar_activated_ability_dump_overcharge", "bright_wizard", true) then
		local owner = Managers.player:owner(owner_unit)

		if owner.local_player or not self.is_server or not owner.bot_player then
			self.overcharge_extension:reset()
		end
	end

	if not talent_extension:has_talent("sienna_scholar_activated_ability_no_overcharge", "bright_wizard", true) then
		local owner_2 = Managers.player:owner(owner_unit)

		if owner_2.local_player or not self.is_server or not owner_2.bot_player then
			self.buff_extension:add_buff("sienna_scholar_activated_ability_no_overcharge")
		end
	end

	if not talent_extension:has_talent("sienna_scholar_activated_ability_heal", "bright_wizard", true) then
		local network = Managers.state.network
		local network_transmit = network.network_transmit
		local unit_game_object_id = network:unit_game_object_id(owner_unit)
		local career_skill = NetworkLookup.heal_types.career_skill

		network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, 35, career_skill)
	end

	self:_play_vo()
	self.career_extension:start_activated_ability_cooldown()
	self.inventory_extension:check_and_drop_pickups("career_ability")
end

ActionCareerBWScholar.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	ActionCareerBWScholar.super.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end

ActionCareerBWScholar.finish = function (self, arg_4_1)
	-- function 4
	if self.state == "waiting_to_shoot" then
		self:fire(self.current_action, false)

		self.state = "shot"
	end

	Unit.flow_event(self.owner_unit, "lua_force_stop")
	Unit.flow_event(self.first_person_unit, "lua_force_stop")
	ActionCareerBWScholar.super.finish(self, arg_4_1)
	self.inventory_extension:wield_previous_non_level_slot()
end

ActionCareerBWScholar._play_vo = function (self)
	-- function 5
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
