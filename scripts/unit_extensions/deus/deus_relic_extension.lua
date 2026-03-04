-- chunkname: @scripts/unit_extensions/deus/deus_relic_extension.lua

DeusRelicExtension = class(DeusRelicExtension)

local var_0_0 = 30
local var_0_1 = 30
local var_0_2 = 5
local var_0_3 = 5
local var_0_4 = 10
local var_0_5 = 5
local var_0_6 = 0.5

local function var_0_7(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0
	local var_1_1, var_1_2 = GwNavQueries.triangle_from_position(arg_1_0, arg_1_1, arg_1_2, arg_1_2)

	if var_1_1 then
		var_1_0 = Vector3(arg_1_1.x, arg_1_1.y, var_1_2)
	else
		local var_1_3 = GwNavQueries.inside_position_from_outside_position(arg_1_0, arg_1_1, arg_1_2, arg_1_2, arg_1_2, var_0_6)

		if var_1_3 then
			var_1_0 = var_1_3
		end
	end

	if not var_1_0 then
		return nil
	else
		return Vector3.length_squared(arg_1_1 - var_1_0)
	end
end

local function var_0_8(arg_2_0, arg_2_1)
	local var_2_0 = math.huge

	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		local var_2_1 = Vector3.length_squared(arg_2_1 - iter_2_1)

		var_2_0 = math.min(var_2_1, var_2_0)
	end

	return var_2_0
end

local function var_0_9(arg_3_0)
	local var_3_0 = Managers.state.conflict
	local var_3_1 = var_3_0.level_analysis:get_main_paths()
	local var_3_2 = var_3_0.main_path_info
	local var_3_3 = MainPathUtils.total_path_dist()
	local var_3_4

	if not var_3_2.ahead_unit then
		var_3_4 = var_3_3
	else
		var_3_4 = var_3_0.main_path_player_info[var_3_2.ahead_unit].travel_dist
	end

	local var_3_5 = var_3_4 + var_0_5
	local var_3_6 = math.clamp(var_3_5, 0, MainPathUtils.total_path_dist() - 0.1)
	local var_3_7 = MainPathUtils.point_on_mainpath(var_3_1, var_3_6)
	local var_3_8 = ScriptUnit.extension(arg_3_0, "projectile_locomotion_system")

	Actor.teleport_position(var_3_8.physics_actor, var_3_7)
end

function DeusRelicExtension.init(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0._unit = arg_4_2
	arg_4_0._is_server = Managers.player.is_server
	arg_4_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
end

function DeusRelicExtension.game_object_initialized(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._go_id = arg_5_2
end

function DeusRelicExtension.destroy(arg_6_0)
	local var_6_0 = Managers.state.unit_spawner
	local var_6_1 = arg_6_0._objective_unit

	if ALIVE[var_6_1] and not var_6_0:is_marked_for_deletion(var_6_1) then
		var_6_0:mark_for_deletion(var_6_1)

		arg_6_0._objective_unit = nil
	end
end

function DeusRelicExtension.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	arg_7_0:_update_position_resetting(arg_7_1, arg_7_5)
	arg_7_0:_update_objective_marker(arg_7_1, arg_7_5)
end

function DeusRelicExtension._update_position_resetting(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = POSITION_LOOKUP[arg_8_1]
	local var_8_1 = var_0_7(arg_8_0._nav_world, var_8_0, var_0_2)
	local var_8_2 = var_0_2 * var_0_2

	if not var_8_1 or var_8_2 < var_8_1 then
		if not arg_8_0._out_of_bounds_since then
			arg_8_0._out_of_bounds_since = arg_8_2
		end

		if arg_8_2 - arg_8_0._out_of_bounds_since > var_0_3 then
			var_0_9(arg_8_1)

			arg_8_0._out_of_bounds_since = nil
		end
	else
		arg_8_0._out_of_bounds_since = nil

		local var_8_3 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_POSITIONS

		if var_0_8(var_8_3, var_8_0) > var_0_0 * var_0_0 then
			if not arg_8_0._far_away_since then
				arg_8_0._far_away_since = arg_8_2
			end

			if arg_8_2 - arg_8_0._far_away_since > var_0_1 then
				var_0_9(arg_8_1)

				arg_8_0._far_away_since = nil
			end
		else
			arg_8_0._far_away_since = nil
		end
	end
end

function DeusRelicExtension._update_objective_marker(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0._objective_unit then
		return
	end

	if not arg_9_0._alive_since then
		arg_9_0._alive_since = arg_9_2
	end

	if arg_9_2 - arg_9_0._alive_since > var_0_4 then
		local var_9_0 = "units/hub_elements/objective_unit"
		local var_9_1 = Managers.state.unit_spawner:spawn_network_unit(var_9_0, "objective_unit", nil, POSITION_LOOKUP[arg_9_1])

		ScriptUnit.extension(var_9_1, "tutorial_system"):set_active(true)
		World.link_unit(Unit.world(arg_9_1), var_9_1, 0, arg_9_1, 0)

		local var_9_2 = Managers.state.network
		local var_9_3 = var_9_2:unit_game_object_id(var_9_1)
		local var_9_4 = var_9_2:unit_game_object_id(arg_9_1)

		var_9_2.network_transmit:send_rpc_clients("rpc_link_unit", var_9_3, 0, var_9_4, 0)

		arg_9_0._objective_unit = var_9_1
	end
end
