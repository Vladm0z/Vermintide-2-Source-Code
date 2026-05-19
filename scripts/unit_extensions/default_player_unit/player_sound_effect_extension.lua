-- chunkname: @scripts/unit_extensions/default_player_unit/player_sound_effect_extension.lua

PlayerSoundEffectExtension = class(PlayerSoundEffectExtension)

local var_0_0 = Unit.get_data
local var_0_1 = 1.8
local var_0_2 = 3.5
local var_0_3 = 100
local var_0_4 = 10
local var_0_5 = {
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
local var_0_6 = 7
local var_0_7 = 14
local var_0_8 = 0.5

function PlayerSoundEffectExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._world = arg_1_1.world
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)
	arg_1_0._player = Managers.player
	arg_1_0._is_server = Managers.player.is_server
	arg_1_0._local_player = Managers.player.local_player
	arg_1_0._num_recent_hits = 0
	arg_1_0._num_recent_kills = 0
	arg_1_0._recent_hit_cooldown = 0
	arg_1_0._recent_kill_cooldown = 0
	arg_1_0._aggro_unit = nil
	arg_1_0._aggro_breed = nil
	arg_1_0._current_aggro_value = 0
	arg_1_0._ai_broadphase = Managers.state.entity:system("ai_system").broadphase
	arg_1_0._broadphase_update_timer = 0
	arg_1_0._nearby_ai_units = {}
	arg_1_0._music_manager = Managers.music
end

function PlayerSoundEffectExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")

	if arg_2_0._first_person_extension then
		arg_2_0._first_person_unit = arg_2_0._first_person_extension:get_first_person_unit()
	end
end

function PlayerSoundEffectExtension.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if not arg_3_0._local_player then
		return
	end

	arg_3_0:_update_recent_hits(arg_3_3)
	arg_3_0:_update_recent_kills(arg_3_3)
	arg_3_0:_update_aggro_ranges(arg_3_3)
	arg_3_0:_update_camera_look_angle()
	arg_3_0:_update_specials_proximity(arg_3_3)
end

function PlayerSoundEffectExtension.destroy(arg_4_0)
	return
end

function PlayerSoundEffectExtension._update_recent_hits(arg_5_0, arg_5_1)
	if arg_5_0._recent_hit_cooldown <= 0 then
		return
	end

	arg_5_0._recent_hit_cooldown = math.max(arg_5_0._recent_hit_cooldown - arg_5_1, 0)

	if arg_5_0._recent_hit_cooldown == 0 then
		arg_5_0:_set_hit_count(0)
	end
end

function PlayerSoundEffectExtension._update_recent_kills(arg_6_0, arg_6_1)
	if arg_6_0._recent_kill_cooldown <= 0 then
		return
	end

	arg_6_0._recent_kill_cooldown = math.max(arg_6_0._recent_kill_cooldown - arg_6_1, 0)

	if arg_6_0._recent_kill_cooldown == 0 then
		arg_6_0:_set_kill_count(0)
	end
end

function PlayerSoundEffectExtension._update_aggro_ranges(arg_7_0, arg_7_1)
	if not arg_7_0._aggro_unit then
		local var_7_0 = arg_7_0._wwise_world

		WwiseWorld.set_global_parameter(var_7_0, "combat_combo_has_aggro", 0)
	elseif not HEALTH_ALIVE[arg_7_0._aggro_unit] then
		arg_7_0._aggro_unit = nil

		local var_7_1 = arg_7_0._wwise_world

		WwiseWorld.set_global_parameter(var_7_1, "combat_combo_has_aggro", 0)
		WwiseWorld.trigger_event(var_7_1, "Play_boss_aggro_exit")
	end

	if arg_7_0._waiting_aggro_unit then
		if not HEALTH_ALIVE[arg_7_0._waiting_aggro_unit] then
			arg_7_0._waiting_aggro_unit = nil

			return
		end

		local var_7_2 = var_0_0(arg_7_0._waiting_aggro_unit, "breed").name
		local var_7_3 = var_0_5[var_7_2]

		if not var_7_3 then
			return
		end

		local var_7_4 = POSITION_LOOKUP[arg_7_0._unit]
		local var_7_5 = POSITION_LOOKUP[arg_7_0._waiting_aggro_unit]

		if var_7_3 >= Vector3.distance_squared(var_7_4, var_7_5) then
			local var_7_6 = arg_7_0._wwise_world

			WwiseWorld.set_global_parameter(var_7_6, "combat_combo_has_aggro", 1)
			WwiseWorld.trigger_event(var_7_6, "Play_boss_aggro_enter")

			arg_7_0._aggro_unit = arg_7_0._waiting_aggro_unit
			arg_7_0._waiting_aggro_unit = nil
		end
	end
end

function PlayerSoundEffectExtension._set_hit_count(arg_8_0, arg_8_1)
	arg_8_0._num_recent_hits = arg_8_1

	local var_8_0 = arg_8_0._wwise_world

	WwiseWorld.set_global_parameter(var_8_0, "combat_combo_hits", arg_8_1)
end

function PlayerSoundEffectExtension._set_kill_count(arg_9_0, arg_9_1)
	arg_9_0._num_recent_kills = arg_9_1

	local var_9_0 = arg_9_0._wwise_world

	WwiseWorld.set_global_parameter(var_9_0, "combat_combo_kills", arg_9_1)
end

function PlayerSoundEffectExtension._update_camera_look_angle(arg_10_0)
	local var_10_0 = arg_10_0._unit
	local var_10_1 = Managers.state.network
	local var_10_2 = var_10_1:game()
	local var_10_3 = var_10_1:unit_game_object_id(var_10_0)
	local var_10_4 = GameSession.game_object_field(var_10_2, var_10_3, "aim_direction")
	local var_10_5 = Vector3.normalize(Vector3.flat(var_10_4))
	local var_10_6 = Vector3.dot(var_10_5, var_10_4)
	local var_10_7 = math.acos(math.clamp(var_10_6, -1, 1))
	local var_10_8 = math.radians_to_degrees(var_10_7) * math.sign(var_10_4.z)
	local var_10_9 = arg_10_0._wwise_world

	WwiseWorld.set_global_parameter(var_10_9, "player_camera_horizon_angle", var_10_8)
end

local var_0_9 = {}

function PlayerSoundEffectExtension._update_specials_proximity(arg_11_0, arg_11_1)
	arg_11_0._broadphase_update_timer = arg_11_0._broadphase_update_timer - arg_11_1

	if arg_11_0._broadphase_update_timer <= 0 then
		arg_11_0._broadphase_update_timer = var_0_8

		local var_11_0 = POSITION_LOOKUP[arg_11_0._unit]

		table.clear(var_0_9)

		local var_11_1 = Broadphase.query(arg_11_0._ai_broadphase, var_11_0, var_0_7, var_0_9)
		local var_11_2

		for iter_11_0 = 1, var_11_1 do
			repeat
				local var_11_3 = var_0_9[iter_11_0]

				if not HEALTH_ALIVE[var_11_3] then
					break
				end

				if not var_0_0(var_11_3, "breed").special then
					break
				end

				local var_11_4 = POSITION_LOOKUP[var_11_3]

				var_11_2 = Vector3.distance_squared(var_11_0, var_11_4) <= var_0_6^2 and "close" or var_11_2 or "medium"
			until true
		end

		var_11_2 = var_11_2 or "far"

		arg_11_0._music_manager:set_wwise_state("specials_proximity", var_11_2)
	end
end

function PlayerSoundEffectExtension.add_hit(arg_12_0)
	arg_12_0._recent_hit_cooldown = var_0_1

	local var_12_0 = math.min(arg_12_0._num_recent_hits + 1, var_0_3)

	arg_12_0:_set_hit_count(var_12_0)
end

function PlayerSoundEffectExtension.add_kill(arg_13_0)
	arg_13_0._recent_kill_cooldown = var_0_2

	local var_13_0 = math.min(arg_13_0._num_recent_kills + 1, var_0_4)

	arg_13_0:_set_kill_count(var_13_0)
end

function PlayerSoundEffectExtension.dodge(arg_14_0)
	if arg_14_0._first_person_unit then
		Unit.flow_event(arg_14_0._first_person_unit, "lua_dodge")
	end
end

function PlayerSoundEffectExtension.dodged_attack(arg_15_0)
	if arg_15_0._first_person_unit then
		Unit.flow_event(arg_15_0._first_person_unit, "lua_dodged_attack")
	end
end

function PlayerSoundEffectExtension.melee_kill(arg_16_0)
	if arg_16_0._first_person_unit then
		Unit.flow_event(arg_16_0._first_person_unit, "lua_melee_kill")
	end
end

function PlayerSoundEffectExtension.aggro_unit_changed(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = Unit.get_data(arg_17_1, "breed")

	if not var_17_0 then
		return
	end

	local var_17_1 = var_17_0.name
	local var_17_2 = var_0_5[var_17_1]

	if not var_17_2 then
		return
	end

	if arg_17_2 and arg_17_0._aggro_unit ~= arg_17_1 then
		arg_17_0._aggro_unit = arg_17_1

		local var_17_3 = POSITION_LOOKUP[arg_17_0._unit]
		local var_17_4 = POSITION_LOOKUP[arg_17_1]

		if var_17_2 >= Vector3.distance_squared(var_17_3, var_17_4) then
			local var_17_5 = arg_17_0._wwise_world

			WwiseWorld.set_global_parameter(var_17_5, "combat_combo_has_aggro", 1)
			WwiseWorld.trigger_event(var_17_5, "Play_boss_aggro_enter")
		else
			arg_17_0._aggro_unit = nil
			arg_17_0._waiting_aggro_unit = arg_17_1
		end
	elseif not arg_17_2 and arg_17_0._aggro_unit == arg_17_1 then
		arg_17_0._aggro_unit = nil
		arg_17_0._waiting_aggro_unit = nil

		local var_17_6 = arg_17_0._wwise_world

		WwiseWorld.set_global_parameter(var_17_6, "combat_combo_has_aggro", 0)
		WwiseWorld.trigger_event(var_17_6, "Play_boss_aggro_exit")
	end
end

function PlayerSoundEffectExtension.get_music_aggro_state(arg_18_0)
	if arg_18_0._aggro_unit then
		return "player"
	end

	return "husk"
end
