-- chunkname: @scripts/settings/dlcs/belakor/belakor_death_reactions.lua

return {
	tiny_explosive_barrel = {
		unit = {
			pre_start = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				return
			end,
			start = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = Managers.state.network:network_time()
				local var_2_1 = arg_2_3[DamageDataIndex.ATTACKER]
				local var_2_2 = {
					explode_time = var_2_0,
					killer_unit = var_2_1
				}
				local var_2_3 = ScriptUnit.has_extension(arg_2_0, "health_system").last_damage_data.attacker_unique_id
				local var_2_4 = Managers.player:player_from_unique_id(var_2_3)
				local var_2_5 = var_2_4 and var_2_4:stats_id()

				Managers.state.achievement:trigger_event("explosive_barrel_destroyed", var_2_5, arg_2_0, arg_2_3)

				ScriptUnit.extension(arg_2_0, "death_system").death_has_started = true

				return var_2_2, DeathReactions.IS_NOT_DONE
			end,
			update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = Managers.state.network:network_time()

				if not arg_3_4.exploded then
					Unit.flow_event(arg_3_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_3_0, false)

					local var_3_1 = ScriptUnit.extension(arg_3_0, "health_system")

					if var_3_1.in_hand then
						if not var_3_1.thrown then
							local var_3_2 = POSITION_LOOKUP[arg_3_0]
							local var_3_3 = Unit.local_rotation(arg_3_0, 0)
							local var_3_4 = "tiny_explosive_barrel"
							local var_3_5 = var_3_1.item_name
							local var_3_6 = var_3_1.owner_unit

							Managers.state.entity:system("area_damage_system"):create_explosion(var_3_6, var_3_2, var_3_3, var_3_4, 1, var_3_5, nil, false)

							local var_3_7 = ScriptUnit.extension(var_3_6, "inventory_system")
							local var_3_8 = var_3_7:equipment().wielded_slot

							var_3_7:destroy_slot(var_3_8)
							var_3_7:wield_previous_weapon()
						end
					else
						local var_3_9 = POSITION_LOOKUP[arg_3_0]
						local var_3_10 = Unit.local_rotation(arg_3_0, 0)
						local var_3_11 = "tiny_explosive_barrel"
						local var_3_12 = var_3_1.item_name
						local var_3_13 = var_3_1.last_damage_data
						local var_3_14 = Managers.state.network:game_object_or_level_unit(var_3_13.attacker_unit_id, false) or arg_3_0

						Managers.state.entity:system("area_damage_system"):create_explosion(var_3_14, var_3_9, var_3_10, var_3_11, 1, var_3_12, nil, false)

						if var_3_14 then
							local var_3_15 = ScriptUnit.has_extension(var_3_14, "buff_system")

							if var_3_15 then
								var_3_15:trigger_procs("on_barrel_exploded", var_3_9, var_3_10, var_3_12, arg_3_0)
							end
						end
					end

					arg_3_4.exploded = true
				elseif var_3_0 >= arg_3_4.explode_time + 0.5 then
					Managers.state.unit_spawner:mark_for_deletion(arg_3_0)

					return DeathReactions.IS_DONE
				end
			end
		},
		husk = {
			pre_start = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			start = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = Managers.state.network:network_time()
				local var_5_1 = {
					explode_time = var_5_0,
					killer_unit = arg_5_3[DamageDataIndex.ATTACKER]
				}
				local var_5_2 = ScriptUnit.has_extension(arg_5_0, "health_system").last_damage_data.attacker_unique_id
				local var_5_3 = Managers.player:player_from_unique_id(var_5_2)
				local var_5_4 = var_5_3 and var_5_3:stats_id()

				Managers.state.achievement:trigger_event("explosive_barrel_destroyed", var_5_4, arg_5_0, arg_5_3)

				ScriptUnit.extension(arg_5_0, "death_system").death_has_started = true

				return var_5_1, DeathReactions.IS_NOT_DONE
			end,
			update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = Managers.state.network:network_time()

				if not arg_6_4.exploded then
					Unit.flow_event(arg_6_0, "exploding_barrel_detonate")
					Unit.set_unit_visibility(arg_6_0, false)

					local var_6_1 = ScriptUnit.extension(arg_6_0, "health_system")

					if var_6_1.in_hand and not var_6_1.thrown then
						local var_6_2 = POSITION_LOOKUP[arg_6_0]
						local var_6_3 = Unit.local_rotation(arg_6_0, 0)
						local var_6_4 = "tiny_explosive_barrel"
						local var_6_5 = var_6_1.item_name
						local var_6_6 = var_6_1.owner_unit

						Managers.state.entity:system("area_damage_system"):create_explosion(var_6_6, var_6_2, var_6_3, var_6_4, 1, var_6_5, nil, false)

						local var_6_7 = ScriptUnit.extension(var_6_6, "inventory_system")
						local var_6_8 = var_6_7:equipment().wielded_slot

						var_6_7:destroy_slot(var_6_8)
						var_6_7:wield_previous_weapon()
					end

					arg_6_4.exploded = true
				elseif var_6_0 >= arg_6_4.explode_time + 0.5 then
					return DeathReactions.IS_DONE
				end
			end
		}
	}
}
