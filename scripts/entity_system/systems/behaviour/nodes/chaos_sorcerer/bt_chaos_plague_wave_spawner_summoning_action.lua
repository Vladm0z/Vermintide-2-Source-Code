-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_plague_wave_spawner_summoning_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosPlagueWaveSpawnerSummoningAction = class(BTChaosPlagueWaveSpawnerSummoningAction, BTNode)
BTChaosPlagueWaveSpawnerSummoningAction.name = "BTChaosPlagueWaveSpawnerSummoningAction"

local var_0_0 = BTChaosPlagueWaveSpawnerSummoningAction

function var_0_0.init(arg_1_0, ...)
	var_0_0.super.init(arg_1_0, ...)
end

function var_0_0.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = arg_2_2.breed

	arg_2_2.action = var_2_0

	local var_2_2 = arg_2_2.target_dist

	arg_2_2.ready_to_summon = false

	if not arg_2_2.plague_wave_data then
		arg_2_2.plague_wave_data = {
			plague_wave_timer = arg_2_3 + var_2_0.plague_wave_spawn_cooldown,
			physics_world = World.get_data(arg_2_2.world, "physics_world"),
			target_starting_pos = Vector3Box(),
			plague_wave_rot = QuaternionBox()
		}
	end
end

function var_0_0.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.action = nil
end

function var_0_0.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.action
	local var_4_1 = arg_4_2.plague_wave_data
	local var_4_2 = arg_4_2.skulk_data
	local var_4_3 = arg_4_2.target_unit
	local var_4_4 = arg_4_2.external_event_name
	local var_4_5 = arg_4_2.external_event_value
	local var_4_6 = var_4_0.plague_wave_spawn_cooldown

	if var_4_4 and var_4_4 == var_4_0.external_event_name then
		var_4_6 = var_4_5
	end

	if var_4_5 and var_4_5 >= 100 then
		Managers.state.conflict:destroy_unit(arg_4_1, arg_4_2, "plague_wave_spawner")

		return
	end

	local var_4_7 = var_4_0.anticipation_fx

	if not arg_4_2.anticipation_fx_id and var_4_7 and arg_4_3 > var_4_1.plague_wave_timer - var_4_0.anticipation_fx_offset_time then
		local var_4_8 = arg_4_2.world

		arg_4_2.anticipation_fx_id = World.create_particles(var_4_8, var_4_7, POSITION_LOOKUP[arg_4_1], Quaternion.identity())
	end

	if arg_4_3 > var_4_1.plague_wave_timer and not ScriptUnit.extension(var_4_3, "status_system"):is_invisible() then
		local var_4_9 = arg_4_2.nav_world
		local var_4_10 = POSITION_LOOKUP[var_4_3]
		local var_4_11 = POSITION_LOOKUP[arg_4_1]
		local var_4_12 = LocomotionUtils.pos_on_mesh(var_4_9, var_4_11, 1, 1)
		local var_4_13 = LocomotionUtils.pos_on_mesh(var_4_9, var_4_10, 1, 1)

		if var_4_12 and var_4_13 and GwNavQueries.raycango(var_4_9, var_4_12, var_4_13) then
			var_4_1.plague_wave_timer = arg_4_3 + var_4_6 or var_4_0.plague_wave_spawn_cooldown
			arg_4_2.ready_to_summon = true
			arg_4_2.summoning_finished = true
			arg_4_2.anticipation_fx_id = nil
		else
			var_4_1.plague_wave_timer = arg_4_3 + 2
		end

		return "done"
	end

	return "running"
end
