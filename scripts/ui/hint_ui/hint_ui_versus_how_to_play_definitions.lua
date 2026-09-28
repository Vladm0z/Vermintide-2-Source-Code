-- chunkname: @scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions.lua

local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.popup
		}
	},
	hint_anchor = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-400,
			0,
			1
		}
	}
}
local widget_definitions = {}
local animation_definitions = {
	enter = {
		{
			name = "slide_and_fade_in",
			start_progress = 0,
			end_progress = 0.75,
			init = function (ui_scenegraph, scenegraph_definition, widget, params)
				-- function 1
				params.render_settings.alpha_multiplier = 0

				local wwise_world = params.wwise_world

				WwiseWorld.trigger_event(wwise_world, "Play_hud_gameplay_hint")
			end,
			update = function (ui_scenegraph, scenegraph_definition, widget, progress, params)
				-- function 2
				if not widget then
					return
				end

				local anim_progress = math.easeOutCubic(progress)

				params.render_settings.alpha_multiplier = progress
				widget.offset[1] = 400 * (1 - anim_progress)
			end,
			on_complete = function (ui_scenegraph, scenegraph_definition, widget, params)
				-- function 3
				return
			end
		}
	},
	exit = {
		{
			name = "slide_and_fade_out",
			start_progress = 0,
			end_progress = 0.5,
			init = function (ui_scenegraph, scenegraph_definition, widget, params)
				-- function 4
				return
			end,
			update = function (ui_scenegraph, scenegraph_definition, widget, progress, params)
				-- function 5
				if not widget then
					return
				end

				local anim_progress = math.easeOutCubic(progress)

				params.render_settings.alpha_multiplier = 1 - progress
				widget.offset[1] = 400 * anim_progress
			end,
			on_complete = function (ui_scenegraph, scenegraph_definition, widget, params)
				-- function 6
				local self = params.self

				self:hide()
			end
		}
	}
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	animation_definitions = animation_definitions
}
