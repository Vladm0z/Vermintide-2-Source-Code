-- chunkname: @scripts/settings/controller_features_settings.lua

RumbleTemplates = {
	full_stop = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0,
				sustain = 0,
				sustain_level = 0,
				attack = 0,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0,
				sustain = 0,
				sustain_level = 0,
				attack = 0,
				frequency = 0,
				period = math.huge
			}
		}
	},
	aim_start = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.01,
				sustain = 0.15,
				sustain_level = 0.15,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.01,
				sustain = 0.15,
				sustain_level = 0.15,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	overcharge_rumble = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.15,
				sustain = 1.5,
				sustain_level = 0.1,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.1,
				sustain = 1.3,
				sustain_level = 0.1,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			}
		}
	},
	overcharge_rumble_overcharged = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.2,
				sustain = 1.5,
				sustain_level = 0.15,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.25,
				sustain = 1.3,
				sustain_level = 0.15,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			}
		}
	},
	overcharge_rumble_crit = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.3,
				sustain = 1.5,
				sustain_level = 0.2,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.3,
				sustain = 1.5,
				sustain_level = 0.2,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			}
		}
	},
	reload_start = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.2,
				sustain = 0.5,
				sustain_level = 0.1,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.1,
				sustain = 0.3,
				sustain_level = 0.2,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			}
		}
	},
	reload_over = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.3,
				sustain = 0,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.3,
				sustain = 0,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	light_swing = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.2,
				sustain = 0.1,
				sustain_level = 0.1,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.2,
				sustain = 0.1,
				sustain_level = 0.1,
				attack = 0.3,
				frequency = 0,
				period = math.huge
			}
		}
	},
	crossbow_fire = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0,
				sustain_level = 0.2,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0,
				sustain_level = 0.2,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	bow_fire = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.35,
				sustain = 0,
				sustain_level = 0.2,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.35,
				sustain = 0,
				sustain_level = 0.2,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	handgun_fire = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0.25,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0.25,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	light_hit = {
		motors = {
			0
		},
		params = {
			release = 0,
			decay = 0,
			offset = 0,
			attack_level = 1,
			sustain = 0.3,
			sustain_level = 0.15,
			attack = 0,
			frequency = 0,
			period = math.huge
		}
	},
	medium_hit = {
		motors = {
			1
		},
		params = {
			release = 0,
			decay = 0,
			offset = 0,
			attack_level = 1,
			sustain = 0.3,
			sustain_level = 0.4,
			attack = 0,
			frequency = 0,
			period = math.huge
		}
	},
	heavy_hit = {
		motors = {
			0,
			1
		},
		params = {
			release = 0,
			decay = 0,
			offset = 0,
			attack_level = 1,
			sustain = 0.5,
			sustain_level = 0.7,
			attack = 0,
			frequency = 0,
			period = math.huge
		}
	},
	push_hit = {
		motors = {
			0,
			1
		},
		params = {
			release = 0,
			decay = 0,
			offset = 0,
			attack_level = 0.3,
			sustain = 0.3,
			sustain_level = 0.3,
			attack = 0,
			frequency = 0,
			period = math.huge
		}
	},
	block = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.65,
				sustain = 0.2,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.65,
				sustain = 0.1,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	hit_environment = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0.2,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0.2,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	hit_shield = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0.3,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0.3,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	hit_character_light = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.5,
				sustain = 0,
				sustain_level = 0.35,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 0.5,
				sustain = 0,
				sustain_level = 0.35,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	hit_character = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0,
				sustain_level = 0.75,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0,
				sustain_level = 0.75,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	hit_armor = {
		motors = {
			0,
			1
		},
		params = {
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0.3,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			},
			{
				release = 0,
				decay = 0,
				offset = 0,
				attack_level = 1,
				sustain = 0.3,
				sustain_level = 0.5,
				attack = 0.2,
				frequency = 0,
				period = math.huge
			}
		}
	},
	camera_shake = {
		motors = {
			0,
			1
		},
		params = {
			release = 0,
			decay = 0,
			offset = 0,
			attack_level = 1,
			sustain = 0,
			sustain_level = 1,
			attack = 0,
			frequency = 0,
			period = math.huge
		},
		disabled_events = {
			castle_escape = true
		}
	}
}

local var_0_0 = 0.5

ControllerFeaturesSettings = {
	rumble = {
		init = function(arg_1_0, arg_1_1)
			local var_1_0 = RumbleTemplates[arg_1_1.rumble_effect]

			if var_1_0 then
				arg_1_0.ids = {}
				arg_1_0._check_timer = var_0_0

				for iter_1_0, iter_1_1 in pairs(var_1_0.motors) do
					arg_1_0.ids[iter_1_1] = arg_1_0.controller.rumble_effect(iter_1_1, var_1_0.params[iter_1_1 + 1] or var_1_0.params)
				end
			else
				Application.warning(string.format("[ControllerFeaturesImplementation] No such rumble effect: %s", tostring(arg_1_1.rumble_effect)))
			end
		end,
		update = function(arg_2_0, arg_2_1, arg_2_2)
			arg_2_0._check_timer = arg_2_0._check_timer - arg_2_1

			if arg_2_0._check_timer <= 0 then
				arg_2_0._check_timer = var_0_0

				for iter_2_0, iter_2_1 in pairs(arg_2_0.ids) do
					if arg_2_0.controller.is_rumble_effect_playing(iter_2_0, iter_2_1) then
						return false
					end
				end

				return true
			else
				return false
			end
		end,
		destroy = function(arg_3_0, arg_3_1, arg_3_2)
			for iter_3_0, iter_3_1 in pairs(arg_3_0.ids) do
				if arg_3_0.controller.is_rumble_effect_playing(iter_3_0, iter_3_1) then
					arg_3_0.controller.stop_rumble_effect(iter_3_0, iter_3_1)
				end
			end
		end
	},
	hit_rumble = {
		init = function(arg_4_0, arg_4_1)
			local var_4_0 = arg_4_1.damage_amount
			local var_4_1 = ScriptUnit.extension(arg_4_1.unit, "health_system"):get_max_health()
			local var_4_2 = Managers.state.difficulty:get_difficulty_rank()
			local var_4_3 = var_4_0 / var_4_1
			local var_4_4 = 0.025 * var_4_2
			local var_4_5 = 0.06 * var_4_2
			local var_4_6 = "light_hit"

			if var_4_4 < var_4_3 and var_4_3 < var_4_5 then
				var_4_6 = "medium_hit"
			elseif var_4_5 <= var_4_3 then
				var_4_6 = "heavy_hit"
			end

			local var_4_7 = RumbleTemplates[var_4_6]

			if var_4_7 then
				arg_4_0.ids = {}
				arg_4_0._check_timer = var_0_0

				for iter_4_0, iter_4_1 in pairs(var_4_7.motors) do
					arg_4_0.ids[iter_4_1] = arg_4_0.controller.rumble_effect(iter_4_1, var_4_7.params)
				end
			else
				Application.warning(string.format("[ControllerFeaturesImplementation] No such rumble effect: %s", tostring(arg_4_1.rumble_effect)))
			end
		end,
		update = function(arg_5_0, arg_5_1, arg_5_2)
			arg_5_0._check_timer = arg_5_0._check_timer - arg_5_1

			if arg_5_0._check_timer <= 0 then
				arg_5_0._check_timer = var_0_0

				for iter_5_0, iter_5_1 in pairs(arg_5_0.ids) do
					if arg_5_0.controller.is_rumble_effect_playing(iter_5_0, iter_5_1) then
						return false
					end
				end

				return true
			else
				return false
			end
		end,
		destroy = function(arg_6_0, arg_6_1, arg_6_2)
			for iter_6_0, iter_6_1 in pairs(arg_6_0.ids) do
				if arg_6_0.controller.is_rumble_effect_playing(iter_6_0, iter_6_1) then
					arg_6_0.controller.stop_rumble_effect(iter_6_0, iter_6_1)
				end
			end
		end
	},
	camera_shake = {
		init = function(arg_7_0, arg_7_1)
			local var_7_0 = arg_7_1.shake_settings
			local var_7_1 = RumbleTemplates.camera_shake

			arg_7_0.ids = {}
			arg_7_0._check_timer = var_0_0

			if arg_7_1.event_name and var_7_1.disabled_events[arg_7_1.event_name] then
				print("[CameraFeatureSettings] Trying to add disabled rumble event:", arg_7_1.event_name)

				return
			end

			local var_7_2 = var_7_0.event.fade_in or 0
			local var_7_3 = var_7_0.event.fade_out or 0
			local var_7_4 = arg_7_1.duration - var_7_2
			local var_7_5 = math.clamp(arg_7_1.shake_settings.event.octaves or 0, 0, 6)
			local var_7_6 = (1 - 1 / (var_7_0.event.octaves or 1)) * arg_7_1.scale * var_7_0.event.amplitude * var_7_0.event.persistance * 0.5

			var_7_1.params.attack = var_7_2
			var_7_1.params.attack_level = var_7_6
			var_7_1.params.frequency = var_7_5
			var_7_1.params.release = var_7_3
			var_7_1.params.sustain = var_7_4
			var_7_1.params.sustain_level = var_7_6

			for iter_7_0, iter_7_1 in pairs(var_7_1.motors) do
				arg_7_0.ids[iter_7_1] = arg_7_0.controller.rumble_effect(iter_7_1, var_7_1.params)
			end
		end,
		update = function(arg_8_0, arg_8_1, arg_8_2)
			arg_8_0._check_timer = arg_8_0._check_timer - arg_8_1

			if arg_8_0._check_timer <= 0 then
				arg_8_0._check_timer = var_0_0

				for iter_8_0, iter_8_1 in pairs(arg_8_0.ids) do
					if arg_8_0.controller.is_rumble_effect_playing(iter_8_0, iter_8_1) then
						return false
					end
				end

				return true
			else
				return false
			end
		end,
		destroy = function(arg_9_0, arg_9_1, arg_9_2)
			for iter_9_0, iter_9_1 in pairs(arg_9_0.ids) do
				if arg_9_0.controller.is_rumble_effect_playing(iter_9_0, iter_9_1) then
					arg_9_0.controller.stop_rumble_effect(iter_9_0, iter_9_1)
				end
			end
		end
	},
	persistent_rumble = {
		init = function(arg_10_0, arg_10_1)
			local var_10_0 = table.clone(RumbleTemplates[arg_10_1.rumble_effect])
			local var_10_1 = arg_10_1.sustain_function

			if var_10_0 then
				arg_10_0.sustain_function = var_10_1
				arg_10_0.ids = {}
				arg_10_0.check_timer = var_0_0

				for iter_10_0, iter_10_1 in pairs(var_10_0.params) do
					if iter_10_1.sustain then
						iter_10_1.sustain = math.huge
					end
				end

				for iter_10_2, iter_10_3 in pairs(var_10_0.motors) do
					arg_10_0.ids[iter_10_3] = arg_10_0.controller.rumble_effect(iter_10_3, var_10_0.params[iter_10_3 + 1] or var_10_0.params)
				end
			else
				Application.warning(string.format("[ControllerFeaturesImplementation] No such rumble effect: %s", tostring(arg_10_1.rumble_effect)))
			end
		end,
		update = function(arg_11_0, arg_11_1, arg_11_2)
			arg_11_0.check_timer = arg_11_0.check_timer - arg_11_1

			if arg_11_0.check_timer <= 0 then
				arg_11_0.check_timer = var_0_0

				if arg_11_0.sustain_function and not arg_11_0.sustain_function() then
					return true
				end

				for iter_11_0, iter_11_1 in pairs(arg_11_0.ids) do
					if arg_11_0.controller.is_rumble_effect_playing(iter_11_0, iter_11_1) then
						return false
					end
				end

				return true
			else
				return false
			end
		end,
		destroy = function(arg_12_0, arg_12_1, arg_12_2)
			for iter_12_0, iter_12_1 in pairs(arg_12_0.ids) do
				if arg_12_0.controller.is_rumble_effect_playing(iter_12_0, iter_12_1) then
					arg_12_0.controller.stop_rumble_effect(iter_12_0, iter_12_1)
				end
			end
		end
	}
}
