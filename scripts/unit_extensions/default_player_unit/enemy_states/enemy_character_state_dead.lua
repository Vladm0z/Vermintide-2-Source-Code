-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_dead.lua

EnemyCharacterStateDead = class(EnemyCharacterStateDead, EnemyCharacterState)

EnemyCharacterStateDead.init = function (self, character_state_init_context)
	-- function 1
	EnemyCharacterState.init(self, character_state_init_context, "dead")
end

EnemyCharacterStateDead.on_enter = function (self, unit, input, dt, context, t, previous_state, params)
	-- function 2
	self.despawn_time_start = t
	self.despawned = false
	self.switched_to_observer_camera = false

	local breed = Unit.get_data(unit, "breed")

	if breed then
		-- Nothing
	end

	::label_2_0::

	local name = breed.name

	if name then
		-- Nothing
	end

	if breed.name ~= "vs_gutter_runner" then
		name = false

		goto label_2_1
	end

	name = true

	local is_gutter_runner = name

	::label_2_1::

	if not is_gutter_runner and unit then
		local animation_2

		if params then
			animation_2 = params.animation

			if not animation_2 then
				-- Nothing
			end
		end

		animation_2 = "death"

		local animation = animation_2

		::label_2_2::

		CharacterStateHelper.play_animation_event(unit, animation)
	end

	self._locomotion_extension:set_wanted_velocity(Vector3.zero())

	local first_person_extension = self._first_person_extension

	first_person_extension:set_wanted_player_height("knocked_down", t)
	first_person_extension:set_first_person_mode(false)

	local death_sound_event = breed.death_sound_event

	if death_sound_event then
		first_person_extension:play_hud_sound_event(death_sound_event)
	end

	local include_local_player = true
	local fast_respawns = Development.parameter("fast_respawns")
	local profile_id = self._player:profile_index()
	local profile = SPProfiles[profile_id]
	local affiliation = profile.affiliation
	local health_extension = ScriptUnit.extension(unit, "health_system")
	local last_damage = health_extension.last_damage_data
	local last_attacker = Managers.state.network.unit_storage:unit(last_damage.attacker_unit_id)

	if last_attacker and DamageUtils.is_player_unit(last_attacker) then
		self._override_follow_unit = last_attacker
		self._override_node_name = "camera_attach"
	else
		self._override_follow_unit = self._player.player_unit
		self._override_node_name = "j_hips"
	end

	local spawn_times = GameModeSettings.versus.side_settings.dark_pact.spawn_times

	self._linger_time = spawn_times.delayed_death_time

	local flag

	flag = (not fast_respawns or not 1) and not not self._linger_time
	self.dead_player_destroy_time = flag

	local drop_items_delay_2

	if not fast_respawns and params then
		drop_items_delay_2 = params.drop_items_delay

		if not drop_items_delay_2 then
			-- Nothing
		end
	end

	drop_items_delay_2 = 0

	local drop_items_delay = drop_items_delay_2

	::label_2_3::

	if profile.dead_player_destroy_time then
		self.dead_player_destroy_time = profile.dead_player_destroy_time
		drop_items_delay = self.dead_player_destroy_time - 0.001
	end

	local camera_params = {
		override_node_name = "j_hips",
		allow_camera_movement = true,
		follow_unit_rotation = false,
		override_follow_unit = self._player.player_unit,
		camera_offset = Vector3.up(),
		min_leave_t = math.huge
	}

	CharacterStateHelper.change_camera_state(self._player, "follow_third_person", camera_params)
	fassert(drop_items_delay < self.dead_player_destroy_time, "Drop items delay too large - this will cause a drop attempt when the player is already despawned!")

	self.drop_items_time = t + drop_items_delay

	local override_item_drop_position_2

	if params then
		override_item_drop_position_2 = params.override_item_drop_position

		if not override_item_drop_position_2 then
			-- Nothing
		end
	end

	override_item_drop_position_2 = nil

	local override_item_drop_position = override_item_drop_position_2

	do
		local override_item_drop_direction_2
	end

	::label_2_4::

	if params then
		override_item_drop_direction_2 = params.override_item_drop_direction

		if not override_item_drop_direction_2 then
			-- Nothing
		end
	end

	override_item_drop_direction_2 = nil

	local override_item_drop_direction = override_item_drop_direction_2

	do
		local var_2_6
	end

	::label_2_5::

	if override_item_drop_position then
		var_2_6 = Vector3Box(override_item_drop_position)

		if not var_2_6 then
			-- Nothing
		end
	end

	var_2_6 = nil

	::label_2_6::

	self.override_item_drop_position = var_2_6

	local var_2_7

	if override_item_drop_direction then
		var_2_7 = Vector3Box(override_item_drop_direction)

		if not var_2_7 then
			-- Nothing
		end
	end

	var_2_7 = nil

	::label_2_7::

	self.override_item_drop_direction = var_2_7

	if breed.name == "vs_packmaster" then
		local status_extension = ScriptUnit.extension(unit, "status_system")
		local packmaster_dragging = status_extension:get_is_packmaster_dragging()

		if packmaster_dragging then
			local dragged_unit = status_extension:get_packmaster_dragged_unit()

			StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", dragged_unit, false, unit)
			status_extension:set_packmaster_released()
		end
	end
end

EnemyCharacterStateDead.on_exit = function (self, unit, input, dt, context, t, next_state)
	-- function 3
	self.override_item_drop_position = nil
	self.override_item_drop_direction = nil

	local game_mode = Managers.state.game_mode:game_mode()

	if game_mode then
		local about_to_end_game_early = game_mode:is_about_to_end_game_early()

		if not about_to_end_game_early then
			local camera_params = {
				input_service_name = "dark_pact_selection",
				allow_camera_movement = true,
				follow_unit_rotation = false,
				override_follow_unit = self._override_follow_unit,
				override_node_name = self._override_node_name
			}
			local time_since_death = t - self.despawn_time_start

			if time_since_death < self._linger_time then
				local move_to_follow_t = t + (self._linger_time - time_since_death)

				CharacterStateHelper.change_camera_state_delayed(self._player, "observer", camera_params, move_to_follow_t)
			else
				CharacterStateHelper.change_camera_state(self._player, "observer", camera_params)
			end
		end
	end
end

EnemyCharacterStateDead.update = function (self, unit, input, dt, context, t)
	-- function 4
	local time_since_death = t - self.despawn_time_start

	if not self.despawned and time_since_death > self.dead_player_destroy_time then
		local player = Managers.player:unit_owner(unit)

		Managers.state.spawn:delayed_despawn(player)

		self.despawned = true

		if player.local_player then
			Managers.state.camera:clear_mood("knocked_down")
			Managers.state.camera:clear_mood("wounded")
			Managers.state.camera:clear_mood("bleeding_out")
		end
	end
end
