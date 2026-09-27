-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_champion_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChampionAttackAction = class(BTChampionAttackAction, BTNode)

BTChampionAttackAction.init = function (arg_1_0, ...)
	-- function 1
	BTChampionAttackAction.super.init(arg_1_0, ...)
end

BTChampionAttackAction.name = "BTChampionAttackAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTChampionAttackAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTChampionAttackAction
	arg_3_2.attack_range = action_data.range
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false

	local hit_players = arg_3_2.hit_players

	hit_players = hit_players or {}
	arg_3_2.hit_players = hit_players
	arg_3_2.target_dodged = false

	local target_unit = arg_3_2.target_unit
	local extension

	if not ScriptUnit.has_extension(target_unit, "status_system") then
		extension = ScriptUnit.extension(target_unit, "status_system")

		if not extension then
			-- Nothing
		end
	end

	extension = nil

	::label_3_0::

	arg_3_2.target_unit_status_extension = extension

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_3_2.attacking_target = arg_3_2.target_unit

	self:_init_attack(arg_3_1, arg_3_2, action_data, arg_3_3)

	arg_3_2.spawn_to_running = nil

	AiUtils.stormvermin_champion_hack_check_ward(arg_3_1, arg_3_2)
end

local function fn_2()
	-- function 4
	return false
end

local tbl = {}
local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {
	mode = "retained",
	name = "BTChampionAttackAction"
}

BTChampionAttackAction._init_attack = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	arg_5_2.move_state = "attacking"

	local world = arg_5_2.world
	local var_5_1
	local var_5_2
	local attack_sequence = arg_5_3.attack_sequence

	if not attack_sequence then
		var_5_1, var_5_2 = self:_next_in_sequence(arg_5_2, arg_5_4, attack_sequence, 1)
	else
		arg_5_2.attack_next_sequence_ready = fn_2
		var_5_1 = arg_5_3.attack_anim
		var_5_2 = arg_5_3.animation_drive_scale
	end

	if not arg_5_3.animation_driven and not var_5_2 then
		LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(var_5_2, var_5_2, var_5_2))
	end

	if not var_5_1 then
		Managers.state.network:anim_event(arg_5_1, fn(var_5_1))
	else
		self:anim_cb_damage(arg_5_1, arg_5_2)

		arg_5_2.attack_finished = true
	end

	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.attacking_target)

	arg_5_2.attack_rotation = QuaternionBox(rotation_towards_unit_flat)
	arg_5_2.attack_rotation_update_timer = arg_5_4 + arg_5_3.rotation_time

	if arg_5_3.mode == "continuous_overlap" then
		arg_5_2.last_attack_overlap_position = Vector3Box(POSITION_LOOKUP[arg_5_1])
		arg_5_2.last_attack_overlap_position_time = arg_5_4
		arg_5_2.overlap_start_time = arg_5_4 + arg_5_3.overlap_start_time
		arg_5_2.overlap_end_time = arg_5_4 + arg_5_3.overlap_end_time

		local overlap_check_walls_time = arg_5_3.overlap_check_walls_time

		overlap_check_walls_time = overlap_check_walls_time or math.huge
		arg_5_2.overlap_walls_check_time = arg_5_4 + overlap_check_walls_time
	elseif arg_5_3.mode == "radial_cylinder" then
		arg_5_2.overlap_start_time = arg_5_4 + arg_5_3.overlap_start_time
		arg_5_2.overlap_end_time = arg_5_4 + arg_5_3.overlap_end_time
		arg_5_2.overlap_angle_speed = (arg_5_3.overlap_end_angle_offset - arg_5_3.overlap_start_angle_offset) / (arg_5_3.overlap_end_time - arg_5_3.overlap_start_time)

		local forward = Quaternion.forward(arg_5_2.attack_rotation:unbox())
		local atan2 = math.atan2(forward.y, forward.x)

		arg_5_2.overlap_start_angle = atan2 + arg_5_3.overlap_start_angle_offset
		arg_5_2.overlap_end_angle = atan2 + arg_5_3.overlap_end_angle_offset
		arg_5_2.overlap_last_angle = arg_5_2.overlap_start_angle
	elseif arg_5_3.mode == "nav_mesh_wave" then
		local num = 1
		local forward_2 = Quaternion.forward(rotation_towards_unit_flat)
		local var_5_10 = POSITION_LOOKUP[arg_5_1]
		local num_2 = var_5_10 + forward_2 * arg_5_3.offset_forward
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local num_3 = 2
		local num_4 = 2
		local num_5 = 0.4
		local triangle_from_position, var_5_17 = GwNavQueries.triangle_from_position(nav_world, var_5_10, num_3, num_4)

		table.clear(tbl)
		table.clear(tbl_2)
		table.clear(tbl_3)

		if not triangle_from_position then
			local parameter = Development.parameter("debug_ai_attack")
			local get_data = World.get_data(world, "physics_world")
			local wave_point_distance = arg_5_3.wave_point_distance
			local var_5_21 = Vector3(num_2.x, num_2.y, var_5_17)
			local tbl_5 = {
				Vector3Box(var_5_21)
			}

			tbl_2[num] = var_5_21

			while not (not triangle_from_position and not (num < arg_5_3.num_wave_points)) do
				local num_6 = var_5_21 + forward_2 * wave_point_distance
				local var_5_24

				triangle_from_position, var_5_24 = GwNavQueries.triangle_from_position(nav_world, num_6, num_3, num_4)

				if not triangle_from_position then
					num_6.z = var_5_24
					triangle_from_position = GwNavQueries.raycango(nav_world, var_5_21, num_6)

					if not triangle_from_position then
						local num_7 = var_5_21 + Vector3(0, 0, num_5)
						local num_8 = num_6 - var_5_21
						local length = Vector3.length(num_8)
						local num_9 = num_8 / length

						triangle_from_position = not PhysicsWorld.raycast(get_data, num_7, num_9, length, "closest", "collision_filter", "filter_ai_line_of_sight_check")
					end

					if not triangle_from_position then
						num = num + 1
						tbl_5[num] = Vector3Box(num_6)
						tbl_2[num] = num_6
						var_5_21 = num_6

						if not parameter then
							local drawer = Managers.state.debug:drawer(tbl_4)

							drawer:reset()
							drawer:sphere(num_6, 0.25, Color(255, 0, 0))
						end
					end
				end
			end

			arg_5_2.overlap_wave_points = tbl_5
		else
			arg_5_2.overlap_wave_points = {
				Vector3Box(num_2)
			}
			tbl_2[num] = num_2
		end

		local anticipation_fx = arg_5_3.anticipation_fx
		local var_5_31 = NetworkLookup.effects[anticipation_fx]

		for i = 1, num do
			local var_5_32 = tbl_2[i]

			tbl[i] = var_5_31

			World.create_particles(world, anticipation_fx, var_5_32)
		end

		Managers.state.network.network_transmit:send_rpc_clients("rpc_play_fx", tbl, tbl_3, tbl_2)

		local wave_speed = arg_5_3.wave_speed

		arg_5_2.overlap_start_time = arg_5_4 + arg_5_3.overlap_start_time
		arg_5_2.overlap_end_time = arg_5_2.overlap_start_time + num * wave_speed
		arg_5_2.last_overlap_index = 0
	end

	if not arg_5_3.animation_driven then
		LocomotionUtils.set_animation_driven_movement(arg_5_1, true, true, true)
	end

	local bot_threat_duration = arg_5_3.bot_threat_duration

	if not bot_threat_duration then
		if arg_5_3.collision_type == "cylinder" then
			local rotation_towards_unit_flat_2 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.attacking_target)
			local _calculate_cylinder_collision = self:_calculate_cylinder_collision(arg_5_3, POSITION_LOOKUP[arg_5_1], rotation_towards_unit_flat_2)
			local var_5_37 = Vector3(0, arg_5_3.radius, arg_5_3.height * 0.5)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(_calculate_cylinder_collision, "cylinder", var_5_37, nil, bot_threat_duration, "Champion Attack")
		elseif not (arg_5_3.collision_type == "oobb" or arg_5_3.collision_type) then
			local rotation_towards_unit_flat_3 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.attacking_target)
			local _calculate_oobb_collision, var_5_40, var_5_41 = self:_calculate_oobb_collision(arg_5_3, POSITION_LOOKUP[arg_5_1], rotation_towards_unit_flat_3)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(_calculate_oobb_collision, "oobb", var_5_41, var_5_40, bot_threat_duration, "Champion Attack")
		end
	end
end

BTChampionAttackAction._attack_threat_over = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local attacking_target = arg_6_2.attacking_target
	local alive = Unit.alive(attacking_target)
	local var_6_2 = arg_6_2.hit_players[attacking_target]

	if (not alive and var_6_2 or not arg_6_3.throw_dialogue_system_event_on_dodged_attack) and arg_6_2.target_dodged and not arg_6_3.throw_dialogue_system_event_on_missed_attack then
		local player_profile = ScriptUnit.extension(attacking_target, "dialogue_system").context.player_profile

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_6_1, "enemy_attack", DialogueSettings.enemy_attack_distance, "attack_tag", arg_6_3.name, "target_name", player_profile, "attack_hit", false)
	end
end

BTChampionAttackAction.leave = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local action = arg_7_2.action
	local catapulted_players = arg_7_2.catapulted_players

	if not catapulted_players then
		arg_7_2.catapulted_players = nil

		if arg_7_5 or not catapulted_players[1] then
			self:_catapult_players(arg_7_1, arg_7_2, action, catapulted_players)
		end
	end

	if arg_7_5 or not action.animation_driven then
		LocomotionUtils.set_animation_driven_movement(arg_7_1, false)
		LocomotionUtils.set_animation_translation_scale(arg_7_1, Vector3(1, 1, 1))
	end

	if not (not arg_7_2.attacking_target and arg_7_5) then
		self:_attack_threat_over(arg_7_1, arg_7_2, action)
	end

	local attacking_target = arg_7_2.attacking_target
	local alive = Unit.alive(attacking_target)
	local var_7_4 = arg_7_2.hit_players[attacking_target]
	local increment_stat_on_attack_dodged = action.increment_stat_on_attack_dodged

	if not increment_stat_on_attack_dodged and (arg_7_5 or not alive or var_7_4 or not arg_7_2.target_dodged) then
		local owner = Managers.player:owner(attacking_target)

		if not owner and not owner.local_player then
			local stats_id = owner:stats_id()

			Managers.player:statistics_db():increment_stat(stats_id, increment_stat_on_attack_dodged)
		elseif not owner and not owner:is_player_controlled() then
			local var_7_8 = PEER_ID_TO_CHANNEL[owner:network_id()]

			RPC.rpc_increment_stat(var_7_8, NetworkLookup.statistics[increment_stat_on_attack_dodged])
		end
	end

	arg_7_2.navigation_extension:set_enabled(true)
	table.clear(arg_7_2.hit_players)

	arg_7_2.target_unit_status_extension = nil
	arg_7_2.active_node = nil
	arg_7_2.attack_aborted = nil
	arg_7_2.attack_rotation = nil
	arg_7_2.attack_rotation_update_timer = nil
	arg_7_2.attacking_target = nil
	arg_7_2.action = nil
	arg_7_2.target_dodged = nil
	arg_7_2.attack_next_sequence_step_at = nil
	arg_7_2.attack_next_sequence_index = nil

	if action.mode == "continuous_overlap" then
		arg_7_2.last_attack_overlap_position = nil
		arg_7_2.overlap_start_time = nil
		arg_7_2.overlap_end_time = nil
		arg_7_2.overlap_wall_collision_time = nil
		arg_7_2.overlap_walls_check_time = nil
	elseif action.mode == "radial_cylinder" then
		-- Nothing
	end

	local exit_flow_event = action.exit_flow_event

	if not exit_flow_event then
		Unit.flow_event(arg_7_1, exit_flow_event)
	end
end

BTChampionAttackAction.run = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local attacking_target = arg_8_2.attacking_target

	if not Unit.alive(attacking_target) and not arg_8_2.attack_aborted then
		return "done"
	end

	self:_update_rotation(arg_8_1, arg_8_3, arg_8_4, arg_8_2)

	local action = arg_8_2.action
	local catapulted_players = arg_8_2.catapulted_players

	if not catapulted_players and not catapulted_players[1] then
		self:_catapult_players(arg_8_1, arg_8_2, action, catapulted_players)
	end

	local overlap_wall_collision_time = arg_8_2.overlap_wall_collision_time

	if not overlap_wall_collision_time then
		if overlap_wall_collision_time < arg_8_3 then
			return "done"
		else
			return "running"
		end
	end

	if not arg_8_2.attack_next_sequence_ready(arg_8_1, arg_8_2, arg_8_3) then
		local _next_in_sequence, var_8_5 = self:_next_in_sequence(arg_8_2, arg_8_3, action.attack_sequence, arg_8_2.attack_next_sequence_index)

		Managers.state.network:anim_event(arg_8_1, fn(_next_in_sequence))

		if not action.animation_driven then
			LocomotionUtils.set_animation_translation_scale(arg_8_1, Vector3(var_8_5, var_8_5, var_8_5))
		end
	end

	if action.mode == "continuous_overlap" then
		self:_update_overlap(arg_8_1, arg_8_2, action, arg_8_4, arg_8_3)
	elseif action.mode == "radial_cylinder" then
		self:_update_radial_cylinder(arg_8_1, arg_8_2, action, arg_8_4, arg_8_3)
	elseif action.mode == "nav_mesh_wave" then
		self:_update_nav_mesh_wave(arg_8_1, arg_8_2, action, arg_8_4, arg_8_3)
	end

	if not arg_8_2.attack_finished then
		return "done"
	end

	return "running"
end

BTChampionAttackAction._next_in_sequence = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local var_9_0 = arg_9_3[arg_9_4]
	local attack_anim = var_9_0.attack_anim
	local animation_drive_scale = var_9_0.animation_drive_scale
	local num = arg_9_4 + 1
	local var_9_4 = arg_9_3[num]
	local var_9_5 = arg_9_2

	arg_9_1.attack_sequence_start_time = var_9_5

	if not var_9_4 then
		local at = var_9_4.at
		local fn

		if not at then
			function fn(arg_10_0, arg_10_1, arg_10_2)
				-- function 10
				return arg_10_2 - var_9_5 >= at
			end

			if not fn then
				-- Nothing
			end
		end

		fn = var_9_4.ready_function

		::label_9_0::

		arg_9_1.attack_next_sequence_ready = fn
		arg_9_1.attack_next_sequence_index = num
	else
		arg_9_1.attack_next_sequence_ready = fn_2
		arg_9_1.attack_next_sequence_index = nil
	end

	return attack_anim, animation_drive_scale or 1
end

BTChampionAttackAction._update_rotation = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local target_unit_status_extension = arg_11_4.target_unit_status_extension
	local target_dodged = arg_11_4.target_dodged

	if target_dodged or not target_unit_status_extension then
		-- Nothing
	end

	::label_11_0::

	target_dodged = target_unit_status_extension:get_is_dodging()
	target_dodged = target_dodged or target_unit_status_extension:is_invisible()

	::label_11_1::

	arg_11_4.target_dodged = target_dodged

	local var_11_2
	local var_11_3 = POSITION_LOOKUP[arg_11_1]
	local attacking_target = arg_11_4.attacking_target
	local var_11_5 = POSITION_LOOKUP[attacking_target]

	if not (not Unit.alive(attacking_target) and not (arg_11_2 < arg_11_4.attack_rotation_update_timer) and not not target_dodged and not (Vector3.distance_squared(var_11_3, var_11_5) > 0.09) or not arg_11_4.hit_players[attacking_target]) then
		var_11_2 = LocomotionUtils.rotation_towards_unit_flat(arg_11_1, arg_11_4.attacking_target)

		local num = var_11_5 - var_11_3

		num.z = 0

		local look = Quaternion.look(Vector3.normalize(num))

		arg_11_4.attack_rotation:store(look)
	else
		var_11_2 = arg_11_4.attack_rotation:unbox()
	end

	arg_11_4.locomotion_extension:set_wanted_rotation(var_11_2)
end

BTChampionAttackAction._update_overlap = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local overlap_start_time = arg_12_2.overlap_start_time
	local overlap_end_time = arg_12_2.overlap_end_time
	local last_attack_overlap_position_time = arg_12_2.last_attack_overlap_position_time
	local var_12_3 = POSITION_LOOKUP[arg_12_1]

	if not (not (overlap_start_time < arg_12_5) or not (last_attack_overlap_position_time < overlap_end_time)) then
		local unbox = arg_12_2.last_attack_overlap_position:unbox()
		local var_12_5
		local var_12_6

		if last_attack_overlap_position_time < overlap_start_time then
			local num = (overlap_start_time - last_attack_overlap_position_time) / (arg_12_5 - last_attack_overlap_position_time)

			var_12_5 = Vector3.lerp(unbox, var_12_3, num)
		else
			var_12_5 = unbox
		end

		if overlap_end_time < arg_12_5 then
			local num_2 = (overlap_end_time - last_attack_overlap_position_time) / (arg_12_5 - last_attack_overlap_position_time)

			var_12_6 = Vector3.lerp(unbox, var_12_3, num_2)
		else
			var_12_6 = var_12_3
		end

		local movement_controlled_rotation = arg_12_3.movement_controlled_rotation
		local num_3 = var_12_6 - var_12_5
		local length = Vector3.length(num_3)
		local normalize = Vector3.normalize(num_3)
		local var_12_13
		local var_12_14

		if not movement_controlled_rotation then
			var_12_13 = Quaternion.look(normalize, Vector3.up())
			var_12_14 = normalize
		else
			var_12_13 = Unit.local_rotation(arg_12_1, 0)
			var_12_14 = Quaternion.forward(var_12_13)
		end

		local up = Quaternion.up(var_12_13)
		local var_12_16
		local range = arg_12_3.range

		if type(range) == "function" then
			var_12_16 = range((arg_12_5 - overlap_start_time) / (overlap_end_time - overlap_start_time))
		else
			var_12_16 = range
		end

		local num_4 = var_12_16 + (not movement_controlled_rotation and length and Vector3.dot(num_3, var_12_14))
		local height = arg_12_3.height
		local width = arg_12_3.width
		local num_5 = num_4 * 0.5
		local num_6 = height * 0.5
		local num_7 = var_12_5 + var_12_14 * (arg_12_3.offset_forward + num_5) + up * (arg_12_3.offset_up + num_6)
		local var_12_24 = Vector3(width * 0.5, num_5, num_6)
		local get_data = World.get_data(arg_12_2.world, "physics_world")
		local immediate_overlap, var_12_27 = PhysicsWorld.immediate_overlap(get_data, "position", num_7, "rotation", var_12_13, "size", var_12_24, "shape", "oobb", "types", "dynamics", "collision_filter", "filter_player_hit_box_check")

		if not Development.parameter("debug_ai_attack") then
			local from_quaternion_position = Matrix4x4.from_quaternion_position(var_12_13, num_7)

			QuickDrawer:box(from_quaternion_position, var_12_24)
		end

		self:_deal_damage(arg_12_1, arg_12_2, arg_12_3, var_12_5, immediate_overlap, var_12_27, true)

		if arg_12_5 > arg_12_2.overlap_walls_check_time then
			local num_8 = 0.3
			local num_9 = 0.3
			local nav_world = arg_12_2.nav_world
			local triangle_from_position, var_12_33 = GwNavQueries.triangle_from_position(nav_world, var_12_5, num_8, num_9)
			local flag = false

			if not triangle_from_position then
				local num_10 = arg_12_3.overlap_check_walls_range + arg_12_4 * Vector3.length(arg_12_2.locomotion_extension:current_velocity())
				local num_11 = var_12_5 + var_12_14 * num_10
				local triangle_from_position_2, var_12_38 = GwNavQueries.triangle_from_position(nav_world, num_11, math.max(num_8, num_10), math.max(num_9, num_10))

				if not (not triangle_from_position_2 and GwNavQueries.raycango(nav_world, Vector3(var_12_5.x, var_12_5.y, var_12_33), Vector3(num_11.x, num_11.y, var_12_38))) then
					flag = true
				end
			else
				flag = true
			end

			if not flag then
				arg_12_2.overlap_wall_collision_time = arg_12_5 + arg_12_3.wall_collision_stun_time

				Managers.state.network:anim_event(arg_12_1, fn(arg_12_3.wall_collision_anim))
			end
		end
	elseif not (not arg_12_2.attacking_target and not (overlap_end_time < last_attack_overlap_position_time)) then
		self:_attack_threat_over(arg_12_1, arg_12_2, arg_12_3)
	end

	arg_12_2.last_attack_overlap_position:store(var_12_3)

	arg_12_2.last_attack_overlap_position_time = arg_12_5
end

local tbl_5 = {}

BTChampionAttackAction._update_nav_mesh_wave = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	local world = arg_13_2.world
	local overlap_start_time = arg_13_2.overlap_start_time
	local overlap_end_time = arg_13_2.overlap_end_time

	if not (overlap_end_time < arg_13_5) or not arg_13_2.attacking_target then
		self:_attack_threat_over(arg_13_1, arg_13_2, arg_13_3)

		return
	elseif not (arg_13_5 < overlap_start_time or not (overlap_end_time < arg_13_5)) then
		return
	end

	local wave_speed = arg_13_3.wave_speed
	local overlap_wave_points = arg_13_2.overlap_wave_points
	local num = arg_13_5 - overlap_start_time
	local min = math.min(math.floor(num * wave_speed + 1), #overlap_wave_points)
	local last_overlap_index = arg_13_2.last_overlap_index
	local min_2 = math.min(last_overlap_index + 1, min)
	local get_data = World.get_data(world, "physics_world")

	table.clear(tbl_5)

	local num_2 = 0
	local var_13_11
	local parameter = Development.parameter("debug_ai_attack")

	table.clear(tbl)
	table.clear(tbl_2)
	table.clear(tbl_3)

	local num_3 = 0
	local wave_sfx = arg_13_3.wave_sfx
	local wave_fx = arg_13_3.wave_fx
	local var_13_16 = NetworkLookup.effects[wave_fx]
	local var_13_17 = NetworkLookup.sound_events[wave_sfx]

	for i = min_2, min do
		local unbox = overlap_wave_points[i]:unbox()

		if i ~= last_overlap_index then
			WwiseUtils.trigger_position_event(world, wave_sfx, unbox)
			World.create_particles(world, wave_fx, unbox)

			num_3 = num_3 + 1
			tbl[num_3] = var_13_16
			tbl_3[num_3] = var_13_17
			tbl_2[num_3] = unbox
		end

		local var_13_19 = overlap_wave_points[i + 1]
		local flag

		flag = not var_13_19 and var_13_19:unbox() and unbox
		var_13_11 = overlap_wave_points[i - 1]
		var_13_11 = not var_13_11 and var_13_11:unbox() and POSITION_LOOKUP[arg_13_1]

		local look = Quaternion.look(flag - var_13_11, Vector3.up())
		local max = math.max(Vector3.length(flag - unbox), Vector3.length(var_13_11 - unbox))
		local num_4 = arg_13_3.height * 0.5
		local var_13_24 = Vector3(arg_13_3.width * 0.5, max, num_4)
		local up = Quaternion.up(look)
		local num_5 = (flag + var_13_11) * 0.5 + up * num_4
		local immediate_overlap, var_13_28 = PhysicsWorld.immediate_overlap(get_data, "position", num_5, "rotation", look, "size", var_13_24, "shape", "oobb", "types", "dynamics", "collision_filter", "filter_player_hit_box_check")

		table.append(tbl_5, immediate_overlap)

		num_2 = num_2 + var_13_28

		if not parameter then
			local from_quaternion_position = Matrix4x4.from_quaternion_position(look, num_5)

			QuickDrawer:box(from_quaternion_position, var_13_24)
		end
	end

	if num_3 > 0 then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_play_fx", tbl, tbl_3, tbl_2)
	end

	self:_deal_damage(arg_13_1, arg_13_2, arg_13_3, var_13_11, tbl_5, num_2, true)

	arg_13_2.last_overlap_index = min
end

BTChampionAttackAction.anim_cb_damage = function (self, arg_14_1, arg_14_2)
	-- function 14
	local action = arg_14_2.action
	local mode = action.mode

	if not mode then
		printf("BTChampionAttackAction anim_cb_damage in mode %q", mode)

		return
	end

	local local_position = Unit.local_position(arg_14_1, 0)
	local local_rotation = Unit.local_rotation(arg_14_1, 0)
	local get_data = World.get_data(arg_14_2.world, "physics_world")

	if not action.effect_name then
		Managers.state.network:rpc_play_particle_effect(nil, NetworkLookup.effects[action.effect_name], NetworkConstants.invalid_game_object_id, 0, POSITION_LOOKUP[arg_14_1], Quaternion.identity(), false)
	end

	if not (action.collision_type == "oobb" or action.collision_type) then
		local _calculate_oobb_collision, var_14_6, var_14_7 = self:_calculate_oobb_collision(action, local_position, local_rotation)
		local immediate_overlap, var_14_9 = PhysicsWorld.immediate_overlap(get_data, "position", _calculate_oobb_collision, "rotation", var_14_6, "size", var_14_7, "shape", "oobb", "types", "dynamics", "collision_filter", "filter_player_hit_box_check")

		if not Development.parameter("debug_ai_attack") then
			local drawer = Managers.state.debug:drawer(tbl_4)

			drawer:reset()

			local from_quaternion_position = Matrix4x4.from_quaternion_position(var_14_6, _calculate_oobb_collision)

			drawer:box(from_quaternion_position, var_14_7)
		end

		self:_deal_damage(arg_14_1, arg_14_2, action, local_position, immediate_overlap, var_14_9, true)
	elseif action.collision_type == "cylinder" then
		local _calculate_cylinder_collision, var_14_13, var_14_14 = self:_calculate_cylinder_collision(action, local_position, local_rotation)
		local flag

		flag = not (var_14_13.y - var_14_13.x > 0) or not "capsule" or "sphere"

		PhysicsWorld.prepare_actors_for_overlap(get_data, _calculate_cylinder_collision, action.radius)

		local immediate_overlap_2 = PhysicsWorld.immediate_overlap
		local var_14_17 = get_data
		local str = "position"
		local var_14_19 = _calculate_cylinder_collision
		local str_2 = "rotation"
		local var_14_21 = var_14_14
		local str_3 = "size"
		local var_14_23 = var_14_13
		local str_4 = "shape"
		local var_14_25 = flag
		local str_5 = "types"
		local str_6 = "dynamics"
		local str_7 = "collision_filter"
		local collision_filter = action.collision_filter

		collision_filter = collision_filter or "filter_player_hit_box_check"

		local var_14_30, var_14_31 = immediate_overlap_2(var_14_17, str, var_14_19, str_2, var_14_21, str_3, var_14_23, str_4, var_14_25, str_5, str_6, str_7, collision_filter)

		if not Development.parameter("debug_ai_attack") then
			local drawer_2 = Managers.state.debug:drawer(tbl_4)

			drawer_2:reset()

			local forward = Quaternion.forward(var_14_14)

			drawer_2:cylinder(_calculate_cylinder_collision - forward * var_14_13.y, _calculate_cylinder_collision + forward * var_14_13.y, math.max(var_14_13.x, var_14_13.z), nil, 4)
		end

		self:_deal_damage(arg_14_1, arg_14_2, action, local_position, var_14_30, var_14_31, true)
	end

	self:_attack_threat_over(arg_14_1, arg_14_2, action)
end

BTChampionAttackAction._update_radial_cylinder = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	if not (arg_15_5 > arg_15_2.overlap_end_time) or not arg_15_2.attacking_target then
		self:_attack_threat_over(arg_15_1, arg_15_2, arg_15_3)

		return
	elseif not (arg_15_5 < arg_15_2.overlap_start_time or not (arg_15_5 > arg_15_2.overlap_end_time)) then
		return
	end

	local num = arg_15_5 - arg_15_2.overlap_start_time
	local local_position = Unit.local_position(arg_15_1, 0)
	local local_rotation = Unit.local_rotation(arg_15_1, 0)
	local get_data = World.get_data(arg_15_2.world, "physics_world")
	local _calculate_cylinder_collision, var_15_5, var_15_6 = self:_calculate_cylinder_collision(arg_15_3, local_position, local_rotation)
	local flag

	flag = not (var_15_5.y - var_15_5.x > 0) or not "capsule" or "sphere"

	local immediate_overlap, var_15_9 = PhysicsWorld.immediate_overlap(get_data, "position", _calculate_cylinder_collision, "rotation", var_15_6, "size", var_15_5, "shape", flag, "types", "dynamics", "collision_filter", arg_15_3.collision_filter)

	if not Development.parameter("debug_ai_attack") then
		local drawer = Managers.state.debug:drawer(tbl_4)

		drawer:reset()

		local forward = Quaternion.forward(var_15_6)

		drawer:cylinder(_calculate_cylinder_collision - forward * var_15_5.y, _calculate_cylinder_collision + forward * var_15_5.y, math.max(var_15_5.x, var_15_5.z), nil, 4)
	end

	local overlap_start_angle = arg_15_2.overlap_start_angle
	local overlap_last_angle = arg_15_2.overlap_last_angle
	local num_2 = overlap_start_angle + num * arg_15_2.overlap_angle_speed
	local num_3 = num_2 - overlap_last_angle
	local num_4 = 0.5
	local num_5 = 2 * math.pi
	local tbl = {}
	local num_6 = 0

	for i = 1, var_15_9 do
		local var_15_20 = immediate_overlap[i]
		local unit = Actor.unit(var_15_20)

		if not (unit == arg_15_1 or arg_15_2.hit_players[unit]) then
			local num_7 = Actor.center_of_mass(var_15_20) - local_position
			local y = num_7.y
			local var_15_24
			local direction = arg_15_3.direction

			if direction == "clockwise" then
				var_15_24 = -num_7.x
			elseif direction == "counter_clockwise" then
				var_15_24 = num_7.x
			else
				fassert(false, "Radial cylinder overlap with invalid direction %s", tostring(direction))
			end

			local sqrt = math.sqrt(var_15_24 * var_15_24 + y * y)
			local atan2 = math.atan2(y, var_15_24)
			local num_8 = 2 * math.tan(num_4, sqrt)
			local num_9 = (atan2 - num_8 - overlap_last_angle) % num_5
			local num_10 = (atan2 + num_8 - overlap_last_angle) % num_5

			if num_10 < num_9 then
				num_9 = num_9 - num_5
			end

			if not ((not (num_9 < 0) or not (num_3 < num_10) or not (num_9 > 0)) and not (num_9 < num_3) and not (num_10 > 0) or num_10 < num_3) then
				tbl[#tbl + 1] = var_15_20
				num_6 = num_6 + 1
			end
		end
	end

	self:_deal_damage(arg_15_1, arg_15_2, arg_15_3, local_position, tbl, num_6, false)

	arg_15_2.overlap_last_angle = num_2
end

BTChampionAttackAction._calculate_cylinder_collision = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local radius = arg_16_1.radius
	local height = arg_16_1.height
	local offset_up = arg_16_1.offset_up
	local offset_forward = arg_16_1.offset_forward
	local offset_right = arg_16_1.offset_right
	local num = height * 0.5
	local var_16_6 = Vector3(radius, num, radius)
	local forward = Quaternion.forward(arg_16_3)
	local up = Quaternion.up(arg_16_3)
	local right = Quaternion.right(arg_16_3)
	local num_2 = arg_16_2 + forward * (radius + offset_forward) + up * (num + offset_up) + right * offset_right
	local look = Quaternion.look(up, Vector3.up())

	return num_2, var_16_6, look
end

BTChampionAttackAction._calculate_oobb_collision = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local range = arg_17_1.range
	local height = arg_17_1.height
	local width = arg_17_1.width
	local offset_up = arg_17_1.offset_up
	local offset_forward = arg_17_1.offset_forward
	local num = range * 0.5
	local num_2 = height * 0.5
	local var_17_7 = Vector3(width * 0.5, num, num_2)
	local num_3 = Quaternion.rotate(arg_17_3, Vector3.forward()) * (offset_forward + num)
	local num_4 = Vector3.up() * (num_2 + offset_up)

	return arg_17_2 + num_3 + num_4, arg_17_3, var_17_7
end

BTChampionAttackAction._deal_damage = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
	-- function 18
	local hit_players = arg_18_2.hit_players
	local alive = Unit.alive
	local unit = Actor.unit
	local damage_target = AiUtils.damage_target
	local catapult = arg_18_3.catapult
	local shove_speed = arg_18_3.shove_speed
	local shove_z_speed = arg_18_3.shove_z_speed
	local impact_shove_multiplier = arg_18_3.impact_shove_multiplier

	if not impact_shove_multiplier then
		shove_speed = Vector3.length(arg_18_2.locomotion_extension:current_velocity()) * impact_shove_multiplier
	end

	assert(not shove_speed == not shove_z_speed, "Shove speed and shove_z_speed both or neither need to be set")

	for i = 1, arg_18_6 do
		local var_18_8 = arg_18_5[i]
		local var_18_9 = unit(var_18_8)

		if not (not DamageUtils.is_character(var_18_9) and not alive(var_18_9) and hit_players[var_18_9] or arg_18_1 == var_18_9) then
			hit_players[var_18_9] = true

			local attack_directions = arg_18_3.attack_directions

			attack_directions = not attack_directions and arg_18_3.attack_directions[arg_18_2.attack_anim]

			local check_block = DamageUtils.check_block(arg_18_1, var_18_9, arg_18_3.fatigue_type, attack_directions)
			local var_18_12 = POSITION_LOOKUP[var_18_9]
			local is_player_unit = DamageUtils.is_player_unit(var_18_9)

			if not shove_speed and not is_player_unit then
				local normalize = Vector3.normalize(var_18_12 - arg_18_4)

				if not arg_18_7 then
					local catapulted_players = arg_18_2.catapulted_players

					if not catapulted_players then
						catapulted_players = {}
						arg_18_2.catapulted_players = catapulted_players
					end

					catapulted_players[#catapulted_players + 1] = {
						target_unit = var_18_9,
						blocked = check_block,
						direction = Vector3Box(normalize)
					}
				else
					self:_catapult_enemy(arg_18_1, arg_18_2, shove_speed, shove_z_speed, var_18_9, check_block, normalize)
				end
			end

			if not is_player_unit and not check_block then
				local player_push_speed_blocked = arg_18_3.player_push_speed_blocked

				if not player_push_speed_blocked then
					local num = player_push_speed_blocked * Vector3.normalize(var_18_12 - arg_18_4)

					ScriptUnit.extension(var_18_9, "locomotion_system"):add_external_velocity(num)
				end

				local blocked_damage = arg_18_3.blocked_damage

				if not blocked_damage then
					damage_target(var_18_9, arg_18_1, arg_18_3, blocked_damage)
				end

				if not arg_18_3.ignore_abort_on_blocked_attack then
					return
				end
			else
				if not DamageUtils.is_enemy(arg_18_2.attacking_target, var_18_9) and not arg_18_3.hit_ai_func then
					arg_18_3.hit_ai_func(arg_18_1, arg_18_2, var_18_9)
				end

				damage_target(var_18_9, arg_18_1, arg_18_3, arg_18_3.damage)
			end
		end
	end
end

BTChampionAttackAction._catapult_players = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local shove_speed = arg_19_3.shove_speed
	local shove_z_speed = arg_19_3.shove_z_speed
	local impact_shove_multiplier = arg_19_3.impact_shove_multiplier

	if not impact_shove_multiplier then
		shove_speed = Vector3.length(arg_19_2.locomotion_extension:current_velocity()) * impact_shove_multiplier
	end

	for i, v in ipairs(arg_19_4) do
		local target_unit = v.target_unit

		if not Unit.alive(target_unit) then
			self:_catapult_player(arg_19_1, shove_speed, shove_z_speed, target_unit, v.blocked, v.direction:unbox())
		end
	end

	table.clear(arg_19_4)
end

BTChampionAttackAction._catapult_player = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	-- function 20
	local extension = ScriptUnit.extension(arg_20_4, "status_system")

	if not (extension:is_knocked_down() or extension:is_dead()) then
		local num = arg_20_6 * arg_20_2

		Vector3.set_z(num, arg_20_3)
		StatusUtils.set_catapulted_network(arg_20_4, true, num)
	end
end
