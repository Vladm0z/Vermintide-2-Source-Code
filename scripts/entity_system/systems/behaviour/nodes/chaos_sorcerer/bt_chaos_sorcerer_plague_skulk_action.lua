-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_plague_skulk_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosSorcererPlagueSkulkAction = class(BTChaosSorcererPlagueSkulkAction, BTNode)

local BTChaosSorcererPlagueSkulkAction = BTChaosSorcererPlagueSkulkAction
local POSITION_LOOKUP = POSITION_LOOKUP

BTChaosSorcererPlagueSkulkAction.init = function (arg_1_0, ...)
	-- function 1
	BTChaosSorcererPlagueSkulkAction.super.init(arg_1_0, ...)
end

BTChaosSorcererPlagueSkulkAction.name = "BTChaosSorcererPlagueSkulkAction"

BTChaosSorcererPlagueSkulkAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local breed = arg_2_2.breed

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_2_1, "heard_enemy", DialogueSettings.hear_chaos_corruptor_sorcerer, "enemy_tag", breed.name)

	local skulk_data = arg_2_2.skulk_data

	skulk_data = skulk_data or {}
	arg_2_2.skulk_data = skulk_data

	local direction = skulk_data.direction

	direction = direction or 1 - math.random(0, 1) * 2
	skulk_data.direction = direction

	local radius = skulk_data.radius

	radius = radius or arg_2_2.target_dist
	skulk_data.radius = radius
	arg_2_2.action = action_data

	if arg_2_2.move_state ~= "idle" then
		self:idle(arg_2_1, arg_2_2)
	end

	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if not arg_2_2.move_pos then
		local unbox = arg_2_2.move_pos:unbox()

		self:move_to(unbox, arg_2_1, arg_2_2)
	end

	arg_2_2.ready_to_summon = false

	local num = 6

	if not action_data.skulk_time then
		if not (not action_data.initial_skulk_time and arg_2_2.initial_skulk_finished) then
			num = math.random(action_data.initial_skulk_time[1], action_data.initial_skulk_time[2])
		else
			num = math.random(action_data.skulk_time[1], action_data.skulk_time[2])
		end
	end

	if not arg_2_2.plague_wave_data then
		arg_2_2.plague_wave_data = {
			plague_wave_timer = arg_2_3 + num,
			physics_world = World.get_data(arg_2_2.world, "physics_world"),
			target_starting_pos = Vector3Box(),
			plague_wave_rot = QuaternionBox()
		}
	end

	arg_2_2.health_extension = ScriptUnit.extension(arg_2_1, "health_system")
	arg_2_2.teleport_health_percent = arg_2_2.health_extension:current_health_percent() - action_data.part_hp_lost_to_teleport
	arg_2_2.travel_teleport_timer = arg_2_3 + ConflictUtils.random_interval(action_data.teleport_cooldown)
	arg_2_2.face_target_while_summoning = true

	local summon_vo_timer = arg_2_2.summon_vo_timer

	summon_vo_timer = summon_vo_timer or arg_2_3
	arg_2_2.summon_vo_timer = summon_vo_timer
	arg_2_2.initial_skulk_finished = true

	if not arg_2_2.played_foreshadow then
		local system = Managers.state.entity:system("audio_system")
		local skulk_foreshadowing_sound = action_data.skulk_foreshadowing_sound

		system:play_audio_unit_event(skulk_foreshadowing_sound, arg_2_1)

		arg_2_2.played_foreshadow = true
	end
end

BTChaosSorcererPlagueSkulkAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local skulk_data = arg_3_2.skulk_data
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local navigation_extension = arg_3_2.navigation_extension

	navigation_extension:set_max_speed(get_default_breed_move_speed)

	if arg_3_4 == "aborted" then
		local is_following_path = navigation_extension:is_following_path()

		if not (not arg_3_2.move_pos and not is_following_path and arg_3_2.move_state ~= "idle") then
			self:start_move_animation(arg_3_1, arg_3_2)
		end
	end

	if not arg_3_2.played_foreshadow then
		local system = Managers.state.entity:system("audio_system")
		local skulk_foreshadowing_sound_stop = arg_3_2.action.skulk_foreshadowing_sound_stop

		system:play_audio_unit_event(skulk_foreshadowing_sound_stop, arg_3_1)
	end

	skulk_data.animation_state = nil
	arg_3_2.action = nil

	if arg_3_4 == "failed" then
		arg_3_2.target_unit = nil
	end
end

BTChaosSorcererPlagueSkulkAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not AiUtils.is_of_interest_plague_wave_sorcerer(arg_4_2.target_unit) then
		return "failed"
	end

	local navigation_extension = arg_4_2.navigation_extension
	local is_following_path = navigation_extension:is_following_path()
	local number_failed_move_attempts = navigation_extension:number_failed_move_attempts()
	local action = arg_4_2.action
	local plague_wave_data = arg_4_2.plague_wave_data
	local skulk_data = arg_4_2.skulk_data
	local target_unit = arg_4_2.target_unit

	if not (not arg_4_2.move_pos and not is_following_path and arg_4_2.move_state ~= "idle") then
		self:start_move_animation(arg_4_1, arg_4_2)
	end

	if arg_4_2.health_extension:current_health_percent() < arg_4_2.teleport_health_percent then
		local var_4_7 = POSITION_LOOKUP[arg_4_1]
		local num = math.random() * 5 + math.random() * 5 + math.random() * 5
		local num_2 = num * 0.5 + 10
		local num_3 = 5
		local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(arg_4_2.nav_world, var_4_7, num_2, num, num_3)

		if not get_spawn_pos_on_circle then
			arg_4_2.quick_teleport_exit_pos = Vector3Box(get_spawn_pos_on_circle)
			arg_4_2.quick_teleport = true
			skulk_data.direction = nil
			arg_4_2.move_pos = nil

			return "done"
		end
	end

	if not (not arg_4_2.vanish_timer and not (arg_4_3 < arg_4_2.vanish_timer)) then
		Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_4_1)

		return "running"
	end

	if arg_4_3 > arg_4_2.travel_teleport_timer then
		local get_skulk_target = self:get_skulk_target(arg_4_1, arg_4_2, true)

		if not get_skulk_target then
			arg_4_2.quick_teleport_exit_pos = Vector3Box(get_skulk_target)
			arg_4_2.quick_teleport = true
			arg_4_2.move_pos = nil

			return "done"
		end
	end

	if not arg_4_2.vanish_countdown and not (arg_4_3 > arg_4_2.vanish_countdown) or not self:vanish(arg_4_1, arg_4_2, arg_4_3) then
		return "done"
	end

	if not (not (arg_4_3 > plague_wave_data.plague_wave_timer) or ScriptUnit.extension(target_unit, "status_system"):is_invisible()) then
		local get_plague_wave_cast_position = self:get_plague_wave_cast_position(arg_4_1, arg_4_2, arg_4_2.plague_wave_data)

		if not get_plague_wave_cast_position then
			local num_4 = 6

			if not action.skulk_time then
				num_4 = math.random(action.skulk_time[1], action.skulk_time[2])
			end

			arg_4_2.face_player_when_teleporting = true
			arg_4_2.quick_teleport_exit_pos = Vector3Box(get_plague_wave_cast_position)
			arg_4_2.quick_teleport = true
			arg_4_2.move_pos = nil
			arg_4_2.vanish_countdown = arg_4_3 + action.vanish_countdown
			plague_wave_data.plague_wave_timer = arg_4_3 + num_4
			arg_4_2.ready_to_summon = true

			local num_5

			if not arg_4_2.num_plague_waves then
				num_5 = arg_4_2.num_plague_waves + 1

				if not num_5 then
					-- Nothing
				end
			end

			num_5 = 1

			::label_4_0::

			arg_4_2.num_plague_waves = num_5

			if arg_4_2.num_plague_waves >= 4 then
				arg_4_2.num_plague_waves = 0
			end

			if not arg_4_2.played_foreshadow then
				local system = Managers.state.entity:system("audio_system")
				local skulk_foreshadowing_sound_stop = action.skulk_foreshadowing_sound_stop

				system:play_audio_unit_event(skulk_foreshadowing_sound_stop, arg_4_1)
			end

			return "done"
		end
	end

	if not arg_4_2.move_pos then
		if not (self:at_goal(arg_4_1, arg_4_2) or not (number_failed_move_attempts > 0)) then
			arg_4_2.move_pos = nil
		end

		return "running"
	end

	local get_skulk_target_2 = self:get_skulk_target(arg_4_1, arg_4_2)

	if not get_skulk_target_2 then
		self:move_to(get_skulk_target_2, arg_4_1, arg_4_2)

		return "running"
	end

	if arg_4_2.move_state ~= "idle" then
		self:idle(arg_4_1, arg_4_2)
	end

	return "running"
end

BTChaosSorcererPlagueSkulkAction.at_goal = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local move_pos = arg_5_2.move_pos
	local var_5_1 = POSITION_LOOKUP[arg_5_1]

	if not move_pos then
		return false
	end

	local unbox = move_pos:unbox()

	if Vector3.distance_squared(var_5_1, unbox) < 0.25 then
		return true
	end
end

BTChaosSorcererPlagueSkulkAction.move_to = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_3.navigation_extension:move_to(arg_6_1)

	arg_6_3.move_pos = Vector3Box(arg_6_1)
end

BTChaosSorcererPlagueSkulkAction.vanish = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local action = arg_7_2.action
	local find_escape_position = BTNinjaVanishAction.find_escape_position(arg_7_1, arg_7_2)

	if not find_escape_position then
		arg_7_2.quick_teleport_exit_pos = Vector3Box(find_escape_position)
		arg_7_2.quick_teleport = true
		arg_7_2.move_pos = nil
		arg_7_2.vanish_countdown = nil
		arg_7_2.vanish_timer = arg_7_3 + action.vanish_timer

		arg_7_2.navigation_extension:move_to(find_escape_position)
		arg_7_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

		return true
	end

	return false
end

BTChaosSorcererPlagueSkulkAction.idle = function (self, arg_8_1, arg_8_2)
	-- function 8
	self:anim_event(arg_8_1, arg_8_2, "idle")

	arg_8_2.move_state = "idle"
end

BTChaosSorcererPlagueSkulkAction.start_move_animation = function (self, arg_9_1, arg_9_2)
	-- function 9
	local move_animation = arg_9_2.action.move_animation

	self:anim_event(arg_9_1, arg_9_2, move_animation)

	arg_9_2.move_state = "moving"
end

BTChaosSorcererPlagueSkulkAction.anim_event = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local skulk_data = arg_10_2.skulk_data

	if skulk_data.animation_state ~= arg_10_3 then
		Managers.state.network:anim_event(arg_10_1, arg_10_3)

		skulk_data.animation_state = arg_10_3
	end
end

local flag = false

BTChaosSorcererPlagueSkulkAction.get_plague_wave_cast_position = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local action = arg_11_2.action
	local nav_world = arg_11_2.nav_world
	local target_unit = arg_11_2.target_unit
	local var_11_3 = POSITION_LOOKUP[target_unit]
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_11_3, 1, 1)
	local distance = Vector3.distance
	local min_wave_distance = action.min_wave_distance
	local max_wave_distance = action.max_wave_distance

	if not (not arg_11_2.num_plague_waves and not (arg_11_2.num_plague_waves >= 3)) then
		max_wave_distance = action.third_wave_max_distance
		min_wave_distance = action.third_wave_min_distance
	end

	local num = (max_wave_distance + min_wave_distance) / 2
	local pi = math.pi
	local var_11_10
	local var_11_11 = pos_on_mesh

	if not var_11_11 then
		local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, var_11_3, 6, 6, 8, 0.5)

		if not inside_position_from_outside_position then
			var_11_11 = inside_position_from_outside_position
		end
	end

	if not var_11_11 then
		local num_2 = math.random(0, 360) * pi / 180
		local var_11_14 = Vector3(math.sin(num_2), math.cos(num_2), 0)
		local num_3 = var_11_3 + var_11_14 * max_wave_distance

		if not num_3 then
			local raycast, var_11_17 = GwNavQueries.raycast(nav_world, var_11_11, num_3)

			if not var_11_17 then
				local var_11_18 = distance(var_11_17, var_11_3)

				if not (not (min_wave_distance < var_11_18) or var_11_18 < max_wave_distance) then
					local num_4 = var_11_3 + var_11_14 * math.random(min_wave_distance, var_11_18)

					if num <= var_11_18 then
						num_4 = var_11_3 + var_11_14 * math.random(num, var_11_18)
					end

					local pos_on_mesh_2 = LocomotionUtils.pos_on_mesh(nav_world, num_4, 1, 1)

					if not pos_on_mesh_2 then
						local normalize = Vector3.normalize(var_11_11 - pos_on_mesh_2)
						local look = Quaternion.look(normalize)

						var_11_10 = pos_on_mesh_2

						arg_11_3.plague_wave_rot:store(look)
						arg_11_3.target_starting_pos:store(var_11_11)
					end
				end
			end
		end
	end

	return var_11_10
end

local num = 15

BTChaosSorcererPlagueSkulkAction.get_skulk_target = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local action = arg_12_2.action
	local nav_world = arg_12_2.nav_world
	local skulk_data = arg_12_2.skulk_data
	local direction = skulk_data.direction
	local target_unit = arg_12_2.target_unit

	if not target_unit then
		return
	end

	local var_12_5 = POSITION_LOOKUP[target_unit]
	local var_12_6 = POSITION_LOOKUP[arg_12_1]
	local target_dist = arg_12_2.target_dist
	local num_2 = var_12_6 - var_12_5
	local normalize = Vector3.normalize(num_2)

	if not arg_12_2.is_close then
		local preferred_distance = action.preferred_distance

		preferred_distance = preferred_distance or 20

		if target_dist < preferred_distance then
			num_2 = num_2 + normalize * (1 + math.random())
		else
			arg_12_2.is_close = false
			num_2 = num_2 + normalize
		end
	else
		local close_distance = action.close_distance

		close_distance = close_distance or 20

		if target_dist < close_distance then
			arg_12_2.is_close = true
			num_2 = num_2 + normalize
		end
	end

	local var_12_12 = Vector3(0, 0, direction)
	local num_3 = 0.1
	local num_4 = math.pi * math.clamp(num_3 * 20 / target_dist, 0.01, 0.15)

	if not arg_12_3 then
		num_4 = num_4 * 1.5
	end

	for i = 1, num do
		local num_5 = num_2 - normalize * 0.5
		local num_6 = var_12_5 + Quaternion.rotate(Quaternion(var_12_12, num_4 * i), num_5)
		local find_center_tri = ConflictUtils.find_center_tri(nav_world, num_6)

		if not find_center_tri then
			return find_center_tri
		end
	end

	skulk_data.direction = skulk_data.direction * -1
end
