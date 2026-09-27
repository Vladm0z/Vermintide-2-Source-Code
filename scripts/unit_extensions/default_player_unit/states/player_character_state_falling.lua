-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_falling.lua

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
PlayerCharacterStateFalling = class(PlayerCharacterStateFalling, PlayerCharacterState)

local POSITION_LOOKUP = POSITION_LOOKUP

PlayerCharacterStateFalling.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "falling")

	self.last_valid_nav_position = Vector3Box()
	self.shaking_ladder_unit = false
end

PlayerCharacterStateFalling.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self.falling_reason = arg_2_6

	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local locomotion_extension = self.locomotion_extension
	local first_person_extension = self.first_person_extension
	local inventory_extension = self.inventory_extension

	status_extension:set_falling_height()
	locomotion_extension:set_maximum_upwards_velocity(math.huge)

	local get_wielded_slot_item_template = inventory_extension:get_wielded_slot_item_template()

	self._play_fp_anim = not get_wielded_slot_item_template and get_wielded_slot_item_template.jump_anim_enabled_1p

	if arg_2_6 ~= "jumping" then
		local var_2_6
		local var_2_7
		local flag

		flag = not CharacterStateHelper.is_moving(locomotion_extension) and "jump_fwd" and "jump_idle"

		local flag_2

		flag_2 = not self._play_fp_anim and "to_falling" and "idle"

		CharacterStateHelper.play_animation_event(arg_2_1, flag)
		CharacterStateHelper.play_animation_event_first_person(first_person_extension, flag_2)
	end

	self.jumped = arg_2_7.jumped

	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, self.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, input_extension, inventory_extension, self.health_extension)

	self.is_active = true
	self.times_jumped_in_air = 0

	local shaking_ladder_unit = arg_2_7.shaking_ladder_unit

	shaking_ladder_unit = shaking_ladder_unit or nil
	self.shaking_ladder_unit = shaking_ladder_unit

	if not (arg_2_6 == "jumping" or arg_2_6 == "leaping" or arg_2_6 == "overcharge_exploding" or arg_2_6 == "lunging") then
		ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_fell()
	end

	local owner = Managers.player:owner(arg_2_1)

	self.is_bot = not owner and owner.bot_player
end

PlayerCharacterStateFalling.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	if not (not Managers.state.network:game() and arg_3_6) then
		return
	end

	local status_extension = self.status_extension

	self.locomotion_extension:reset_maximum_upwards_velocity()
	CharacterStateHelper.play_animation_event(arg_3_1, "land_still")
	CharacterStateHelper.play_animation_event(arg_3_1, "to_onground")

	if not self._play_fp_anim then
		CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, "to_onground")
	end

	self.is_active = false
	self.jumped = nil

	if not (arg_3_6 == "walking" or arg_3_6 ~= "standing") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	else
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end
end

PlayerCharacterStateFalling.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local world = self.world
	local locomotion_extension = self.locomotion_extension
	local first_person_extension = self.first_person_extension
	local current_velocity = locomotion_extension:current_velocity()
	local var_4_4 = POSITION_LOOKUP[arg_4_1]

	if current_velocity.z > 0 then
		self.start_fall_height = POSITION_LOOKUP[arg_4_1].z
	end

	CharacterStateHelper.update_dodge_lock(arg_4_1, self.input_extension, self.status_extension)

	if POSITION_LOOKUP[arg_4_1].z < -240 then
		if not self.is_server then
			Managers.state.entity:system("health_system"):suicide(arg_4_1)
		else
			local go_id = self.unit_storage:go_id(arg_4_1)

			self.network_transmit:send_rpc_server("rpc_suicide", go_id)
		end
	end

	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if not CharacterStateHelper.is_overcharge_exploding(status_extension) then
		csm:change_state("overcharge_exploding")

		return
	end

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)

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

	if csm.state_next or not locomotion_extension:is_on_ground() then
		if not CharacterStateHelper.is_moving(locomotion_extension) then
			csm:change_state("walking")
			first_person_extension:change_state("walking")
		else
			csm:change_state("standing")
			first_person_extension:change_state("standing")
		end

		return
	end

	local is_colliding_with_gameplay_collision_box, var_4_15 = CharacterStateHelper.is_colliding_with_gameplay_collision_box(world, unit, "filter_ladder_collision")
	local recently_left_ladder = CharacterStateHelper.recently_left_ladder(status_extension, arg_4_5)
	local var_4_17
	local var_4_18
	local var_4_19

	if not (not is_colliding_with_gameplay_collision_box and recently_left_ladder or not self.shaking_ladder_unit or self.shaking_ladder_unit == var_4_15) then
		local node = Unit.node(var_4_15, "c_platform")
		local local_rotation = Unit.local_rotation(var_4_15, 0)
		local forward = Quaternion.forward(local_rotation)
		local num = Unit.local_position(var_4_15, 0) - var_4_4

		var_4_19 = Vector3.dot(forward, num)

		local num_2 = 0.1

		var_4_17 = var_4_4.z < Vector3.z(Unit.world_position(var_4_15, node))
		var_4_18 = not (var_4_19 > 0) or var_4_19 < 0.7 + num_2
		can_climb_ladder = not var_4_17 and var_4_18

		if not can_climb_ladder then
			local temp_params = self.temp_params

			temp_params.ladder_unit = var_4_15

			csm:change_state("climbing_ladder", temp_params)

			return
		end
	end

	if not script_data.debug_ladder_climbing then
		Debug.text("CAN CLIMB: %s", can_climb_ladder)

		if not can_climb_ladder then
			Debug.text("Can't climb because:")

			if not recently_left_ladder then
				Debug.text("\tRecently left ladder: %s", arg_4_5 - ScriptUnit.extension(unit, "status_system").left_ladder_timer)
			end

			if is_colliding_with_gameplay_collision_box == false then
				Debug.text("\tNot colliding with ladder")
			end

			if var_4_17 == false then
				Debug.text("\tAbove ladder")
			end

			if var_4_18 == false then
				Debug.text("\tToo far from ladder. Is %s, needs %s", var_4_19, 0.8)
			end

			if not (not self.shaking_ladder_unit and var_4_15 ~= self.shaking_ladder_unit) then
				Debug.text("\tAttempting to latch onto shaking ladder")
			end
		end
	end

	if not (not CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) and CharacterStateHelper.handle_bot_ledge_hanging_failsafe(unit, self.is_bot)) then
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if not script_data.use_super_jumps and input_extension:get("jump") and not input_extension:get("jump_only") then
		self.times_jumped_in_air = math.min(#tbl, self.times_jumped_in_air + 1)

		local format = string.format("%sjump!", tbl[self.times_jumped_in_air])

		Debug.sticky_text(format)

		local initial_vertical_speed = get_movement_settings_table.jump.initial_vertical_speed
		local current_velocity_2 = self.locomotion_extension:current_velocity()
		local Vector3 = Vector3
		local x = current_velocity_2.x
		local y = current_velocity_2.y
		local num_3

		if current_velocity_2.z < -3 then
			num_3 = initial_vertical_speed * 0.5

			if not num_3 then
				-- Nothing
			end
		end

		num_3 = initial_vertical_speed * 1.5

		::label_4_0::

		local var_4_33 = Vector3(x, y, num_3)

		self.locomotion_extension:set_forced_velocity(var_4_33)
		self.locomotion_extension:set_wanted_velocity(var_4_33)
	end

	local inventory_extension = self.inventory_extension
	local num_4 = get_movement_settings_table.move_speed * status_extension:current_move_speed_multiplier() * get_movement_settings_table.player_speed_scale * get_movement_settings_table.player_air_speed_scale

	CharacterStateHelper.move_in_air(self.first_person_extension, input_extension, self.locomotion_extension, num_4, unit)
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_4_5, unit, input_extension, inventory_extension, self.health_extension)

	local interactor_extension = self.interactor_extension

	if not CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local interaction_action_names, var_4_38 = InteractionHelper.interaction_action_names(unit)

		interactor_extension:start_interaction(var_4_38)

		if not interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config = interactor_extension:interaction_config()
		local temp_params_2 = self.temp_params

		temp_params_2.swap_to_3p = interaction_config.swap_to_3p
		temp_params_2.show_weapons = interaction_config.show_weapons
		temp_params_2.activate_block = interaction_config.activate_block
		temp_params_2.allow_rotation_update = interaction_config.allow_rotation_update

		csm:change_state("interacting", temp_params_2)

		return
	end

	if not CharacterStateHelper.is_interacting(interactor_extension) then
		if not interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config_2 = interactor_extension:interaction_config()
		local temp_params_3 = self.temp_params

		temp_params_3.swap_to_3p = interaction_config_2.swap_to_3p
		temp_params_3.show_weapons = interaction_config_2.show_weapons
		temp_params_3.activate_block = interaction_config_2.activate_block
		temp_params_3.allow_rotation_update = interaction_config_2.allow_rotation_update

		csm:change_state("interacting", temp_params_3)

		return
	end
end
