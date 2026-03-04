-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_tentacle.lua

PlayerCharacterStateGrabbedByTentacle = class(PlayerCharacterStateGrabbedByTentacle, PlayerCharacterState)

local var_0_0 = POSITION_LOOKUP
local var_0_1 = CharacterStateHelper.play_animation_event
local var_0_2 = 100
local var_0_3 = 9

function PlayerCharacterStateGrabbedByTentacle.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "grabbed_by_tentacle")
end

function PlayerCharacterStateGrabbedByTentacle.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	local var_2_0 = arg_2_0.inventory_extension
	local var_2_1 = arg_2_0.career_extension

	CharacterStateHelper.stop_weapon_actions(var_2_0, "grabbed")
	CharacterStateHelper.stop_career_abilities(var_2_1, "grabbed")
	var_2_0:check_and_drop_pickups("grabbed_by_tentacle")

	local var_2_2 = arg_2_0.first_person_extension

	var_2_2:set_first_person_mode(false)
	var_2_2:set_wanted_player_height("grabbed_by_tentacle", arg_2_5)

	local var_2_3 = arg_2_0.status_extension
	local var_2_4 = var_2_3.grabbed_by_tentacle_unit

	arg_2_0.tentacle_unit = var_2_4

	local var_2_5 = ScriptUnit.has_extension(var_2_4, "ai_supplementary_system")
	local var_2_6 = var_2_5.portal_unit

	arg_2_0.tentacle_template = var_2_5.tentacle_template
	arg_2_0.portal_unit = var_2_6
	arg_2_0.tentacle_spline_extension = var_2_5
	arg_2_0.winding_dist = var_2_5.lock_point_dist

	local var_2_7 = var_2_5.tentacle_data
	local var_2_8 = Quaternion.forward(Unit.local_rotation(var_2_7.portal_unit, 0))

	arg_2_0.portal_forward = Vector3Box(var_2_8)

	local var_2_9 = Unit.get_data(var_2_4, "breed")

	arg_2_0.breed = var_2_9
	arg_2_0.drag_speed = var_2_9.drag_speed
	arg_2_0.camera_state = "first_person"
	arg_2_0.hips_node = Unit.node(arg_2_1, "j_hips")

	if Unit.has_node(var_2_6, "a_player_attach") then
		arg_2_0.hang_node = Unit.node(var_2_6, "a_player_attach")
	end

	arg_2_0.physics_world = World.physics_world(arg_2_0.world)
	arg_2_0.nav_world = arg_2_0.nav_world or Managers.state.entity:system("ai_system"):nav_world()

	local var_2_10 = arg_2_0.locomotion_extension

	var_2_10:enable_script_driven_no_mover_movement()
	var_2_10:enable_rotation_towards_velocity(false)

	local var_2_11 = CharacterStateHelper.grabbed_by_tentacle_status(var_2_3)
	local var_2_12 = PlayerCharacterStateGrabbedByTentacle.states

	if var_2_12[var_2_11].enter then
		var_2_12[var_2_11].enter(arg_2_0, arg_2_1, arg_2_5)
	end

	arg_2_0.grabbed_by_tentacle_status = var_2_11
end

local function var_0_4(arg_3_0, arg_3_1)
	local var_3_0 = LocomotionUtils.pos_on_mesh(arg_3_0, arg_3_1, 1, 1)

	if var_3_0 then
		return var_3_0
	end

	local var_3_1 = 1
	local var_3_2 = 2
	local var_3_3 = 1
	local var_3_4 = 0.05
	local var_3_5 = GwNavQueries.inside_position_from_outside_position(arg_3_0, arg_3_1, var_3_1, var_3_2, var_3_3, var_3_4)

	if var_3_5 then
		return var_3_5
	end
end

function PlayerCharacterStateGrabbedByTentacle.on_exit(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	local var_4_0 = arg_4_0.status_extension

	var_4_0:set_grabbed_by_tentacle(false)

	local var_4_1 = arg_4_0.camera_state ~= "first_person" or false

	CharacterStateHelper.show_inventory_3p(arg_4_1, true, var_4_1, arg_4_0.is_server, arg_4_0.inventory_extension)

	local var_4_2 = arg_4_0.player

	Managers.state.entity:system("camera_system"):set_follow_unit(var_4_2)

	if arg_4_0.grabbed_by_tentacle_status ~= "portal_consume" then
		local var_4_3 = arg_4_0.locomotion_extension

		if not CharacterStateHelper.is_knocked_down(var_4_0) and not CharacterStateHelper.is_dead(var_4_0) then
			local var_4_4 = arg_4_0.first_person_extension
			local var_4_5 = arg_4_0.camera_state

			CharacterStateHelper.change_camera_state(var_4_2, "follow")

			if var_4_5 == "first_person" then
				var_4_4:set_first_person_mode(true)
			else
				var_4_4:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
			end

			var_4_3:reset_maximum_upwards_velocity()
			var_4_3:enable_script_driven_movement()
			var_4_3:enable_rotation_towards_velocity(true)
		end

		local var_4_6 = arg_4_0.nav_world
		local var_4_7 = Unit.world_position(arg_4_1, arg_4_0.hips_node)
		local var_4_8 = arg_4_0.tentacle_spline_extension.tentacle_data.last_target_pos:unbox()

		if var_4_8 then
			var_4_3:teleport_to(var_4_8)
		end
	end

	arg_4_0.first_person_extension:set_wanted_player_height("stand", arg_4_5)

	arg_4_0.camera_state = nil
	arg_4_0.grabbed_by_tentacle_status = nil
end

PlayerCharacterStateGrabbedByTentacle.states = {
	grabbed = {
		enter = function(arg_5_0, arg_5_1, arg_5_2)
			local var_5_0 = arg_5_0.camera_state ~= "first_person" or false

			CharacterStateHelper.show_inventory_3p(arg_5_1, false, var_5_0, arg_5_0.is_server, arg_5_0.inventory_extension)
			var_0_1(arg_5_1, "tentacle_grabbed_loop")
		end,
		run = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = Unit.world_position(arg_6_1, arg_6_0.hips_node)
			local var_6_1 = arg_6_0.nav_world
			local var_6_2 = arg_6_0:get_drag_velocity(var_6_0, arg_6_2, arg_6_3)
			local var_6_3 = var_6_0 + var_6_2
			local var_6_4, var_6_5, var_6_6, var_6_7, var_6_8 = PhysicsWorld.immediate_raycast(arg_6_0.physics_world, var_6_0, Vector3(0, 0, -1), 1, "all", "collision_filter", "filter_ledge_test")

			if var_6_4 then
				var_6_2.z = 0.5
			end

			arg_6_0.locomotion_extension:set_wanted_velocity(var_6_2)

			local var_6_9 = Vector3.normalize(var_6_2)
			local var_6_10 = Unit.world_rotation(arg_6_1, 0)
			local var_6_11 = Quaternion.look(var_6_9, Vector3.up())
			local var_6_12 = Quaternion.lerp(var_6_10, var_6_11, arg_6_3)

			Unit.set_local_rotation(arg_6_1, 0, var_6_12)

			local var_6_13 = arg_6_0.camera_state

			if var_6_13 == "first_person" or var_6_13 == "third_person" then
				local var_6_14 = arg_6_0.player
				local var_6_15 = arg_6_0.portal_unit
				local var_6_16 = var_0_0[var_6_15] - var_6_0
				local var_6_17 = Vector3.length_squared(var_6_16)
				local var_6_18 = arg_6_0.tentacle_template

				if var_6_13 == "first_person" and var_6_17 < var_6_18.switch_to_3p_dist_sq then
					CharacterStateHelper.change_camera_state(var_6_14, "follow_third_person")
					arg_6_0.inventory_extension:show_third_person_inventory(false)

					arg_6_0.camera_state = "third_person"
				elseif var_6_13 == "third_person" and var_6_17 < var_6_18.switch_to_portal_cam_dist_sq then
					local var_6_19 = Managers.state.entity:system("camera_system")
					local var_6_20 = arg_6_0.tentacle_template.portal_camera_node

					var_6_19:set_follow_unit(var_6_14, var_6_15, var_6_20)

					arg_6_0.camera_state = "portal"
				end
			end
		end,
		leave = function(arg_7_0, arg_7_1)
			return
		end
	},
	portal_hanging = {
		enter = function(arg_8_0, arg_8_1, arg_8_2)
			var_0_1(arg_8_1, "tentacle_portal_struggle_loop")

			local var_8_0 = Unit.world_rotation(arg_8_0.portal_unit, arg_8_0.hang_node)

			Unit.set_local_rotation(arg_8_1, 0, var_8_0)
		end,
		run = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			local var_9_0 = Unit.world_position(arg_9_1, 0)
			local var_9_1 = Unit.world_position(arg_9_0.portal_unit, arg_9_0.hang_node) - var_9_0

			if Vector3.length_squared(var_9_1) > 0.01 then
				local var_9_2 = 5 * var_9_1

				arg_9_0.locomotion_extension:set_wanted_velocity(var_9_2)
			else
				arg_9_0.locomotion_extension:set_wanted_velocity(Vector3.zero())
			end
		end,
		leave = function(arg_10_0, arg_10_1)
			return
		end
	},
	portal_consume = {
		enter = function(arg_11_0, arg_11_1, arg_11_2)
			local var_11_0 = arg_11_0.portal_unit
			local var_11_1 = Unit.node(var_11_0, "a_surface_center")
			local var_11_2 = Unit.world_position(var_11_0, var_11_1)
			local var_11_3 = Unit.world_rotation(var_11_0, var_11_1)
			local var_11_4 = Quaternion.forward(var_11_3)
			local var_11_5 = arg_11_0.breed
			local var_11_6 = {
				animation = "tentacle_portal_struggle_dead",
				drop_items_delay = var_11_5.time_before_consume_kill_player,
				override_item_drop_position = var_11_2,
				override_item_drop_direction = var_11_4
			}

			arg_11_0.csm:change_state("dead", var_11_6)
		end,
		run = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			return
		end,
		leave = function(arg_13_0, arg_13_1)
			return
		end
	},
	portal_release = {
		enter = function(arg_14_0, arg_14_1, arg_14_2)
			var_0_1(arg_14_1, "tentacle_portal_struggle_release")
			arg_14_0.locomotion_extension:set_wanted_velocity(Vector3.zero())

			arg_14_0.wait_for_release = arg_14_2 + arg_14_0.breed.portal_release_time
		end,
		run = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			if arg_15_2 > arg_15_0.wait_for_release then
				arg_15_0.csm:change_state("standing")
			end
		end,
		leave = function(arg_16_0, arg_16_1)
			return
		end
	}
}

function PlayerCharacterStateGrabbedByTentacle.get_drag_velocity(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_0.winding_dist = arg_17_0.winding_dist - arg_17_0.drag_speed * arg_17_3

	local var_17_0 = arg_17_0.tentacle_spline_extension.spline
	local var_17_1 = arg_17_0.tentacle_spline_extension.tentacle_data
	local var_17_2 = var_17_1.portal_spawn_type == "floor" and 3.3 or 2.5
	local var_17_3 = var_17_0:get_point_at_distance(arg_17_0.winding_dist - var_17_2)
	local var_17_4 = arg_17_0.tentacle_spline_extension.tentacle_data.travel_to_node_index
	local var_17_5
	local var_17_6

	if var_17_4 then
		local var_17_7 = arg_17_0.tentacle_spline_extension.tentacle_data.astar_node_list[var_17_4 + 1]:unbox()
		local var_17_8 = arg_17_0.tentacle_spline_extension.tentacle_data.astar_node_list[var_17_4]:unbox()

		var_17_5 = Vector3.normalize(var_17_8 - var_17_7)

		QuickDrawer:line(var_17_8, arg_17_1, Color(200, 0, 255))
	else
		local var_17_9
		local var_17_10
		local var_17_11 = arg_17_0.portal_forward:unbox()
		local var_17_12 = var_17_1.root_pos:unbox()
		local var_17_13 = var_17_1.wall_pos:unbox()

		if var_17_1.portal_spawn_type == "floor" then
			local var_17_14 = 4
			local var_17_15 = 3
			local var_17_16

			var_17_16, var_17_10 = arg_17_0.tentacle_spline_extension:funnel_one_point(var_17_3, var_17_13, var_17_12, var_17_11, var_17_14, var_17_15)
		else
			local var_17_17 = 2.5
			local var_17_18

			var_17_18, var_17_10 = arg_17_0.tentacle_spline_extension:funnel_one_point(var_17_3, var_17_13, var_17_12, var_17_11, var_17_17)
		end

		if var_17_10 > 1 then
			var_17_3 = var_17_13 + var_17_11 * 2
		end

		var_17_5 = Vector3.normalize(var_17_3 - arg_17_1)
	end

	local var_17_19

	return var_17_5 * arg_17_0.drag_speed, var_17_19
end

function PlayerCharacterStateGrabbedByTentacle.update(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	local var_18_0 = arg_18_0.csm
	local var_18_1 = arg_18_0.input_extension
	local var_18_2 = arg_18_0.status_extension
	local var_18_3 = arg_18_0.tentacle_unit

	if not var_18_2.grabbed_by_tentacle or not Unit.alive(var_18_3) then
		if CharacterStateHelper.is_waiting_for_assisted_respawn(var_18_2) then
			var_18_0:change_state("waiting_for_assisted_respawn")
		elseif CharacterStateHelper.is_knocked_down(var_18_2) then
			var_18_0:change_state("knocked_down")
		elseif CharacterStateHelper.is_dead(var_18_2) then
			var_18_0:change_state("dead")
		else
			var_18_0:change_state("standing")
		end

		return
	end

	local var_18_4 = CharacterStateHelper.grabbed_by_tentacle_status(var_18_2)
	local var_18_5 = arg_18_0.grabbed_by_tentacle_status
	local var_18_6 = PlayerCharacterStateGrabbedByTentacle.states

	if var_18_4 ~= var_18_5 then
		if var_18_6[var_18_5].leave then
			var_18_6[var_18_5].leave(arg_18_0, arg_18_1)
		end

		if var_18_6[var_18_4].enter then
			var_18_6[var_18_4].enter(arg_18_0, arg_18_1, arg_18_5)
		end

		arg_18_0.grabbed_by_tentacle_status = var_18_4
	end

	var_18_6[var_18_4].run(arg_18_0, arg_18_1, arg_18_5, arg_18_3)

	local var_18_7 = arg_18_0.player

	CharacterStateHelper.look(var_18_1, var_18_7.viewport_name, arg_18_0.first_person_extension, var_18_2, arg_18_0.inventory_extension)
end
