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

local num = 0.5

ControllerFeaturesSettings = {
	rumble = {
		init = function (self, arg_1_1)
			-- function 1
			local var_1_0 = RumbleTemplates[arg_1_1.rumble_effect]

			if not var_1_0 then
				self.ids = {}
				self._check_timer = num

				for k, v in pairs(var_1_0.motors) do
					local ids = self.ids
					local rumble_effect = self.controller.rumble_effect
					local var_1_3 = v
					local var_1_4 = var_1_0.params[v + 1]

					var_1_4 = var_1_4 or var_1_0.params
					ids[v] = rumble_effect(var_1_3, var_1_4)
				end
			else
				Application.warning(string.format("[ControllerFeaturesImplementation] No such rumble effect: %s", tostring(arg_1_1.rumble_effect)))
			end
		end,
		update = function (self, arg_2_1, arg_2_2)
			-- function 2
			self._check_timer = self._check_timer - arg_2_1

			if self._check_timer <= 0 then
				self._check_timer = num

				for k, v in pairs(self.ids) do
					if not self.controller.is_rumble_effect_playing(k, v) then
						return false
					end
				end

				return true
			else
				return false
			end
		end,
		destroy = function (self, arg_3_1, arg_3_2)
			-- function 3
			for k, v in pairs(self.ids) do
				if not self.controller.is_rumble_effect_playing(k, v) then
					self.controller.stop_rumble_effect(k, v)
				end
			end
		end
	},
	hit_rumble = {
		init = function (self, arg_4_1)
			-- function 4
			local damage_amount = arg_4_1.damage_amount
			local get_max_health = ScriptUnit.extension(arg_4_1.unit, "health_system"):get_max_health()
			local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
			local num_2 = damage_amount / get_max_health
			local num_3 = 0.025 * get_difficulty_rank
			local num_4 = 0.06 * get_difficulty_rank
			local str = "light_hit"

			if not (not (num_3 < num_2) or not (num_2 < num_4)) then
				str = "medium_hit"
			elseif num_4 <= num_2 then
				str = "heavy_hit"
			end

			local var_4_7 = RumbleTemplates[str]

			if not var_4_7 then
				self.ids = {}
				self._check_timer = num

				for k, v in pairs(var_4_7.motors) do
					self.ids[v] = self.controller.rumble_effect(v, var_4_7.params)
				end
			else
				Application.warning(string.format("[ControllerFeaturesImplementation] No such rumble effect: %s", tostring(arg_4_1.rumble_effect)))
			end
		end,
		update = function (self, arg_5_1, arg_5_2)
			-- function 5
			self._check_timer = self._check_timer - arg_5_1

			if self._check_timer <= 0 then
				self._check_timer = num

				for k, v in pairs(self.ids) do
					if not self.controller.is_rumble_effect_playing(k, v) then
						return false
					end
				end

				return true
			else
				return false
			end
		end,
		destroy = function (self, arg_6_1, arg_6_2)
			-- function 6
			for k, v in pairs(self.ids) do
				if not self.controller.is_rumble_effect_playing(k, v) then
					self.controller.stop_rumble_effect(k, v)
				end
			end
		end
	},
	camera_shake = {
		init = function (self, arg_7_1)
			-- function 7
			local shake_settings = arg_7_1.shake_settings
			local camera_shake = RumbleTemplates.camera_shake

			self.ids = {}
			self._check_timer = num

			if not arg_7_1.event_name and not camera_shake.disabled_events[arg_7_1.event_name] then
				print("[CameraFeatureSettings] Trying to add disabled rumble event:", arg_7_1.event_name)

				return
			end

			local fade_in = shake_settings.event.fade_in

			fade_in = fade_in or 0

			local fade_out = shake_settings.event.fade_out

			fade_out = fade_out or 0

			local num_2 = arg_7_1.duration - fade_in
			local clamp = math.clamp
			local octaves = arg_7_1.shake_settings.event.octaves

			octaves = octaves or 0

			local var_7_7 = clamp(octaves, 0, 6)
			local octaves_2 = shake_settings.event.octaves

			octaves_2 = octaves_2 or 1

			local num_3 = (1 - 1 / octaves_2) * arg_7_1.scale * shake_settings.event.amplitude * shake_settings.event.persistance * 0.5

			camera_shake.params.attack = fade_in
			camera_shake.params.attack_level = num_3
			camera_shake.params.frequency = var_7_7
			camera_shake.params.release = fade_out
			camera_shake.params.sustain = num_2
			camera_shake.params.sustain_level = num_3

			for k, v in pairs(camera_shake.motors) do
				self.ids[v] = self.controller.rumble_effect(v, camera_shake.params)
			end
		end,
		update = function (self, arg_8_1, arg_8_2)
			-- function 8
			self._check_timer = self._check_timer - arg_8_1

			if self._check_timer <= 0 then
				self._check_timer = num

				for k, v in pairs(self.ids) do
					if not self.controller.is_rumble_effect_playing(k, v) then
						return false
					end
				end

				return true
			else
				return false
			end
		end,
		destroy = function (self, arg_9_1, arg_9_2)
			-- function 9
			for k, v in pairs(self.ids) do
				if not self.controller.is_rumble_effect_playing(k, v) then
					self.controller.stop_rumble_effect(k, v)
				end
			end
		end
	},
	persistent_rumble = {
		init = function (self, arg_10_1)
			-- function 10
			local clone = table.clone(RumbleTemplates[arg_10_1.rumble_effect])
			local sustain_function = arg_10_1.sustain_function

			if not clone then
				self.sustain_function = sustain_function
				self.ids = {}
				self.check_timer = num

				for k, v in pairs(clone.params) do
					if not v.sustain then
						v.sustain = math.huge
					end
				end

				for k_2, v_2 in pairs(clone.motors) do
					local ids = self.ids
					local rumble_effect = self.controller.rumble_effect
					local var_10_4 = v_2
					local var_10_5 = clone.params[v_2 + 1]

					var_10_5 = var_10_5 or clone.params
					ids[v_2] = rumble_effect(var_10_4, var_10_5)
				end
			else
				Application.warning(string.format("[ControllerFeaturesImplementation] No such rumble effect: %s", tostring(arg_10_1.rumble_effect)))
			end
		end,
		update = function (self, arg_11_1, arg_11_2)
			-- function 11
			self.check_timer = self.check_timer - arg_11_1

			if self.check_timer <= 0 then
				self.check_timer = num

				if not (not self.sustain_function and self.sustain_function()) then
					return true
				end

				for k, v in pairs(self.ids) do
					if not self.controller.is_rumble_effect_playing(k, v) then
						return false
					end
				end

				return true
			else
				return false
			end
		end,
		destroy = function (self, arg_12_1, arg_12_2)
			-- function 12
			for k, v in pairs(self.ids) do
				if not self.controller.is_rumble_effect_playing(k, v) then
					self.controller.stop_rumble_effect(k, v)
				end
			end
		end
	}
}
