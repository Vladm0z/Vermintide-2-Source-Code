-- chunkname: @scripts/settings/mutators/mutator_curse_blood_storm.lua

local var_0_0
local var_0_1 = require("scripts/settings/mutators/mutator_curse_blood_storm_v2")

if var_0_1 then
	return var_0_1
end

local var_0_2 = require("scripts/settings/mutators/mutator_nurgle_storm")
local var_0_3 = table.clone(var_0_2)

var_0_3.packages = {
	"resource_packages/mutators/mutator_curse_blood_storm"
}
var_0_3.display_name = "curse_blood_storm_name"
var_0_3.description = "curse_blood_storm_desc"
var_0_3.icon = "deus_curse_khorne_01"

local var_0_4 = {
	harder = 60,
	hard = 45,
	normal = 30,
	hardest = 80,
	cataclysm = 100,
	cataclysm_3 = 130,
	cataclysm_2 = 110,
	easy = 20
}

function var_0_3.server_start_function(arg_1_0, arg_1_1)
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

local var_0_5 = var_0_3.server_pre_update_function

function var_0_3.server_update_function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	var_0_5(arg_2_0, arg_2_1)

	if arg_2_3 < arg_2_1.next_bleed_time then
		return
	else
		arg_2_1.next_bleed_time = arg_2_3 + arg_2_1.bleed_rate
	end

	local var_2_0 = arg_2_1.summoned_vortex_unit
	local var_2_1 = ALIVE[var_2_0] and ScriptUnit.has_extension(var_2_0, "ai_supplementary_system")

	if not var_2_1 then
		return
	end

	local var_2_2 = Managers.player:players()

	for iter_2_0, iter_2_1 in pairs(var_2_2) do
		local var_2_3 = iter_2_1.player_unit

		if ALIVE[var_2_3] then
			local var_2_4 = POSITION_LOOKUP[var_2_3]

			if var_2_1:is_position_inside(var_2_4) then
				local var_2_5 = Managers.state.entity:system("buff_system")
				local var_2_6 = Managers.state.difficulty:get_difficulty()
				local var_2_7 = var_0_4[var_2_6]
				local var_2_8 = iter_2_1.bot_player and arg_2_1.bleed_buff_bots or arg_2_1.bleed_buff

				var_2_5:add_buff(var_2_3, var_2_8, var_2_0, false, var_2_7)
			end
		end
	end
end

function var_0_3.server_player_hit_function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_4[2] == "blood_storm" then
		local var_3_0 = ScriptUnit.extension_input(arg_3_2, "dialogue_system")
		local var_3_1 = FrameTable.alloc_table()

		var_3_0:trigger_dialogue_event("curse_damage_taken", var_3_1)
	end
end

return var_0_3
