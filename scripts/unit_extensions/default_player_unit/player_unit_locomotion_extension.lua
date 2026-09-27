-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_locomotion_extension.lua

require("scripts/helpers/mover_helper")
require("scripts/unit_extensions/default_player_unit/third_person_idle_fullbody_animation_control")

PlayerUnitLocomotionExtension = class(PlayerUnitLocomotionExtension)

local POSITION_LOOKUP = POSITION_LOOKUP
local num = 99.9999
local num_2 = 0.15

PlayerUnitLocomotionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.is_server = Managers.player.is_server
	self.player = arg_1_3.player

	local profile_index = self.player:profile_index()

	self._default_mover_filter = SPProfiles[profile_index].mover_profile or "filter_player_mover"
	self._pactsworn_no_clip = self._default_mover_filter == "filter_player_mover_pactsworn"
	self._no_clip_filter = {}
	self.velocity_network = Vector3Box()
	self.velocity_current = Vector3Box()
	self.animation_translation_scale = Vector3Box(1, 1, 1)
	self.external_velocity = nil
	self._external_velocity_enabled = true
	self._script_driven_gravity_scale = 1
	self._velocity_forced = Vector3Box()
	self._dirty_forced_velocity = false
	self.use_drag = true

	self:reset()

	self.anim_move_speed = 0
	self.move_speed_anim_var = Unit.animation_find_variable(arg_1_2, "move_speed")
	self.collides_down = true
	self.on_ground = true
	self.time_since_last_down_collide = 0
	self.rotate_along_direction = true
	self.debugging_animations = false
	self.ignore_gravity = false

	self:_initialize_sample_velocities()

	self.mover_state = MoverHelper.create_mover_state()

	MoverHelper.set_active_mover(arg_1_2, self.mover_state, "standing")

	self.world = arg_1_1.world
	self.is_bot = arg_1_3.player.bot_player

	local local_rotation = Unit.local_rotation(arg_1_2, 0)

	self.target_rotation = QuaternionBox(local_rotation)

	self:move_to_non_intersecting_position()

	local world_position = Unit.world_position(arg_1_2, 0)

	self.has_moved_from_start_position = false
	self._start_position = Vector3Box(world_position)

	if not self.is_server then
		local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()

		AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table, nil, 1)

		self._latest_position_on_navmesh = Vector3Box(world_position)
		self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
		self._nav_traverse_logic = GwNavTraverseLogic.create(self._nav_world, create_tag_cost_table)
		self._nav_cost_map_cost_table = create_tag_cost_table
	end

	self._system_data = arg_1_3.system_data
	self._system_data.all_update_units[arg_1_2] = self
	self._mover_modes = {
		ladder = false,
		enemy_noclip = false,
		dark_pact_noclip = false,
		enemy_leap_state = false
	}
	self._climb_entrance = nil
	self._climb_exit = nil
	self.wanted_position = Vector3Box()
	self.third_person_idle_fullbody_animation_control = ThirdPersonIdleFullbodyAnimationControl:new(arg_1_2)
end

PlayerUnitLocomotionExtension.set_mover_filter_property = function (self, arg_2_1, arg_2_2)
	-- function 2
	local _mover_modes = self._mover_modes

	fassert(arg_2_2 ~= nil, "Trying to set mover filter property nil")
	fassert(_mover_modes[arg_2_1] ~= nil, "Trying to set unitialized mover filter property %q.", arg_2_2)

	_mover_modes[arg_2_1] = arg_2_2

	local var_2_1
	local flag

	flag = not _mover_modes.ladder and "filter_player_ladder_mover" and not _mover_modes.enemy_noclip or "filter_player_enemy_noclip_mover" and (not _mover_modes.dark_pact_noclip and "filter_player_mover_pactsworn_ghost_mode" and not _mover_modes.enemy_leap_state or "filter_player_enemy_leap_state_noclip_mover" and self._default_mover_filter)

	local mover = Unit.mover(self.unit)

	Mover.set_collision_filter(mover, flag)
end

local num_3 = 1

PlayerUnitLocomotionExtension.move_to_non_intersecting_position = function (self)
	-- function 3
	local unit = self.unit
	local mover = Unit.mover(unit)
	local separate, var_3_3, var_3_4, var_3_5 = Mover.separate(mover, num_3)

	if not separate and not var_3_5 then
		Mover.set_position(mover, var_3_5)
		Unit.set_local_position(unit, 0, var_3_5)
	end
end

PlayerUnitLocomotionExtension.destroy = function (self)
	-- function 4
	if not self.is_server then
		GwNavCostMap.destroy_tag_cost_table(self._nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(self._nav_traverse_logic)
	end

	local unit = self.unit
	local _system_data = self._system_data

	_system_data.all_disabled_units[unit] = nil
	_system_data.all_update_units[unit] = nil
end

PlayerUnitLocomotionExtension.set_on_moving_platform = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0

	if not arg_5_1 then
		self._platform_extension = ScriptUnit.extension(arg_5_1, "transportation_system")
		self._platform_unit = arg_5_1
		self._soft_platform = arg_5_2
		var_5_0 = Managers.state.network:level_object_id(arg_5_1)
	else
		self._platform_extension = nil
		self._platform_unit = nil
		self._soft_platform = nil
		var_5_0 = 0
	end

	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(self.unit)

	GameSession.set_game_object_field(game, go_id, "moving_platform", var_5_0)
	GameSession.set_game_object_field(game, go_id, "moving_platform_soft_linked", arg_5_2 or false)
	self:sync_network_position(game, go_id)
end

PlayerUnitLocomotionExtension.get_moving_platform = function (self)
	-- function 6
	return self._platform_unit, self._platform_extension, self._soft_platform
end

PlayerUnitLocomotionExtension.hot_join_sync = function (self, arg_7_1)
	-- function 7
	local unit = self.unit
	local unit_game_object_id = Managers.state.network:unit_game_object_id(unit)
	local var_7_2 = PEER_ID_TO_CHANNEL[arg_7_1]

	RPC.rpc_sync_anim_state_3(var_7_2, unit_game_object_id, Unit.animation_get_state(unit))
end

PlayerUnitLocomotionExtension._initialize_sample_velocities = function (self)
	-- function 8
	self._sample_velocity_index = 0
	self._sample_velocity_time = Managers.time:time("game")
	self._average_velocity = Vector3Box(0, 0, 0)
	self._small_sample_size_average_velocity = Vector3Box(0, 0, 0)
	self._sample_velocities = {
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0)
	}
end

PlayerUnitLocomotionExtension._stop = function (self, arg_9_1)
	-- function 9
	local zero = Vector3.zero()

	self.velocity_current:store(zero)
	self.velocity_network:store(zero)

	if not arg_9_1 then
		local _sample_velocities = self._sample_velocities

		for i = 1, #_sample_velocities do
			_sample_velocities[i]:store(zero)
		end
	end
end

PlayerUnitLocomotionExtension.average_velocity = function (self)
	-- function 10
	return self._average_velocity:unbox()
end

PlayerUnitLocomotionExtension.small_sample_size_average_velocity = function (self)
	-- function 11
	return self._small_sample_size_average_velocity:unbox()
end

PlayerUnitLocomotionExtension.extensions_ready = function (self, arg_12_1, arg_12_2)
	-- function 12
	self.first_person_extension = ScriptUnit.extension(self.unit, "first_person_system")
	self.status_extension = ScriptUnit.extension(self.unit, "status_system")

	self.third_person_idle_fullbody_animation_control:extensions_ready(arg_12_1, arg_12_2)
end

PlayerUnitLocomotionExtension.last_position_on_navmesh = function (self)
	-- function 13
	assert(self.is_server, "last position on nav mesh is only saved on server")

	return self._latest_position_on_navmesh:unbox()
end

PlayerUnitLocomotionExtension.reset = function (self)
	-- function 14
	self.state = "script_driven"
	self.velocity_wanted = Vector3Box(0, 0, 0)
	self.allow_jump = false

	self:reset_maximum_upwards_velocity()

	self.speed_multiplier = nil
	self.speed_multiplier_start_time = nil
	self.speed_multiplier_duration = nil
end

PlayerUnitLocomotionExtension.set_disabled = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	self.disabled = arg_15_1
	self.run_func = arg_15_2
	self.master_unit = arg_15_3

	local _system_data = self._system_data
	local unit = self.unit

	if not arg_15_1 then
		_system_data.all_update_units[unit] = nil
		_system_data.all_disabled_units[unit] = self

		self:_stop(true)
	else
		_system_data.all_update_units[unit] = self
		_system_data.all_disabled_units[unit] = nil

		local var_15_2 = POSITION_LOOKUP[unit]

		self._pos_lerp_time = 0

		Unit.set_data(unit, "last_lerp_position", var_15_2)
		Unit.set_data(unit, "last_lerp_position_offset", Vector3(0, 0, 0))
		Unit.set_data(unit, "accumulated_movement", Vector3(0, 0, 0))

		if not arg_15_4 then
			self:set_wanted_velocity(Vector3.zero())
			self:move_to_non_intersecting_position()
		end
	end
end

PlayerUnitLocomotionExtension.set_mover_disable_reason = function (self, arg_16_1, arg_16_2)
	-- function 16
	MoverHelper.set_disable_reason(self.unit, self.mover_state, arg_16_1, arg_16_2)
end

PlayerUnitLocomotionExtension.set_active_mover = function (self, arg_17_1)
	-- function 17
	MoverHelper.set_active_mover(self.unit, self.mover_state, arg_17_1)
end

PlayerUnitLocomotionExtension.post_update = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	local length

	if not self.on_ground then
		length = Vector3.length(self.velocity_current:unbox())

		if not length then
			-- Nothing
		end
	end

	length = 0

	::label_18_0::

	local anim_move_speed = self.anim_move_speed
	local abs = math.abs(anim_move_speed - length)

	if anim_move_speed < length then
		local min = math.min(length / num_2 * arg_18_3, abs)

		anim_move_speed = math.clamp(anim_move_speed + min, 0, length)
		self._move_speed_top = anim_move_speed
	else
		local _move_speed_top = self._move_speed_top

		_move_speed_top = _move_speed_top or length

		local min_2 = math.min(_move_speed_top / num_2 * arg_18_3, abs)

		anim_move_speed = math.clamp(anim_move_speed - min_2, 0, anim_move_speed)
	end

	self.anim_move_speed = anim_move_speed

	self.first_person_extension:animation_set_variable("move_speed", math.min(anim_move_speed, num), true)
	self.third_person_idle_fullbody_animation_control:update(arg_18_5)

	if not script_data.debug_player_skeletons then
		local bones = Unit.bones(arg_18_1)

		for i, v in ipairs(bones) do
			if not Unit.has_node(arg_18_1, v) then
				local node = Unit.node(arg_18_1, v)
				local scene_graph_parent = Unit.scene_graph_parent(arg_18_1, node)

				if not scene_graph_parent then
					local world_position = Unit.world_position(arg_18_1, scene_graph_parent)
					local world_position_2 = Unit.world_position(arg_18_1, node)
					local num_3 = Vector3.distance(world_position, world_position_2) / 10

					if num_3 > 0.1 then
						num_3 = 0.1
					end

					local var_18_12 = Color(100, 100, 255)

					if v == self.draw_node then
						var_18_12 = Color(255, 255, 0)
					end

					QuickDrawer:cone(world_position, world_position_2, num_3, var_18_12, 20, 5)
				end
			end
		end
	end
end

PlayerUnitLocomotionExtension.moving_on_slope = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	if not self.is_bot then
		self.allow_jump = true

		return false
	end

	local max_angle = PlayerUnitMovementSettings.slope_traversion.max_angle

	Mover.set_max_slope_angle(arg_19_3, max_angle)

	local actor_colliding_down = Mover.actor_colliding_down(arg_19_3)
	local flag = true

	if not actor_colliding_down then
		local unit = Actor.unit(actor_colliding_down)

		if not (not Unit.alive(unit) and Unit.get_data(unit, "slippery")) then
			flag = false
		end
	end

	local flag_2 = Mover.standing_frames(arg_19_3) == 0 or flag
	local on_ground

	if not arg_19_1 then
		if not self.allow_jump then
			on_ground = self.on_ground

			if not on_ground then
				-- Nothing
			end
		end

		if Mover.flying_frames(arg_19_3) == 0 then
			on_ground = not flag
		else
			on_ground = false
		end
	else
		on_ground = true
	end

	::label_19_0::

	self.allow_jump = on_ground

	return not flag_2 and arg_19_1
end

local tbl = {}

PlayerUnitLocomotionExtension.update_script_driven_movement = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	if not self._script_movement_time_scale then
		arg_20_2 = arg_20_2 * self._script_movement_time_scale
		self._script_movement_time_scale = nil
	end

	local external_velocity = self.external_velocity

	external_velocity = not external_velocity and self.external_velocity:unbox()

	local unbox = self.velocity_current:unbox()
	local Vector3 = Vector3
	local num = 0
	local num_2 = 0
	local z

	if not external_velocity then
		z = external_velocity.z

		if not z then
			-- Nothing
		end
	end

	z = 0

	::label_20_0::

	local num_3 = unbox + Vector3(num, num_2, z)
	local unbox_2 = self.velocity_wanted:unbox()
	local mover = Unit.mover(arg_20_1)

	if not arg_20_4 then
		unbox_2.z = num_3.z
	end

	if not self._dirty_forced_velocity then
		unbox_2 = self._velocity_forced:unbox()

		self._velocity_forced:store(Vector3.zero())

		self._dirty_forced_velocity = false
	end

	local var_20_9
	local var_20_10

	if not external_velocity then
		local flat = Vector3.flat(external_velocity)

		var_20_9 = Vector3.normalize(flat)

		local length = Vector3.length(flat)
		local dot = Vector3.dot(var_20_9, unbox_2)

		if length < dot then
			-- Nothing
		elseif dot > 0 then
			unbox_2 = unbox_2 - var_20_9 * dot + flat
		else
			flat = flat + var_20_9 * dot * arg_20_2
			unbox_2 = unbox_2 - var_20_9 * dot + flat
		end

		if not self.on_ground then
			local num_4 = 15

			var_20_10 = flat + math.min(num_4 * arg_20_2, length) * -var_20_9
		else
			var_20_10 = flat * (1 - math.min(arg_20_2 * 0.00225 * length * length, 1))
		end

		if Vector3.length(var_20_10) < 0.01 then
			self.external_velocity = nil
		else
			self.external_velocity:store(var_20_10)
		end
	end

	local flag

	flag = not self.use_drag and 0.00255 and 1

	local length_2 = Vector3.length(unbox_2)
	local num_5 = unbox_2 + flag * length_2 * length_2 * Vector3.normalize(-unbox_2) * arg_20_2

	if not arg_20_4 then
		local num_6 = num_5.z - PlayerUnitMovementSettings.get_movement_settings_table(arg_20_1).gravity_acceleration * self._script_driven_gravity_scale * arg_20_2

		num_5.z = math.min(self.maximum_upward_velocity, num_6)
	end

	local length_3 = Vector3.length(num_5)
	local local_position = Unit.local_position(arg_20_1, 0)
	local flat_2 = Vector3.flat(num_5)
	local length_4 = Vector3.length(flat_2)

	if length_4 > 0.001 then
		flat_2 = flat_2 / length_4

		local flat_3 = Vector3.flat(local_position)
		local var_20_24
		local num_7 = -1
		local num_8 = 1
		local num_9 = 1
		local num_10 = local_position + flat_2 * 0.5
		local flag_2 = self._mover_modes.enemy_noclip == true
		local flag_3 = not not self._pactsworn_no_clip or not flag_2
		local _no_clip_filter = self._no_clip_filter

		if not flag_3 then
			local broadphase_query = AiUtils.broadphase_query(num_10, num_9, tbl)

			for i = 1, broadphase_query do
				local var_20_33 = tbl[i]
				local _breed = ScriptUnit.extension(var_20_33, "ai_system")._breed
				local var_20_35 = HEALTH_ALIVE[var_20_33]
				local extension = ScriptUnit.extension(var_20_33, "ai_system")

				if not (not var_20_35 and extension.player_locomotion_constrain_radius == nil or _no_clip_filter[_breed.armor_category]) then
					local player_locomotion_constrain_radius = extension.player_locomotion_constrain_radius
					local num_11 = player_locomotion_constrain_radius * player_locomotion_constrain_radius * 2 * 2
					local flat_4 = Vector3.flat(POSITION_LOOKUP[var_20_33])
					local num_12 = flat_3 + flat_2

					if num_11 > Vector3.distance_squared(flat_4, num_12) then
						var_20_24 = flat_4 + Vector3.normalize(num_12 - flat_4) * player_locomotion_constrain_radius * 2

						local dot_2 = Vector3.dot(flat_2, Vector3.normalize(var_20_24 - flat_3))

						num_7 = math.max(num_7, dot_2)
						num_8 = math.min(num_8, dot_2)
					end
				end
			end
		end

		if not (num_8 < num_7 or not (num_8 <= 0)) then
			num_5.z, num_5 = num_5.z, Vector3.zero()
		elseif not var_20_24 then
			local z_2 = num_5.z

			num_5 = var_20_24 - flat_3

			if Vector3.length(num_5) > 0.001 then
				num_5 = Vector3.normalize(num_5) * length_3 * num_8
			end

			num_5.z = z_2
		end
	else
		local flat_5 = Vector3.flat(local_position)
		local num_13 = 1
		local num_14 = local_position + flat_2 * 0.5
		local flag_4 = self._mover_modes.enemy_noclip == true

		if not (not not self._pactsworn_no_clip or not flag_4) then
			local broadphase_query_2 = AiUtils.broadphase_query(num_14, num_13, tbl)

			for j = 1, broadphase_query_2 do
				local var_20_48 = tbl[j]
				local var_20_49 = HEALTH_ALIVE[var_20_48]
				local extension_2 = ScriptUnit.extension(var_20_48, "ai_system")

				if not (not var_20_49 and extension_2.player_locomotion_constrain_radius == nil) then
					local player_locomotion_constrain_radius_2 = extension_2.player_locomotion_constrain_radius
					local flat_6 = Vector3.flat(POSITION_LOOKUP[var_20_48])
					local num_15 = player_locomotion_constrain_radius_2 * player_locomotion_constrain_radius_2
					local distance_squared = Vector3.distance_squared(flat_6, flat_5)

					if distance_squared < num_15 then
						local num_16 = 2 * (1 - distance_squared / num_15)

						num_5 = num_5 + Vector3.normalize(flat_5 - flat_6) * num_16
					end
				end
			end
		end
	end

	local num_17 = num_5 * arg_20_2

	Mover.move(mover, num_17, arg_20_2)

	local position = Mover.position(mover)
	local num_18 = (position - local_position) / arg_20_2
	local copy = Vector3.copy(num_18)

	if not (not self._platform_extension and not (Mover.flying_frames(mover) <= 1)) then
		copy[3] = 0
	end

	self.velocity_network:store(copy)
	Unit.set_local_position(arg_20_1, 0, position)

	if not self:moving_on_slope(arg_20_4, arg_20_1, mover, position) then
		num_18.z = num_5.z
	end

	if not self.external_velocity then
		local dot_3 = Vector3.dot(num_18, var_20_9)

		if dot_3 < Vector3.length(var_20_10) then
			self.external_velocity:store(dot_3 * var_20_9)
		end
	end

	self.velocity_current:store(num_18)
end

PlayerUnitLocomotionExtension.update_animation_driven_movement = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_21_1)
	local translation = Matrix4x4.translation(animation_wanted_root_pose)
	local var_21_2 = POSITION_LOOKUP[arg_21_1]
	local num = translation - var_21_2
	local multiply_elements = Vector3.multiply_elements(num, self.animation_translation_scale:unbox())
	local var_21_5
	local unbox = self.velocity_current:unbox()
	local var_21_7 = Vector3(0, 0, unbox.z)

	if not self.ignore_gravity then
		var_21_5 = multiply_elements
	else
		var_21_7.z = var_21_7.z - 9.82 * arg_21_2
		var_21_5 = var_21_7 * arg_21_2 + multiply_elements
	end

	local mover = Unit.mover(arg_21_1)

	Mover.move(mover, var_21_5, arg_21_2)

	local position = Mover.position(mover)

	Unit.set_local_position(arg_21_1, 0, position)

	local num_2 = (Vector3(translation.x, translation.y, position.z) - var_21_2) / arg_21_2

	if self.ignore_gravity or not self:moving_on_slope(true, arg_21_1, mover, position) then
		num_2.z = var_21_7.z
	end

	num_2.z = math.min(0, num_2.z)

	self.velocity_network:store(num_2)
	self.velocity_current:store(num_2)
end

PlayerUnitLocomotionExtension.set_animation_translation_scale = function (self, arg_22_1)
	-- function 22
	self.animation_translation_scale:store(arg_22_1)
end

PlayerUnitLocomotionExtension.get_animation_translation_scale = function (self)
	-- function 23
	return self.animation_translation_scale:unbox()
end

PlayerUnitLocomotionExtension.update_animation_driven_movement_no_mover = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_24_1)
	local translation = Matrix4x4.translation(animation_wanted_root_pose)
	local var_24_2 = POSITION_LOOKUP[arg_24_1]
	local num = translation - var_24_2
	local multiply_elements = Vector3.multiply_elements(num, self.animation_translation_scale:unbox())
	local num_2 = multiply_elements / arg_24_2

	Unit.set_local_position(arg_24_1, 0, var_24_2 + multiply_elements)
	self.velocity_network:store(num_2)
	self.velocity_current:store(num_2)
end

PlayerUnitLocomotionExtension.update_animation_driven_movement_with_rotation_no_mover = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	self:update_animation_driven_movement_no_mover(arg_25_1, arg_25_2, arg_25_3)

	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_25_1)
	local rotation = Matrix4x4.rotation(animation_wanted_root_pose)

	Unit.set_local_rotation(arg_25_1, 0, rotation)
end

PlayerUnitLocomotionExtension.update_animation_driven_movement_entrance_and_exit_no_mover = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	self:update_animation_driven_movement_no_mover(arg_26_1, arg_26_2, arg_26_3)

	local unbox = self._climb_exit:unbox()
	local unbox_2 = self._climb_entrance:unbox()
	local normalize = Vector3.normalize(Vector3.flat(unbox - unbox_2))
	local look = Quaternion.look(normalize)

	Unit.set_local_rotation(arg_26_1, 0, look)
end

PlayerUnitLocomotionExtension.update_script_driven_ladder_transition_movement = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_27_1)
	local translation, var_27_2 = Matrix4x4.translation(animation_wanted_root_pose), POSITION_LOOKUP[arg_27_1]
	local mover = Unit.mover(arg_27_1)
	local num = translation - var_27_2

	Mover.move(mover, num, arg_27_2)

	local position = Mover.position(mover)
	local num_2 = translation - position

	Unit.set_local_position(arg_27_1, 0, position)

	local num_3 = (translation - var_27_2) / arg_27_2

	self.velocity_network:store(num_3)
	self.velocity_current:store(num_3)
	self.old_error:store(num_2)
end

PlayerUnitLocomotionExtension.update_linked_movement = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local link_data = self.link_data
	local unit = link_data.unit
	local node = link_data.node
	local unbox = link_data.offset:unbox()
	local num = Unit.world_position(unit, node) + unbox

	Unit.set_local_position(arg_28_1, 0, num)

	local zero = Vector3.zero()

	self.velocity_network:store(zero)
	self.velocity_current:store(zero)
end

PlayerUnitLocomotionExtension.update_script_driven_no_mover_movement = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local unbox = self.velocity_wanted:unbox()
	local num = POSITION_LOOKUP[arg_29_1] + unbox * arg_29_2

	Unit.set_local_position(arg_29_1, 0, num)
	self.velocity_network:store(unbox)
	self.velocity_current:store(unbox)
end

PlayerUnitLocomotionExtension.update_wanted_position_movement = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	local var_30_0 = POSITION_LOOKUP[arg_30_1]
	local num = self.wanted_position:unbox() - var_30_0
	local unbox = self.velocity_current:unbox()
	local var_30_3 = Vector3(0, 0, unbox.z)

	var_30_3.z = var_30_3.z - 9.82 * arg_30_2

	local num_2 = num + var_30_3
	local mover = Unit.mover(arg_30_1)

	Mover.move(mover, num_2, arg_30_2)

	local position = Mover.position(mover)

	Unit.set_local_position(arg_30_1, 0, position)
end

PlayerUnitLocomotionExtension.set_disable_rotation_update = function (self)
	-- function 31
	self.disable_rotation_update = true
end

PlayerUnitLocomotionExtension.set_stood_still_target_rotation = function (self, arg_32_1)
	-- function 32
	self.target_rotation:store(arg_32_1)

	local flat = Vector3.flat(Quaternion.forward(arg_32_1))
	local look = Quaternion.look(flat)

	Unit.set_local_rotation(self.unit, 0, look)
end

PlayerUnitLocomotionExtension.is_stood_still = function (self)
	-- function 33
	local current_rotation = self.first_person_extension:current_rotation()
	local flat = Vector3.flat(Quaternion.forward(current_rotation))
	local unbox = self.velocity_current:unbox()

	unbox.z = 0

	return Vector3.dot(unbox, flat) == 0
end

PlayerUnitLocomotionExtension.sync_network_rotation = function (self, arg_34_1, arg_34_2)
	-- function 34
	local local_rotation = Unit.local_rotation(self.unit, 0)
	local yaw = Quaternion.yaw(local_rotation)
	local pitch = Quaternion.pitch(local_rotation)

	GameSession.set_game_object_field(arg_34_1, arg_34_2, "yaw", yaw)
	GameSession.set_game_object_field(arg_34_1, arg_34_2, "pitch", pitch)
end

PlayerUnitLocomotionExtension.sync_network_position = function (self, arg_35_1, arg_35_2)
	-- function 35
	local local_position = Unit.local_position(self.unit, 0)

	if not self._platform_unit then
		local_position = local_position - Unit.local_position(self._platform_unit, 0)
	end

	local position = NetworkConstants.position
	local min = position.min
	local max = position.max

	GameSession.set_game_object_field(arg_35_1, arg_35_2, "position", Vector3.clamp(local_position, min, max))
end

PlayerUnitLocomotionExtension.sync_network_velocity = function (self, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	local unbox = self.velocity_network:unbox()
	local min = NetworkConstants.velocity.min
	local max = NetworkConstants.velocity.max

	GameSession.set_game_object_field(arg_36_1, arg_36_2, "velocity", Vector3.clamp(unbox, min, max))
	GameSession.set_game_object_field(arg_36_1, arg_36_2, "average_velocity", Vector3.clamp(self._average_velocity:unbox(), min, max))
end

PlayerUnitLocomotionExtension.set_wanted_velocity = function (self, arg_37_1)
	-- function 37
	if not (self.disabled or self.state == "script_driven" or self.state == "script_driven_ladder" or self.state == "script_driven_no_mover" or self.state ~= "script_driven_ladder_transition_movement") then
		self.velocity_wanted:store(arg_37_1)
	end
end

PlayerUnitLocomotionExtension.set_script_movement_time_scale = function (self, arg_38_1)
	-- function 38
	self._script_movement_time_scale = arg_38_1
end

PlayerUnitLocomotionExtension.set_script_driven_gravity_scale = function (self, arg_39_1)
	-- function 39
	self._script_driven_gravity_scale = arg_39_1
end

PlayerUnitLocomotionExtension.get_script_driven_gravity_scale = function (self, arg_40_1)
	-- function 40
	return self._script_driven_gravity_scale
end

PlayerUnitLocomotionExtension.add_external_velocity = function (self, arg_41_1, arg_41_2)
	-- function 41
	if not self._external_velocity_enabled then
		return
	end

	if not self.external_velocity then
		self.external_velocity = Vector3Box()
	end

	local unbox = self.external_velocity:unbox()
	local flag = arg_41_2 or 5
	local dot = Vector3.dot(unbox, Vector3.normalize(arg_41_1))
	local num = unbox + arg_41_1 * ((flag - math.clamp(dot, 0, flag)) / flag)

	self.external_velocity:store(num)
end

PlayerUnitLocomotionExtension.set_forced_velocity = function (self, arg_42_1)
	-- function 42
	if not (self.disabled or self.state == "script_driven" or self.state ~= "script_driven_ladder") then
		if not arg_42_1 then
			self._velocity_forced:store(self._velocity_forced:unbox() + arg_42_1)

			self._dirty_forced_velocity = true
		else
			self._velocity_forced:store(Vector3.zero())

			self._dirty_forced_velocity = false
		end
	end
end

PlayerUnitLocomotionExtension.set_external_velocity_enabled = function (self, arg_43_1)
	-- function 43
	self._external_velocity_enabled = arg_43_1

	if not (not self.external_velocity and arg_43_1) then
		self.external_velocity = nil
	end
end

PlayerUnitLocomotionExtension.set_maximum_upwards_velocity = function (self, arg_44_1)
	-- function 44
	self.maximum_upward_velocity = arg_44_1
end

PlayerUnitLocomotionExtension.reset_maximum_upwards_velocity = function (self)
	-- function 45
	self.maximum_upward_velocity = 0
end

PlayerUnitLocomotionExtension.set_speed_multiplier = function (self, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	self.speed_multiplier = arg_46_1
	self.speed_multiplier_start_time = arg_46_2
	self.speed_multiplier_duration = arg_46_3
end

PlayerUnitLocomotionExtension.current_speed_multiplier = function (self)
	-- function 47
	return self.speed_multiplier
end

PlayerUnitLocomotionExtension.jump_allowed = function (self)
	-- function 48
	return self.allow_jump
end

PlayerUnitLocomotionExtension.current_velocity = function (self)
	-- function 49
	local velocity_current = self.velocity_current

	velocity_current = not velocity_current and self.velocity_current:unbox()

	return velocity_current
end

PlayerUnitLocomotionExtension.current_rotation = function (self)
	-- function 50
	return self.first_person_extension:current_rotation()
end

PlayerUnitLocomotionExtension.current_relative_velocity = function (self)
	-- function 51
	local first_person_extension = self.first_person_extension
	local unbox = self.velocity_current:unbox()
	local current_rotation = first_person_extension:current_rotation()
	local inverse = Quaternion.inverse(current_rotation)

	return (Quaternion.rotate(inverse, unbox))
end

PlayerUnitLocomotionExtension.current_relative_velocity_3p = function (self)
	-- function 52
	local unit = self.unit
	local unbox = self.velocity_current:unbox()
	local local_rotation = Unit.local_rotation(unit, 0)
	local inverse = Quaternion.inverse(local_rotation)

	return (Quaternion.rotate(inverse, unbox))
end

PlayerUnitLocomotionExtension.enable_linked_movement = function (self, arg_53_1, arg_53_2, arg_53_3)
	-- function 53
	self.state = "linked_movement"
	self.link_data = {
		unit = arg_53_1,
		node = arg_53_2,
		offset = Vector3Box(arg_53_3)
	}

	local unit = self.unit
	local network = Managers.state.network
	local game = network:game()
	local go_id = Managers.state.unit_storage:go_id(unit)

	if not game and not go_id then
		local game_object_or_level_id, var_53_5 = network:game_object_or_level_id(arg_53_1)

		GameSession.set_game_object_field(game, go_id, "linked_movement", true)
		GameSession.set_game_object_field(game, go_id, "link_parent_id", game_object_or_level_id)
		GameSession.set_game_object_field(game, go_id, "link_parent_is_level_unit", var_53_5)
		GameSession.set_game_object_field(game, go_id, "link_node", arg_53_2)
		GameSession.set_game_object_field(game, go_id, "link_offset", arg_53_3)
	end
end

PlayerUnitLocomotionExtension.disable_linked_movement = function (self)
	-- function 54
	local unit = self.unit
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(unit)

	if not game and not go_id then
		GameSession.set_game_object_field(game, go_id, "linked_movement", false)
	end
end

PlayerUnitLocomotionExtension.enable_animation_driven_movement = function (self, arg_55_1)
	-- function 55
	self.ignore_gravity = arg_55_1
	self.state = "animation_driven"
end

PlayerUnitLocomotionExtension.enable_animation_driven_movement_entrance_and_exit_no_mover = function (self, arg_56_1, arg_56_2)
	-- function 56
	self._climb_entrance = Vector3Box(arg_56_1)
	self._climb_exit = Vector3Box(arg_56_2)
	self.state = "animation_driven_entrance_and_exit_no_mover"
end

PlayerUnitLocomotionExtension.enable_animation_driven_movement_with_rotation_no_mover = function (self)
	-- function 57
	self.state = "animation_driven_with_rotation_no_mover"
end

PlayerUnitLocomotionExtension.enable_script_driven_movement = function (self)
	-- function 58
	self._dirty_forced_velocity = false
	self._script_movement_time_scale = nil
	self.state = "script_driven"
end

PlayerUnitLocomotionExtension.enable_script_driven_ladder_movement = function (self)
	-- function 59
	self._dirty_forced_velocity = false
	self._script_movement_time_scale = nil
	self.state = "script_driven_ladder"

	self:set_wanted_velocity(Vector3.zero())
end

PlayerUnitLocomotionExtension.enable_script_driven_ladder_transition_movement = function (self)
	-- function 60
	self.state = "script_driven_ladder_transition_movement"
	self.old_error = Vector3Box(0, 0, 0)
end

PlayerUnitLocomotionExtension.enable_script_driven_no_mover_movement = function (self)
	-- function 61
	self.state = "script_driven_no_mover"
end

PlayerUnitLocomotionExtension.enable_wanted_position_movement = function (self, arg_62_1, arg_62_2)
	-- function 62
	self:_stop(false)

	self.state = "wanted_position_mover"
end

PlayerUnitLocomotionExtension.is_animation_driven = function (self)
	-- function 63
	return self.state == "animation_driven"
end

PlayerUnitLocomotionExtension.is_linked_movement = function (self)
	-- function 64
	return self.state == "linked_movement"
end

PlayerUnitLocomotionExtension.is_script_driven_ladder = function (self)
	-- function 65
	return self.state == "script_driven_ladder"
end

PlayerUnitLocomotionExtension.is_script_driven_ladder_transition = function (self)
	-- function 66
	return self.state == "script_driven_ladder_transition_movement"
end

PlayerUnitLocomotionExtension.get_link_data = function (self)
	-- function 67
	return self.link_data
end

PlayerUnitLocomotionExtension.is_colliding_down = function (self)
	-- function 68
	return self.collides_down
end

PlayerUnitLocomotionExtension.force_on_ground = function (self, arg_69_1)
	-- function 69
	self.on_ground = arg_69_1
end

PlayerUnitLocomotionExtension.is_on_ground = function (self)
	-- function 70
	return self.on_ground
end

PlayerUnitLocomotionExtension.set_wanted_pos = function (self, arg_71_1)
	-- function 71
	self.wanted_position:store(arg_71_1)
end

PlayerUnitLocomotionExtension.teleport_to = function (self, arg_72_1, arg_72_2)
	-- function 72
	local unit = self.unit
	local mover = Unit.mover(unit)

	Mover.set_position(mover, arg_72_1)
	Unit.set_local_position(unit, 0, arg_72_1)

	if arg_72_2 ~= nil then
		self.first_person_extension:set_rotation(arg_72_2)
	end

	if not (not IS_WINDOWS and self.player.bot_player) then
		Application.reset_dlss()
	end

	self:move_to_non_intersecting_position()
	self.status_extension:set_ignore_next_fall_damage(true)
	self.status_extension:set_falling_height()
end

PlayerUnitLocomotionExtension.enable_rotation_towards_velocity = function (self, arg_73_1, arg_73_2, arg_73_3)
	-- function 73
	self.rotate_along_direction = arg_73_1

	if not arg_73_1 then
		self.target_rotation_data = nil
	elseif not arg_73_2 then
		assert(arg_73_3, "Tried to set target rotation without setting duration")

		local time = Managers.time:time("game")

		self.target_rotation_data = {
			target_rotation = QuaternionBox(arg_73_2),
			start_rotation = QuaternionBox(Unit.local_rotation(self.unit, 0)),
			start_time = time,
			end_time = time + arg_73_3
		}
	end
end

PlayerUnitLocomotionExtension.enable_drag = function (self, arg_74_1)
	-- function 74
	self.use_drag = arg_74_1
end

local num_4 = 6

PlayerUnitLocomotionExtension.apply_no_clip_filter = function (self, arg_75_1, arg_75_2)
	-- function 75
	for i = 1, num_4 do
		if not arg_75_1[i] then
			if not self._no_clip_filter[i] then
				self._no_clip_filter[i] = {
					[arg_75_2] = true
				}
			else
				self._no_clip_filter[i][arg_75_2] = true
			end
		end
	end
end

PlayerUnitLocomotionExtension.remove_no_clip_filter = function (self, arg_76_1)
	-- function 76
	local _no_clip_filter = self._no_clip_filter

	for i = 1, num_4 do
		local var_76_1 = _no_clip_filter[i]

		if not var_76_1 then
			var_76_1[arg_76_1] = nil

			if not table.is_empty(var_76_1) then
				_no_clip_filter[i] = nil
			end
		end
	end
end
