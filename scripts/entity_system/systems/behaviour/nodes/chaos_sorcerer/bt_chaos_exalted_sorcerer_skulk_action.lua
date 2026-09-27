-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_exalted_sorcerer_skulk_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosExaltedSorcererSkulkAction = class(BTChaosExaltedSorcererSkulkAction, BTNode)
BTChaosExaltedSorcererSkulkAction.name = "BTChaosExaltedSorcererSkulkAction"

local BTChaosExaltedSorcererSkulkAction = BTChaosExaltedSorcererSkulkAction
local alive = Unit.alive
local POSITION_LOOKUP = POSITION_LOOKUP

BTChaosExaltedSorcererSkulkAction.init = function (self, ...)
	-- function 1
	BTChaosExaltedSorcererSkulkAction.super.init(self, ...)

	self.cover_points_broadphase = Managers.state.conflict.level_analysis.cover_points_broadphase
end

BTChaosExaltedSorcererSkulkAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local breed = arg_2_2.breed
	local target_dist = arg_2_2.target_dist
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

	arg_2_2.navigation_extension:set_max_speed(breed.run_speed)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if not arg_2_2.move_pos then
		local unbox = arg_2_2.move_pos:unbox()

		self:move_to(unbox, arg_2_1, arg_2_2)
	end

	arg_2_2.ready_to_summon = false

	local num_summons = arg_2_2.num_summons

	num_summons = num_summons or 0
	arg_2_2.num_summons = num_summons
	arg_2_2.health_extension = ScriptUnit.extension(arg_2_1, "health_system")
	arg_2_2.teleport_health_percent = arg_2_2.health_extension:current_health_percent() - action_data.part_hp_lost_to_teleport
	arg_2_2.travel_teleport_timer = arg_2_3 + ConflictUtils.random_interval(action_data.teleport_cooldown)

	local available_spells = action_data.available_spells
	local var_2_9 = available_spells[Math.random(1, #available_spells)]
	local var_2_10 = arg_2_2.spells_lookup[var_2_9]

	arg_2_2.current_spell = var_2_10
	arg_2_2.current_spell_name = var_2_10.name
	arg_2_2.face_target_while_summoning = true
end

BTChaosExaltedSorcererSkulkAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
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

		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_3_2.done_casting_timer = arg_3_3 + arg_3_2.action.after_casting_delay[get_difficulty]
	end

	skulk_data.animation_state = nil
	arg_3_2.action = nil
end

BTChaosExaltedSorcererSkulkAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local navigation_extension = arg_4_2.navigation_extension
	local is_following_path = navigation_extension:is_following_path()
	local number_failed_move_attempts = navigation_extension:number_failed_move_attempts()
	local action = arg_4_2.action
	local current_spell = arg_4_2.current_spell

	if (not (arg_4_3 > arg_4_2.done_casting_timer) or not current_spell) and not current_spell.search_func(self, arg_4_1, arg_4_2, arg_4_3, current_spell) then
		return "done"
	end

	local skulk_data = arg_4_2.skulk_data

	if not (not arg_4_2.move_pos and not is_following_path and arg_4_2.move_state ~= "idle") then
		self:start_move_animation(arg_4_1, arg_4_2)
	end

	if arg_4_2.health_extension:current_health_percent() < arg_4_2.teleport_health_percent then
		local var_4_6 = POSITION_LOOKUP[arg_4_1]
		local var_4_7 = POSITION_LOOKUP[arg_4_2.target_unit]
		local var_4_8 = var_4_6

		if Vector3.distance_squared(var_4_6, var_4_7) > action.far_away_from_target_sq then
			local var_4_9 = var_4_7
		end

		local num = math.random() * 5 + math.random() * 5 + math.random() * 5
		local num_2 = num * 0.5 + 10
		local num_3 = 5
		local get_spawn_pos_on_circle_with_func = ConflictUtils.get_spawn_pos_on_circle_with_func(arg_4_2.nav_world, var_4_6, num_2, num, num_3, arg_4_2.valid_teleport_pos_func, arg_4_2)

		if not get_spawn_pos_on_circle_with_func then
			arg_4_2.quick_teleport_exit_pos = Vector3Box(get_spawn_pos_on_circle_with_func)
			arg_4_2.quick_teleport = true
			skulk_data.direction = nil
			arg_4_2.move_pos = nil

			return "done"
		end
	elseif arg_4_3 > arg_4_2.travel_teleport_timer then
		local get_skulk_target = BTChaosExaltedSorcererSkulkAction.get_skulk_target(arg_4_1, arg_4_2, true)

		if not get_skulk_target and not arg_4_2.valid_teleport_pos_func(get_skulk_target, arg_4_2) then
			arg_4_2.quick_teleport_exit_pos = Vector3Box(get_skulk_target)
			arg_4_2.quick_teleport = true
			arg_4_2.move_pos = nil

			return "done"
		end
	end

	if not arg_4_2.move_pos then
		if not (self:at_goal(arg_4_1, arg_4_2) or not (number_failed_move_attempts > 0)) then
			arg_4_2.move_pos = nil
		end

		return "running"
	end

	local get_skulk_target_2 = BTChaosExaltedSorcererSkulkAction.get_skulk_target(arg_4_1, arg_4_2)

	if not get_skulk_target_2 then
		self:move_to(get_skulk_target_2, arg_4_1, arg_4_2)

		return "running"
	end

	if arg_4_2.move_state ~= "idle" then
		self:idle(arg_4_1, arg_4_2)
	end

	return "running"
end

BTChaosExaltedSorcererSkulkAction.at_goal = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local skulk_data = arg_5_2.skulk_data
	local move_pos = arg_5_2.move_pos

	if not move_pos then
		return false
	end

	local unbox = move_pos:unbox()

	if Vector3.distance_squared(unbox, POSITION_LOOKUP[arg_5_1]) < 0.25 then
		return true
	end
end

BTChaosExaltedSorcererSkulkAction.move_to = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_3.navigation_extension:move_to(arg_6_1)

	arg_6_3.move_pos = Vector3Box(arg_6_1)
end

BTChaosExaltedSorcererSkulkAction.idle = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:anim_event(arg_7_1, arg_7_2, "idle")

	arg_7_2.move_state = "idle"
end

BTChaosExaltedSorcererSkulkAction.start_move_animation = function (self, arg_8_1, arg_8_2)
	-- function 8
	local move_animation = arg_8_2.action.move_animation

	self:anim_event(arg_8_1, arg_8_2, move_animation)

	arg_8_2.move_state = "moving"
end

BTChaosExaltedSorcererSkulkAction.anim_event = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local skulk_data = arg_9_2.skulk_data

	if skulk_data.animation_state ~= arg_9_3 then
		Managers.state.network:anim_event(arg_9_1, arg_9_3)

		skulk_data.animation_state = arg_9_3
	end
end

local num = 15

BTChaosExaltedSorcererSkulkAction.get_skulk_target = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local action = arg_10_1.action
	local nav_world = arg_10_1.nav_world
	local skulk_data = arg_10_1.skulk_data
	local direction = skulk_data.direction
	local target_unit = arg_10_1.target_unit
	local var_10_5 = POSITION_LOOKUP[target_unit]
	local var_10_6 = POSITION_LOOKUP[arg_10_0]
	local target_dist = arg_10_1.target_dist
	local num_2 = var_10_6 - var_10_5
	local normalize = Vector3.normalize(num_2)
	local preferred_distance = action.preferred_distance

	if not arg_10_1.is_close then
		if target_dist < preferred_distance then
			num_2 = num_2 + normalize * (1 + math.random())
		else
			arg_10_1.is_close = false
			num_2 = num_2 + normalize
		end
	elseif target_dist < action.close_distance then
		arg_10_1.is_close = true
		num_2 = num_2 + normalize
	end

	local var_10_11 = Vector3(0, 0, direction)
	local num_3 = 0.1
	local num_4 = math.pi * math.clamp(num_3 * 20 / target_dist, 0.01, 0.15)

	if not arg_10_2 then
		num_4 = num_4 * 1.5
	end

	for i = 1, num do
		local num_5 = num_2 - normalize * 0.5

		if not arg_10_1.num_summons then
			local num_summons = arg_10_1.num_summons
			local teleport_closer_summon_limit = action.teleport_closer_summon_limit

			teleport_closer_summon_limit = teleport_closer_summon_limit or 3

			if teleport_closer_summon_limit <= num_summons then
				num_5 = Vector3.normalize(var_10_5 - var_10_6) * action.teleport_closer_range
			end
		end

		local num_6 = var_10_5 + Quaternion.rotate(Quaternion(var_10_11, num_4 * i), num_5)
		local find_center_tri = ConflictUtils.find_center_tri(nav_world, num_6)

		if not find_center_tri then
			return find_center_tri
		end
	end

	skulk_data.direction = skulk_data.direction * -1
end

BTChaosExaltedSorcererSkulkAction.debug_show_skulk_circle = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local action = arg_11_2.action
	local skulk_data = arg_11_2.skulk_data
	local radius = skulk_data.radius
	local target_unit = arg_11_2.target_unit
	local var_11_4 = POSITION_LOOKUP[target_unit]
	local num = Vector3.up() * 0.2

	QuickDrawer:circle(var_11_4 + num, arg_11_2.target_dist, Vector3.up(), Colors.get("light_green"))
	QuickDrawer:circle(var_11_4 + num, skulk_data.radius, Vector3.up(), Colors.get("light_green"))

	skulk_data.radius = arg_11_2.target_dist
end

BTChaosExaltedSorcererSkulkAction.update_dummy = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	return false
end

BTChaosExaltedSorcererSkulkAction.update_plague_wave = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local target_unit = arg_13_2.target_unit
	local get_plague_wave_cast_position = BTChaosSorcererPlagueSkulkAction.get_plague_wave_cast_position(arg_13_0, arg_13_1, arg_13_2, arg_13_4)

	if not get_plague_wave_cast_position and not arg_13_2.valid_teleport_pos_func(get_plague_wave_cast_position, arg_13_2) then
		arg_13_2.face_player_when_teleporting = true
		arg_13_2.quick_teleport_exit_pos = Vector3Box(get_plague_wave_cast_position)
		arg_13_2.quick_teleport = true
		arg_13_2.move_pos = nil
		arg_13_2.ready_to_summon = true

		local num

		if not arg_13_2.num_plague_waves then
			num = arg_13_2.num_plague_waves + 1

			if not num then
				-- Nothing
			end
		end

		num = 1

		::label_13_0::

		arg_13_2.num_plague_waves = num

		if arg_13_2.num_plague_waves >= 4 then
			arg_13_2.num_plague_waves = 0
		end

		return true
	end
end

BTChaosExaltedSorcererSkulkAction.update_cast_missile = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local copy = Vector3.copy(POSITION_LOOKUP[arg_14_1])
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_14_1, arg_14_2.target_unit)
	local var_14_2, var_14_3, var_14_4 = unpack(arg_14_2.action.missile_spawn_offset)
	local var_14_5 = Vector3(var_14_2, var_14_3, var_14_4)
	local num = copy + Quaternion.rotate(rotation_towards_unit_flat, var_14_5)

	copy.z = num.z

	local num_2 = num - copy
	local normalize = Vector3.normalize(num_2)
	local length = Vector3.length(num_2)
	local world = arg_14_2.world
	local get_data = World.get_data(world, "physics_world")

	if not PhysicsWorld.immediate_raycast(get_data, copy, normalize, length, "closest", "collision_filter", "filter_enemy_ray_projectile") then
		return false
	end

	arg_14_2.ready_to_summon = true

	return true
end
