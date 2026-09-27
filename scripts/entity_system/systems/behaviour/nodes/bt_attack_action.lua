-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTAttackAction = class(BTAttackAction, BTNode)

BTAttackAction.init = function (arg_1_0, ...)
	-- function 1
	BTAttackAction.super.init(arg_1_0, ...)
end

BTAttackAction.name = "BTAttackAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

local num = 1.5
local tbl = {}

BTAttackAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTAttackAction
	arg_3_2.attack_aborted = false
	arg_3_2.attack_finished = false
	arg_3_2.attack_finished_t = nil
	arg_3_2.attack_token = true
	arg_3_2.locked_attack_rotation = false
	arg_3_2.moving_attack = action_data.moving_attack
	arg_3_2.past_damage_in_attack = false
	arg_3_2.target_speed = 0

	local target_unit = arg_3_2.target_unit
	local has_extension = ScriptUnit.has_extension(target_unit, "status_system")
	local has_extension_2 = ScriptUnit.has_extension(target_unit, "ai_slot_system")
	local _select_attack = self:_select_attack(action_data, arg_3_1, target_unit, arg_3_2, has_extension)

	arg_3_2.attack_anim = fn(_select_attack.anims)

	if not action_data.blocked_anim then
		arg_3_2.blocked_anim = action_data.blocked_anim
	end

	local damage_box_range = _select_attack.damage_box_range

	if not damage_box_range then
		arg_3_2.attack_range_up = damage_box_range.up
		arg_3_2.attack_range_down = damage_box_range.down
		arg_3_2.attack_range_flat = damage_box_range.flat
	end

	if not arg_3_2.attack_token and not has_extension then
		local breed = arg_3_2.breed

		if not (not breed.use_backstab_vo and not has_extension_2 and not (has_extension_2.num_occupied_slots <= 5)) then
			local unit_owner = Managers.player:unit_owner(target_unit)

			if not (not unit_owner and unit_owner.bot_player) then
				local unit_is_flanking_player = AiUtils.unit_is_flanking_player(arg_3_1, target_unit)

				if not unit_is_flanking_player then
					arg_3_2.backstab_attack_trigger = true
				end

				if not unit_owner.local_player then
					if not unit_is_flanking_player then
						local extension = ScriptUnit.extension(arg_3_1, "dialogue_system")
						local make_unit_auto_source, var_3_11 = WwiseUtils.make_unit_auto_source(arg_3_2.world, arg_3_1, extension.voice_node)
						local backstab_player_sound_event = breed.backstab_player_sound_event

						Managers.state.entity:system("audio_system"):_play_event_with_source(var_3_11, backstab_player_sound_event, make_unit_auto_source)
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
	end

	arg_3_2.target_unit_status_extension = has_extension
	arg_3_2.attack_setup_delayed = true
	arg_3_2.attacking_target = target_unit
	arg_3_2.spawn_to_running = nil

	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_3_1, target_unit)

	arg_3_2.attack_rotation = QuaternionBox(rotation_towards_unit_flat)
	arg_3_2.attack_rotation_lock_timer = arg_3_3

	local dodge_window_start = action_data.dodge_window_start
	local dodge_window_duration = action_data.dodge_window_duration

	dodge_window_duration = dodge_window_duration or tbl

	local get_difficulty = Managers.state.difficulty:get_difficulty()

	if not (not dodge_window_start and type(dodge_window_start) ~= "table") then
		dodge_window_start = dodge_window_start[get_difficulty]
	end

	local num_2

	if not dodge_window_start then
		num_2 = dodge_window_start + arg_3_3

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = arg_3_3

	::label_3_0::

	arg_3_2.attack_dodge_window_start = num_2

	local var_3_22 = dodge_window_duration[get_difficulty]

	var_3_22 = var_3_22 or num
	arg_3_2.attack_dodge_window_duration = var_3_22

	if not action_data.attack_finished_duration then
		local var_3_23 = action_data.attack_finished_duration[get_difficulty]

		if not var_3_23 then
			arg_3_2.attack_finished_t = arg_3_3 + Math.random_range(var_3_23[1], var_3_23[2])
		end
	end

	AiUtils.add_attack_intensity(target_unit, action_data, arg_3_2)

	if not arg_3_2.moving_attack and not ScriptUnit.has_extension(arg_3_1, "ai_slot_system") then
		Managers.state.entity:system("ai_slot_system"):set_release_slot_lock(arg_3_1, true)

		arg_3_2.keep_target = true
	end

	local has_extension_3 = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if not has_extension_3 then
		arg_3_2.target_unit_attack_intensity_extension = has_extension_3
	end
end

BTAttackAction._select_attack = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local get_data = Unit.get_data(arg_4_3, "target_type")

	if not get_data then
		-- Nothing
	end

	::label_4_0::

	local target_type_exceptions = arg_4_1.target_type_exceptions

	target_type_exceptions = not target_type_exceptions and arg_4_1.target_type_exceptions[get_data]

	::label_4_1::

	if not target_type_exceptions then
		return target_type_exceptions
	else
		local var_4_2 = POSITION_LOOKUP[arg_4_2]
		local var_4_3 = POSITION_LOOKUP[arg_4_3]

		var_4_3 = var_4_3 or Unit.world_position(arg_4_2, 0)

		local num = var_4_3.z - var_4_2.z
		local distance = Vector3.distance(Vector3.flat(var_4_2), Vector3.flat(var_4_3))
		local default_attack = arg_4_1.default_attack
		local high_attack = arg_4_1.high_attack
		local mid_attack = arg_4_1.mid_attack
		local low_attack = arg_4_1.low_attack
		local step_attack = arg_4_1.step_attack
		local step_attack_with_callback = arg_4_1.step_attack_with_callback
		local knocked_down_attack = arg_4_1.knocked_down_attack

		if not (not high_attack and not (num > high_attack.z_threshold)) then
			return high_attack
		elseif not (not mid_attack and not (num < mid_attack.z_threshold) or not (distance > mid_attack.flat_threshold)) then
			return mid_attack
		elseif not (not low_attack and not (num < low_attack.z_threshold)) then
			return low_attack
		elseif not knocked_down_attack and (not (num < knocked_down_attack.z_threshold) or not arg_4_5) and not arg_4_5:is_knocked_down() then
			return knocked_down_attack
		else
			if not step_attack_with_callback then
				local target_speed_away = arg_4_4.target_speed_away
				local step_speed_moving = step_attack_with_callback.step_speed_moving

				step_speed_moving = step_speed_moving or 1

				if step_speed_moving < target_speed_away then
					local step_distance_moving = step_attack_with_callback.step_distance_moving

					step_distance_moving = step_distance_moving or 1.5

					if not (step_distance_moving < distance) then
						-- Nothing
					end
				end

				do
					local step_distance_stationary = step_attack_with_callback.step_distance_stationary

					step_distance_stationary = step_distance_stationary or 2.5

					if step_distance_stationary < distance then
						-- Nothing
					end
				end

				::label_4_2::

				arg_4_4.moving_attack_with_callback = true

				if not step_attack_with_callback.attack_hit_animation then
					arg_4_4.attack_hit_animation = step_attack_with_callback.attack_hit_animation
				end

				do return step_attack_with_callback end

				goto label_4_6
			end

			::label_4_3::

			if not step_attack then
				local target_speed_away_2 = arg_4_4.target_speed_away
				local step_speed_moving_2 = step_attack.step_speed_moving

				step_speed_moving_2 = step_speed_moving_2 or 1

				if step_speed_moving_2 < target_speed_away_2 then
					local step_distance_moving_2 = step_attack.step_distance_moving

					step_distance_moving_2 = step_distance_moving_2 or 1.5

					if not (step_distance_moving_2 < distance) then
						-- Nothing
					end
				end

				do
					local step_distance_stationary_2 = step_attack.step_distance_stationary

					step_distance_stationary_2 = step_distance_stationary_2 or 2.5

					if step_distance_stationary_2 < distance then
						-- Nothing
					end
				end

				::label_4_4::

				arg_4_4.moving_attack = step_attack.moving_attack

				do return step_attack end

				goto label_4_6
			end

			::label_4_5::

			return default_attack
		end
	end

	::label_4_6::
end

BTAttackAction.leave = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_5_1, arg_5_2)
	local navigation_extension = arg_5_2.navigation_extension

	navigation_extension:set_enabled(true)
	navigation_extension:set_max_speed(get_default_breed_move_speed)

	if arg_5_2.move_state == "idle" or not HEALTH_ALIVE[arg_5_1] then
		arg_5_2.move_state = "idle"
	end

	if not arg_5_2.moving_attack and not ScriptUnit.has_extension(arg_5_1, "ai_slot_system") then
		Managers.state.entity:system("ai_slot_system"):set_release_slot_lock(arg_5_1, false)

		arg_5_2.keep_target = nil
	end

	if not ScriptUnit.has_extension(arg_5_1, "ai_shield_system") then
		ScriptUnit.extension(arg_5_1, "ai_shield_system"):set_is_blocking(true)
	end

	self:clear_blackboard(arg_5_1, arg_5_2, arg_5_3)
end

BTAttackAction.clear_blackboard = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not arg_6_2.action.use_box_range then
		arg_6_2.attack_range_up = nil
		arg_6_2.attack_range_down = nil
		arg_6_2.attack_range_flat = nil
	end

	arg_6_2.action = nil
	arg_6_2.active_node = nil
	arg_6_2.anim_cb_attack_cooldown = nil
	arg_6_2.anim_cb_damage = nil
	arg_6_2.anim_cb_running_attack_end = nil
	arg_6_2.anim_cb_running_attack_start = nil
	arg_6_2.anim_cb_stagger_immune = nil
	arg_6_2.attack_aborted = nil
	arg_6_2.attack_anim = nil
	arg_6_2.attack_dodge_window_start = nil
	arg_6_2.attack_dodge_window_duration = nil
	arg_6_2.attack_finished = nil
	arg_6_2.attack_finished_duration = nil
	arg_6_2.attack_finished_t = nil
	arg_6_2.attack_hit_animation = nil
	arg_6_2.attack_rotation = nil
	arg_6_2.attack_rotation_lock_timer = nil
	arg_6_2.attack_token = nil
	arg_6_2.attacking_target = nil
	arg_6_2.backstab_attack_trigger = nil
	arg_6_2.locked_attack_rotation = nil
	arg_6_2.moving_attack = nil
	arg_6_2.moving_attack_with_callback = nil
	arg_6_2.past_damage_in_attack = nil
	arg_6_2.target_speed = 0
	arg_6_2.target_unit_attack_intensity_extension = nil
	arg_6_2.target_unit_status_extension = nil
end

BTAttackAction.run = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if not Unit.alive(arg_7_2.attacking_target) then
		return "done"
	end

	if not arg_7_2.attack_aborted then
		return "done"
	end

	if not arg_7_2.anim_cb_damage then
		arg_7_2.anim_cb_damage = nil
		arg_7_2.past_damage_in_attack = true

		if not arg_7_2.moving_attack then
			arg_7_2.navigation_extension:set_enabled(false)
			arg_7_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
		end

		if not ScriptUnit.has_extension(arg_7_1, "ai_shield_system") then
			ScriptUnit.extension(arg_7_1, "ai_shield_system"):set_is_blocking(false)
		end
	end

	if not arg_7_2.anim_cb_attack_cooldown and not arg_7_2.attack_finished_t and arg_7_3 > arg_7_2.attack_finished_t and arg_7_2.attack_finished_t or not arg_7_2.attack_finished then
		return "done"
	end

	if not arg_7_2.moving_attack then
		local breed = arg_7_2.breed
		local destination_dist = arg_7_2.destination_dist
		local target_speed_away_small_sample = arg_7_2.target_speed_away_small_sample
		local run_speed = breed.run_speed

		if destination_dist > 0.5 then
			if not arg_7_2.locked_attack_rotation then
				target_speed_away_small_sample = run_speed * 0.85
			else
				target_speed_away_small_sample = run_speed * 1.1
			end
		elseif not arg_7_2.locked_attack_rotation then
			target_speed_away_small_sample = run_speed * 0.65
		else
			target_speed_away_small_sample = target_speed_away_small_sample * 1.2
		end

		if math.abs(target_speed_away_small_sample - arg_7_2.target_speed) > 0.25 then
			arg_7_2.target_speed = target_speed_away_small_sample

			arg_7_2.navigation_extension:set_max_speed(math.clamp(target_speed_away_small_sample, 0, run_speed))
		end
	end

	if not arg_7_2.attack_setup_delayed then
		if not arg_7_2.moving_attack then
			arg_7_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
			arg_7_2.navigation_extension:set_enabled(false)
		end

		arg_7_2.attack_setup_delayed = false
	end

	if not arg_7_2.moving_attack_with_callback then
		if not arg_7_2.anim_cb_running_attack_start then
			arg_7_2.navigation_extension:set_enabled(true)

			arg_7_2.anim_cb_running_attack_start = nil
		elseif not arg_7_2.anim_cb_running_attack_end then
			arg_7_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
			arg_7_2.navigation_extension:set_enabled(false)

			arg_7_2.anim_cb_running_attack_end = nil
		end
	end

	self:_attack(arg_7_1, arg_7_3, arg_7_4, arg_7_2)
	self:_handle_movement(arg_7_1, arg_7_3, arg_7_4, arg_7_2)

	return "running"
end

BTAttackAction.attack_cooldown = function (self, arg_8_1, arg_8_2)
	-- function 8
	local time = Managers.time:time("game")

	arg_8_2.is_in_attack_cooldown, arg_8_2.attack_cooldown_at = self:_get_attack_cooldown_finished_at(arg_8_1, arg_8_2, time)
end

BTAttackAction.attack_success = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	if not arg_9_2.breed.use_backstab_vo and not arg_9_2.backstab_attack_trigger then
		Managers.state.entity:system("dialogue_system"):trigger_backstab_hit(arg_9_2.target_unit, arg_9_1)

		arg_9_2.backstab_attack_trigger = false
	end

	if not arg_9_2.attack_hit_animation then
		Managers.state.network:anim_event(arg_9_1, arg_9_2.attack_hit_animation)
		arg_9_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
		arg_9_2.navigation_extension:set_enabled(false)
	end
end

BTAttackAction.attack_blocked = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local action = arg_10_2.action
	local attacking_target = arg_10_2.attacking_target
	local player_push_speed_blocked = action.player_push_speed_blocked

	if not player_push_speed_blocked then
		local has_extension = ScriptUnit.has_extension(attacking_target, "status_system")

		if not (not has_extension and has_extension:is_disabled()) then
			local var_10_4 = POSITION_LOOKUP[arg_10_1]

			var_10_4 = var_10_4 or Unit.world_position(arg_10_1, 0)

			local var_10_5 = POSITION_LOOKUP[attacking_target]

			var_10_5 = var_10_5 or Unit.local_position(attacking_target, 0)

			local normalize = Vector3.normalize(var_10_5 - var_10_4)
			local has_extension_2 = ScriptUnit.has_extension(attacking_target, "locomotion_system")

			if not has_extension_2 then
				has_extension_2:add_external_velocity(player_push_speed_blocked * normalize, action.max_player_push_speed)
			end
		end
	end
end

BTAttackAction._attack = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local var_11_0 = arg_11_4

	if var_11_0.move_state ~= "attacking" then
		var_11_0.move_state = "attacking"

		Managers.state.network:anim_event(arg_11_1, var_11_0.attack_anim)
	end
end

local num_2 = 4

BTAttackAction._handle_movement = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local var_12_0 = arg_12_4
	local target_dist = arg_12_4.target_dist
	local attack_dodge_window_start = var_12_0.attack_dodge_window_start

	attack_dodge_window_start = not attack_dodge_window_start and arg_12_2 > var_12_0.attack_dodge_window_start

	if not (not attack_dodge_window_start and var_12_0.past_damage_in_attack) then
		local target_unit_status_extension = var_12_0.target_unit_status_extension

		if not target_unit_status_extension then
			local get_is_dodging = target_unit_status_extension:get_is_dodging()

			get_is_dodging = get_is_dodging or target_unit_status_extension:is_invisible()

			local flag = not not get_is_dodging or arg_12_2 > var_12_0.attack_rotation_lock_timer
			local flag_2 = not get_is_dodging and not not var_12_0.locked_attack_rotation or target_dist < num_2

			if not flag then
				local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_12_1, var_12_0.attacking_target)

				var_12_0.attack_rotation:store(rotation_towards_unit_flat)

				if not var_12_0.locked_attack_rotation then
					var_12_0.locked_attack_rotation = false
				end
			elseif not flag_2 then
				var_12_0.attack_rotation_lock_timer = arg_12_2 + arg_12_4.attack_dodge_window_duration
				var_12_0.locked_attack_rotation = true
			end
		end

		var_12_0.locomotion_extension:set_wanted_rotation(arg_12_4.attack_rotation:unbox())
	else
		var_12_0.locomotion_extension:set_wanted_rotation(arg_12_4.attack_rotation:unbox())
	end

	if not (not var_12_0.locked_attack_rotation and not var_12_0.attack_rotation_lock_timer and arg_12_2 > var_12_0.attack_rotation_lock_timer or not (target_dist > num_2)) then
		var_12_0.locked_attack_rotation = false
	end
end

BTAttackAction._get_attack_cooldown_finished_at = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local attacking_target = arg_13_2.attacking_target

	if not Unit.alive(attacking_target) then
		return false, 0
	end

	local diminishing_damage = arg_13_2.action.diminishing_damage

	if not diminishing_damage then
		return false, 0
	end

	local has_extension = ScriptUnit.has_extension(attacking_target, "ai_slot_system")

	if not (not has_extension and has_extension.has_slots_attached) then
		return false, 0
	end

	local num_occupied_slots = has_extension.num_occupied_slots

	if num_occupied_slots == 0 then
		return false, 0
	end

	local var_13_4 = diminishing_damage[math.min(num_occupied_slots, 9)]

	if not var_13_4 then
		local action = arg_13_2.action
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		if not action.diminishing_damage and not action.difficulty_diminishing_damage then
			var_13_4 = action.difficulty_diminishing_damage[get_difficulty][math.min(num_occupied_slots, 9)]
		end
	end

	local cooldown = var_13_4.cooldown
	local random = AiUtils.random(cooldown[1], cooldown[2])

	return true, random + arg_13_3
end

BTAttackAction.anim_cb_attack_vce = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	if not Managers.state.network:game() and not arg_14_2.target_unit_status_extension then
		Managers.state.entity:system("dialogue_system"):trigger_attack(arg_14_2, arg_14_2.target_unit, arg_14_1, false, false)
	end
end

BTAttackAction.anim_cb_attack_vce_long = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	if not Managers.state.network:game() and not arg_15_2.target_unit_status_extension then
		Managers.state.entity:system("dialogue_system"):trigger_attack(arg_15_2, arg_15_2.target_unit, arg_15_1, false, true)
	end
end

BTAttackAction.anim_cb_running_attack_start = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	if not Managers.state.network:game() then
		arg_16_2.anim_cb_running_attack_start = true
	end
end

BTAttackAction.anim_cb_attack_finished = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	if not arg_17_2.attack_finished then
		return
	end

	if not Managers.state.network:game() then
		arg_17_2.attacks_done = arg_17_2.attacks_done + 1
		arg_17_2.attack_finished = true
	end
end
