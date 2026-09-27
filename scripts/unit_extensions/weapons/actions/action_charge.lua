-- chunkname: @scripts/unit_extensions/weapons/actions/action_charge.lua

ActionCharge = class(ActionCharge, ActionBase)

ActionCharge.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCharge.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_4, "inventory_system") then
		local extension = ScriptUnit.extension(self.owner_unit, "inventory_system")
		local get_wielded_slot_name = extension:get_wielded_slot_name()

		self.left_unit = extension:get_slot_data(get_wielded_slot_name).left_unit_1p
	end

	self.status_extension = ScriptUnit.has_extension(arg_1_4, "status_system")
	self.spread_extension = ScriptUnit.has_extension(arg_1_7, "spread_system")
	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self.ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
	self._rumble_effect_id = nil
end

ActionCharge.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionCharge.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	local owner_unit = self.owner_unit

	self.current_action = arg_2_1

	local audio_loop_id = arg_2_1.audio_loop_id

	audio_loop_id = audio_loop_id or "charge"
	self.audio_loop_id = audio_loop_id
	self.charge_ready_sound_event = self.current_action.charge_ready_sound_event
	self.charge_flow_event_left_weapon = arg_2_1.charge_flow_event_left_weapon
	self.venting_overcharge = nil
	self._max_charge = false

	local overcharge_extension = self.overcharge_extension

	if not (not arg_2_1.vent_overcharge and not overcharge_extension and not (overcharge_extension:get_overcharge_value() > 0)) then
		overcharge_extension:vent_overcharge()

		self.venting_overcharge = true
	end

	self.fully_charged_triggered = false
	self.total_overcharge_added = 0
	self.remove_overcharge_on_interrupt = arg_2_1.remove_overcharge_on_interrupt

	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.buff_extension = extension
	self.charge_level = 0
	self.charge_time = extension:apply_buffs_to_value(arg_2_1.charge_time, "reduced_ranged_charge_time")
	self.charge_complete_time = self.charge_time + arg_2_2
	self.overcharge_timer = 0
	self.ability_charge_timer = 0
	self.ammo_consumption_timer = 0

	if not arg_2_1.vent_overcharge then
		Unit.flow_event(self.first_person_unit, "lua_charge_start")
	end

	local charge_effect_name = arg_2_1.charge_effect_name

	if not charge_effect_name then
		local weapon_unit = self.weapon_unit
		local node = Unit.node(weapon_unit, "fx_muzzle")

		self.particle_id = ScriptWorld.create_particles_linked(self.world, charge_effect_name, weapon_unit, node, "destroy")

		if not self.left_unit then
			local node_2 = Unit.node(self.left_unit, "fx_muzzle")

			self.left_particle_id = ScriptWorld.create_particles_linked(self.world, charge_effect_name, self.left_unit, node_2, "destroy")
		end
	end

	self:_start_charge_sound()

	local spread_template_override = arg_2_1.spread_template_override

	if not spread_template_override then
		self.spread_extension:override_spread_template(spread_template_override)
	end

	if not arg_2_1.zoom then
		local extension_2 = ScriptUnit.extension(self.owner_unit, "status_system")

		if not extension_2:is_zooming() then
			extension_2:set_zooming(true)
		end
	end

	local loaded_projectile_settings = arg_2_1.loaded_projectile_settings

	if not loaded_projectile_settings then
		ScriptUnit.extension(self.owner_unit, "inventory_system"):set_loaded_projectile_override(loaded_projectile_settings)
	end
end

ActionCharge._start_charge_sound = function (self)
	-- function 3
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

	local owner_player = self.owner_player

	if not owner_player then
		-- Nothing
	end

	::label_3_0::

	local bot_player = owner_player.bot_player

	bot_player = not bot_player and not owner_player.remote

	::label_3_1::

	if not bot_player then
		local charge_sound_switch = current_action.charge_sound_switch

		if not charge_sound_switch then
			local flag

			flag = not ScriptUnit.extension(self.owner_unit, "overcharge_system"):above_overcharge_threshold() and "above_overcharge_threshold" and "below_overcharge_threshold"

			weapon_extension:set_looping_audio_switch(self.audio_loop_id, charge_sound_switch, flag)
		end

		local charge_sound_parameter_name = current_action.charge_sound_parameter_name

		if not charge_sound_parameter_name then
			weapon_extension:update_looping_audio_parameter(self.audio_loop_id, charge_sound_parameter_name, 1)
		end
	end

	weapon_extension:start_looping_audio(self.audio_loop_id)
end

ActionCharge._stop_charge_sound = function (self, arg_4_1)
	-- function 4
	local charge_sound_stop_event_condition_func = self.current_action.charge_sound_stop_event_condition_func

	if not (not charge_sound_stop_event_condition_func and charge_sound_stop_event_condition_func(self.owner_unit, arg_4_1)) then
		return
	end

	self.weapon_extension:stop_looping_audio(self.audio_loop_id)
end

ActionCharge.client_owner_post_update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local current_action = self.current_action
	local charge_time = self.charge_time
	local num = self.charge_complete_time - arg_5_2

	if not current_action.ammo_charge then
		local ammo_extension = self.ammo_extension

		if not (not ammo_extension and not (ammo_extension:current_ammo() < 1)) then
			return
		end
	end

	local overcharge_type = current_action.overcharge_type
	local var_5_5

	if not (not (num > 0) or not (charge_time > 0)) then
		var_5_5 = 1 - num / charge_time
	elseif not ((not (num > 0) or not (charge_time <= 0) or not (num <= 0)) and (not (charge_time > 0) or not (num <= 0) or not (charge_time <= 0))) then
		var_5_5 = 1
	end

	local max = math.max(math.min(var_5_5, 1), 0)

	if not (current_action.vent_overcharge or not (max >= 1) or self._max_charge) then
		self._max_charge = true

		Unit.flow_event(self.first_person_unit, "lua_max_charge")

		if not self.fully_charged_triggered then
			self.buff_extension:trigger_procs("on_full_charge")

			self.fully_charged_triggered = true
		end
	end

	local overcharge_extension = self.overcharge_extension
	local extension = ScriptUnit.extension(self.owner_unit, "inventory_system")
	local extension_2 = ScriptUnit.extension(self.owner_unit, "career_system")

	if not overcharge_type and overcharge_extension:get_overcharge_value() ~= 0 or not self.venting_overcharge then
		CharacterStateHelper.stop_weapon_actions(extension, "no_more_overcharge")
		CharacterStateHelper.stop_career_abilities(extension_2, "no_more_overcharge")
	end

	if not current_action.overcharge_interval then
		self.overcharge_timer = self.overcharge_timer + arg_5_1

		if self.overcharge_timer >= current_action.overcharge_interval then
			if not overcharge_type then
				local var_5_10 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]

				if not (not self.remove_overcharge_on_interrupt and var_5_5 ~= 1) then
					var_5_10 = PlayerUnitStatusSettings.overcharge_values.drakegun_charging
				end

				self.overcharge_extension:add_charge(var_5_10, nil, overcharge_type)

				self.total_overcharge_added = self.total_overcharge_added + var_5_10
			end

			self.overcharge_timer = 0
		end
	end

	if not current_action.ammo_charge then
		self.ammo_consumption_timer = self.ammo_consumption_timer + arg_5_1

		if self.ammo_consumption_timer >= current_action.charge_time / current_action.ammo_per_clip then
			local ammo_extension_2 = self.ammo_extension

			if not ammo_extension_2 then
				ammo_extension_2:use_ammo(1)
			end

			self.ammo_consumption_timer = 0
		end
	end

	if not current_action.charge_anim_variable then
		self.first_person_extension:animation_set_variable(current_action.charge_anim_variable, max)
	end

	local particle_id = self.particle_id
	local charge_effect_material_name = current_action.charge_effect_material_name
	local charge_effect_material_variable_name = current_action.charge_effect_material_variable_name

	if not charge_effect_material_name and not charge_effect_material_variable_name and not particle_id and not World.has_particles_material(arg_5_3, particle_id, charge_effect_material_name) then
		World.set_particles_material_scalar(arg_5_3, particle_id, charge_effect_material_name, charge_effect_material_variable_name, max)
	end

	local left_particle_id = self.left_particle_id
	local charge_effect_material_name_2 = current_action.charge_effect_material_name
	local charge_effect_material_variable_name_2 = current_action.charge_effect_material_variable_name

	if not charge_effect_material_name_2 and not charge_effect_material_variable_name_2 and not left_particle_id and not World.has_particles_material(arg_5_3, left_particle_id, charge_effect_material_name_2) then
		World.set_particles_material_scalar(arg_5_3, left_particle_id, charge_effect_material_name_2, charge_effect_material_variable_name_2, max)
	end

	local owner_unit = self.owner_unit
	local owner = Managers.player:owner(owner_unit)

	if not (not owner and owner.bot_player) then
		local charge_sound_parameter_name = current_action.charge_sound_parameter_name

		if not charge_sound_parameter_name then
			local wwise_world = self.wwise_world
			local wwise_source_id = self.wwise_source_id

			WwiseWorld.set_source_parameter(wwise_world, wwise_source_id, charge_sound_parameter_name, max)
		end

		if not (not self.charge_ready_sound_event and not (max >= 1)) then
			self.first_person_extension:play_hud_sound_event(self.charge_ready_sound_event)

			self.charge_ready_sound_event = nil
		end

		if (not (max >= 1) or not self.charge_flow_event_left_weapon) and not self.left_unit then
			Unit.flow_event(self.left_unit, self.charge_flow_event_left_weapon)

			self.charge_flow_event_left_weapon = nil
		end
	end

	if not (not (max >= 1) or Managers.player:owner(self.owner_unit).bot_player or self._rumble_effect_id) then
		self._rumble_effect_id = Managers.state.controller_features:add_effect("persistent_rumble", {
			rumble_effect = "reload_start"
		})
	end

	self.charge_level = max
end

ActionCharge._clean_up = function (self, arg_6_1)
	-- function 6
	if not self.particle_id then
		World.destroy_particles(self.world, self.particle_id)

		self.particle_id = nil
	end

	if not self.left_particle_id then
		World.destroy_particles(self.world, self.left_particle_id)

		self.left_particle_id = nil
	end

	if not self._rumble_effect_id then
		Managers.state.controller_features:stop_effect(self._rumble_effect_id)

		self._rumble_effect_id = nil
	end

	self:_stop_charge_sound(arg_6_1)
end

ActionCharge.finish = function (self, arg_7_1)
	-- function 7
	local owner_unit = self.owner_unit
	local first_person_unit = self.first_person_unit
	local current_action = self.current_action

	self:_clean_up(arg_7_1)

	local overcharge_extension = self.overcharge_extension

	if not current_action.vent_overcharge and not overcharge_extension then
		overcharge_extension:vent_overcharge_done()
	end

	if not self.remove_overcharge_on_interrupt then
		if arg_7_1 == "interrupted" then
			overcharge_extension:remove_charge(self.total_overcharge_added * 0.75)
		elseif arg_7_1 == "hold_input_released" then
			overcharge_extension:remove_charge(self.total_overcharge_added * 0.5)
		end
	end

	if not (arg_7_1 == "hold_input_released" or arg_7_1 ~= "weapon_wielded") then
		Unit.flow_event(first_person_unit, "lua_charge_cancel")
	end

	Unit.flow_event(first_person_unit, "lua_charge_stop")

	if not self.spread_extension then
		self.spread_extension:reset_spread_template()
	end

	if not current_action.zoom then
		ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)
	end

	ScriptUnit.extension(self.owner_unit, "inventory_system"):set_loaded_projectile_override(nil)
	self.buff_extension:trigger_procs("on_charge_finished")

	return {
		charge_level = self.charge_level
	}
end

ActionCharge.destroy = function (self)
	-- function 8
	self:_clean_up()
end
