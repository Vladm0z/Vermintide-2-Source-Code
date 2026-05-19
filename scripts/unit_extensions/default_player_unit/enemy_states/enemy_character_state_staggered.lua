-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_staggered.lua

local var_0_0 = require("scripts/utils/stagger_types")

EnemyCharacterStateStaggered = class(EnemyCharacterStateStaggered, EnemyCharacterState)

function EnemyCharacterStateStaggered.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "staggered")

	arg_1_0._status_extension = nil
	arg_1_0._stagger_time_scale = 1.5

	arg_1_0:reset_stagger()

	arg_1_0._last_stagger_anim = nil
end

function EnemyCharacterStateStaggered.reset_stagger(arg_2_0)
	arg_2_0._accumulated_stagger = 0
	arg_2_0._stagger_type = nil
end

function EnemyCharacterStateStaggered._select_animation(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = Vector3.normalize(arg_3_2)
	local var_3_1 = Quaternion.forward(Unit.local_rotation(arg_3_1, 0))
	local var_3_2 = Vector3.dot(var_3_1, var_3_0)
	local var_3_3 = math.clamp(var_3_2, -1, 1)
	local var_3_4 = math.acos(var_3_3)
	local var_3_5 = arg_3_0._locomotion_extension:current_velocity()
	local var_3_6 = Vector3.dot(var_3_5, var_3_1)
	local var_3_7 = arg_3_4.moving_stagger_minimum_destination_distance
	local var_3_8 = arg_3_4.action_data
	local var_3_9 = var_3_7 and var_3_7 < blackboard.destination_dist
	local var_3_10 = var_3_8 and var_3_8 < var_3_6
	local var_3_11
	local var_3_12
	local var_3_13 = arg_3_0._status_extension:always_stagger_suffered()
	local var_3_14 = false

	if not var_3_13 then
		var_3_14 = var_3_9 and var_3_10
	end

	arg_3_0._status_extension:set_always_stagger_suffered(false)

	if var_3_0.z == -1 and arg_3_3.dwn then
		var_3_0.z = 0
		var_3_11 = Quaternion.look(-var_3_0)
		var_3_12 = var_3_14 and arg_3_3.moving_dwn or arg_3_3.dwn
	else
		var_3_0.z = 0

		if var_3_4 > math.pi * 0.75 then
			var_3_11 = Quaternion.look(-var_3_0)
			var_3_12 = var_3_14 and arg_3_3.moving_bwd or arg_3_3.bwd
		elseif var_3_4 < math.pi * 0.25 then
			var_3_11 = Quaternion.look(var_3_0)
			var_3_12 = var_3_14 and arg_3_3.moving_fwd or arg_3_3.fwd
		elseif Vector3.cross(var_3_1, var_3_0).z > 0 then
			local var_3_15 = Vector3.cross(Vector3(0, 0, -1), var_3_0)

			var_3_11 = Quaternion.look(var_3_15)
			var_3_12 = var_3_14 and arg_3_3.moving_left or arg_3_3.left
		else
			local var_3_16 = Vector3.cross(Vector3(0, 0, 1), var_3_0)

			var_3_11 = Quaternion.look(var_3_16)
			var_3_12 = var_3_14 and arg_3_3.moving_right or arg_3_3.right
		end
	end

	local var_3_17 = #var_3_12
	local var_3_18 = Math.random(1, var_3_17)
	local var_3_19 = var_3_12[var_3_18]

	if var_3_19 == arg_3_0._last_stagger_anim then
		var_3_19 = var_3_12[var_3_18 % var_3_17 + 1]
	end

	local var_3_20 = Quaternion.yaw(var_3_11)
	local var_3_21 = Quaternion(Vector3.up(), var_3_20)

	return var_3_19, var_3_21
end

function EnemyCharacterStateStaggered.on_enter(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	Managers.state.camera:set_mood("staggered", arg_4_0, true)

	arg_4_0._exit_anim_triggered = false

	CharacterStateHelper.move_on_ground(arg_4_0._first_person_extension, arg_4_2, arg_4_0._locomotion_extension, Vector3(0, 0, 0), 0, arg_4_1)
	CharacterStateHelper.stop_weapon_actions(arg_4_0._inventory_extension, "stunned")
	CharacterStateHelper.stop_career_abilities(arg_4_0._career_extension, "stunned")
	CharacterStateHelper.play_animation_event_first_person(arg_4_0._first_person_extension, "interrupt")

	arg_4_0._status_extension = ScriptUnit.has_extension(arg_4_1, "status_system")

	local var_4_0 = arg_4_0._status_extension
	local var_4_1 = var_4_0:accumulated_stagger()
	local var_4_2 = arg_4_0._accumulated_stagger > 0 and arg_4_0._accumulated_stagger ~= var_4_1

	arg_4_0._accumulated_stagger = var_4_1
	arg_4_0._stagger_type = var_4_0:stagger_type()

	local var_4_3 = Unit.get_data(arg_4_1, "breed")
	local var_4_4 = BreedActions[var_4_3.name].stagger

	arg_4_0:set_breed_action("stagger")
	var_4_0:set_stagger_animation_done(false)

	arg_4_0._stagger_hit_wall = nil
	arg_4_0._stagger_ignore_anim_cb = var_4_3.stagger_ignore_anim_cb

	var_4_0:increase_stagger_count()

	local var_4_5 = "idle"
	local var_4_6 = var_4_4.stagger_anims[arg_4_0._stagger_type]
	local var_4_7 = var_4_0:stagger_direction():unbox()
	local var_4_8, var_4_9 = arg_4_0:_select_animation(arg_4_1, var_4_7, var_4_6, var_4_4)

	Unit.set_local_rotation(arg_4_1, 0, var_4_9)

	local var_4_10 = Managers.state.network

	if arg_4_0._stagger_time_scale then
		local var_4_11 = arg_4_0._stagger_time_scale

		var_4_10:anim_event_with_variable_float(arg_4_1, var_4_8, "stagger_scale", var_4_11)
	else
		var_4_10:anim_event(arg_4_1, var_4_8)
	end

	var_4_10:anim_event(arg_4_1, var_4_5)

	if not var_4_2 then
		arg_4_0._locomotion_extension:enable_animation_driven_movement(false)
	end

	if arg_4_0._player.local_player and not arg_4_0._player.bot_player then
		WwiseWorld.trigger_event(arg_4_0._wwise_world, "Play_versus_hud_pactsworn_stagger_1p")
	end

	if arg_4_0._breed.boss and arg_4_0._stagger_type > 1 then
		Managers.state.entity:system("buff_system"):add_buff_synced(arg_4_1, "vs_boss_stagger_immune", BuffSyncType.Server)
	end
end

function EnemyCharacterStateStaggered.on_exit(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	arg_5_0:reset_stagger()
	arg_5_0._status_extension:set_stagger_values(var_0_0.none, Vector3(0, 0, 0), 0, 0, 0, 1, false, true)
	arg_5_0._locomotion_extension:enable_script_driven_movement()
	arg_5_0._first_person_extension:set_wanted_player_height("stand", arg_5_5)
	arg_5_0:set_breed_action("n/a")
	Managers.state.camera:set_mood("staggered", arg_5_0, false)
end

function EnemyCharacterStateStaggered.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0._csm
	local var_6_1 = arg_6_0._status_extension
	local var_6_2 = arg_6_0._locomotion_extension
	local var_6_3 = var_6_1:accumulated_stagger()

	if arg_6_0._accumulated_stagger ~= var_6_3 then
		arg_6_0:on_enter(arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, "staggered", nil)
	end

	local var_6_4 = var_6_1:stagger_animation_done()
	local var_6_5 = var_6_1:stagger_time()
	local var_6_6 = var_6_1:stagger_immune_time()
	local var_6_7 = var_6_1:heavy_stagger_immune_time()
	local var_6_8 = var_6_5 < arg_6_5
	local var_6_9

	var_6_9 = arg_6_5 > var_6_5 - 0.3333333333333333

	if var_6_6 and var_6_8 then
		var_6_1:set_stagger_immune_time(nil)
	end

	if var_6_7 and var_6_8 then
		var_6_1:set_heavy_stagger_immune_time(nil)
	end

	if var_6_8 or not arg_6_0._stagger_ignore_anim_cb and var_6_4 then
		if not var_6_0.state_next and not var_6_2:is_on_ground() then
			var_6_0:change_state("falling")
		else
			var_6_0:change_state("standing")
		end

		return
	end

	var_6_2:set_disable_rotation_update()

	local var_6_10 = 0.5

	CharacterStateHelper.look(arg_6_0._input_extension, arg_6_0._player.viewport_name, arg_6_0._first_person_extension, arg_6_0._status_extension, arg_6_0._inventory_extension, var_6_10)
end
