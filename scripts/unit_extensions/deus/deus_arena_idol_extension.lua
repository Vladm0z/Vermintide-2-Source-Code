-- chunkname: @scripts/unit_extensions/deus/deus_arena_idol_extension.lua

DeusArenaIdolExtension = class(DeusArenaIdolExtension)

local var_0_0 = 1
local var_0_1 = 2
local var_0_2 = 3
local var_0_3 = 4
local var_0_4 = 5
local var_0_5 = {
	[var_0_0] = "units/props/deus_idol/deus_sigmar_01",
	[var_0_1] = "units/props/deus_idol/deus_myrmidia_01",
	[var_0_2] = "units/props/deus_idol/deus_valaya_01",
	[var_0_3] = "units/props/deus_idol/deus_lileath_01",
	[var_0_4] = "units/props/deus_idol/deus_taal_01"
}

DeusArenaIdolExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._world = arg_1_1.world
end

DeusArenaIdolExtension.destroy = function (arg_2_0)
	return
end

DeusArenaIdolExtension.on_local_player_game_starts = function (arg_3_0)
	local var_3_0 = POSITION_LOOKUP[arg_3_0._unit]
	local var_3_1 = Managers.player:local_player():profile_index()
	local var_3_2 = var_0_5[var_3_1]
	local var_3_3 = World.spawn_unit(arg_3_0._world, var_3_2, var_3_0)

	World.link_unit(arg_3_0._world, var_3_3, 0, arg_3_0._unit, 0)
end
