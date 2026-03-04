-- chunkname: @scripts/settings/volume_settings.lua

require("scripts/unit_extensions/generic/generic_volume_templates")

local var_0_0 = "PlayerVolumeExtension"
local var_0_1 = "BotVolumeExtension"
local var_0_2 = "AIVolumeExtension"
local var_0_3 = "PickupProjectileVolumeExtension"
local var_0_4 = "LocalPlayerVolumeExtension"

VolumeSystemSettings = VolumeSystemSettings or {
	updates_per_frame = {
		[var_0_0] = 4,
		[var_0_4] = 1,
		[var_0_1] = 3,
		[var_0_2] = 10,
		[var_0_3] = 1
	},
	traversal_costs = {
		high = 2,
		inferno = 100000,
		low = 1.2,
		insane = 4,
		medium = 1.5
	}
}
VolumeExtensionSettings = VolumeExtensionSettings or {
	damage_volume = {
		generic_dot = {
			[var_0_0] = {
				time_between_damage = 2,
				damage = {
					10,
					10,
					10,
					10,
					10
				}
			},
			[var_0_1] = {
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
			[var_0_2] = {
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
			[var_0_0] = {
				time_between_damage = 0.1,
				damage = {
					3,
					3,
					3,
					3,
					3
				}
			},
			[var_0_1] = {
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
			[var_0_2] = {
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
			[var_0_2] = {
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
			[var_0_0] = {},
			[var_0_4] = {},
			[var_0_1] = {
				traversal_cost = "high"
			},
			[var_0_2] = {
				traversal_cost = "high"
			}
		},
		player_insta_kill = {
			[var_0_0] = {},
			[var_0_4] = {},
			[var_0_1] = {
				traversal_cost = "high"
			}
		},
		ai_insta_kill = {
			[var_0_2] = {
				traversal_cost = "high"
			}
		},
		generic_insta_kill_no_cost = {
			[var_0_0] = {},
			[var_0_4] = {},
			[var_0_1] = {},
			[var_0_2] = {}
		},
		player_insta_kill_no_cost = {
			[var_0_0] = {},
			[var_0_4] = {},
			[var_0_1] = {}
		},
		pactsworn_insta_kill_no_cost = {
			[var_0_0] = {},
			[var_0_4] = {},
			[var_0_1] = {}
		},
		heroes_insta_kill_no_cost = {
			[var_0_0] = {},
			[var_0_4] = {},
			[var_0_1] = {}
		},
		ai_insta_kill_no_cost = {
			[var_0_2] = {}
		},
		ai_kill_dot_no_cost = {
			[var_0_2] = {
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
			[var_0_0] = {
				time_between_damage = 0.5,
				damage = {
					1,
					1,
					1,
					1,
					1
				}
			},
			[var_0_1] = {
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
			[var_0_0] = {}
		},
		cemetery_plague_floor = {
			[var_0_0] = {},
			[var_0_1] = {
				traversal_cost = "insane"
			}
		},
		skaven_molten_steel = {
			[var_0_0] = {
				time_between_damage = 1,
				damage = {
					10,
					10,
					10,
					10,
					10
				}
			},
			[var_0_1] = {
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
			[var_0_2] = {
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
			[var_0_1] = {
				traversal_cost = "inferno"
			}
		},
		ai_avoid_area = {
			[var_0_2] = {
				traversal_cost = "inferno"
			}
		}
	},
	movement_volume = {
		generic_slowdown = {
			[var_0_0] = {
				speed_multiplier = 0.75
			},
			[var_0_1] = {
				speed_multiplier = 0.75
			}
		},
		generic_slowdown_2 = {
			[var_0_0] = {
				speed_multiplier = 0.6
			},
			[var_0_1] = {
				speed_multiplier = 0.6
			}
		},
		generic_slowdown_3 = {
			[var_0_0] = {
				speed_multiplier = 0.8
			},
			[var_0_1] = {
				speed_multiplier = 0.8
			}
		},
		generic_slowdown_glue = {
			[var_0_0] = {
				speed_multiplier = 0.1
			},
			[var_0_1] = {
				speed_multiplier = 0.1
			}
		}
	},
	location_volume = {
		area_indication = {
			[var_0_0] = {}
		}
	},
	trigger_volume = {
		all_alive_humans_outside = {
			[var_0_0] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled
			}
		},
		all_alive_players_outside = {
			[var_0_0] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled
			},
			[var_0_1] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled
			}
		},
		all_alive_players_outside_no_alive_inside = {
			[var_0_0] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled_outside_or_disabled_inside_and_not_all_disabled_inside
			},
			[var_0_1] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled_outside_or_disabled_inside_and_not_all_disabled_inside
			}
		},
		all_alive_players_inside = {
			[var_0_0] = {
				filter = GenericVolumeTemplates.filters.all_alive_players_inside
			}
		},
		all_non_disabled_players_inside = {
			[var_0_0] = {
				filter = GenericVolumeTemplates.filters.all_non_disabled_players_inside
			}
		},
		non_disabled_players_inside = {
			[var_0_0] = {
				filter = GenericVolumeTemplates.filters.unit_not_disabled
			}
		},
		ai_inside = {
			[var_0_2] = {
				filter = GenericVolumeTemplates.filters.is_alive_default_enemy
			}
		},
		players_and_bots_inside = {
			[var_0_0] = {},
			[var_0_1] = {}
		},
		players_inside = {
			[var_0_0] = {}
		},
		local_player_inside = {
			[var_0_0] = {},
			[var_0_4] = {}
		}
	},
	despawn_volume = {
		pickup_projectiles = {
			[var_0_3] = {}
		}
	}
}

local var_0_5 = {}

for iter_0_0, iter_0_1 in pairs(VolumeExtensionSettings) do
	for iter_0_2, iter_0_3 in pairs(iter_0_1) do
		for iter_0_4, iter_0_5 in pairs(iter_0_3) do
			local var_0_6 = iter_0_5.traversal_cost

			if var_0_6 then
				var_0_5[iter_0_0] = var_0_5[iter_0_0] or {}
				var_0_5[iter_0_0][iter_0_2] = var_0_5[iter_0_0][iter_0_2] or {}
				var_0_5[iter_0_0][iter_0_2][iter_0_4] = VolumeSystemSettings.traversal_costs[var_0_6]
			end
		end
	end
end

VolumeSystemSettings.nav_tag_layer_costs = var_0_5
