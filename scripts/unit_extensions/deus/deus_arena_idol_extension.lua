-- chunkname: @scripts/unit_extensions/deus/deus_arena_idol_extension.lua

DeusArenaIdolExtension = class(DeusArenaIdolExtension)

local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4
local num_5 = 5
local tbl = {
	[num] = "units/props/deus_idol/deus_sigmar_01",
	[num_2] = "units/props/deus_idol/deus_myrmidia_01",
	[num_3] = "units/props/deus_idol/deus_valaya_01",
	[num_4] = "units/props/deus_idol/deus_lileath_01",
	[num_5] = "units/props/deus_idol/deus_taal_01"
}

DeusArenaIdolExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._world = arg_1_1.world
end

DeusArenaIdolExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

DeusArenaIdolExtension.on_local_player_game_starts = function (self)
	-- function 3
	local var_3_0 = POSITION_LOOKUP[self._unit]
	local profile_index = Managers.player:local_player():profile_index()
	local var_3_2 = tbl[profile_index]
	local spawn_unit = World.spawn_unit(self._world, var_3_2, var_3_0)

	World.link_unit(self._world, spawn_unit, 0, self._unit, 0)
end
