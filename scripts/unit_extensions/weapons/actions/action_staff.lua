-- chunkname: @scripts/unit_extensions/weapons/actions/action_staff.lua

ActionStaff = class(ActionStaff, ActionBase)

ActionStaff.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionStaff.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	if not ScriptUnit.has_extension(arg_1_7, "spread_system") then
		self.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
	end

	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
end

ActionStaff.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionStaff.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self.current_action = arg_2_1

	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)

	self.state = "waiting_to_shoot"

	local fire_time = arg_2_1.fire_time

	fire_time = fire_time or 0
	self.time_to_shoot = arg_2_2 + fire_time
	self.power_level = arg_2_4

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, nil, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike
end

ActionStaff.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not (self.state ~= "waiting_to_shoot" or not (arg_3_2 >= self.time_to_shoot)) then
		self.state = "shooting"
	end

	if self.state == "shooting" then
		self:fire()

		self.state = "shot"
	end
end

ActionStaff.finish = function (self, arg_4_1)
	-- function 4
	local has_extension = ScriptUnit.has_extension(self.owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end
end

ActionStaff.fire = function (self, arg_5_1)
	-- function 5
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local get_projectile_start_position_rotation, var_5_3 = ScriptUnit.extension(owner_unit, "first_person_system"):get_projectile_start_position_rotation()
	local spread_extension = self.spread_extension

	if not spread_extension then
		var_5_3 = spread_extension:get_randomised_spread(var_5_3)

		spread_extension:set_shooting()
	end

	local pitch_from_rotation = ActionUtils.pitch_from_rotation(var_5_3)
	local speed = current_action.speed
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(var_5_3)))
	local lookup_data = current_action.lookup_data

	ActionUtils.spawn_player_projectile(owner_unit, get_projectile_start_position_rotation, var_5_3, 0, pitch_from_rotation, normalize, speed, self.item_name, lookup_data.item_template_name, lookup_data.action_name, lookup_data.sub_action_name, self._is_critical_strike, self.power_level)

	if not self.ammo_extension then
		local ammo_usage = current_action.ammo_usage

		self.ammo_extension:use_ammo(ammo_usage)
	end

	local overcharge_type = current_action.overcharge_type

	if not overcharge_type then
		local var_5_11 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]

		self.overcharge_extension:add_charge(var_5_11)
	end

	if not self.ammo_extension and not self.ammo_extension:can_reload() then
		local flag = true

		self.ammo_extension:start_reload(flag)
	end

	local fire_sound_event = current_action.fire_sound_event

	if not fire_sound_event then
		WwiseUtils.trigger_unit_event(self.world, fire_sound_event, self.weapon_unit)
	end
end
