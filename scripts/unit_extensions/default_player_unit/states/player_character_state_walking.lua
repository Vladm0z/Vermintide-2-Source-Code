-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_walking.lua

PlayerCharacterStateWalking = class(PlayerCharacterStateWalking, PlayerCharacterState)

PlayerCharacterStateWalking.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "walking")

	self.current_movement_speed_scale = 0
	self.latest_valid_navmesh_position = Vector3Box(math.huge, math.huge, math.huge)
	self.last_input_direction = Vector3Box(0, 0, 0)
end

PlayerCharacterStateWalking.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local input_extension = self.input_extension
	local first_person_extension = self.first_person_extension
	local status_extension = self.status_extension
	local inventory_extension = self.inventory_extension
	local health_extension = self.health_extension
	local current_velocity = self.locomotion_extension:current_velocity()
	local owner = Managers.player:owner(arg_2_1)
	local flag = not owner and owner.bot_player

	if arg_2_6 == "standing" then
		self.current_movement_speed_scale = 0
	elseif not script_data.disable_nice_movement then
		local length = Vector3.length(current_velocity)
		local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)

		self.current_movement_speed_scale = math.min(length / get_movement_settings_table.move_speed, 1)
	else
		self.current_movement_speed_scale = 1
	end

	if not flag then
		local normalize = Vector3.normalize(Vector3.flat(current_velocity))
		local current_rotation = first_person_extension:current_rotation()
		local dot = Vector3.dot(Quaternion.right(current_rotation), normalize)
		local dot_2 = Vector3.dot(Vector3.normalize(Vector3.flat(Quaternion.forward(current_rotation))), normalize)
		local var_2_14 = Vector3(dot, dot_2, 0)

		self.last_input_direction:store(var_2_14)
	end

	local get_move_animation, var_2_16 = CharacterStateHelper.get_move_animation(self.locomotion_extension, input_extension, status_extension, self.move_anim_3p)

	self.move_anim_3p = get_move_animation
	self.move_anim_1p = var_2_16

	CharacterStateHelper.play_animation_event(arg_2_1, get_move_animation)
	CharacterStateHelper.play_animation_event_first_person(first_person_extension, var_2_16)
	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, input_extension, inventory_extension, health_extension)

	self.walking = false
	self.is_bot = flag
end

PlayerCharacterStateWalking.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local first_person_extension = self.first_person_extension

	CharacterStateHelper.play_animation_event_first_person(first_person_extension, "idle")
end

PlayerCharacterStateWalking._handle_ladder_collision = function (self, arg_4_1, arg_4_2)
	-- function 4
	local unit = self.unit
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local locomotion_extension = self.locomotion_extension
	local is_colliding_with_gameplay_collision_box, var_4_5 = CharacterStateHelper.is_colliding_with_gameplay_collision_box(self.world, unit, "filter_ladder_collision")
	local looking_up = CharacterStateHelper.looking_up(first_person_extension, arg_4_2.ladder.looking_up_threshold)
	local recently_left_ladder = CharacterStateHelper.recently_left_ladder(status_extension, arg_4_1)

	if not is_colliding_with_gameplay_collision_box then
		local flag = false
		local local_rotation = Unit.local_rotation(var_4_5, 0)
		local forward = Quaternion.forward(local_rotation)
		local num = Unit.local_position(var_4_5, 0) - POSITION_LOOKUP[unit]
		local dot = Vector3.dot(forward, num)
		local flag_2 = false
		local flag_3 = false
		local forward_2 = Quaternion.forward(Unit.local_rotation(var_4_5, 0))
		local forward_3 = Quaternion.forward(first_person_extension:current_rotation())
		local flag_4 = Vector3.dot(forward_3, forward_2) < 0
		local dot_2 = Vector3.dot(locomotion_extension.velocity_current:unbox(), forward_2)
		local node = Unit.node(var_4_5, "c_platform")

		if POSITION_LOOKUP[unit].z > Vector3.z(Unit.world_position(var_4_5, node)) then
			local flag_5 = not looking_up

			if not (not flag_5 and not flag_4 and not (dot_2 < 0)) then
				flag_3 = dot > 0.5
				flag_2 = true
			elseif not (not flag_5 and not (dot > 0) or flag_4 or not (dot_2 > 0.5)) then
				flag_3 = dot > 0.25
				flag_2 = true
			end

			flag = true
		else
			local num_2 = 0.02

			flag_3 = not (dot < 0.7 + num_2) or dot > 0
			flag_2 = not looking_up and not not flag_4 or dot_2 > 0
		end

		if not flag_2 and recently_left_ladder or not flag_3 then
			self.temp_params.ladder_unit = var_4_5

			if not flag then
				return "enter_ladder_top"
			else
				return "climbing_ladder"
			end
		end
	end
end

PlayerCharacterStateWalking.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local world = self.world
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_5_1)
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local locomotion_extension = self.locomotion_extension
	local health_extension = self.health_extension
	local inventory_extension = self.inventory_extension
	local interactor_extension = self.interactor_extension
	local buff_extension = self.buff_extension
	local current_movement_speed_scale = self.current_movement_speed_scale
	local CharacterStateHelper = CharacterStateHelper

	if not locomotion_extension:is_on_ground() then
		ScriptUnit.extension(arg_5_1, "whereabouts_system"):set_is_onground()
	end

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if not (not CharacterStateHelper.is_ledge_hanging(world, arg_5_1, self.temp_params) and CharacterStateHelper.handle_bot_ledge_hanging_failsafe(arg_5_1, self.is_bot)) then
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if not CharacterStateHelper.is_overcharge_exploding(status_extension) then
		csm:change_state("overcharge_exploding")

		return
	end

	if not CharacterStateHelper.is_using_transport(status_extension) then
		csm:change_state("using_transport")

		return
	end

	if not CharacterStateHelper.is_pushed(status_extension) then
		status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = status_extension:hit_react_type() .. "_push"

		csm:change_state("stunned", pushed)

		return
	end

	if not CharacterStateHelper.is_charged(status_extension) then
		local charged = get_movement_settings_table.charged_settings.charged

		charged.hit_react_type = "charged"

		csm:change_state("charged", charged)

		return
	end

	if not CharacterStateHelper.is_block_broken(status_extension) then
		status_extension:set_block_broken(false)

		local parry_broken = get_movement_settings_table.stun_settings.parry_broken

		parry_broken.hit_react_type = "medium_push"

		csm:change_state("stunned", parry_broken)

		return
	end

	if not locomotion_extension:is_animation_driven() then
		return
	end

	if csm.state_next or not status_extension.do_leap then
		csm:change_state("leaping")

		return
	end

	CharacterStateHelper.update_dodge_lock(arg_5_1, input_extension, status_extension)

	local check_to_start_dodge, var_5_17 = CharacterStateHelper.check_to_start_dodge(arg_5_1, input_extension, status_extension, arg_5_5)

	if not check_to_start_dodge then
		local temp_params = self.temp_params

		temp_params.dodge_direction = var_5_17

		csm:change_state("dodging", temp_params)

		return
	end

	local is_device_active = Managers.input:is_device_active("gamepad")
	local is_crouching = status_extension:is_crouching()

	if (csm.state_next or input_extension:get("jump") or not input_extension:get("jump_only") or not is_crouching) and (CharacterStateHelper.can_uncrouch(arg_5_1) or not locomotion_extension:jump_allowed()) then
		local get_movement_input = CharacterStateHelper.get_movement_input(input_extension)

		if not is_crouching then
			CharacterStateHelper.uncrouch(arg_5_1, arg_5_5, first_person_extension, status_extension)
		end

		if not ((input_extension:get("jump") or not is_device_active or status_extension:can_override_dodge_with_jump(arg_5_5)) and (Vector3.y(get_movement_input) >= 0 or not (Vector3.length(get_movement_input) <= input_extension.minimum_dodge_input))) then
			if Vector3.y(CharacterStateHelper.get_movement_input(input_extension)) < 0 then
				self.temp_params.backward_jump = true
			else
				self.temp_params.backward_jump = false
			end

			csm:change_state("jumping", self.temp_params)
			first_person_extension:change_state("jumping")

			return
		end
	end

	local has_move_input = CharacterStateHelper.has_move_input(input_extension)

	if not (csm.state_next or has_move_input or current_movement_speed_scale ~= 0) then
		local temp_params_2 = self.temp_params

		csm:change_state("standing", temp_params_2)
		first_person_extension:change_state("standing")

		return
	end

	if not (csm.state_next or locomotion_extension:is_on_ground()) then
		csm:change_state("falling", self.temp_params)
		first_person_extension:change_state("falling")

		return
	end

	local _handle_ladder_collision = self:_handle_ladder_collision(arg_5_5, get_movement_settings_table)

	if csm.state_next or not _handle_ladder_collision then
		csm:change_state(_handle_ladder_collision, self.temp_params)

		return
	end

	local toggle_crouch = input_extension.toggle_crouch

	CharacterStateHelper.check_crouch(arg_5_1, input_extension, status_extension, toggle_crouch, first_person_extension, arg_5_5)

	local get_movement_input_2 = CharacterStateHelper.get_movement_input(input_extension)

	if not self.is_bot then
		local num = get_movement_settings_table.move_acceleration_up * arg_5_3
		local num_2 = get_movement_settings_table.move_acceleration_down * arg_5_3

		if not has_move_input then
			current_movement_speed_scale = math.min(1, current_movement_speed_scale + num)

			if not is_device_active then
				current_movement_speed_scale = Vector3.length(get_movement_input_2) * current_movement_speed_scale
			end
		else
			current_movement_speed_scale = math.max(0, current_movement_speed_scale - num_2)
		end
	else
		current_movement_speed_scale = not has_move_input and 1 and 0
	end

	local get = input_extension:get("walk")
	local is_crouching_2 = status_extension:is_crouching()

	if get ~= self.walking then
		status_extension:set_slowed(get)
	end

	local crouch_move_speed

	if not is_crouching_2 then
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

	local num_3 = crouch_move_speed * status_extension:current_move_speed_multiplier() * current_movement_speed_scale * get_movement_settings_table.player_speed_scale
	local has_buff_perk = buff_extension:has_buff_perk("intoxication_stagger")
	local has_buff_perk_2 = buff_extension:has_buff_perk("drunk_stagger")
	local has_buff_perk_3 = buff_extension:has_buff_perk("hungover_stagger")

	if has_buff_perk or has_buff_perk_2 or not has_buff_perk_3 then
		local abs = math.abs(status_extension:intoxication_level())
		local flag = not has_buff_perk and math.random() > 0.6 / abs
		local flag_2 = not has_buff_perk_2 and math.random() > 0.9 / abs
		local var_5_39 = has_buff_perk_3
		local flag_3 = flag or flag_2 or var_5_39

		if self._is_in_intoxication_stagger_cooldown or self._is_intoxication_stagger or not flag_3 then
			self._is_intoxication_stagger = true
			self._intoxication_stagger_start = arg_5_5
			self._intoxication_stagger_duration = math.random() * 1.5 + math.random() * 0.5
			self._intoxication_stagger_time = self._intoxication_stagger_start + self._intoxication_stagger_duration

			local current_velocity = locomotion_extension:current_velocity()
			local normalize = Vector3.normalize(current_velocity)
			local cross = Vector3.cross(normalize, Vector3.up())
			local num_4 = math.sin(arg_5_5 * (math.pi * 0.5)) * math.sign(math.random() * 2 - 1) * cross

			self._intoxication_stagger_dir = Vector3Box(num_4)
		end

		if not (not self._is_intoxication_stagger and not (arg_5_5 <= self._intoxication_stagger_time)) then
			local num_5 = self._intoxication_stagger_time - arg_5_5
			local num_6 = (self._intoxication_stagger_duration - num_5) / self._intoxication_stagger_duration

			get_movement_input_2 = get_movement_input_2 + Vector3.lerp(get_movement_input_2, self._intoxication_stagger_dir:unbox(), num_6)

			if num_6 < 0.5 then
				num_3 = math.lerp(num_3, num_3 * 0.75, math.sin(num_6 * 2 * math.pi * 0.5))
			else
				num_3 = math.lerp(num_3 * 0.75, num_3, math.sin(num_6 * 2 * math.pi * 0.5))
			end
		elseif not (not self._is_intoxication_stagger and not (arg_5_5 > self._intoxication_stagger_time)) then
			self._is_intoxication_stagger = nil
			self._is_in_intoxication_stagger_cooldown = true
			self._intoxication_stagger_cooldown_time = arg_5_5 + math.random() * (1 / math.abs(abs))
		end

		if not (not self._is_in_intoxication_stagger_cooldown and not (arg_5_5 > self._intoxication_stagger_cooldown_time)) then
			self._is_in_intoxication_stagger_cooldown = nil
			self._intoxication_stagger_cooldown_time = nil
		end
	end

	local normalize_2 = Vector3.normalize(get_movement_input_2)

	if Vector3.length_squared(get_movement_input_2) == 0 then
		normalize_2 = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize_2)
	end

	if not CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local interaction_action_names, var_5_49 = InteractionHelper.interaction_action_names(arg_5_1)

		interactor_extension:start_interaction(var_5_49)

		if not interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config = interactor_extension:interaction_config()
		local temp_params_3 = self.temp_params

		temp_params_3.swap_to_3p = interaction_config.swap_to_3p
		temp_params_3.show_weapons = interaction_config.show_weapons
		temp_params_3.activate_block = interaction_config.activate_block
		temp_params_3.allow_rotation_update = interaction_config.allow_rotation_update

		csm:change_state("interacting", temp_params_3)

		return
	end

	if not self.cosmetic_extension:get_queued_3p_emote() then
		local get_item_data_and_weapon_extensions, var_5_53, var_5_54 = CharacterStateHelper.get_item_data_and_weapon_extensions(self.inventory_extension)

		if not CharacterStateHelper.get_current_action_data(var_5_54, var_5_53) then
			csm:change_state("emote")

			return
		end
	end

	CharacterStateHelper.move_on_ground(first_person_extension, input_extension, locomotion_extension, normalize_2, num_3, arg_5_1)
	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_5_5, arg_5_1, input_extension, inventory_extension, health_extension)

	if not CharacterStateHelper.is_interacting(interactor_extension) then
		if not interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config_2 = interactor_extension:interaction_config()
		local temp_params_4 = self.temp_params

		temp_params_4.swap_to_3p = interaction_config_2.swap_to_3p
		temp_params_4.show_weapons = interaction_config_2.show_weapons
		temp_params_4.activate_block = interaction_config_2.activate_block
		temp_params_4.allow_rotation_update = interaction_config_2.allow_rotation_update

		csm:change_state("interacting", temp_params_4)

		return
	end

	local get_move_animation, var_5_58 = CharacterStateHelper.get_move_animation(locomotion_extension, input_extension, status_extension, self.move_anim_3p)

	if var_5_58 ~= self.move_anim_1p then
		CharacterStateHelper.play_animation_event_first_person(first_person_extension, var_5_58)

		self.move_anim_1p = var_5_58
	end

	if get_move_animation ~= self.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_5_1, get_move_animation)

		self.move_anim_3p = get_move_animation
	end

	self.current_movement_speed_scale = current_movement_speed_scale
	self.walking = get
end
