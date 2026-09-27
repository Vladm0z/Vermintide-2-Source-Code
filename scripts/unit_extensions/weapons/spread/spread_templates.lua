-- chunkname: @scripts/unit_extensions/weapons/spread/spread_templates.lua

SpreadTemplates = {}
SpreadTemplates.default = {
	continuous = {
		still = {
			max_yaw = 1,
			max_pitch = 1
		},
		moving = {
			max_yaw = 3,
			max_pitch = 3
		},
		crouch_still = {
			max_yaw = 0.8,
			max_pitch = 0.8
		},
		crouch_moving = {
			max_yaw = 2,
			max_pitch = 2
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 4,
			immediate_yaw = 4
		}
	}
}
SpreadTemplates.repeating_pistol = {
	continuous = {
		still = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		moving = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		crouch_still = {
			max_yaw = 0.3,
			max_pitch = 0.3
		},
		crouch_moving = {
			max_yaw = 1,
			max_pitch = 1
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 3,
			immediate_yaw = 3
		}
	}
}
SpreadTemplates.repeating_crossbow_burst = {
	continuous = {
		still = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		moving = {
			max_yaw = 1,
			max_pitch = 1
		},
		crouch_still = {
			max_yaw = 0.3,
			max_pitch = 0.3
		},
		crouch_moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		zoomed_still = {
			max_yaw = 0.1,
			max_pitch = 0.1
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0.1,
			max_pitch = 0.1
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 0.2,
			immediate_yaw = 0.2
		}
	}
}
SpreadTemplates.sparks = {
	continuous = {
		still = {
			max_yaw = 1.5,
			max_pitch = 0.75
		},
		moving = {
			max_yaw = 1.75,
			max_pitch = 0.9
		},
		crouch_still = {
			max_yaw = 1.4,
			max_pitch = 0.7
		},
		crouch_moving = {
			max_yaw = 4,
			max_pitch = 2
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 0.25,
			immediate_yaw = 0.5
		}
	}
}
SpreadTemplates.spear = {
	continuous = {
		still = {
			max_yaw = 0.25,
			max_pitch = 0.25
		},
		moving = {
			max_yaw = 0.35,
			max_pitch = 0.35
		},
		crouch_still = {
			max_yaw = 0.2,
			max_pitch = 0.2
		},
		crouch_moving = {
			max_yaw = 2,
			max_pitch = 2
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 6,
			immediate_yaw = 6
		}
	}
}
SpreadTemplates.crossbow = {
	continuous = {
		still = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		moving = {
			max_yaw = 1.25,
			max_pitch = 1.25
		},
		crouch_still = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		crouch_moving = {
			max_yaw = 1.5,
			max_pitch = 1.5
		},
		zoomed_still = {
			max_yaw = 0.15,
			max_pitch = 0.15
		},
		zoomed_moving = {
			max_yaw = 0.25,
			max_pitch = 0.25
		},
		zoomed_crouch_still = {
			max_yaw = 0.1,
			max_pitch = 0.1
		},
		zoomed_crouch_moving = {
			max_yaw = 0.1,
			max_pitch = 0.1
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 100.4,
			immediate_yaw = 100.4
		},
		shooting = {
			immediate_pitch = 6,
			immediate_yaw = 6
		}
	}
}
SpreadTemplates.repeating_crossbow_3bolt = {
	continuous = {
		still = {
			max_yaw = 3.5,
			max_pitch = 0.5
		},
		moving = {
			max_yaw = 3.5,
			max_pitch = 0.5
		},
		crouch_still = {
			max_yaw = 3.5,
			max_pitch = 0.5
		},
		crouch_moving = {
			max_yaw = 3.5,
			max_pitch = 0.5
		},
		zoomed_still = {
			max_yaw = 3.5,
			max_pitch = 0.5
		},
		zoomed_moving = {
			max_yaw = 3.5,
			max_pitch = 0.5
		},
		zoomed_crouch_still = {
			max_yaw = 3.5,
			max_pitch = 0.5
		},
		zoomed_crouch_moving = {
			max_yaw = 3.5,
			max_pitch = 0.5
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 100.4,
			immediate_yaw = 100.4
		},
		shooting = {
			immediate_pitch = 6,
			immediate_yaw = 6
		}
	}
}
SpreadTemplates.bounty_hunter_handgun = {
	continuous = {
		still = {
			max_yaw = 0,
			max_pitch = 0
		},
		moving = {
			max_yaw = 1,
			max_pitch = 1
		},
		crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		crouch_moving = {
			max_yaw = 0.8,
			max_pitch = 0.8
		},
		zoomed_still = {
			max_yaw = 0.8,
			max_pitch = 0.8
		},
		zoomed_moving = {
			max_yaw = 1,
			max_pitch = 1
		},
		zoomed_crouch_still = {
			max_yaw = 0.6,
			max_pitch = 0.6
		},
		zoomed_crouch_moving = {
			max_yaw = 1.5,
			max_pitch = 1.5
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 0,
			immediate_yaw = 0
		}
	}
}
SpreadTemplates.handgun = {
	continuous = {
		still = {
			max_yaw = 1.5,
			max_pitch = 1.5
		},
		moving = {
			max_yaw = 2.25,
			max_pitch = 2.25
		},
		crouch_still = {
			max_yaw = 1.75,
			max_pitch = 1.75
		},
		crouch_moving = {
			max_yaw = 2,
			max_pitch = 2
		},
		zoomed_still = {
			max_yaw = 0.05,
			max_pitch = 0.05
		},
		zoomed_moving = {
			max_yaw = 0.1,
			max_pitch = 0.1
		},
		zoomed_crouch_still = {
			max_yaw = 0.05,
			max_pitch = 0.05
		},
		zoomed_crouch_moving = {
			max_yaw = 0.8,
			max_pitch = 0.8
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 6,
			immediate_yaw = 6
		}
	}
}
SpreadTemplates.repeating_handgun = {
	continuous = {
		still = {
			max_yaw = 0.6,
			max_pitch = 0.6
		},
		moving = {
			max_yaw = 1.5,
			max_pitch = 1.5
		},
		crouch_still = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		crouch_moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		zoomed_still = {
			max_yaw = 0.1,
			max_pitch = 0.1
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0.1,
			max_pitch = 0.1
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 1,
			immediate_yaw = 1
		}
	}
}
SpreadTemplates.longbow = {
	continuous = {
		still = {
			max_yaw = 0.65,
			max_pitch = 0.65
		},
		moving = {
			max_yaw = 1,
			max_pitch = 1
		},
		crouch_still = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		crouch_moving = {
			max_yaw = 2,
			max_pitch = 2
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 0.5,
			immediate_yaw = 0.5
		}
	}
}
SpreadTemplates.empire_longbow = {
	continuous = {
		still = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		crouch_still = {
			max_yaw = 1.25,
			max_pitch = 1.25
		},
		crouch_moving = {
			max_yaw = 2,
			max_pitch = 2
		},
		zoomed_still = {
			max_yaw = 0.25,
			max_pitch = 0.25
		},
		zoomed_moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		zoomed_crouch_still = {
			max_yaw = 1.5,
			max_pitch = 1.5
		},
		zoomed_crouch_moving = {
			max_yaw = 2,
			max_pitch = 2
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 0.5,
			immediate_yaw = 0.5
		}
	}
}
SpreadTemplates.bow = {
	continuous = {
		still = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		moving = {
			max_yaw = 1,
			max_pitch = 1
		},
		crouch_still = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		crouch_moving = {
			max_yaw = 1,
			max_pitch = 1
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 0.5,
			immediate_yaw = 0.5
		}
	}
}
SpreadTemplates.bounty_hunter_shotgun = {
	continuous = {
		still = {
			max_yaw = 20,
			max_pitch = 6
		},
		moving = {
			max_yaw = 20,
			max_pitch = 6
		},
		crouch_still = {
			max_yaw = 20,
			max_pitch = 6
		},
		crouch_moving = {
			max_yaw = 20,
			max_pitch = 6
		},
		zoomed_still = {
			max_yaw = 20,
			max_pitch = 6
		},
		zoomed_moving = {
			max_yaw = 20,
			max_pitch = 6
		},
		zoomed_crouch_still = {
			max_yaw = 20,
			max_pitch = 6
		},
		zoomed_crouch_moving = {
			max_yaw = 20,
			max_pitch = 6
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 0.2,
			immediate_yaw = 0.2
		},
		shooting = {
			immediate_pitch = 10,
			immediate_yaw = 10
		}
	}
}
SpreadTemplates.blunderbuss = {
	continuous = {
		still = {
			max_yaw = 9,
			max_pitch = 6
		},
		moving = {
			max_yaw = 9,
			max_pitch = 6
		},
		crouch_still = {
			max_yaw = 9,
			max_pitch = 6
		},
		crouch_moving = {
			max_yaw = 9,
			max_pitch = 6
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 0.2,
			immediate_yaw = 0.2
		},
		shooting = {
			immediate_pitch = 10,
			immediate_yaw = 10
		}
	}
}
SpreadTemplates.repeating_handgun_special = {
	continuous = {
		still = {
			max_yaw = 6,
			max_pitch = 4
		},
		moving = {
			max_yaw = 6,
			max_pitch = 4
		},
		crouch_still = {
			max_yaw = 6,
			max_pitch = 4
		},
		crouch_moving = {
			max_yaw = 6,
			max_pitch = 4
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 4,
			max_pitch = 2.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 4,
			max_pitch = 2.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 2,
			immediate_yaw = 2
		}
	}
}
SpreadTemplates.heavy_steam_pistol_special = {
	continuous = {
		still = {
			max_yaw = 9,
			max_pitch = 7
		},
		moving = {
			max_yaw = 11,
			max_pitch = 8
		},
		crouch_still = {
			max_yaw = 8,
			max_pitch = 6
		},
		crouch_moving = {
			max_yaw = 9,
			max_pitch = 7
		},
		zoomed_still = {
			max_yaw = 11,
			max_pitch = 8
		},
		zoomed_moving = {
			max_yaw = 11,
			max_pitch = 8
		},
		zoomed_crouch_still = {
			max_yaw = 11,
			max_pitch = 8
		},
		zoomed_crouch_moving = {
			max_yaw = 11,
			max_pitch = 8
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 3,
			immediate_yaw = 3
		},
		shooting = {
			immediate_pitch = 5,
			immediate_yaw = 5
		}
	}
}
SpreadTemplates.rake_shot = {
	continuous = {
		still = {
			max_yaw = 6,
			max_pitch = 4.5
		},
		moving = {
			max_yaw = 6,
			max_pitch = 4.5
		},
		crouch_still = {
			max_yaw = 6,
			max_pitch = 4.5
		},
		crouch_moving = {
			max_yaw = 6,
			max_pitch = 4.5
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 5,
			immediate_yaw = 5
		}
	}
}
SpreadTemplates.rake_twin_shot = {
	continuous = {
		still = {
			max_yaw = 12,
			max_pitch = 10
		},
		moving = {
			max_yaw = 12,
			max_pitch = 10
		},
		crouch_still = {
			max_yaw = 12,
			max_pitch = 10
		},
		crouch_moving = {
			max_yaw = 12,
			max_pitch = 10
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 10,
			immediate_yaw = 10
		}
	}
}
SpreadTemplates.brace_of_pistols = {
	continuous = {
		still = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		moving = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		crouch_still = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		crouch_moving = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 0.4,
			immediate_yaw = 0.4
		},
		shooting = {
			immediate_pitch = 0.25,
			immediate_yaw = 0.25
		}
	}
}
SpreadTemplates.pistol_special = {
	continuous = {
		still = {
			max_yaw = 1,
			max_pitch = 1
		},
		moving = {
			max_yaw = 1.5,
			max_pitch = 1.5
		},
		crouch_still = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		crouch_moving = {
			max_yaw = 1,
			max_pitch = 1
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 1,
			max_pitch = 1
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 1,
			max_pitch = 1
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 0.25,
			immediate_yaw = 0.25
		}
	}
}
SpreadTemplates.brace_of_drake_pistols = {
	continuous = {
		still = {
			max_yaw = 2,
			max_pitch = 2
		},
		moving = {
			max_yaw = 3,
			max_pitch = 3
		},
		crouch_still = {
			max_yaw = 2,
			max_pitch = 2
		},
		crouch_moving = {
			max_yaw = 2.5,
			max_pitch = 2.5
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 3,
			immediate_yaw = 3
		}
	}
}
SpreadTemplates.drakegun = {
	continuous = {
		still = {
			max_yaw = 1.75,
			max_pitch = 1.75
		},
		moving = {
			max_yaw = 3,
			max_pitch = 3
		},
		crouch_still = {
			max_yaw = 3,
			max_pitch = 3
		},
		crouch_moving = {
			max_yaw = 3.5,
			max_pitch = 3.5
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 10,
			immediate_yaw = 10
		}
	}
}
SpreadTemplates.drake_pistol_charged = {
	continuous = {
		still = {
			max_yaw = 15,
			max_pitch = 6
		},
		moving = {
			max_yaw = 15,
			max_pitch = 6
		},
		crouch_still = {
			max_yaw = 15,
			max_pitch = 6
		},
		crouch_moving = {
			max_yaw = 15,
			max_pitch = 6
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 10,
			immediate_yaw = 10
		}
	}
}
SpreadTemplates.fireball = {
	continuous = {
		still = {
			max_yaw = 1,
			max_pitch = 1
		},
		moving = {
			max_yaw = 1.5,
			max_pitch = 1.5
		},
		crouch_still = {
			max_yaw = 2.5,
			max_pitch = 2.25
		},
		crouch_moving = {
			max_yaw = 2.5,
			max_pitch = 2.5
		},
		zoomed_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		},
		zoomed_crouch_still = {
			max_yaw = 0,
			max_pitch = 0
		},
		zoomed_crouch_moving = {
			max_yaw = 0.4,
			max_pitch = 0.4
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1.4,
			immediate_yaw = 1.4
		},
		shooting = {
			immediate_pitch = 4,
			immediate_yaw = 4
		}
	}
}
SpreadTemplates.vs_warpfire_thrower_gun = {
	continuous = {
		still = {
			max_yaw = 7,
			max_pitch = 7
		},
		moving = {
			max_yaw = 8,
			max_pitch = 8
		},
		crouch_still = {
			max_yaw = 7,
			max_pitch = 7
		},
		crouch_moving = {
			max_yaw = 8,
			max_pitch = 8
		},
		zoomed_still = {
			max_yaw = 7,
			max_pitch = 7
		},
		zoomed_moving = {
			max_yaw = 8,
			max_pitch = 8
		},
		zoomed_crouch_still = {
			max_yaw = 7,
			max_pitch = 7
		},
		zoomed_crouch_moving = {
			max_yaw = 8,
			max_pitch = 8
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1,
			immediate_yaw = 1
		},
		shooting = {
			immediate_pitch = 1,
			immediate_yaw = 1
		}
	}
}
SpreadTemplates.vs_ratling_gunner_gun = {
	continuous = {
		still = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		crouch_still = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		crouch_moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		zoomed_still = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		zoomed_moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		zoomed_crouch_still = {
			max_yaw = 0.5,
			max_pitch = 0.5
		},
		zoomed_crouch_moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1,
			immediate_yaw = 1
		},
		shooting = {
			immediate_pitch = 1,
			immediate_yaw = 1
		}
	}
}
SpreadTemplates.vs_ratling_gunner_gun_shooting = {
	continuous = {
		still = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		crouch_still = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		crouch_moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		zoomed_still = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		zoomed_moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		zoomed_crouch_still = {
			max_yaw = 0.75,
			max_pitch = 0.75
		},
		zoomed_crouch_moving = {
			max_yaw = 0.75,
			max_pitch = 0.75
		}
	},
	immediate = {
		being_hit = {
			immediate_pitch = 1,
			immediate_yaw = 1
		},
		shooting = {
			immediate_pitch = 1,
			immediate_yaw = 1
		}
	}
}
SpreadTemplates.maximum_pitch = 15
SpreadTemplates.maximum_yaw = 15

local SpreadTemplates = SpreadTemplates
local str = "fireball"
local fireball = SpreadTemplates.fireball

fireball = fireball or table.clone(SpreadTemplates.default)
SpreadTemplates[str] = fireball

local SpreadTemplates_2 = SpreadTemplates
local str_2 = "beam_staff_basic"
local beam_staff_basic = SpreadTemplates.beam_staff_basic

beam_staff_basic = beam_staff_basic or table.clone(SpreadTemplates.default)
SpreadTemplates_2[str_2] = beam_staff_basic

local SpreadTemplates_3 = SpreadTemplates
local repeating_pistol = SpreadTemplates.repeating_pistol

repeating_pistol = repeating_pistol or table.clone(SpreadTemplates.default)
SpreadTemplates_3.repeating_pistol = repeating_pistol

local SpreadTemplates_4 = SpreadTemplates
local repeating_handgun = SpreadTemplates.repeating_handgun

repeating_handgun = repeating_handgun or table.clone(SpreadTemplates.default)
SpreadTemplates_4.repeating_handgun = repeating_handgun

local SpreadTemplates_5 = SpreadTemplates
local repeating_handgun_special = SpreadTemplates.repeating_handgun_special

repeating_handgun_special = repeating_handgun_special or table.clone(SpreadTemplates.default)
SpreadTemplates_5.repeating_handgun_special = repeating_handgun_special

local SpreadTemplates_6 = SpreadTemplates
local heavy_steam_pistol_special = SpreadTemplates.heavy_steam_pistol_special

heavy_steam_pistol_special = heavy_steam_pistol_special or table.clone(SpreadTemplates.default)
SpreadTemplates_6.heavy_steam_pistol_special = heavy_steam_pistol_special

local SpreadTemplates_7 = SpreadTemplates
local repeating_crossbow_burst = SpreadTemplates.repeating_crossbow_burst

repeating_crossbow_burst = repeating_crossbow_burst or table.clone(SpreadTemplates.default)
SpreadTemplates_7.repeating_crossbow_burst = repeating_crossbow_burst

local SpreadTemplates_8 = SpreadTemplates
local sparks = SpreadTemplates.sparks

sparks = sparks or table.clone(SpreadTemplates.default)
SpreadTemplates_8.sparks = sparks

local SpreadTemplates_9 = SpreadTemplates
local spear = SpreadTemplates.spear

spear = spear or table.clone(SpreadTemplates.default)
SpreadTemplates_9.spear = spear

local SpreadTemplates_10 = SpreadTemplates
local longbow = SpreadTemplates.longbow

longbow = longbow or table.clone(SpreadTemplates.default)
SpreadTemplates_10.longbow = longbow

local SpreadTemplates_11 = SpreadTemplates
local empire_longbow = SpreadTemplates.empire_longbow

empire_longbow = empire_longbow or table.clone(SpreadTemplates.default)
SpreadTemplates_11.empire_longbow = empire_longbow

local SpreadTemplates_12 = SpreadTemplates
local create_copy = table.create_copy(SpreadTemplates.handgun, SpreadTemplates.handgun)

create_copy = create_copy or table.clone(SpreadTemplates.default)
SpreadTemplates_12.handgun = create_copy

local SpreadTemplates_13 = SpreadTemplates
local crossbow = SpreadTemplates.crossbow

crossbow = crossbow or table.clone(SpreadTemplates.default)
SpreadTemplates_13.crossbow = crossbow

local SpreadTemplates_14 = SpreadTemplates
local str_3 = "brace_of_pistols"
local brace_of_pistols = SpreadTemplates.brace_of_pistols

brace_of_pistols = brace_of_pistols or table.clone(SpreadTemplates.default)
SpreadTemplates_14[str_3] = brace_of_pistols

local SpreadTemplates_15 = SpreadTemplates
local str_4 = "pistol_special"
local pistol_special = SpreadTemplates.pistol_special

pistol_special = pistol_special or table.clone(SpreadTemplates.default)
SpreadTemplates_15[str_4] = pistol_special

local SpreadTemplates_16 = SpreadTemplates
local str_5 = "brace_of_drake_pistols"
local brace_of_drake_pistols = SpreadTemplates.brace_of_drake_pistols

brace_of_drake_pistols = brace_of_drake_pistols or table.clone(SpreadTemplates.default)
SpreadTemplates_16[str_5] = brace_of_drake_pistols

local SpreadTemplates_17 = SpreadTemplates
local str_6 = "drakegun"
local drakegun = SpreadTemplates.drakegun

drakegun = drakegun or table.clone(SpreadTemplates.default)
SpreadTemplates_17[str_6] = drakegun

local SpreadTemplates_18 = SpreadTemplates
local create_copy_2 = table.create_copy(SpreadTemplates.bow, SpreadTemplates.bow)

create_copy_2 = create_copy_2 or table.clone(SpreadTemplates.default)
SpreadTemplates_18.bow = create_copy_2

local SpreadTemplates_19 = SpreadTemplates
local create_copy_3 = table.create_copy(SpreadTemplates.blunderbuss, SpreadTemplates.blunderbuss)

create_copy_3 = create_copy_3 or table.clone(SpreadTemplates.default)
SpreadTemplates_19.blunderbuss = create_copy_3

local SpreadTemplates_20 = SpreadTemplates
local create_copy_4 = table.create_copy(SpreadTemplates.bounty_hunter_shotgun, SpreadTemplates.bounty_hunter_shotgun)

create_copy_4 = create_copy_4 or table.clone(SpreadTemplates.default)
SpreadTemplates_20.bounty_hunter_shotgun = create_copy_4

local SpreadTemplates_21 = SpreadTemplates
local str_7 = "drake_pistol_charged"
local drake_pistol_charged = SpreadTemplates.drake_pistol_charged

drake_pistol_charged = drake_pistol_charged or table.clone(SpreadTemplates.default)
SpreadTemplates_21[str_7] = drake_pistol_charged

local SpreadTemplates_22 = SpreadTemplates
local create_copy_5 = table.create_copy(SpreadTemplates.rake_shot, SpreadTemplates.rake_shot)

create_copy_5 = create_copy_5 or table.clone(SpreadTemplates.default)
SpreadTemplates_22.rake_shot = create_copy_5

local SpreadTemplates_23 = SpreadTemplates
local str_8 = "rake_twin_shot"
local create_copy_6 = table.create_copy(SpreadTemplates.rake_twin_shot, SpreadTemplates.rake_twin_shot)

create_copy_6 = create_copy_6 or table.clone(SpreadTemplates.default)
SpreadTemplates_23[str_8] = create_copy_6

local SpreadTemplates_24 = SpreadTemplates
local str_9 = "rake_twin_shot"
local rake_twin_shot = SpreadTemplates.rake_twin_shot

rake_twin_shot = rake_twin_shot or table.clone(SpreadTemplates.default)
SpreadTemplates_24[str_9] = rake_twin_shot

local SpreadTemplates_25 = SpreadTemplates
local str_10 = "vs_warpfire_thrower_gun"
local vs_warpfire_thrower_gun = SpreadTemplates.vs_warpfire_thrower_gun

vs_warpfire_thrower_gun = vs_warpfire_thrower_gun or table.clone(SpreadTemplates.default)
SpreadTemplates_25[str_10] = vs_warpfire_thrower_gun

local SpreadTemplates_26 = SpreadTemplates
local str_11 = "vs_ratling_gunner_gun"
local vs_ratling_gunner_gun = SpreadTemplates.vs_ratling_gunner_gun

vs_ratling_gunner_gun = vs_ratling_gunner_gun or table.clone(SpreadTemplates.default)
SpreadTemplates_26[str_11] = vs_ratling_gunner_gun

local SpreadTemplates_27 = SpreadTemplates
local str_12 = "vs_ratling_gunner_gun_shooting"
local vs_ratling_gunner_gun_shooting = SpreadTemplates.vs_ratling_gunner_gun_shooting

vs_ratling_gunner_gun_shooting = vs_ratling_gunner_gun_shooting or table.clone(SpreadTemplates.default)
SpreadTemplates_27[str_12] = vs_ratling_gunner_gun_shooting

DLCUtils.merge("spread_templates", SpreadTemplates)
