-- chunkname: @scripts/unit_extensions/ai_supplementary/shadow_homing_skulls_spawner_extension.lua

ShadowHomingSkullsSpawnerExtension = class(ShadowHomingSkullsSpawnerExtension)

local num = 10
local num_2 = 1
local num_3 = 2
local num_4 = 0
local num_5 = 1.5
local num_6 = 0.3
local num_7 = 1
local str = "filter_ai_line_of_sight_check"

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local str = "fx/blk_grey_wings_teleport_01"

	if not str then
		local var_1_1 = NetworkLookup.effects[str]
		local num = 0
		local identity = Quaternion.identity()

		Managers.state.network:rpc_play_particle_effect(nil, var_1_1, NetworkConstants.invalid_game_object_id, num, arg_1_1, identity, false)
	end

	local var_1_4 = POSITION_LOOKUP[arg_1_0]
	local tbl = {
		prepare_func = function (self, arg_2_1)
			-- function 2
			local flag = false

			self.modify_extension_init_data(self, flag, arg_2_1)
		end
	}
	local look = Quaternion.look(arg_1_2, Vector3.up())

	return Managers.state.conflict:spawn_queued_unit(Breeds.shadow_skull, Vector3Box(arg_1_1), QuaternionBox(look), "mutator", "spawn_idle", "terror_event", tbl)
end

local function fn_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local num = arg_3_3 - arg_3_2
	local length = Vector3.length(num)
	local normalize = Vector3.normalize(num)
	local var_3_3 = str
	local raycast, var_3_5, var_3_6, var_3_7, var_3_8 = PhysicsWorld.raycast(arg_3_0, arg_3_2, normalize, length, "closest", "collision_filter", var_3_3)
	local flag = not raycast and Actor.unit(var_3_8)

	return not raycast and flag == arg_3_1
end

local function fn_3(arg_4_0, arg_4_1)
	-- function 4
	return arg_4_1
end

local function fn_4(self)
	-- function 5
	local PLAYER_AND_BOT_UNITS = self.PLAYER_AND_BOT_UNITS
	local tbl = {}

	for i = 1, #PLAYER_AND_BOT_UNITS do
		local var_5_2 = PLAYER_AND_BOT_UNITS[i]

		if not HEALTH_ALIVE[var_5_2] then
			tbl[#tbl + 1] = var_5_2
		end
	end

	table.shuffle(tbl)

	return tbl
end

local tbl = {
	INITIAL = "INITIAL",
	COOLDOWN_FROM_TARGETTING = "COOLDOWN_FROM_TARGETTING",
	FINDING_TARGET = "FINDING_TARGET",
	DONE = "DONE",
	WAITING_TO_SPAWN_SKULLS = "WAITING_TO_SPAWN_SKULLS",
	SPAWNING_SKULL = "SPAWNING_SKULL"
}

ShadowHomingSkullsSpawnerExtension.init = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local world = arg_6_1.world

	self.world = world
	self.physics_world = World.get_data(world, "physics_world")
	self.unit = arg_6_2
	self.is_server = Managers.player.is_server
	self._limitted_spawner = arg_6_3.limitted_spawner
	self._hero_side = Managers.state.side:get_side_from_name("heroes")
	self._state = tbl.INITIAL
end

ShadowHomingSkullsSpawnerExtension.destroy = function (arg_7_0)
	-- function 7
	return
end

ShadowHomingSkullsSpawnerExtension.on_remove_extension = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return
end

ShadowHomingSkullsSpawnerExtension.update = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	if not self._done then
		return
	end

	if not self.is_server then
		return
	end

	if not self._own_position then
		self._own_position = Vector3Box(Unit.local_position(arg_9_1, 0))
	end

	if not (not self._tracked_player and ALIVE[self._tracked_player]) then
		self._state = tbl.FINDING_TARGET
		self._finding_target_since = arg_9_5
	end

	if self._state == tbl.INITIAL then
		self._state = tbl.FINDING_TARGET
		self._finding_target_since = arg_9_5
	elseif self._state == tbl.COOLDOWN_FROM_TARGETTING then
		if arg_9_5 > self._next_t then
			self._state = tbl.FINDING_TARGET
		end
	elseif self._state == tbl.FINDING_TARGET then
		self._tracked_player = nil

		local var_9_0 = fn_4(self._hero_side)

		for i = 1, #var_9_0 do
			local var_9_1 = var_9_0[i]
			local num_8 = POSITION_LOOKUP[var_9_1] + Vector3(0, 0, num_7)
			local _own_position = self._own_position
			local var_9_4 = fn_3(num_8, _own_position:unbox())
			local physics_world = self.physics_world

			if not fn_2(physics_world, var_9_1, var_9_4, num_8) then
				self._tracked_player = var_9_1

				break
			end
		end

		if not self._tracked_player then
			self._state = tbl.WAITING_TO_SPAWN_SKULLS
			self._next_t = arg_9_5 + num_3
		elseif arg_9_5 > self._finding_target_since + num then
			self._state = tbl.DONE
		else
			self._state = tbl.COOLDOWN_FROM_TARGETTING
			self._next_t = arg_9_5 + num_2
		end
	elseif self._state == tbl.WAITING_TO_SPAWN_SKULLS then
		local num_9 = POSITION_LOOKUP[self._tracked_player] + Vector3(0, 0, num_7)
		local _own_position_2 = self._own_position
		local var_9_8 = fn_3(num_9, _own_position_2:unbox())

		self._launch_position = var_9_8

		local physics_world_2 = self.physics_world

		if not fn_2(physics_world_2, self._tracker_player, var_9_8, num_9) then
			self._state = tbl.COOLDOWN_FROM_TARGETTING
			self._next_t = arg_9_5 + num_2
			self._target_decal = nil
		end

		if arg_9_5 > self._next_t then
			local num_10 = (num_5 - num_4) / num_6
			local num_11 = math.floor(math.random() * num_10) * num_6

			self._next_t = arg_9_5 + num_4 + num_11
			self._state = tbl.SPAWNING_SKULL
		end
	elseif self._state == tbl.SPAWNING_SKULL then
		if arg_9_5 > self._next_t then
			local unbox = self._own_position:unbox()
			local num_12 = POSITION_LOOKUP[self._tracked_player] + Vector3(0, 0, num_7) - unbox
			local normalize = Vector3.normalize(num_12)

			fn(self.unit, unbox, normalize)

			self._state = tbl.DONE
		end
	elseif self._state ~= tbl.DONE or self._destroyed or not Unit.alive(arg_9_1) then
		Managers.state.unit_spawner:mark_for_deletion(arg_9_1)

		self._destroyed = true
	end
end
