-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_foff.lua

GutterRunnerStateFoff = class(GutterRunnerStateFoff, EnemyCharacterStateWalking)

GutterRunnerStateFoff.init = function (arg_1_0, arg_1_1, arg_1_2)
	GutterRunnerStateFoff.super.init(arg_1_0, arg_1_1, "gutter_runner_foff")

	arg_1_0._network_manager = Managers.state.network
end

GutterRunnerStateFoff.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0:set_breed_action("ninja_vanish")
	arg_2_0._locomotion_extension:set_forced_velocity(Vector3:zero())
	arg_2_0._locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_0._enter_anim_time = arg_2_5 + arg_2_0._breed.foff_enter_anim_time
	arg_2_0.falling = false
	arg_2_0.foffed = false

	arg_2_0:on_enter_animation()
end

GutterRunnerStateFoff.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0:set_breed_action("n/a")
	arg_3_0:on_exit_animation()

	if not Managers.state.network:game() or not arg_3_6 then
		return
	end

	if arg_3_0.falling and arg_3_6 ~= "falling" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end
end

GutterRunnerStateFoff.on_enter_animation = function (arg_4_0)
	CharacterStateHelper.play_animation_event(arg_4_0._unit, "foff_self")
	CharacterStateHelper.play_animation_event_first_person(arg_4_0._first_person_extension, "foff_self")
end

GutterRunnerStateFoff.on_exit_animation = function (arg_5_0)
	CharacterStateHelper.play_animation_event(arg_5_0._unit, "idle")
	CharacterStateHelper.play_animation_event_first_person(arg_5_0._first_person_extension, "idle")
end

GutterRunnerStateFoff.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if arg_6_0:common_state_changes() then
		return
	end

	if arg_6_5 > arg_6_0._enter_anim_time and not arg_6_0.foffed then
		arg_6_0:foff()

		arg_6_0.foffed = true
	end
end

GutterRunnerStateFoff.foff = function (arg_7_0)
	local var_7_0 = arg_7_0._unit
	local var_7_1 = arg_7_0._csm
	local var_7_2 = Managers.player:owner(var_7_0).local_player
	local var_7_3 = Managers.state.network:unit_game_object_id(var_7_0) or NetworkConstants.invalid_game_object_id
	local var_7_4 = "fx/chr_gutter_foff"

	Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect", NetworkLookup.effects[var_7_4], var_7_3, 0, Vector3.zero(), Quaternion.identity(), false)
	arg_7_0._buff_extension:add_buff("vs_gutter_runner_smoke_bomb_invisible", {
		attacker_unit = var_7_0
	})

	if var_7_2 then
		local var_7_5 = arg_7_0._first_person_extension
		local var_7_6 = ScriptUnit.extension(var_7_0, "career_system")

		var_7_5:play_unit_sound_event("Play_versus_gutterrunner_vanish_fps", var_7_0, 0)
		var_7_6:set_state("vs_gutter_runner_smoke_bomb_invisible")
	end

	var_7_1:change_state("standing")
end
