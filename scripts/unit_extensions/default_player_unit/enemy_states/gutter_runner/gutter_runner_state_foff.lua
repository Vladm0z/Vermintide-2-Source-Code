-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_foff.lua

GutterRunnerStateFoff = class(GutterRunnerStateFoff, EnemyCharacterStateWalking)

GutterRunnerStateFoff.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	GutterRunnerStateFoff.super.init(self, arg_1_1, "gutter_runner_foff")

	self._network_manager = Managers.state.network
end

GutterRunnerStateFoff.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self:set_breed_action("ninja_vanish")
	self._locomotion_extension:set_forced_velocity(Vector3:zero())
	self._locomotion_extension:set_wanted_velocity(Vector3.zero())

	self._enter_anim_time = arg_2_5 + self._breed.foff_enter_anim_time
	self.falling = false
	self.foffed = false

	self:on_enter_animation()
end

GutterRunnerStateFoff.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self:set_breed_action("n/a")
	self:on_exit_animation()

	if not (not Managers.state.network:game() and arg_3_6) then
		return
	end

	if not (not self.falling and arg_3_6 == "falling") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end
end

GutterRunnerStateFoff.on_enter_animation = function (self)
	-- function 4
	CharacterStateHelper.play_animation_event(self._unit, "foff_self")
	CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, "foff_self")
end

GutterRunnerStateFoff.on_exit_animation = function (self)
	-- function 5
	CharacterStateHelper.play_animation_event(self._unit, "idle")
	CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, "idle")
end

GutterRunnerStateFoff.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	if not self:common_state_changes() then
		return
	end

	if not (not (arg_6_5 > self._enter_anim_time) or self.foffed) then
		self:foff()

		self.foffed = true
	end
end

GutterRunnerStateFoff.foff = function (self)
	-- function 7
	local _unit = self._unit
	local _csm = self._csm
	local local_player = Managers.player:owner(_unit).local_player
	local unit_game_object_id = Managers.state.network:unit_game_object_id(_unit)

	unit_game_object_id = unit_game_object_id or NetworkConstants.invalid_game_object_id

	local str = "fx/chr_gutter_foff"

	Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect", NetworkLookup.effects[str], unit_game_object_id, 0, Vector3.zero(), Quaternion.identity(), false)
	self._buff_extension:add_buff("vs_gutter_runner_smoke_bomb_invisible", {
		attacker_unit = _unit
	})

	if not local_player then
		local _first_person_extension = self._first_person_extension
		local extension = ScriptUnit.extension(_unit, "career_system")

		_first_person_extension:play_unit_sound_event("Play_versus_gutterrunner_vanish_fps", _unit, 0)
		extension:set_state("vs_gutter_runner_smoke_bomb_invisible")
	end

	_csm:change_state("standing")
end
