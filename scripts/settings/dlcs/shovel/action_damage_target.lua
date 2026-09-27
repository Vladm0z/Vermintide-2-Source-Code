-- chunkname: @scripts/settings/dlcs/shovel/action_damage_target.lua

ActionDamageTarget = class(ActionDamageTarget, ActionBase)

ActionDamageTarget.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionDamageTarget.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.owner_unit = arg_1_4
	self.ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self.owner_buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	self.hud_extension = ScriptUnit.has_extension(arg_1_4, "hud_system")

	if not self.first_person_extension then
		self.first_person_unit = self.first_person_extension:get_first_person_unit()
	end

	self._rumble_effect_id = false
	self.unit_id = self.network_manager.unit_storage:go_id(arg_1_4)
end

ActionDamageTarget.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionDamageTarget.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	if not (not arg_2_3 and arg_2_3.target) then
		self._done = true

		self.weapon_extension:stop_action("action_complete")

		return
	end

	self._power_level = arg_2_4
	self._target_unit = arg_2_3.target
	self._damage_steps = arg_2_1.damage_steps
	self._step_idx = 1
	self._num_repeats = 0
	self._anim_time_scale = ActionUtils.get_action_time_scale(self.owner_unit, arg_2_1)
	self._next_update_t = arg_2_2 + arg_2_1.damage_steps[1].start_delay / self._anim_time_scale
	self._done = false

	local _target_unit = self._target_unit
	local node

	if not Unit.has_node(_target_unit, "j_spine") then
		node = Unit.node(_target_unit, "j_spine")

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_2_0::

	self._target_node_id = node
	self._target_hit_zone = arg_2_1.target_node
	self._target_hit_zone_id = NetworkLookup.hit_zones[arg_2_1.target_node]

	local network = Managers.state.network

	self._attacker_unit_id = network:unit_game_object_id(self.owner_unit)
	self._hit_unit_id = network:unit_game_object_id(arg_2_3.target)

	AiUtils.alert_unit(self.owner_unit, self._target_unit)
	self.weapon_system:start_soul_rip(self.owner_unit, arg_2_3.target, node, math.random(0, 65535), true)

	if not self.is_bot then
		local start_charge_sound, var_2_4 = ActionUtils.start_charge_sound(self.wwise_world, self.weapon_unit, self.owner_unit, arg_2_1)

		self.charging_sound_id = start_charge_sound
		self.wwise_source_id = var_2_4
	end
end

ActionDamageTarget._apply_damage_step = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local damage_profile = arg_3_3.damage_profile
	local overcharge_amount = arg_3_3.overcharge_amount
	local get_data = Unit.get_data(arg_3_1, "breed")

	if not get_data then
		overcharge_amount = not get_data.is_player and arg_3_3.overcharge_amount_player_target and overcharge_amount

		if not arg_3_3.can_crit then
			self._is_critical_strike = ActionUtils.is_critical_strike(self.owner_unit, self.current_action, arg_3_4)

			self:_handle_critical_strike(self._is_critical_strike, self.buff_extension, self.hud_extension, self.first_person_extension, "on_critical_shot", nil)
		else
			self._is_critical_strike = false
		end

		if not arg_3_3.proc_buffs then
			local num = 1
			local flag = true
			local charge_value = DamageProfileTemplates[damage_profile].charge_value

			charge_value = charge_value or "instant_projectile"

			local get_item_buff_type = DamageUtils.get_item_buff_type(self.item_name)

			DamageUtils.buff_on_attack(self.owner_unit, arg_3_1, charge_value, self._is_critical_strike, self._target_hit_zone, num, flag, get_item_buff_type, nil, self.item_name)
		end
	end

	local get_ranged_boost, var_3_8 = ActionUtils.get_ranged_boost(self.owner_unit)
	local item_name = self.item_name
	local var_3_10 = NetworkLookup.damage_sources[item_name]
	local _attacker_unit_id = self._attacker_unit_id
	local _hit_unit_id = self._hit_unit_id
	local _target_hit_zone_id = self._target_hit_zone_id
	local world_position = Unit.world_position(arg_3_1, self._target_node_id)
	local current_position = self.first_person_extension:current_position()
	local normalize = Vector3.normalize(world_position - current_position)
	local var_3_17 = NetworkLookup.damage_profiles[damage_profile]

	self.weapon_system:send_rpc_attack_hit(var_3_10, _attacker_unit_id, _hit_unit_id, _target_hit_zone_id, world_position, normalize, var_3_17, "power_level", arg_3_2, "hit_target_index", 1, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", var_3_8, "is_critical_strike", self._is_critical_strike, "can_damage", true, "can_stagger", true, "first_hit", true)

	if not overcharge_amount then
		local owner_buff_extension = self.owner_buff_extension

		if not self._is_critical_strike and not owner_buff_extension:has_buff_perk("no_overcharge_crit") then
			overcharge_amount = 0
		end

		self.overcharge_extension:add_charge(overcharge_amount)
	end
end

ActionDamageTarget.client_owner_post_update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local _target_unit = self._target_unit

	if not (not _target_unit and HEALTH_ALIVE[_target_unit]) then
		self._done = true
		self._target_unit = nil

		if not ALIVE[_target_unit] then
			local current_action = self.current_action

			self.weapon_system:soul_rip_burst(self.owner_unit, _target_unit, self._target_node_id, current_action.last_damage_step_fx_name, math.random(0, 65535), true)
		end

		self:_start_forced_action(arg_4_2)
	end

	if not (self._done or not (arg_4_2 >= self._next_update_t)) then
		local var_4_2 = self._damage_steps[self._step_idx]

		self:_apply_damage_step(_target_unit, self._power_level, var_4_2, arg_4_2)

		self._num_repeats = self._num_repeats + 1

		if self._num_repeats < var_4_2.repeat_count then
			self._next_update_t = arg_4_2 + var_4_2.repeat_delay / self._anim_time_scale
		else
			self._step_idx = self._step_idx + 1

			local var_4_3 = self._damage_steps[self._step_idx]

			if not var_4_3 then
				self._next_update_t = arg_4_2 + var_4_3.start_delay / self._anim_time_scale
				self._num_repeats = 0
			else
				self._done = true

				self:_proc_spell_used(self.owner_buff_extension)
				self:_start_forced_action(arg_4_2)
			end
		end
	end

	if not ALIVE[_target_unit] then
		local world_position = Unit.world_position(_target_unit, self._target_node_id)
		local direction_length, var_4_6 = Vector3.direction_length(world_position - self.first_person_extension:current_position())
		local forward = Quaternion.forward(self.first_person_extension:current_rotation())
		local cos = math.cos(math.degrees_to_radians(45))
		local dot = Vector3.dot(forward, direction_length)

		if dot < cos then
			local num = 5

			if dot < math.cos(math.atan2(num, var_4_6)) then
				self._done = true
				self._target_unit = nil

				self.weapon_extension:stop_action("action_complete")
			end
		end

		if not self._damage_steps[self._step_idx] then
			local current_action_2 = self.current_action

			self.weapon_system:soul_rip_burst(self.owner_unit, _target_unit, self._target_node_id, current_action_2.last_damage_step_fx_name, math.random(0, 65535), true)

			local last_damage_step_sound_event = current_action_2.last_damage_step_sound_event

			if not last_damage_step_sound_event then
				Managers.state.entity:system("audio_system"):play_audio_position_event(last_damage_step_sound_event, world_position)
			end
		end
	end
end

ActionDamageTarget._start_forced_action = function (self, arg_5_1)
	-- function 5
	local force_action_on_complete = self.current_action.force_action_on_complete

	if not force_action_on_complete then
		return
	end

	local action_name = force_action_on_complete.action_name
	local sub_action_name = force_action_on_complete.sub_action_name
	local _power_level = self._power_level
	local weapon_extension = self.weapon_extension
	local item_template_name = self.current_action.lookup_data.item_template_name
	local actions = WeaponUtils.get_weapon_template(item_template_name).actions

	weapon_extension:start_action(action_name, sub_action_name, actions, arg_5_1, _power_level)
end

ActionDamageTarget.finish = function (self, arg_6_1)
	-- function 6
	ActionDamageTarget.super.finish(self, arg_6_1)

	if not self.is_bot then
		ActionUtils.stop_charge_sound(self.wwise_world, self.charging_sound_id, self.wwise_source_id, self.current_action)

		self.charging_sound_id = nil
		self.wwise_source_id = nil
	end

	self.weapon_system:stop_soul_rip(self.owner_unit, true)
end

ActionDamageTarget.destroy = function (arg_7_0)
	-- function 7
	return
end
