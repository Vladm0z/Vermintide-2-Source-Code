-- chunkname: @scripts/unit_extensions/limited_item_track/limited_item_track_spawner_templates.lua

LimitedItemTrackSpawnerTemplates = {}
LimitedItemTrackSpawnerTemplates.explosive_barrel_spawner = {
	types = {
		"explosive_barrel",
		"explosive_barrel_objective"
	},
	init_func = function (arg_1_0, arg_1_1, arg_1_2)
		return {}
	end,
	spawn_func = function (arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = Unit.local_position(arg_2_1, 0)
		local var_2_1 = Unit.local_rotation(arg_2_1, 0)
		local var_2_2 = AiAnimUtils.position_network_scale(var_2_0, true)
		local var_2_3 = AiAnimUtils.rotation_network_scale(var_2_1, true)
		local var_2_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_2_5 = var_2_4
		local var_2_6 = Unit.get_data(arg_2_1, "pickup_name")

		var_2_6 = var_2_6 ~= "" and var_2_6 or "explosive_barrel_objective"

		local var_2_7 = Pickups.level_events[var_2_6]
		local var_2_8 = var_2_7.unit_name
		local var_2_9 = var_2_7.unit_template_name
		local var_2_10 = {
			projectile_locomotion_system = {
				network_position = var_2_2,
				network_rotation = var_2_3,
				network_velocity = var_2_4,
				network_angular_velocity = var_2_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = var_2_6
			},
			limited_item_track_system = {
				id = arg_2_2.id,
				spawner_unit = arg_2_1
			},
			death_system = {
				in_hand = false,
				item_name = var_2_6
			},
			health_system = {
				in_hand = false,
				item_name = var_2_6
			}
		}
		local var_2_11 = AiAnimUtils.position_network_scale(var_2_2)
		local var_2_12 = AiAnimUtils.rotation_network_scale(var_2_3)

		return Managers.state.unit_spawner:spawn_network_unit(var_2_8, var_2_9, var_2_10, var_2_11, var_2_12)
	end
}
LimitedItemTrackSpawnerTemplates.sack_spawner = {
	types = {
		"grain_sack"
	},
	init_func = function (arg_3_0, arg_3_1, arg_3_2)
		return {}
	end,
	spawn_func = function (arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = Unit.local_position(arg_4_1, 0)
		local var_4_1 = Unit.local_rotation(arg_4_1, 0)
		local var_4_2 = AiAnimUtils.position_network_scale(var_4_0, true)
		local var_4_3 = AiAnimUtils.rotation_network_scale(var_4_1, true)
		local var_4_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_4_5 = var_4_4
		local var_4_6 = Unit.get_data(arg_4_1, "pickup_name")

		var_4_6 = var_4_6 ~= "" and var_4_6 or "grain_sack"

		local var_4_7 = Pickups.level_events[var_4_6]
		local var_4_8 = var_4_7.unit_name
		local var_4_9 = var_4_7.unit_template_name
		local var_4_10 = {
			projectile_locomotion_system = {
				network_position = var_4_2,
				network_rotation = var_4_3,
				network_velocity = var_4_4,
				network_angular_velocity = var_4_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = var_4_6
			},
			limited_item_track_system = {
				id = arg_4_2.id,
				spawner_unit = arg_4_1
			},
			death_system = {
				in_hand = false,
				item_name = var_4_6
			},
			health_system = {
				in_hand = false,
				item_name = var_4_6
			}
		}
		local var_4_11 = AiAnimUtils.position_network_scale(var_4_2)
		local var_4_12 = AiAnimUtils.rotation_network_scale(var_4_3)

		return Managers.state.unit_spawner:spawn_network_unit(var_4_8, var_4_9, var_4_10, var_4_11, var_4_12)
	end
}
LimitedItemTrackSpawnerTemplates.cannon_ball_spawner = {
	types = {
		"cannon_ball"
	},
	init_func = function (arg_5_0, arg_5_1, arg_5_2)
		return {}
	end,
	spawn_func = function (arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = Unit.local_position(arg_6_1, 0)
		local var_6_1 = Unit.local_rotation(arg_6_1, 0)
		local var_6_2 = AiAnimUtils.position_network_scale(var_6_0, true)
		local var_6_3 = AiAnimUtils.rotation_network_scale(var_6_1, true)
		local var_6_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_6_5 = var_6_4
		local var_6_6 = Unit.get_data(arg_6_1, "pickup_name")

		var_6_6 = var_6_6 ~= "" and var_6_6 or "cannon_ball"

		local var_6_7 = Pickups.level_events[var_6_6]
		local var_6_8 = var_6_7.unit_name
		local var_6_9 = var_6_7.unit_template_name
		local var_6_10 = {
			projectile_locomotion_system = {
				network_position = var_6_2,
				network_rotation = var_6_3,
				network_velocity = var_6_4,
				network_angular_velocity = var_6_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = var_6_6
			},
			limited_item_track_system = {
				id = arg_6_2.id,
				spawner_unit = arg_6_1
			},
			death_system = {
				in_hand = false,
				item_name = var_6_6
			},
			health_system = {
				in_hand = false,
				item_name = var_6_6
			}
		}
		local var_6_11 = AiAnimUtils.position_network_scale(var_6_2)
		local var_6_12 = AiAnimUtils.rotation_network_scale(var_6_3)

		return Managers.state.unit_spawner:spawn_network_unit(var_6_8, var_6_9, var_6_10, var_6_11, var_6_12)
	end
}
LimitedItemTrackSpawnerTemplates.trail_cog_spawner = {
	types = {
		"trail_cog"
	},
	init_func = function (arg_7_0, arg_7_1, arg_7_2)
		return {}
	end,
	spawn_func = function (arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = Unit.local_position(arg_8_1, 0)
		local var_8_1 = Unit.local_rotation(arg_8_1, 0)
		local var_8_2 = AiAnimUtils.position_network_scale(var_8_0, true)
		local var_8_3 = AiAnimUtils.rotation_network_scale(var_8_1, true)
		local var_8_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_8_5 = var_8_4
		local var_8_6 = Unit.get_data(arg_8_1, "pickup_name")

		var_8_6 = var_8_6 ~= "" and var_8_6 or "trail_cog"

		local var_8_7 = Pickups.level_events[var_8_6]
		local var_8_8 = var_8_7.unit_name
		local var_8_9 = var_8_7.unit_template_name
		local var_8_10 = {
			projectile_locomotion_system = {
				network_position = var_8_2,
				network_rotation = var_8_3,
				network_velocity = var_8_4,
				network_angular_velocity = var_8_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = var_8_6
			},
			limited_item_track_system = {
				id = arg_8_2.id,
				spawner_unit = arg_8_1
			},
			death_system = {
				in_hand = false,
				item_name = var_8_6
			},
			health_system = {
				in_hand = false,
				item_name = var_8_6
			}
		}
		local var_8_11 = AiAnimUtils.position_network_scale(var_8_2)
		local var_8_12 = AiAnimUtils.rotation_network_scale(var_8_3)

		return Managers.state.unit_spawner:spawn_network_unit(var_8_8, var_8_9, var_8_10, var_8_11, var_8_12)
	end
}
LimitedItemTrackSpawnerTemplates.gargoyle_head_spawner = {
	types = {
		"gargoyle_head_vs"
	},
	init_func = function (arg_9_0, arg_9_1, arg_9_2)
		return {}
	end,
	spawn_func = function (arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = Unit.local_position(arg_10_1, 0)
		local var_10_1 = Unit.local_rotation(arg_10_1, 0)
		local var_10_2 = AiAnimUtils.position_network_scale(var_10_0, true)
		local var_10_3 = AiAnimUtils.rotation_network_scale(var_10_1, true)
		local var_10_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_10_5 = var_10_4
		local var_10_6 = Unit.get_data(arg_10_1, "pickup_name")

		var_10_6 = var_10_6 ~= "" and var_10_6 or "gargoyle_head_vs"

		local var_10_7 = Pickups.level_events[var_10_6]
		local var_10_8 = var_10_7.unit_name
		local var_10_9 = var_10_7.unit_template_name
		local var_10_10 = {
			projectile_locomotion_system = {
				network_position = var_10_2,
				network_rotation = var_10_3,
				network_velocity = var_10_4,
				network_angular_velocity = var_10_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = var_10_6
			},
			limited_item_track_system = {
				id = arg_10_2.id,
				spawner_unit = arg_10_1
			},
			death_system = {
				in_hand = false,
				item_name = var_10_6
			},
			health_system = {
				in_hand = false,
				item_name = var_10_6
			}
		}
		local var_10_11 = AiAnimUtils.position_network_scale(var_10_2)
		local var_10_12 = AiAnimUtils.rotation_network_scale(var_10_3)

		return Managers.state.unit_spawner:spawn_network_unit(var_10_8, var_10_9, var_10_10, var_10_11, var_10_12)
	end
}
LimitedItemTrackSpawnerTemplates.magic_barrel_spawner = {
	types = {
		"explosive_barrel",
		"explosive_barrel_objective",
		"magic_barrel"
	},
	init_func = function (arg_11_0, arg_11_1, arg_11_2)
		return {}
	end,
	spawn_func = function (arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = Unit.local_position(arg_12_1, 0)
		local var_12_1 = Unit.local_rotation(arg_12_1, 0)
		local var_12_2 = AiAnimUtils.position_network_scale(var_12_0, true)
		local var_12_3 = AiAnimUtils.rotation_network_scale(var_12_1, true)
		local var_12_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_12_5 = var_12_4
		local var_12_6 = Unit.get_data(arg_12_1, "pickup_name")

		var_12_6 = var_12_6 ~= "" and var_12_6 or "magic_barrel"

		local var_12_7 = Pickups.level_events[var_12_6]
		local var_12_8 = var_12_7.unit_name
		local var_12_9 = var_12_7.unit_template_name
		local var_12_10 = {
			projectile_locomotion_system = {
				network_position = var_12_2,
				network_rotation = var_12_3,
				network_velocity = var_12_4,
				network_angular_velocity = var_12_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = var_12_6
			},
			limited_item_track_system = {
				id = arg_12_2.id,
				spawner_unit = arg_12_1
			},
			death_system = {
				in_hand = false,
				item_name = var_12_6
			},
			health_system = {
				in_hand = false,
				item_name = var_12_6
			}
		}
		local var_12_11 = AiAnimUtils.position_network_scale(var_12_2)
		local var_12_12 = AiAnimUtils.rotation_network_scale(var_12_3)

		return Managers.state.unit_spawner:spawn_network_unit(var_12_8, var_12_9, var_12_10, var_12_11, var_12_12)
	end
}
LimitedItemTrackSpawnerTemplates.wizards_barrel_spawner = {
	types = {
		"explosive_barrel",
		"explosive_barrel_objective",
		"wizards_barrel"
	},
	init_func = function (arg_13_0, arg_13_1, arg_13_2)
		return {}
	end,
	spawn_func = function (arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = Unit.local_position(arg_14_1, 0)
		local var_14_1 = Unit.local_rotation(arg_14_1, 0)
		local var_14_2 = AiAnimUtils.position_network_scale(var_14_0, true)
		local var_14_3 = AiAnimUtils.rotation_network_scale(var_14_1, true)
		local var_14_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_14_5 = var_14_4
		local var_14_6 = Unit.get_data(arg_14_1, "pickup_name")

		var_14_6 = var_14_6 ~= "" and var_14_6 or "wizards_barrel"

		local var_14_7 = Pickups.level_events[var_14_6]
		local var_14_8 = var_14_7.unit_name
		local var_14_9 = var_14_7.unit_template_name
		local var_14_10 = {
			projectile_locomotion_system = {
				network_position = var_14_2,
				network_rotation = var_14_3,
				network_velocity = var_14_4,
				network_angular_velocity = var_14_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = var_14_6
			},
			limited_item_track_system = {
				id = arg_14_2.id,
				spawner_unit = arg_14_1
			},
			death_system = {
				in_hand = false,
				item_name = var_14_6
			},
			health_system = {
				in_hand = false,
				item_name = var_14_6
			}
		}
		local var_14_11 = AiAnimUtils.position_network_scale(var_14_2)
		local var_14_12 = AiAnimUtils.rotation_network_scale(var_14_3)

		AIGroupTemplates.ethereal_skulls.last_state = "spawned"

		return Managers.state.unit_spawner:spawn_network_unit(var_14_8, var_14_9, var_14_10, var_14_11, var_14_12)
	end
}
LimitedItemTrackSpawnerTemplates.belakor_crystal_spawner = {
	types = {
		"belakor_crystal"
	},
	init_func = function (arg_15_0, arg_15_1, arg_15_2)
		return {}
	end,
	spawn_func = function (arg_16_0, arg_16_1, arg_16_2)
		local var_16_0 = Unit.local_position(arg_16_1, 0)
		local var_16_1 = Unit.local_rotation(arg_16_1, 0)
		local var_16_2 = AiAnimUtils.position_network_scale(var_16_0, true)
		local var_16_3 = AiAnimUtils.rotation_network_scale(var_16_1, true)
		local var_16_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_16_5 = var_16_4
		local var_16_6 = "belakor_crystal"
		local var_16_7 = "units/weapons/player/pup_belakor_crystal/pup_belakor_crystal"
		local var_16_8 = "pickup_projectile_unit_limited"
		local var_16_9 = {
			projectile_locomotion_system = {
				network_position = var_16_2,
				network_rotation = var_16_3,
				network_velocity = var_16_4,
				network_angular_velocity = var_16_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = var_16_6
			},
			limited_item_track_system = {
				id = arg_16_2.id,
				spawner_unit = arg_16_1
			},
			death_system = {
				in_hand = false,
				item_name = var_16_6
			}
		}
		local var_16_10 = AiAnimUtils.position_network_scale(var_16_2)
		local var_16_11 = AiAnimUtils.rotation_network_scale(var_16_3)

		return Managers.state.unit_spawner:spawn_network_unit(var_16_7, var_16_8, var_16_9, var_16_10, var_16_11)
	end
}
LimitedItemTrackSpawnerTemplates.torch_spawner = {
	types = {
		"torch"
	},
	init_func = function (arg_17_0, arg_17_1, arg_17_2)
		return {}
	end,
	spawn_func = function (arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = Unit.local_position(arg_18_1, 0)
		local var_18_1 = Unit.local_rotation(arg_18_1, 0)
		local var_18_2 = AiAnimUtils.position_network_scale(var_18_0, true)
		local var_18_3 = AiAnimUtils.rotation_network_scale(var_18_1, true)
		local var_18_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_18_5 = var_18_4
		local var_18_6 = "torch"
		local var_18_7 = "units/weapons/player/pup_torch/pup_torch"
		local var_18_8 = "pickup_projectile_unit_limited"
		local var_18_9 = {
			projectile_locomotion_system = {
				network_position = var_18_2,
				network_rotation = var_18_3,
				network_velocity = var_18_4,
				network_angular_velocity = var_18_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = var_18_6
			},
			limited_item_track_system = {
				id = arg_18_2.id,
				spawner_unit = arg_18_1
			},
			death_system = {
				in_hand = false,
				item_name = var_18_6
			}
		}
		local var_18_10 = AiAnimUtils.position_network_scale(var_18_2)
		local var_18_11 = AiAnimUtils.rotation_network_scale(var_18_3)

		return Managers.state.unit_spawner:spawn_network_unit(var_18_7, var_18_8, var_18_9, var_18_10, var_18_11)
	end
}
LimitedItemTrackSpawnerTemplates.gargoyle_head_spawner_vs = {
	types = {
		"gargoyle_head"
	},
	init_func = function (arg_19_0, arg_19_1, arg_19_2)
		return {}
	end,
	spawn_func = function (arg_20_0, arg_20_1, arg_20_2)
		local var_20_0 = Unit.local_position(arg_20_1, 0)
		local var_20_1 = Unit.local_rotation(arg_20_1, 0)
		local var_20_2 = AiAnimUtils.position_network_scale(var_20_0, true)
		local var_20_3 = AiAnimUtils.rotation_network_scale(var_20_1, true)
		local var_20_4 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_20_5 = var_20_4
		local var_20_6 = Unit.get_data(arg_20_1, "pickup_name")

		var_20_6 = var_20_6 ~= "" and var_20_6 or "gargoyle_head"

		local var_20_7 = Pickups.level_events[var_20_6]
		local var_20_8 = var_20_7.unit_name
		local var_20_9 = var_20_7.unit_template_name
		local var_20_10 = {
			projectile_locomotion_system = {
				network_position = var_20_2,
				network_rotation = var_20_3,
				network_velocity = var_20_4,
				network_angular_velocity = var_20_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = var_20_6
			},
			limited_item_track_system = {
				id = arg_20_2.id,
				spawner_unit = arg_20_1
			},
			death_system = {
				in_hand = false,
				item_name = var_20_6
			},
			health_system = {
				in_hand = false,
				item_name = var_20_6
			}
		}
		local var_20_11 = AiAnimUtils.position_network_scale(var_20_2)
		local var_20_12 = AiAnimUtils.rotation_network_scale(var_20_3)

		return Managers.state.unit_spawner:spawn_network_unit(var_20_8, var_20_9, var_20_10, var_20_11, var_20_12)
	end
}
