-- chunkname: @scripts/settings/dlcs/cog/action_career_dr_engineer_charge.lua

ActionCareerDREngineerCharge = class(ActionCareerDREngineerCharge, ActionBase)

ActionCareerDREngineerCharge.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerDREngineerCharge.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	self.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self.owner_unit = arg_1_4
	self.audio_loop_id = "engineer_weapon_charge"
	self._buff_to_add = "bardin_engineer_pump_buff"
end

ActionCareerDREngineerCharge.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionCareerDREngineerCharge.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.ability_charge_timer = -arg_2_1.initial_charge_delay

	self:start_audio_loop()
end

ActionCareerDREngineerCharge.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local buff_extension = self.buff_extension
	local ability_charge_interval = self.current_action.ability_charge_interval
	local num = self.ability_charge_timer + arg_3_1

	if ability_charge_interval <= num then
		local floor = math.floor(num / ability_charge_interval)

		num = num - floor * ability_charge_interval

		local wwise_world = self.wwise_world
		local _buff_to_add = self._buff_to_add
		local num_buff_type = buff_extension:num_buff_type(_buff_to_add)
		local get_buff_type = buff_extension:get_buff_type(_buff_to_add)

		if not get_buff_type then
			if not self.last_pump_time then
				self.last_pump_time = arg_3_2
			end

			local template = get_buff_type.template

			if not (not (arg_3_2 - self.last_pump_time > 10) or not (num_buff_type >= template.max_stacks)) then
				Managers.state.achievement:trigger_event("clutch_pump", self.owner_unit)
			end

			self.last_pump_time = arg_3_2
		end

		WwiseWorld.set_global_parameter(wwise_world, "engineer_charge", num_buff_type + floor)

		for i = 1, floor do
			buff_extension:add_buff(_buff_to_add)
		end
	end

	self.ability_charge_timer = num
end

ActionCareerDREngineerCharge.finish = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

ActionCareerDREngineerCharge.start_audio_loop = function (self)
	-- function 5
	local current_action = self.current_action
	local charge_sound_name = current_action.charge_sound_name
	local charge_sound_stop_event = current_action.charge_sound_stop_event

	if not (not charge_sound_name and charge_sound_stop_event) then
		return
	end

	local weapon_extension = self.weapon_extension
	local charge_sound_husk_name = current_action.charge_sound_husk_name
	local charge_sound_husk_stop_event = current_action.charge_sound_husk_stop_event

	weapon_extension:add_looping_audio(self.audio_loop_id, charge_sound_name, charge_sound_stop_event, charge_sound_husk_name, charge_sound_husk_stop_event)
	weapon_extension:start_looping_audio(self.audio_loop_id)
end
