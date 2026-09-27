-- chunkname: @scripts/settings/volume_settings.lua

require("scripts/unit_extensions/generic/generic_volume_templates")

local str = "PlayerVolumeExtension"
local str_2 = "BotVolumeExtension"
local str_3 = "AIVolumeExtension"
local str_4 = "PickupProjectileVolumeExtension"
local str_5 = "LocalPlayerVolumeExtension"
local VolumeSystemSettings = VolumeSystemSettings

VolumeSystemSettings = VolumeSystemSettings or {
	updates_per_frame = {
		[str] = 4,
		[str_5] = 1,
		[str_2] = 3,
		[str_3] = 10,
		[str_4] = 1
	},
	traversal_costs = {
		high = 2,
		inferno = 100000,
		low = 1.2,
		insane = 4,
		medium = 1.5
	}
}
VolumeSystemSettings = VolumeSystemSettings

local VolumeExtensionSettings = VolumeExtensionSettings

VolumeExtensionSettings = VolumeExtensionSettings or {
	damage_volume = {
		generic_dot = {
			[str] = {
				time_between_damage = 2,
				damage = {
					10,
					10,
					10,
					10,
					10
				}
			},
			[str_2] = {
				traversal_cost = "low",
				time_between_damage = 2,
				damage = {
					10,
					10,
					10,
					10,
					10
				}
			},
			[str_3] = {
				traversal_cost = "low",
				time_between_damage = 2,
				damage = {
					1,
					1,
					1,
					1,
					1
				}
			}
		},
		warpstone_meteor = {
			[str] = {
				time_between_damage = 0.1,
				damage = {
					3,
					3,
					3,
					3,
					3
				}
			},
			[str_2] = {
				traversal_cost = "medium",
				time_between_damage = 0.1,
				damage = {
					3,
					3,
					3,
					3,
					3
				}
			},
			[str_3] = {
				traversal_cost = "medium",
				time_between_damage = 0.1,
				damage = {
					4,
					4,
					4,
					4,
					4
				}
			}
		},
		ai_kill_dot = {
			[str_3] = {
				traversal_cost = "insane",
				time_between_damage = 0.1,
				damage = {
					500,
					500,
					500,
					500,
					500
				}
			}
		},
		generic_insta_kill = {
			[str] = {},
			[str_5] = {},
			[str_2] = {
				traversal_cost = "high"
			},
			[str_3] = {
				traversal_cost = "high"
			}
		},
		player_insta_kill = {
			[str] = {},
			[str_5] = {},
			[str_2] = {
				traversal_cost = "high"
			}
		},
		ai_insta_kill = {
			[str_3] = {
				traversal_cost = "high"
			}
		},
		generic_insta_kill_no_cost = {
			[str] = {},
			[str_5] = {},
			[str_2] = {},
			[str_3] = {}
		},
		player_insta_kill_no_cost = {
			[str] = {},
			[str_5] = {},
			[str_2] = {}
		},
		pactsworn_insta_kill_no_cost = {
			[str] = {},
			[str_5] = {},
			[str_2] = {}
		},
		heroes_insta_kill_no_cost = {
			[str] = {},
			[str_5] = {},
			[str_2] = {}
		},
		ai_insta_kill_no_cost = {
			[str_3] = {}
		},
		ai_kill_dot_no_cost = {
			[str_3] = {
				time_between_damage = 0.1,
				damage = {
					500,
					500,
					500,
					500,
					500
				}
			}
		},
		generic_fire = {
			[str] = {
				time_between_damage = 0.5,
				damage = {
					1,
					1,
					1,
					1,
					1
				}
			},
			[str_2] = {
				traversal_cost = "high",
				time_between_damage = 0.5,
				damage = {
					1,
					1,
					1,
					1,
					1
				}
			}
		},
		catacombs_corpse_pit = {
			[str] = {}
		},
		cemetery_plague_floor = {
			[str] = {},
			[str_2] = {
				traversal_cost = "insane"
			}
		},
		skaven_molten_steel = {
			[str] = {
				time_between_damage = 1,
				damage = {
					10,
					10,
					10,
					10,
					10
				}
			},
			[str_2] = {
				traversal_cost = "inferno",
				time_between_damage = 1,
				damage = {
					10,
					10,
					10,
					10,
					10
				}
			},
			[str_3] = {
				traversal_cost = "inferno",
				time_between_damage = 1,
				damage = {
					3,
					3,
					3,
					3,
					3
				}
			}
		},
		bot_avoid_area = {
			[str_2] = {
				traversal_cost = "inferno"
			}
		},
		ai_avoid_area = {
			[str_3] = {
				traversal_cost = "inferno"
			}
		}
	},
	movement_volume = {
		generic_slowdown = {
			[str] = {
				speed_multiplier = 0.75
			},
			[str_2] = {
				speed_multiplier = 0.75
			}
		},
		generic_slowdown_2 = {
			[str] = {
				speed_multiplier = 0.6
			},
			[str_2] = {
				speed_multiplier = 0.6
			}
		},
		generic_slowdown_3 = {
			[str] = {
				speed_multiplier = 0.8
			},
			[str_2] = {
				speed_multiplier = 0.8
			}
		},
		generic_slowdown_glue = {
			[str] = {
				speed_multiplier = 0.1
			},
			[str_2] = {
				speed_multiplier = 0.1
			}
		}
	},
	location_volume = {
		area_indication = {
			[str] = {}
		}
	},
	trigger_volume = {
		all_alive_humans_outside = {
			[str] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled
			}
		},
		all_alive_players_outside = {
			[str] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled
			},
			[str_2] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled
			}
		},
		all_alive_players_outside_no_alive_inside = {
			[str] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled_outside_or_disabled_inside_and_not_all_disabled_inside
			},
			[str_2] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled_outside_or_disabled_inside_and_not_all_disabled_inside
			}
		},
		all_alive_players_inside = {
			[str] = {
				filter = GenericVolumeTemplates.filters.all_alive_players_inside
			}
		},
		all_non_disabled_players_inside = {
			[str] = {
				filter = GenericVolumeTemplates.filters.all_non_disabled_players_inside
			}
		},
		non_disabled_players_inside = {
			[str] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled
			}
		},
		ai_inside = {
			[str_3] = {
				filter = GenericVolumeTemplates.filters.is_alive_default_enemy
			}
		},
		players_and_bots_inside = {
			[str] = {},
			[str_2] = {}
		},
		players_inside = {
			[str] = {}
		},
		local_player_inside = {
			[str] = {},
			[str_5] = {}
		}
	},
	despawn_volume = {
		pickup_projectiles = {
			[str_4] = {}
		}
	}
}
VolumeExtensionSettings = VolumeExtensionSettings

local tbl = {}

for k, v in pairs(VolumeExtensionSettings) do
	for k_2, v_2 in pairs(v) do
		for k_3, v_3 in pairs(v_2) do
			local traversal_cost = v_3.traversal_cost

			if not traversal_cost then
				local var_0_9 = tbl[k]

				var_0_9 = var_0_9 or {}
				tbl[k] = var_0_9

				local var_0_10 = tbl[k]
				local var_0_11 = tbl[k][k_2]

				var_0_11 = var_0_11 or {}
				var_0_10[k_2] = var_0_11
				tbl[k][k_2][k_3] = VolumeSystemSettings.traversal_costs[traversal_cost]
			end
		end
	end
end

VolumeSystemSettings.nav_tag_layer_costs = tbl
