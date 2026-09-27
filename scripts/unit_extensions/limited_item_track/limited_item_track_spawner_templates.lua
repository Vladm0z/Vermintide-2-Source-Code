-- chunkname: @scripts/unit_extensions/limited_item_track/limited_item_track_spawner_templates.lua

LimitedItemTrackSpawnerTemplates = {}
LimitedItemTrackSpawnerTemplates.explosive_barrel_spawner = {
	types = {
		"explosive_barrel",
		"explosive_barrel_objective"
	},
	init_func = function (arg_1_0, arg_1_1, arg_1_2)
		-- function 1
		return {}
	end,
	spawn_func = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		local local_position = Unit.local_position(arg_2_1, 0)
		local local_rotation = Unit.local_rotation(arg_2_1, 0)
		local position_network_scale = AiAnimUtils.position_network_scale(local_position, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(local_rotation, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_2_5 = velocity_network_scale
		local get_data = Unit.get_data(arg_2_1, "pickup_name")

		get_data = get_data == "" or not get_data or "explosive_barrel_objective"

		local var_2_7 = Pickups.level_events[get_data]
		local unit_name = var_2_7.unit_name
		local unit_template_name = var_2_7.unit_template_name
		local tbl = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_2_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = get_data
			},
			limited_item_track_system = {
				id = arg_2_2.id,
				spawner_unit = arg_2_1
			},
			death_system = {
				in_hand = false,
				item_name = get_data
			},
			health_system = {
				in_hand = false,
				item_name = get_data
			}
		}
		local position_network_scale_2 = AiAnimUtils.position_network_scale(position_network_scale)
		local rotation_network_scale_2 = AiAnimUtils.rotation_network_scale(rotation_network_scale)

		return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, position_network_scale_2, rotation_network_scale_2)
	end
}
LimitedItemTrackSpawnerTemplates.sack_spawner = {
	types = {
		"grain_sack"
	},
	init_func = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		return {}
	end,
	spawn_func = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		local local_position = Unit.local_position(arg_4_1, 0)
		local local_rotation = Unit.local_rotation(arg_4_1, 0)
		local position_network_scale = AiAnimUtils.position_network_scale(local_position, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(local_rotation, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_4_5 = velocity_network_scale
		local get_data = Unit.get_data(arg_4_1, "pickup_name")

		get_data = get_data == "" or not get_data or "grain_sack"

		local var_4_7 = Pickups.level_events[get_data]
		local unit_name = var_4_7.unit_name
		local unit_template_name = var_4_7.unit_template_name
		local tbl = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_4_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = get_data
			},
			limited_item_track_system = {
				id = arg_4_2.id,
				spawner_unit = arg_4_1
			},
			death_system = {
				in_hand = false,
				item_name = get_data
			},
			health_system = {
				in_hand = false,
				item_name = get_data
			}
		}
		local position_network_scale_2 = AiAnimUtils.position_network_scale(position_network_scale)
		local rotation_network_scale_2 = AiAnimUtils.rotation_network_scale(rotation_network_scale)

		return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, position_network_scale_2, rotation_network_scale_2)
	end
}
LimitedItemTrackSpawnerTemplates.cannon_ball_spawner = {
	types = {
		"cannon_ball"
	},
	init_func = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		return {}
	end,
	spawn_func = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		local local_position = Unit.local_position(arg_6_1, 0)
		local local_rotation = Unit.local_rotation(arg_6_1, 0)
		local position_network_scale = AiAnimUtils.position_network_scale(local_position, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(local_rotation, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_6_5 = velocity_network_scale
		local get_data = Unit.get_data(arg_6_1, "pickup_name")

		get_data = get_data == "" or not get_data or "cannon_ball"

		local var_6_7 = Pickups.level_events[get_data]
		local unit_name = var_6_7.unit_name
		local unit_template_name = var_6_7.unit_template_name
		local tbl = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_6_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = get_data
			},
			limited_item_track_system = {
				id = arg_6_2.id,
				spawner_unit = arg_6_1
			},
			death_system = {
				in_hand = false,
				item_name = get_data
			},
			health_system = {
				in_hand = false,
				item_name = get_data
			}
		}
		local position_network_scale_2 = AiAnimUtils.position_network_scale(position_network_scale)
		local rotation_network_scale_2 = AiAnimUtils.rotation_network_scale(rotation_network_scale)

		return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, position_network_scale_2, rotation_network_scale_2)
	end
}
LimitedItemTrackSpawnerTemplates.trail_cog_spawner = {
	types = {
		"trail_cog"
	},
	init_func = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		return {}
	end,
	spawn_func = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		local local_position = Unit.local_position(arg_8_1, 0)
		local local_rotation = Unit.local_rotation(arg_8_1, 0)
		local position_network_scale = AiAnimUtils.position_network_scale(local_position, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(local_rotation, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_8_5 = velocity_network_scale
		local get_data = Unit.get_data(arg_8_1, "pickup_name")

		get_data = get_data == "" or not get_data or "trail_cog"

		local var_8_7 = Pickups.level_events[get_data]
		local unit_name = var_8_7.unit_name
		local unit_template_name = var_8_7.unit_template_name
		local tbl = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_8_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = get_data
			},
			limited_item_track_system = {
				id = arg_8_2.id,
				spawner_unit = arg_8_1
			},
			death_system = {
				in_hand = false,
				item_name = get_data
			},
			health_system = {
				in_hand = false,
				item_name = get_data
			}
		}
		local position_network_scale_2 = AiAnimUtils.position_network_scale(position_network_scale)
		local rotation_network_scale_2 = AiAnimUtils.rotation_network_scale(rotation_network_scale)

		return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, position_network_scale_2, rotation_network_scale_2)
	end
}
LimitedItemTrackSpawnerTemplates.gargoyle_head_spawner = {
	types = {
		"gargoyle_head_vs"
	},
	init_func = function (arg_9_0, arg_9_1, arg_9_2)
		-- function 9
		return {}
	end,
	spawn_func = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		local local_position = Unit.local_position(arg_10_1, 0)
		local local_rotation = Unit.local_rotation(arg_10_1, 0)
		local position_network_scale = AiAnimUtils.position_network_scale(local_position, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(local_rotation, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_10_5 = velocity_network_scale
		local get_data = Unit.get_data(arg_10_1, "pickup_name")

		get_data = get_data == "" or not get_data or "gargoyle_head_vs"

		local var_10_7 = Pickups.level_events[get_data]
		local unit_name = var_10_7.unit_name
		local unit_template_name = var_10_7.unit_template_name
		local tbl = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_10_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = get_data
			},
			limited_item_track_system = {
				id = arg_10_2.id,
				spawner_unit = arg_10_1
			},
			death_system = {
				in_hand = false,
				item_name = get_data
			},
			health_system = {
				in_hand = false,
				item_name = get_data
			}
		}
		local position_network_scale_2 = AiAnimUtils.position_network_scale(position_network_scale)
		local rotation_network_scale_2 = AiAnimUtils.rotation_network_scale(rotation_network_scale)

		return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, position_network_scale_2, rotation_network_scale_2)
	end
}
LimitedItemTrackSpawnerTemplates.magic_barrel_spawner = {
	types = {
		"explosive_barrel",
		"explosive_barrel_objective",
		"magic_barrel"
	},
	init_func = function (arg_11_0, arg_11_1, arg_11_2)
		-- function 11
		return {}
	end,
	spawn_func = function (arg_12_0, arg_12_1, arg_12_2)
		-- function 12
		local local_position = Unit.local_position(arg_12_1, 0)
		local local_rotation = Unit.local_rotation(arg_12_1, 0)
		local position_network_scale = AiAnimUtils.position_network_scale(local_position, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(local_rotation, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_12_5 = velocity_network_scale
		local get_data = Unit.get_data(arg_12_1, "pickup_name")

		get_data = get_data == "" or not get_data or "magic_barrel"

		local var_12_7 = Pickups.level_events[get_data]
		local unit_name = var_12_7.unit_name
		local unit_template_name = var_12_7.unit_template_name
		local tbl = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_12_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = get_data
			},
			limited_item_track_system = {
				id = arg_12_2.id,
				spawner_unit = arg_12_1
			},
			death_system = {
				in_hand = false,
				item_name = get_data
			},
			health_system = {
				in_hand = false,
				item_name = get_data
			}
		}
		local position_network_scale_2 = AiAnimUtils.position_network_scale(position_network_scale)
		local rotation_network_scale_2 = AiAnimUtils.rotation_network_scale(rotation_network_scale)

		return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, position_network_scale_2, rotation_network_scale_2)
	end
}
LimitedItemTrackSpawnerTemplates.wizards_barrel_spawner = {
	types = {
		"explosive_barrel",
		"explosive_barrel_objective",
		"wizards_barrel"
	},
	init_func = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		return {}
	end,
	spawn_func = function (arg_14_0, arg_14_1, arg_14_2)
		-- function 14
		local local_position = Unit.local_position(arg_14_1, 0)
		local local_rotation = Unit.local_rotation(arg_14_1, 0)
		local position_network_scale = AiAnimUtils.position_network_scale(local_position, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(local_rotation, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_14_5 = velocity_network_scale
		local get_data = Unit.get_data(arg_14_1, "pickup_name")

		get_data = get_data == "" or not get_data or "wizards_barrel"

		local var_14_7 = Pickups.level_events[get_data]
		local unit_name = var_14_7.unit_name
		local unit_template_name = var_14_7.unit_template_name
		local tbl = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_14_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = get_data
			},
			limited_item_track_system = {
				id = arg_14_2.id,
				spawner_unit = arg_14_1
			},
			death_system = {
				in_hand = false,
				item_name = get_data
			},
			health_system = {
				in_hand = false,
				item_name = get_data
			}
		}
		local position_network_scale_2 = AiAnimUtils.position_network_scale(position_network_scale)
		local rotation_network_scale_2 = AiAnimUtils.rotation_network_scale(rotation_network_scale)

		AIGroupTemplates.ethereal_skulls.last_state = "spawned"

		return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, position_network_scale_2, rotation_network_scale_2)
	end
}
LimitedItemTrackSpawnerTemplates.belakor_crystal_spawner = {
	types = {
		"belakor_crystal"
	},
	init_func = function (arg_15_0, arg_15_1, arg_15_2)
		-- function 15
		return {}
	end,
	spawn_func = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		local local_position = Unit.local_position(arg_16_1, 0)
		local local_rotation = Unit.local_rotation(arg_16_1, 0)
		local position_network_scale = AiAnimUtils.position_network_scale(local_position, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(local_rotation, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_16_5 = velocity_network_scale
		local str = "belakor_crystal"
		local str_2 = "units/weapons/player/pup_belakor_crystal/pup_belakor_crystal"
		local str_3 = "pickup_projectile_unit_limited"
		local tbl = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_16_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = str
			},
			limited_item_track_system = {
				id = arg_16_2.id,
				spawner_unit = arg_16_1
			},
			death_system = {
				in_hand = false,
				item_name = str
			}
		}
		local position_network_scale_2 = AiAnimUtils.position_network_scale(position_network_scale)
		local rotation_network_scale_2 = AiAnimUtils.rotation_network_scale(rotation_network_scale)

		return Managers.state.unit_spawner:spawn_network_unit(str_2, str_3, tbl, position_network_scale_2, rotation_network_scale_2)
	end
}
LimitedItemTrackSpawnerTemplates.torch_spawner = {
	types = {
		"torch"
	},
	init_func = function (arg_17_0, arg_17_1, arg_17_2)
		-- function 17
		return {}
	end,
	spawn_func = function (arg_18_0, arg_18_1, arg_18_2)
		-- function 18
		local local_position = Unit.local_position(arg_18_1, 0)
		local local_rotation = Unit.local_rotation(arg_18_1, 0)
		local position_network_scale = AiAnimUtils.position_network_scale(local_position, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(local_rotation, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_18_5 = velocity_network_scale
		local str = "torch"
		local str_2 = "units/weapons/player/pup_torch/pup_torch"
		local str_3 = "pickup_projectile_unit_limited"
		local tbl = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_18_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = str
			},
			limited_item_track_system = {
				id = arg_18_2.id,
				spawner_unit = arg_18_1
			},
			death_system = {
				in_hand = false,
				item_name = str
			}
		}
		local position_network_scale_2 = AiAnimUtils.position_network_scale(position_network_scale)
		local rotation_network_scale_2 = AiAnimUtils.rotation_network_scale(rotation_network_scale)

		return Managers.state.unit_spawner:spawn_network_unit(str_2, str_3, tbl, position_network_scale_2, rotation_network_scale_2)
	end
}
LimitedItemTrackSpawnerTemplates.gargoyle_head_spawner_vs = {
	types = {
		"gargoyle_head"
	},
	init_func = function (arg_19_0, arg_19_1, arg_19_2)
		-- function 19
		return {}
	end,
	spawn_func = function (arg_20_0, arg_20_1, arg_20_2)
		-- function 20
		local local_position = Unit.local_position(arg_20_1, 0)
		local local_rotation = Unit.local_rotation(arg_20_1, 0)
		local position_network_scale = AiAnimUtils.position_network_scale(local_position, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(local_rotation, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_20_5 = velocity_network_scale
		local get_data = Unit.get_data(arg_20_1, "pickup_name")

		get_data = get_data == "" or not get_data or "gargoyle_head"

		local var_20_7 = Pickups.level_events[get_data]
		local unit_name = var_20_7.unit_name
		local unit_template_name = var_20_7.unit_template_name
		local tbl = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = var_20_5
			},
			pickup_system = {
				spawn_type = "limited",
				pickup_name = get_data
			},
			limited_item_track_system = {
				id = arg_20_2.id,
				spawner_unit = arg_20_1
			},
			death_system = {
				in_hand = false,
				item_name = get_data
			},
			health_system = {
				in_hand = false,
				item_name = get_data
			}
		}
		local position_network_scale_2 = AiAnimUtils.position_network_scale(position_network_scale)
		local rotation_network_scale_2 = AiAnimUtils.rotation_network_scale(rotation_network_scale)

		return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, position_network_scale_2, rotation_network_scale_2)
	end
}
