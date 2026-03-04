-- chunkname: @scripts/settings/ping_templates.lua

PingTypes = table.mirror_array_inplace({
	"ACKNOWLEDGE",
	"CANCEL",
	"CHAT_ONLY",
	"CONTEXT",
	"DENY",
	"ENEMY_AMBUSH",
	"ENEMY_ATTACK",
	"ENEMY_BOSS",
	"ENEMY_GENERIC",
	"ENEMY_PATROL",
	"MOVEMENT_GENERIC",
	"MOVEMENT_GROUP_UP",
	"MOVEMENT_WAIT",
	"MOVEMENTY_COME_HERE",
	"PING_ONLY",
	"PLAYER_COVER_ME",
	"PLAYER_HELP",
	"PLAYER_PICK_UP",
	"PLAYER_PICK_UP_ACKNOWLEDGE",
	"PLAYER_THANK_YOU",
	"VO_ONLY",
	"UNIT_DOWNED",
	"LOCAL_ONLY",
	"ENEMY_POSITION"
})
IgnoreFreeEvents = {
	[PingTypes.CONTEXT] = true,
	[PingTypes.CANCEL] = true,
	[PingTypes.MOVEMENT_GENERIC] = true,
	[PingTypes.ENEMY_GENERIC] = true,
	[PingTypes.UNIT_DOWNED] = true
}
IgnoreFreeCombatEvents = {
	[PingTypes.CANCEL] = true
}
IgnoreChatPings = {
	[PingTypes.CANCEL] = true,
	[PingTypes.MOVEMENT_GENERIC] = true,
	[PingTypes.PING_ONLY] = true,
	[PingTypes.ENEMY_POSITION] = true,
	[PingTypes.LOCAL_ONLY] = true,
	mechanism_overrides = {
		versus = {
			[PingTypes.ENEMY_GENERIC] = true,
			[PingTypes.PLAYER_PICK_UP] = true,
			[PingTypes.ACKNOWLEDGE] = true
		}
	}
}
PingMessagesByPingType = {
	versus = {
		[PingTypes.PLAYER_PICK_UP] = {
			default = "versus_pickup_lookup_deafult",
			ammo = "versus_pickup_lookup_ammo",
			health_flask = "versus_pickup_lookup_health_flask",
			health = "versus_pickup_lookup_health",
			potion = "versus_pickup_lookup_potion",
			bomb = "versus_pickup_lookup_bomb"
		},
		[PingTypes.ENEMY_GENERIC] = {
			default = "versus_generic_enemy",
			vs_gutter_runner = "versus_ping_skaven_gutter_runner",
			vs_poison_wind_globadier = "versus_ping_skaven_poison_wind_globadier",
			vs_warpfire_thrower = "versus_ping_skaven_warpfire_thrower",
			vs_ratling_gunner = "versus_ping_skaven_ratling_gunner",
			vs_packmaster = "versus_ping_skaven_pack_master"
		}
	}
}
PingTemplates = {
	generic_item = {
		check_func = function (arg_1_0, arg_1_1, arg_1_2)
			return arg_1_2 and (ScriptUnit.has_extension(arg_1_2, "pickup_system") or Managers.state.network:level_object_id(arg_1_2))
		end,
		responses = {
			[PingTypes.ENEMY_GENERIC] = {
				true,
				{
					"ENEMY_GENERIC"
				}
			},
			[PingTypes.MOVEMENT_GENERIC] = {
				true,
				{
					"MOVEMENT_GENERIC"
				},
				"ping_friendly"
			},
			[PingTypes.PLAYER_PICK_UP] = {
				true,
				{
					"PLAYER_PICK_UP"
				}
			},
			[PingTypes.CANCEL] = {
				false,
				{
					"CANCEL"
				}
			},
			[PingTypes.ACKNOWLEDGE] = {
				false,
				{
					"ACKNOWLEDGE"
				}
			},
			[PingTypes.DENY] = {
				false,
				{
					"DENY"
				}
			},
			mechanism_overrides = {
				versus = {
					[PingTypes.PLAYER_PICK_UP] = {
						true,
						{
							PingMessagesByPingType.versus[PingTypes.PLAYER_PICK_UP].default
						}
					}
				}
			}
		},
		exec_func = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
			local var_2_0 = arg_2_0.responses[arg_2_4]

			if var_2_0 then
				local var_2_1 = PingMessagesByPingType[arg_2_6]
				local var_2_2 = var_2_1 and var_2_1[arg_2_4]

				if var_2_2 then
					local var_2_3 = arg_2_3 and Unit.get_data(arg_2_3, "lookat_tag")

					if var_2_3 then
						local var_2_4, var_2_5, var_2_6 = unpack(var_2_0)

						var_2_5[1] = var_2_2[var_2_3] or var_2_2.default

						return var_2_4, var_2_5, var_2_6
					end
				end

				return unpack(var_2_0)
			end

			return true, nil, nil
		end
	},
	enemy_unit = {
		check_func = function (arg_3_0, arg_3_1, arg_3_2)
			return arg_3_2 and Managers.state.side:is_enemy(arg_3_1, arg_3_2)
		end,
		responses = {
			[PingTypes.ENEMY_GENERIC] = {
				true,
				{
					"ENEMY_GENERIC"
				}
			},
			[PingTypes.MOVEMENT_GENERIC] = {
				true,
				{
					"MOVEMENT_GENERIC"
				},
				"ping_friendly"
			},
			[PingTypes.PLAYER_PICK_UP] = {
				true,
				{
					"PLAYER_PICK_UP"
				}
			},
			[PingTypes.CANCEL] = {
				false,
				{
					"CANCEL"
				}
			},
			[PingTypes.ACKNOWLEDGE] = {
				false,
				{
					"ACKNOWLEDGE"
				}
			},
			[PingTypes.DENY] = {
				false,
				{
					"DENY"
				}
			}
		},
		exec_func = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
			local var_4_0 = arg_4_0.responses[arg_4_4]

			if var_4_0 then
				local var_4_1 = PingMessagesByPingType[arg_4_6]
				local var_4_2 = var_4_1 and var_4_1[arg_4_4]

				if var_4_2 then
					local var_4_3 = arg_4_3 and Unit.get_data(arg_4_3, "breed")

					if var_4_3 then
						local var_4_4, var_4_5, var_4_6 = unpack(var_4_0)

						var_4_5[1] = var_4_2[var_4_3.name] or var_4_2.default

						return var_4_4, var_4_5, var_4_6
					end
				end

				return unpack(var_4_0)
			end

			return true, nil, nil
		end
	},
	friendly_unit = {
		check_func = function (arg_5_0, arg_5_1, arg_5_2)
			return arg_5_2 and not Managers.state.side:is_enemy(arg_5_1, arg_5_2)
		end,
		responses = {
			[PingTypes.ENEMY_GENERIC] = {
				true,
				{
					"ENEMY_GENERIC"
				}
			},
			[PingTypes.MOVEMENT_GENERIC] = {
				true,
				{
					"MOVEMENT_GENERIC"
				},
				"ping_friendly"
			},
			[PingTypes.PLAYER_PICK_UP] = {
				true,
				{
					"PLAYER_PICK_UP"
				}
			},
			[PingTypes.CANCEL] = {
				false,
				{
					"CANCEL"
				}
			},
			[PingTypes.ACKNOWLEDGE] = {
				false,
				{
					"ACKNOWLEDGE"
				}
			},
			[PingTypes.DENY] = {
				false,
				{
					"DENY"
				}
			},
			[PingTypes.CHAT_ONLY] = {
				true
			},
			[PingTypes.UNIT_DOWNED] = {
				true
			}
		},
		exec_func = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
			local var_6_0 = arg_6_0.responses[arg_6_4]

			if var_6_0 then
				return unpack(var_6_0)
			end

			return false, nil, nil
		end
	},
	position_only = {
		check_func = function (arg_7_0, arg_7_1, arg_7_2)
			return not arg_7_2
		end,
		responses = {
			[PingTypes.ENEMY_GENERIC] = {
				true,
				{
					"ENEMY_GENERIC"
				}
			},
			[PingTypes.MOVEMENT_GENERIC] = {
				true,
				{
					"MOVEMENT_GENERIC"
				},
				"ping_friendly"
			},
			[PingTypes.PLAYER_PICK_UP] = {
				true,
				{
					"PLAYER_PICK_UP"
				}
			},
			[PingTypes.CANCEL] = {
				false,
				{
					"CANCEL"
				}
			},
			[PingTypes.ACKNOWLEDGE] = {
				false,
				{
					"ACKNOWLEDGE"
				}
			},
			[PingTypes.DENY] = {
				false,
				{
					"DENY"
				}
			},
			[PingTypes.ENEMY_POSITION] = {
				true,
				{
					"ENEMY_POSITION"
				},
				"ping_hostile"
			}
		},
		exec_func = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
			local var_8_0 = arg_8_0.responses[arg_8_4]

			if var_8_0 then
				return unpack(var_8_0)
			end

			return true, nil, nil
		end
	}
}
