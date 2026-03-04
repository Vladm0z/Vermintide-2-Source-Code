-- chunkname: @scripts/managers/spawn/spawn_manager.lua

require("scripts/utils/hero_spawner_handler")

SpawnManager = class(SpawnManager)

local var_0_0 = 8

function SpawnManager.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	arg_1_0.world = arg_1_1
	arg_1_0.spawn_points = {}
	arg_1_0.last_spawn_point = 0
	arg_1_0._is_server = arg_1_2
	arg_1_0._spawning = true
	arg_1_0.new_spawns = {}
	arg_1_0.unit_spawner = arg_1_4
	arg_1_0.num_new_spawns = 0
	arg_1_0._game_mode = Managers.state.game_mode:game_mode()
	arg_1_0.hero_spawner_handler = HeroSpawnerHandler:new(arg_1_2, arg_1_5, arg_1_3)
	arg_1_0._bot_profile_release_list = {}
	arg_1_0._spawn_list = {}
	arg_1_0._available_profile_order = {}
	arg_1_0._available_profiles = {}
	arg_1_0._bot_players = {}
	arg_1_0._delayed_bot_despawn_list = {}
	arg_1_0._game_objects_to_remove = {}
	arg_1_0._profile_synchronizer = arg_1_5
	arg_1_0._network_server = arg_1_6
	arg_1_0._network_event_delegate = arg_1_3
	arg_1_0._disable_spawning_reason_filter = {}
	arg_1_0._checkpoint_data = nil
	arg_1_0._respawns_enabled = true
	arg_1_0._despawn_queue = {}
	arg_1_0._despawn_queue_size = 0
end

function SpawnManager.destroy(arg_2_0)
	arg_2_0.hero_spawner_handler:destroy()

	if arg_2_0._despawn_queue_size > 0 then
		arg_2_0:_update_despawns()
	end

	assert(arg_2_0._despawn_queue_size == 0, "Players left to despawn when the spawn manager is destroyed")
end

function SpawnManager._default_player_statuses(arg_3_0)
	local var_3_0 = Managers.state.game_mode:settings().team_a_num_slots or var_0_0
	local var_3_1 = {}

	for iter_3_0 = 1, var_3_0 do
		var_3_1[iter_3_0] = {
			temporary_health_percentage = 0,
			spawn_state = "not_spawned",
			health_percentage = 1,
			health_state = "alive",
			last_update = -math.huge,
			consumables = {},
			ammo = {
				slot_ranged = 1,
				slot_melee = 1
			}
		}
	end

	return var_3_1
end

function SpawnManager._spawn_pos_rot_from_index(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.spawn_points[arg_4_1]
	local var_4_1 = var_4_0.pos:unbox()
	local var_4_2 = var_4_0.rot:unbox()

	return var_4_1, var_4_2
end

function SpawnManager.flow_callback_set_checkpoint(arg_5_0, arg_5_1, arg_5_2, ...)
	if not arg_5_0._is_server then
		print("calling flow_callback_set_checkpoint on client.")

		return
	end

	local var_5_0 = Managers.state.entity:system("mission_system"):create_checkpoint_data()
	local var_5_1 = Managers.state.entity:system("pickup_system"):create_checkpoint_data()
	local var_5_2 = Managers.state.conflict.level_analysis:create_checkpoint_data()
	local var_5_3 = Managers.state.networked_flow_state:create_checkpoint_data()

	arg_5_0._checkpoint_data = {
		player_statuses = arg_5_0:_clone_player_status(arg_5_0._player_statuses),
		spawns = arg_5_0:_pack_spawn_unit_level_indices(...),
		no_spawn_volume = arg_5_1,
		safe_zone_volume_name = arg_5_2,
		pickup = var_5_1,
		level_analysis = var_5_2,
		mission = var_5_0,
		networked_flow_state = var_5_3
	}
end

function SpawnManager.load_checkpoint_data(arg_6_0, arg_6_1)
	arg_6_0._checkpoint_data = arg_6_1

	local var_6_0 = arg_6_0:_clone_player_status(arg_6_1.player_statuses)
	local var_6_1 = LevelHelper:current_level(arg_6_0.world)

	for iter_6_0, iter_6_1 in ipairs(arg_6_1.spawns) do
		local var_6_2 = Level.unit_by_index(var_6_1, iter_6_1)
		local var_6_3 = Unit.local_position(var_6_2, 0)
		local var_6_4 = Unit.local_rotation(var_6_2, 0)
		local var_6_5 = var_6_0[iter_6_0]

		if var_6_5.position and var_6_5.rotation then
			var_6_5.position:store(var_6_3)
			var_6_5.rotation:store(var_6_4)
		else
			var_6_5.position = Vector3Box(var_6_3)
			var_6_5.rotation = QuaternionBox(var_6_4)
		end
	end

	arg_6_0._player_statuses = var_6_0
end

function SpawnManager.checkpoint_data(arg_7_0)
	return arg_7_0._checkpoint_data
end

function SpawnManager._clone_player_status(arg_8_0, arg_8_1)
	local var_8_0 = {}

	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		if type(iter_8_1) == "table" then
			var_8_0[iter_8_0] = arg_8_0:_clone_player_status(iter_8_1)
		elseif iter_8_0 == "position" then
			var_8_0[iter_8_0] = Vector3Box(iter_8_1:unbox())
		elseif iter_8_0 == "rotation" then
			var_8_0[iter_8_0] = QuaternionBox(iter_8_1:unbox())
		else
			var_8_0[iter_8_0] = iter_8_1
		end
	end

	return var_8_0
end

function SpawnManager._pack_spawn_unit_level_indices(arg_9_0, ...)
	local var_9_0 = {}
	local var_9_1 = LevelHelper:current_level(arg_9_0.world)

	for iter_9_0, iter_9_1 in ipairs({
		...
	}) do
		var_9_0[iter_9_0] = Level.unit_index(var_9_1, iter_9_1)
	end

	return var_9_0
end

function SpawnManager.pre_update(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0._despawn_queue_size > 0 then
		arg_10_0:_update_despawns()
	end
end

function SpawnManager.delayed_despawn(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._despawn_queue

	arg_11_0._despawn_queue_size = arg_11_0._despawn_queue_size + 1
	var_11_0[arg_11_0._despawn_queue_size] = arg_11_1

	arg_11_1:mark_as_queued_for_despawn()
end

function SpawnManager._update_despawns(arg_12_0)
	local var_12_0 = arg_12_0._despawn_queue

	for iter_12_0 = arg_12_0._despawn_queue_size, 1, -1 do
		var_12_0[iter_12_0]:despawn()

		var_12_0[iter_12_0] = nil
	end

	arg_12_0._despawn_queue_size = 0
end
