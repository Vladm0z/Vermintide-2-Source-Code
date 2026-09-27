-- chunkname: @scripts/unit_extensions/weapons/actions/action_aim_energy.lua

ActionAimEnergy = class(ActionAimEnergy, ActionAim)

ActionAimEnergy.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionAimEnergy.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

ActionAimEnergy.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	ActionAimEnergy.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
end

ActionAimEnergy.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	ActionAimEnergy.super.client_owner_post_update(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	self:_process_energy_draining(arg_3_1, arg_3_2)
end

ActionAimEnergy._process_energy_draining = function (self, arg_4_1, arg_4_2)
	-- function 4
	local flag = false
	local extension = ScriptUnit.extension(self.owner_unit, "energy_system")

	if not extension:is_drainable() then
		local num = self.current_action.drain_rate * arg_4_1

		extension:drain(num)

		flag = extension:is_depleted()
	end

	if not flag then
		self:_fire_shot(arg_4_2)
	end
end

ActionAimEnergy._fire_shot = function (self, arg_5_1)
	-- function 5
	local extension = ScriptUnit.extension(self.owner_unit, "inventory_system")
	local get_item_data_and_weapon_extensions, var_5_2, var_5_3 = CharacterStateHelper.get_item_data_and_weapon_extensions(extension)
	local get_item_template = BackendUtils.get_item_template(get_item_data_and_weapon_extensions)
	local action_on_energy_drained = self.current_action.action_on_energy_drained
	local action_name = action_on_energy_drained.action_name
	local sub_action_name = action_on_energy_drained.sub_action_name
	local actions = get_item_template.actions
	local local_player = Managers.player:local_player()
	local profile_display_name = local_player:profile_display_name()
	local career_name = local_player:career_name()
	local get_total_power_level = BackendUtils.get_total_power_level(profile_display_name, career_name)
	local var_5_13

	ScriptUnit.extension(self.weapon_unit, "weapon_system"):start_action(action_name, sub_action_name, actions, arg_5_1, get_total_power_level, var_5_13)
end
