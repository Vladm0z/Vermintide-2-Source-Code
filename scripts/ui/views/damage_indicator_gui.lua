-- chunkname: @scripts/ui/views/damage_indicator_gui.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = 10
local var_0_3 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
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
local var_0_4 = {
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
local var_0_5 = {
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
local var_0_6 = {
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

DamageIndicatorGui.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.input_manager = arg_1_2.input_manager

	arg_1_0:create_ui_elements()

	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.peer_id = arg_1_2.peer_id
end

DamageIndicatorGui.create_ui_elements = function (arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)
	arg_2_0.indicator_widgets = {}
	arg_2_0.indicator_positions = {}

	for iter_2_0 = 1, var_0_2 do
		arg_2_0.indicator_widgets[iter_2_0] = UIWidget.init(var_0_5)
		arg_2_0.indicator_positions[iter_2_0] = {}
	end

	arg_2_0.num_active_indicators = 0
end

DamageIndicatorGui.destroy = function (arg_3_0)
	return
end

DamageIndicatorGui.update = function (arg_4_0, arg_4_1)
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	local var_4_0 = arg_4_0.input_manager:get_service("ingame_menu")
	local var_4_1 = arg_4_0.ui_renderer
	local var_4_2 = arg_4_0.ui_scenegraph
	local var_4_3 = arg_4_0.indicator_widgets
	local var_4_4 = arg_4_0.peer_id
	local var_4_5 = arg_4_0.player_manager:player_from_peer_id(var_4_4).player_unit

	if not var_4_5 then
		return
	end

	UIRenderer.begin_pass(var_4_1, var_4_2, var_4_0, arg_4_1)

	local var_4_6, var_4_7 = ScriptUnit.extension(var_4_5, "health_system"):recent_damages()
	local var_4_8 = arg_4_0.indicator_positions

	if var_4_7 > 0 then
		for iter_4_0 = 1, var_4_7 / DamageDataIndex.STRIDE do
			local var_4_9 = (iter_4_0 - 1) * DamageDataIndex.STRIDE
			local var_4_10 = var_4_6[var_4_9 + DamageDataIndex.ATTACKER]
			local var_4_11 = var_4_6[var_4_9 + DamageDataIndex.DAMAGE_TYPE]
			local var_4_12 = var_4_10 == var_4_5
			local var_4_13 = not var_0_4[var_4_11] and not var_4_12

			if var_4_10 and Unit.alive(var_4_10) and var_4_13 then
				local var_4_14 = arg_4_0.num_active_indicators + 1

				if var_4_14 <= var_0_2 then
					arg_4_0.num_active_indicators = var_4_14
				else
					var_4_14 = 1
				end

				local var_4_15 = var_4_3[var_4_14]
				local var_4_16 = var_4_8[var_4_14]
				local var_4_17 = POSITION_LOOKUP[var_4_10] or Unit.world_position(var_4_10, 0)

				Vector3Aux.box(var_4_16, var_4_17)

				var_4_16[3] = 0

				local var_4_18 = var_4_15.style.rotating_texture.color
				local var_4_19 = Managers.state.side:is_player_friendly_fire(var_4_10, var_4_5)
				local var_4_20

				if var_4_19 and not Application.user_setting("friendly_fire_hit_marker") then
					goto label_4_0
				elseif var_4_19 then
					var_4_20 = var_0_6.friendly_fire
				else
					var_4_20 = var_0_6.enemy
				end

				var_4_18[2] = var_4_20[2]
				var_4_18[3] = var_4_20[3]
				var_4_18[4] = var_4_20[4]

				UIWidget.animate(var_4_15, UIAnimation.init(UIAnimation.function_by_time, var_4_18, 1, 255, 0, 1, math.easeInCubic))
			end

			::label_4_0::
		end
	end

	local var_4_21 = ScriptUnit.extension(var_4_5, "first_person_system")
	local var_4_22 = Vector3.copy(POSITION_LOOKUP[var_4_5])
	local var_4_23 = var_4_21:current_rotation()
	local var_4_24 = Quaternion.forward(var_4_23)

	var_4_24.z = 0

	local var_4_25 = Vector3.normalize(var_4_24)
	local var_4_26 = Vector3.cross(var_4_25, Vector3.up())

	var_4_22.z = 0

	local var_4_27 = 1
	local var_4_28 = arg_4_0.num_active_indicators

	while var_4_27 <= var_4_28 do
		local var_4_29 = var_4_3[var_4_27]

		if not UIWidget.has_animation(var_4_29) then
			var_4_3[var_4_27] = var_4_3[var_4_28]
			var_4_3[var_4_28] = var_4_29
			var_4_28 = var_4_28 - 1
		else
			local var_4_30 = Vector3.normalize(Vector3Aux.unbox(var_4_8[var_4_27]) - var_4_22)
			local var_4_31 = Vector3.dot(var_4_25, var_4_30)
			local var_4_32 = Vector3.dot(var_4_26, var_4_30)
			local var_4_33 = math.atan2(var_4_32, var_4_31)

			var_4_29.style.rotating_texture.angle = var_4_33
			var_4_27 = var_4_27 + 1

			UIRenderer.draw_widget(var_4_1, var_4_29)
		end
	end

	arg_4_0.num_active_indicators = var_4_28

	UIRenderer.end_pass(var_4_1)
end
