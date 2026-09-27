-- chunkname: @scripts/unit_extensions/generic/generic_volume_templates.lua

local VolumeFilters = VolumeFilters

VolumeFilters = VolumeFilters or {}
VolumeFilters = VolumeFilters

local GenericVolumeTemplates = GenericVolumeTemplates

GenericVolumeTemplates = GenericVolumeTemplates or {}
GenericVolumeTemplates = GenericVolumeTemplates
GenericVolumeTemplates.functions = {
	damage_volume = {
		generic_dot = {
			on_enter = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				local tbl = {
					t = arg_1_2,
					attacker_unit = arg_1_0,
					external_optional_bonus = {
						damage = arg_1_3.settings.damage,
						time_between_damage = arg_1_3.settings.time_between_damage
					}
				}

				arg_1_3[arg_1_0] = ScriptUnit.extension(arg_1_0, "buff_system"):add_buff("damage_volume_generic_dot", tbl)
			end,
			on_exit = function (arg_2_0, arg_2_1)
				-- function 2
				ScriptUnit.extension(arg_2_0, "buff_system"):remove_buff(arg_2_1[arg_2_0])

				arg_2_1[arg_2_0] = nil
			end
		},
		generic_insta_kill = {
			on_enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				ScriptUnit.extension(arg_3_0, "health_system"):entered_kill_volume(arg_3_2)
			end
		},
		heroes_insta_kill = {
			on_enter = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				if not Managers.state.side:versus_is_hero(arg_4_0) then
					ScriptUnit.extension(arg_4_0, "health_system"):entered_kill_volume(arg_4_2)
				end
			end
		},
		dark_pact_insta_kill = {
			on_enter = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				if not Managers.state.side:versus_is_dark_pact(arg_5_0) then
					ScriptUnit.extension(arg_5_0, "health_system"):entered_kill_volume(arg_5_2)
				end
			end
		},
		catacombs_corpse_pit = {
			on_enter = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				local system = Managers.state.entity:system("buff_system")
				local flag = true

				arg_6_3[arg_6_0] = system:add_buff(arg_6_0, "catacombs_corpse_pit", arg_6_0, flag)
			end,
			on_exit = function (arg_7_0, arg_7_1)
				-- function 7
				local var_7_0 = arg_7_1[arg_7_0]

				if var_7_0 == nil then
					return
				end

				Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_7_0, var_7_0)

				arg_7_1[arg_7_0] = nil
			end
		},
		cemetery_plague_floor = {
			on_enter = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				local system = Managers.state.entity:system("buff_system")
				local flag = true

				arg_8_3[arg_8_0] = system:add_buff(arg_8_0, "cemetery_plague_floor", arg_8_0, flag)
			end,
			on_exit = function (arg_9_0, arg_9_1)
				-- function 9
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
			on_enter = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				local system = Managers.state.entity:system("buff_system")
				local speed_multiplier = arg_10_3.settings.speed_multiplier

				system:add_volume_buff_multiplier(arg_10_0, "movement_volume_generic_slowdown", speed_multiplier)
			end,
			on_exit = function (arg_11_0, arg_11_1)
				-- function 11
				Managers.state.entity:system("buff_system"):remove_volume_buff_multiplier(arg_11_0, "movement_volume_generic_slowdown")
			end
		}
	},
	location_volume = {
		area_indication = {
			on_enter = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				local owner = Managers.player:owner(arg_12_0)
				local location = arg_12_3.params.location

				if not owner.local_player then
					ScriptUnit.extension(arg_12_0, "hud_system"):set_current_location(location)
				elseif not owner.remote then
					local go_id = Managers.state.unit_storage:go_id(arg_12_0)
					local var_12_3 = NetworkLookup.locations[location]
					local var_12_4 = PEER_ID_TO_CHANNEL[owner.peer_id]

					RPC.rpc_set_current_location(var_12_4, go_id, var_12_3)
				end
			end
		}
	},
	trigger_volume = {
		all_alive_humans_outside = {
			on_exit = function (arg_13_0, arg_13_1)
				-- function 13
				if not Managers.state.entity:system("volume_system"):volume_has_units_inside(arg_13_1.volume_name) then
					local event_on_triggered = arg_13_1.params.event_on_triggered

					if not event_on_triggered then
						Level.trigger_event(arg_13_1.level, event_on_triggered)
					end

					local on_triggered = arg_13_1.params.on_triggered

					if not on_triggered then
						on_triggered()
					end
				end
			end
		},
		local_player_inside = {
			on_enter = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				if arg_14_0 == Managers.player:local_player().player_unit then
					local event_on_triggered = arg_14_3.params.event_on_triggered

					if not event_on_triggered then
						return
					end

					Level.trigger_event(arg_14_3.level, event_on_triggered)
				end
			end,
			on_exit = function (arg_15_0, arg_15_1)
				-- function 15
				if arg_15_0 == Managers.player:local_player().player_unit then
					local event_on_exit = arg_15_1.params.event_on_exit

					if not event_on_exit then
						return
					end

					Level.trigger_event(arg_15_1.level, event_on_exit)
				end
			end
		},
		all_alive_players_outside = {
			on_exit = function (arg_16_0, arg_16_1)
				-- function 16
				if not Managers.state.entity:system("volume_system"):volume_has_units_inside(arg_16_1.volume_name) then
					local event_on_triggered = arg_16_1.params.event_on_triggered

					if not event_on_triggered then
						Level.trigger_event(arg_16_1.level, event_on_triggered)
					end

					local on_triggered = arg_16_1.params.on_triggered

					if not on_triggered then
						on_triggered()
					end
				end
			end
		},
		all_alive_players_outside_no_alive_inside = {
			on_exit = function (arg_17_0, arg_17_1)
				-- function 17
				if not Managers.state.entity:system("volume_system"):volume_has_units_inside(arg_17_1.volume_name) then
					local event_on_triggered = arg_17_1.params.event_on_triggered

					if not event_on_triggered then
						Level.trigger_event(arg_17_1.level, event_on_triggered)
					end

					local on_triggered = arg_17_1.params.on_triggered

					if not on_triggered then
						on_triggered()
					end
				end
			end
		},
		all_alive_players_inside = {
			on_enter = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				local event_on_triggered = arg_18_3.params.event_on_triggered
				local flag = not arg_18_3.all_players_inside

				if not event_on_triggered and not flag then
					Level.trigger_event(arg_18_3.level, event_on_triggered)

					arg_18_3.all_players_inside = true
				end

				local on_triggered = arg_18_3.params.on_triggered

				if not flag and not on_triggered then
					on_triggered()
				end
			end,
			on_exit = function (arg_19_0, arg_19_1)
				-- function 19
				local event_on_exit = arg_19_1.params.event_on_exit
				local all_players_inside = arg_19_1.all_players_inside

				if not event_on_exit and not all_players_inside then
					Level.trigger_event(arg_19_1.level, event_on_exit)

					arg_19_1.all_players_inside = false
				end

				local callback_on_exit = arg_19_1.params.callback_on_exit

				if not all_players_inside and not callback_on_exit then
					callback_on_exit()
				end
			end
		},
		all_non_disabled_players_inside = {
			on_enter = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				local event_on_triggered = arg_20_3.params.event_on_triggered
				local flag = not arg_20_3.all_players_inside

				if not event_on_triggered and not flag then
					Level.trigger_event(arg_20_3.level, event_on_triggered)

					arg_20_3.all_players_inside = true
				end

				local on_triggered = arg_20_3.params.on_triggered

				if not flag and not on_triggered then
					on_triggered()
				end
			end,
			on_exit = function (arg_21_0, arg_21_1)
				-- function 21
				local event_on_exit = arg_21_1.params.event_on_exit
				local all_players_inside = arg_21_1.all_players_inside

				if not event_on_exit and not all_players_inside then
					Level.trigger_event(arg_21_1.level, event_on_exit)

					arg_21_1.all_players_inside = false
				end

				local on_exit = arg_21_1.params.on_exit

				if not all_players_inside and not on_exit then
					on_exit()
				end
			end
		},
		non_disabled_players_inside = {
			on_enter = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				local event_on_triggered = arg_22_3.params.event_on_triggered
				local flag = not arg_22_3.params.player_entered

				if not event_on_triggered and not flag then
					Level.trigger_event(arg_22_3.level, event_on_triggered)

					arg_22_3.params.player_entered = true
				end

				local on_triggered = arg_22_3.params.on_triggered

				if not flag and not on_triggered then
					on_triggered()
				end
			end,
			on_exit = function (arg_23_0, arg_23_1)
				-- function 23
				if not Managers.state.entity:system("volume_system"):volume_has_units_inside(arg_23_1.volume_name) then
					local event_on_exit = arg_23_1.params.event_on_exit

					if not event_on_exit then
						Level.trigger_event(arg_23_1.level, event_on_exit)
					end

					local on_exit = arg_23_1.params.on_exit

					if not on_exit then
						on_exit()
					end

					arg_23_1.params.player_entered = false
				end
			end
		},
		ai_inside = {
			on_enter = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				local event_on_triggered = arg_24_3.params.event_on_triggered

				if not event_on_triggered then
					Level.trigger_event(arg_24_3.level, event_on_triggered)
				end

				local on_triggered = arg_24_3.params.on_triggered

				if not on_triggered then
					on_triggered()
				end

				local function fn()
					-- function 25
					GenericVolumeTemplates.functions.trigger_volume.ai_inside.on_exit(arg_24_0, arg_24_3)
				end

				Managers.state.entity:system("volume_system"):register_track_unit_dead(arg_24_0, fn)
			end,
			on_exit = function (arg_26_0, arg_26_1)
				-- function 26
				local event_on_exit = arg_26_1.params.event_on_exit

				if not event_on_exit then
					Level.trigger_event(arg_26_1.level, event_on_exit)
				end

				local on_exit = arg_26_1.params.on_exit

				if not on_exit then
					on_exit()
				end

				Managers.state.entity:system("volume_system"):unregister_track_unit_dead(arg_26_0)
			end
		},
		players_inside = {
			on_enter = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				local event_on_triggered = arg_27_3.params.event_on_triggered
				local flag = not arg_27_3.params.player_entered

				if not event_on_triggered and not flag then
					Level.trigger_event(arg_27_3.level, event_on_triggered)

					arg_27_3.params.player_entered = true
				end

				local on_triggered = arg_27_3.params.on_triggered

				if not flag and not on_triggered then
					on_triggered()
				end
			end,
			on_exit = function (arg_28_0, arg_28_1)
				-- function 28
				if not Managers.state.entity:system("volume_system"):volume_has_units_inside(arg_28_1.volume_name) then
					local event_on_exit = arg_28_1.params.event_on_exit

					if not event_on_exit then
						Level.trigger_event(arg_28_1.level, event_on_exit)
					end

					arg_28_1.params.player_entered = false

					local on_exit = arg_28_1.params.on_exit

					if not on_exit then
						on_exit()
					end
				end
			end
		}
	},
	despawn_volume = {
		pickup_projectiles = {
			on_enter = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				local event_on_triggered = arg_29_3.params.event_on_triggered

				if not event_on_triggered then
					Level.trigger_event(arg_29_3.level, event_on_triggered)
				end

				local has_extension = ScriptUnit.has_extension(arg_29_0, "kill_volume_handler_system")

				if not has_extension and not has_extension:on_hit_kill_volume() then
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
	unit_not_disabled = function (arg_30_0, arg_30_1)
		-- function 30
		return not ScriptUnit.extension(arg_30_0, "status_system"):is_disabled()
	end,
	unit_not_disabled_outside_or_disabled_inside_and_not_all_disabled_inside = function (arg_31_0, arg_31_1)
		-- function 31
		local is_disabled = ScriptUnit.extension(arg_31_0, "status_system"):is_disabled()
		local system = Managers.state.entity:system("volume_system")
		local player_inside = system:player_inside(arg_31_1.volume_name, arg_31_0)
		local all_human_players_inside_disabled = system:all_human_players_inside_disabled(arg_31_1.volume_name)
		local flag = not is_disabled and player_inside
		local flag_2 = not not player_inside or not is_disabled

		return (flag or not flag_2) and not not all_human_players_inside_disabled
	end,
	all_alive_players_inside = function (arg_32_0, arg_32_1)
		-- function 32
		return Managers.state.entity:system("volume_system"):all_alive_or_respawned_human_players_inside(arg_32_1.volume_name)
	end,
	all_non_disabled_players_inside = function (arg_33_0, arg_33_1)
		-- function 33
		return Managers.state.entity:system("volume_system"):all_alive_human_players_inside(arg_33_1.volume_name)
	end,
	is_alive_default_enemy = function (arg_34_0, arg_34_1)
		-- function 34
		if not HEALTH_ALIVE[arg_34_0] then
			return false
		end

		local conflict = Managers.state.conflict
		local side = Managers.state.side
		local flag = not side and side.side_by_unit[arg_34_0]

		return (not conflict and conflict.default_enemy_side_id) == (not flag and flag.side_id)
	end
}
