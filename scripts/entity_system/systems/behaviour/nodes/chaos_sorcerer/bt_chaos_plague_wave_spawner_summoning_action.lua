-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_plague_wave_spawner_summoning_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosPlagueWaveSpawnerSummoningAction = class(BTChaosPlagueWaveSpawnerSummoningAction, BTNode)
BTChaosPlagueWaveSpawnerSummoningAction.name = "BTChaosPlagueWaveSpawnerSummoningAction"

local BTChaosPlagueWaveSpawnerSummoningAction = BTChaosPlagueWaveSpawnerSummoningAction

BTChaosPlagueWaveSpawnerSummoningAction.init = function (arg_1_0, ...)
	-- function 1
	BTChaosPlagueWaveSpawnerSummoningAction.super.init(arg_1_0, ...)
end

BTChaosPlagueWaveSpawnerSummoningAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local breed = arg_2_2.breed

	arg_2_2.action = action_data

	local target_dist = arg_2_2.target_dist

	arg_2_2.ready_to_summon = false

	if not arg_2_2.plague_wave_data then
		arg_2_2.plague_wave_data = {
			plague_wave_timer = arg_2_3 + action_data.plague_wave_spawn_cooldown,
			physics_world = World.get_data(arg_2_2.world, "physics_world"),
			target_starting_pos = Vector3Box(),
			plague_wave_rot = QuaternionBox()
		}
	end
end

BTChaosPlagueWaveSpawnerSummoningAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.action = nil
end

BTChaosPlagueWaveSpawnerSummoningAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local action = arg_4_2.action
	local plague_wave_data = arg_4_2.plague_wave_data
	local skulk_data = arg_4_2.skulk_data
	local target_unit = arg_4_2.target_unit
	local external_event_name = arg_4_2.external_event_name
	local external_event_value = arg_4_2.external_event_value
	local plague_wave_spawn_cooldown = action.plague_wave_spawn_cooldown

	if not (not external_event_name and external_event_name ~= action.external_event_name) then
		plague_wave_spawn_cooldown = external_event_value
	end

	if not (not external_event_value and not (external_event_value >= 100)) then
		Managers.state.conflict:destroy_unit(arg_4_1, arg_4_2, "plague_wave_spawner")

		return
	end

	local anticipation_fx = action.anticipation_fx

	if not ((arg_4_2.anticipation_fx_id or not anticipation_fx) and not (arg_4_3 > plague_wave_data.plague_wave_timer - action.anticipation_fx_offset_time)) then
		local world = arg_4_2.world

		arg_4_2.anticipation_fx_id = World.create_particles(world, anticipation_fx, POSITION_LOOKUP[arg_4_1], Quaternion.identity())
	end

	if not (not (arg_4_3 > plague_wave_data.plague_wave_timer) or ScriptUnit.extension(target_unit, "status_system"):is_invisible()) then
		local nav_world = arg_4_2.nav_world
		local var_4_10 = POSITION_LOOKUP[target_unit]
		local var_4_11 = POSITION_LOOKUP[arg_4_1]
		local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_4_11, 1, 1)
		local pos_on_mesh_2 = LocomotionUtils.pos_on_mesh(nav_world, var_4_10, 1, 1)

		if not (not pos_on_mesh and not pos_on_mesh_2 and GwNavQueries.raycango(nav_world, pos_on_mesh, pos_on_mesh_2)) then
			local num = arg_4_3 + plague_wave_spawn_cooldown

			num = num or action.plague_wave_spawn_cooldown
			plague_wave_data.plague_wave_timer = num
			arg_4_2.ready_to_summon = true
			arg_4_2.summoning_finished = true
			arg_4_2.anticipation_fx_id = nil
		else
			plague_wave_data.plague_wave_timer = arg_4_3 + 2
		end

		return "done"
	end

	return "running"
end
