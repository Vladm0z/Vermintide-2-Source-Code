-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_wave.lua

ActionCareerBWNecromancerWave = class(ActionCareerBWNecromancerWave, ActionBase)

ActionCareerBWNecromancerWave.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerBWNecromancerWave.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
end

ActionCareerBWNecromancerWave.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	ActionCareerBWNecromancerWave.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	if not arg_2_3 then
		self:_play_vo()
		self._first_person_extension:play_hud_sound_event("Play_career_necro_ability_withering_wave_start", nil, true)
		self:_spawn_wave(arg_2_3.position:unbox(), arg_2_3.direction:unbox())
		self._career_extension:start_activated_ability_cooldown()
	end
end

ActionCareerBWNecromancerWave.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

ActionCareerBWNecromancerWave.finish = function (self, arg_4_1)
	-- function 4
	self._inventory_extension:wield_previous_non_level_slot()
end

ActionCareerBWNecromancerWave._spawn_wave = function (self, arg_5_1, arg_5_2)
	-- function 5
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(self.owner_unit)

	network.network_transmit:send_rpc_server("rpc_necromancer_create_curse_weave", unit_game_object_id, arg_5_1, arg_5_2)
end

ActionCareerBWNecromancerWave._play_vo = function (self)
	-- function 6
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
