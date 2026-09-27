-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_charged.lua

PlayerCharacterStateCharged = class(PlayerCharacterStateCharged, PlayerCharacterState)

PlayerCharacterStateCharged.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "charged")

	local var_1_0 = arg_1_1

	self.inputs_to_buffer = {
		wield_4_alt = true,
		wield_2 = true,
		wield_5 = true,
		action_career_release = true,
		action_career = true,
		wield_3 = true,
		wield_1 = true,
		wield_4 = true,
		action_one = true,
		wield_switch = true
	}
	self.movement_speed = 0
	self.movement_speed_limit = 1
	self.last_input_direction = Vector3Box(0, 0, 0)
	self.look_override = Vector3Box(0, 0, 0)
end

PlayerCharacterStateCharged.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "charged")
	CharacterStateHelper.stop_career_abilities(self.career_extension, "charged")
	CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, arg_2_7.first_person_anim_name)
	CharacterStateHelper.play_animation_event(arg_2_1, arg_2_7.third_person_anim_name)

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local hit_react_type = arg_2_7.hit_react_type

	hit_react_type = hit_react_type or "light"

	assert(get_movement_settings_table.hit_react_settings[hit_react_type])

	local var_2_2 = get_movement_settings_table.hit_react_settings[hit_react_type]
	local look_override_function, var_2_4 = var_2_2.look_override_function()

	self.movement_speed = var_2_2.movement_speed_modifier
	self.movement_speed_modifier = var_2_2.movement_speed_modifier
	self.end_look_sense_override = var_2_2.end_look_sense_override
	self.start_look_sense_override = var_2_2.start_look_sense_override

	local duration_function = var_2_2.duration_function()
	local onscreen_particle_function = var_2_2.onscreen_particle_function(duration_function)
	local has_extension = ScriptUnit.has_extension(arg_2_1, "first_person_system")

	if not has_extension and not onscreen_particle_function then
		self.onscreen_particle_id = has_extension:create_screen_particles(onscreen_particle_function)
	end

	if not has_extension then
		has_extension:play_hud_sound_event("Play_enemy_bestigor_charge_impact")
		has_extension:set_wanted_player_height("charged", arg_2_5, duration_function / 2)
	end

	self.last_input_direction:store(Vector3(0, 0, 0))

	if not var_2_4 and not look_override_function then
		self.look_override:store(Vector3(look_override_function, var_2_4, 0))
	end

	self.duration = duration_function
	self.time_in_state = 0
	self.end_time = arg_2_5 + duration_function
	self.next_pulse = 0
	self.current_stagger_speed = 1
	self.last_stagger = Vector3Box(0, 0, 0)

	print("-----Enter charged")
end

PlayerCharacterStateCharged.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local input_extension = self.input_extension

	if not input_extension:get("action_one_hold") then
		input_extension:add_stun_buffer("action_one_hold")
	end

	local has_extension = ScriptUnit.has_extension(arg_3_1, "first_person_system")

	if not has_extension and not self.onscreen_particle_id then
		has_extension:stop_spawning_screen_particles(self.onscreen_particle_id)
	end

	if not has_extension then
		has_extension:set_wanted_player_height("stand", arg_3_5, 0.2)
	end

	self.status_extension:set_charged(false)

	if not CharacterStateHelper.is_block_broken(self.status_extension) then
		self.status_extension:set_block_broken(false)
	end

	print("-----Exit charged")
end

PlayerCharacterStateCharged.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local inventory_extension = self.inventory_extension
	local status_extension = self.status_extension
	local locomotion_extension = self.locomotion_extension
	local world = self.world
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local first_person_extension = self.first_person_extension

	self.time_in_state = self.time_in_state + arg_4_3

	if not first_person_extension and not (self.time_in_state >= self.duration / 2) then
		first_person_extension:set_wanted_player_height("stand", arg_4_5, self.duration / 2)
	end

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm, "charged") then
		return
	end

	if not CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) then
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if arg_4_5 > self.end_time then
		csm:change_state("standing")

		return
	end

	if not CharacterStateHelper.is_overcharge_exploding(status_extension) then
		csm:change_state("overcharge_exploding")

		return
	end

	self:queue_input(arg_4_2, input_extension, inventory_extension)

	local has_move_input = CharacterStateHelper.has_move_input(input_extension)
	local inventory_extension_2 = self.inventory_extension
	local owner = Managers.player:owner(unit)

	if not has_move_input then
		self.movement_speed = math.min(0.75, self.movement_speed + get_movement_settings_table.move_acceleration_up * arg_4_3)
	elseif not owner and not owner.bot_player then
		self.movement_speed = 0
	else
		self.movement_speed = math.max(self.movement_speed_limit, self.movement_speed - get_movement_settings_table.move_acceleration_down * arg_4_3)
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

	::label_4_0::

	local current_move_speed_multiplier = status_extension:current_move_speed_multiplier()

	if get ~= self.walking then
		status_extension:set_slowed(get)
	end

	local num = crouch_move_speed * current_move_speed_multiplier * get_movement_settings_table.player_speed_scale * self.movement_speed
	local var_4_16 = Vector3(0, 0, 0)
	local get_2 = input_extension:get("move")

	if not get_2 then
		var_4_16 = var_4_16 + get_2
	end

	local get_3 = input_extension:get("move_controller")

	if not get_3 then
		local length = Vector3.length(get_3)

		if length > 0 then
			num = num * length
		end

		var_4_16 = var_4_16 + get_3
	end

	local var_4_20

	if arg_4_5 > self.next_pulse then
		local var_4_21 = Vector3(2 * (math.random() - 0.5), 2 * (math.random() - 0.5), 0)
		local normalize = Vector3.normalize(var_4_21)
		local length_2 = Vector3.length(var_4_21)

		self.next_pulse = arg_4_5 + 0.2

		self.last_stagger:store(var_4_21)

		self.current_stagger_speed = 1
	end

	local num_2 = var_4_16 + self.last_stagger:unbox()

	self.current_stagger_speed = math.max(0, self.current_stagger_speed - get_movement_settings_table.move_acceleration_down * arg_4_3)

	local num_3 = num * self.current_stagger_speed * self.movement_speed_modifier
	local var_4_26
	local normalize_2 = Vector3.normalize(num_2)

	if Vector3.length(normalize_2) == 0 then
		normalize_2 = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize_2)
	end

	CharacterStateHelper.move_on_ground(first_person_extension, input_extension, locomotion_extension, normalize_2, num_3, unit)

	self.walking = get

	if not (csm.state_next or locomotion_extension:is_on_ground()) then
		csm:change_state("falling")

		return
	end

	local var_4_28

	if not self.look_override then
		var_4_28 = self.look_override:unbox()
	end

	local num_4 = self.time_in_state / self.duration
	local min = math.min(self.end_look_sense_override, math.lerp(self.start_look_sense_override, 1, num_4))

	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension, min, var_4_28)
	CharacterStateHelper.update_weapon_actions(arg_4_5, unit, input_extension, inventory_extension_2, self.health_extension)
	self.look_override:store(0, 0, 0)
end

PlayerCharacterStateCharged.queue_input = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local wield_input = CharacterStateHelper.wield_input(arg_5_2, arg_5_3, "action_wield")

	if not wield_input then
		arg_5_2:add_buffer(wield_input)
	end

	for k, v in pairs(self.inputs_to_buffer) do
		if not arg_5_2:get(k) then
			arg_5_2:add_stun_buffer(k)

			break
		end
	end
end
