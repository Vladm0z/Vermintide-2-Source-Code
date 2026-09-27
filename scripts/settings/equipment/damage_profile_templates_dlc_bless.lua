-- chunkname: @scripts/settings/equipment/damage_profile_templates_dlc_bless.lua

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, ...)
	-- function 1
	local var_1_0 = DamageProfileTemplates[arg_1_0]
	local clone = table.clone(var_1_0)
	local var_1_2 = select("#", ...)

	if not arg_1_4 then
		if type(clone.default_target) == "string" then
			clone.default_target = PowerLevelTemplates[clone.default_target]
		end

		clone.default_target = table.clone(clone.default_target)
		clone.default_target.attack_template = arg_1_4

		if type(clone.targets) == "string" then
			clone.targets = PowerLevelTemplates[clone.targets]
		end

		clone.targets = table.clone(clone.targets)

		local targets = clone.targets

		if not targets then
			for i, v in ipairs(targets) do
				if i <= var_1_2 then
					v.attack_template = select(i, ...)
				else
					v.attack_template = arg_1_4
				end
			end
		end
	end

	if not arg_1_3 then
		clone.charge_value = arg_1_3
	end

	if not arg_1_2 then
		DamageProfileTemplates[arg_1_2] = clone
	elseif not arg_1_1 then
		local str = arg_1_0 .. arg_1_1

		DamageProfileTemplates[str] = clone
	end
end

local tbl = {
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

fn("medium_blunt_smiter_1h", "_priest", nil, nil)

DamageProfileTemplates.medium_blunt_smiter_1h_priest.default_target.power_distribution.impact = 0.3

fn("medium_blunt_smiter_1h", "_thrust", nil, nil)

DamageProfileTemplates.medium_blunt_smiter_1h_thrust.default_target.power_distribution.impact = 0.35
DamageProfileTemplates.medium_blunt_smiter_1h_thrust.default_target.power_distribution.attack = 0.45

fn("shield_slam_aoe", "_priest", nil, nil)

DamageProfileTemplates.shield_slam_aoe_priest.charge_value = "aoe"

return tbl
