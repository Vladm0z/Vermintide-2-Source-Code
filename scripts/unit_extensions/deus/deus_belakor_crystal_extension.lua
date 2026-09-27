-- chunkname: @scripts/unit_extensions/deus/deus_belakor_crystal_extension.lua

DeusBelakorCrystalExtension = class(DeusBelakorCrystalExtension)

local num = 5
local num_2 = 1
local num_3 = 2
local num_4 = 1
local num_5 = 1

DeusBelakorCrystalExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._is_server = Managers.player.is_server

	if not self._is_server then
		return
	end

	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._astar = GwNavAStar.create()
end

DeusBelakorCrystalExtension.game_object_initialized = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._go_id = arg_2_2
end

DeusBelakorCrystalExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self._is_server then
		return
	end

	ScriptUnit.extension(arg_3_2, "kill_volume_handler_system"):add_handler(function ()
		-- function 4
		if not self._nearest_locus then
			self._nearest_locus = self:_find_nearest_locus()

			if not self._nearest_locus then
				return false
			end
		end

		self._next_check = 0

		return true
	end)
end

DeusBelakorCrystalExtension.destroy = function (self)
	-- function 5
	if not self._is_server then
		return
	end

	GwNavAStar.destroy(self._astar)

	self._astar = nil
	self._running_astar = nil
end

DeusBelakorCrystalExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	if not self._is_server then
		return
	end

	if not self._next_check then
		self._next_check = arg_6_5
	end

	if arg_6_5 < self._next_check then
		return
	end

	local var_6_0 = POSITION_LOOKUP[arg_6_1]

	if not self._nearest_locus then
		self._nearest_locus = self:_find_nearest_locus()
	end

	if not (not self._nearest_locus and ALIVE[self._nearest_locus]) then
		self._next_check = arg_6_5 + num

		return
	end

	local var_6_1 = POSITION_LOOKUP[self._nearest_locus]

	if not self._running_astar then
		if not GwNavAStar.processing_finished(self._astar) then
			self._running_astar = false

			if not GwNavAStar.path_found(self._astar) then
				local tbl = {}

				ConflictUtils.find_positions_around_position(var_6_1, tbl, self._nav_world, num_2, num_3, 1, nil, nil, nil, nil, nil, num_5, num_4)

				local var_6_3 = tbl[1]

				if not var_6_3 then
					local actor = Unit.actor(arg_6_1, "throw")

					Actor.set_velocity(actor, Vector3(0, 0, 0))
					Actor.teleport_position(Unit.actor(arg_6_1, "throw"), var_6_3 + Vector3(0, 0, 1))
				end
			end

			self._next_check = arg_6_5 + num
		end
	else
		local traverse_logic = Managers.state.bot_nav_transition:traverse_logic()

		GwNavAStar.start_with_propagation_box(self._astar, self._nav_world, var_6_0, var_6_1, 30, traverse_logic)

		self._running_astar = true

		return
	end
end

DeusBelakorCrystalExtension._find_nearest_locus = function (self)
	-- function 7
	local var_7_0 = POSITION_LOOKUP[self._unit]
	local get_entities = Managers.state.entity:get_entities("DeusBelakorLocusExtension")
	local var_7_2
	local var_7_3

	for k, v in pairs(get_entities) do
		local length = Vector3.length(var_7_0 - POSITION_LOOKUP[k])

		if not (not var_7_3 and not (length < var_7_3)) then
			var_7_2 = k
			var_7_3 = length
		end
	end

	return var_7_2
end
