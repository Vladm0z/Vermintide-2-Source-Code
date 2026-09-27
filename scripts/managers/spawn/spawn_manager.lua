-- chunkname: @scripts/managers/spawn/spawn_manager.lua

require("scripts/utils/hero_spawner_handler")

SpawnManager = class(SpawnManager)

local num = 8

SpawnManager.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	-- function 1
	self.world = arg_1_1
	self.spawn_points = {}
	self.last_spawn_point = 0
	self._is_server = arg_1_2
	self._spawning = true
	self.new_spawns = {}
	self.unit_spawner = arg_1_4
	self.num_new_spawns = 0
	self._game_mode = Managers.state.game_mode:game_mode()
	self.hero_spawner_handler = HeroSpawnerHandler:new(arg_1_2, arg_1_5, arg_1_3)
	self._bot_profile_release_list = {}
	self._spawn_list = {}
	self._available_profile_order = {}
	self._available_profiles = {}
	self._bot_players = {}
	self._delayed_bot_despawn_list = {}
	self._game_objects_to_remove = {}
	self._profile_synchronizer = arg_1_5
	self._network_server = arg_1_6
	self._network_event_delegate = arg_1_3
	self._disable_spawning_reason_filter = {}
	self._checkpoint_data = nil
	self._respawns_enabled = true
	self._despawn_queue = {}
	self._despawn_queue_size = 0
end

SpawnManager.destroy = function (self)
	-- function 2
	self.hero_spawner_handler:destroy()

	if self._despawn_queue_size > 0 then
		self:_update_despawns()
	end

	assert(self._despawn_queue_size == 0, "Players left to despawn when the spawn manager is destroyed")
end

SpawnManager._default_player_statuses = function (arg_3_0)
	-- function 3
	local team_a_num_slots = Managers.state.game_mode:settings().team_a_num_slots

	team_a_num_slots = team_a_num_slots or num

	local tbl = {}

	for i = 1, team_a_num_slots do
		tbl[i] = {
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

	return tbl
end

SpawnManager._spawn_pos_rot_from_index = function (self, arg_4_1)
	-- function 4
	local var_4_0 = self.spawn_points[arg_4_1]
	local unbox = var_4_0.pos:unbox()
	local unbox_2 = var_4_0.rot:unbox()

	return unbox, unbox_2
end

SpawnManager.flow_callback_set_checkpoint = function (self, arg_5_1, arg_5_2, ...)
	-- function 5
	if not self._is_server then
		print("calling flow_callback_set_checkpoint on client.")

		return
	end

	local create_checkpoint_data = Managers.state.entity:system("mission_system"):create_checkpoint_data()
	local create_checkpoint_data_2 = Managers.state.entity:system("pickup_system"):create_checkpoint_data()
	local create_checkpoint_data_3 = Managers.state.conflict.level_analysis:create_checkpoint_data()
	local create_checkpoint_data_4 = Managers.state.networked_flow_state:create_checkpoint_data()

	self._checkpoint_data = {
		player_statuses = self:_clone_player_status(self._player_statuses),
		spawns = self:_pack_spawn_unit_level_indices(...),
		no_spawn_volume = arg_5_1,
		safe_zone_volume_name = arg_5_2,
		pickup = create_checkpoint_data_2,
		level_analysis = create_checkpoint_data_3,
		mission = create_checkpoint_data,
		networked_flow_state = create_checkpoint_data_4
	}
end

SpawnManager.load_checkpoint_data = function (self, arg_6_1)
	-- function 6
	self._checkpoint_data = arg_6_1

	local _clone_player_status = self:_clone_player_status(arg_6_1.player_statuses)
	local current_level = LevelHelper:current_level(self.world)

	for i, v in ipairs(arg_6_1.spawns) do
		local unit_by_index = Level.unit_by_index(current_level, v)
		local local_position = Unit.local_position(unit_by_index, 0)
		local local_rotation = Unit.local_rotation(unit_by_index, 0)
		local var_6_5 = _clone_player_status[i]

		if not var_6_5.position and not var_6_5.rotation then
			var_6_5.position:store(local_position)
			var_6_5.rotation:store(local_rotation)
		else
			var_6_5.position = Vector3Box(local_position)
			var_6_5.rotation = QuaternionBox(local_rotation)
		end
	end

	self._player_statuses = _clone_player_status
end

SpawnManager.checkpoint_data = function (self)
	-- function 7
	return self._checkpoint_data
end

SpawnManager._clone_player_status = function (self, arg_8_1)
	-- function 8
	local tbl = {}

	for k, v in pairs(arg_8_1) do
		if type(v) == "table" then
			tbl[k] = self:_clone_player_status(v)
		elseif k == "position" then
			tbl[k] = Vector3Box(v:unbox())
		elseif k == "rotation" then
			tbl[k] = QuaternionBox(v:unbox())
		else
			tbl[k] = v
		end
	end

	return tbl
end

SpawnManager._pack_spawn_unit_level_indices = function (self, ...)
	-- function 9
	local tbl = {}
	local current_level = LevelHelper:current_level(self.world)

	for i, v in ipairs({
		...
	}) do
		tbl[i] = Level.unit_index(current_level, v)
	end

	return tbl
end

SpawnManager.pre_update = function (self, arg_10_1, arg_10_2)
	-- function 10
	if self._despawn_queue_size > 0 then
		self:_update_despawns()
	end
end

SpawnManager.delayed_despawn = function (self, arg_11_1)
	-- function 11
	local _despawn_queue = self._despawn_queue

	self._despawn_queue_size = self._despawn_queue_size + 1
	_despawn_queue[self._despawn_queue_size] = arg_11_1

	arg_11_1:mark_as_queued_for_despawn()
end

SpawnManager._update_despawns = function (self)
	-- function 12
	local _despawn_queue = self._despawn_queue

	for i = self._despawn_queue_size, 1, -1 do
		_despawn_queue[i]:despawn()

		_despawn_queue[i] = nil
	end

	self._despawn_queue_size = 0
end
