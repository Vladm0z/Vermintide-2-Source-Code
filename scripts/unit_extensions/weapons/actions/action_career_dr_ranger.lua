-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_dr_ranger.lua

ActionCareerDRRanger = class(ActionCareerDRRanger, ActionBase)

ActionCareerDRRanger.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerDRRanger.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self.input_extension = ScriptUnit.extension(arg_1_4, "input_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
end

ActionCareerDRRanger.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionCareerDRRanger.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self.current_action = arg_2_1
	self.action_time_started = arg_2_2
	self.thrown = nil
	self._cooldown_started = false

	local slot_to_wield = arg_2_1.slot_to_wield

	self.inventory_extension:wield(slot_to_wield)

	self.power_level = arg_2_4

	ScriptUnit.extension(self.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end

ActionCareerDRRanger._create_smoke_screen = function (self)
	-- function 3
	local owner_unit = self.owner_unit
	local network_transmit = Managers.state.network.network_transmit
	local extension = ScriptUnit.extension(owner_unit, "status_system")
	local extension_2 = ScriptUnit.extension(owner_unit, "career_system")
	local extension_3 = ScriptUnit.extension(owner_unit, "buff_system")
	local str = "bardin_ranger_activated_ability"
	local extension_4 = ScriptUnit.extension(owner_unit, "talent_system")

	if not extension_4:has_talent("bardin_ranger_ability_free_grenade", "dwarf_ranger", true) then
		extension_3:add_buff("bardin_ranger_ability_free_grenade_buff")
	end

	if not extension_4:has_talent("bardin_ranger_smoke_attack", "dwarf_ranger", true) then
		extension_3:add_buff("bardin_ranger_smoke_attack")
		extension_3:add_buff("bardin_ranger_smoke_heal")
	end

	if not extension_4:has_talent("bardin_ranger_activated_ability_stealth_outside_of_smoke", "dwarf_ranger", true) then
		extension_3:add_buff("bardin_ranger_activated_ability_stealth_outside_of_smoke")

		return
	end

	extension_3:add_buff(str, {
		attacker_unit = owner_unit
	})
end

ActionCareerDRRanger._play_vo = function (self)
	-- function 4
	local owner_unit = self.owner_unit
	local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

ActionCareerDRRanger.client_owner_post_update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not self.thrown then
		return
	end

	local current_action = self.current_action

	if arg_5_2 >= self.action_time_started + current_action.throw_time then
		self:_throw()
	end
end

ActionCareerDRRanger._stagger_explosion = function (self)
	-- function 6
	local owner_unit = self.owner_unit
	local world = self.world
	local is_server = self.is_server
	local network = Managers.state.network
	local network_transmit = network.network_transmit
	local unit_game_object_id = network:unit_game_object_id(owner_unit)
	local str = "bardin_ranger_activated_ability_stagger"
	local get_template = ExplosionUtils.get_template(str)
	local num = 1
	local str_2 = "career_ability"
	local flag = false
	local var_6_11 = POSITION_LOOKUP[owner_unit]
	local identity = Quaternion.identity()
	local var_6_13 = NetworkLookup.explosion_templates[str]
	local var_6_14 = NetworkLookup.damage_sources[str_2]

	if not is_server then
		network_transmit:send_rpc_clients("rpc_create_explosion", unit_game_object_id, false, var_6_11, identity, var_6_13, num, var_6_14, self.power_level, false, unit_game_object_id)
	else
		network_transmit:send_rpc_server("rpc_create_explosion", unit_game_object_id, false, var_6_11, identity, var_6_13, num, var_6_14, self.power_level, false, unit_game_object_id)
	end

	DamageUtils.create_explosion(world, owner_unit, var_6_11, identity, get_template, num, str_2, is_server, flag, owner_unit, self.power_level, false, owner_unit)
end

ActionCareerDRRanger._throw = function (self)
	-- function 7
	self:_create_smoke_screen()
	self:_stagger_explosion()
	self:_play_vo()

	self.thrown = true
end

ActionCareerDRRanger.finish = function (self, arg_8_1)
	-- function 8
	ActionCareerDRRanger.super.finish(self, arg_8_1)

	if not self.thrown then
		self:_throw()
	end

	if not self._cooldown_started then
		self._cooldown_started = true

		self.career_extension:start_activated_ability_cooldown()
	end

	self.inventory_extension:wield_previous_non_level_slot()
end
