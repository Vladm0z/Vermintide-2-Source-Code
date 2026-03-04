-- chunkname: @scripts/unit_extensions/deus/deus_belakor_crystal_extension.lua

DeusBelakorCrystalExtension = class(DeusBelakorCrystalExtension)

local var_0_0 = 5
local var_0_1 = 1
local var_0_2 = 2
local var_0_3 = 1
local var_0_4 = 1

function DeusBelakorCrystalExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._is_server = Managers.player.is_server

	if not arg_1_0._is_server then
		return
	end

	arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0._astar = GwNavAStar.create()
end

function DeusBelakorCrystalExtension.game_object_initialized(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._go_id = arg_2_2
end

function DeusBelakorCrystalExtension.extensions_ready(arg_3_0, arg_3_1, arg_3_2)
	if not arg_3_0._is_server then
		return
	end

	ScriptUnit.extension(arg_3_2, "kill_volume_handler_system"):add_handler(function()
		if not arg_3_0._nearest_locus then
			arg_3_0._nearest_locus = arg_3_0:_find_nearest_locus()

			if not arg_3_0._nearest_locus then
				return false
			end
		end

		arg_3_0._next_check = 0

		return true
	end)
end

function DeusBelakorCrystalExtension.destroy(arg_5_0)
	if not arg_5_0._is_server then
		return
	end

	GwNavAStar.destroy(arg_5_0._astar)

	arg_5_0._astar = nil
	arg_5_0._running_astar = nil
end

function DeusBelakorCrystalExtension.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if not arg_6_0._is_server then
		return
	end

	if not arg_6_0._next_check then
		arg_6_0._next_check = arg_6_5
	end

	if arg_6_5 < arg_6_0._next_check then
		return
	end

	local var_6_0 = POSITION_LOOKUP[arg_6_1]

	if not arg_6_0._nearest_locus then
		arg_6_0._nearest_locus = arg_6_0:_find_nearest_locus()
	end

	if not arg_6_0._nearest_locus or not ALIVE[arg_6_0._nearest_locus] then
		arg_6_0._next_check = arg_6_5 + var_0_0

		return
	end

	local var_6_1 = POSITION_LOOKUP[arg_6_0._nearest_locus]

	if arg_6_0._running_astar then
		if GwNavAStar.processing_finished(arg_6_0._astar) then
			arg_6_0._running_astar = false

			if not GwNavAStar.path_found(arg_6_0._astar) then
				local var_6_2 = {}

				ConflictUtils.find_positions_around_position(var_6_1, var_6_2, arg_6_0._nav_world, var_0_1, var_0_2, 1, nil, nil, nil, nil, nil, var_0_4, var_0_3)

				local var_6_3 = var_6_2[1]

				if var_6_3 then
					local var_6_4 = Unit.actor(arg_6_1, "throw")

					Actor.set_velocity(var_6_4, Vector3(0, 0, 0))
					Actor.teleport_position(Unit.actor(arg_6_1, "throw"), var_6_3 + Vector3(0, 0, 1))
				end
			end

			arg_6_0._next_check = arg_6_5 + var_0_0
		end
	else
		local var_6_5 = Managers.state.bot_nav_transition:traverse_logic()

		GwNavAStar.start_with_propagation_box(arg_6_0._astar, arg_6_0._nav_world, var_6_0, var_6_1, 30, var_6_5)

		arg_6_0._running_astar = true

		return
	end
end

function DeusBelakorCrystalExtension._find_nearest_locus(arg_7_0)
	local var_7_0 = POSITION_LOOKUP[arg_7_0._unit]
	local var_7_1 = Managers.state.entity:get_entities("DeusBelakorLocusExtension")
	local var_7_2
	local var_7_3

	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		local var_7_4 = Vector3.length(var_7_0 - POSITION_LOOKUP[iter_7_0])

		if not var_7_3 or var_7_4 < var_7_3 then
			var_7_2 = iter_7_0
			var_7_3 = var_7_4
		end
	end

	return var_7_2
end
