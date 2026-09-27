-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_jump_across.lua

EnemyCharacterStateJumpAcross = class(EnemyCharacterStateJumpAcross, EnemyCharacterStateAnimatedJump)

local function fn(self)
	-- function 1
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

EnemyCharacterStateJumpAcross.init = function (arg_2_0, arg_2_1)
	-- function 2
	EnemyCharacterStateJumpAcross.super.init(arg_2_0, arg_2_1, "jump_across")
end

EnemyCharacterStateJumpAcross.setup_transition = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self.smart_object_data = arg_3_2

	local var_3_0 = POSITION_LOOKUP[arg_3_1]

	self._entrance_pos = Vector3Box(var_3_0)
	self._exit_pos = Vector3Box(arg_3_4)
	self._sub_state = "moving_to_to_entrance"

	self._locomotion_extension:set_animation_translation_scale(Vector3(1, 1, 1))

	self.jump_ledge_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(arg_3_4 - var_3_0)))
end

EnemyCharacterStateJumpAcross.do_the_transition = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if self._sub_state == "moving_to_to_entrance" then
		local unbox = self._entrance_pos:unbox()
		local unbox_2 = self._exit_pos:unbox()

		arg_4_4:enable_animation_driven_movement_entrance_and_exit_no_mover(unbox, unbox_2)

		local unbox_3 = self.jump_ledge_lookat_direction:unbox()
		local look = Quaternion.look(unbox_3)

		self._first_person_extension:set_rotation(look)

		local num = unbox_2 - unbox
		local length = Vector3.length(Vector3.flat(num))
		local jump_across_anim_thresholds = SmartObjectSettings.templates[self._breed.smart_object_template].jump_across_anim_thresholds

		for i = 1, #jump_across_anim_thresholds do
			local var_4_7 = jump_across_anim_thresholds[i]

			if length < var_4_7.horizontal_threshold then
				Managers.state.network:anim_event(arg_4_1, fn(var_4_7.animation_jump))

				local num_2 = length / var_4_7.horizontal_length
				local z = num.z

				arg_4_4:set_animation_translation_scale(Vector3(num_2, num_2, z))

				break
			end
		end

		ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = true
		self._sub_state = "waiting_for_finished_climb_anim"
	end

	if self._sub_state ~= "waiting_for_finished_climb_anim" or not BLACKBOARDS[arg_4_1].jump_start_finished then
		self._sub_state = "done"
	end

	if not (self._sub_state == "done" or not (arg_4_2 > self._fail_timer)) then
		if arg_4_2 > self._fail_timer then
			Application.warning("Breed " .. Unit.get_data(arg_4_1, "breed").name .. " failed to jump across at position %q", self._entrance_pos:unbox())
		end

		return true
	end
end
