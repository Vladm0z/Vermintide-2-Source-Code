-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_falling.lua

local tbl = {
	"Double",
	"Triple",
	"Quad",
	"Penta",
	"Hexa",
	"Hepta",
	"Octa",
	"Nona",
	"Deca",
	"Hendeca",
	"Dodeca",
	"Trideca",
	"Tetradeca",
	"Pentadeca",
	"Hexadeca",
	"Heptadeca",
	"Octadeca",
	"Enneadeca",
	"Icosa"
}
local script_data = script_data
local ledge_hanging_turned_off = script_data.ledge_hanging_turned_off

ledge_hanging_turned_off = ledge_hanging_turned_off or Development.parameter("ledge_hanging_turned_off")
script_data.ledge_hanging_turned_off = ledge_hanging_turned_off
TimesJumpedInAir = 0
EnemyCharacterStateFalling = class(EnemyCharacterStateFalling, EnemyCharacterState)

local POSITION_LOOKUP = POSITION_LOOKUP

EnemyCharacterStateFalling.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "falling")

	self.last_valid_nav_position = Vector3Box()
	self.shaking_ladder_unit = false
end

EnemyCharacterStateFalling.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self.falling_reason = arg_2_6

	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local _first_person_extension = self._first_person_extension

	self._breed = Unit.get_data(arg_2_1, "breed")

	_status_extension:set_falling_height()
	_locomotion_extension:set_maximum_upwards_velocity(math.huge)
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "idle")

	if arg_2_6 ~= "jumping" then
		local var_2_4
		local var_2_5
		local flag

		flag = not CharacterStateHelper.is_moving(_locomotion_extension) and "jump_idle" and "jump_idle"

		local flag_2

		flag_2 = not self._play_fp_anim and "to_falling" and "idle"

		CharacterStateHelper.play_animation_event(arg_2_1, flag)
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, flag_2)
	end

	self.jumped = arg_2_7.jumped

	local _inventory_extension = self._inventory_extension

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, self._inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, _input_extension, _inventory_extension, self._health_extension)

	self.is_active = true
	self.times_jumped_in_air = 0

	local shaking_ladder_unit = arg_2_7.shaking_ladder_unit

	shaking_ladder_unit = shaking_ladder_unit or false
	self.shaking_ladder_unit = shaking_ladder_unit

	if not (arg_2_6 == "jumping" or arg_2_6 == "leaping" or arg_2_6 == "lunging" or arg_2_6 == "pouncing") then
		ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_fell()
	end
end

local num = 7
local num_2 = 1

EnemyCharacterStateFalling.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	if not (not Managers.state.network:game() and arg_3_6) then
		return
	end

	self._locomotion_extension:reset_maximum_upwards_velocity()

	local fall_distance = self._status_extension:fall_distance()

	if fall_distance > num then
		local str = "Play_versus_pactsworn_jump_land"

		self._first_person_extension:play_unit_sound_event(str, arg_3_1, 0)
	elseif fall_distance > num_2 then
		Unit.flow_event(arg_3_1, "pactsworn_land_after_jump")
	elseif self.falling_reason == "tunneling" then
		Unit.flow_event(arg_3_1, "pactsworn_land_after_jump")
	elseif self.falling_reason == "jumping" then
		Unit.flow_event(arg_3_1, "pactsworn_land_after_jump")
	end

	self.is_active = false
	self.jumped = nil

	local str_2 = "idle"

	if not (arg_3_6 == "walking" or arg_3_6 ~= "standing") then
		if self.falling_reason == "tunneling" then
			local str_3 = "jump_down_land"
		end

		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	else
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end

	if not arg_3_6 and arg_3_6 == "falling" or not Managers.state.network:game() then
		if arg_3_6 == "dead" then
			CharacterStateHelper.play_animation_event(arg_3_1, "ragdoll")
		else
			CharacterStateHelper.play_animation_event(arg_3_1, "land_still")
			CharacterStateHelper.play_animation_event(arg_3_1, "to_onground")

			if not self._play_fp_anim then
				CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, "to_onground")
			end
		end
	end
end

EnemyCharacterStateFalling.common_movement = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local _locomotion_extension = self._locomotion_extension
	local _first_person_extension = self._first_person_extension
	local _breed = self._breed

	if _locomotion_extension:current_velocity().z > 0 then
		self.start_fall_height = POSITION_LOOKUP[arg_4_3].z
	end

	CharacterStateHelper.update_dodge_lock(arg_4_3, self._input_extension, self._status_extension)

	if POSITION_LOOKUP[arg_4_3].z < -240 then
		local go_id = self._unit_storage:go_id(arg_4_3)

		self._network_transmit:send_rpc_server("rpc_suicide", go_id)
	end

	local _csm = self._csm
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_3)

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)

		return
	end

	if _csm.state_next or not _locomotion_extension:is_on_ground() then
		if not CharacterStateHelper.is_moving(_locomotion_extension) then
			_csm:change_state("walking")
			_first_person_extension:change_state("walking")
		else
			_csm:change_state("standing")
			_first_person_extension:change_state("standing")
		end

		return
	end

	if not script_data.use_super_jumps and _input_extension:get("jump") and not _input_extension:get("jump_only") then
		self.times_jumped_in_air = math.min(#tbl, self.times_jumped_in_air + 1)

		local format = string.format("%sjump!", tbl[self.times_jumped_in_air])

		Debug.sticky_text(format)

		local initial_vertical_speed = get_movement_settings_table.jump.initial_vertical_speed
		local current_velocity = self._locomotion_extension:current_velocity()
		local Vector3 = Vector3
		local x = current_velocity.x
		local y = current_velocity.y
		local num

		if current_velocity.z < -3 then
			num = initial_vertical_speed * 0.5

			if not num then
				-- Nothing
			end
		end

		num = initial_vertical_speed * 1.5

		::label_4_0::

		local var_4_16 = Vector3(x, y, num)

		self._locomotion_extension:set_forced_velocity(var_4_16)
		self._locomotion_extension:set_wanted_velocity(var_4_16)
	end

	local movement_speed_multiplier = _breed.movement_speed_multiplier
	local move_speed = get_movement_settings_table.move_speed

	if not arg_4_1 then
		move_speed = get_movement_settings_table.ghost_move_speed
	end

	local num_2 = move_speed * movement_speed_multiplier
	local num_3 = self._buff_extension:apply_buffs_to_value(num_2, "movement_speed") * get_movement_settings_table.player_speed_scale

	CharacterStateHelper.move_in_air_pactsworn(self._first_person_extension, _input_extension, self._locomotion_extension, num_3, arg_4_3)
	CharacterStateHelper.ghost_mode(self._ghost_mode_extension, _input_extension)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, self._first_person_extension, _status_extension, self._inventory_extension)
end

EnemyCharacterStateFalling.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local common_movement = self:common_movement(is_in_ghost_mode, arg_5_3, arg_5_1)
end
