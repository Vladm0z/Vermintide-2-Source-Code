-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_dead.lua

EnemyCharacterStateDead = class(EnemyCharacterStateDead, EnemyCharacterState)

EnemyCharacterStateDead.init = function (arg_1_0, arg_1_1)
	-- function 1
	EnemyCharacterState.init(arg_1_0, arg_1_1, "dead")
end

EnemyCharacterStateDead.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self.despawn_time_start = arg_2_5
	self.despawned = false
	self.switched_to_observer_camera = false

	local get_data = Unit.get_data(arg_2_1, "breed")

	if not get_data then
		-- Nothing
	end

	::label_2_0::

	local name = get_data.name

	name = not name and get_data.name == "vs_gutter_runner"

	::label_2_1::

	if name or not arg_2_1 then
		local animation

		if not arg_2_7 then
			animation = arg_2_7.animation

			if not animation then
				-- Nothing
			end
		end

		animation = "death"

		::label_2_2::

		CharacterStateHelper.play_animation_event(arg_2_1, animation)
	end

	self._locomotion_extension:set_wanted_velocity(Vector3.zero())

	local _first_person_extension = self._first_person_extension

	_first_person_extension:set_wanted_player_height("knocked_down", arg_2_5)
	_first_person_extension:set_first_person_mode(false)

	local death_sound_event = get_data.death_sound_event

	if not death_sound_event then
		_first_person_extension:play_hud_sound_event(death_sound_event)
	end

	local flag = true
	local parameter = Development.parameter("fast_respawns")
	local profile_index = self._player:profile_index()
	local var_2_8 = SPProfiles[profile_index]
	local affiliation = var_2_8.affiliation
	local last_damage_data = ScriptUnit.extension(arg_2_1, "health_system").last_damage_data
	local unit = Managers.state.network.unit_storage:unit(last_damage_data.attacker_unit_id)

	if not unit and not DamageUtils.is_player_unit(unit) then
		self._override_follow_unit = unit
		self._override_node_name = "camera_attach"
	else
		self._override_follow_unit = self._player.player_unit
		self._override_node_name = "j_hips"
	end

	self._linger_time = GameModeSettings.versus.side_settings.dark_pact.spawn_times.delayed_death_time

	local flag_2

	flag_2 = not parameter and 1 and self._linger_time
	self.dead_player_destroy_time = flag_2

	local drop_items_delay

	if parameter or not arg_2_7 then
		drop_items_delay = arg_2_7.drop_items_delay

		if not drop_items_delay then
			-- Nothing
		end
	end

	drop_items_delay = 0

	::label_2_3::

	if not var_2_8.dead_player_destroy_time then
		self.dead_player_destroy_time = var_2_8.dead_player_destroy_time
		drop_items_delay = self.dead_player_destroy_time - 0.001
	end

	local tbl = {
		override_node_name = "j_hips",
		allow_camera_movement = true,
		follow_unit_rotation = false,
		override_follow_unit = self._player.player_unit,
		camera_offset = Vector3.up(),
		min_leave_t = math.huge
	}

	CharacterStateHelper.change_camera_state(self._player, "follow_third_person", tbl)
	fassert(drop_items_delay < self.dead_player_destroy_time, "Drop items delay too large - this will cause a drop attempt when the player is already despawned!")

	self.drop_items_time = arg_2_5 + drop_items_delay

	local override_item_drop_position

	if not arg_2_7 then
		override_item_drop_position = arg_2_7.override_item_drop_position

		if not override_item_drop_position then
			-- Nothing
		end
	end

	override_item_drop_position = nil

	do
		local override_item_drop_direction
	end

	::label_2_4::

	if not arg_2_7 then
		override_item_drop_direction = arg_2_7.override_item_drop_direction

		if not override_item_drop_direction then
			-- Nothing
		end
	end

	override_item_drop_direction = nil

	do
		local var_2_17
	end

	::label_2_5::

	if not override_item_drop_position then
		var_2_17 = Vector3Box(override_item_drop_position)

		if not var_2_17 then
			-- Nothing
		end
	end

	var_2_17 = nil

	::label_2_6::

	self.override_item_drop_position = var_2_17

	local var_2_18

	if not override_item_drop_direction then
		var_2_18 = Vector3Box(override_item_drop_direction)

		if not var_2_18 then
			-- Nothing
		end
	end

	var_2_18 = nil

	::label_2_7::

	self.override_item_drop_direction = var_2_18

	if get_data.name == "vs_packmaster" then
		local extension = ScriptUnit.extension(arg_2_1, "status_system")

		if not extension:get_is_packmaster_dragging() then
			local get_packmaster_dragged_unit = extension:get_packmaster_dragged_unit()

			StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", get_packmaster_dragged_unit, false, arg_2_1)
			extension:set_packmaster_released()
		end
	end
end

EnemyCharacterStateDead.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self.override_item_drop_position = nil
	self.override_item_drop_direction = nil

	local game_mode = Managers.state.game_mode:game_mode()

	if not (not game_mode and game_mode:is_about_to_end_game_early()) then
		local tbl = {
			input_service_name = "dark_pact_selection",
			allow_camera_movement = true,
			follow_unit_rotation = false,
			override_follow_unit = self._override_follow_unit,
			override_node_name = self._override_node_name
		}
		local num = arg_3_5 - self.despawn_time_start

		if num < self._linger_time then
			local num_2 = arg_3_5 + (self._linger_time - num)

			CharacterStateHelper.change_camera_state_delayed(self._player, "observer", tbl, num_2)
		else
			CharacterStateHelper.change_camera_state(self._player, "observer", tbl)
		end
	end
end

EnemyCharacterStateDead.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local num = arg_4_5 - self.despawn_time_start

	if not (self.despawned or not (num > self.dead_player_destroy_time)) then
		local unit_owner = Managers.player:unit_owner(arg_4_1)

		Managers.state.spawn:delayed_despawn(unit_owner)

		self.despawned = true

		if not unit_owner.local_player then
			Managers.state.camera:clear_mood("knocked_down")
			Managers.state.camera:clear_mood("wounded")
			Managers.state.camera:clear_mood("bleeding_out")
		end
	end
end
