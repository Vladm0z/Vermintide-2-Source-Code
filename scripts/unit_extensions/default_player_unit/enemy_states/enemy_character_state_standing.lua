-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_standing.lua

EnemyCharacterStateStanding = class(EnemyCharacterStateStanding, EnemyCharacterState)

EnemyCharacterStateStanding.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "standing")

	self.wherabouts_extension = ScriptUnit.extension(self._unit, "whereabouts_system")
end

EnemyCharacterStateStanding.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local _unit = self._unit
	local _input_extension = self._input_extension

	self._locomotion_extension:set_wanted_velocity(Vector3.zero())

	local _inventory_extension = self._inventory_extension
	local _first_person_extension = self._first_person_extension
	local _status_extension = self._status_extension
	local toggle_crouch = _input_extension.toggle_crouch

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, self._inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, _unit, _input_extension, _inventory_extension, self._health_extension)

	self.time_when_can_be_pushed = arg_2_5 + PlayerUnitMovementSettings.get_movement_settings_table(_unit).soft_collision.grace_time_pushed_entering_standing

	if arg_2_6 == "dummy" then
		_first_person_extension:set_first_person_mode(false)
		_first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	end

	local owner = Managers.player:owner(_unit)

	CharacterStateHelper.change_camera_state(owner, "follow")

	self.side = Managers.state.side.side_by_unit[_unit]
	self.current_animation = "idle"

	if not _status_extension:get_unarmed() then
		CharacterStateHelper.play_animation_event(_unit, "to_combat")
	end

	CharacterStateHelper.play_animation_event(_unit, "idle")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "idle")
end

local tbl = {}
local tbl_2 = {}
local tbl_3 = {}

EnemyCharacterStateStanding.teleport = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local viewport_name = self._player.viewport_name
	local viewport = ScriptWorld.viewport(self._world, viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local position = ScriptCamera.position(camera)
	local rotation = ScriptCamera.rotation(camera)
	local forward = Quaternion.forward(rotation)
	local num = 30
	local immediate_raycast, var_3_8, var_3_9, var_3_10, var_3_11 = PhysicsWorld.immediate_raycast(self._physics_world, position, forward, num, "closest", "collision_filter", "filter_enemy_ray_projectile")

	if not immediate_raycast then
		if not World.umbra_available(self._world) then
			local num_2 = position + forward * num

			tbl[1] = position
			tbl_2[1] = num_2
			tbl[2] = position
			tbl_2[2] = num_2 + Vector3(0, 0, 0.1)
			tbl[3] = position
			tbl_2[3] = num_2 - Vector3(0, 0, 0.1)

			if World.umbra_has_line_of_sight_many(self._world, tbl, tbl_2, tbl_3) > 0 then
				Debug.string("UMBRA HIT")
			end
		end

		if Vector3.dot(var_3_10, Vector3.up()) > 0.8 then
			QuickDrawer:sphere(var_3_8, 0.25, Color(255, 100, 0))
		else
			QuickDrawer:sphere(var_3_8, 0.25, Color(255, 255, 0))

			local num_3 = var_3_8 - forward * 0.6
			local immediate_raycast_2, var_3_15, var_3_16, var_3_17, var_3_18 = PhysicsWorld.immediate_raycast(self._physics_world, num_3, -Vector3.up(), 6, "closest", "collision_filter", "filter_enemy_ray_projectile")
			local num_4 = 0.4

			for i = 1, 10 do
				local num_5 = var_3_8 + i * Vector3(0, 0, 0.2)
				local immediate_raycast_3, var_3_22, var_3_23, var_3_24, var_3_25 = PhysicsWorld.immediate_raycast(self._physics_world, num_5, forward, num_4, "closest", "collision_filter", "filter_enemy_ray_projectile")

				if not immediate_raycast_3 then
					QuickDrawer:line(num_5, num_5 + forward * num_4)

					local num_6 = 0.3

					for j = 1, 4 do
						local num_7 = num_5 + j * forward * 0.1
						local immediate_raycast_4, var_3_29, var_3_30, var_3_31, var_3_32 = PhysicsWorld.immediate_raycast(self._physics_world, num_5, -Vector3.up(), num_6, "closest", "collision_filter", "filter_enemy_ray_projectile")

						if not immediate_raycast_4 then
							QuickDrawer:sphere(var_3_29, 0.75, Color(255, 255, 0))

							break
						end
					end

					break
				end
			end

			local num_8 = 0.2
			local num_9 = 3
			local num_10 = var_3_8 + forward * num_8 + Vector3.up() * num_9
			local immediate_raycast_5, var_3_37, var_3_38, var_3_39, var_3_40 = PhysicsWorld.immediate_raycast(self._physics_world, num_10, -Vector3.up(), num_9, "closest", "collision_filter", "filter_enemy_ray_projectile")

			if not immediate_raycast_5 then
				local num_11 = var_3_37 - forward * num_8
				local immediate_raycast_6, var_3_43, var_3_44, var_3_45, var_3_46 = PhysicsWorld.immediate_raycast(self._physics_world, num_11, forward, num_8, "closest", "collision_filter", "filter_enemy_ray_projectile")

				immediate_raycast_5 = not immediate_raycast_6
			end

			if not immediate_raycast_2 and not immediate_raycast_5 then
				if var_3_16 < var_3_38 then
					QuickDrawer:line(num_3, var_3_15)
					QuickDrawer:sphere(var_3_15, 0.25, Color(0, 125, 0))
				else
					QuickDrawer:line(num_3, var_3_37)
					QuickDrawer:sphere(var_3_37, 0.25, Color(0, 0, 125))
				end
			elseif not immediate_raycast_2 then
				QuickDrawer:sphere(var_3_15, 0.25, Color(0, 125, 0))
				QuickDrawer:line(var_3_15, num_3, Color(0, 125, 0))
			elseif not immediate_raycast_5 then
				QuickDrawer:sphere(var_3_37, 0.25, Color(0, 0, 125))
				QuickDrawer:line(var_3_37, num_10, Color(0, 0, 125))
			end
		end
	else
		local num_12 = position + forward * num
		local immediate_raycast_7, var_3_49, var_3_50, var_3_51, var_3_52 = PhysicsWorld.immediate_raycast(self._physics_world, num_12, -Vector3.up(), 6, "closest", "collision_filter", "filter_enemy_ray_projectile")

		if not immediate_raycast_7 then
			QuickDrawer:sphere(var_3_49, 0.25, Color(155, 225, 100))
		end
	end
end

EnemyCharacterStateStanding.common_state_changes = function (self)
	-- function 4
	self:handle_disabled_ghost_mode()

	local _csm = self._csm
	local _unit = self._unit
	local _locomotion_extension = self._locomotion_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local CharacterStateHelper = CharacterStateHelper
	local career_settings = self._career_extension:career_settings()
	local _inventory_extension = self._inventory_extension

	if not _locomotion_extension:is_on_ground() then
		self.wherabouts_extension:set_is_onground()
	end

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return true
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return true
	end

	if _csm.state_next or not _status_extension.do_leap then
		_csm:change_state("leaping")

		return true
	end

	if not self._input_extension:get("character_inspecting") then
		local get_item_data_and_weapon_extensions, var_4_9, var_4_10 = CharacterStateHelper.get_item_data_and_weapon_extensions(self._inventory_extension)

		if not CharacterStateHelper.get_current_action_data(var_4_10, var_4_9) then
			_csm:change_state("inspecting")

			return true
		end
	end

	return false
end

EnemyCharacterStateStanding.common_movement = function (self, arg_5_1)
	-- function 5
	local _csm = self._csm
	local _unit = self._unit
	local _first_person_extension = self._first_person_extension
	local _ghost_mode_extension = self._ghost_mode_extension
	local _input_extension = self._input_extension
	local _locomotion_extension = self._locomotion_extension
	local _status_extension = self._status_extension
	local CharacterStateHelper = CharacterStateHelper
	local is_device_active = Managers.input:is_device_active("gamepad")
	local is_crouching = _status_extension:is_crouching()

	if (_input_extension:get("jump") or not _input_extension:get("jump_only") or _status_extension:is_crouching()) and (not is_crouching or CharacterStateHelper.can_uncrouch(_unit) or not _locomotion_extension:jump_allowed()) then
		if not is_crouching then
			CharacterStateHelper.uncrouch(_unit, arg_5_1, _first_person_extension, _status_extension)
		end

		_csm:change_state("jumping")
		_first_person_extension:change_state("jumping")

		return
	end

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)

		return true
	end

	if not _locomotion_extension:is_animation_driven() then
		_csm:change_state("walking")

		return true
	end

	local _interactor_extension = self._interactor_extension

	if not CharacterStateHelper.is_starting_interaction(_input_extension, _interactor_extension) then
		local interaction_action_names, var_5_14 = InteractionHelper.interaction_action_names(_unit)

		_interactor_extension:start_interaction(var_5_14)

		if not _interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config = _interactor_extension:interaction_config()
		local _temp_params = self._temp_params

		_temp_params.swap_to_3p = interaction_config.swap_to_3p
		_temp_params.show_weapons = interaction_config.show_weapons
		_temp_params.activate_block = interaction_config.activate_block
		_temp_params.allow_rotation_update = interaction_config.allow_rotation_update

		_csm:change_state("interacting", _temp_params)

		return true
	end

	if not CharacterStateHelper.has_move_input(_input_extension) then
		local _temp_params_2 = self._temp_params

		_csm:change_state("walking", _temp_params_2)
		_first_person_extension:change_state("walking")

		return true
	end

	if not _locomotion_extension:is_on_ground() then
		_csm:change_state("falling")
		_first_person_extension:change_state("falling")

		return true
	end

	if not _input_extension:get("character_inspecting") then
		local get_item_data_and_weapon_extensions, var_5_19, var_5_20 = CharacterStateHelper.get_item_data_and_weapon_extensions(self._inventory_extension)

		if not CharacterStateHelper.get_current_action_data(var_5_20, var_5_19) then
			_csm:change_state("inspecting")

			return true
		end
	end

	local _inventory_extension = self._inventory_extension
	local _first_person_extension_2 = self._first_person_extension
	local toggle_crouch = _input_extension.toggle_crouch

	if not (arg_5_1 > self.time_when_can_be_pushed) or not self._player:is_player_controlled() then
		self.current_animation = CharacterStateHelper.update_soft_collision_movement(_first_person_extension_2, _status_extension, _locomotion_extension, _unit, self._world, self.current_animation, self.side)
	end

	CharacterStateHelper.ghost_mode(self._ghost_mode_extension, _input_extension)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, self._first_person_extension, _status_extension, self._inventory_extension)

	return false
end

EnemyCharacterStateStanding.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	if not self:common_state_changes() then
		return
	end

	self:_update_taunt_dialogue(arg_6_5)

	local common_movement = self:common_movement(arg_6_5)
end
