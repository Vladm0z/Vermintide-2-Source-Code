-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_staggered.lua

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

EnemyCharacterStateStaggered = class(EnemyCharacterStateStaggered, EnemyCharacterState)

EnemyCharacterStateStaggered.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "staggered")

	self._status_extension = nil
	self._stagger_time_scale = 1.5

	self:reset_stagger()

	self._last_stagger_anim = nil
end

EnemyCharacterStateStaggered.reset_stagger = function (self)
	-- function 2
	self._accumulated_stagger = 0
	self._stagger_type = nil
end

EnemyCharacterStateStaggered._select_animation = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local normalize = Vector3.normalize(arg_3_2)
	local forward = Quaternion.forward(Unit.local_rotation(arg_3_1, 0))
	local dot = Vector3.dot(forward, normalize)
	local clamp = math.clamp(dot, -1, 1)
	local acos = math.acos(clamp)
	local current_velocity = self._locomotion_extension:current_velocity()
	local dot_2 = Vector3.dot(current_velocity, forward)
	local moving_stagger_minimum_destination_distance = arg_3_4.moving_stagger_minimum_destination_distance
	local action_data = arg_3_4.action_data
	local flag = not moving_stagger_minimum_destination_distance and moving_stagger_minimum_destination_distance < blackboard.destination_dist
	local flag_2 = not action_data and action_data < dot_2
	local var_3_11
	local var_3_12
	local always_stagger_suffered = self._status_extension:always_stagger_suffered()
	local flag_3 = false

	if not always_stagger_suffered then
		flag_3 = not flag and flag_2
	end

	self._status_extension:set_always_stagger_suffered(false)

	if normalize.z ~= -1 or not arg_3_3.dwn then
		normalize.z = 0
		var_3_11 = Quaternion.look(-normalize)
		var_3_12 = not flag_3 and arg_3_3.moving_dwn and arg_3_3.dwn
	else
		normalize.z = 0

		if acos > math.pi * 0.75 then
			var_3_11 = Quaternion.look(-normalize)
			var_3_12 = not flag_3 and arg_3_3.moving_bwd and arg_3_3.bwd
		elseif acos < math.pi * 0.25 then
			var_3_11 = Quaternion.look(normalize)
			var_3_12 = not flag_3 and arg_3_3.moving_fwd and arg_3_3.fwd
		elseif Vector3.cross(forward, normalize).z > 0 then
			local cross = Vector3.cross(Vector3(0, 0, -1), normalize)

			var_3_11 = Quaternion.look(cross)
			var_3_12 = not flag_3 and arg_3_3.moving_left and arg_3_3.left
		else
			local cross_2 = Vector3.cross(Vector3(0, 0, 1), normalize)

			var_3_11 = Quaternion.look(cross_2)
			var_3_12 = not flag_3 and arg_3_3.moving_right and arg_3_3.right
		end
	end

	local count = #var_3_12
	local random = Math.random(1, count)
	local var_3_19 = var_3_12[random]

	if var_3_19 == self._last_stagger_anim then
		var_3_19 = var_3_12[random % count + 1]
	end

	local yaw = Quaternion.yaw(var_3_11)
	local var_3_21 = Quaternion(Vector3.up(), yaw)

	return var_3_19, var_3_21
end

EnemyCharacterStateStaggered.on_enter = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	-- function 4
	Managers.state.camera:set_mood("staggered", self, true)

	self._exit_anim_triggered = false

	CharacterStateHelper.move_on_ground(self._first_person_extension, arg_4_2, self._locomotion_extension, Vector3(0, 0, 0), 0, arg_4_1)
	CharacterStateHelper.stop_weapon_actions(self._inventory_extension, "stunned")
	CharacterStateHelper.stop_career_abilities(self._career_extension, "stunned")
	CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, "interrupt")

	self._status_extension = ScriptUnit.has_extension(arg_4_1, "status_system")

	local _status_extension = self._status_extension
	local accumulated_stagger = _status_extension:accumulated_stagger()
	local flag = not (self._accumulated_stagger > 0) or self._accumulated_stagger ~= accumulated_stagger

	self._accumulated_stagger = accumulated_stagger
	self._stagger_type = _status_extension:stagger_type()

	local get_data = Unit.get_data(arg_4_1, "breed")
	local stagger = BreedActions[get_data.name].stagger

	self:set_breed_action("stagger")
	_status_extension:set_stagger_animation_done(false)

	self._stagger_hit_wall = nil
	self._stagger_ignore_anim_cb = get_data.stagger_ignore_anim_cb

	_status_extension:increase_stagger_count()

	local str = "idle"
	local var_4_6 = stagger.stagger_anims[self._stagger_type]
	local unbox = _status_extension:stagger_direction():unbox()
	local _select_animation, var_4_9 = self:_select_animation(arg_4_1, unbox, var_4_6, stagger)

	Unit.set_local_rotation(arg_4_1, 0, var_4_9)

	local network = Managers.state.network

	if not self._stagger_time_scale then
		local _stagger_time_scale = self._stagger_time_scale

		network:anim_event_with_variable_float(arg_4_1, _select_animation, "stagger_scale", _stagger_time_scale)
	else
		network:anim_event(arg_4_1, _select_animation)
	end

	network:anim_event(arg_4_1, str)

	if not flag then
		self._locomotion_extension:enable_animation_driven_movement(false)
	end

	if not (not self._player.local_player and self._player.bot_player) then
		WwiseWorld.trigger_event(self._wwise_world, "Play_versus_hud_pactsworn_stagger_1p")
	end

	if not (not self._breed.boss and not (self._stagger_type > 1)) then
		Managers.state.entity:system("buff_system"):add_buff_synced(arg_4_1, "vs_boss_stagger_immune", BuffSyncType.Server)
	end
end

EnemyCharacterStateStaggered.on_exit = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	self:reset_stagger()
	self._status_extension:set_stagger_values(scripts_utils_stagger_types.none, Vector3(0, 0, 0), 0, 0, 0, 1, false, true)
	self._locomotion_extension:enable_script_driven_movement()
	self._first_person_extension:set_wanted_player_height("stand", arg_5_5)
	self:set_breed_action("n/a")
	Managers.state.camera:set_mood("staggered", self, false)
end

EnemyCharacterStateStaggered.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local _csm = self._csm
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local accumulated_stagger = _status_extension:accumulated_stagger()

	if self._accumulated_stagger ~= accumulated_stagger then
		self:on_enter(arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, "staggered", nil)
	end

	local stagger_animation_done = _status_extension:stagger_animation_done()
	local stagger_time = _status_extension:stagger_time()
	local stagger_immune_time = _status_extension:stagger_immune_time()
	local heavy_stagger_immune_time = _status_extension:heavy_stagger_immune_time()
	local flag = stagger_time < arg_6_5
	local flag_2

	flag_2 = arg_6_5 > stagger_time - 0.3333333333333333

	if not stagger_immune_time and not flag then
		_status_extension:set_stagger_immune_time(nil)
	end

	if not heavy_stagger_immune_time and not flag then
		_status_extension:set_heavy_stagger_immune_time(nil)
	end

	if flag or self._stagger_ignore_anim_cb or not stagger_animation_done then
		if not (_csm.state_next or _locomotion_extension:is_on_ground()) then
			_csm:change_state("falling")
		else
			_csm:change_state("standing")
		end

		return
	end

	_locomotion_extension:set_disable_rotation_update()

	local num = 0.5

	CharacterStateHelper.look(self._input_extension, self._player.viewport_name, self._first_person_extension, self._status_extension, self._inventory_extension, num)
end
