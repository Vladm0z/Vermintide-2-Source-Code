-- chunkname: @scripts/settings/mutators/mutator_curse_rotten_miasma.lua

local num = 5
local num_2 = 1

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local game = Managers.state.network:game()

	if not (not Unit.alive(arg_1_0) and not Unit.alive(arg_1_1) and game) then
		return
	end

	local local_position = Unit.local_position(arg_1_1, 0)

	Unit.set_local_position(arg_1_0, 0, local_position)
end

local function fn_2()
	-- function 2
	local var_2_0 = Managers.state.entity:system("pickup_system"):get_pickups_by_type("deus_relic_01")[1]

	if not var_2_0 then
		return var_2_0
	end

	local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

	for i, v in ipairs(PLAYER_UNITS) do
		if not ScriptUnit.extension(v, "inventory_system"):has_inventory_item("slot_level_event", "wpn_deus_relic_01") then
			return v
		end
	end

	return nil
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local tbl = {
		pickup_system = {
			has_physics = true,
			pickup_name = "deus_relic_01",
			spawn_type = "dropped"
		},
		projectile_locomotion_system = {
			network_position = AiAnimUtils.position_network_scale(arg_3_0, true),
			network_rotation = AiAnimUtils.rotation_network_scale(arg_3_1, true),
			network_velocity = AiAnimUtils.velocity_network_scale(Vector3.zero(), true),
			network_angular_velocity = AiAnimUtils.velocity_network_scale(Vector3.zero(), true)
		}
	}

	return Managers.state.unit_spawner:spawn_network_unit("units/weapons/player/pup_deus_relic_01/pup_deus_relic_01", "deus_relic", tbl, arg_3_0, arg_3_1)
end

local function fn_4()
	-- function 4
	local conflict = Managers.state.conflict
	local get_main_paths = conflict.level_analysis:get_main_paths()

	if not get_main_paths then
		return nil
	end

	local main_path_info = conflict.main_path_info
	local main_path_player_info = conflict.main_path_player_info
	local unbox = MainPathUtils.get_main_path_point_between_players(get_main_paths, main_path_info, main_path_player_info):unbox()
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, unbox)

	if not pos_on_mesh then
		return nil
	end

	pos_on_mesh.z = pos_on_mesh.z + num_2

	return pos_on_mesh
end

local function fn_5(arg_5_0)
	-- function 5
	local var_5_0 = fn_4()

	if not var_5_0 then
		return nil, nil
	end

	local identity = Quaternion.identity()
	local var_5_2 = fn_2()

	var_5_2 = var_5_2 or fn_3(var_5_0, identity)

	local tbl = {
		buff_system = {
			initial_buff_names = {
				arg_5_0
			}
		}
	}

	return Managers.state.unit_spawner:spawn_network_unit("units/gameplay/rotten_miasma_safe_area/rotten_miasma_safe_area_01", "buff_objective_unit", tbl, var_5_0, identity), var_5_2
end

local str = "curse_rotten_miasma"

return {
	description = "curse_rotten_miasma_desc",
	display_name = "curse_rotten_miasma_name",
	icon = "deus_curse_nurgle_01",
	packages = {
		"resource_packages/mutators/mutator_curse_rotten_miasma"
	},
	server_update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		if not arg_6_1.rotten_miasma_safe_area then
			local var_6_0, var_6_1 = fn_5(str)

			arg_6_1.rotten_miasma_safe_area = var_6_0
			arg_6_1.target_to_follow = var_6_1
		end

		local var_6_2 = fn_2()

		if not var_6_2 then
			arg_6_1.target_to_follow = var_6_2
			arg_6_1.target_respawn_at = nil
		else
			local target_respawn_at = arg_6_1.target_respawn_at

			target_respawn_at = target_respawn_at or num + arg_6_3
			arg_6_1.target_respawn_at = target_respawn_at

			local var_6_4 = fn_4()

			if not (arg_6_3 >= arg_6_1.target_respawn_at) or not var_6_4 then
				local identity = Quaternion.identity()

				arg_6_1.target_to_follow = fn_3(var_6_4, identity)
			end
		end

		fn(arg_6_1.rotten_miasma_safe_area, arg_6_1.target_to_follow)
	end,
	server_stop_function = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		local rotten_miasma_safe_area = arg_7_1.rotten_miasma_safe_area

		if not ALIVE[rotten_miasma_safe_area] then
			Managers.state.unit_spawner:mark_for_deletion(rotten_miasma_safe_area)
		end
	end
}
