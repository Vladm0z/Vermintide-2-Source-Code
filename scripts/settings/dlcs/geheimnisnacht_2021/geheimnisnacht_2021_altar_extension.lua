-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_altar_extension.lua

Geheimnisnacht2021AltarExtension = class(Geheimnisnacht2021AltarExtension)

local str = "fx/halloween_event_ambient"
local str_2 = "fx/halloween_event_final_explosion"
local str_3 = "units/decals/decal_halloween_2021"
local num = 3
local degrees_to_radians = math.degrees_to_radians(78.5)
local tbl = {
	-0.04,
	-0.1
}
local num_2 = 0
local num_3 = 1
local num_4 = 2
local num_5 = 3
local str_4 = "to_interactable"
local str_5 = "to_destructible"
local str_6 = "hit_start"
local str_7 = "hit_end"
local set_game_object_field = GameSession.set_game_object_field
local game_object_field = GameSession.game_object_field

Geheimnisnacht2021AltarExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._is_server = Managers.state.network.is_server
	self.world = arg_1_1.world

	local state = arg_1_3.state

	state = state or num_2
	self._state = state
	self._audio_system = Managers.state.entity:system("audio_system")
	self._unit_spawner = Managers.state.unit_spawner

	self:_init_state()
end

Geheimnisnacht2021AltarExtension.destroy = function (self)
	-- function 2
	self:unregister_events()
end

Geheimnisnacht2021AltarExtension.assign_cultist_group_id = function (self, arg_3_1)
	-- function 3
	self._cultist_group_id = arg_3_1
end

Geheimnisnacht2021AltarExtension.get_current_state = function (self)
	-- function 4
	return self._state
end

Geheimnisnacht2021AltarExtension.can_interact = function (self)
	-- function 5
	return self._state == num_4
end

Geheimnisnacht2021AltarExtension.on_interact = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not arg_6_1 then
		Unit.animation_event(self._unit, str_7)
	end

	if not arg_6_1 and not arg_6_2 then
		self:change_state(num_5)
	end
end

Geheimnisnacht2021AltarExtension.on_interact_start = function (self, arg_7_1)
	-- function 7
	if not arg_7_1 then
		Unit.animation_event(self._unit, str_6)
	end
end

Geheimnisnacht2021AltarExtension.update = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local game = Managers.state.network:game()
	local _go_id = self._go_id

	_go_id = _go_id or Managers.state.unit_storage:go_id(arg_8_1)

	if not game and not _go_id then
		if not self._is_server then
			set_game_object_field(game, _go_id, "state", self._state)
		else
			local var_8_2 = game_object_field(game, _go_id, "state")

			self:change_state(var_8_2)
		end

		self._go_id = _go_id
	end

	if not self._check_time then
		self._check_time = 0
	end

	if not (self._hero_close or not (arg_8_5 > self._check_time)) then
		local alloc_table = FrameTable.alloc_table()
		local player_units_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

		Broadphase.query(player_units_broadphase, POSITION_LOOKUP[arg_8_1], 35, alloc_table)

		for k, v in pairs(alloc_table) do
			local owner = Managers.player:owner(v)

			if not (not owner and not owner:is_player_controlled()) then
				self:play_relevant_faction_sound()
				self:set_ritual_sound(true)

				self._hero_close = true

				if self.nurglings_spawned or not self._is_server then
					self:spawn_nurglings()
				end
			end
		end

		self._check_time = arg_8_5 + 1
	end
end

Geheimnisnacht2021AltarExtension.die = function (self)
	-- function 9
	if not self._is_server then
		local node = Unit.node(self._unit, "j_skull_anim")
		local world_position = Unit.world_position(self._unit, node)

		Managers.state.entity:system("pickup_system"):buff_spawn_pickup("geheimnisnacht_2021_side_objective", world_position, true)
	end

	Managers.state.achievement:trigger_event("altar_destroyed")
	Unit.flow_event(self._unit, "lua_dead")
	World.create_particles(self.world, str_2, POSITION_LOOKUP[self._unit] + Vector3.up())

	if not self._ambient_vfx then
		World.destroy_particles(self.world, self._ambient_vfx)

		self._ambient_vfx = nil
	end

	self:set_ritual_sound(false)
	self:unregister_events()
end

Geheimnisnacht2021AltarExtension.register_events = function (self)
	-- function 10
	local event = Managers.state.event

	if not event then
		self._registered_events = true

		event:register(self, "geheimnisnacht_2021_altar_cultists_killed", "on_cultists_killed")
		event:register(self, "geheimnisnacht_2021_altar_cultists_aggroed", "on_cultists_aggroed")

		if not self._is_server then
			event:register(self, "nurgling_killed", "nurglings_flee")
		end
	end
end

Geheimnisnacht2021AltarExtension.unregister_events = function (self)
	-- function 11
	local event = Managers.state.event

	if not event and not self._registered_events then
		self._registered_events = nil

		event:unregister("geheimnisnacht_2021_altar_cultists_killed", self)
		event:unregister("geheimnisnacht_2021_altar_cultists_aggroed", self)

		if not self._is_server then
			event:unregister("nurgling_killed", self)
		end
	end
end

Geheimnisnacht2021AltarExtension.on_cultists_killed = function (self, arg_12_1)
	-- function 12
	if arg_12_1 == self._cultist_group_id then
		self:change_state(num_4)
		self:stop_relevant_faction_sound()
	end
end

Geheimnisnacht2021AltarExtension.on_cultists_aggroed = function (self, arg_13_1)
	-- function 13
	if arg_13_1 == self._cultist_group_id then
		self:stop_relevant_faction_sound()
		self:change_state(num_3)
		self:nurglings_flee()
	end
end

Geheimnisnacht2021AltarExtension.stop_relevant_faction_sound = function (self)
	-- function 14
	local _faction = self._faction

	if not _faction then
		local _audio_system = self._audio_system
		local _unit = self._unit

		if not ALIVE[_unit] then
			return
		end

		if _faction == "chaos" then
			_audio_system:play_audio_unit_event("enemy_marauder_halloween_ritual_loop_stop", _unit)
		else
			_audio_system:play_audio_unit_event("enemy_skaven_halloween_ritual_loop_stop", _unit)
		end
	end
end

Geheimnisnacht2021AltarExtension.play_relevant_faction_sound = function (self)
	-- function 15
	local _faction = self._faction

	if not _faction then
		local _unit = self._unit

		if not ALIVE[_unit] then
			return
		end

		local _audio_system = self._audio_system

		if _faction == "chaos" then
			_audio_system:play_audio_unit_event("enemy_marauder_halloween_ritual_loop", _unit)
		else
			_audio_system:play_audio_unit_event("enemy_skaven_halloween_ritual_loop", _unit)
		end
	end
end

Geheimnisnacht2021AltarExtension.set_ritual_sound = function (self, arg_16_1)
	-- function 16
	local _audio_system = self._audio_system
	local _unit = self._unit

	if not arg_16_1 then
		_audio_system:play_audio_unit_event("halloween_event_ritual_loop", _unit)
	else
		_audio_system:play_audio_unit_event("halloween_event_ritual_loop_stop", _unit)
	end
end

Geheimnisnacht2021AltarExtension.setup_faction = function (self, arg_17_1)
	-- function 17
	if not arg_17_1 then
		self._faction = arg_17_1
	end
end

Geheimnisnacht2021AltarExtension.change_state = function (self, arg_18_1)
	-- function 18
	local _state = self._state

	if _state < arg_18_1 then
		for i = _state + 1, arg_18_1 do
			self:_increment_state(i)
		end

		self._state = arg_18_1
	end
end

Geheimnisnacht2021AltarExtension._init_state = function (self)
	-- function 19
	local world = self.world
	local _unit = self._unit

	self._health_extension = ScriptUnit.extension(_unit, "health_system")
	self._health_extension.is_invincible = true

	if self._state == num_2 then
		self:register_events()
	end

	if self._state ~= num_5 then
		local world_position = Unit.world_position(_unit, 0)
		local world_rotation = Unit.world_rotation(_unit, 0)

		self._ambient_vfx = World.create_particles(world, str, world_position, world_rotation)

		World.link_particles(world, self._ambient_vfx, _unit, 0, Matrix4x4.identity(), "stop")

		if not str_3 then
			self._decal_unit = self._unit_spawner:spawn_local_unit(str_3)

			Unit.set_local_position(self._decal_unit, 0, world_position + Vector3(tbl[1], tbl[2], 0))
			Unit.set_local_rotation(self._decal_unit, 0, Quaternion.multiply(world_rotation, Quaternion(Vector3.up(), degrees_to_radians)))
			Unit.set_local_scale(self._decal_unit, 0, Vector3(num, num, 2))
		end
	end
end

Geheimnisnacht2021AltarExtension._increment_state = function (self, arg_20_1)
	-- function 20
	if arg_20_1 == num_3 then
		self:_mark_aggroed()
	elseif arg_20_1 == num_4 then
		self:_mark_interactable()
	elseif arg_20_1 == num_5 then
		self:_mark_destructible()
	end
end

Geheimnisnacht2021AltarExtension._mark_aggroed = function (self)
	-- function 21
	Unit.animation_event(self._unit, str_4)
end

Geheimnisnacht2021AltarExtension._mark_interactable = function (self)
	-- function 22
	self:unregister_events()
	Unit.animation_event(self._unit, str_5)
end

Geheimnisnacht2021AltarExtension._mark_destructible = function (self)
	-- function 23
	if not self._decal_unit then
		Unit.flow_event(self._decal_unit, "despawn")

		self._decal_unit = nil
	end

	self:die()
end

Geheimnisnacht2021AltarExtension.nurglings_flee = function (self)
	-- function 24
	local get_ai_group = Managers.state.entity:system("ai_group_system"):get_ai_group(self.nurgling_group_id)

	if not get_ai_group then
		AIGroupTemplates.critter_nurglings.wake_up_group(get_ai_group)
	end
end

Geheimnisnacht2021AltarExtension.spawn_nurglings = function (self)
	-- function 25
	if not self.nurglings_spawned then
		return
	end

	local _unit = self._unit
	local local_position = Unit.local_position(_unit, 0)
	local var_25_2 = Vector3Box(local_position)

	self.nurgling_group_id = Managers.state.entity:system("ai_group_system"):generate_group_id()

	local tbl = {
		spawned_func = function (arg_26_0, arg_26_1, arg_26_2)
			-- function 26
			local var_26_0 = BLACKBOARDS[arg_26_0]

			ScriptUnit.extension(arg_26_0, "ai_system"):set_perception("perception_regular", "pick_no_targets")

			if not var_26_0 then
				var_26_0.altar_pos = var_25_2
				var_26_0.is_fleeing = false
				var_26_0.nurgling_spawned_by_altar = true
			end
		end
	}
	local num = 15
	local num_2 = 20
	local random = math.random(num, num_2)
	local num_3 = 1
	local num_4 = 1
	local num_5 = 15
	local tbl_2 = {
		template = "critter_nurglings",
		id = self.nurgling_group_id,
		size = random
	}
	local identity = Quaternion.identity()
	local str = "critter_nurgling"
	local str_2 = "event"
	local str_3 = "event"
	local var_25_15
	local var_25_16 = Breeds[str]
	local conflict = Managers.state.conflict
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()

	for i = 1, random do
		local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(nav_world, local_position, num_3, num_4, num_5)

		if not get_spawn_pos_on_circle then
			conflict:spawn_queued_unit(var_25_16, Vector3Box(get_spawn_pos_on_circle), QuaternionBox(identity), str_2, var_25_15, str_3, tbl, tbl_2)
		end
	end

	self.nurglings_spawned = true
end
