-- chunkname: @scripts/unit_extensions/weapons/actions/action_base.lua

ActionBase = class(ActionBase)

local flow_event = Unit.flow_event

ActionBase.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	self.world = arg_1_1
	self.physics_world = World.get_data(arg_1_1, "physics_world")
	self.wwise_world = Managers.world:wwise_world(arg_1_1)
	self.first_person_unit = arg_1_6
	self.owner_unit = arg_1_4
	self.owner = Managers.player:unit_owner(arg_1_4)
	self.owner_player = Managers.player:owner(arg_1_4)
	self.weapon_unit = arg_1_7
	self.item_name = arg_1_2
	self.weapon_system = arg_1_8

	local network = Managers.state.network

	self.network_manager = network
	self.network_transmit = network.network_transmit
	self.is_server = arg_1_3

	local owner_player = self.owner_player

	owner_player = not owner_player and self.owner_player.bot_player
	self.is_bot = owner_player
	self._is_critical_strike = false
	self._fatigue_reset = true
	self._extra_shots = 0
	self._extra_shots_procced = false
end

ActionBase.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	self.current_action = arg_2_1

	ScriptUnit.has_extension(self.owner_unit, "buff_system"):trigger_procs("on_start_action", arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	self._fatigue_reset = true
	self._extra_shots_procced = false
	self.action_start_t = arg_2_2
end

ActionBase._handle_critical_strike = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	if not arg_3_1 then
		self:_do_critical_strike_fx(arg_3_3, arg_3_4, arg_3_6)
		self:_do_critical_strike_procs(arg_3_2, arg_3_5)
	end
end

ActionBase._do_critical_strike_fx = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local owner_unit = self.owner_unit
	local first_person_unit = self.first_person_unit

	if Application.user_setting("weapon_trails") == "normal" then
		flow_event(owner_unit, "vfx_critical_strike")
		flow_event(first_person_unit, "vfx_critical_strike")
	end

	if not arg_4_1 then
		arg_4_1.show_critical_indication = true
	end

	if not arg_4_2 and not arg_4_3 then
		arg_4_2:play_hud_sound_event(arg_4_3, nil, false)
	end
end

ActionBase._do_critical_strike_procs = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_1 and not arg_5_2 then
		arg_5_1:trigger_procs(arg_5_2)
	end
end

ActionBase._update_extra_shots = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local current_action = self.current_action

	if not current_action and not current_action.no_extra_shots then
		return nil
	end

	if not self._extra_shots_procced and not arg_6_3 then
		local apply_buffs_to_value = arg_6_1:apply_buffs_to_value(0, "extra_shot")

		self._extra_shots = math.floor(apply_buffs_to_value)
		self._extra_shots_procced = true
	end

	if self._extra_shots > 0 then
		if not arg_6_2 then
			self._extra_shots = self._extra_shots - arg_6_2
		end

		return self._extra_shots
	end
end

ActionBase._handle_fatigue = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local var_7_0

	if not self._fatigue_reset then
		if not arg_7_4 then
			var_7_0 = arg_7_1:has_buff_perk("no_push_fatigue_cost")
		end

		if not var_7_0 then
			local str = "action_push"
			local num = 1

			if not arg_7_3.fatigue_cost then
				str = arg_7_3.fatigue_cost
			end

			if not arg_7_1:has_buff_perk("slayer_stamina") then
				num = 0.5
			end

			arg_7_2:add_fatigue_points(str, nil, nil, num)
			arg_7_2:set_has_pushed(arg_7_3.fatigue_regen_delay)
		end

		self._fatigue_reset = false
	end
end

ActionBase._proc_spell_used = function (self, arg_8_1)
	-- function 8
	local current_action = self.current_action

	if not arg_8_1 and not current_action and not current_action.is_spell then
		arg_8_1:trigger_procs("on_spell_used", current_action)
	end
end

ActionBase._play_additional_animation = function (self, arg_9_1)
	-- function 9
	if not arg_9_1 and not arg_9_1.variable_name and not arg_9_1.variable_value then
		if not arg_9_1.third_person then
			local owner_unit = self.owner_unit

			if not owner_unit then
				if not arg_9_1.anim_event then
					CharacterStateHelper.play_animation_event_with_variable_float(owner_unit, arg_9_1.anim_event, arg_9_1.variable_name, arg_9_1.variable_value)
				else
					CharacterStateHelper.set_animation_variable_float(owner_unit, arg_9_1.variable_name, arg_9_1.variable_value)
				end
			end
		end

		if not arg_9_1.first_person then
			local first_person_unit = self.first_person_unit

			if not first_person_unit then
				local animation_find_variable = Unit.animation_find_variable(first_person_unit, arg_9_1.variable_name)

				Unit.animation_set_variable(first_person_unit, animation_find_variable, arg_9_1.variable_value)

				if not arg_9_1.anim_event then
					Unit.animation_event(first_person_unit, arg_9_1.anim_event)
				end
			end
		end
	end
end

ActionBase.finish = function (arg_10_0, arg_10_1)
	-- function 10
	return
end
