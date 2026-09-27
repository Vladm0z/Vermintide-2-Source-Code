-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_overcharge_exploding.lua

PlayerCharacterStateOverchargeExploding = class(PlayerCharacterStateOverchargeExploding, PlayerCharacterState)

PlayerCharacterStateOverchargeExploding.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "overcharge_exploding")

	self.movement_speed = 0
	self.movement_speed_limit = 1
	self.last_input_direction = Vector3Box(0, 0, 0)
	self.inside_inn = global_is_inside_inn
end

PlayerCharacterStateOverchargeExploding.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "exploding")
	CharacterStateHelper.stop_career_abilities(self.career_extension, "exploding")

	local input_extension = self.input_extension
	local first_person_extension = self.first_person_extension
	local status_extension = self.status_extension

	self.damage_timer = arg_2_5 + 0.5
	self.movement_speed = 0.2

	local get_move_animation, var_2_4 = CharacterStateHelper.get_move_animation(self.locomotion_extension, input_extension, status_extension)

	self.move_anim_3p = get_move_animation

	CharacterStateHelper.play_animation_event(arg_2_1, "explode_start")
	CharacterStateHelper.play_animation_event_first_person(first_person_extension, "explode_start")
	self.last_input_direction:store(Vector3.zero())

	self.has_exploded = false

	local extension = ScriptUnit.extension(arg_2_1, "overcharge_system")

	self.explosion_template = extension.explosion_template
	self.no_forced_movement = extension.no_forced_movement
	self.no_explosion = extension.no_explosion

	local overcharge_explosion_time = extension.overcharge_explosion_time

	overcharge_explosion_time = overcharge_explosion_time or 3
	self.explosion_time = arg_2_5 + overcharge_explosion_time
	self.percent_health_lost = extension.percent_health_lost
	self._explode_vfx_name = extension.explode_vfx_name
	self.walking = false
	self.falling = false
end

PlayerCharacterStateOverchargeExploding.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	if not (not Managers.state.network:game() and arg_3_6) then
		return
	end

	CharacterStateHelper.play_animation_event(arg_3_1, "cooldown_end")
	CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, "cooldown_end")

	local extension = ScriptUnit.extension(arg_3_1, "career_system")
	local career_name = extension:career_name()

	if not (self.has_exploded or career_name ~= "bw_unchained" or extension:get_state() == "sienna_activate_unchained") then
		self:explode()
	end

	if not (not self.falling and arg_3_6 == "falling") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end
end

PlayerCharacterStateOverchargeExploding.explode = function (self)
	-- function 4
	self.has_exploded = true

	local unit = self.unit

	StatusUtils.set_overcharge_exploding(unit, false)

	local extension = ScriptUnit.extension(unit, "overcharge_system")

	if not extension.lockout_overcharge_decay_rate then
		extension:set_lockout(true)
	else
		extension:reset()
	end

	if not (self.inside_inn or self.status_extension:is_knocked_down()) then
		local get_max_health = ScriptUnit.extension(unit, "health_system"):get_max_health()
		local percent_health_lost = self.percent_health_lost

		percent_health_lost = percent_health_lost or 1

		local num = get_max_health * percent_health_lost
		local apply_buffs_to_value, var_4_6 = ScriptUnit.extension(unit, "buff_system"):apply_buffs_to_value(0, "overcharge_damage_immunity")

		if not var_4_6 then
			DamageUtils.add_damage_network(unit, unit, num, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, unit, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end

	local num_2 = POSITION_LOOKUP[unit] + Vector3(0, 1.5, 0)
	local local_rotation = Unit.local_rotation(unit, 0)
	local explosion_template = self.explosion_template
	local num_3 = 1

	if not self.no_explosion then
		Managers.state.entity:system("area_damage_system"):create_explosion(unit, num_2, local_rotation, explosion_template, num_3, "overcharge", nil, false)
	end

	if not self._explode_vfx_name then
		local _explode_vfx_name = self._explode_vfx_name
		local var_4_12 = NetworkLookup.effects[_explode_vfx_name]
		local invalid_game_object_id = NetworkConstants.invalid_game_object_id
		local num_4 = 0

		Managers.state.event:trigger("event_play_particle_effect", _explode_vfx_name, nil, num_4, POSITION_LOOKUP[unit], local_rotation, false)

		local network_transmit = Managers.state.network.network_transmit

		if not Managers.player.is_server then
			network_transmit:send_rpc_clients("rpc_play_particle_effect", var_4_12, invalid_game_object_id, num_4, POSITION_LOOKUP[unit], local_rotation, false)
		else
			network_transmit:send_rpc_server("rpc_play_particle_effect", var_4_12, invalid_game_object_id, num_4, POSITION_LOOKUP[unit], local_rotation, false)
		end
	end
end

PlayerCharacterStateOverchargeExploding.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local world = self.world
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_5_1)
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local locomotion_extension = self.locomotion_extension
	local extension = ScriptUnit.extension(arg_5_1, "whereabouts_system")
	local first_person_extension = self.first_person_extension

	if not locomotion_extension:is_on_ground() then
		if not self.falling then
			self.falling = false

			extension:set_landed()
		end

		extension:set_is_onground()
	elseif not self.falling then
		self.falling = true

		extension:set_fell()
	end

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	local temp_params = self.temp_params

	if not (not (arg_5_5 >= self.explosion_time) or not self.has_exploded or status_extension:is_overcharge_exploding()) then
		if not status_extension:is_overcharge_exploding() then
			self:explode()
		end

		if not locomotion_extension:is_on_ground() then
			if not CharacterStateHelper.has_move_input(input_extension) then
				csm:change_state("walking", temp_params)
				first_person_extension:change_state("walking")
			else
				csm:change_state("standing", temp_params)
				first_person_extension:change_state("standing")
			end
		else
			csm:change_state("falling", temp_params)
			first_person_extension:change_state("falling")
		end

		return
	end

	if arg_5_5 > self.damage_timer then
		self.damage_timer = arg_5_5 + 0.5

		if not self.inside_inn then
			DamageUtils.add_damage_network(arg_5_1, arg_5_1, 10, "torso", "overcharge", nil, Vector3(0, 0, 1), "overcharge", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "overcharge_rumble_crit"
		})

		local extension_2 = ScriptUnit.extension(arg_5_1, "locomotion_system")
		local normalize = Vector3.normalize(Vector3(2 * (math.random() - 0.5), 2 * (math.random() - 0.5), 0))

		extension_2:add_external_velocity(normalize, 10)

		self.movement_speed = math.random() * 0.5 + 0.15
		self.movement_speed_limit = self.movement_speed

		first_person_extension:animation_event("overheat_indicator")
	end

	if not self.no_forced_movement then
		return
	end

	local owner = Managers.player:owner(arg_5_1)

	if not CharacterStateHelper.has_move_input(input_extension) then
		self.movement_speed = math.min(1, self.movement_speed + get_movement_settings_table.move_acceleration_up * arg_5_3)
	elseif not owner and not owner.bot_player then
		self.movement_speed = 0
	else
		self.movement_speed = math.max(self.movement_speed_limit, self.movement_speed - get_movement_settings_table.move_acceleration_down * arg_5_3)
	end

	local get = input_extension:get("walk")
	local crouch_move_speed

	if not status_extension:is_crouching() then
		crouch_move_speed = get_movement_settings_table.crouch_move_speed

		if not crouch_move_speed then
			-- Nothing
		end
	end

	if not get then
		crouch_move_speed = get_movement_settings_table.walk_move_speed

		if not crouch_move_speed then
			-- Nothing
		end
	end

	crouch_move_speed = get_movement_settings_table.move_speed

	::label_5_0::

	local current_move_speed_multiplier = status_extension:current_move_speed_multiplier()

	if get ~= self.walking then
		status_extension:set_slowed(get)
	end

	local num = crouch_move_speed * current_move_speed_multiplier * get_movement_settings_table.player_speed_scale * self.movement_speed
	local var_5_16 = Vector3(0, 0.9, 0)
	local get_2 = input_extension:get("move")

	if not get_2 then
		var_5_16 = var_5_16 + get_2
	end

	local get_3 = input_extension:get("move_controller")

	if not get_3 then
		local length = Vector3.length(get_3)

		if length > 0 then
			num = num * length
		end

		var_5_16 = var_5_16 + get_3
	end

	local var_5_20
	local normalize_2 = Vector3.normalize(var_5_16)

	if Vector3.length(normalize_2) == 0 then
		normalize_2 = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize_2)
	end

	CharacterStateHelper.move_on_ground(first_person_extension, input_extension, locomotion_extension, normalize_2, num, arg_5_1)
	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, self.inventory_extension)

	local get_move_animation, var_5_23 = CharacterStateHelper.get_move_animation(locomotion_extension, input_extension, status_extension, self.move_anim_3p)

	if get_move_animation ~= self.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_5_1, get_move_animation)

		self.move_anim_3p = get_move_animation
	end

	self.walking = get
end
