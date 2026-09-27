-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_dead.lua

PlayerCharacterStateDead = class(PlayerCharacterStateDead, PlayerCharacterState)

PlayerCharacterStateDead.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "dead")
end

PlayerCharacterStateDead.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self.despawn_time_start = arg_2_5
	self.despawned = false
	self.switched_to_observer_camera = false

	local animation

	if not arg_2_7 then
		animation = arg_2_7.animation

		if not animation then
			-- Nothing
		end
	end

	animation = "death"

	::label_2_0::

	CharacterStateHelper.play_animation_event(self.unit, animation)
	self.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local first_person_extension = self.first_person_extension

	first_person_extension:set_wanted_player_height("knocked_down", arg_2_5)
	first_person_extension:set_first_person_mode(false)

	local flag = true

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self.is_server, self.inventory_extension)
	CharacterStateHelper.change_camera_state(self.player, "follow_third_person")

	local parameter = Development.parameter("fast_respawns")
	local flag_2

	flag_2 = not parameter and 1 and PlayerUnitDamageSettings.dead_player_destroy_time
	self.dead_player_destroy_time = flag_2

	local drop_items_delay

	if parameter or not arg_2_7 then
		drop_items_delay = arg_2_7.drop_items_delay

		if not drop_items_delay then
			-- Nothing
		end
	end

	drop_items_delay = 0

	::label_2_1::

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

	::label_2_2::

	if not arg_2_7 then
		override_item_drop_direction = arg_2_7.override_item_drop_direction

		if not override_item_drop_direction then
			-- Nothing
		end
	end

	override_item_drop_direction = nil

	do
		local var_2_8
	end

	::label_2_3::

	if not override_item_drop_position then
		var_2_8 = Vector3Box(override_item_drop_position)

		if not var_2_8 then
			-- Nothing
		end
	end

	var_2_8 = nil

	::label_2_4::

	self.override_item_drop_position = var_2_8

	local var_2_9

	if not override_item_drop_direction then
		var_2_9 = Vector3Box(override_item_drop_direction)

		if not var_2_9 then
			-- Nothing
		end
	end

	var_2_9 = nil

	::label_2_5::

	self.override_item_drop_direction = var_2_9
end

PlayerCharacterStateDead.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self.override_item_drop_position = nil
	self.override_item_drop_direction = nil
end

PlayerCharacterStateDead.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local num = arg_4_5 - self.despawn_time_start
	local unit_owner = Managers.player:unit_owner(arg_4_1)
	local flag = not unit_owner and not unit_owner:needs_despawn()
	local is_about_to_end_game_early = Managers.state.game_mode:game_mode():is_about_to_end_game_early()

	if not (not (not not self.switched_to_observer_camera or flag or num + 1 > self.dead_player_destroy_time) and is_about_to_end_game_early) then
		self.switched_to_observer_camera = true

		CharacterStateHelper.change_camera_state(self.player, "observer")
	end

	if not (self.items_dropped or flag or not (arg_4_5 > self.drop_items_time)) then
		local override_item_drop_position = self.override_item_drop_position

		override_item_drop_position = not override_item_drop_position and self.override_item_drop_position:unbox()

		local override_item_drop_direction = self.override_item_drop_direction

		override_item_drop_direction = not override_item_drop_direction and self.override_item_drop_direction:unbox()

		ScriptUnit.extension(arg_4_1, "inventory_system"):check_and_drop_pickups("death", override_item_drop_position, override_item_drop_direction)

		self.items_dropped = true
	end

	if not (self.despawned or flag or not (num > self.dead_player_destroy_time)) then
		print("state dead despawn")

		if not flag then
			Managers.state.spawn:delayed_despawn(unit_owner)
		end

		self.despawned = true

		if not unit_owner.local_player then
			Managers.state.camera:clear_mood("knocked_down")
			Managers.state.camera:clear_mood("wounded")
			Managers.state.camera:clear_mood("bleeding_out")
		end
	end
end
