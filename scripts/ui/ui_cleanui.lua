-- chunkname: @scripts/ui/ui_cleanui.lua

UICleanUI = class(UICleanUI)

local var_0_0 = 1
local var_0_1 = 1.5
local var_0_2 = 0.1
local var_0_3 = 50
local var_0_4 = 1

function UICleanUI.create(arg_1_0, arg_1_1)
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

local function var_0_5(arg_2_0)
	local var_2_0, var_2_1 = Application.resolution()
	local var_2_2 = var_2_0
	local var_2_3 = var_2_1
	local var_2_4 = 0
	local var_2_5 = 0

	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		var_2_2 = math.min(var_2_2, iter_2_1[1][1])
		var_2_3 = math.min(var_2_3, iter_2_1[1][2])
		var_2_4 = math.max(var_2_4, iter_2_1[1][1] + iter_2_1[2][1])
		var_2_5 = math.max(var_2_5, iter_2_1[1][2] + iter_2_1[2][2])
	end

	local var_2_6 = RESOLUTION_LOOKUP.scale

	return {
		var_2_2 * var_2_6,
		var_2_3 * var_2_6,
		var_2_4 * var_2_6,
		var_2_5 * var_2_6
	}
end

local function var_0_6(arg_3_0, arg_3_1)
	return {
		arg_3_0[1] - arg_3_1,
		arg_3_0[2] - arg_3_1,
		arg_3_0[3] + arg_3_1,
		arg_3_0[4] + arg_3_1
	}
end

local function var_0_7(arg_4_0, arg_4_1, arg_4_2)
	return arg_4_0 > arg_4_2[1] and arg_4_0 < arg_4_2[3] and arg_4_1 > arg_4_2[2] and arg_4_1 < arg_4_2[4]
end

function UICleanUI.update(arg_5_0, arg_5_1)
	local var_5_0 = false
	local var_5_1 = arg_5_0.peer_id
	local var_5_2 = Managers.player:player_from_peer_id(var_5_1)
	local var_5_3 = var_5_2 and var_5_2.player_unit

	if Unit.alive(var_5_3) and ScriptUnit.has_extension(var_5_3, "eyetracking_system") then
		var_5_0 = ScriptUnit.extension(var_5_3, "eyetracking_system"):get_is_feature_enabled("tobii_clean_ui")
	end

	local var_5_4, var_5_5 = Tobii.get_gaze_point()
	local var_5_6 = var_5_4 * 0.5 + 0.5
	local var_5_7 = var_5_5 * 0.5 + 0.5
	local var_5_8, var_5_9 = Application.resolution()
	local var_5_10 = var_5_6 * var_5_8
	local var_5_11 = var_5_7 * var_5_9
	local var_5_12 = var_5_6 >= 0 and var_5_6 <= 1 and var_5_7 >= 0 and var_5_7 <= 1
	local var_5_13 = false

	if var_5_12 then
		arg_5_0.off_window_clock = 0
	else
		arg_5_0.off_window_clock = arg_5_0.off_window_clock + arg_5_1
		var_5_13 = arg_5_0.off_window_clock > var_0_4

		if var_5_13 then
			arg_5_0.off_window_clock = var_0_4
		end
	end

	local var_5_14 = arg_5_0.hud
	local var_5_15 = {
		86,
		108
	}
	local var_5_16 = {}
	local var_5_17 = var_5_14:component("UnitFramesHandler")
	local var_5_18 = var_5_17:unit_frame_amount()

	for iter_5_0 = 1, var_5_18 do
		local var_5_19 = var_5_17:get_unit_widget(iter_5_0).ui_scenegraph.portrait_pivot.world_position

		var_5_16[iter_5_0] = {
			{
				var_5_19[1] - var_5_15[1] * 0.5,
				var_5_19[2] - var_5_15[2]
			},
			var_5_15
		}
	end

	local var_5_20 = var_5_14:component("EquipmentUI")
	local var_5_21 = var_5_14:component("GamePadEquipmentUI")

	if not var_5_20 or not var_5_21 then
		return
	end

	local var_5_22 = var_5_20.ui_scenegraph.ammo_background.world_position
	local var_5_23 = var_5_20.ui_scenegraph.ammo_background.size
	local var_5_24 = var_5_20.ui_scenegraph.background_panel.world_position
	local var_5_25 = var_5_21.ui_scenegraph.background_panel.world_position
	local var_5_26 = var_5_20.ui_scenegraph.background_panel.size
	local var_5_27 = var_5_21.ui_scenegraph.background_panel.size
	local var_5_28 = {
		{
			{
				var_5_24[1],
				var_5_24[2],
				var_5_24[3]
			},
			{
				var_5_26[1],
				var_5_26[2]
			}
		}
	}
	local var_5_29 = {
		{
			{
				var_5_22[1],
				var_5_22[2],
				var_5_22[3]
			},
			{
				var_5_23[1],
				var_5_23[2]
			}
		}
	}
	local var_5_30 = {
		{
			{
				var_5_25[1],
				var_5_25[2],
				var_5_25[3]
			},
			{
				var_5_27[1],
				var_5_27[2]
			}
		}
	}
	local var_5_31 = {
		var_5_16[2],
		var_5_16[3],
		var_5_16[4]
	}
	local var_5_32 = {
		var_5_16[1]
	}

	if not arg_5_0.clusters or RESOLUTION_LOOKUP.modified or arg_5_0.dirty then
		local var_5_33 = arg_5_0.hud

		if arg_5_0.gamepadclusters then
			arg_5_0.gamepadclusters.bottom.bounding_box = var_0_6(var_0_5(var_5_30), var_0_3)
			arg_5_0.gamepadclusters.left.bounding_box = var_0_6(var_0_5(var_5_31), var_0_3)
			arg_5_0.gamepadclusters.bottom_left.bounding_box = var_0_6(var_0_5(var_5_32), var_0_3)
			arg_5_0.gamepadclusters.bottom_right.bounding_box = var_0_6(var_0_5(var_5_29), var_0_3)
		else
			arg_5_0.gamepadclusters = {
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
					bounding_box = var_0_6(var_0_5(var_5_28), var_0_3),
					widgets = {
						{
							alpha = -1,
							set_alpha_function = "set_health_alpha",
							get_widget_function = function(arg_6_0)
								return (arg_6_0.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							set_alpha_function = "set_frame_alpha",
							alpha = -1,
							widget = var_5_33:component("GamepadEquipmentUI")
						}
					}
				},
				left = {
					bounding_box = var_0_6(var_0_5(var_5_31), var_0_3),
					widgets = {
						{
							alpha = 1,
							get_widget_function = function(arg_7_0)
								return (arg_7_0.hud:component("UnitFramesHandler"):get_unit_widget(2))
							end
						},
						{
							alpha = -1,
							get_widget_function = function(arg_8_0)
								return (arg_8_0.hud:component("UnitFramesHandler"):get_unit_widget(3))
							end
						},
						{
							alpha = -1,
							get_widget_function = function(arg_9_0)
								return (arg_9_0.hud:component("UnitFramesHandler"):get_unit_widget(4))
							end
						}
					}
				},
				bottom_left = {
					bounding_box = var_0_6(var_0_5(var_5_31), var_0_3),
					widgets = {
						{
							alpha = -1,
							set_alpha_function = "set_default_alpha",
							get_widget_function = function(arg_10_0)
								return (arg_10_0.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							set_alpha_function = "set_portrait_alpha",
							get_widget_function = function(arg_11_0)
								return (arg_11_0.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							widget = var_5_33:component("BuffUI")
						}
					}
				},
				bottom_right = {
					bounding_box = var_0_6(var_0_5(var_5_29), var_0_3),
					widgets = {
						{
							set_alpha_function = "set_panel_alpha",
							alpha = -1,
							widget = var_5_33:component("GamePadEquipmentUI")
						},
						{
							alpha = -1,
							set_alpha_function = "set_ability_alpha",
							get_widget_function = function(arg_12_0)
								return (arg_12_0.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							widget = var_5_33:component("GamePadAbilityUI")
						}
					}
				}
			}
		end

		if arg_5_0.clusters then
			arg_5_0.clusters.bottom.bounding_box = var_0_6(var_0_5(var_5_28), var_0_3)
			arg_5_0.clusters.left.bounding_box = var_0_6(var_0_5(var_5_31), var_0_3)
			arg_5_0.clusters.bottom_left.bounding_box = var_0_6(var_0_5(var_5_32), var_0_3)
			arg_5_0.clusters.bottom_right.bounding_box = var_0_6(var_0_5(var_5_29), var_0_3)
		else
			arg_5_0.clusters = {
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
					bounding_box = var_0_6(var_0_5(var_5_28), var_0_3),
					widgets = {
						{
							set_alpha_function = "set_panel_alpha",
							alpha = -1,
							widget = var_5_33:component("EquipmentUI")
						},
						{
							alpha = -1,
							set_alpha_function = "set_equipment_alpha",
							get_widget_function = function(arg_13_0)
								return (arg_13_0.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							set_alpha_function = "set_health_alpha",
							get_widget_function = function(arg_14_0)
								return (arg_14_0.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							set_alpha_function = "set_ability_alpha",
							get_widget_function = function(arg_15_0)
								return (arg_15_0.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							widget = var_5_33:component("AbilityUI")
						}
					}
				},
				left = {
					bounding_box = var_0_6(var_0_5(var_5_31), var_0_3),
					widgets = {
						{
							alpha = 1,
							get_widget_function = function(arg_16_0)
								return (arg_16_0.hud:component("UnitFramesHandler"):get_unit_widget(2))
							end
						},
						{
							alpha = -1,
							get_widget_function = function(arg_17_0)
								return (arg_17_0.hud:component("UnitFramesHandler"):get_unit_widget(3))
							end
						},
						{
							alpha = -1,
							get_widget_function = function(arg_18_0)
								return (arg_18_0.hud:component("UnitFramesHandler"):get_unit_widget(4))
							end
						}
					}
				},
				bottom_left = {
					bounding_box = var_0_6(var_0_5(var_5_31), var_0_3),
					widgets = {
						{
							alpha = -1,
							set_alpha_function = "set_default_alpha",
							get_widget_function = function(arg_19_0)
								return (arg_19_0.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							set_alpha_function = "set_portrait_alpha",
							get_widget_function = function(arg_20_0)
								return (arg_20_0.hud:component("UnitFramesHandler"):get_unit_widget(1))
							end
						},
						{
							alpha = -1,
							widget = var_5_33:component("BuffUI")
						}
					}
				},
				bottom_right = {
					bounding_box = var_0_6(var_0_5(var_5_29), var_0_3),
					widgets = {
						{
							set_alpha_function = "set_ammo_alpha",
							alpha = -1,
							widget = var_5_33:component("EquipmentUI")
						}
					}
				}
			}
		end
	end

	local var_5_34 = true

	for iter_5_1, iter_5_2 in pairs(arg_5_0.clocks) do
		var_5_34 = false
	end

	local var_5_35 = Managers.state.entity:system("cutscene_system")
	local var_5_36 = var_5_35 and var_5_35.active_camera
	local var_5_37 = Managers.input:is_device_active("gamepad")
	local var_5_38 = arg_5_0.clusters

	if var_5_37 then
		var_5_38 = arg_5_0.gamepadclusters
	end

	local var_5_39 = arg_5_0.clocks

	for iter_5_3, iter_5_4 in pairs(var_5_38) do
		local var_5_40 = var_5_39[iter_5_3]
		local var_5_41 = var_0_7(var_5_10, var_5_11, iter_5_4.bounding_box)

		iter_5_4.visible = var_5_41

		if var_5_41 or var_5_34 or var_5_13 or var_5_36 then
			var_5_40 = var_0_0 + var_0_1
		else
			var_5_40 = math.max(0, var_5_40 - arg_5_1)
		end

		local var_5_42 = 1

		if var_5_0 then
			var_5_42 = var_5_40 / var_0_1
			var_5_42 = var_5_42 * (1 - var_0_2) + var_0_2
			var_5_42 = math.clamp(var_5_42, 0, 1)
		end

		local var_5_43 = iter_5_4.widgets

		for iter_5_5, iter_5_6 in pairs(var_5_43) do
			local var_5_44 = iter_5_6.widget
			local var_5_45 = iter_5_6.get_widget_function

			if var_5_45 then
				var_5_44 = var_5_45(arg_5_0)
			end

			if iter_5_6.alpha ~= var_5_42 then
				if var_5_44 then
					local var_5_46 = iter_5_6.set_alpha_function

					if var_5_46 then
						if var_5_44[var_5_46] then
							var_5_44[var_5_46](var_5_44, var_5_42)
						end
					else
						if var_5_44.set_panel_alpha then
							var_5_44:set_panel_alpha(var_5_42)
						end

						if var_5_44.set_alpha then
							var_5_44:set_alpha(var_5_42)
						end
					end
				end

				iter_5_6.alpha = var_5_42
			end
		end

		var_5_39[iter_5_3] = var_5_40
	end
end
