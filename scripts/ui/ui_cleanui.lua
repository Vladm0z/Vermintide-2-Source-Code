-- chunkname: @scripts/ui/ui_cleanui.lua

UICleanUI = class(UICleanUI)

local num = 1
local num_2 = 1.5
local num_3 = 0.1
local num_4 = 50
local num_5 = 1

UICleanUI.create = function (arg_1_0, arg_1_1)
	-- function 1
	return {
		off_window_clock = 0,
		was_enabled = false,
		dirty = true,
		areas = {},
		widget_area_map = {},
		clocks = {},
		peer_id = arg_1_0,
		hud = arg_1_1
	}
end

local function fn(arg_2_0)
	-- function 2
	local resolution, var_2_1 = Application.resolution()
	local var_2_2 = resolution
	local var_2_3 = var_2_1
	local num = 0
	local num_2 = 0

	for i, v in ipairs(arg_2_0) do
		var_2_2 = math.min(var_2_2, v[1][1])
		var_2_3 = math.min(var_2_3, v[1][2])
		num = math.max(num, v[1][1] + v[2][1])
		num_2 = math.max(num_2, v[1][2] + v[2][2])
	end

	local scale = RESOLUTION_LOOKUP.scale

	return {
		var_2_2 * scale,
		var_2_3 * scale,
		num * scale,
		num_2 * scale
	}
end

local function fn_2(self, arg_3_1)
	-- function 3
	return {
		self[1] - arg_3_1,
		self[2] - arg_3_1,
		self[3] + arg_3_1,
		self[4] + arg_3_1
	}
end

local function fn_3(arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	return not (arg_4_0 > arg_4_2[1]) or not (arg_4_0 < arg_4_2[3]) or not (arg_4_1 > arg_4_2[2]) or arg_4_1 < arg_4_2[4]
end

UICleanUI.update = function (self, arg_5_1)
	-- function 5
	local flag = false
	local peer_id = self.peer_id
	local player_from_peer_id = Managers.player:player_from_peer_id(peer_id)
	local flag_2 = not player_from_peer_id and player_from_peer_id.player_unit

	if not Unit.alive(flag_2) and not ScriptUnit.has_extension(flag_2, "eyetracking_system") then
		flag = ScriptUnit.extension(flag_2, "eyetracking_system"):get_is_feature_enabled("tobii_clean_ui")
	end

	local get_gaze_point, var_5_5 = Tobii.get_gaze_point()
	local num_6 = get_gaze_point * 0.5 + 0.5
	local num_7 = var_5_5 * 0.5 + 0.5
	local resolution, var_5_9 = Application.resolution()
	local num_8 = num_6 * resolution
	local num_9 = num_7 * var_5_9
	local flag_3 = not (num_6 >= 0) or not (num_6 <= 1) or not (num_7 >= 0) or num_7 <= 1
	local flag_4 = false

	if not flag_3 then
		self.off_window_clock = 0
	else
		self.off_window_clock = self.off_window_clock + arg_5_1
		flag_4 = self.off_window_clock > num_5

		if not flag_4 then
			self.off_window_clock = num_5
		end
	end

	local hud = self.hud
	local tbl = {
		86,
		108
	}
	local tbl_2 = {}
	local component = hud:component("UnitFramesHandler")
	local unit_frame_amount = component:unit_frame_amount()

	for i = 1, unit_frame_amount do
		local world_position = component:get_unit_widget(i).ui_scenegraph.portrait_pivot.world_position

		tbl_2[i] = {
			{
				world_position[1] - tbl[1] * 0.5,
				world_position[2] - tbl[2]
			},
			tbl
		}
	end

	local component_2 = hud:component("EquipmentUI")
	local component_3 = hud:component("GamePadEquipmentUI")

	if not (not component_2 and component_3) then
		return
	end

	local world_position_2 = component_2.ui_scenegraph.ammo_background.world_position
	local size = component_2.ui_scenegraph.ammo_background.size
	local world_position_3 = component_2.ui_scenegraph.background_panel.world_position
	local world_position_4 = component_3.ui_scenegraph.background_panel.world_position
	local size_2 = component_2.ui_scenegraph.background_panel.size
	local size_3 = component_3.ui_scenegraph.background_panel.size
	local tbl_3 = {
		{
			{
				world_position_3[1],
				world_position_3[2],
				world_position_3[3]
			},
			{
				size_2[1],
				size_2[2]
			}
		}
	}
	local tbl_4 = {
		{
			{
				world_position_2[1],
				world_position_2[2],
				world_position_2[3]
			},
			{
				size[1],
				size[2]
			}
		}
	}
	local tbl_5 = {
		{
			{
				world_position_4[1],
				world_position_4[2],
				world_position_4[3]
			},
			{
				size_3[1],
				size_3[2]
			}
		}
	}
	local tbl_6 = {
		tbl_2[2],
		tbl_2[3],
		tbl_2[4]
	}
	local tbl_7 = {
		tbl_2[1]
	}

	if not self.clusters and RESOLUTION_LOOKUP.modified or not self.dirty then
		local hud_2 = self.hud

		if not self.gamepadclusters then
			self.gamepadclusters.bottom.bounding_box = fn_2(fn(tbl_5), num_4)
			self.gamepadclusters.left.bounding_box = fn_2(fn(tbl_6), num_4)
			self.gamepadclusters.bottom_left.bounding_box = fn_2(fn(tbl_7), num_4)
			self.gamepadclusters.bottom_right.bounding_box = fn_2(fn(tbl_4), num_4)
		else
			self.gamepadclusters = {
				mission = {
					bounding_box = {
						0,
						0,
						10,
						10
					},
					widgets = {}
				},
				bottom = {
					bounding_box = fn_2(fn(tbl_3), num_4),
					widgets = {
						{
							alpha = -1,
							set_alpha_function = "set_health_alpha",
							get_widget_function = function (self)
								-- function 6
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							set_alpha_function = "set_frame_alpha",
							alpha = -1,
							widget = hud_2:component("GamepadEquipmentUI")
						}
					}
				},
				left = {
					bounding_box = fn_2(fn(tbl_6), num_4),
					widgets = {
						{
							alpha = 1,
							get_widget_function = function (self)
								-- function 7
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(2))
							end
						},
						{
							alpha = -1,
							get_widget_function = function (self)
								-- function 8
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(3))
							end
						},
						{
							alpha = -1,
							get_widget_function = function (self)
								-- function 9
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(4))
							end
						}
					}
				},
				bottom_left = {
					bounding_box = fn_2(fn(tbl_6), num_4),
					widgets = {
						{
							alpha = -1,
							set_alpha_function = "set_default_alpha",
							get_widget_function = function (self)
								-- function 10
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							set_alpha_function = "set_portrait_alpha",
							get_widget_function = function (self)
								-- function 11
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							widget = hud_2:component("BuffUI")
						}
					}
				},
				bottom_right = {
					bounding_box = fn_2(fn(tbl_4), num_4),
					widgets = {
						{
							set_alpha_function = "set_panel_alpha",
							alpha = -1,
							widget = hud_2:component("GamePadEquipmentUI")
						},
						{
							alpha = -1,
							set_alpha_function = "set_ability_alpha",
							get_widget_function = function (self)
								-- function 12
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							widget = hud_2:component("GamePadAbilityUI")
						}
					}
				}
			}
		end

		if not self.clusters then
			self.clusters.bottom.bounding_box = fn_2(fn(tbl_3), num_4)
			self.clusters.left.bounding_box = fn_2(fn(tbl_6), num_4)
			self.clusters.bottom_left.bounding_box = fn_2(fn(tbl_7), num_4)
			self.clusters.bottom_right.bounding_box = fn_2(fn(tbl_4), num_4)
		else
			self.clusters = {
				mission = {
					bounding_box = {
						0,
						0,
						10,
						10
					},
					widgets = {}
				},
				bottom = {
					bounding_box = fn_2(fn(tbl_3), num_4),
					widgets = {
						{
							set_alpha_function = "set_panel_alpha",
							alpha = -1,
							widget = hud_2:component("EquipmentUI")
						},
						{
							alpha = -1,
							set_alpha_function = "set_equipment_alpha",
							get_widget_function = function (self)
								-- function 13
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							set_alpha_function = "set_health_alpha",
							get_widget_function = function (self)
								-- function 14
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							set_alpha_function = "set_ability_alpha",
							get_widget_function = function (self)
								-- function 15
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							widget = hud_2:component("AbilityUI")
						}
					}
				},
				left = {
					bounding_box = fn_2(fn(tbl_6), num_4),
					widgets = {
						{
							alpha = 1,
							get_widget_function = function (self)
								-- function 16
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(2))
							end
						},
						{
							alpha = -1,
							get_widget_function = function (self)
								-- function 17
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(3))
							end
						},
						{
							alpha = -1,
							get_widget_function = function (self)
								-- function 18
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(4))
							end
						}
					}
				},
				bottom_left = {
					bounding_box = fn_2(fn(tbl_6), num_4),
					widgets = {
						{
							alpha = -1,
							set_alpha_function = "set_default_alpha",
							get_widget_function = function (self)
								-- function 19
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							set_alpha_function = "set_portrait_alpha",
							get_widget_function = function (self)
								-- function 20
								return (self.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							widget = hud_2:component("BuffUI")
						}
					}
				},
				bottom_right = {
					bounding_box = fn_2(fn(tbl_4), num_4),
					widgets = {
						{
							set_alpha_function = "set_ammo_alpha",
							alpha = -1,
							widget = hud_2:component("EquipmentUI")
						}
					}
				}
			}
		end
	end

	local flag_5 = true

	for k, v in pairs(self.clocks) do
		flag_5 = false
	end

	local system = Managers.state.entity:system("cutscene_system")
	local flag_6 = not system and system.active_camera
	local is_device_active = Managers.input:is_device_active("gamepad")
	local clusters = self.clusters

	if not is_device_active then
		clusters = self.gamepadclusters
	end

	local clocks = self.clocks

	for k_2, v_2 in pairs(clusters) do
		local var_5_40 = clocks[k_2]
		local var_5_41 = fn_3(num_8, num_9, v_2.bounding_box)

		v_2.visible = var_5_41

		if var_5_41 or flag_5 or flag_4 or not flag_6 then
			var_5_40 = num + num_2
		else
			var_5_40 = math.max(0, var_5_40 - arg_5_1)
		end

		local num_10 = 1

		if not flag then
			num_10 = var_5_40 / num_2
			num_10 = num_10 * (1 - num_3) + num_3
			num_10 = math.clamp(num_10, 0, 1)
		end

		local widgets = v_2.widgets

		for k_3, v_3 in pairs(widgets) do
			local widget = v_3.widget
			local get_widget_function = v_3.get_widget_function

			if not get_widget_function then
				widget = get_widget_function(self)
			end

			if v_3.alpha ~= num_10 then
				if not widget then
					local set_alpha_function = v_3.set_alpha_function

					if not set_alpha_function then
						if not widget[set_alpha_function] then
							widget[set_alpha_function](widget, num_10)
						end
					else
						if not widget.set_panel_alpha then
							widget:set_panel_alpha(num_10)
						end

						if not widget.set_alpha then
							widget:set_alpha(num_10)
						end
					end
				end

				v_3.alpha = num_10
			end
		end

		clocks[k_2] = var_5_40
	end
end
