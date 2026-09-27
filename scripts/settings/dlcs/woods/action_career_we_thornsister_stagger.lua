-- chunkname: @scripts/settings/dlcs/woods/action_career_we_thornsister_stagger.lua

ActionCareerWEThornsisterStagger = class(ActionCareerWEThornsisterStagger, ActionBase)

ActionCareerWEThornsisterStagger.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerWEThornsisterStagger.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self._network_transmit = Managers.state.network.network_transmit
end

ActionCareerWEThornsisterStagger.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	ActionCareerWEThornsisterStagger.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	self:_play_vo()

	local career_extension = self.career_extension

	career_extension:start_activated_ability_cooldown()

	local var_2_1 = arg_2_3

	if not var_2_1 then
		local is_server = self.is_server
		local flag = false
		local str = "we_thornsister_career_skill_stagger_spell"
		local get_template = ExplosionUtils.get_template(str)
		local num = 1
		local str_2 = "career_ability"
		local get_career_power_level = career_extension:get_career_power_level()
		local owner_unit = self.owner_unit
		local var_2_10 = POSITION_LOOKUP[owner_unit]
		local look = Quaternion.look(var_2_1.direction:unbox(), Vector3.up())

		DamageUtils.create_explosion(self.world, owner_unit, var_2_10, look, get_template, num, str_2, is_server, flag, owner_unit, get_career_power_level, false, owner_unit)

		local network = Managers.state.network
		local network_transmit = network.network_transmit
		local unit_game_object_id = network:unit_game_object_id(owner_unit)
		local var_2_15 = NetworkLookup.explosion_templates[str]
		local var_2_16 = NetworkLookup.damage_sources[str_2]

		if not is_server then
			network_transmit:send_rpc_clients("rpc_create_explosion", unit_game_object_id, false, var_2_10, look, var_2_15, num, var_2_16, get_career_power_level, false, unit_game_object_id)
		else
			network_transmit:send_rpc_server("rpc_create_explosion", unit_game_object_id, false, var_2_10, look, var_2_15, num, var_2_16, get_career_power_level, false, unit_game_object_id)
		end
	end
end

ActionCareerWEThornsisterStagger.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

ActionCareerWEThornsisterStagger.finish = function (self, arg_4_1)
	-- function 4
	self.inventory_extension:wield_previous_non_level_slot()
end

ActionCareerWEThornsisterStagger._play_vo = function (self)
	-- function 5
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
