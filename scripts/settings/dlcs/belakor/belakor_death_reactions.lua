-- chunkname: @scripts/settings/dlcs/belakor/belakor_death_reactions.lua

return {
	tiny_explosive_barrel = {
		unit = {
			pre_start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				return
			end,
			start = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local network_time = Managers.state.network:network_time()
				local var_2_1 = arg_2_3[DamageDataIndex.ATTACKER]
				local tbl = {
					explode_time = network_time,
					killer_unit = var_2_1
				}
				local attacker_unique_id = ScriptUnit.has_extension(arg_2_0, "health_system").last_damage_data.attacker_unique_id
				local player_from_unique_id = Managers.player:player_from_unique_id(attacker_unique_id)
				local flag = not player_from_unique_id and player_from_unique_id:stats_id()

				Managers.state.achievement:trigger_event("explosive_barrel_destroyed", flag, arg_2_0, arg_2_3)

				ScriptUnit.extension(arg_2_0, "death_system").death_has_started = true

				return tbl, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				local network_time = Managers.state.network:network_time()

				if not arg_3_4.exploded then
					Unit.flow_event(arg_3_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_3_0, false)

					local extension = ScriptUnit.extension(arg_3_0, "health_system")

					if not extension.in_hand then
						if not extension.thrown then
							local var_3_2 = POSITION_LOOKUP[arg_3_0]
							local local_rotation = Unit.local_rotation(arg_3_0, 0)
							local str = "tiny_explosive_barrel"
							local item_name = extension.item_name
							local owner_unit = extension.owner_unit

							Managers.state.entity:system("area_damage_system"):create_explosion(owner_unit, var_3_2, local_rotation, str, 1, item_name, nil, false)

							local extension_2 = ScriptUnit.extension(owner_unit, "inventory_system")
							local wielded_slot = extension_2:equipment().wielded_slot

							extension_2:destroy_slot(wielded_slot)
							extension_2:wield_previous_weapon()
						end
					else
						local var_3_9 = POSITION_LOOKUP[arg_3_0]
						local local_rotation_2 = Unit.local_rotation(arg_3_0, 0)
						local str_2 = "tiny_explosive_barrel"
						local item_name_2 = extension.item_name
						local last_damage_data = extension.last_damage_data
						local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(last_damage_data.attacker_unit_id, false)

						game_object_or_level_unit = game_object_or_level_unit or arg_3_0

						Managers.state.entity:system("area_damage_system"):create_explosion(game_object_or_level_unit, var_3_9, local_rotation_2, str_2, 1, item_name_2, nil, false)

						if not game_object_or_level_unit then
							local has_extension = ScriptUnit.has_extension(game_object_or_level_unit, "buff_system")

							if not has_extension then
								has_extension:trigger_procs("on_barrel_exploded", var_3_9, local_rotation_2, item_name_2, arg_3_0)
							end
						end
					end

					arg_3_4.exploded = true
				elseif network_time >= arg_3_4.explode_time + 0.5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_3_0)

					return DeathReactions.IS_DONE
				end
			end
		},
		husk = {
			pre_start = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end,
			start = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local network_time = Managers.state.network:network_time()
				local tbl = {
					explode_time = network_time,
					killer_unit = arg_5_3[DamageDataIndex.ATTACKER]
				}
				local attacker_unique_id = ScriptUnit.has_extension(arg_5_0, "health_system").last_damage_data.attacker_unique_id
				local player_from_unique_id = Managers.player:player_from_unique_id(attacker_unique_id)
				local flag = not player_from_unique_id and player_from_unique_id:stats_id()

				Managers.state.achievement:trigger_event("explosive_barrel_destroyed", flag, arg_5_0, arg_5_3)

				ScriptUnit.extension(arg_5_0, "death_system").death_has_started = true

				return tbl, DeathReactions.IS_NOT_DONE
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local network_time = Managers.state.network:network_time()

				if not arg_6_4.exploded then
					Unit.flow_event(arg_6_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_6_0, false)

					local extension = ScriptUnit.extension(arg_6_0, "health_system")

					if not (not extension.in_hand and extension.thrown) then
						local var_6_2 = POSITION_LOOKUP[arg_6_0]
						local local_rotation = Unit.local_rotation(arg_6_0, 0)
						local str = "tiny_explosive_barrel"
						local item_name = extension.item_name
						local owner_unit = extension.owner_unit

						Managers.state.entity:system("area_damage_system"):create_explosion(owner_unit, var_6_2, local_rotation, str, 1, item_name, nil, false)

						local extension_2 = ScriptUnit.extension(owner_unit, "inventory_system")
						local wielded_slot = extension_2:equipment().wielded_slot

						extension_2:destroy_slot(wielded_slot)
						extension_2:wield_previous_weapon()
					end

					arg_6_4.exploded = true
				elseif network_time >= arg_6_4.explode_time + 0.5 then
					return DeathReactions.IS_DONE
				end
			end
		}
	}
}
