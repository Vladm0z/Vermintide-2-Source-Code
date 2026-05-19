-- chunkname: @scripts/unit_extensions/generic/generic_volume_templates.lua

VolumeFilters = VolumeFilters or {}
GenericVolumeTemplates = GenericVolumeTemplates or {}
GenericVolumeTemplates.functions = {
	damage_volume = {
		generic_dot = {
			on_enter = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				local var_1_0 = {
					t = arg_1_2,
					attacker_unit = arg_1_0,
					external_optional_bonus = {
						damage = arg_1_3.settings.damage,
						time_between_damage = arg_1_3.settings.time_between_damage
					}
				}

				arg_1_3[arg_1_0] = ScriptUnit.extension(arg_1_0, "buff_system"):add_buff("damage_volume_generic_dot", var_1_0)
			end,
			on_exit = function(arg_2_0, arg_2_1)
				ScriptUnit.extension(arg_2_0, "buff_system"):remove_buff(arg_2_1[arg_2_0])

				arg_2_1[arg_2_0] = nil
			end
		},
		generic_insta_kill = {
			on_enter = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				ScriptUnit.extension(arg_3_0, "health_system"):entered_kill_volume(arg_3_2)
			end
		},
		heroes_insta_kill = {
			on_enter = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				if Managers.state.side:versus_is_hero(arg_4_0) then
					ScriptUnit.extension(arg_4_0, "health_system"):entered_kill_volume(arg_4_2)
				end
			end
		},
		dark_pact_insta_kill = {
			on_enter = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				if Managers.state.side:versus_is_dark_pact(arg_5_0) then
					ScriptUnit.extension(arg_5_0, "health_system"):entered_kill_volume(arg_5_2)
				end
			end
		},
		catacombs_corpse_pit = {
			on_enter = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				local var_6_0 = Managers.state.entity:system("buff_system")
				local var_6_1 = true

				arg_6_3[arg_6_0] = var_6_0:add_buff(arg_6_0, "catacombs_corpse_pit", arg_6_0, var_6_1)
			end,
			on_exit = function(arg_7_0, arg_7_1)
				local var_7_0 = arg_7_1[arg_7_0]

				if var_7_0 == nil then
					return
				end

				Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_7_0, var_7_0)

				arg_7_1[arg_7_0] = nil
			end
		},
		cemetery_plague_floor = {
			on_enter = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				local var_8_0 = Managers.state.entity:system("buff_system")
				local var_8_1 = true

				arg_8_3[arg_8_0] = var_8_0:add_buff(arg_8_0, "cemetery_plague_floor", arg_8_0, var_8_1)
			end,
			on_exit = function(arg_9_0, arg_9_1)
				local var_9_0 = arg_9_1[arg_9_0]

				if var_9_0 == nil then
					return
				end

				Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_9_0, var_9_0)

				arg_9_1[arg_9_0] = nil
			end
		}
	},
	movement_volume = {
		generic_slowdown = {
			on_enter = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				local var_10_0 = Managers.state.entity:system("buff_system")
				local var_10_1 = arg_10_3.settings.speed_multiplier

				var_10_0:add_volume_buff_multiplier(arg_10_0, "movement_volume_generic_slowdown", var_10_1)
			end,
			on_exit = function(arg_11_0, arg_11_1)
				Managers.state.entity:system("buff_system"):remove_volume_buff_multiplier(arg_11_0, "movement_volume_generic_slowdown")
			end
		}
	},
	location_volume = {
		area_indication = {
			on_enter = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				local var_12_0 = Managers.player:owner(arg_12_0)
				local var_12_1 = arg_12_3.params.location

				if var_12_0.local_player then
					ScriptUnit.extension(arg_12_0, "hud_system"):set_current_location(var_12_1)
				elseif var_12_0.remote then
					local var_12_2 = Managers.state.unit_storage:go_id(arg_12_0)
					local var_12_3 = NetworkLookup.locations[var_12_1]
					local var_12_4 = PEER_ID_TO_CHANNEL[var_12_0.peer_id]

					RPC.rpc_set_current_location(var_12_4, var_12_2, var_12_3)
				end
			end
		}
	},
	trigger_volume = {
		all_alive_humans_outside = {
			on_exit = function(arg_13_0, arg_13_1)
				if not Managers.state.entity:system("volume_system"):volume_has_units_inside(arg_13_1.volume_name) then
					local var_13_0 = arg_13_1.params.event_on_triggered

					if var_13_0 then
						Level.trigger_event(arg_13_1.level, var_13_0)
					end

					local var_13_1 = arg_13_1.params.on_triggered

					if var_13_1 then
						var_13_1()
					end
				end
			end
		},
		local_player_inside = {
			on_enter = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				if arg_14_0 == Managers.player:local_player().player_unit then
					local var_14_0 = arg_14_3.params.event_on_triggered

					if not var_14_0 then
						return
					end

					Level.trigger_event(arg_14_3.level, var_14_0)
				end
			end,
			on_exit = function(arg_15_0, arg_15_1)
				if arg_15_0 == Managers.player:local_player().player_unit then
					local var_15_0 = arg_15_1.params.event_on_exit

					if not var_15_0 then
						return
					end

					Level.trigger_event(arg_15_1.level, var_15_0)
				end
			end
		},
		all_alive_players_outside = {
			on_exit = function(arg_16_0, arg_16_1)
				if not Managers.state.entity:system("volume_system"):volume_has_units_inside(arg_16_1.volume_name) then
					local var_16_0 = arg_16_1.params.event_on_triggered

					if var_16_0 then
						Level.trigger_event(arg_16_1.level, var_16_0)
					end

					local var_16_1 = arg_16_1.params.on_triggered

					if var_16_1 then
						var_16_1()
					end
				end
			end
		},
		all_alive_players_outside_no_alive_inside = {
			on_exit = function(arg_17_0, arg_17_1)
				if not Managers.state.entity:system("volume_system"):volume_has_units_inside(arg_17_1.volume_name) then
					local var_17_0 = arg_17_1.params.event_on_triggered

					if var_17_0 then
						Level.trigger_event(arg_17_1.level, var_17_0)
					end

					local var_17_1 = arg_17_1.params.on_triggered

					if var_17_1 then
						var_17_1()
					end
				end
			end
		},
		all_alive_players_inside = {
			on_enter = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				local var_18_0 = arg_18_3.params.event_on_triggered
				local var_18_1 = not arg_18_3.all_players_inside

				if var_18_0 and var_18_1 then
					Level.trigger_event(arg_18_3.level, var_18_0)

					arg_18_3.all_players_inside = true
				end

				local var_18_2 = arg_18_3.params.on_triggered

				if var_18_1 and var_18_2 then
					var_18_2()
				end
			end,
			on_exit = function(arg_19_0, arg_19_1)
				local var_19_0 = arg_19_1.params.event_on_exit
				local var_19_1 = arg_19_1.all_players_inside

				if var_19_0 and var_19_1 then
					Level.trigger_event(arg_19_1.level, var_19_0)

					arg_19_1.all_players_inside = false
				end

				local var_19_2 = arg_19_1.params.callback_on_exit

				if var_19_1 and var_19_2 then
					var_19_2()
				end
			end
		},
		all_non_disabled_players_inside = {
			on_enter = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				local var_20_0 = arg_20_3.params.event_on_triggered
				local var_20_1 = not arg_20_3.all_players_inside

				if var_20_0 and var_20_1 then
					Level.trigger_event(arg_20_3.level, var_20_0)

					arg_20_3.all_players_inside = true
				end

				local var_20_2 = arg_20_3.params.on_triggered

				if var_20_1 and var_20_2 then
					var_20_2()
				end
			end,
			on_exit = function(arg_21_0, arg_21_1)
				local var_21_0 = arg_21_1.params.event_on_exit
				local var_21_1 = arg_21_1.all_players_inside

				if var_21_0 and var_21_1 then
					Level.trigger_event(arg_21_1.level, var_21_0)

					arg_21_1.all_players_inside = false
				end

				local var_21_2 = arg_21_1.params.on_exit

				if var_21_1 and var_21_2 then
					var_21_2()
				end
			end
		},
		non_disabled_players_inside = {
			on_enter = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				local var_22_0 = arg_22_3.params.event_on_triggered
				local var_22_1 = not arg_22_3.params.player_entered

				if var_22_0 and var_22_1 then
					Level.trigger_event(arg_22_3.level, var_22_0)

					arg_22_3.params.player_entered = true
				end

				local var_22_2 = arg_22_3.params.on_triggered

				if var_22_1 and var_22_2 then
					var_22_2()
				end
			end,
			on_exit = function(arg_23_0, arg_23_1)
				if not Managers.state.entity:system("volume_system"):volume_has_units_inside(arg_23_1.volume_name) then
					local var_23_0 = arg_23_1.params.event_on_exit

					if var_23_0 then
						Level.trigger_event(arg_23_1.level, var_23_0)
					end

					local var_23_1 = arg_23_1.params.on_exit

					if var_23_1 then
						var_23_1()
					end

					arg_23_1.params.player_entered = false
				end
			end
		},
		ai_inside = {
			on_enter = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				local var_24_0 = arg_24_3.params.event_on_triggered

				if var_24_0 then
					Level.trigger_event(arg_24_3.level, var_24_0)
				end

				local var_24_1 = arg_24_3.params.on_triggered

				if var_24_1 then
					var_24_1()
				end

				local function var_24_2()
					GenericVolumeTemplates.functions.trigger_volume.ai_inside.on_exit(arg_24_0, arg_24_3)
				end

				Managers.state.entity:system("volume_system"):register_track_unit_dead(arg_24_0, var_24_2)
			end,
			on_exit = function(arg_26_0, arg_26_1)
				local var_26_0 = arg_26_1.params.event_on_exit

				if var_26_0 then
					Level.trigger_event(arg_26_1.level, var_26_0)
				end

				local var_26_1 = arg_26_1.params.on_exit

				if var_26_1 then
					var_26_1()
				end

				Managers.state.entity:system("volume_system"):unregister_track_unit_dead(arg_26_0)
			end
		},
		players_inside = {
			on_enter = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				local var_27_0 = arg_27_3.params.event_on_triggered
				local var_27_1 = not arg_27_3.params.player_entered

				if var_27_0 and var_27_1 then
					Level.trigger_event(arg_27_3.level, var_27_0)

					arg_27_3.params.player_entered = true
				end

				local var_27_2 = arg_27_3.params.on_triggered

				if var_27_1 and var_27_2 then
					var_27_2()
				end
			end,
			on_exit = function(arg_28_0, arg_28_1)
				if not Managers.state.entity:system("volume_system"):volume_has_units_inside(arg_28_1.volume_name) then
					local var_28_0 = arg_28_1.params.event_on_exit

					if var_28_0 then
						Level.trigger_event(arg_28_1.level, var_28_0)
					end

					arg_28_1.params.player_entered = false

					local var_28_1 = arg_28_1.params.on_exit

					if var_28_1 then
						var_28_1()
					end
				end
			end
		}
	},
	despawn_volume = {
		pickup_projectiles = {
			on_enter = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				local var_29_0 = arg_29_3.params.event_on_triggered

				if var_29_0 then
					Level.trigger_event(arg_29_3.level, var_29_0)
				end

				local var_29_1 = ScriptUnit.has_extension(arg_29_0, "kill_volume_handler_system")

				if var_29_1 and var_29_1:on_hit_kill_volume() then
					return
				end

				Managers.state.unit_spawner:mark_for_deletion(arg_29_0)
			end
		}
	}
}
GenericVolumeTemplates.functions.damage_volume.warpstone_meteor = GenericVolumeTemplates.functions.damage_volume.generic_dot
GenericVolumeTemplates.functions.damage_volume.generic_fire = GenericVolumeTemplates.functions.damage_volume.generic_dot
GenericVolumeTemplates.functions.damage_volume.ai_insta_kill = GenericVolumeTemplates.functions.damage_volume.generic_insta_kill
GenericVolumeTemplates.functions.damage_volume.player_insta_kill = GenericVolumeTemplates.functions.damage_volume.generic_insta_kill
GenericVolumeTemplates.functions.damage_volume.generic_insta_kill_no_cost = GenericVolumeTemplates.functions.damage_volume.generic_insta_kill
GenericVolumeTemplates.functions.damage_volume.ai_insta_kill_no_cost = GenericVolumeTemplates.functions.damage_volume.generic_insta_kill
GenericVolumeTemplates.functions.damage_volume.player_insta_kill_no_cost = GenericVolumeTemplates.functions.damage_volume.generic_insta_kill
GenericVolumeTemplates.functions.damage_volume.pactsworn_insta_kill_no_cost = GenericVolumeTemplates.functions.damage_volume.dark_pact_insta_kill
GenericVolumeTemplates.functions.damage_volume.heroes_insta_kill_no_cost = GenericVolumeTemplates.functions.damage_volume.heroes_insta_kill
GenericVolumeTemplates.functions.damage_volume.ai_kill_dot = GenericVolumeTemplates.functions.damage_volume.generic_dot
GenericVolumeTemplates.functions.damage_volume.ai_kill_dot_no_cost = GenericVolumeTemplates.functions.damage_volume.generic_dot
GenericVolumeTemplates.functions.damage_volume.skaven_molten_steel = GenericVolumeTemplates.functions.damage_volume.generic_dot
GenericVolumeTemplates.filters = {
	unit_not_disabled = function(arg_30_0, arg_30_1)
		return not ScriptUnit.extension(arg_30_0, "status_system"):is_disabled()
	end,
	unit_not_disabled_outside_or_disabled_inside_and_not_all_disabled_inside = function(arg_31_0, arg_31_1)
		local var_31_0 = ScriptUnit.extension(arg_31_0, "status_system"):is_disabled()
		local var_31_1 = Managers.state.entity:system("volume_system")
		local var_31_2 = var_31_1:player_inside(arg_31_1.volume_name, arg_31_0)
		local var_31_3 = var_31_1:all_human_players_inside_disabled(arg_31_1.volume_name)
		local var_31_4 = var_31_0 and var_31_2
		local var_31_5 = not var_31_2 and not var_31_0

		return not var_31_4 and not var_31_5 or not not var_31_3
	end,
	all_alive_players_inside = function(arg_32_0, arg_32_1)
		return Managers.state.entity:system("volume_system"):all_alive_or_respawned_human_players_inside(arg_32_1.volume_name)
	end,
	all_non_disabled_players_inside = function(arg_33_0, arg_33_1)
		return Managers.state.entity:system("volume_system"):all_alive_human_players_inside(arg_33_1.volume_name)
	end,
	is_alive_default_enemy = function(arg_34_0, arg_34_1)
		if not HEALTH_ALIVE[arg_34_0] then
			return false
		end

		local var_34_0 = Managers.state.conflict
		local var_34_1 = Managers.state.side
		local var_34_2 = var_34_1 and var_34_1.side_by_unit[arg_34_0]

		return (var_34_0 and var_34_0.default_enemy_side_id) == (var_34_2 and var_34_2.side_id)
	end
}
