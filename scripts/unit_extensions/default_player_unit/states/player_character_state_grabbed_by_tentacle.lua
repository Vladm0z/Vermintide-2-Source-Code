-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_tentacle.lua

PlayerCharacterStateGrabbedByTentacle = class(PlayerCharacterStateGrabbedByTentacle, PlayerCharacterState)

local POSITION_LOOKUP = POSITION_LOOKUP
local play_animation_event = CharacterStateHelper.play_animation_event
local num = 100
local num_2 = 9

PlayerCharacterStateGrabbedByTentacle.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "grabbed_by_tentacle")
end

PlayerCharacterStateGrabbedByTentacle.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	local inventory_extension = self.inventory_extension
	local career_extension = self.career_extension

	CharacterStateHelper.stop_weapon_actions(inventory_extension, "grabbed")
	CharacterStateHelper.stop_career_abilities(career_extension, "grabbed")
	inventory_extension:check_and_drop_pickups("grabbed_by_tentacle")

	local first_person_extension = self.first_person_extension

	first_person_extension:set_first_person_mode(false)
	first_person_extension:set_wanted_player_height("grabbed_by_tentacle", arg_2_5)

	local status_extension = self.status_extension
	local grabbed_by_tentacle_unit = status_extension.grabbed_by_tentacle_unit

	self.tentacle_unit = grabbed_by_tentacle_unit

	local has_extension = ScriptUnit.has_extension(grabbed_by_tentacle_unit, "ai_supplementary_system")
	local portal_unit = has_extension.portal_unit

	self.tentacle_template = has_extension.tentacle_template
	self.portal_unit = portal_unit
	self.tentacle_spline_extension = has_extension
	self.winding_dist = has_extension.lock_point_dist

	local tentacle_data = has_extension.tentacle_data
	local forward = Quaternion.forward(Unit.local_rotation(tentacle_data.portal_unit, 0))

	self.portal_forward = Vector3Box(forward)

	local get_data = Unit.get_data(grabbed_by_tentacle_unit, "breed")

	self.breed = get_data
	self.drag_speed = get_data.drag_speed
	self.camera_state = "first_person"
	self.hips_node = Unit.node(arg_2_1, "j_hips")

	if not Unit.has_node(portal_unit, "a_player_attach") then
		self.hang_node = Unit.node(portal_unit, "a_player_attach")
	end

	self.physics_world = World.physics_world(self.world)

	local nav_world = self.nav_world

	nav_world = nav_world or Managers.state.entity:system("ai_system"):nav_world()
	self.nav_world = nav_world

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:enable_script_driven_no_mover_movement()
	locomotion_extension:enable_rotation_towards_velocity(false)

	local grabbed_by_tentacle_status = CharacterStateHelper.grabbed_by_tentacle_status(status_extension)
	local states = PlayerCharacterStateGrabbedByTentacle.states

	if not states[grabbed_by_tentacle_status].enter then
		states[grabbed_by_tentacle_status].enter(self, arg_2_1, arg_2_5)
	end

	self.grabbed_by_tentacle_status = grabbed_by_tentacle_status
end

local function fn(arg_3_0, arg_3_1)
	-- function 3
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(arg_3_0, arg_3_1, 1, 1)

	if not pos_on_mesh then
		return pos_on_mesh
	end

	local num = 1
	local num_2 = 2
	local num_3 = 1
	local num_4 = 0.05
	local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(arg_3_0, arg_3_1, num, num_2, num_3, num_4)

	if not inside_position_from_outside_position then
		return inside_position_from_outside_position
	end
end

PlayerCharacterStateGrabbedByTentacle.on_exit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	local status_extension = self.status_extension

	status_extension:set_grabbed_by_tentacle(false)

	local flag = self.camera_state ~= "first_person" or false

	CharacterStateHelper.show_inventory_3p(arg_4_1, true, flag, self.is_server, self.inventory_extension)

	local player = self.player

	Managers.state.entity:system("camera_system"):set_follow_unit(player)

	if self.grabbed_by_tentacle_status ~= "portal_consume" then
		local locomotion_extension = self.locomotion_extension

		if not (CharacterStateHelper.is_knocked_down(status_extension) or CharacterStateHelper.is_dead(status_extension)) then
			local first_person_extension = self.first_person_extension
			local camera_state = self.camera_state

			CharacterStateHelper.change_camera_state(player, "follow")

			if camera_state == "first_person" then
				first_person_extension:set_first_person_mode(true)
			else
				first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
			end

			locomotion_extension:reset_maximum_upwards_velocity()
			locomotion_extension:enable_script_driven_movement()
			locomotion_extension:enable_rotation_towards_velocity(true)
		end

		local nav_world = self.nav_world
		local world_position = Unit.world_position(arg_4_1, self.hips_node)
		local unbox = self.tentacle_spline_extension.tentacle_data.last_target_pos:unbox()

		if not unbox then
			locomotion_extension:teleport_to(unbox)
		end
	end

	self.first_person_extension:set_wanted_player_height("stand", arg_4_5)

	self.camera_state = nil
	self.grabbed_by_tentacle_status = nil
end

PlayerCharacterStateGrabbedByTentacle.states = {
	grabbed = {
		enter = function (self, arg_5_1, arg_5_2)
			-- function 5
			local flag = self.camera_state ~= "first_person" or false

			CharacterStateHelper.show_inventory_3p(arg_5_1, false, flag, self.is_server, self.inventory_extension)
			play_animation_event(arg_5_1, "tentacle_grabbed_loop")
		end,
		run = function (self, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			local world_position = Unit.world_position(arg_6_1, self.hips_node)
			local nav_world = self.nav_world
			local get_drag_velocity = self:get_drag_velocity(world_position, arg_6_2, arg_6_3)
			local num = world_position + get_drag_velocity
			local immediate_raycast, var_6_5, var_6_6, var_6_7, var_6_8 = PhysicsWorld.immediate_raycast(self.physics_world, world_position, Vector3(0, 0, -1), 1, "all", "collision_filter", "filter_ledge_test")

			if not immediate_raycast then
				get_drag_velocity.z = 0.5
			end

			self.locomotion_extension:set_wanted_velocity(get_drag_velocity)

			local normalize = Vector3.normalize(get_drag_velocity)
			local world_rotation = Unit.world_rotation(arg_6_1, 0)
			local look = Quaternion.look(normalize, Vector3.up())
			local lerp = Quaternion.lerp(world_rotation, look, arg_6_3)

			Unit.set_local_rotation(arg_6_1, 0, lerp)

			local camera_state = self.camera_state

			if not (camera_state == "first_person" or camera_state ~= "third_person") then
				local player = self.player
				local portal_unit = self.portal_unit
				local num_2 = POSITION_LOOKUP[portal_unit] - world_position
				local length_squared = Vector3.length_squared(num_2)
				local tentacle_template = self.tentacle_template

				if not (camera_state ~= "first_person" or not (length_squared < tentacle_template.switch_to_3p_dist_sq)) then
					CharacterStateHelper.change_camera_state(player, "follow_third_person")
					self.inventory_extension:show_third_person_inventory(false)

					self.camera_state = "third_person"
				elseif not (camera_state ~= "third_person" or not (length_squared < tentacle_template.switch_to_portal_cam_dist_sq)) then
					local system = Managers.state.entity:system("camera_system")
					local portal_camera_node = self.tentacle_template.portal_camera_node

					system:set_follow_unit(player, portal_unit, portal_camera_node)

					self.camera_state = "portal"
				end
			end
		end,
		leave = function (arg_7_0, arg_7_1)
			-- function 7
			return
		end
	},
	portal_hanging = {
		enter = function (self, arg_8_1, arg_8_2)
			-- function 8
			play_animation_event(arg_8_1, "tentacle_portal_struggle_loop")

			local world_rotation = Unit.world_rotation(self.portal_unit, self.hang_node)

			Unit.set_local_rotation(arg_8_1, 0, world_rotation)
		end,
		run = function (self, arg_9_1, arg_9_2, arg_9_3)
			-- function 9
			local world_position = Unit.world_position(arg_9_1, 0)
			local num = Unit.world_position(self.portal_unit, self.hang_node) - world_position

			if Vector3.length_squared(num) > 0.01 then
				local num_2 = 5 * num

				self.locomotion_extension:set_wanted_velocity(num_2)
			else
				self.locomotion_extension:set_wanted_velocity(Vector3.zero())
			end
		end,
		leave = function (arg_10_0, arg_10_1)
			-- function 10
			return
		end
	},
	portal_consume = {
		enter = function (self, arg_11_1, arg_11_2)
			-- function 11
			local portal_unit = self.portal_unit
			local node = Unit.node(portal_unit, "a_surface_center")
			local world_position = Unit.world_position(portal_unit, node)
			local world_rotation = Unit.world_rotation(portal_unit, node)
			local forward = Quaternion.forward(world_rotation)
			local breed = self.breed
			local tbl = {
				animation = "tentacle_portal_struggle_dead",
				drop_items_delay = breed.time_before_consume_kill_player,
				override_item_drop_position = world_position,
				override_item_drop_direction = forward
			}

			self.csm:change_state("dead", tbl)
		end,
		run = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			-- function 12
			return
		end,
		leave = function (arg_13_0, arg_13_1)
			-- function 13
			return
		end
	},
	portal_release = {
		enter = function (self, arg_14_1, arg_14_2)
			-- function 14
			play_animation_event(arg_14_1, "tentacle_portal_struggle_release")
			self.locomotion_extension:set_wanted_velocity(Vector3.zero())

			self.wait_for_release = arg_14_2 + self.breed.portal_release_time
		end,
		run = function (self, arg_15_1, arg_15_2, arg_15_3)
			-- function 15
			if arg_15_2 > self.wait_for_release then
				self.csm:change_state("standing")
			end
		end,
		leave = function (arg_16_0, arg_16_1)
			-- function 16
			return
		end
	}
}

PlayerCharacterStateGrabbedByTentacle.get_drag_velocity = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	self.winding_dist = self.winding_dist - self.drag_speed * arg_17_3

	local spline = self.tentacle_spline_extension.spline
	local tentacle_data = self.tentacle_spline_extension.tentacle_data
	local flag

	flag = tentacle_data.portal_spawn_type ~= "floor" or not 3.3 or 2.5

	local get_point_at_distance = spline:get_point_at_distance(self.winding_dist - flag)
	local travel_to_node_index = self.tentacle_spline_extension.tentacle_data.travel_to_node_index
	local var_17_5
	local var_17_6

	if not travel_to_node_index then
		local unbox = self.tentacle_spline_extension.tentacle_data.astar_node_list[travel_to_node_index + 1]:unbox()
		local unbox_2 = self.tentacle_spline_extension.tentacle_data.astar_node_list[travel_to_node_index]:unbox()

		var_17_5 = Vector3.normalize(unbox_2 - unbox)

		QuickDrawer:line(unbox_2, arg_17_1, Color(200, 0, 255))
	else
		local var_17_9
		local var_17_10
		local unbox_3 = self.portal_forward:unbox()
		local unbox_4 = tentacle_data.root_pos:unbox()
		local unbox_5 = tentacle_data.wall_pos:unbox()

		if tentacle_data.portal_spawn_type == "floor" then
			local num = 4
			local num_2 = 3
			local funnel_one_point

			funnel_one_point, var_17_10 = self.tentacle_spline_extension:funnel_one_point(get_point_at_distance, unbox_5, unbox_4, unbox_3, num, num_2)
		else
			local num_3 = 2.5
			local funnel_one_point_2

			funnel_one_point_2, var_17_10 = self.tentacle_spline_extension:funnel_one_point(get_point_at_distance, unbox_5, unbox_4, unbox_3, num_3)
		end

		if var_17_10 > 1 then
			get_point_at_distance = unbox_5 + unbox_3 * 2
		end

		var_17_5 = Vector3.normalize(get_point_at_distance - arg_17_1)
	end

	local var_17_19

	return var_17_5 * self.drag_speed, var_17_19
end

PlayerCharacterStateGrabbedByTentacle.update = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	local csm = self.csm
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local tentacle_unit = self.tentacle_unit

	if not (not status_extension.grabbed_by_tentacle and Unit.alive(tentacle_unit)) then
		if not CharacterStateHelper.is_waiting_for_assisted_respawn(status_extension) then
			csm:change_state("waiting_for_assisted_respawn")
		elseif not CharacterStateHelper.is_knocked_down(status_extension) then
			csm:change_state("knocked_down")
		elseif not CharacterStateHelper.is_dead(status_extension) then
			csm:change_state("dead")
		else
			csm:change_state("standing")
		end

		return
	end

	local grabbed_by_tentacle_status = CharacterStateHelper.grabbed_by_tentacle_status(status_extension)
	local grabbed_by_tentacle_status_2 = self.grabbed_by_tentacle_status
	local states = PlayerCharacterStateGrabbedByTentacle.states

	if grabbed_by_tentacle_status ~= grabbed_by_tentacle_status_2 then
		if not states[grabbed_by_tentacle_status_2].leave then
			states[grabbed_by_tentacle_status_2].leave(self, arg_18_1)
		end

		if not states[grabbed_by_tentacle_status].enter then
			states[grabbed_by_tentacle_status].enter(self, arg_18_1, arg_18_5)
		end

		self.grabbed_by_tentacle_status = grabbed_by_tentacle_status
	end

	states[grabbed_by_tentacle_status].run(self, arg_18_1, arg_18_5, arg_18_3)

	local player = self.player

	CharacterStateHelper.look(input_extension, player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
end
