-- chunkname: @scripts/ui/views/damage_indicator_gui.lua

local num = 1920
local num_2 = 1080
local num_3 = 10
local tbl = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
		}
	},
	indicator_centre = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	}
}
local tbl_2 = {
	temporary_health_degen = true,
	vomit_face = true,
	buff_shared_medpack = true,
	buff = true,
	damage_over_time = true,
	life_tap = true,
	health_degen = true,
	warpfire_ground = true,
	vomit_ground = true,
	warpfire_face = true,
	wounded_dot = true,
	overcharge = true,
	heal = true,
	knockdown_bleed = true,
	life_drain = true
}
local tbl_3 = {
	scenegraph_id = "indicator_centre",
	element = UIElements.RotatedTexture,
	content = {
		texture_id = "damage_direction_indicator"
	},
	style = {
		rotating_texture = {
			angle = 90,
			size = {
				423,
				174
			},
			pivot = {
				211.5,
				-200
			},
			offset = {
				-211.5,
				200,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}
}
local tbl_4 = {
	enemy = {
		255,
		205,
		50,
		50
	},
	friendly_fire = {
		255,
		50,
		205,
		50
	}
}

DamageIndicatorGui = class(DamageIndicatorGui)

DamageIndicatorGui.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.input_manager = arg_1_2.input_manager

	self:create_ui_elements()

	self.player_manager = arg_1_2.player_manager
	self.peer_id = arg_1_2.peer_id
end

DamageIndicatorGui.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self.indicator_widgets = {}
	self.indicator_positions = {}

	for i = 1, num_3 do
		self.indicator_widgets[i] = UIWidget.init(tbl_3)
		self.indicator_positions[i] = {}
	end

	self.num_active_indicators = 0
end

DamageIndicatorGui.destroy = function (arg_3_0)
	-- function 3
	return
end

DamageIndicatorGui.update = function (self, arg_4_1)
	-- function 4
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	local get_service = self.input_manager:get_service("ingame_menu")
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local indicator_widgets = self.indicator_widgets
	local peer_id = self.peer_id
	local player_unit = self.player_manager:player_from_peer_id(peer_id).player_unit

	if not player_unit then
		return
	end

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_4_1)

	local recent_damages, var_4_7 = ScriptUnit.extension(player_unit, "health_system"):recent_damages()
	local indicator_positions = self.indicator_positions

	if var_4_7 > 0 then
		for i = 1, var_4_7 / DamageDataIndex.STRIDE do
			local num = (i - 1) * DamageDataIndex.STRIDE
			local var_4_10 = recent_damages[num + DamageDataIndex.ATTACKER]
			local var_4_11 = recent_damages[num + DamageDataIndex.DAMAGE_TYPE]
			local flag = var_4_10 == player_unit
			local flag_2 = not not tbl_2[var_4_11] or not flag

			if not var_4_10 and not Unit.alive(var_4_10) and not flag_2 then
				local num_2 = self.num_active_indicators + 1

				if num_2 <= num_3 then
					self.num_active_indicators = num_2
				else
					num_2 = 1
				end

				local var_4_15 = indicator_widgets[num_2]
				local var_4_16 = indicator_positions[num_2]
				local var_4_17 = POSITION_LOOKUP[var_4_10]

				var_4_17 = var_4_17 or Unit.world_position(var_4_10, 0)

				Vector3Aux.box(var_4_16, var_4_17)

				var_4_16[3] = 0

				local color = var_4_15.style.rotating_texture.color
				local is_player_friendly_fire = Managers.state.side:is_player_friendly_fire(var_4_10, player_unit)
				local var_4_20

				if not (not is_player_friendly_fire and Application.user_setting("friendly_fire_hit_marker")) then
					goto label_4_0
				elseif not is_player_friendly_fire then
					var_4_20 = tbl_4.friendly_fire
				else
					var_4_20 = tbl_4.enemy
				end

				color[2] = var_4_20[2]
				color[3] = var_4_20[3]
				color[4] = var_4_20[4]

				UIWidget.animate(var_4_15, UIAnimation.init(UIAnimation.function_by_time, color, 1, 255, 0, 1, math.easeInCubic))
			end

			::label_4_0::
		end
	end

	local extension = ScriptUnit.extension(player_unit, "first_person_system")
	local copy = Vector3.copy(POSITION_LOOKUP[player_unit])
	local current_rotation = extension:current_rotation()
	local forward = Quaternion.forward(current_rotation)

	forward.z = 0

	local normalize = Vector3.normalize(forward)
	local cross = Vector3.cross(normalize, Vector3.up())

	copy.z = 0

	local num_4 = 1
	local num_active_indicators = self.num_active_indicators

	while num_4 <= num_active_indicators do
		local var_4_29 = indicator_widgets[num_4]

		if not UIWidget.has_animation(var_4_29) then
			indicator_widgets[num_4] = indicator_widgets[num_active_indicators]
			indicator_widgets[num_active_indicators] = var_4_29
			num_active_indicators = num_active_indicators - 1
		else
			local normalize_2 = Vector3.normalize(Vector3Aux.unbox(indicator_positions[num_4]) - copy)
			local dot = Vector3.dot(normalize, normalize_2)
			local dot_2 = Vector3.dot(cross, normalize_2)
			local atan2 = math.atan2(dot_2, dot)

			var_4_29.style.rotating_texture.angle = atan2
			num_4 = num_4 + 1

			UIRenderer.draw_widget(ui_renderer, var_4_29)
		end
	end

	self.num_active_indicators = num_active_indicators

	UIRenderer.end_pass(ui_renderer)
end
