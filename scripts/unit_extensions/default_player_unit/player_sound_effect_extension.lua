-- chunkname: @scripts/unit_extensions/default_player_unit/player_sound_effect_extension.lua

PlayerSoundEffectExtension = class(PlayerSoundEffectExtension)

local get_data = Unit.get_data
local num = 1.8
local num_2 = 3.5
local num_3 = 100
local num_4 = 10
local tbl = {
	skaven_storm_vermin_champion = 100,
	chaos_exalted_champion_warcamp = 100,
	chaos_exalted_sorcerer = 400,
	chaos_warrior = 100,
	skaven_storm_vermin_warlord = 100,
	skaven_rat_ogre = 100,
	chaos_exalted_champion_norsca = 100,
	beastmen_minotaur = 100,
	chaos_troll = 100,
	chaos_spawn = 100,
	skaven_stormfiend_boss = 100,
	chaos_spawn_exalted_champion_norsca = 100,
	skaven_stormfiend = 100
}
local num_5 = 7
local num_6 = 14
local num_7 = 0.5

PlayerSoundEffectExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._world = arg_1_1.world
	self._wwise_world = Managers.world:wwise_world(self._world)
	self._player = Managers.player
	self._is_server = Managers.player.is_server
	self._local_player = Managers.player.local_player
	self._num_recent_hits = 0
	self._num_recent_kills = 0
	self._recent_hit_cooldown = 0
	self._recent_kill_cooldown = 0
	self._aggro_unit = nil
	self._aggro_breed = nil
	self._current_aggro_value = 0
	self._ai_broadphase = Managers.state.entity:system("ai_system").broadphase
	self._broadphase_update_timer = 0
	self._nearby_ai_units = {}
	self._music_manager = Managers.music
end

PlayerSoundEffectExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")

	if not self._first_person_extension then
		self._first_person_unit = self._first_person_extension:get_first_person_unit()
	end
end

PlayerSoundEffectExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not self._local_player then
		return
	end

	self:_update_recent_hits(arg_3_3)
	self:_update_recent_kills(arg_3_3)
	self:_update_aggro_ranges(arg_3_3)
	self:_update_camera_look_angle()
	self:_update_specials_proximity(arg_3_3)
end

PlayerSoundEffectExtension.destroy = function (arg_4_0)
	-- function 4
	return
end

PlayerSoundEffectExtension._update_recent_hits = function (self, arg_5_1)
	-- function 5
	if self._recent_hit_cooldown <= 0 then
		return
	end

	self._recent_hit_cooldown = math.max(self._recent_hit_cooldown - arg_5_1, 0)

	if self._recent_hit_cooldown == 0 then
		self:_set_hit_count(0)
	end
end

PlayerSoundEffectExtension._update_recent_kills = function (self, arg_6_1)
	-- function 6
	if self._recent_kill_cooldown <= 0 then
		return
	end

	self._recent_kill_cooldown = math.max(self._recent_kill_cooldown - arg_6_1, 0)

	if self._recent_kill_cooldown == 0 then
		self:_set_kill_count(0)
	end
end

PlayerSoundEffectExtension._update_aggro_ranges = function (self, arg_7_1)
	-- function 7
	if not self._aggro_unit then
		local _wwise_world = self._wwise_world

		WwiseWorld.set_global_parameter(_wwise_world, "combat_combo_has_aggro", 0)
	elseif not HEALTH_ALIVE[self._aggro_unit] then
		self._aggro_unit = nil

		local _wwise_world_2 = self._wwise_world

		WwiseWorld.set_global_parameter(_wwise_world_2, "combat_combo_has_aggro", 0)
		WwiseWorld.trigger_event(_wwise_world_2, "Play_boss_aggro_exit")
	end

	if not self._waiting_aggro_unit then
		if not HEALTH_ALIVE[self._waiting_aggro_unit] then
			self._waiting_aggro_unit = nil

			return
		end

		local name = get_data(self._waiting_aggro_unit, "breed").name
		local var_7_3 = tbl[name]

		if not var_7_3 then
			return
		end

		local var_7_4 = POSITION_LOOKUP[self._unit]
		local var_7_5 = POSITION_LOOKUP[self._waiting_aggro_unit]

		if var_7_3 >= Vector3.distance_squared(var_7_4, var_7_5) then
			local _wwise_world_3 = self._wwise_world

			WwiseWorld.set_global_parameter(_wwise_world_3, "combat_combo_has_aggro", 1)
			WwiseWorld.trigger_event(_wwise_world_3, "Play_boss_aggro_enter")

			self._aggro_unit = self._waiting_aggro_unit
			self._waiting_aggro_unit = nil
		end
	end
end

PlayerSoundEffectExtension._set_hit_count = function (self, arg_8_1)
	-- function 8
	self._num_recent_hits = arg_8_1

	local _wwise_world = self._wwise_world

	WwiseWorld.set_global_parameter(_wwise_world, "combat_combo_hits", arg_8_1)
end

PlayerSoundEffectExtension._set_kill_count = function (self, arg_9_1)
	-- function 9
	self._num_recent_kills = arg_9_1

	local _wwise_world = self._wwise_world

	WwiseWorld.set_global_parameter(_wwise_world, "combat_combo_kills", arg_9_1)
end

PlayerSoundEffectExtension._update_camera_look_angle = function (self)
	-- function 10
	local _unit = self._unit
	local network = Managers.state.network
	local game = network:game()
	local unit_game_object_id = network:unit_game_object_id(_unit)
	local game_object_field = GameSession.game_object_field(game, unit_game_object_id, "aim_direction")
	local normalize = Vector3.normalize(Vector3.flat(game_object_field))
	local dot = Vector3.dot(normalize, game_object_field)
	local acos = math.acos(math.clamp(dot, -1, 1))
	local num = math.radians_to_degrees(acos) * math.sign(game_object_field.z)
	local _wwise_world = self._wwise_world

	WwiseWorld.set_global_parameter(_wwise_world, "player_camera_horizon_angle", num)
end

local tbl_2 = {}

PlayerSoundEffectExtension._update_specials_proximity = function (self, arg_11_1)
	-- function 11
	self._broadphase_update_timer = self._broadphase_update_timer - arg_11_1

	if self._broadphase_update_timer <= 0 then
		self._broadphase_update_timer = num_7

		local var_11_0 = POSITION_LOOKUP[self._unit]

		table.clear(tbl_2)

		local query = Broadphase.query(self._ai_broadphase, var_11_0, num_6, tbl_2)
		local var_11_2

		for i = 1, query do
			repeat
				local var_11_3 = tbl_2[i]

				if not HEALTH_ALIVE[var_11_3] then
					break
				end

				if not get_data(var_11_3, "breed").special then
					break
				end

				local var_11_4 = POSITION_LOOKUP[var_11_3]

				var_11_2 = (not (Vector3.distance_squared(var_11_0, var_11_4) <= num_5^2) or not "close" or var_11_2) and "medium"
			until true
		end

		var_11_2 = var_11_2 or "far"

		self._music_manager:set_wwise_state("specials_proximity", var_11_2)
	end
end

PlayerSoundEffectExtension.add_hit = function (self)
	-- function 12
	self._recent_hit_cooldown = num

	local min = math.min(self._num_recent_hits + 1, num_3)

	self:_set_hit_count(min)
end

PlayerSoundEffectExtension.add_kill = function (self)
	-- function 13
	self._recent_kill_cooldown = num_2

	local min = math.min(self._num_recent_kills + 1, num_4)

	self:_set_kill_count(min)
end

PlayerSoundEffectExtension.dodge = function (self)
	-- function 14
	if not self._first_person_unit then
		Unit.flow_event(self._first_person_unit, "lua_dodge")
	end
end

PlayerSoundEffectExtension.dodged_attack = function (self)
	-- function 15
	if not self._first_person_unit then
		Unit.flow_event(self._first_person_unit, "lua_dodged_attack")
	end
end

PlayerSoundEffectExtension.melee_kill = function (self)
	-- function 16
	if not self._first_person_unit then
		Unit.flow_event(self._first_person_unit, "lua_melee_kill")
	end
end

PlayerSoundEffectExtension.aggro_unit_changed = function (self, arg_17_1, arg_17_2)
	-- function 17
	local get_data = Unit.get_data(arg_17_1, "breed")

	if not get_data then
		return
	end

	local name = get_data.name
	local var_17_2 = tbl[name]

	if not var_17_2 then
		return
	end

	if not (not arg_17_2 and self._aggro_unit == arg_17_1) then
		self._aggro_unit = arg_17_1

		local var_17_3 = POSITION_LOOKUP[self._unit]
		local var_17_4 = POSITION_LOOKUP[arg_17_1]

		if var_17_2 >= Vector3.distance_squared(var_17_3, var_17_4) then
			local _wwise_world = self._wwise_world

			WwiseWorld.set_global_parameter(_wwise_world, "combat_combo_has_aggro", 1)
			WwiseWorld.trigger_event(_wwise_world, "Play_boss_aggro_enter")
		else
			self._aggro_unit = nil
			self._waiting_aggro_unit = arg_17_1
		end
	elseif not (arg_17_2 or self._aggro_unit ~= arg_17_1) then
		self._aggro_unit = nil
		self._waiting_aggro_unit = nil

		local _wwise_world_2 = self._wwise_world

		WwiseWorld.set_global_parameter(_wwise_world_2, "combat_combo_has_aggro", 0)
		WwiseWorld.trigger_event(_wwise_world_2, "Play_boss_aggro_exit")
	end
end

PlayerSoundEffectExtension.get_music_aggro_state = function (self)
	-- function 18
	if not self._aggro_unit then
		return "player"
	end

	return "husk"
end
