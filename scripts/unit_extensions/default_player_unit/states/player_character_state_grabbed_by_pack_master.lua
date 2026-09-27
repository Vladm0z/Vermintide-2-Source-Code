-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_pack_master.lua

PlayerCharacterStateGrabbedByPackMaster = class(PlayerCharacterStateGrabbedByPackMaster, PlayerCharacterState)

local POSITION_LOOKUP = POSITION_LOOKUP

PlayerCharacterStateGrabbedByPackMaster.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "grabbed_by_pack_master")

	self.move_target_index = 0
	self.desired_distance = 2
	self.last_valid_position = Vector3Box()
	self._drag_delta_move = Vector3Box()
	self.next_hanging_damage_time = 0
	self._mechanism_name = Managers.mechanism:current_mechanism_name()
end

PlayerCharacterStateGrabbedByPackMaster.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local inventory_extension = self.inventory_extension
	local career_extension = self.career_extension

	CharacterStateHelper.stop_weapon_actions(inventory_extension, "grabbed")
	CharacterStateHelper.stop_career_abilities(career_extension, "grabbed")
	inventory_extension:check_and_drop_pickups("grabbed_by_pack_master")
	CharacterStateHelper.change_camera_state(self.player, "follow_third_person")

	local first_person_extension = self.first_person_extension

	first_person_extension:set_first_person_mode(false)
	self.locomotion_extension:enable_rotation_towards_velocity(false)

	local status_extension = self.status_extension
	local get_pack_master_grabber = status_extension:get_pack_master_grabber()

	self.packmaster_unit = get_pack_master_grabber
	self.packmaster_is_player = Managers.player:is_player_unit(get_pack_master_grabber)

	if not self.packmaster_is_player then
		self.packmaster_claw_left_hand_constraint = Unit.animation_find_constraint_target(get_pack_master_grabber, "claw_target_left_hand")
		self.packmaster_claw_right_hand_constraint = Unit.animation_find_constraint_target(get_pack_master_grabber, "claw_target_right_hand")
		self.packmaster_claw = ScriptUnit.extension(get_pack_master_grabber, "inventory_system"):get_weapon_unit()
		self.claw_left_hand_node = Unit.node(self.packmaster_claw, "a_left_hand")
		self.claw_right_hand_node = Unit.node(self.packmaster_claw, "a_right_hand")
	end

	local var_2_5 = POSITION_LOOKUP[get_pack_master_grabber]
	local var_2_6 = POSITION_LOOKUP[arg_2_1]
	local node = Unit.node(get_pack_master_grabber, "j_rightweaponcomponent10")
	local world_position = Unit.world_position(get_pack_master_grabber, node)
	local num = world_position + Vector3(0, 2, 0)

	self._pole = {
		pole_length = 2,
		apos = Vector3Box(world_position),
		bpos = Vector3Box(num)
	}
	self.move_target_index = 1

	if self.ai_extension == nil then
		local wwise_world = Managers.world:wwise_world(self.world)
		local trigger_event, var_2_12 = WwiseWorld.trigger_event(wwise_world, "start_strangled_state", first_person_extension:get_first_person_unit())
	end

	self.last_valid_position:store(var_2_6)
	self.locomotion_extension:set_wanted_pos(var_2_6)

	self.packmaster_grab_state_initialized = false
	self.pack_master_status = CharacterStateHelper.pack_master_status(status_extension)

	local states = PlayerCharacterStateGrabbedByPackMaster.states

	if self.pack_master_status == "pack_master_pulling" then
		self._initial_pull_t = arg_2_5 + 0.75
	else
		self._initial_pull_t = arg_2_5
	end

	if not states[self.pack_master_status].enter then
		states[self.pack_master_status].enter(self, arg_2_1)
	end
end

PlayerCharacterStateGrabbedByPackMaster.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local first_person_extension = self.first_person_extension
	local status_extension = self.status_extension

	if not (status_extension:is_knocked_down() or status_extension:is_dead()) then
		CharacterStateHelper.change_camera_state(self.player, "follow")
		first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

		local locomotion_extension = self.locomotion_extension

		locomotion_extension:enable_script_driven_movement()
		locomotion_extension:enable_rotation_towards_velocity(true)
	end

	local inventory_extension = self.inventory_extension

	if inventory_extension:get_wielded_slot_name() ~= "slot_packmaster_claw" or not Managers.state.network:game() then
		inventory_extension:wield_previous_weapon()
	end

	if self.ai_extension == nil then
		local wwise_world = Managers.world:wwise_world(self.world)
		local trigger_event, var_3_6 = WwiseWorld.trigger_event(wwise_world, "stop_strangled_state", first_person_extension:get_first_person_unit())
	end

	if not status_extension:is_blocking() then
		if LEVEL_EDITOR_TEST or not Managers.state.network:game() then
			local go_id = Managers.state.unit_storage:go_id(arg_3_1)

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, false)
			end
		end

		status_extension:set_blocking(false)
	end
end

function fix_mover(arg_4_0, arg_4_1)
	-- function 4
	local mover = Unit.mover(arg_4_1)
	local var_4_1 = POSITION_LOOKUP[arg_4_1]

	Mover.set_position(mover, var_4_1 + Vector3(0, 0, 1.5))
	Mover.move(mover, Vector3(0, 0, -1.5), 0.03333333333333333)

	if not script_data.debug_ai_movement then
		local position = Mover.position(mover)

		QuickDrawerStay:sphere(var_4_1, 0.3, Color(245, 0, 0))
		QuickDrawerStay:line(var_4_1, position, Color(245, 0, 0))
		QuickDrawerStay:sphere(position, 0.3, Color(245, 245, 0))
	end
end

function update_mover(arg_5_0, arg_5_1)
	-- function 5
	local mover = Unit.mover(arg_5_1)

	Mover.move(mover, Vector3(0, 0, -1.5), 0.03333333333333333)
end

local function fn(self, arg_6_1, arg_6_2)
	-- function 6
	if not self.packmaster_grab_state_initialized then
		return false
	end

	self.packmaster_grab_state_initialized = true

	if arg_6_2 == "pack_master_hoisting" then
		self.locomotion_extension:enable_wanted_position_movement()
	end

	local inventory_extension = self.inventory_extension

	if inventory_extension:get_wielded_slot_name() ~= "slot_packmaster_claw" then
		inventory_extension:wield("slot_packmaster_claw", true)
	else
		CharacterStateHelper.show_inventory_3p(arg_6_1, true, true, Managers.player.is_server, self.inventory_extension)
	end
end

PlayerCharacterStateGrabbedByPackMaster.states = {
	pack_master_pulling = {
		enter = function (self, arg_7_1)
			-- function 7
			self.locomotion_extension:enable_animation_driven_movement()
			fn(self, arg_7_1, "pack_master_pulling")
			Managers.state.network:anim_event(arg_7_1, "packmaster_hooked")
		end,
		run = function (self, arg_8_1)
			-- function 8
			self.last_valid_position:store(POSITION_LOOKUP[arg_8_1])
		end
	},
	pack_master_dragging = {
		enter = function (self, arg_9_1)
			-- function 9
			self.locomotion_extension:enable_wanted_position_movement()
			fn(self, arg_9_1, "pack_master_dragging")

			self.dragged_move_anim = "move_bwd"

			CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, "move_bwd")
		end,
		run = function (self, arg_10_1)
			-- function 10
			local unbox = self._drag_delta_move:unbox()
			local length = Vector3.length(unbox)

			if not self.packmaster_is_player then
				local world_position = Unit.world_position(self.packmaster_claw, self.claw_left_hand_node)
				local world_position_2 = Unit.world_position(self.packmaster_claw, self.claw_right_hand_node)

				Unit.animation_set_constraint_target(self.packmaster_unit, self.packmaster_claw_left_hand_constraint, world_position)
				Unit.animation_set_constraint_target(self.packmaster_unit, self.packmaster_claw_right_hand_constraint, world_position_2)
			end

			if not (length ~= 0 or self.dragged_move_anim ~= "move_bwd") then
				Managers.state.network:anim_event(arg_10_1, "packmaster_hooked_idle")

				self.dragged_move_anim = "packmaster_hooked_idle"
			elseif not (not (length > 0) or self.dragged_move_anim ~= "packmaster_hooked_idle") then
				Managers.state.network:anim_event(arg_10_1, "move_bwd")

				self.dragged_move_anim = "move_bwd"
			end

			return true
		end,
		leave = function (self, arg_11_1)
			-- function 11
			local flag = not arg_11_1 and POSITION_LOOKUP[arg_11_1]

			if not flag then
				self.locomotion_extension:teleport_to(flag)

				if not script_data.vs_debug_hoist then
					QuickDrawerStay:sphere(flag, 0.5, Colors.get("yellow"))
				end
			end
		end
	},
	pack_master_unhooked = {
		run = function (self, arg_12_1)
			-- function 12
			self.last_valid_position:store(POSITION_LOOKUP[arg_12_1])
		end,
		enter = function (self, arg_13_1)
			-- function 13
			CharacterStateHelper.show_inventory_3p(arg_13_1, false, true, Managers.player.is_server, self.inventory_extension)

			local status_extension = self.status_extension

			if not CharacterStateHelper.is_dead(status_extension) then
				CharacterStateHelper.play_animation_event(arg_13_1, "packmaster_release_death")
			elseif not CharacterStateHelper.is_knocked_down(status_extension) then
				self.temp_params.already_in_ko_anim = true

				CharacterStateHelper.play_animation_event(arg_13_1, "packmaster_release_ko")
			else
				if LEVEL_EDITOR_TEST or not Managers.state.network:game() then
					local go_id = Managers.state.unit_storage:go_id(arg_13_1)

					if not self.is_server then
						Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, true)
					else
						Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, true)
					end
				end

				status_extension:set_blocking(true)
				CharacterStateHelper.play_animation_event(arg_13_1, "packmaster_release")
			end

			self.locomotion_extension:enable_animation_driven_movement()
		end
	},
	pack_master_hoisting = {
		enter = function (self, arg_14_1)
			-- function 14
			fn(self, arg_14_1, "pack_master_hoisting")

			local extension = ScriptUnit.extension(arg_14_1, "inventory_system")
			local right_hand_wielded_unit_3p = extension:equipment().right_hand_wielded_unit_3p

			if not (extension:get_wielded_slot_name() ~= "slot_packmaster_claw" or right_hand_wielded_unit_3p) then
				extension:wield("slot_packmaster_claw")
			end

			local profile_index = Managers.player:owner(arg_14_1):profile_index()
			local unit_name = SPProfiles[profile_index].unit_name
			local str = "attack_grab_hang_" .. unit_name

			Managers.state.entity:system("inventory_system"):weapon_anim_event(arg_14_1, str)
			Managers.state.network:anim_event(arg_14_1, "packmaster_hang_start")

			local get_pack_master_grabber = self.status_extension:get_pack_master_grabber()

			if not ALIVE[get_pack_master_grabber] then
				Managers.state.network:anim_event(get_pack_master_grabber, str)
			end

			local function fn_2()
				-- function 15
				if not ALIVE[arg_14_1] and not ALIVE[get_pack_master_grabber] then
					local get_data = World.get_data(self.world, "physics_world")
					local get_hoist_position = PactswornUtils.get_hoist_position(get_data, arg_14_1, get_pack_master_grabber)

					if not script_data.vs_debug_hoist then
						QuickDrawerStay:sphere(get_hoist_position, 0.5, Colors.get("magenta"))
					end

					self.locomotion_extension:teleport_to(get_hoist_position, nil)
				end
			end

			Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn_2)
		end,
		run = function (arg_16_0, arg_16_1)
			-- function 16
			return
		end
	},
	pack_master_hanging = {
		enter = function (arg_17_0, arg_17_1)
			-- function 17
			return
		end,
		run = function (arg_18_0, arg_18_1)
			-- function 18
			return
		end
	},
	pack_master_dropping = {
		enter = function (self, arg_19_1)
			-- function 19
			CharacterStateHelper.show_inventory_3p(arg_19_1, false, true, Managers.player.is_server, self.inventory_extension)

			local status_extension = self.status_extension

			if not CharacterStateHelper.is_dead(status_extension) then
				CharacterStateHelper.play_animation_event(arg_19_1, "packmaster_hang_release_death")
			elseif not CharacterStateHelper.is_knocked_down(status_extension) then
				self.temp_params.already_in_ko_anim = true

				CharacterStateHelper.play_animation_event(arg_19_1, "packmaster_hang_release_ko")
			else
				if LEVEL_EDITOR_TEST or not Managers.state.network:game() then
					local go_id = Managers.state.unit_storage:go_id(arg_19_1)

					if not self.is_server then
						Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, true)
					else
						Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, true)
					end
				end

				status_extension:set_blocking(true)
				CharacterStateHelper.play_animation_event(arg_19_1, "packmaster_hang_release")
			end

			self.locomotion_extension:enable_animation_driven_movement()
		end,
		run = function (arg_20_0, arg_20_1)
			-- function 20
			return
		end
	},
	pack_master_released = {
		run = function (arg_21_0, arg_21_1)
			-- function 21
			return
		end,
		enter = function (self, arg_22_1)
			-- function 22
			self.locomotion_extension:enable_script_driven_movement()
			CharacterStateHelper.show_inventory_3p(arg_22_1, true, true, Managers.player.is_server, self.inventory_extension)

			local status_extension = self.status_extension
			local csm = self.csm

			if not CharacterStateHelper.is_dead(status_extension) then
				csm:change_state("dead")
			elseif not CharacterStateHelper.is_knocked_down(status_extension) then
				if self.inventory_extension:get_wielded_slot_name() == "slot_packmaster_claw" then
					self.inventory_extension:wield_previous_weapon()
				end

				csm:change_state("knocked_down", self.temp_params)
			else
				if self.inventory_extension:get_wielded_slot_name() == "slot_packmaster_claw" then
					self.inventory_extension:wield_previous_weapon()
				end

				csm:change_state("standing")
			end
		end
	}
}

PlayerCharacterStateGrabbedByPackMaster.update = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local pack_master_status = CharacterStateHelper.pack_master_status(self.status_extension)

	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)

	if self._mechanism_name ~= "versus" or not CharacterStateHelper.is_ledge_hanging(self.world, unit, self.temp_params) then
		local get_pack_master_grabber = status_extension:get_pack_master_grabber()

		StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", unit, false, get_pack_master_grabber)
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	local states = PlayerCharacterStateGrabbedByPackMaster.states
	local pack_master_status_2 = self.pack_master_status

	if pack_master_status ~= pack_master_status_2 then
		if not states[pack_master_status_2].leave then
			states[pack_master_status_2].leave(self, unit)
		end

		if not states[pack_master_status].enter then
			states[pack_master_status].enter(self, unit)
		end

		self.pack_master_status = pack_master_status
	end

	local get_pack_master_grabber_2 = status_extension:get_pack_master_grabber()

	if not (not states[pack_master_status].run(self, unit) and Unit.alive(get_pack_master_grabber_2)) then
		if pack_master_status == "pack_master_pulling" then
			if not (not (arg_23_5 > self._initial_pull_t) or self._pull_lerp) then
				self.locomotion_extension:enable_wanted_position_movement()

				self._pull_lerp = true
				self._pull_lerp_dif = math.huge
			end

			if not self._pull_lerp then
				local _pole = self._pole
				local node = Unit.node(unit, "j_neck")
				local world_position = Unit.world_position(unit, node)
				local num = POSITION_LOOKUP[unit] - world_position
				local node_2 = Unit.node(get_pack_master_grabber_2, "j_rightweaponcomponent10")
				local world_position_2 = Unit.world_position(get_pack_master_grabber_2, node_2)
				local num_2 = world_position_2 + Vector3.normalize(world_position - world_position_2) * _pole.pole_length + num

				if not self._pull_lerp then
					local world_position_3 = Unit.world_position(unit, 0)
					local num_3 = num_2 - world_position_3
					local num_4 = Vector3.normalize(num_3) * arg_23_3 * 0.5

					if Vector3.length_squared(num_3) < self._pull_lerp_dif then
						self._pull_lerp_dif = Vector3.length_squared(num_3)
						num_2 = world_position_3 + num_4
					else
						self._pull_lerp = nil
					end
				end

				self.locomotion_extension:set_wanted_pos(num_2)
			end
		end

		return
	end

	local var_23_21 = POSITION_LOOKUP[get_pack_master_grabber_2]
	local var_23_22 = POSITION_LOOKUP[unit]
	local var_23_23
	local _pole_2 = self._pole
	local node_3 = Unit.node(unit, "j_neck")
	local world_position_4 = Unit.world_position(unit, node_3)
	local num_5 = var_23_22 - world_position_4
	local node_4 = Unit.node(get_pack_master_grabber_2, "j_rightweaponcomponent10")
	local world_position_5 = Unit.world_position(get_pack_master_grabber_2, node_4)
	local num_6 = Vector3.normalize(world_position_4 - world_position_5) * _pole_2.pole_length
	local num_7 = world_position_5 + num_6
	local num_8 = num_7 + num_5

	num_8 = num_8 or var_23_22

	local num_9 = num_8 - var_23_22

	num_9.z = 0

	self._drag_delta_move:store(num_9)

	local flat = Vector3.flat(var_23_21 - var_23_22)
	local look = Quaternion.look(-flat)
	local local_rotation = Unit.local_rotation(unit, 0)
	local lerp = Quaternion.lerp(local_rotation, look, 0.1)

	Unit.set_local_rotation(unit, 0, lerp)
	self.locomotion_extension:set_wanted_pos(num_8)

	if not script_data.vs_debug_hoist then
		QuickDrawer:sphere(num_8, 0.5, Colors.get("green"))
		QuickDrawer:sphere(world_position_5, 0.5, Colors.get("blue"))
		QuickDrawer:line(world_position_5, world_position_5 + num_6, Colors.get("blue"))
		QuickDrawer:sphere(num_7, 0.5, Colors.get("yellow"))
	end

	local get_data = World.get_data(self.world, "physics_world")
	local num_10 = 0.9
	local num_11 = 0.6
	local var_23_41 = Vector3(num_10, num_11, num_10)
	local flag

	flag = not (num_11 - num_10 > 0) or not "capsule" or "sphere"

	local immediate_overlap, var_23_44 = PhysicsWorld.immediate_overlap(get_data, "shape", flag, "position", var_23_22 + Vector3(0, 0, 0.9), "size", var_23_41, "collision_filter", "filter_player_mover")

	if var_23_44 == 0 then
		self.last_valid_position:store(var_23_22)
	end
end
