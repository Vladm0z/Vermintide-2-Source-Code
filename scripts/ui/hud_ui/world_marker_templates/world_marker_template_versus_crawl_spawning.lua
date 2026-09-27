-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_crawl_spawning.lua

local str = "spawning"
local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_climbing")

local climbing = WorldMarkerTemplates.climbing
local merge = table.merge
local var_0_4 = WorldMarkerTemplates[str]

var_0_4 = var_0_4 or {}

local var_0_5 = merge(var_0_4, climbing)

WorldMarkerTemplates[str] = var_0_5

var_0_5.on_enter = function (arg_1_0)
	-- function 1
	climbing.on_enter(arg_1_0)

	arg_1_0.content.icon = "world_marker_versus_pactsworn_interact_spawning"
end

var_0_5.update_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local content = arg_2_1.content
	local style = arg_2_1.style
	local icon = style.icon
	local distance = content.distance
	local progress = content.progress
	local get = Managers.input:get_service("Player"):get("action_one_hold")

	if not (not (distance <= 3) or arg_2_2.raycast_result or get) then
		progress = math.min(1, progress + arg_2_4 * 3.5)
	else
		progress = math.max(0, progress - arg_2_4 * 15)
	end

	content.progress = progress
	style.background.color[1] = 175 * progress

	if arg_2_2.raycast_result or not get then
		Colors.copy_to(icon.color, icon.color_occluded)
	else
		Colors.lerp_color_tables(icon.color_inactive, icon.color_active, progress, icon.color)
	end

	local num = (arg_2_3.max_distance - distance) / arg_2_3.fade_distance

	if num < 1 then
		icon.color[1] = icon.color[1] * num
	end

	local player_unit = Managers.player:local_player().player_unit

	if not ScriptUnit.has_extension(player_unit, "ghost_mode_system"):is_in_ghost_mode() then
		arg_2_1.alpha_multiplier = 0
	else
		arg_2_1.alpha_multiplier = 1
	end

	return false
end
