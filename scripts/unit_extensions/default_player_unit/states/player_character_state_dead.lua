-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_dead.lua

PlayerCharacterStateDead = class(PlayerCharacterStateDead, PlayerCharacterState)

PlayerCharacterStateDead.init = function (self, character_state_init_context)
	-- function 1
	PlayerCharacterState.init(self, character_state_init_context, "dead")
end

PlayerCharacterStateDead.on_enter = function (self, unit, input, dt, context, t, previous_state, params)
	-- function 2
	self.despawn_time_start = t
	self.despawned = false
	self.switched_to_observer_camera = false

	local animation_2

	if params then
		animation_2 = params.animation

		if not animation_2 then
			-- Nothing
		end
	end

	animation_2 = "death"

	local animation = animation_2

	::label_2_0::

	CharacterStateHelper.play_animation_event(self.unit, animation)
	self.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local first_person_extension = self.first_person_extension

	first_person_extension:set_wanted_player_height("knocked_down", t)
	first_person_extension:set_first_person_mode(false)

	local include_local_player = true

	CharacterStateHelper.show_inventory_3p(unit, false, include_local_player, self.is_server, self.inventory_extension)
	CharacterStateHelper.change_camera_state(self.player, "follow_third_person")

	local fast_respawns = Development.parameter("fast_respawns")
	local flag

	flag = (not fast_respawns or not 1) and not not PlayerUnitDamageSettings.dead_player_destroy_time
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

	::label_2_1::

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

	::label_2_2::

	if params then
		override_item_drop_direction_2 = params.override_item_drop_direction

		if not override_item_drop_direction_2 then
			-- Nothing
		end
	end

	override_item_drop_direction_2 = nil

	local override_item_drop_direction = override_item_drop_direction_2

	do
		local var_2_5
	end

	::label_2_3::

	if override_item_drop_position then
		var_2_5 = Vector3Box(override_item_drop_position)

		if not var_2_5 then
			-- Nothing
		end
	end

	var_2_5 = nil

	::label_2_4::

	self.override_item_drop_position = var_2_5

	local var_2_6

	if override_item_drop_direction then
		var_2_6 = Vector3Box(override_item_drop_direction)

		if not var_2_6 then
			-- Nothing
		end
	end

	var_2_6 = nil

	::label_2_5::

	self.override_item_drop_direction = var_2_6
end

PlayerCharacterStateDead.on_exit = function (self, unit, input, dt, context, t, next_state)
	-- function 3
	self.override_item_drop_position = nil
	self.override_item_drop_direction = nil
end

PlayerCharacterStateDead.update = function (self, unit, input, dt, context, t)
	-- function 4
	local time_since_death = t - self.despawn_time_start
	local player = Managers.player:unit_owner(unit)
	local marked_for_despawn = not not player and not not not player:needs_despawn()
	local game_mode = Managers.state.game_mode:game_mode()
	local about_to_end_game_early = game_mode:is_about_to_end_game_early()
	local should_go_to_observer = not self.switched_to_observer_camera and not not marked_for_despawn or time_since_death + 1 > self.dead_player_destroy_time

	if should_go_to_observer and not about_to_end_game_early then
		self.switched_to_observer_camera = true

		CharacterStateHelper.change_camera_state(self.player, "observer")
	end

	if not self.items_dropped and (marked_for_despawn or t > self.drop_items_time) then
		local override_item_drop_position_2 = self.override_item_drop_position

		if override_item_drop_position_2 then
			-- Nothing
		end

		override_item_drop_position_2 = self.override_item_drop_position:unbox()

		local override_item_drop_position = override_item_drop_position_2

		::label_4_0::

		local override_item_drop_direction_2 = self.override_item_drop_direction

		if override_item_drop_direction_2 then
			-- Nothing
		end

		override_item_drop_direction_2 = self.override_item_drop_direction:unbox()

		local override_item_drop_direction = override_item_drop_direction_2

		::label_4_1::

		local inventory_extension = ScriptUnit.extension(unit, "inventory_system")

		inventory_extension:check_and_drop_pickups("death", override_item_drop_position, override_item_drop_direction)

		self.items_dropped = true
	end

	if not self.despawned and (marked_for_despawn or time_since_death > self.dead_player_destroy_time) then
		print("state dead despawn")

		if not marked_for_despawn then
			Managers.state.spawn:delayed_despawn(player)
		end

		self.despawned = true

		if player.local_player then
			Managers.state.camera:clear_mood("knocked_down")
			Managers.state.camera:clear_mood("wounded")
			Managers.state.camera:clear_mood("bleeding_out")
		end
	end
end
