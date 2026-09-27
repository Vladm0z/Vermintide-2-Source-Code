-- chunkname: @scripts/unit_extensions/ai_supplementary/beastmen_standard_templates.lua

BeastmenStandardTemplates = {
	invincibility_standard = {
		buff_template_name = "invincibility_standard",
		radius = 20,
		astar_check_frequency = 10,
		apply_buff_to_ai = true,
		vfx_picked_up_standard = "fx/chr_beastmen_standard_bearer_end_02",
		ai_buff_proc_vfx_name = "",
		ai_buff_vfx_name = ""
	},
	healing_standard = {
		sfx_taking_damage = "Play_enemy_beastmen_standar_taking_damage",
		radius = 15,
		astar_check_frequency = 10,
		apply_buff_to_ai = true,
		sfx_destroyed = "Play_enemy_beastmen_standar_destroy",
		ai_buff_proc_vfx_name = "fx/chr_beastmen_standard_bearer_buff_02",
		vfx_picked_up_standard = "fx/chr_beastmen_standard_bearer_end_02",
		buff_template_name = "healing_standard",
		sfx_placed = "Play_enemy_standard_bearer_place_standar",
		sfx_loop_stop = "Stop_enemy_beastmen_standar_spell_loop",
		apply_buff_to_player = false,
		ai_buff_vfx_name = "fx/chr_beastmen_standard_bearer_buff_01",
		custom_update_func = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
			-- function 1
			if not arg_1_1.is_server and arg_1_1.challenge_done and not (arg_1_2 > arg_1_1.challenge_time) or not HEALTH_ALIVE[arg_1_1.standard_bearer_unit] then
				local str = "scorpion_keep_standard_bearer_alive"
				local var_1_1 = NetworkLookup.statistics[str]
				local statistics_db = Managers.player:statistics_db()
				local local_player = Managers.player:local_player()

				if not local_player then
					local stats_id = local_player:stats_id()

					statistics_db:increment_stat(stats_id, str)
					Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", var_1_1)
				end

				arg_1_1.challenge_done = true
			end
		end
	},
	horde_standard = {
		radius = 12,
		sfx_loop_stop = "Stop_enemy_beastmen_standar_spell_loop",
		sfx_destroyed = "Play_enemy_beastmen_standar_destroy",
		vfx_picked_up_standard = "fx/chr_beastmen_standard_bearer_end_02",
		sfx_placed = "Play_enemy_standard_bearer_place_standar",
		sfx_taking_damage = "Play_enemy_beastmen_standar_taking_damage",
		astar_check_frequency = 10,
		composition = "standard_bearer_ambush",
		custom_update_func = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
			-- function 2
			local next_horde_t = arg_2_1.next_horde_t

			next_horde_t = next_horde_t or 0

			if next_horde_t < arg_2_2 then
				local conflict = Managers.state.conflict
				local local_position = Unit.local_position(arg_2_4, 0)
				local var_2_3 = HordeCompositions[self.composition]
				local get_difficulty_rank, var_2_5 = Managers.state.difficulty:get_difficulty_rank()
				local var_2_6 = var_2_3[DifficultyTweak.converters.composition_rank(get_difficulty_rank, var_2_5) - 1]
				local tbl = {
					sound_settings = self.horde_sound_settings
				}

				conflict.horde_spawner:execute_ambush_horde(tbl, conflict.default_enemy_side_id, false, local_position, var_2_6)

				arg_2_1.next_horde_t = arg_2_2 + 10
			end
		end,
		horde_sound_settings = {
			stinger_sound_event = "enemy_horde_beastmen_stinger",
			music_states = {
				pre_ambush = "pre_ambush_beastmen",
				horde = "horde_beastmen"
			}
		}
	}
}
