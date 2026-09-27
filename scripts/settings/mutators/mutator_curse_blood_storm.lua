-- chunkname: @scripts/settings/mutators/mutator_curse_blood_storm.lua

local var_0_0
local scripts_settings_mutators_mutator_curse_blood_storm_v2 = require("scripts/settings/mutators/mutator_curse_blood_storm_v2")

if not scripts_settings_mutators_mutator_curse_blood_storm_v2 then
	return scripts_settings_mutators_mutator_curse_blood_storm_v2
end

local scripts_settings_mutators_mutator_nurgle_storm = require("scripts/settings/mutators/mutator_nurgle_storm")
local clone = table.clone(scripts_settings_mutators_mutator_nurgle_storm)

clone.packages = {
	"resource_packages/mutators/mutator_curse_blood_storm"
}
clone.display_name = "curse_blood_storm_name"
clone.description = "curse_blood_storm_desc"
clone.icon = "deus_curse_khorne_01"

local tbl = {
	harder = 60,
	hard = 45,
	normal = 30,
	hardest = 80,
	cataclysm = 100,
	cataclysm_3 = 130,
	cataclysm_2 = 110,
	easy = 20
}

clone.server_start_function = function (arg_1_0, arg_1_1)
	-- function 1
	arg_1_1.spawn_nurgle_storm_at = Managers.time:time("game") + 30
	arg_1_1.next_bleed_time = 0
	arg_1_1.bleed_rate = 0.2
	arg_1_1.bleed_buff = "curse_blood_storm_dot"
	arg_1_1.bleed_buff_bots = "curse_blood_storm_dot_bots"
	arg_1_1.vortex_template_name = "blood_storm"
	arg_1_1.vortex_template = VortexTemplates[arg_1_1.vortex_template_name]
	arg_1_1.inner_decal_unit_name = "units/decals/deus_decal_bloodstorm_inner"
	arg_1_1.outer_decal_unit_name = "units/decals/deus_decal_bloodstorm_outer"
	arg_1_1.storm_spawn_position = Vector3Box()
	arg_1_1.offset_spawn_distance = 3
	arg_1_1.delay_between_spawns = 2
	arg_1_1.unchecked_positions = {}
	arg_1_1.astar = GwNavAStar.create()
end

local server_pre_update_function = clone.server_pre_update_function

clone.server_update_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	server_pre_update_function(arg_2_0, arg_2_1)

	if arg_2_3 < arg_2_1.next_bleed_time then
		return
	else
		arg_2_1.next_bleed_time = arg_2_3 + arg_2_1.bleed_rate
	end

	local summoned_vortex_unit = arg_2_1.summoned_vortex_unit
	local var_2_1 = ALIVE[summoned_vortex_unit]

	var_2_1 = not var_2_1 and ScriptUnit.has_extension(summoned_vortex_unit, "ai_supplementary_system")

	if not var_2_1 then
		return
	end

	local players = Managers.player:players()

	for k, v in pairs(players) do
		local player_unit = v.player_unit

		if not ALIVE[player_unit] then
			local var_2_4 = POSITION_LOOKUP[player_unit]

			if not var_2_1:is_position_inside(var_2_4) then
				local system = Managers.state.entity:system("buff_system")
				local get_difficulty = Managers.state.difficulty:get_difficulty()
				local var_2_7 = tbl[get_difficulty]
				local bleed_buff_bots

				if not v.bot_player then
					bleed_buff_bots = arg_2_1.bleed_buff_bots

					if not bleed_buff_bots then
						-- Nothing
					end
				end

				bleed_buff_bots = arg_2_1.bleed_buff

				::label_2_0::

				system:add_buff(player_unit, bleed_buff_bots, summoned_vortex_unit, false, var_2_7)
			end
		end
	end
end

clone.server_player_hit_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if arg_3_4[2] == "blood_storm" then
		local extension_input = ScriptUnit.extension_input(arg_3_2, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_dialogue_event("curse_damage_taken", alloc_table)
	end
end

return clone
