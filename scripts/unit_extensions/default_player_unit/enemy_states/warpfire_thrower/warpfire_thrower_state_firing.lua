-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/warpfire_thrower/warpfire_thrower_state_firing.lua

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

WarpfireThrowerStateFiring = class(WarpfireThrowerStateFiring, EnemyCharacterState)

WarpfireThrowerStateFiring.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "warpfire_firing")

	self.current_movement_speed_scale = 0
	self.last_input_direction = Vector3Box(0, 0, 0)
end

local POSITION_LOOKUP = POSITION_LOOKUP

WarpfireThrowerStateFiring.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	table.clear(self._temp_params)

	self._unit_id = Managers.state.network.unit_storage:go_id(arg_2_1)

	local get_data = Unit.get_data(arg_2_1, "breed")

	self._breed = get_data
	self._blackboard = BLACKBOARDS[arg_2_1]

	local var_2_1 = Vector3(0, 0, 0)

	CharacterStateHelper.play_animation_event(arg_2_1, "attack_shoot_start")
	CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, "attack_shoot_start")

	self._done_priming = false
	self._prime_time = arg_2_5 + get_data.shoot_warpfire_prime_time
	self._max_prime_time = get_data.shoot_warpfire_prime_time
	self._max_flame_time = get_data.shoot_warpfire_max_flame_time
	self._current_flame_time = 0
	self._wind_up_movement_speed = get_data.shoot_warpfire_wind_up_movement_speed
	self.shoot_warpfire_movement_speed_mod = get_data.shoot_warpfire_movement_speed_mod

	if not self._first_person_extension then
		self.first_person_unit = self._first_person_extension:get_first_person_unit()
	end

	self.blackboard = BLACKBOARDS[self._unit]

	local warpfire_data = self.blackboard.warpfire_data

	warpfire_data = warpfire_data or {
		aim_rotation_override_speed_multiplier = 1.5,
		aim_rotation_override_distance = 3,
		warpfire_follow_target_speed = 0.75,
		muzzle_node = "p_fx",
		buff_name_close = "vs_warpfire_thrower_short_distance_damage",
		buff_name_far = "vs_warpfire_thrower_long_distance_damage",
		aim_rotation_dodge_multipler = 0.15,
		attack_range = get_data.shoot_warpfire_attack_range,
		close_attack_range = get_data.shoot_warpfire_close_attack_range,
		close_attack_cooldown = get_data.shoot_warpfire_close_attack_cooldown,
		hit_radius = get_data.shoot_warpfire_close_attack_hit_radius,
		target_position = Vector3Box(0, 0, 0)
	}
	warpfire_data.is_firing = false
	self._is_firing = false

	local peer_id = warpfire_data.peer_id

	peer_id = peer_id or Network.peer_id()
	warpfire_data.peer_id = peer_id
	self.blackboard.warpfire_data = warpfire_data
	self._create_fire_time = 0
	self._gravity = -9.82
	self._speed = 17
	self._angle = math.degrees_to_radians(math.pi / 4)

	self:set_breed_action("shoot_warpfire_thrower")
	Managers.state.entity:system("weapon_system"):change_single_weapon_state(arg_2_1, "windup_start", warpfire_data.peer_id)
end

WarpfireThrowerStateFiring.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local _csm = self._csm
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_3_1)
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension
	local _inventory_extension = self._inventory_extension

	if not self._done_priming then
		self:_update_priming(arg_3_1, arg_3_5, arg_3_3)
	end

	if not self._is_firing then
		self:_update_warpfire_attack(arg_3_1, arg_3_5, arg_3_3)
	end

	if not (self._current_flame_time >= self._max_flame_time) then
		_csm:change_state("standing")

		return
	end

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return
	end

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)

		return
	end

	if not _input_extension then
		return
	end

	local get = _input_extension:get("action_one_release")

	if not get then
		get = _input_extension:get("action_two")
		get = get or _input_extension:get("action_two_release")
	end

	if not get then
		_csm:change_state("standing")

		return
	end

	if not (not self._done_priming and self._is_firing) then
		self:_start_firing(arg_3_5)
	end

	self:_update_movement(arg_3_1, arg_3_5, arg_3_3)
	CharacterStateHelper.look(self._input_extension, self._player.viewport_name, self._first_person_extension, self._status_extension, self._inventory_extension)
end

WarpfireThrowerStateFiring._set_priming_progress = function (self, arg_4_1)
	-- function 4
	local _career_extension = self._career_extension
	local str = "fire"
	local ability_id = _career_extension:ability_id(str)

	_career_extension:get_activated_ability_data(ability_id).priming_progress = arg_4_1
end

WarpfireThrowerStateFiring._update_priming = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local flag = not self._done_priming

	if arg_5_2 > self._prime_time then
		self._done_priming = true
	end

	if not flag then
		local _prime_time = self._prime_time
		local _max_prime_time = self._max_prime_time
		local num = _max_prime_time - (_prime_time - arg_5_2)
		local clamp = math.clamp(num / _max_prime_time, 0, 1)

		self:_set_priming_progress(clamp)
		self:_update_movement(arg_5_1, arg_5_2, arg_5_3, clamp)
	end
end

WarpfireThrowerStateFiring._start_firing = function (self, arg_6_1)
	-- function 6
	self:_set_priming_progress(0)

	local _unit = self._unit
	local blackboard = self.blackboard
	local warpfire_data = blackboard.warpfire_data

	if not self:_create_warpfire_blob(_unit, warpfire_data, blackboard, arg_6_1) then
		blackboard.close_attack_cooldown = 0
	end

	local warpfire_data_2 = blackboard.warpfire_data

	warpfire_data_2.is_firing = true
	self._is_firing = true
	warpfire_data_2.state = "shoot_start"

	Managers.state.entity:system("weapon_system"):change_single_weapon_state(_unit, "shoot_start", warpfire_data_2.peer_id)
end

WarpfireThrowerStateFiring._stop_priming = function (self)
	-- function 7
	local _unit = self._unit
	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.play_animation_event(_unit, "idle")
	CharacterStateHelper.play_animation_event(_unit, "no_anim_upperbody")
end

WarpfireThrowerStateFiring._close_range_attack = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local get_enemies_in_line_of_sight = EnemyCharacterStateHelper.get_enemies_in_line_of_sight(arg_8_1, self.first_person_unit, self._physics_world)

	if not get_enemies_in_line_of_sight then
		return
	end

	for i = 1, #get_enemies_in_line_of_sight do
		local var_8_1 = get_enemies_in_line_of_sight[i]
		local unit = var_8_1.unit
		local is_enemy = DamageUtils.is_enemy(arg_8_1, unit)

		if not is_enemy then
			local has_extension = ScriptUnit.has_extension(unit, "buff_system")
			local flag = not has_extension and has_extension:has_buff_perk(scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.power_block)
			local has_extension_2 = ScriptUnit.has_extension(unit, "status_system")
			local var_8_7
			local var_8_8

			if not has_extension_2 then
				var_8_7, var_8_8 = has_extension_2:is_blocking()
			end

			if not flag and not var_8_7 and not var_8_8 then
				is_enemy = not DamageUtils.check_ranged_block(arg_8_1, unit, "blocked_berzerker")
			end

			if not is_enemy then
				local buff_name_close

				if var_8_1.distance <= arg_8_3.close_attack_range then
					buff_name_close = arg_8_3.buff_name_close

					if not buff_name_close then
						-- Nothing
					end
				end

				buff_name_close = arg_8_3.buff_name_far

				::label_8_0::

				local tbl = {
					attacker_unit = arg_8_1
				}
				local system = Managers.state.entity:system("buff_system")

				system:add_buff_synced(unit, buff_name_close, BuffSyncType.All, tbl)
				system:add_buff_synced(unit, "warpfire_thrower_fire_slowdown", BuffSyncType.All, tbl)
			end
		end
	end
end

local function fn(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	local num = arg_9_2 / arg_9_1

	for i = 1, arg_9_1 do
		local num_2 = arg_9_3 + arg_9_4 * num
		local num_3 = num_2 - arg_9_3
		local normalize = Vector3.normalize(num_3)
		local length = Vector3.length(num_3)
		local immediate_raycast, var_9_6, var_9_7, var_9_8, var_9_9 = PhysicsWorld.immediate_raycast(arg_9_0, arg_9_3, normalize, length, "closest", "collision_filter", arg_9_6)

		if not var_9_6 then
			return immediate_raycast, var_9_6, var_9_7, var_9_8, var_9_9
		end

		arg_9_4 = arg_9_4 + arg_9_5 * num
		arg_9_3 = num_2
	end

	return false, arg_9_3
end

WarpfireThrowerStateFiring._update_warpfire_attack = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	self._current_flame_time = self._current_flame_time + arg_10_3

	local blackboard = self.blackboard
	local warpfire_data = blackboard.warpfire_data

	if arg_10_2 > blackboard.close_attack_cooldown then
		self:_close_range_attack(arg_10_1, blackboard, warpfire_data, arg_10_2)

		blackboard.close_attack_cooldown = arg_10_2 + warpfire_data.close_attack_cooldown
	end
end

local flag = false

WarpfireThrowerStateFiring.hit_ground_at = function (self)
	-- function 11
	local var_11_0 = POSITION_LOOKUP[self._unit]
	local var_11_1 = POSITION_LOOKUP[self.first_person_unit]
	local world_rotation = Unit.world_rotation(self.first_person_unit, 0)
	local var_11_3
	local num = 10
	local num_2 = 1.5
	local _speed = self._speed
	local _angle = self._angle
	local num_3 = Quaternion.forward(Quaternion.multiply(world_rotation, Quaternion(Vector3.right(), _angle))) * _speed
	local var_11_9 = Vector3(0, 0, self._gravity)
	local str = "filter_geiser_check"
	local var_11_11, var_11_12, var_11_13, var_11_14 = fn(self._physics_world, num, num_2, var_11_1, num_3, var_11_9, str, flag)
	local var_11_15 = var_11_12

	if not var_11_11 then
		local var_11_16 = Vector3(0, 0, 1)

		if Vector3.dot(var_11_14, var_11_16) < 0.75 then
			local num_4 = var_11_15 - 1 * Vector3.normalize(var_11_15 - var_11_0)
			local immediate_raycast, var_11_19, var_11_20, var_11_21 = PhysicsWorld.immediate_raycast(self._physics_world, num_4, Vector3(0, 0, -1), 5, "closest", "collision_filter", str)

			if not var_11_19 then
				var_11_15 = var_11_19
			end
		end
	end

	return var_11_15, var_11_0
end

WarpfireThrowerStateFiring._move_warpfire_blob = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local blob_unit = arg_12_2.blob_unit
	local var_12_1 = POSITION_LOOKUP[blob_unit]

	if not blob_unit and not var_12_1 then
		local var_12_2 = POSITION_LOOKUP[arg_12_1]
		local unbox = arg_12_2.target_position:unbox()
		local flat = Vector3.flat(unbox - var_12_2)
		local length = Vector3.length(flat)
		local var_12_6
		local var_12_7
		local close_attack_range = arg_12_2.close_attack_range
		local warpfire_follow_target_speed = arg_12_2.warpfire_follow_target_speed

		if close_attack_range < length then
			var_12_6 = math.min(arg_12_4 * warpfire_follow_target_speed, 1)
			var_12_7 = unbox
		else
			var_12_6 = math.min(arg_12_4 * warpfire_follow_target_speed * 6, 1)
			var_12_7 = var_12_2 + Vector3.normalize(unbox - var_12_2) * close_attack_range
		end

		local lerp = Vector3.lerp(var_12_1, var_12_7, var_12_6)

		Unit.set_local_position(blob_unit, 0, lerp)
	end
end

WarpfireThrowerStateFiring._create_warpfire_blob = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local warpfire_data = arg_13_3.warpfire_data
	local weapon_unit = arg_13_3.weapon_unit
	local hit_ground_at, var_13_3 = self:hit_ground_at()

	if not hit_ground_at then
		return false
	end

	warpfire_data.target_position:store(hit_ground_at)

	local tbl = {
		area_damage_system = {
			damage_blob_template_name = "warpfire_vs",
			source_unit = arg_13_1
		}
	}
	local str = "units/hub_elements/empty"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "damage_blob_unit", tbl, hit_ground_at)
	local extension = ScriptUnit.extension(spawn_network_unit, "area_damage_system")

	warpfire_data.blob_unit = spawn_network_unit
	warpfire_data.blob_extension = extension

	local num = Vector3.length(hit_ground_at - var_13_3) / 10

	extension:start_placing_blobs(num, arg_13_4)

	self._create_fire_time = arg_13_4 + 9999999

	return true
end

WarpfireThrowerStateFiring.on_exit = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	if not Managers.state.network:in_game_session() then
		return
	end

	local _csm = self._csm
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "attack_finished")
	CharacterStateHelper.play_animation_event(arg_14_1, "no_anim_upperbody")

	local warpfire_data = self.blackboard.warpfire_data

	if not warpfire_data.is_firing then
		local clamp = math.clamp((self._max_flame_time - self._current_flame_time) / self._max_flame_time - self._breed.shoot_warpfire_minimum_forced_cooldown, 0, 1)

		self._career_extension:start_activated_ability_cooldown(1, clamp)
		Managers.state.entity:system("weapon_system"):change_single_weapon_state(arg_14_1, "shoot_end", warpfire_data.peer_id)

		warpfire_data.is_firing = false

		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "wind_up_start")
		CharacterStateHelper.play_animation_event(arg_14_1, "wind_up_start")
		_first_person_extension:play_hud_sound_event("player_enemy_warpfire_steam_after_flame_start")
	end

	if not warpfire_data.blob_extension then
		warpfire_data.blob_extension:stop_placing_blobs(arg_14_5)
	end

	self._max_flame_time = nil
	self._done_priming = false
	self._prime_time = nil
	self._current_flame_time = nil

	self:set_breed_action("n/a")
	self:_set_priming_progress(0)
end

WarpfireThrowerStateFiring._update_movement = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local _input_extension = self._input_extension
	local _buff_extension = self._buff_extension
	local _first_person_extension = self._first_person_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_15_1)
	local get_movement_input = CharacterStateHelper.get_movement_input(_input_extension)
	local has_move_input = CharacterStateHelper.has_move_input(_input_extension)
	local current_movement_speed_scale = self.current_movement_speed_scale

	if not self.is_bot then
		local _breed = self._breed

		_breed = not _breed and self._breed.breed_move_acceleration_up

		local _breed_2 = self._breed

		_breed_2 = not _breed_2 and self._breed.breed_move_acceleration_down

		local num = _breed * arg_15_3

		num = num or get_movement_settings_table.move_acceleration_up * arg_15_3

		local num_2 = _breed_2 * arg_15_3

		num_2 = num_2 or get_movement_settings_table.move_acceleration_down * arg_15_3

		if not has_move_input then
			current_movement_speed_scale = math.min(1, current_movement_speed_scale + num)
		else
			current_movement_speed_scale = math.max(0, current_movement_speed_scale - num_2)
		end
	else
		current_movement_speed_scale = not has_move_input and 1 and 0
	end

	local num_3 = 1
	local flag

	flag = not self._is_firing and 1 and self._career_extension:get_activated_ability_data(1).priming_progress

	local lerp = math.lerp(self._wind_up_movement_speed.start, self._wind_up_movement_speed.finish, flag^self._wind_up_movement_speed.rate)
	local num_4 = _buff_extension:apply_buffs_to_value(lerp, "movement_speed") * current_movement_speed_scale * get_movement_settings_table.player_speed_scale * self.shoot_warpfire_movement_speed_mod
	local var_15_15 = Vector3(0, 0, 0)

	if not get_movement_input then
		var_15_15 = var_15_15 + get_movement_input
	end

	local var_15_16
	local normalize = Vector3.normalize(var_15_15)

	if Vector3.length(normalize) == 0 then
		normalize = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize)
	end

	local get_move_animation = CharacterStateHelper.get_move_animation(self._locomotion_extension, _input_extension, self._status_extension, self.move_anim_3p)

	if get_move_animation ~= self.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_15_1, get_move_animation)

		self.move_anim_3p = get_move_animation
	end

	if not (self._previous_state == "jumping" or self._previous_state ~= "falling") then
		CharacterStateHelper.move_in_air_pactsworn(self._first_person_extension, _input_extension, self._locomotion_extension, num_4, arg_15_1)
	else
		CharacterStateHelper.move_on_ground(_first_person_extension, _input_extension, self._locomotion_extension, normalize, num_4, arg_15_1)
	end

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, self._status_extension, self._inventory_extension)

	self.current_movement_speed_scale = current_movement_speed_scale

	if arg_15_2 > self._prime_time then
		self._done_priming = true
		self._is_priming = false
	end
end
