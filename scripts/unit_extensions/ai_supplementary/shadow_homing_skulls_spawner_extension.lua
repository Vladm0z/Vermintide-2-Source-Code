-- chunkname: @scripts/unit_extensions/ai_supplementary/shadow_homing_skulls_spawner_extension.lua

ShadowHomingSkullsSpawnerExtension = class(ShadowHomingSkullsSpawnerExtension)

local var_0_0 = 10
local var_0_1 = 1
local var_0_2 = 2
local var_0_3 = 0
local var_0_4 = 1.5
local var_0_5 = 0.3
local var_0_6 = 1
local var_0_7 = "filter_ai_line_of_sight_check"

local function var_0_8(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = "fx/blk_grey_wings_teleport_01"

	if var_1_0 then
		local var_1_1 = NetworkLookup.effects[var_1_0]
		local var_1_2 = 0
		local var_1_3 = Quaternion.identity()

		Managers.state.network:rpc_play_particle_effect(nil, var_1_1, NetworkConstants.invalid_game_object_id, var_1_2, arg_1_1, var_1_3, false)
	end

	local var_1_4 = POSITION_LOOKUP[arg_1_0]
	local var_1_5 = {
		prepare_func = function (arg_2_0, arg_2_1)
			local var_2_0 = false

			arg_2_0.modify_extension_init_data(arg_2_0, var_2_0, arg_2_1)
		end
	}
	local var_1_6 = Quaternion.look(arg_1_2, Vector3.up())

	return Managers.state.conflict:spawn_queued_unit(Breeds.shadow_skull, Vector3Box(arg_1_1), QuaternionBox(var_1_6), "mutator", "spawn_idle", "terror_event", var_1_5)
end

local function var_0_9(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_3 - arg_3_2
	local var_3_1 = Vector3.length(var_3_0)
	local var_3_2 = Vector3.normalize(var_3_0)
	local var_3_3 = var_0_7
	local var_3_4, var_3_5, var_3_6, var_3_7, var_3_8 = PhysicsWorld.raycast(arg_3_0, arg_3_2, var_3_2, var_3_1, "closest", "collision_filter", var_3_3)
	local var_3_9 = var_3_4 and Actor.unit(var_3_8)

	return not var_3_4 or var_3_9 == arg_3_1
end

local function var_0_10(arg_4_0, arg_4_1)
	return arg_4_1
end

local function var_0_11(arg_5_0)
	local var_5_0 = arg_5_0.PLAYER_AND_BOT_UNITS
	local var_5_1 = {}

	for iter_5_0 = 1, #var_5_0 do
		local var_5_2 = var_5_0[iter_5_0]

		if HEALTH_ALIVE[var_5_2] then
			var_5_1[#var_5_1 + 1] = var_5_2
		end
	end

	table.shuffle(var_5_1)

	return var_5_1
end

local var_0_12 = {
	INITIAL = "INITIAL",
	COOLDOWN_FROM_TARGETTING = "COOLDOWN_FROM_TARGETTING",
	FINDING_TARGET = "FINDING_TARGET",
	DONE = "DONE",
	WAITING_TO_SPAWN_SKULLS = "WAITING_TO_SPAWN_SKULLS",
	SPAWNING_SKULL = "SPAWNING_SKULL"
}

ShadowHomingSkullsSpawnerExtension.init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_1.world

	arg_6_0.world = var_6_0
	arg_6_0.physics_world = World.get_data(var_6_0, "physics_world")
	arg_6_0.unit = arg_6_2
	arg_6_0.is_server = Managers.player.is_server
	arg_6_0._limitted_spawner = arg_6_3.limitted_spawner
	arg_6_0._hero_side = Managers.state.side:get_side_from_name("heroes")
	arg_6_0._state = var_0_12.INITIAL
end

ShadowHomingSkullsSpawnerExtension.destroy = function (arg_7_0)
	return
end

ShadowHomingSkullsSpawnerExtension.on_remove_extension = function (arg_8_0, arg_8_1, arg_8_2)
	return
end

ShadowHomingSkullsSpawnerExtension.update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	if arg_9_0._done then
		return
	end

	if not arg_9_0.is_server then
		return
	end

	if not arg_9_0._own_position then
		arg_9_0._own_position = Vector3Box(Unit.local_position(arg_9_1, 0))
	end

	if arg_9_0._tracked_player and not ALIVE[arg_9_0._tracked_player] then
		arg_9_0._state = var_0_12.FINDING_TARGET
		arg_9_0._finding_target_since = arg_9_5
	end

	if arg_9_0._state == var_0_12.INITIAL then
		arg_9_0._state = var_0_12.FINDING_TARGET
		arg_9_0._finding_target_since = arg_9_5
	elseif arg_9_0._state == var_0_12.COOLDOWN_FROM_TARGETTING then
		if arg_9_5 > arg_9_0._next_t then
			arg_9_0._state = var_0_12.FINDING_TARGET
		end
	elseif arg_9_0._state == var_0_12.FINDING_TARGET then
		arg_9_0._tracked_player = nil

		local var_9_0 = var_0_11(arg_9_0._hero_side)

		for iter_9_0 = 1, #var_9_0 do
			local var_9_1 = var_9_0[iter_9_0]
			local var_9_2 = POSITION_LOOKUP[var_9_1] + Vector3(0, 0, var_0_6)
			local var_9_3 = arg_9_0._own_position
			local var_9_4 = var_0_10(var_9_2, var_9_3:unbox())
			local var_9_5 = arg_9_0.physics_world

			if var_0_9(var_9_5, var_9_1, var_9_4, var_9_2) then
				arg_9_0._tracked_player = var_9_1

				break
			end
		end

		if arg_9_0._tracked_player then
			arg_9_0._state = var_0_12.WAITING_TO_SPAWN_SKULLS
			arg_9_0._next_t = arg_9_5 + var_0_2
		elseif arg_9_5 > arg_9_0._finding_target_since + var_0_0 then
			arg_9_0._state = var_0_12.DONE
		else
			arg_9_0._state = var_0_12.COOLDOWN_FROM_TARGETTING
			arg_9_0._next_t = arg_9_5 + var_0_1
		end
	elseif arg_9_0._state == var_0_12.WAITING_TO_SPAWN_SKULLS then
		local var_9_6 = POSITION_LOOKUP[arg_9_0._tracked_player] + Vector3(0, 0, var_0_6)
		local var_9_7 = arg_9_0._own_position
		local var_9_8 = var_0_10(var_9_6, var_9_7:unbox())

		arg_9_0._launch_position = var_9_8

		local var_9_9 = arg_9_0.physics_world

		if not var_0_9(var_9_9, arg_9_0._tracker_player, var_9_8, var_9_6) then
			arg_9_0._state = var_0_12.COOLDOWN_FROM_TARGETTING
			arg_9_0._next_t = arg_9_5 + var_0_1
			arg_9_0._target_decal = nil
		end

		if arg_9_5 > arg_9_0._next_t then
			local var_9_10 = (var_0_4 - var_0_3) / var_0_5
			local var_9_11 = math.floor(math.random() * var_9_10) * var_0_5

			arg_9_0._next_t = arg_9_5 + var_0_3 + var_9_11
			arg_9_0._state = var_0_12.SPAWNING_SKULL
		end
	elseif arg_9_0._state == var_0_12.SPAWNING_SKULL then
		if arg_9_5 > arg_9_0._next_t then
			local var_9_12 = arg_9_0._own_position:unbox()
			local var_9_13 = POSITION_LOOKUP[arg_9_0._tracked_player] + Vector3(0, 0, var_0_6) - var_9_12
			local var_9_14 = Vector3.normalize(var_9_13)

			var_0_8(arg_9_0.unit, var_9_12, var_9_14)

			arg_9_0._state = var_0_12.DONE
		end
	elseif arg_9_0._state == var_0_12.DONE and not arg_9_0._destroyed and Unit.alive(arg_9_1) then
		Managers.state.unit_spawner:mark_for_deletion(arg_9_1)

		arg_9_0._destroyed = true
	end
end
