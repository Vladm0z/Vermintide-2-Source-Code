-- chunkname: @scripts/ui/hud_ui/world_marker_ui.lua

require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_ping")
require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_text_box")
require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_news_feed")
require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_store")
require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_pet_nameplate")
require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_pet_cancel")

local tbl = {}
local tbl_2 = {}
local num = 1
local num_2 = 5

local function fn(self, arg_1_1)
	-- function 1
	local raycast_frame_count = self.raycast_frame_count

	raycast_frame_count = raycast_frame_count or 0

	local raycast_frame_count_2 = arg_1_1.raycast_frame_count

	raycast_frame_count_2 = raycast_frame_count_2 or 0

	if raycast_frame_count == raycast_frame_count_2 then
		local distance = self.widget.content.distance

		distance = distance or 0

		local distance_2 = arg_1_1.widget.content.distance

		distance_2 = distance_2 or 0

		return distance < distance_2
	end

	return raycast_frame_count_2 < raycast_frame_count
end

DLCUtils.require_list("ui_world_marker_templates")

local tbl_3 = {
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
local str = "ping"

WorldMarkerUI = class(WorldMarkerUI)

WorldMarkerUI.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._parent = arg_2_1
	self.ui_renderer = arg_2_2.ui_renderer
	self.ingame_ui = arg_2_2.ingame_ui
	self.input_manager = arg_2_2.input_manager
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	self._raycast_frame_counter = 0
	self._aiming_alpha_multiplier = 1
	self._game_world = arg_2_2.world_manager:world("level_world")
	self.local_player = arg_2_2.player

	self:_create_ui_elements()

	local event = Managers.state.event

	event:register(self, "add_world_marker_unit", "event_add_world_marker_unit")
	event:register(self, "add_world_marker_position", "event_add_world_marker_position")
	event:register(self, "remove_world_marker", "event_remove_world_marker")
	event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
end

WorldMarkerUI.destroy = function (arg_3_0)
	-- function 3
	local event = Managers.state.event

	event:unregister("add_world_marker_unit", arg_3_0)
	event:unregister("add_world_marker_position", arg_3_0)
	event:unregister("remove_world_marker", arg_3_0)
	event:unregister("on_spectator_target_changed", arg_3_0)
end

WorldMarkerUI._create_ui_elements = function (self)
	-- function 4
	self._id_counter = 0
	self._markers = {}
	self._markers_by_id = {}
	self._markers_by_type = {}
	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl_3)

	local tbl = {}

	self._widget_definitions_by_type = tbl

	for k, v in pairs(WorldMarkerTemplates) do
		tbl[k] = v.create_widget_definition("pivot")
	end
end

WorldMarkerUI.event_remove_world_marker = function (self, arg_5_1)
	-- function 5
	local var_5_0
	local _markers = self._markers

	for i = 1, #_markers do
		local var_5_2 = _markers[i]

		if var_5_2.id == arg_5_1 then
			var_5_0 = var_5_2

			break
		end
	end

	if not var_5_0 then
		self:_unregister_marker(var_5_0)
	end
end

WorldMarkerUI.event_add_world_marker_unit = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local _create_widget_by_type = self:_create_widget_by_type(arg_6_1)
	local _register_marker = self:_register_marker({
		type = arg_6_1,
		unit = arg_6_2,
		widget = _create_widget_by_type
	})
	local on_enter = WorldMarkerTemplates[arg_6_1].on_enter

	if not on_enter then
		on_enter(_create_widget_by_type)
	end

	if not arg_6_3 then
		arg_6_3(_register_marker, _create_widget_by_type)
	end
end

WorldMarkerUI.event_add_world_marker_position = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local _create_widget_by_type = self:_create_widget_by_type(arg_7_1)
	local tbl = {
		type = arg_7_1,
		world_position = Vector3Box(arg_7_2),
		widget = _create_widget_by_type
	}
	local _register_marker = self:_register_marker(tbl)
	local on_enter = WorldMarkerTemplates[arg_7_1].on_enter

	if not on_enter then
		on_enter(_create_widget_by_type)
	end

	if not arg_7_3 then
		arg_7_3(_register_marker, _create_widget_by_type)
	end
end

WorldMarkerUI.on_spectator_target_changed = function (self, arg_8_1)
	-- function 8
	self._spectated_player_unit = arg_8_1
	self._spectated_player = Managers.player:owner(arg_8_1)
	self._is_spectator = true
	self.local_player = self._spectated_player
end

WorldMarkerUI._register_marker = function (self, arg_9_1)
	-- function 9
	local _markers = self._markers
	local _markers_by_id = self._markers_by_id
	local _markers_by_type = self._markers_by_type

	self._id_counter = self._id_counter + 1

	local _id_counter = self._id_counter

	arg_9_1.id = _id_counter
	_markers_by_id[_id_counter] = arg_9_1
	_markers[#_markers + 1] = arg_9_1

	local type = arg_9_1.type
	local var_9_5 = _markers_by_type[type]

	var_9_5 = var_9_5 or {}
	_markers_by_type[type] = var_9_5
	var_9_5[#var_9_5 + 1] = arg_9_1

	return _id_counter
end

WorldMarkerUI._unregister_marker = function (self, arg_10_1)
	-- function 10
	local _markers = self._markers
	local _markers_by_id = self._markers_by_id
	local _markers_by_type = self._markers_by_type
	local id = arg_10_1.id

	_markers_by_id[id] = nil

	for i = 1, #_markers do
		if _markers[i].id == id then
			table.remove(_markers, i)

			break
		end
	end

	local var_10_4 = _markers_by_type[arg_10_1.type]

	for j = 1, #var_10_4 do
		if var_10_4[j].id == id then
			table.remove(var_10_4, j)

			break
		end
	end
end

WorldMarkerUI._create_widget_by_type = function (self, arg_11_1)
	-- function 11
	local var_11_0 = self._widget_definitions_by_type[arg_11_1]

	return UIWidget.init(var_11_0)
end

WorldMarkerUI.update = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	return
end

WorldMarkerUI.post_update = function (self, arg_13_1, arg_13_2)
	-- function 13
	local player_unit = self.local_player.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	local flag = self._raycast_frame_counter == 0

	self._raycast_frame_counter = (self._raycast_frame_counter + 1) % num_2

	local _camera = self._camera

	if not _camera then
		local ui_renderer = self.ui_renderer
		local ui_scenegraph = self.ui_scenegraph
		local get_service = self.input_manager:get_service("Player")
		local _render_settings = self._render_settings
		local local_position = Camera.local_position(_camera)
		local local_rotation = Camera.local_rotation(_camera)
		local forward = Quaternion.forward(local_rotation)
		local forward_2 = Quaternion.forward(local_rotation)
		local up = Quaternion.up(local_rotation)
		local right = Quaternion.right(local_rotation)
		local normalize = Vector3.normalize(Vector3.flat(right))
		local near_range = Camera.near_range(_camera)
		local num_3 = local_position + forward
		local local_pose = Camera.local_pose(_camera)
		local right_2 = Matrix4x4.right(local_pose)
		local num_4 = -right_2
		local up_2 = Matrix4x4.up(local_pose)
		local num_5 = -up_2
		local _markers_by_id = self._markers_by_id
		local _markers_by_type = self._markers_by_type

		for k, v in pairs(_markers_by_type) do
			local var_13_23 = WorldMarkerTemplates[k]
			local screen_clamp = var_13_23.screen_clamp
			local only_when_clamped = var_13_23.only_when_clamped
			local draw_behind = var_13_23.draw_behind
			local screen_margins = var_13_23.screen_margins
			local max_distance = var_13_23.max_distance
			local life_time = var_13_23.life_time
			local check_line_of_sight = var_13_23.check_line_of_sight

			for k_2 = 1, #v do
				local var_13_31 = v[k_2]
				local flag_2 = _markers_by_id[var_13_31.id] ~= nil
				local flag_3 = false
				local widget = var_13_31.widget
				local content = widget.content
				local var_13_36

				if not flag_2 then
					local world_position = var_13_31.world_position

					if not world_position then
						var_13_36 = world_position:unbox()
					else
						local unit = var_13_31.unit

						if not Unit.alive(unit) then
							local unit_node = var_13_23.unit_node
							local node

							if not unit_node then
								node = Unit.node(unit, unit_node)

								if not node then
									-- Nothing
								end
							end

							node = 0

							::label_13_0::

							var_13_36 = Unit.world_position(unit, node)
						else
							flag_3 = true
						end
					end

					if not life_time then
						local duration = var_13_31.duration

						duration = duration or 0

						local min = math.min(duration + arg_13_1, life_time)

						if life_time <= min then
							flag_3 = true
						else
							var_13_31.duration = min
						end
					end
				end

				if not flag_3 then
					flag_2 = false
					tbl[#tbl + 1] = var_13_31
				end

				if not flag_2 then
					local position_offset = var_13_23.position_offset

					if not position_offset then
						var_13_36.x = var_13_36.x + position_offset[1]
						var_13_36.y = var_13_36.y + position_offset[2]
						var_13_36.z = var_13_36.z + position_offset[3]
					end

					var_13_31.position = var_13_36

					local distance = Vector3.distance(var_13_36, local_position)

					content.distance = distance

					local flag_4 = not max_distance and max_distance < distance
					local flag_5 = false
					local flag_6 = not flag_4

					if not flag_4 then
						local normalize_2 = Vector3.normalize(var_13_36 - local_position)
						local dot = Vector3.dot(forward_2, normalize_2)
						local dot_2 = Vector3.dot(normalize, normalize_2)

						content.forward_dot_dir = dot

						local flag_7 = Camera.inside_frustum(_camera, var_13_36) > 0
						local cross = Vector3.cross(forward_2, Vector3.up())
						local dot_3 = Vector3.dot(cross, normalize_2)
						local atan2 = math.atan2(dot_3, dot)
						local flag_8

						flag_8 = not (dot < 0) or not true or false

						local flag_9 = var_13_36.z < local_position.z
						local _convert_world_to_screen_position, var_13_58, var_13_59 = self:_convert_world_to_screen_position(_camera, var_13_36)
						local flag_10 = false

						if not screen_clamp then
							if var_13_23.screen_clamp_method == "tutorial" then
								local normalize_3 = Vector3.normalize(Vector3.flat(forward))
								local normalize_4 = Vector3.normalize(Vector3.flat(normalize_2))
								local dot_4 = Vector3.dot(normalize_3, normalize_4)
								local dot_5 = Vector3.dot(normalize, normalize_4)

								content.forward_dot_flat = dot_4
								content.right_dot_flat = dot_5

								local var_13_65
								local var_13_66
								local _tutorial_clamp_to_screen, var_13_68

								_tutorial_clamp_to_screen, var_13_68, flag_10 = self:_tutorial_clamp_to_screen(_convert_world_to_screen_position, var_13_58, dot_4, dot_5, var_13_23)

								local _lerp_speed = content._lerp_speed

								if not (not _lerp_speed and flag_10 == content.is_clamped) then
									_lerp_speed = 0
								end

								local min_2 = math.min(_lerp_speed + arg_13_1, 1)
								local offset = widget.offset

								_convert_world_to_screen_position = math.lerp(offset[1], _tutorial_clamp_to_screen, min_2)
								var_13_58 = math.lerp(offset[2], var_13_68, min_2)
								content._lerp_speed = min_2
							else
								_convert_world_to_screen_position, var_13_58, flag_10 = self:_normal_clamp_to_screen(_convert_world_to_screen_position, var_13_58, screen_margins, flag_8, flag_9, var_13_36, num_3, num_4, right_2, up_2, num_5)
							end
						end

						if not flag_10 then
							if not ((only_when_clamped or not flag_8) and draw_behind) then
								flag_6 = false
							elseif not flag_7 then
								local get_size_scaled = UISceneGraph.get_size_scaled(ui_scenegraph, "root")
								local var_13_73
								local var_13_74

								if _convert_world_to_screen_position < 0 then
									var_13_74 = math.abs(_convert_world_to_screen_position)
								elseif _convert_world_to_screen_position > get_size_scaled[1] then
									var_13_74 = _convert_world_to_screen_position - get_size_scaled[1]
								end

								if var_13_58 < 0 then
									var_13_73 = math.abs(var_13_58)
								elseif var_13_58 > get_size_scaled[2] then
									var_13_73 = var_13_58 - get_size_scaled[2]
								end

								if var_13_73 or not var_13_74 then
									flag_6 = false

									local check_widget_visible = var_13_23.check_widget_visible

									if not check_widget_visible then
										flag_6 = check_widget_visible(widget, var_13_73, var_13_74)
									end
								else
									flag_6 = false
								end
							end
						end

						content.is_inside_frustum = flag_7
						content.is_clamped = flag_10
						content.is_under = flag_9
						content.distance = distance
						content.angle = atan2

						local offset_2 = widget.offset

						offset_2[1] = _convert_world_to_screen_position
						offset_2[2] = var_13_58

						if not flag_6 and not check_line_of_sight then
							local raycast_frame_count = var_13_31.raycast_frame_count

							raycast_frame_count = raycast_frame_count or 0
							var_13_31.raycast_frame_count = raycast_frame_count + 1

							if not flag then
								tbl_2[#tbl_2 + 1] = var_13_31
							end
						end
					end

					var_13_31.draw = flag_6
					content.do_update = not flag_4
				end
			end
		end

		if not flag then
			local count = #tbl_2

			if count > 1 then
				table.sort(tbl_2, fn)
			end

			for l = 1, count do
				if l > num then
					break
				end

				local var_13_79 = tbl_2[l]

				var_13_79.raycast_result, var_13_79.raycast_frame_count = self:_raycast_marker(var_13_79), 0
			end

			table.clear(tbl_2)
		end

		local flag_11 = not ScriptUnit.has_extension(player_unit, "status_system"):get_is_aiming()
		local max = math.max(0.25, UIUtils.animate_value(self._aiming_alpha_multiplier, arg_13_1 * 5, flag_11))

		self._aiming_alpha_multiplier = max

		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_13_1, nil, _render_settings)

		for k_3, v_2 in pairs(_markers_by_type) do
			local var_13_82 = WorldMarkerTemplates[k_3]

			for i6 = 1, #v_2 do
				local var_13_83 = v_2[i6]
				local widget_2 = var_13_83.widget
				local content_2 = widget_2.content
				local distance_2 = content_2.distance
				local draw = var_13_83.draw
				local flag_12 = false
				local scale_settings = var_13_82.scale_settings
				local update_function = var_13_82.update_function

				if not content_2.do_update and not update_function then
					flag_12 = update_function(ui_renderer, widget_2, var_13_83, var_13_82, arg_13_1, arg_13_2)
				end

				if flag_12 or not scale_settings then
					local _get_scale = self:_get_scale(scale_settings, distance_2)

					self:_apply_scale(widget_2, _get_scale)
				end

				if not draw then
					local alpha_multiplier = widget_2.alpha_multiplier

					alpha_multiplier = alpha_multiplier or 1

					if not var_13_82.ignore_aiming then
						alpha_multiplier = alpha_multiplier * max
					end

					_render_settings.alpha_multiplier = alpha_multiplier

					UIRenderer.draw_widget(ui_renderer, widget_2)
				end
			end
		end

		UIRenderer.end_pass(ui_renderer)
	else
		local str = "player_1"
		local _game_world = self._game_world

		if not Managers.state.camera:has_viewport(str) then
			local viewport = ScriptWorld.viewport(_game_world, str)

			self._camera = ScriptViewport.camera(viewport)
		end
	end

	local count_2 = #tbl

	if count_2 > 0 then
		for i7 = 1, count_2 do
			local var_13_97 = tbl[i7]

			self:_unregister_marker(var_13_97)
		end

		table.clear(tbl)
	end
end

WorldMarkerUI._raycast_marker = function (self, arg_14_1)
	-- function 14
	local content = arg_14_1.widget.content
	local position = arg_14_1.position
	local distance = content.distance
	local world = Managers.world
	local str = "level_world"

	if not world:has_world(str) then
		return
	end

	local world_2 = world:world(str)
	local get_data = World.get_data(world_2, "physics_world")
	local _camera = self._camera
	local local_position = Camera.local_position(_camera)
	local local_rotation = Camera.local_rotation(_camera)

	return PhysicsWorld.immediate_raycast(get_data, local_position, Vector3.normalize(position - local_position), distance, "closest", "collision_filter", "filter_physics_projectile")
end

WorldMarkerUI._get_scale = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local min_scale = arg_15_1.min_scale
	local start_scale_distance = arg_15_1.start_scale_distance
	local end_scale_distance = arg_15_1.end_scale_distance

	if start_scale_distance < arg_15_2 then
		local num = arg_15_2 - start_scale_distance
		local min = math.min(end_scale_distance, num)
		local max = math.max(0, min)

		return (math.max(min_scale, 1 - max / end_scale_distance))
	end

	return 1
end

WorldMarkerUI._apply_scale = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local style = arg_16_1.style

	arg_16_1.content.scale = arg_16_2

	local num = 0.2

	for k, v in pairs(style) do
		local default_size = v.default_size

		if not default_size then
			local area_size = v.area_size

			if not area_size then
				area_size = v.texture_size
				area_size = area_size or v.size
			end

			area_size[1] = math.lerp(area_size[1], default_size[1] * arg_16_2, num)
			area_size[2] = math.lerp(area_size[2], default_size[2] * arg_16_2, num)
		end

		local animation_offset = v.animation_offset

		animation_offset = animation_offset or v.default_offset

		if not animation_offset then
			local offset = v.offset

			offset[1] = math.lerp(offset[1], animation_offset[1] * arg_16_2, num)
			offset[2] = math.lerp(offset[2], animation_offset[2] * arg_16_2, num)

			local offset_2 = v.offset
		end
	end
end

WorldMarkerUI._convert_world_to_screen_position = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	if not arg_17_1 then
		local world_to_screen, var_17_1 = Camera.world_to_screen(arg_17_1, arg_17_2)
		local inv_scale = RESOLUTION_LOOKUP.inv_scale

		return world_to_screen.x * inv_scale, world_to_screen.y * inv_scale, var_17_1
	end
end

WorldMarkerUI._normal_clamp_to_screen = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9, arg_18_10, arg_18_11)
	-- function 18
	local get_size_scaled = UISceneGraph.get_size_scaled(self.ui_scenegraph, "root")
	local up

	if not arg_18_3 then
		up = arg_18_3.up

		if not up then
			-- Nothing
		end
	end

	up = 0

	do
		local down
	end

	::label_18_0::

	if not arg_18_3 then
		down = arg_18_3.down

		if not down then
			-- Nothing
		end
	end

	down = 0

	do
		local left
	end

	::label_18_1::

	if not arg_18_3 then
		left = arg_18_3.left

		if not left then
			-- Nothing
		end
	end

	left = 0

	do
		local right
	end

	::label_18_2::

	if not arg_18_3 then
		right = arg_18_3.right

		if not right then
			-- Nothing
		end
	end

	right = 0

	::label_18_3::

	local max = math.max(left, math.min(arg_18_1, get_size_scaled[1] - right))
	local max_2 = math.max(down, math.min(arg_18_2, get_size_scaled[2] - up))
	local flag = max ~= arg_18_1 or max_2 ~= arg_18_2 or arg_18_4

	if not arg_18_4 then
		local distance = Vector3.distance(Vector3.flat(arg_18_6), Vector3.flat(arg_18_7 + arg_18_8))
		local distance_2 = Vector3.distance(Vector3.flat(arg_18_6), Vector3.flat(arg_18_7 + arg_18_9))
		local num = distance - distance_2
		local num_2 = math.abs(num) / 2
		local distance_3 = Vector3.distance(Vector3.flat(arg_18_6), Vector3.flat(arg_18_7 + arg_18_10))
		local distance_4 = Vector3.distance(Vector3.flat(arg_18_6), Vector3.flat(arg_18_7 + arg_18_11))
		local num_3 = (distance_3 - distance_4) / 2
		local num_4 = math.abs(num_3) / 1 - 1

		if distance < distance_2 then
			max = math.lerp(left, (get_size_scaled[1] - right) * 0.5, 1 - num_2)
		else
			max = math.lerp((get_size_scaled[1] - right) * 0.5, get_size_scaled[1] - right, num_2)
		end

		if distance_3 < distance_4 then
			max_2 = math.lerp(down, (get_size_scaled[2] - up) * 0.5, 1 - num_4)
		else
			max_2 = math.lerp((get_size_scaled[2] - up) * 0.5, get_size_scaled[2] - up, num_4)
		end

		if not arg_18_5 then
			max_2 = max_2 * -1
		end

		if not (left <= max or not (max <= get_size_scaled[2] - right)) then
			if not (max_2 > get_size_scaled[2] / 2 or arg_18_5) then
				max_2 = get_size_scaled[2] - up
			else
				max_2 = down
			end
		end
	end

	return max, max_2, flag
end

WorldMarkerUI._is_clamped = function (self, arg_19_1, arg_19_2)
	-- function 19
	local get_size_scaled = UISceneGraph.get_size_scaled(self.ui_scenegraph, "root")
	local scale = RESOLUTION_LOOKUP.scale
	local num = get_size_scaled[1] * scale
	local num_2 = get_size_scaled[2] * scale
	local num_3 = get_size_scaled[1] * 0.5
	local num_4 = get_size_scaled[2] * 0.5
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num_5 = res_w * 0.5
	local num_6 = res_h * 0.5
	local num_7 = arg_19_1 - num_5
	local num_8 = num_6 - arg_19_2
	local flag = false
	local flag_2 = false

	if math.abs(num_7) > num_3 * 0.9 then
		flag = true
	end

	if math.abs(num_8) > num_4 * 0.9 then
		flag_2 = true
	end

	local flag_3

	flag_3 = flag or not flag_2 or true or false

	return flag_3
end

WorldMarkerUI._tutorial_clamp_to_screen = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local RESOLUTION_LOOKUP = RESOLUTION_LOOKUP
	local scale = RESOLUTION_LOOKUP.scale
	local num = RESOLUTION_LOOKUP.res_w * 0.5
	local num_2 = RESOLUTION_LOOKUP.res_h * 0.5
	local flag = math.abs(arg_20_1 * scale - num) > num * 0.9
	local flag_2 = math.abs(num_2 - arg_20_2 * scale) > num_2 * 0.9
	local flag_3 = flag or flag_2 or arg_20_3 < 0

	if not flag_3 then
		local inv_scale = RESOLUTION_LOOKUP.inv_scale
		local distance_from_center = arg_20_5.distance_from_center

		arg_20_1 = inv_scale * num + arg_20_4 * distance_from_center.width
		arg_20_2 = inv_scale * num_2 + arg_20_3 * distance_from_center.height
	end

	return arg_20_1, arg_20_2, flag_3
end

local num_3 = 1
local num_4 = 2
local num_5 = 3
local num_6 = 4

WorldMarkerUI._test_raycast = function (self)
	-- function 21
	local player_unit = self.local_player.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	local str = "ping"

	if not self.input_manager:get_service("Player"):get(str) then
		self._broadphase = Broadphase(255, 15)
		self._broadphase_ids = {}

		local str_2 = "climbing"
		local level_jump_units = Managers.state.entity:system("nav_graph_system"):level_jump_units()
		local num = 0

		for k, v in pairs(level_jump_units) do
			if not Unit.alive(k) then
				local world_position = Unit.world_position(k, 0)
				local add = Broadphase.add(self._broadphase, k, world_position, 1)

				self._broadphase_ids[add] = k
				num = num + 1
			end
		end

		local _camera = self._camera
		local local_position = Camera.local_position(_camera)
		local tbl = {}
		local query = Broadphase.query(self._broadphase, local_position, 10, tbl)

		print("num_hits", query, num)

		for k_2 = 1, query do
			local var_21_11 = tbl[k_2]

			self:event_add_world_marker_unit(str_2, var_21_11)
		end
	end
end

WorldMarkerUI._get_raycast_position = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	local immediate_raycast = PhysicsWorld.immediate_raycast(arg_22_4, arg_22_2, arg_22_3, 100, "all", "collision_filter", arg_22_5)

	if not immediate_raycast then
		return
	end

	local huge = math.huge
	local var_22_2
	local owner_unit = self.owner_unit
	local count = #immediate_raycast

	for i = 1, count do
		local var_22_5 = immediate_raycast[i]
		local var_22_6 = var_22_5[num_3]
		local var_22_7 = var_22_5[num_4]
		local var_22_8 = var_22_5[num_5]
		local var_22_9 = var_22_5[num_6]
		local unit = Actor.unit(var_22_9)

		if not (unit == arg_22_1 or unit == owner_unit or not (var_22_7 < huge)) then
			huge = var_22_7
			var_22_2 = var_22_5
		end
	end

	if not var_22_2 then
		return var_22_2[num_3]
	end
end
