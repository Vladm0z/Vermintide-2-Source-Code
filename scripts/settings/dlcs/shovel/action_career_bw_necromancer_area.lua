-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_area.lua

ActionCareerBWNecromancerArea = class(ActionCareerBWNecromancerArea, ActionBase)

ActionCareerBWNecromancerArea.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerBWNecromancerArea.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
end

ActionCareerBWNecromancerArea.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	ActionCareerBWNecromancerArea.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	if not arg_2_3 then
		self:_play_vo()
		self._first_person_extension:play_hud_sound_event("Play_career_necro_ability_withering_wave_start", nil, true)
		self:_create_damage_area(arg_2_3.position:unbox())
		self:_add_buffs()
		self._career_extension:start_activated_ability_cooldown()
	end
end

ActionCareerBWNecromancerArea._create_damage_area = function (self, arg_3_1)
	-- function 3
	local owner_unit = self.owner_unit
	local network = Managers.state.network
	local network_transmit = network.network_transmit
	local unit_game_object_id = network:unit_game_object_id(self.owner_unit)

	network_transmit:send_rpc_server("rpc_necromancer_create_curse_area", unit_game_object_id, arg_3_1)
end

ActionCareerBWNecromancerArea._add_buffs = function (self)
	-- function 4
	local str = "sienna_necromancer_cursed_area"
	local owner_unit = self.owner_unit

	self._buff_extension:add_buff(str, {
		attacker_unit = owner_unit
	})
end

ActionCareerBWNecromancerArea.client_owner_post_update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	return
end

ActionCareerBWNecromancerArea._play_vo = function (self)
	-- function 6
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

ActionCareerBWNecromancerArea.finish = function (self, arg_7_1)
	-- function 7
	self._inventory_extension:wield_previous_non_level_slot()
end
