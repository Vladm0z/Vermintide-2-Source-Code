-- chunkname: @scripts/ui/hud_ui/world_marker_ui.lua

require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_ping")
require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_text_box")
require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_news_feed")
require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_store")
require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_pet_nameplate")
require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_pet_cancel")

local var_0_0 = {}
local var_0_1 = {}
local var_0_2 = 1
local var_0_3 = 5

local function var_0_4(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.raycast_frame_count or 0
	local var_1_1 = arg_1_1.raycast_frame_count or 0

	if var_1_0 == var_1_1 then
		return (arg_1_0.widget.content.distance or 0) < (arg_1_1.widget.content.distance or 0)
	end

	return var_1_1 < var_1_0
end

DLCUtils.require_list("ui_world_marker_templates")

local var_0_5 = {
	root = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud_inventory
		},
		size = {
			1920,
			1080
		}
	},
	pivot = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
		},
		size = {
			0,
			0
		}
	}
}
local var_0_6 = "ping"

WorldMarkerUI = class(WorldMarkerUI)

WorldMarkerUI.init = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._parent = arg_2_1
	arg_2_0.ui_renderer = arg_2_2.ui_renderer
	arg_2_0.ingame_ui = arg_2_2.ingame_ui
	arg_2_0.input_manager = arg_2_2.input_manager
	arg_2_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	arg_2_0._raycast_frame_counter = 0
	arg_2_0._aiming_alpha_multiplier = 1
	arg_2_0._game_world = arg_2_2.world_manager:world("level_world")
	arg_2_0.local_player = arg_2_2.player

	arg_2_0:_create_ui_elements()

	local var_2_0 = Managers.state.event

	var_2_0:register(arg_2_0, "add_world_marker_unit", "event_add_world_marker_unit")
	var_2_0:register(arg_2_0, "add_world_marker_position", "event_add_world_marker_position")
	var_2_0:register(arg_2_0, "remove_world_marker", "event_remove_world_marker")
	var_2_0:register(arg_2_0, "on_spectator_target_changed", "on_spectator_target_changed")
end

WorldMarkerUI.destroy = function (arg_3_0)
	local var_3_0 = Managers.state.event

	var_3_0:unregister("add_world_marker_unit", arg_3_0)
	var_3_0:unregister("add_world_marker_position", arg_3_0)
	var_3_0:unregister("remove_world_marker", arg_3_0)
	var_3_0:unregister("on_spectator_target_changed", arg_3_0)
end

WorldMarkerUI._create_ui_elements = function (arg_4_0)
	arg_4_0._id_counter = 0
	arg_4_0._markers = {}
	arg_4_0._markers_by_id = {}
	arg_4_0._markers_by_type = {}
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_5)

	local var_4_0 = {}

	arg_4_0._widget_definitions_by_type = var_4_0

	for iter_4_0, iter_4_1 in pairs(WorldMarkerTemplates) do
		var_4_0[iter_4_0] = iter_4_1.create_widget_definition("pivot")
	end
end

WorldMarkerUI.event_remove_world_marker = function (arg_5_0, arg_5_1)
	local var_5_0
	local var_5_1 = arg_5_0._markers

	for iter_5_0 = 1, #var_5_1 do
		local var_5_2 = var_5_1[iter_5_0]

		if var_5_2.id == arg_5_1 then
			var_5_0 = var_5_2

			break
		end
	end

	if var_5_0 then
		arg_5_0:_unregister_marker(var_5_0)
	end
end

WorldMarkerUI.event_add_world_marker_unit = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0:_create_widget_by_type(arg_6_1)
	local var_6_1 = arg_6_0:_register_marker({
		type = arg_6_1,
		unit = arg_6_2,
		widget = var_6_0
	})
	local var_6_2 = WorldMarkerTemplates[arg_6_1].on_enter

	if var_6_2 then
		var_6_2(var_6_0)
	end

	if arg_6_3 then
		arg_6_3(var_6_1, var_6_0)
	end
end

WorldMarkerUI.event_add_world_marker_position = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0:_create_widget_by_type(arg_7_1)
	local var_7_1 = {
		type = arg_7_1,
		world_position = Vector3Box(arg_7_2),
		widget = var_7_0
	}
	local var_7_2 = arg_7_0:_register_marker(var_7_1)
	local var_7_3 = WorldMarkerTemplates[arg_7_1].on_enter

	if var_7_3 then
		var_7_3(var_7_0)
	end

	if arg_7_3 then
		arg_7_3(var_7_2, var_7_0)
	end
end

WorldMarkerUI.on_spectator_target_changed = function (arg_8_0, arg_8_1)
	arg_8_0._spectated_player_unit = arg_8_1
	arg_8_0._spectated_player = Managers.player:owner(arg_8_1)
	arg_8_0._is_spectator = true
	arg_8_0.local_player = arg_8_0._spectated_player
end

WorldMarkerUI._register_marker = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._markers
	local var_9_1 = arg_9_0._markers_by_id
	local var_9_2 = arg_9_0._markers_by_type

	arg_9_0._id_counter = arg_9_0._id_counter + 1

	local var_9_3 = arg_9_0._id_counter

	arg_9_1.id = var_9_3
	var_9_1[var_9_3] = arg_9_1
	var_9_0[#var_9_0 + 1] = arg_9_1

	local var_9_4 = arg_9_1.type
	local var_9_5 = var_9_2[var_9_4] or {}

	var_9_2[var_9_4] = var_9_5
	var_9_5[#var_9_5 + 1] = arg_9_1

	return var_9_3
end

WorldMarkerUI._unregister_marker = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._markers
	local var_10_1 = arg_10_0._markers_by_id
	local var_10_2 = arg_10_0._markers_by_type
	local var_10_3 = arg_10_1.id

	var_10_1[var_10_3] = nil

	for iter_10_0 = 1, #var_10_0 do
		if var_10_0[iter_10_0].id == var_10_3 then
			table.remove(var_10_0, iter_10_0)

			break
		end
	end

	local var_10_4 = var_10_2[arg_10_1.type]

	for iter_10_1 = 1, #var_10_4 do
		if var_10_4[iter_10_1].id == var_10_3 then
			table.remove(var_10_4, iter_10_1)

			break
		end
	end
end

WorldMarkerUI._create_widget_by_type = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._widget_definitions_by_type[arg_11_1]

	return UIWidget.init(var_11_0)
end

WorldMarkerUI.update = function (arg_12_0, arg_12_1, arg_12_2)
	return
end

WorldMarkerUI.post_update = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.local_player.player_unit

	if not Unit.alive(var_13_0) then
		return
	end

	local var_13_1 = arg_13_0._raycast_frame_counter == 0

	arg_13_0._raycast_frame_counter = (arg_13_0._raycast_frame_counter + 1) % var_0_3

	local var_13_2 = arg_13_0._camera

	if var_13_2 then
		local var_13_3 = arg_13_0.ui_renderer
		local var_13_4 = arg_13_0.ui_scenegraph
		local var_13_5 = arg_13_0.input_manager:get_service("Player")
		local var_13_6 = arg_13_0._render_settings
		local var_13_7 = Camera.local_position(var_13_2)
		local var_13_8 = Camera.local_rotation(var_13_2)
		local var_13_9 = Quaternion.forward(var_13_8)
		local var_13_10 = Quaternion.forward(var_13_8)
		local var_13_11 = Quaternion.up(var_13_8)
		local var_13_12 = Quaternion.right(var_13_8)
		local var_13_13 = Vector3.normalize(Vector3.flat(var_13_12))
		local var_13_14 = Camera.near_range(var_13_2)
		local var_13_15 = var_13_7 + var_13_9
		local var_13_16 = Camera.local_pose(var_13_2)
		local var_13_17 = Matrix4x4.right(var_13_16)
		local var_13_18 = -var_13_17
		local var_13_19 = Matrix4x4.up(var_13_16)
		local var_13_20 = -var_13_19
		local var_13_21 = arg_13_0._markers_by_id
		local var_13_22 = arg_13_0._markers_by_type

		for iter_13_0, iter_13_1 in pairs(var_13_22) do
			local var_13_23 = WorldMarkerTemplates[iter_13_0]
			local var_13_24 = var_13_23.screen_clamp
			local var_13_25 = var_13_23.only_when_clamped
			local var_13_26 = var_13_23.draw_behind
			local var_13_27 = var_13_23.screen_margins
			local var_13_28 = var_13_23.max_distance
			local var_13_29 = var_13_23.life_time
			local var_13_30 = var_13_23.check_line_of_sight

			for iter_13_2 = 1, #iter_13_1 do
				local var_13_31 = iter_13_1[iter_13_2]
				local var_13_32 = var_13_21[var_13_31.id] ~= nil
				local var_13_33 = false
				local var_13_34 = var_13_31.widget
				local var_13_35 = var_13_34.content
				local var_13_36

				if var_13_32 then
					local var_13_37 = var_13_31.world_position

					if var_13_37 then
						var_13_36 = var_13_37:unbox()
					else
						local var_13_38 = var_13_31.unit

						if Unit.alive(var_13_38) then
							local var_13_39 = var_13_23.unit_node
							local var_13_40 = var_13_39 and Unit.node(var_13_38, var_13_39) or 0

							var_13_36 = Unit.world_position(var_13_38, var_13_40)
						else
							var_13_33 = true
						end
					end

					if var_13_29 then
						local var_13_41 = var_13_31.duration or 0
						local var_13_42 = math.min(var_13_41 + arg_13_1, var_13_29)

						if var_13_29 <= var_13_42 then
							var_13_33 = true
						else
							var_13_31.duration = var_13_42
						end
					end
				end

				if var_13_33 then
					var_13_32 = false
					var_0_0[#var_0_0 + 1] = var_13_31
				end

				if var_13_32 then
					local var_13_43 = var_13_23.position_offset

					if var_13_43 then
						var_13_36.x = var_13_36.x + var_13_43[1]
						var_13_36.y = var_13_36.y + var_13_43[2]
						var_13_36.z = var_13_36.z + var_13_43[3]
					end

					var_13_31.position = var_13_36

					local var_13_44 = Vector3.distance(var_13_36, var_13_7)

					var_13_35.distance = var_13_44

					local var_13_45 = var_13_28 and var_13_28 < var_13_44
					local var_13_46 = false
					local var_13_47 = not var_13_45

					if not var_13_45 then
						local var_13_48 = Vector3.normalize(var_13_36 - var_13_7)
						local var_13_49 = Vector3.dot(var_13_10, var_13_48)
						local var_13_50 = Vector3.dot(var_13_13, var_13_48)

						var_13_35.forward_dot_dir = var_13_49

						local var_13_51 = Camera.inside_frustum(var_13_2, var_13_36) > 0
						local var_13_52 = Vector3.cross(var_13_10, Vector3.up())
						local var_13_53 = Vector3.dot(var_13_52, var_13_48)
						local var_13_54 = math.atan2(var_13_53, var_13_49)
						local var_13_55 = var_13_49 < 0 and true or false
						local var_13_56 = var_13_36.z < var_13_7.z
						local var_13_57, var_13_58, var_13_59 = arg_13_0:_convert_world_to_screen_position(var_13_2, var_13_36)
						local var_13_60 = false

						if var_13_24 then
							if var_13_23.screen_clamp_method == "tutorial" then
								local var_13_61 = Vector3.normalize(Vector3.flat(var_13_9))
								local var_13_62 = Vector3.normalize(Vector3.flat(var_13_48))
								local var_13_63 = Vector3.dot(var_13_61, var_13_62)
								local var_13_64 = Vector3.dot(var_13_13, var_13_62)

								var_13_35.forward_dot_flat = var_13_63
								var_13_35.right_dot_flat = var_13_64

								local var_13_65
								local var_13_66
								local var_13_67, var_13_68

								var_13_67, var_13_68, var_13_60 = arg_13_0:_tutorial_clamp_to_screen(var_13_57, var_13_58, var_13_63, var_13_64, var_13_23)

								local var_13_69 = var_13_35._lerp_speed

								if not var_13_69 or var_13_60 ~= var_13_35.is_clamped then
									var_13_69 = 0
								end

								local var_13_70 = math.min(var_13_69 + arg_13_1, 1)
								local var_13_71 = var_13_34.offset

								var_13_57 = math.lerp(var_13_71[1], var_13_67, var_13_70)
								var_13_58 = math.lerp(var_13_71[2], var_13_68, var_13_70)
								var_13_35._lerp_speed = var_13_70
							else
								var_13_57, var_13_58, var_13_60 = arg_13_0:_normal_clamp_to_screen(var_13_57, var_13_58, var_13_27, var_13_55, var_13_56, var_13_36, var_13_15, var_13_18, var_13_17, var_13_19, var_13_20)
							end
						end

						if not var_13_60 then
							if var_13_25 or var_13_55 and not var_13_26 then
								var_13_47 = false
							elseif not var_13_51 then
								local var_13_72 = UISceneGraph.get_size_scaled(var_13_4, "root")
								local var_13_73
								local var_13_74

								if var_13_57 < 0 then
									var_13_74 = math.abs(var_13_57)
								elseif var_13_57 > var_13_72[1] then
									var_13_74 = var_13_57 - var_13_72[1]
								end

								if var_13_58 < 0 then
									var_13_73 = math.abs(var_13_58)
								elseif var_13_58 > var_13_72[2] then
									var_13_73 = var_13_58 - var_13_72[2]
								end

								if var_13_73 or var_13_74 then
									var_13_47 = false

									local var_13_75 = var_13_23.check_widget_visible

									if var_13_75 then
										var_13_47 = var_13_75(var_13_34, var_13_73, var_13_74)
									end
								else
									var_13_47 = false
								end
							end
						end

						var_13_35.is_inside_frustum = var_13_51
						var_13_35.is_clamped = var_13_60
						var_13_35.is_under = var_13_56
						var_13_35.distance = var_13_44
						var_13_35.angle = var_13_54

						local var_13_76 = var_13_34.offset

						var_13_76[1] = var_13_57
						var_13_76[2] = var_13_58

						if var_13_47 and var_13_30 then
							var_13_31.raycast_frame_count = (var_13_31.raycast_frame_count or 0) + 1

							if var_13_1 then
								var_0_1[#var_0_1 + 1] = var_13_31
							end
						end
					end

					var_13_31.draw = var_13_47
					var_13_35.do_update = not var_13_45
				end
			end
		end

		if var_13_1 then
			local var_13_77 = #var_0_1

			if var_13_77 > 1 then
				table.sort(var_0_1, var_0_4)
			end

			for iter_13_3 = 1, var_13_77 do
				if iter_13_3 > var_0_2 then
					break
				end

				local var_13_78 = var_0_1[iter_13_3]

				var_13_78.raycast_result, var_13_78.raycast_frame_count = arg_13_0:_raycast_marker(var_13_78), 0
			end

			table.clear(var_0_1)
		end

		local var_13_79 = not ScriptUnit.has_extension(var_13_0, "status_system"):get_is_aiming()
		local var_13_80 = math.max(0.25, UIUtils.animate_value(arg_13_0._aiming_alpha_multiplier, arg_13_1 * 5, var_13_79))

		arg_13_0._aiming_alpha_multiplier = var_13_80

		UIRenderer.begin_pass(var_13_3, var_13_4, var_13_5, arg_13_1, nil, var_13_6)

		for iter_13_4, iter_13_5 in pairs(var_13_22) do
			local var_13_81 = WorldMarkerTemplates[iter_13_4]

			for iter_13_6 = 1, #iter_13_5 do
				local var_13_82 = iter_13_5[iter_13_6]
				local var_13_83 = var_13_82.widget
				local var_13_84 = var_13_83.content
				local var_13_85 = var_13_84.distance
				local var_13_86 = var_13_82.draw
				local var_13_87 = false
				local var_13_88 = var_13_81.scale_settings
				local var_13_89 = var_13_81.update_function

				if var_13_84.do_update and var_13_89 then
					var_13_87 = var_13_89(var_13_3, var_13_83, var_13_82, var_13_81, arg_13_1, arg_13_2)
				end

				if not var_13_87 and var_13_88 then
					local var_13_90 = arg_13_0:_get_scale(var_13_88, var_13_85)

					arg_13_0:_apply_scale(var_13_83, var_13_90)
				end

				if var_13_86 then
					local var_13_91 = var_13_83.alpha_multiplier or 1

					if not var_13_81.ignore_aiming then
						var_13_91 = var_13_91 * var_13_80
					end

					var_13_6.alpha_multiplier = var_13_91

					UIRenderer.draw_widget(var_13_3, var_13_83)
				end
			end
		end

		UIRenderer.end_pass(var_13_3)
	else
		local var_13_92 = "player_1"
		local var_13_93 = arg_13_0._game_world

		if Managers.state.camera:has_viewport(var_13_92) then
			local var_13_94 = ScriptWorld.viewport(var_13_93, var_13_92)

			arg_13_0._camera = ScriptViewport.camera(var_13_94)
		end
	end

	local var_13_95 = #var_0_0

	if var_13_95 > 0 then
		for iter_13_7 = 1, var_13_95 do
			local var_13_96 = var_0_0[iter_13_7]

			arg_13_0:_unregister_marker(var_13_96)
		end

		table.clear(var_0_0)
	end
end

WorldMarkerUI._raycast_marker = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1.widget.content
	local var_14_1 = arg_14_1.position
	local var_14_2 = var_14_0.distance
	local var_14_3 = Managers.world
	local var_14_4 = "level_world"

	if not var_14_3:has_world(var_14_4) then
		return
	end

	local var_14_5 = var_14_3:world(var_14_4)
	local var_14_6 = World.get_data(var_14_5, "physics_world")
	local var_14_7 = arg_14_0._camera
	local var_14_8 = Camera.local_position(var_14_7)
	local var_14_9 = Camera.local_rotation(var_14_7)

	return PhysicsWorld.immediate_raycast(var_14_6, var_14_8, Vector3.normalize(var_14_1 - var_14_8), var_14_2, "closest", "collision_filter", "filter_physics_projectile")
end

WorldMarkerUI._get_scale = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_1.min_scale
	local var_15_1 = arg_15_1.start_scale_distance
	local var_15_2 = arg_15_1.end_scale_distance

	if var_15_1 < arg_15_2 then
		local var_15_3 = arg_15_2 - var_15_1
		local var_15_4 = math.min(var_15_2, var_15_3)
		local var_15_5 = math.max(0, var_15_4)

		return (math.max(var_15_0, 1 - var_15_5 / var_15_2))
	end

	return 1
end

WorldMarkerUI._apply_scale = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1.style

	arg_16_1.content.scale = arg_16_2

	local var_16_1 = 0.2

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		local var_16_2 = iter_16_1.default_size

		if var_16_2 then
			local var_16_3 = iter_16_1.area_size or iter_16_1.texture_size or iter_16_1.size

			var_16_3[1] = math.lerp(var_16_3[1], var_16_2[1] * arg_16_2, var_16_1)
			var_16_3[2] = math.lerp(var_16_3[2], var_16_2[2] * arg_16_2, var_16_1)
		end

		local var_16_4 = iter_16_1.animation_offset or iter_16_1.default_offset

		if var_16_4 then
			local var_16_5 = iter_16_1.offset

			var_16_5[1] = math.lerp(var_16_5[1], var_16_4[1] * arg_16_2, var_16_1)
			var_16_5[2] = math.lerp(var_16_5[2], var_16_4[2] * arg_16_2, var_16_1)

			local var_16_6 = iter_16_1.offset
		end
	end
end

WorldMarkerUI._convert_world_to_screen_position = function (arg_17_0, arg_17_1, arg_17_2)
	if arg_17_1 then
		local var_17_0, var_17_1 = Camera.world_to_screen(arg_17_1, arg_17_2)
		local var_17_2 = RESOLUTION_LOOKUP.inv_scale

		return var_17_0.x * var_17_2, var_17_0.y * var_17_2, var_17_1
	end
end

WorldMarkerUI._normal_clamp_to_screen = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9, arg_18_10, arg_18_11)
	local var_18_0 = UISceneGraph.get_size_scaled(arg_18_0.ui_scenegraph, "root")
	local var_18_1 = arg_18_3 and arg_18_3.up or 0
	local var_18_2 = arg_18_3 and arg_18_3.down or 0
	local var_18_3 = arg_18_3 and arg_18_3.left or 0
	local var_18_4 = arg_18_3 and arg_18_3.right or 0
	local var_18_5 = math.max(var_18_3, math.min(arg_18_1, var_18_0[1] - var_18_4))
	local var_18_6 = math.max(var_18_2, math.min(arg_18_2, var_18_0[2] - var_18_1))
	local var_18_7 = var_18_5 ~= arg_18_1 or var_18_6 ~= arg_18_2 or arg_18_4

	if arg_18_4 then
		local var_18_8 = Vector3.distance(Vector3.flat(arg_18_6), Vector3.flat(arg_18_7 + arg_18_8))
		local var_18_9 = Vector3.distance(Vector3.flat(arg_18_6), Vector3.flat(arg_18_7 + arg_18_9))
		local var_18_10 = var_18_8 - var_18_9
		local var_18_11 = math.abs(var_18_10) / 2
		local var_18_12 = Vector3.distance(Vector3.flat(arg_18_6), Vector3.flat(arg_18_7 + arg_18_10))
		local var_18_13 = Vector3.distance(Vector3.flat(arg_18_6), Vector3.flat(arg_18_7 + arg_18_11))
		local var_18_14 = (var_18_12 - var_18_13) / 2
		local var_18_15 = math.abs(var_18_14) / 1 - 1

		if var_18_8 < var_18_9 then
			var_18_5 = math.lerp(var_18_3, (var_18_0[1] - var_18_4) * 0.5, 1 - var_18_11)
		else
			var_18_5 = math.lerp((var_18_0[1] - var_18_4) * 0.5, var_18_0[1] - var_18_4, var_18_11)
		end

		if var_18_12 < var_18_13 then
			var_18_6 = math.lerp(var_18_2, (var_18_0[2] - var_18_1) * 0.5, 1 - var_18_15)
		else
			var_18_6 = math.lerp((var_18_0[2] - var_18_1) * 0.5, var_18_0[2] - var_18_1, var_18_15)
		end

		if arg_18_5 then
			var_18_6 = var_18_6 * -1
		end

		if var_18_3 <= var_18_5 or var_18_5 <= var_18_0[2] - var_18_4 then
			if var_18_6 > var_18_0[2] / 2 or not arg_18_5 then
				var_18_6 = var_18_0[2] - var_18_1
			else
				var_18_6 = var_18_2
			end
		end
	end

	return var_18_5, var_18_6, var_18_7
end

WorldMarkerUI._is_clamped = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = UISceneGraph.get_size_scaled(arg_19_0.ui_scenegraph, "root")
	local var_19_1 = RESOLUTION_LOOKUP.scale
	local var_19_2 = var_19_0[1] * var_19_1
	local var_19_3 = var_19_0[2] * var_19_1
	local var_19_4 = var_19_0[1] * 0.5
	local var_19_5 = var_19_0[2] * 0.5
	local var_19_6 = RESOLUTION_LOOKUP.res_w
	local var_19_7 = RESOLUTION_LOOKUP.res_h
	local var_19_8 = var_19_6 * 0.5
	local var_19_9 = var_19_7 * 0.5
	local var_19_10 = arg_19_1 - var_19_8
	local var_19_11 = var_19_9 - arg_19_2
	local var_19_12 = false
	local var_19_13 = false

	if math.abs(var_19_10) > var_19_4 * 0.9 then
		var_19_12 = true
	end

	if math.abs(var_19_11) > var_19_5 * 0.9 then
		var_19_13 = true
	end

	return (var_19_12 or var_19_13) and true or false
end

WorldMarkerUI._tutorial_clamp_to_screen = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = RESOLUTION_LOOKUP
	local var_20_1 = var_20_0.scale
	local var_20_2 = var_20_0.res_w * 0.5
	local var_20_3 = var_20_0.res_h * 0.5
	local var_20_4 = math.abs(arg_20_1 * var_20_1 - var_20_2) > var_20_2 * 0.9
	local var_20_5 = math.abs(var_20_3 - arg_20_2 * var_20_1) > var_20_3 * 0.9
	local var_20_6 = var_20_4 or var_20_5 or arg_20_3 < 0

	if var_20_6 then
		local var_20_7 = var_20_0.inv_scale
		local var_20_8 = arg_20_5.distance_from_center

		arg_20_1 = var_20_7 * var_20_2 + arg_20_4 * var_20_8.width
		arg_20_2 = var_20_7 * var_20_3 + arg_20_3 * var_20_8.height
	end

	return arg_20_1, arg_20_2, var_20_6
end

local var_0_7 = 1
local var_0_8 = 2
local var_0_9 = 3
local var_0_10 = 4

WorldMarkerUI._test_raycast = function (arg_21_0)
	local var_21_0 = arg_21_0.local_player.player_unit

	if not Unit.alive(var_21_0) then
		return
	end

	local var_21_1 = "ping"

	if arg_21_0.input_manager:get_service("Player"):get(var_21_1) then
		arg_21_0._broadphase = Broadphase(255, 15)
		arg_21_0._broadphase_ids = {}

		local var_21_2 = "climbing"
		local var_21_3 = Managers.state.entity:system("nav_graph_system"):level_jump_units()
		local var_21_4 = 0

		for iter_21_0, iter_21_1 in pairs(var_21_3) do
			if Unit.alive(iter_21_0) then
				local var_21_5 = Unit.world_position(iter_21_0, 0)
				local var_21_6 = Broadphase.add(arg_21_0._broadphase, iter_21_0, var_21_5, 1)

				arg_21_0._broadphase_ids[var_21_6] = iter_21_0
				var_21_4 = var_21_4 + 1
			end
		end

		local var_21_7 = arg_21_0._camera
		local var_21_8 = Camera.local_position(var_21_7)
		local var_21_9 = {}
		local var_21_10 = Broadphase.query(arg_21_0._broadphase, var_21_8, 10, var_21_9)

		print("num_hits", var_21_10, var_21_4)

		for iter_21_2 = 1, var_21_10 do
			local var_21_11 = var_21_9[iter_21_2]

			arg_21_0:event_add_world_marker_unit(var_21_2, var_21_11)
		end
	end
end

WorldMarkerUI._get_raycast_position = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	local var_22_0 = PhysicsWorld.immediate_raycast(arg_22_4, arg_22_2, arg_22_3, 100, "all", "collision_filter", arg_22_5)

	if not var_22_0 then
		return
	end

	local var_22_1 = math.huge
	local var_22_2
	local var_22_3 = arg_22_0.owner_unit
	local var_22_4 = #var_22_0

	for iter_22_0 = 1, var_22_4 do
		local var_22_5 = var_22_0[iter_22_0]
		local var_22_6 = var_22_5[var_0_7]
		local var_22_7 = var_22_5[var_0_8]
		local var_22_8 = var_22_5[var_0_9]
		local var_22_9 = var_22_5[var_0_10]
		local var_22_10 = Actor.unit(var_22_9)

		if not (var_22_10 == arg_22_1 or var_22_10 == var_22_3) and var_22_7 < var_22_1 then
			var_22_1 = var_22_7
			var_22_2 = var_22_5
		end
	end

	if var_22_2 then
		return var_22_2[var_0_7]
	end
end
