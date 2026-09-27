-- chunkname: @scripts/settings/dlcs/woods/action_spirit_storm.lua

ActionSpiritStorm = class(ActionSpiritStorm, ActionBase)

ActionSpiritStorm.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionSpiritStorm.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
end

ActionSpiritStorm.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionSpiritStorm.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self.current_action = arg_2_1

	local owner_unit = self.owner_unit

	self.owner_buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
	self.state = "waiting_to_shoot"

	local fire_time = arg_2_1.fire_time

	fire_time = fire_time or 0
	self.time_to_shoot = arg_2_2 + fire_time
	self.target = arg_2_3.target
	self.is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1)
end

ActionSpiritStorm.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local current_action = self.current_action

	if not (self.state ~= "waiting_to_shoot" or not (arg_3_2 >= self.time_to_shoot)) then
		self.state = "shooting"
	end

	if self.state == "shooting" then
		self:fire()

		self.state = "doing_damage"
	end

	if self.state == "doing_damage" then
		self:_proc_spell_used(self.owner_buff_extension)

		self.state = "shot"
	end
end

ActionSpiritStorm.finish = function (self, arg_4_1)
	-- function 4
	if not (self.state == "waiting_to_shoot" or self.state == "shot") then
		self:_proc_spell_used(self.owner_buff_extension)
	end

	self.position = nil

	local has_extension = ScriptUnit.has_extension(self.owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end
end

ActionSpiritStorm.fire = function (self, arg_5_1)
	-- function 5
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local target = self.target
	local var_5_3 = POSITION_LOOKUP[target]
	local overcharge_amount = current_action.overcharge_amount

	if not var_5_3 then
		local go_id = Managers.state.unit_storage:go_id(owner_unit)
		local go_id_2 = Managers.state.unit_storage:go_id(self.target)

		self.network_transmit:send_rpc_server("rpc_summon_vortex", go_id, go_id_2)

		local get_data = Unit.get_data(target, "breed")

		if not get_data and not get_data.is_player then
			overcharge_amount = current_action.overcharge_amount_player_target or overcharge_amount

			if not current_action.player_target_buff then
				self.owner_buff_extension:add_buff(current_action.player_target_buff)
			end
		end
	end

	if not overcharge_amount then
		local owner_buff_extension = self.owner_buff_extension

		if not self.is_critical_strike and not owner_buff_extension:has_buff_perk("no_overcharge_crit") then
			overcharge_amount = 0
		end

		self.overcharge_extension:add_charge(overcharge_amount)
	end

	local fire_sound_event = self.current_action.fire_sound_event

	if not fire_sound_event then
		local fire_sound_on_husk = self.current_action.fire_sound_on_husk

		ScriptUnit.extension(owner_unit, "first_person_system"):play_hud_sound_event(fire_sound_event, nil, fire_sound_on_husk)
	end

	if not current_action.alert_enemies and not var_5_3 then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, var_5_3, current_action.alert_sound_range_fire)
	end
end
