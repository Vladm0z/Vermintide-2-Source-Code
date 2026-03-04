-- chunkname: @scripts/settings/equipment/damage_profile_templates_dlc_bless.lua

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, ...)
	local var_1_0 = DamageProfileTemplates[arg_1_0]
	local var_1_1 = table.clone(var_1_0)
	local var_1_2 = select("#", ...)

	if arg_1_4 then
		if type(var_1_1.default_target) == "string" then
			var_1_1.default_target = PowerLevelTemplates[var_1_1.default_target]
		end

		var_1_1.default_target = table.clone(var_1_1.default_target)
		var_1_1.default_target.attack_template = arg_1_4

		if type(var_1_1.targets) == "string" then
			var_1_1.targets = PowerLevelTemplates[var_1_1.targets]
		end

		var_1_1.targets = table.clone(var_1_1.targets)

		local var_1_3 = var_1_1.targets

		if var_1_3 then
			for iter_1_0, iter_1_1 in ipairs(var_1_3) do
				if iter_1_0 <= var_1_2 then
					iter_1_1.attack_template = select(iter_1_0, ...)
				else
					iter_1_1.attack_template = arg_1_4
				end
			end
		end
	end

	if arg_1_3 then
		var_1_1.charge_value = arg_1_3
	end

	if arg_1_2 then
		DamageProfileTemplates[arg_1_2] = var_1_1
	elseif arg_1_1 then
		local var_1_4 = arg_1_0 .. arg_1_1

		DamageProfileTemplates[var_1_4] = var_1_1
	end
end

local var_0_1 = {
	hammer_book_charged_explosion = {
		no_stagger_damage_reduction = true,
		charge_value = "aoe",
		armor_modifier = {
			attack = {
				1,
				1,
				1.5,
				1,
				0.75,
				0.3
			},
			impact = {
				1,
				1,
				1,
				1,
				0.75,
				0.3
			}
		},
		default_target = {
			attack_template = "drakegun",
			damage_type = "drakegun",
			power_distribution = {
				attack = 0.3,
				impact = 0.5
			}
		}
	},
	great_hammer_righteous_heavy = {
		charge_value = "heavy_attack",
		critical_strike = {
			attack_armor_power_modifer = {
				1,
				1,
				2,
				1,
				1
			},
			impact_armor_power_modifer = {
				1,
				1,
				1,
				1,
				1
			}
		},
		cleave_distribution = {
			attack = 0.3,
			impact = 0.8
		},
		armor_modifier = {
			attack = {
				1,
				1,
				1.5,
				1,
				0.75
			},
			impact = {
				1,
				1,
				1,
				1,
				0.75
			}
		},
		default_target = {
			boost_curve_type = "tank_curve",
			boost_curve_coefficient = 4,
			attack_template = "blunt_tank",
			power_distribution = {
				attack = 0.5,
				impact = 0.5
			}
		},
		targets = {
			{
				boost_curve_type = "tank_curve",
				boost_curve_coefficient = 4,
				attack_template = "heavy_blunt_tank",
				power_distribution = {
					attack = 0.5,
					impact = 0.5
				},
				armor_modifier = {
					attack = {
						1,
						1,
						2,
						1,
						0.75
					},
					impact = {
						1.5,
						1,
						1,
						1,
						0.75
					}
				}
			},
			{
				boost_curve_type = "tank_curve",
				boost_curve_coefficient = 4,
				attack_template = "heavy_blunt_tank",
				power_distribution = {
					attack = 0.5,
					impact = 0.5
				},
				armor_modifier = {
					attack = {
						1,
						1,
						2,
						1,
						0.75
					},
					impact = {
						1.5,
						1,
						1,
						1,
						0.75
					}
				}
			},
			{
				boost_curve_type = "tank_curve",
				boost_curve_coefficient = 4,
				attack_template = "heavy_blunt_tank",
				power_distribution = {
					attack = 0.5,
					impact = 0.5
				},
				armor_modifier = {
					attack = {
						1,
						1,
						2,
						1,
						0.75
					},
					impact = {
						1.5,
						1,
						1,
						1,
						0.75
					}
				}
			},
			{
				boost_curve_type = "tank_curve",
				boost_curve_coefficient = 4,
				attack_template = "heavy_blunt_tank",
				power_distribution = {
					attack = 0.5,
					impact = 0.5
				},
				armor_modifier = {
					attack = {
						1,
						1,
						2,
						1,
						0.75
					},
					impact = {
						1.5,
						1,
						1,
						1,
						0.75
					}
				}
			},
			{
				boost_curve_type = "tank_curve",
				boost_curve_coefficient = 4,
				attack_template = "heavy_blunt_tank",
				power_distribution = {
					attack = 0.5,
					impact = 0.5
				},
				armor_modifier = {
					attack = {
						1,
						1,
						2,
						1,
						0.75
					},
					impact = {
						1.5,
						1,
						1,
						1,
						0.75
					}
				}
			}
		}
	},
	priest_hammer_blunt_smiter = {
		charge_value = "heavy_attack",
		shield_break = true,
		critical_strike = {
			attack_armor_power_modifer = {
				1,
				1.1,
				1.75,
				1.2,
				1,
				1.1
			},
			impact_armor_power_modifer = {
				1,
				1.1,
				1,
				1,
				1,
				1.1
			}
		},
		cleave_distribution = {
			attack = 0.075,
			impact = 0.075
		},
		armor_modifier = {
			attack = {
				1,
				1,
				1.75,
				1,
				0.75,
				1
			},
			impact = {
				1,
				1,
				1,
				1,
				0.75,
				1
			}
		},
		default_target = {
			boost_curve_coefficient_headshot = 0.5,
			boost_curve_type = "smiter_curve",
			boost_curve_coefficient = 0.75,
			attack_template = "heavy_blunt_smiter",
			power_distribution = {
				attack = 0.6,
				impact = 0.3
			}
		},
		targets = {
			[2] = {
				boost_curve_type = "smiter_curve",
				attack_template = "heavy_blunt_smiter",
				power_distribution = {
					attack = 0.2,
					impact = 0.1
				}
			}
		}
	},
	priest_hammer_blunt_tank_upper_2h = {
		stagger_duration_modifier = 1.5,
		charge_value = "light_attack",
		critical_strike = {
			attack_armor_power_modifer = {
				1,
				0.5,
				1,
				1,
				1
			},
			impact_armor_power_modifer = {
				1,
				1,
				0.5,
				1,
				1
			}
		},
		cleave_distribution = {
			attack = 0.3,
			impact = 0.8
		},
		armor_modifier = {
			attack = {
				1,
				0.5,
				1,
				1,
				0.75
			},
			impact = {
				1,
				1,
				0.5,
				1,
				0.75
			}
		},
		default_target = {
			boost_curve_type = "tank_curve",
			attack_template = "blunt_tank_uppercut",
			power_distribution = {
				attack = 0.05,
				impact = 0.05
			}
		},
		targets = {
			{
				boost_curve_type = "tank_curve",
				boost_curve_coefficient_headshot = 1,
				attack_template = "blunt_tank_uppercut",
				power_distribution = {
					attack = 0.475,
					impact = 0.475
				}
			},
			{
				boost_curve_type = "tank_curve",
				attack_template = "blunt_tank_uppercut",
				power_distribution = {
					attack = 0.3,
					impact = 0.3
				}
			},
			{
				boost_curve_type = "tank_curve",
				attack_template = "blunt_tank_uppercut",
				power_distribution = {
					attack = 0.075,
					impact = 0.1
				}
			}
		}
	},
	victor_priest_activated_ability_nuke_explosion = {
		charge_value = "ability",
		is_explosion = true,
		no_stagger_damage_reduction_ranged = true,
		armor_modifier = {
			attack = {
				1,
				0.2,
				1.5,
				1,
				0.75,
				0
			},
			impact = {
				1,
				0.5,
				1,
				1,
				0.75,
				0.5
			}
		},
		default_target = {
			attack_template = "flame_blast",
			dot_template_name = "victor_priest_nuke_dot",
			damage_type = "burn_shotgun",
			power_distribution = {
				attack = 0.25,
				impact = 0.75
			}
		}
	},
	priest_shield_slam_shotgun = {
		armor_modifier = "armor_modifier_slam_tank_L",
		critical_strike = "critical_strike_slam_tank_L",
		charge_value = "light_attack",
		default_target = "target_settings_slam_tank_L"
	},
	priest_shield_slam_shotgun_aoe = {
		armor_modifier = "armor_modifier_slam_tank_L",
		critical_strike = "critical_strike_slam_tank_L",
		charge_value = "light_attack",
		default_target = "aoe_target_settings_slam_tank_L",
		no_damage = true
	},
	priest_hammer_heavy_blunt_tank_upper = {
		stagger_duration_modifier = 1.8,
		charge_value = "heavy_attack",
		critical_strike = {
			attack_armor_power_modifer = {
				1,
				0.6,
				2,
				1,
				1
			},
			impact_armor_power_modifer = {
				1,
				1,
				1,
				1,
				1
			}
		},
		cleave_distribution = {
			attack = 0.3,
			impact = 0.8
		},
		armor_modifier = {
			attack = {
				1,
				0,
				1.5,
				1,
				0.75
			},
			impact = {
				1,
				1,
				1,
				1,
				0.75
			}
		},
		default_target = {
			boost_curve_type = "tank_curve",
			attack_template = "blunt_tank",
			power_distribution = {
				attack = 0.05,
				impact = 0.125
			}
		},
		targets = {
			{
				boost_curve_type = "tank_curve",
				attack_template = "heavy_blunt_tank",
				power_distribution = {
					attack = 0.46,
					impact = 0.3
				},
				armor_modifier = {
					attack = {
						1,
						0.5,
						2,
						1,
						0.75
					},
					impact = {
						1.5,
						1,
						1,
						1,
						0.75
					}
				}
			},
			{
				boost_curve_type = "tank_curve",
				attack_template = "heavy_blunt_tank",
				power_distribution = {
					attack = 0.45,
					impact = 0.225
				}
			}
		}
	}
}

var_0_0("medium_blunt_smiter_1h", "_priest", nil, nil)

DamageProfileTemplates.medium_blunt_smiter_1h_priest.default_target.power_distribution.impact = 0.3

var_0_0("medium_blunt_smiter_1h", "_thrust", nil, nil)

DamageProfileTemplates.medium_blunt_smiter_1h_thrust.default_target.power_distribution.impact = 0.35
DamageProfileTemplates.medium_blunt_smiter_1h_thrust.default_target.power_distribution.attack = 0.45

var_0_0("shield_slam_aoe", "_priest", nil, nil)

DamageProfileTemplates.shield_slam_aoe_priest.charge_value = "aoe"

return var_0_1
