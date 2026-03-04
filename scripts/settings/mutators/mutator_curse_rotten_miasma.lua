-- chunkname: @scripts/settings/mutators/mutator_curse_rotten_miasma.lua

local var_0_0 = 5
local var_0_1 = 1

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = Managers.state.network:game()

	if not Unit.alive(arg_1_0) or not Unit.alive(arg_1_1) or not var_1_0 then
		return
	end

	local var_1_1 = Unit.local_position(arg_1_1, 0)

	Unit.set_local_position(arg_1_0, 0, var_1_1)
end

local function var_0_3()
	local var_2_0 = Managers.state.entity:system("pickup_system"):get_pickups_by_type("deus_relic_01")[1]

	if var_2_0 then
		return var_2_0
	end

	local var_2_1 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

	for iter_2_0, iter_2_1 in ipairs(var_2_1) do
		if ScriptUnit.extension(iter_2_1, "inventory_system"):has_inventory_item("slot_level_event", "wpn_deus_relic_01") then
			return iter_2_1
		end
	end

	return nil
end

local function var_0_4(arg_3_0, arg_3_1)
	local var_3_0 = {
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

	return Managers.state.unit_spawner:spawn_network_unit("units/weapons/player/pup_deus_relic_01/pup_deus_relic_01", "deus_relic", var_3_0, arg_3_0, arg_3_1)
end

local function var_0_5()
	local var_4_0 = Managers.state.conflict
	local var_4_1 = var_4_0.level_analysis:get_main_paths()

	if not var_4_1 then
		return nil
	end

	local var_4_2 = var_4_0.main_path_info
	local var_4_3 = var_4_0.main_path_player_info
	local var_4_4 = MainPathUtils.get_main_path_point_between_players(var_4_1, var_4_2, var_4_3):unbox()
	local var_4_5 = Managers.state.entity:system("ai_system"):nav_world()
	local var_4_6 = LocomotionUtils.pos_on_mesh(var_4_5, var_4_4)

	if not var_4_6 then
		return nil
	end

	var_4_6.z = var_4_6.z + var_0_1

	return var_4_6
end

local function var_0_6(arg_5_0)
	local var_5_0 = var_0_5()

	if not var_5_0 then
		return nil, nil
	end

	local var_5_1 = Quaternion.identity()
	local var_5_2 = var_0_3() or var_0_4(var_5_0, var_5_1)
	local var_5_3 = {
		buff_system = {
			initial_buff_names = {
				arg_5_0
			}
		}
	}

	return Managers.state.unit_spawner:spawn_network_unit("units/gameplay/rotten_miasma_safe_area/rotten_miasma_safe_area_01", "buff_objective_unit", var_5_3, var_5_0, var_5_1), var_5_2
end

local var_0_7 = "curse_rotten_miasma"

return {
	description = "curse_rotten_miasma_desc",
	display_name = "curse_rotten_miasma_name",
	icon = "deus_curse_nurgle_01",
	packages = {
		"resource_packages/mutators/mutator_curse_rotten_miasma"
	},
	server_update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if not arg_6_1.rotten_miasma_safe_area then
			local var_6_0, var_6_1 = var_0_6(var_0_7)

			arg_6_1.rotten_miasma_safe_area = var_6_0
			arg_6_1.target_to_follow = var_6_1
		end

		local var_6_2 = var_0_3()

		if var_6_2 then
			arg_6_1.target_to_follow = var_6_2
			arg_6_1.target_respawn_at = nil
		else
			arg_6_1.target_respawn_at = arg_6_1.target_respawn_at or var_0_0 + arg_6_3

			local var_6_3 = var_0_5()

			if arg_6_3 >= arg_6_1.target_respawn_at and var_6_3 then
				local var_6_4 = Quaternion.identity()

				arg_6_1.target_to_follow = var_0_4(var_6_3, var_6_4)
			end
		end

		var_0_2(arg_6_1.rotten_miasma_safe_area, arg_6_1.target_to_follow)
	end,
	server_stop_function = function (arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = arg_7_1.rotten_miasma_safe_area

		if ALIVE[var_7_0] then
			Managers.state.unit_spawner:mark_for_deletion(var_7_0)
		end
	end
}
