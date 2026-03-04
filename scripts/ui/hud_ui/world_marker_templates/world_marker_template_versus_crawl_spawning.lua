-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_crawl_spawning.lua

local var_0_0 = "spawning"

WorldMarkerTemplates = WorldMarkerTemplates or {}

require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_climbing")

local var_0_1 = WorldMarkerTemplates.climbing
local var_0_2 = table.merge(WorldMarkerTemplates[var_0_0] or {}, var_0_1)

WorldMarkerTemplates[var_0_0] = var_0_2

function var_0_2.on_enter(arg_1_0)
	var_0_1.on_enter(arg_1_0)

	arg_1_0.content.icon = "world_marker_versus_pactsworn_interact_spawning"
end

function var_0_2.update_function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_1.content
	local var_2_1 = arg_2_1.style
	local var_2_2 = var_2_1.icon
	local var_2_3 = var_2_0.distance
	local var_2_4 = var_2_0.progress
	local var_2_5 = Managers.input:get_service("Player"):get("action_one_hold")

	if var_2_3 <= 3 and not arg_2_2.raycast_result and not var_2_5 then
		var_2_4 = math.min(1, var_2_4 + arg_2_4 * 3.5)
	else
		var_2_4 = math.max(0, var_2_4 - arg_2_4 * 15)
	end

	var_2_0.progress = var_2_4
	var_2_1.background.color[1] = 175 * var_2_4

	if arg_2_2.raycast_result or var_2_5 then
		Colors.copy_to(var_2_2.color, var_2_2.color_occluded)
	else
		Colors.lerp_color_tables(var_2_2.color_inactive, var_2_2.color_active, var_2_4, var_2_2.color)
	end

	local var_2_6 = (arg_2_3.max_distance - var_2_3) / arg_2_3.fade_distance

	if var_2_6 < 1 then
		var_2_2.color[1] = var_2_2.color[1] * var_2_6
	end

	local var_2_7 = Managers.player:local_player().player_unit

	if not ScriptUnit.has_extension(var_2_7, "ghost_mode_system"):is_in_ghost_mode() then
		arg_2_1.alpha_multiplier = 0
	else
		arg_2_1.alpha_multiplier = 1
	end

	return false
end
