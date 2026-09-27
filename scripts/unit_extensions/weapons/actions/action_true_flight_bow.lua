-- chunkname: @scripts/unit_extensions/weapons/actions/action_true_flight_bow.lua

require("scripts/unit_extensions/weapons/projectiles/true_flight_templates")

ActionTrueFlightBow = class(ActionTrueFlightBow, ActionBase)

ActionTrueFlightBow.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionTrueFlightBow.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
end

ActionTrueFlightBow.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionTrueFlightBow.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	self.current_action = arg_2_1
	self.true_flight_template_id = TrueFlightTemplates[arg_2_1.true_flight_template].lookup_id

	assert(self.true_flight_template_id)

	local owner_unit = self.owner_unit
	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)
	local _update_extra_shots = self:_update_extra_shots(extension)

	_update_extra_shots = _update_extra_shots or 0
	self.num_extra_shots = _update_extra_shots

	self:_update_extra_shots(extension, _update_extra_shots)

	local num_projectiles = arg_2_1.num_projectiles

	num_projectiles = num_projectiles or 1
	self.num_projectiles = num_projectiles + _update_extra_shots

	if not ScriptUnit.has_extension(owner_unit, "talent_system"):has_talent("kerillian_waywatcher_activated_ability_additional_projectile") then
		self.num_projectiles = self.num_projectiles + 1
	end

	local multi_projectile_spread = arg_2_1.multi_projectile_spread

	multi_projectile_spread = multi_projectile_spread or 0.075
	self.multi_projectile_spread = multi_projectile_spread
	self.num_projectiles_shot = 1

	if not arg_2_3 then
		self.targets = arg_2_3.targets

		if not self.targets then
			self.targets = {
				arg_2_3.target
			}
		end
	end

	if not arg_2_5 then
		self.targets = arg_2_5.targets

		if not self.targets then
			self.targets = {
				arg_2_5.target
			}
		end
	end

	self.state = "waiting_to_shoot"

	local fire_time = arg_2_1.fire_time

	fire_time = fire_time or 0
	self.time_to_shoot = arg_2_2 + fire_time
	self.power_level = arg_2_4
	self.extra_buff_shot = false

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike
end

ActionTrueFlightBow.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local current_action = self.current_action

	if not (self.state ~= "waiting_to_shoot" or not (arg_3_2 >= self.time_to_shoot)) then
		self.state = "shooting"
	end

	if self.state == "shooting" then
		self:fire(current_action)

		self.state = "shot"

		local first_person_extension = self.first_person_extension

		if not self.current_action.reset_aim_on_attack then
			first_person_extension:reset_aim_assist_multiplier()
		end

		local fire_sound_event = self.current_action.fire_sound_event

		if not fire_sound_event then
			local fire_sound_on_husk = self.current_action.fire_sound_on_husk

			first_person_extension:play_hud_sound_event(fire_sound_event, nil, fire_sound_on_husk)
		end

		if not self.current_action.extra_fire_sound_event then
			local var_3_4 = POSITION_LOOKUP[self.owner_unit]

			WwiseUtils.trigger_position_event(self.world, self.current_action.extra_fire_sound_event, var_3_4)
		end
	end
end

ActionTrueFlightBow.finish = function (self, arg_4_1, arg_4_2)
	-- function 4
	local extension = ScriptUnit.extension(self.owner_unit, "status_system")

	if not (not arg_4_2 and arg_4_2.new_action ~= "action_two" or arg_4_2.new_sub_action == "default") then
		extension:set_zooming(false)
	end
end

ActionTrueFlightBow.fire = function (self, arg_5_1)
	-- function 5
	local owner_unit = self.owner_unit
	local speed = arg_5_1.speed
	local get_projectile_start_position_rotation, var_5_3 = self.first_person_extension:get_projectile_start_position_rotation()
	local spread_extension = self.spread_extension
	local num_projectiles = self.num_projectiles
	local num = num_projectiles - self.num_extra_shots + 1

	for i = 1, num_projectiles do
		local var_5_7 = var_5_3
		local flag = num <= i

		if not spread_extension then
			if self.num_projectiles_shot > 1 then
				local num_2 = math.pi * (self.num_projectiles_shot % 2 + 0.5)
				local flag_2

				flag_2 = self.num_projectiles_shot ~= 1 or not 0 or math.round((self.num_projectiles_shot - 1) * 0.5, 0)

				local num_3 = self.multi_projectile_spread * flag_2

				var_5_7 = spread_extension:combine_spread_rotations(num_2, num_3, var_5_7)
			end

			if not flag then
				spread_extension:set_shooting()
			end
		end

		local pitch_from_rotation = ActionUtils.pitch_from_rotation(var_5_7)
		local normalize = Vector3.normalize(Quaternion.forward(var_5_7))

		if i > 1 then
			speed = speed * (1 - i * 0.05)
		end

		local targets = self.targets

		if not targets then
			if not arg_5_1.single_target then
				targets = self.targets[1]

				if not targets then
					-- Nothing
				end
			end

			targets = self.targets[i]
		end

		::label_5_0::

		local lookup_data = arg_5_1.lookup_data
		local num_4 = 1

		ActionUtils.spawn_true_flight_projectile(owner_unit, targets, self.true_flight_template_id, get_projectile_start_position_rotation, var_5_7, pitch_from_rotation, normalize, speed, self.item_name, lookup_data.item_template_name, lookup_data.action_name, lookup_data.sub_action_name, num_4, self._is_critical_strike, self.power_level)

		if not (not self.ammo_extension and flag) then
			local ammo_usage = self.current_action.ammo_usage

			self.ammo_extension:use_ammo(ammo_usage)

			if not self.ammo_extension:can_reload() then
				local flag_3 = false

				self.ammo_extension:start_reload(flag_3)
			end
		end

		self.num_projectiles_shot = self.num_projectiles_shot + 1

		local overcharge_type = arg_5_1.overcharge_type

		if not (not overcharge_type and flag) then
			local var_5_20 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]

			if not arg_5_1.scale_overcharge then
				self.overcharge_extension:add_charge(var_5_20, self.charge_level)
			else
				self.overcharge_extension:add_charge(var_5_20)
			end
		end

		if not arg_5_1.alert_sound_range_fire then
			Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], arg_5_1.alert_sound_range_fire)
		end
	end
end
