-- chunkname: @scripts/entity_system/systems/behaviour/nodes/storm_vermin/bt_storm_vermin_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTStormVerminAttackAction = class(BTStormVerminAttackAction, BTNode)

BTStormVerminAttackAction.init = function (arg_1_0, ...)
	-- function 1
	BTStormVerminAttackAction.super.init(arg_1_0, ...)
end

BTStormVerminAttackAction.name = "BTStormVerminAttackAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTStormVerminAttackAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTStormVerminAttackAction
	arg_3_2.attack_range = action_data.range
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.target_speed = 0
	arg_3_2.attack_token = true

	local sound_delay = action_data.sound_delay

	sound_delay = sound_delay or 0
	arg_3_2.play_sound_delay = arg_3_3 + sound_delay

	if not action_data.blocked_anim then
		arg_3_2.blocked_anim = action_data.blocked_anim
	end

	local target_unit = arg_3_2.target_unit
	local has_extension = ScriptUnit.has_extension(target_unit, "status_system")

	has_extension = has_extension or nil
	arg_3_2.target_unit_status_extension = has_extension
	arg_3_2.attacking_target = arg_3_2.target_unit

	self:_init_attack(arg_3_1, arg_3_2, arg_3_3)

	if not arg_3_2.moving_attack then
		arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
		arg_3_2.navigation_extension:set_enabled(false)
	end

	arg_3_2.spawn_to_running = nil

	if not has_extension then
		local breed = arg_3_2.breed

		if not breed.use_backstab_vo then
			local unit_owner = Managers.player:unit_owner(target_unit)

			if not (not unit_owner and unit_owner.bot_player) then
				local unit_is_flanking_player = AiUtils.unit_is_flanking_player(arg_3_1, target_unit)

				if not unit_owner.local_player then
					if not unit_is_flanking_player then
						local extension = ScriptUnit.extension(arg_3_1, "dialogue_system")
						local make_unit_auto_source, var_3_9 = WwiseUtils.make_unit_auto_source(arg_3_2.world, arg_3_1, extension.voice_node)
						local backstab_player_sound_event = breed.backstab_player_sound_event

						Managers.state.entity:system("audio_system"):_play_event_with_source(var_3_9, backstab_player_sound_event, make_unit_auto_source)
					end
				else
					local network = Managers.state.network
					local network_transmit = network.network_transmit
					local unit_game_object_id = network:unit_game_object_id(arg_3_1)
					local network_id = unit_owner:network_id()

					network_transmit:send_rpc("rpc_check_trigger_backstab_sfx", network_id, unit_game_object_id)
				end
			end
		end

		AiUtils.add_attack_intensity(target_unit, action_data, arg_3_2)

		if not arg_3_2.moving_attack and not ScriptUnit.has_extension(arg_3_1, "ai_slot_system") then
			Managers.state.entity:system("ai_slot_system"):set_release_slot_lock(arg_3_1, true)

			arg_3_2.keep_target = true
		end
	end

	arg_3_2.attacking_target_is_ai_breed = has_extension == nil

	if not action_data.attack_finished_duration then
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local var_3_16 = action_data.attack_finished_duration[get_difficulty]

		if not var_3_16 then
			arg_3_2.attack_finished_t = arg_3_3 + Math.random_range(var_3_16[1], var_3_16[2])
		end
	end
end

BTStormVerminAttackAction._init_attack = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local action = arg_4_2.action

	arg_4_2.move_state = "attacking"

	local var_4_1
	local target_unit_status_extension = arg_4_2.target_unit_status_extension

	target_unit_status_extension = not target_unit_status_extension and arg_4_2.target_unit_status_extension:is_knocked_down()

	if not target_unit_status_extension and not action.knocked_down_attack_anim then
		local var_4_3 = POSITION_LOOKUP[arg_4_1]
		local var_4_4 = POSITION_LOOKUP[arg_4_2.target_unit]

		var_4_4 = var_4_4 or Unit.world_position(arg_4_1, 0)

		if var_4_4.z - var_4_3.z < action.knocked_down_attack_threshold then
			var_4_1 = fn(action.knocked_down_attack_anim)
		else
			var_4_1 = fn(action.attack_anim)
		end
	elseif not action.step_attack_anim then
		local var_4_5 = POSITION_LOOKUP[arg_4_1]
		local var_4_6 = POSITION_LOOKUP[arg_4_2.target_unit]

		var_4_6 = var_4_6 or Unit.world_position(arg_4_1, 0)

		local distance = Vector3.distance(Vector3.flat(var_4_5), Vector3.flat(var_4_6))
		local step_attack_target_speed_away = action.step_attack_target_speed_away

		step_attack_target_speed_away = step_attack_target_speed_away or 1

		local step_attack_distance = action.step_attack_distance

		step_attack_distance = step_attack_distance or 1.5

		local step_attack_target_speed_away_override = action.step_attack_target_speed_away_override

		step_attack_target_speed_away_override = step_attack_target_speed_away_override or 2

		local step_attack_distance_override = action.step_attack_distance_override

		step_attack_distance_override = step_attack_distance_override or 3

		local target_speed_away_small_sample = arg_4_2.target_speed_away_small_sample

		if not ((not (step_attack_target_speed_away < target_speed_away_small_sample) or not (step_attack_distance < distance)) and step_attack_target_speed_away_override < target_speed_away_small_sample or step_attack_distance_override < distance) then
			arg_4_2.moving_attack = true
			var_4_1 = fn(action.step_attack_anim)
		else
			var_4_1 = fn(action.attack_anim)
		end
	else
		arg_4_2.moving_attack = action.moving_attack
		var_4_1 = fn(action.attack_anim)
	end

	Managers.state.network:anim_event(arg_4_1, var_4_1)

	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, arg_4_2.attacking_target)

	arg_4_2.attack_rotation = QuaternionBox(rotation_towards_unit_flat)

	if not arg_4_2.moving_attack and not action.rotation_time_step then
		arg_4_2.attack_rotation_update_timer = arg_4_3 + action.rotation_time_step
	else
		arg_4_2.attack_rotation_update_timer = arg_4_3 + action.rotation_time
	end

	if not (not action.bot_threat_duration and action.bot_threat_start_time) then
		self:_create_bot_threat(arg_4_1, arg_4_2)
	elseif not action.bot_threat_start_time then
		if not arg_4_2.moving_attack and not action.bot_threat_start_time_step then
			arg_4_2.bot_threat_at_t = arg_4_3 + action.bot_threat_start_time_step
		else
			arg_4_2.bot_threat_at_t = arg_4_3 + action.bot_threat_start_time
		end
	end
end

BTStormVerminAttackAction.leave = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	arg_5_2.navigation_extension:set_enabled(true)

	arg_5_2.active_node = nil
	arg_5_2.anim_cb_stagger_immune = nil
	arg_5_2.attack_aborted = nil
	arg_5_2.attack_finished_at_t = nil
	arg_5_2.attack_rotation = nil
	arg_5_2.attack_rotation_update_timer = nil
	arg_5_2.reset_attack = nil
	arg_5_2.target_unit_status_extension = nil

	if not arg_5_2.moving_attack and not ScriptUnit.has_extension(arg_5_1, "ai_slot_system") then
		Managers.state.entity:system("ai_slot_system"):set_release_slot_lock(arg_5_1, false)

		arg_5_2.keep_target = nil
	end

	arg_5_2.anim_cb_attack_cooldown = nil
	arg_5_2.attack_finished_t = nil
	arg_5_2.attack_token = nil
	arg_5_2.attacking_target = nil
	arg_5_2.moving_attack = nil
	arg_5_2.reset_attack = nil
	arg_5_2.reset_attack_animation_locked = nil
	arg_5_2.reset_attack_delay = nil
	arg_5_2.past_damage_in_attack = nil
	arg_5_2.bot_threat_at_t = nil

	if not arg_5_2.action.reset_stagger_count then
		ScriptUnit.extension(arg_5_1, "ai_system"):reset_stagger_count()
	end

	arg_5_2.action = nil
end

BTStormVerminAttackAction.run = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	self:update_reset_attack(arg_6_1, arg_6_3, arg_6_4, arg_6_2)

	if not arg_6_2.attack_aborted then
		return "done"
	end

	local alive = Unit.alive(arg_6_2.attacking_target)

	if not alive then
		self:attack(arg_6_1, arg_6_3, arg_6_4, arg_6_2)
	else
		return "done"
	end

	if not arg_6_2.catapult_hit then
		BTStormVerminAttackAction.catapult_enemies(arg_6_1, arg_6_2)
	end

	if not arg_6_2.anim_cb_attack_cooldown and not arg_6_2.attack_finished_t and arg_6_3 > arg_6_2.attack_finished_t and arg_6_2.attack_finished_t or not arg_6_2.attack_finished then
		return "done"
	end

	if not (not arg_6_2.play_sound_delay and not (arg_6_3 > arg_6_2.play_sound_delay)) then
		local sound_event = arg_6_2.action.sound_event

		if not sound_event then
			Managers.state.entity:system("audio_system"):play_audio_unit_event(sound_event, arg_6_1)
		end

		arg_6_2.play_sound_delay = nil
	end

	if not arg_6_2.moving_attack then
		local breed = arg_6_2.breed
		local navigation_extension = arg_6_2.navigation_extension
		local target_dist = arg_6_2.target_dist
		local target_speed_away_small_sample = arg_6_2.target_speed_away_small_sample

		if target_dist > 2.5 then
			if not arg_6_2.set_dodge_rotation_timer then
				target_speed_away_small_sample = breed.run_speed * 0.25
			else
				target_speed_away_small_sample = breed.run_speed
			end
		elseif target_dist > 1.5 then
			target_speed_away_small_sample = not arg_6_2.set_dodge_rotation_timer and 0 and target_speed_away_small_sample * 1.15
		end

		if math.abs(target_speed_away_small_sample - arg_6_2.target_speed) > 0.25 then
			arg_6_2.target_speed = target_speed_away_small_sample

			navigation_extension:set_max_speed(math.clamp(target_speed_away_small_sample, 0, breed.run_speed))
		end
	end

	if not (not alive and not arg_6_2.bot_threat_at_t and not (arg_6_3 > arg_6_2.bot_threat_at_t)) then
		self:_create_bot_threat(arg_6_1, arg_6_2)

		arg_6_2.bot_threat_at_t = nil
	end

	return "running"
end

BTStormVerminAttackAction._create_bot_threat = function (self, arg_7_1, arg_7_2)
	-- function 7
	local action = arg_7_2.action
	local bot_threat_duration = action.bot_threat_duration

	if not bot_threat_duration then
		if action.collision_type == "cylinder" then
			local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, arg_7_2.attacking_target)
			local _calculate_cylinder_collision = self:_calculate_cylinder_collision(action, POSITION_LOOKUP[arg_7_1], rotation_towards_unit_flat)
			local var_7_4 = Vector3(0, action.radius, action.height * 0.5)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(_calculate_cylinder_collision, "cylinder", var_7_4, nil, bot_threat_duration, "Storm Vermin")
		elseif not (action.collision_type == "oobb" or action.collision_type) then
			local rotation_towards_unit_flat_2 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, arg_7_2.attacking_target)
			local _calculate_oobb_collision, var_7_7, var_7_8 = self:_calculate_oobb_collision(action, POSITION_LOOKUP[arg_7_1], rotation_towards_unit_flat_2)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(_calculate_oobb_collision, "oobb", var_7_8, var_7_7, bot_threat_duration, "Storm Vermin")
		end
	end
end

BTStormVerminAttackAction.anim_cb_attack_vce = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	if not Managers.state.network:game() and not arg_8_2.target_unit_status_extension then
		Managers.state.entity:system("dialogue_system"):trigger_attack(arg_8_2, arg_8_2.target_unit, arg_8_1, false, false)
	end
end

BTStormVerminAttackAction.anim_cb_attack_vce_long = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	if not Managers.state.network:game() and not arg_9_2.target_unit_status_extension then
		Managers.state.entity:system("dialogue_system"):trigger_attack(arg_9_2, arg_9_2.target_unit, arg_9_1, false, true)
	end
end

BTStormVerminAttackAction.update_reset_attack = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local action = arg_10_4.action
	local reset_attack = arg_10_4.reset_attack
	local reset_attack_delay = arg_10_4.reset_attack_delay
	local reset_attack_animation_locked = arg_10_4.reset_attack_animation_locked

	if not (not reset_attack and reset_attack_animation_locked) then
		local var_10_4 = fn(action.reset_attack_animations)

		Managers.state.network:anim_event_with_variable_float(arg_10_1, var_10_4, "reset_speed", 0.1)

		arg_10_4.reset_attack = false
	end

	if not reset_attack_delay then
		arg_10_4.reset_attack_delay = reset_attack_delay - arg_10_3

		if reset_attack_delay < 0 then
			local reset_attack_animation_speed = action.reset_attack_animation_speed

			fassert(reset_attack_animation_speed, "no reset_attack_animation_speed for action %s", action.name)
			Managers.state.network:anim_set_variable_float(arg_10_1, "reset_speed", reset_attack_animation_speed)

			arg_10_4.reset_attack_delay = nil
		end
	end
end

BTStormVerminAttackAction.attack = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local extension = ScriptUnit.extension(arg_11_1, "locomotion_system")
	local target_unit_status_extension = arg_11_4.target_unit_status_extension

	if not target_unit_status_extension then
		-- Nothing
	end

	::label_11_0::

	local get_is_dodging = target_unit_status_extension:get_is_dodging()

	get_is_dodging = get_is_dodging or target_unit_status_extension:is_invisible()

	::label_11_1::

	if not get_is_dodging then
		arg_11_4.attack_rotation_update_timer = arg_11_2
	end

	if arg_11_2 < arg_11_4.attack_rotation_update_timer then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_11_1, arg_11_4.attacking_target)

		arg_11_4.attack_rotation = QuaternionBox(rotation_towards_unit_flat)
	end

	arg_11_4.locomotion_extension:set_wanted_rotation(arg_11_4.attack_rotation:unbox())
end

local tbl = {
	mode = "retained",
	name = "BTStormVerminAttackAction"
}

BTStormVerminAttackAction.anim_cb_damage = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local action = arg_12_2.action

	arg_12_2.past_damage_in_attack = true

	local world = Unit.world(arg_12_1)
	local get_data = World.get_data(world, "physics_world")
	local range = action.range
	local height = action.height
	local width = action.width
	local offset_up = action.offset_up
	local offset_forward = action.offset_forward
	local num = range * 0.5
	local num_2 = height * 0.5
	local var_12_10 = Vector3(width * 0.5, num, num_2)
	local local_position = Unit.local_position(arg_12_1, 0)
	local local_rotation = Unit.local_rotation(arg_12_1, 0)
	local num_3 = Quaternion.rotate(local_rotation, Vector3.forward()) * (offset_forward + num)
	local num_4 = Vector3.up() * (num_2 + offset_up)
	local num_5 = local_position + num_3 + num_4
	local immediate_overlap, var_12_17 = PhysicsWorld.immediate_overlap(get_data, "position", num_5, "rotation", local_rotation, "size", var_12_10, "shape", "oobb", "types", "dynamics", "collision_filter", "filter_player_hit_box_check")

	if not Development.parameter("debug_weapons") then
		local drawer = Managers.state.debug:drawer(tbl)

		drawer:reset()

		local from_quaternion_position = Matrix4x4.from_quaternion_position(local_rotation, num_5)

		drawer:box(from_quaternion_position, var_12_10)
	end

	local alloc_table = FrameTable.alloc_table()

	if not arg_12_2.moving_attack then
		arg_12_2.navigation_extension:set_enabled(false)
		arg_12_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
	else
		local time = Managers.time:time("game")
	end

	for i, v in ipairs(immediate_overlap) do
		alloc_table[Actor.unit(v)] = true
	end

	for k, v_2 in pairs(alloc_table) do
		if not Unit.alive(k) then
			return
		end

		local attack_directions = action.attack_directions

		attack_directions = not attack_directions and action.attack_directions[arg_12_2.attack_anim]

		local check_block = DamageUtils.check_block(arg_12_1, k, action.fatigue_type, attack_directions)

		if not action.damage then
			if not check_block then
				AiUtils.damage_target(k, arg_12_1, action, action.damage)
			elseif not check_block and not action.blocked_damage then
				AiUtils.damage_target(k, arg_12_1, action, action.blocked_damage)
			end

			if not (not DamageUtils.is_player_unit(k) and not check_block and action.fatigue_type ~= "complete") then
				SurroundingAwareSystem.add_event(k, "breaking_hit", DialogueSettings.grabbed_broadcast_range, "profile_name", ScriptUnit.extension(k, "dialogue_system").context.player_profile)
			end
		end

		if not action.catapult then
			BTStormVerminAttackAction.tag_catapult_enemy(arg_12_1, arg_12_2, action, k, check_block)
		end

		if not action.push then
			local var_12_24 = POSITION_LOOKUP[arg_12_1]
			local var_12_25 = POSITION_LOOKUP[k]
			local normalize = Vector3.normalize(var_12_25 - var_12_24)
			local is_player_unit = DamageUtils.is_player_unit(k)
			local player_push_speed = action.player_push_speed

			if not (not is_player_unit and not player_push_speed and ScriptUnit.extension(k, "status_system").knocked_down) then
				ScriptUnit.extension(k, "locomotion_system"):add_external_velocity(player_push_speed * normalize, action.max_player_push_speed)
			end
		end
	end

	if not arg_12_2.attacking_target_is_ai_breed then
		AiUtils.damage_target(arg_12_2.attacking_target, arg_12_1, action, action.damage)
	end
end

BTStormVerminAttackAction.anim_cb_attack_finished = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	arg_13_2.attack_finished = true
end

BTStormVerminAttackAction._calculate_cylinder_collision = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local radius = arg_14_1.radius
	local height = arg_14_1.height
	local offset_up = arg_14_1.offset_up
	local offset_forward = arg_14_1.offset_forward
	local offset_right = arg_14_1.offset_right
	local num = height * 0.5
	local var_14_6 = Vector3(radius, num, radius)
	local forward = Quaternion.forward(arg_14_3)
	local up = Quaternion.up(arg_14_3)
	local right = Quaternion.right(arg_14_3)
	local num_2 = arg_14_2 + forward * (radius + offset_forward) + up * (num + offset_up) + right * offset_right
	local look = Quaternion.look(up, Vector3.up())

	return num_2, var_14_6, look
end

BTStormVerminAttackAction._calculate_oobb_collision = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local range = arg_15_1.range
	local height = arg_15_1.height
	local width = arg_15_1.width
	local offset_up = arg_15_1.offset_up
	local offset_forward = arg_15_1.offset_forward
	local num = range * 0.5
	local num_2 = height * 0.5
	local var_15_7 = Vector3(width * 0.5, num, num_2)
	local num_3 = Quaternion.rotate(arg_15_3, Vector3.forward()) * (offset_forward + num)
	local num_4 = Vector3.up() * (num_2 + offset_up)

	return arg_15_2 + num_3 + num_4, arg_15_3, var_15_7
end

BTStormVerminAttackAction.tag_catapult_enemy = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local catapult_list = arg_16_1.catapult_list

	catapult_list = catapult_list or {}
	arg_16_1.catapult_list = catapult_list
	arg_16_1.catapult_list[arg_16_3] = arg_16_4
	arg_16_1.catapult_hit = true
end

BTStormVerminAttackAction.catapult_enemies = function (arg_17_0, arg_17_1)
	-- function 17
	local catapult_list = arg_17_1.catapult_list

	if not catapult_list then
		local catapult_enemy = BTStormVerminAttackAction.catapult_enemy
		local action = arg_17_1.action

		for k, v in pairs(catapult_list) do
			if not Unit.alive(k) then
				catapult_enemy(arg_17_0, arg_17_1, action, k, v)
			end

			catapult_list[k] = nil
		end
	end

	arg_17_1.catapult_hit = false
end

BTStormVerminAttackAction.catapult_enemy = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	if not arg_18_2.catapult then
		return
	end

	if not arg_18_4 then
		-- Nothing
	else
		AiUtils.damage_target(arg_18_3, arg_18_0, arg_18_2, arg_18_2.damage)
	end

	if not ScriptUnit.extension(arg_18_3, "status_system").knocked_down then
		local var_18_0 = POSITION_LOOKUP[arg_18_0]
		local var_18_1 = POSITION_LOOKUP[arg_18_3]
		local num = Vector3.normalize(var_18_1 - var_18_0) * arg_18_2.shove_speed

		Vector3.set_z(num, arg_18_2.shove_z_speed)
		StatusUtils.set_catapulted_network(arg_18_3, true, num)
	end
end
