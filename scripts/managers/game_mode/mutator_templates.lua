-- chunkname: @scripts/managers/game_mode/mutator_templates.lua

local var_0_0 = local_require("scripts/settings/mutator_settings")

local function var_0_1(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1.template
	local var_1_1 = var_1_0.modify_health_breeds

	if var_1_1 then
		local var_1_2 = var_1_0.health_modifier
		local var_1_3 = {}

		for iter_1_0, iter_1_1 in ipairs(var_1_1) do
			local var_1_4 = Breeds[iter_1_1].max_health

			var_1_3[iter_1_1] = table.clone(var_1_4)

			for iter_1_2, iter_1_3 in ipairs(var_1_4) do
				var_1_4[iter_1_2] = iter_1_3 * var_1_2
			end
		end

		arg_1_1.vanilla_breed_health = var_1_3
	end
end

local function var_0_2(arg_2_0, arg_2_1)
	if arg_2_1.vanilla_breed_health then
		for iter_2_0, iter_2_1 in pairs(arg_2_1.vanilla_breed_health) do
			Breeds[iter_2_0].max_health = iter_2_1
		end
	end
end

local function var_0_3(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.template
	local var_3_1 = var_3_0.modify_primary_armor_category_breeds

	if var_3_1 then
		local var_3_2 = var_3_0.primary_armor_category
		local var_3_3 = {}

		for iter_3_0, iter_3_1 in ipairs(var_3_1) do
			local var_3_4 = Breeds[iter_3_1]
			local var_3_5 = var_3_4.primary_armor_category

			if var_3_5 then
				var_3_3[iter_3_1] = var_3_5
			else
				var_3_3[iter_3_1] = false
			end

			var_3_4.primary_armor_category = var_3_2
		end

		if not arg_3_1.vanilla_breed_primary_armor_category then
			arg_3_1.vanilla_breed_primary_armor_category = var_3_3
		end
	end
end

local function var_0_4(arg_4_0, arg_4_1)
	if arg_4_1.vanilla_breed_primary_armor_category then
		for iter_4_0, iter_4_1 in pairs(arg_4_1.vanilla_breed_primary_armor_category) do
			if iter_4_1 then
				Breeds[iter_4_0].primary_armor_category = iter_4_1
			else
				Breeds[iter_4_0].primary_armor_category = nil
			end
		end
	end
end

local function var_0_5(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.template
	local var_5_1 = var_5_0.modify_armor_category_breeds

	if var_5_1 then
		local var_5_2 = var_5_0.armor_category
		local var_5_3 = {}

		for iter_5_0, iter_5_1 in ipairs(var_5_1) do
			local var_5_4 = Breeds[iter_5_1]
			local var_5_5 = var_5_4.armor_category

			if var_5_5 then
				var_5_3[iter_5_1] = var_5_5
				var_5_4.armor_category = var_5_2
			end
		end

		if not arg_5_1.vanilla_breed_armor_category then
			arg_5_1.vanilla_breed_armor_category = var_5_3
		end
	end
end

local function var_0_6(arg_6_0, arg_6_1)
	if arg_6_1.vanilla_breed_armor_category then
		for iter_6_0, iter_6_1 in pairs(arg_6_1.vanilla_breed_armor_category) do
			Breeds[iter_6_0].armor_category = iter_6_1
		end
	end
end

local function var_0_7(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.template
	local var_7_1 = var_7_0.remove_pickups

	if var_7_1 then
		local var_7_2 = {}

		for iter_7_0 = 1, #var_7_1 do
			var_7_2[var_7_1[iter_7_0]] = true
		end

		local var_7_3 = var_7_0.excluded_pickup_item_names
		local var_7_4 = Managers.state.entity:get_entities("PickupUnitExtension")

		for iter_7_1, iter_7_2 in pairs(var_7_4) do
			local var_7_5 = iter_7_2:get_pickup_settings()

			if not (var_7_3 and var_7_3[var_7_5.item_name]) and var_7_2.all or var_7_2[var_7_5.type] then
				Managers.state.unit_spawner:mark_for_deletion(iter_7_1)
			end
		end
	end
end

local function var_0_8(arg_8_0, arg_8_1)
	var_0_2(arg_8_0, arg_8_1)
	var_0_4(arg_8_0, arg_8_1)
	var_0_6(arg_8_0, arg_8_1)
end

local function var_0_9(arg_9_0, arg_9_1, arg_9_2)
	return
end

local function var_0_10(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	return
end

local function var_0_11(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	return
end

local function var_0_12(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	return
end

local function var_0_13(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	return
end

local function var_0_14(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	return
end

local function var_0_15(arg_15_0, arg_15_1, arg_15_2)
	return
end

local function var_0_16(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
	return
end

local function var_0_17(arg_17_0, arg_17_1, arg_17_2)
	return
end

local function var_0_18(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	return
end

local function var_0_19(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	return
end

local function var_0_20(arg_20_0, arg_20_1)
	var_0_3(arg_20_0, arg_20_1)
	var_0_5(arg_20_0, arg_20_1)
end

local function var_0_21(arg_21_0, arg_21_1)
	var_0_4(arg_21_0, arg_21_1)
	var_0_6(arg_21_0, arg_21_1)
end

local function var_0_22(arg_22_0, arg_22_1, arg_22_2)
	return
end

local function var_0_23(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	return
end

local function var_0_24(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	return
end

local function var_0_25(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	return
end

local function var_0_26(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	return
end

local function var_0_27(arg_27_0, arg_27_1, arg_27_2)
	return
end

local function var_0_28(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	return
end

local function var_0_29(arg_29_0, arg_29_1, arg_29_2)
	return
end

local function var_0_30(arg_30_0, arg_30_1)
	return
end

local function var_0_31(arg_31_0, arg_31_1)
	var_0_1(arg_31_0, arg_31_1)
	var_0_3(arg_31_0, arg_31_1)
	var_0_5(arg_31_0, arg_31_1)
end

MutatorTemplates = MutatorTemplates or {}

for iter_0_0, iter_0_1 in pairs(var_0_0) do
	iter_0_1.name = iter_0_0
	iter_0_1.server = {}
	iter_0_1.client = {}

	if iter_0_1.check_dependencies then
		local var_0_32 = iter_0_1.check_dependencies()

		fassert(var_0_32, "Mutator (%s) failed dependency check! :(", iter_0_0)
	end

	if iter_0_1.server_initialize_function then
		local function var_0_33(arg_32_0, arg_32_1)
			var_0_31(arg_32_0, arg_32_1)
			iter_0_1.server_initialize_function(arg_32_0, arg_32_1)
		end

		iter_0_1.server.initialize_function = var_0_33
	else
		iter_0_1.server.initialize_function = var_0_31
	end

	if iter_0_1.server_start_function then
		local function var_0_34(arg_33_0, arg_33_1)
			var_0_7(arg_33_0, arg_33_1)
			iter_0_1.server_start_function(arg_33_0, arg_33_1)
		end

		iter_0_1.server.start_function = var_0_34
	else
		iter_0_1.server.start_function = var_0_7
	end

	if iter_0_1.server_stop_function then
		local function var_0_35(arg_34_0, arg_34_1, arg_34_2)
			var_0_8(arg_34_0, arg_34_1)
			iter_0_1.server_stop_function(arg_34_0, arg_34_1, arg_34_2)
		end

		iter_0_1.server.stop_function = var_0_35
	else
		iter_0_1.server.stop_function = var_0_8
	end

	if iter_0_1.server_hot_join_sync then
		local function var_0_36(arg_35_0, arg_35_1, arg_35_2)
			var_0_9(arg_35_0, arg_35_1, arg_35_2)
			iter_0_1.server_hot_join_sync(arg_35_0, arg_35_1, arg_35_2)
		end

		iter_0_1.server.hot_join_sync_function = var_0_36
	else
		iter_0_1.server.hot_join_sync_function = var_0_9
	end

	if iter_0_1.server_player_disabled_function then
		local function var_0_37(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
			var_0_10(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
			iter_0_1.server_player_disabled_function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
		end

		iter_0_1.server.player_disabled_function = var_0_37
	else
		iter_0_1.server.player_disabled_function = var_0_10
	end

	if iter_0_1.server_ai_killed_function then
		local function var_0_38(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
			var_0_11(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
			iter_0_1.server_ai_killed_function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
		end

		iter_0_1.server.ai_killed_function = var_0_38
	else
		iter_0_1.server.ai_killed_function = var_0_11
	end

	if iter_0_1.server_level_object_killed_function then
		local function var_0_39(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
			var_0_12(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
			iter_0_1.server_level_object_killed_function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
		end

		iter_0_1.server.level_object_killed_function = var_0_39
	else
		iter_0_1.server.level_object_killed_function = var_0_12
	end

	if iter_0_1.server_ai_hit_by_player_function then
		local function var_0_40(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
			var_0_13(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
			iter_0_1.server_ai_hit_by_player_function(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
		end

		iter_0_1.server.ai_hit_by_player_function = var_0_40
	else
		iter_0_1.server.ai_hit_by_player_function = var_0_13
	end

	if iter_0_1.server_player_hit_function then
		local function var_0_41(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
			var_0_14(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
			iter_0_1.server_player_hit_function(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
		end

		iter_0_1.server.player_hit_function = var_0_41
	else
		iter_0_1.server.player_hit_function = var_0_14
	end

	if iter_0_1.server_player_respawned_function then
		local function var_0_42(arg_41_0, arg_41_1, arg_41_2)
			var_0_15(arg_41_0, arg_41_1, arg_41_2)
			iter_0_1.server_player_respawned_function(arg_41_0, arg_41_1, arg_41_2)
		end

		iter_0_1.server.player_respawned_function = var_0_42
	else
		iter_0_1.server.player_respawned_function = var_0_15
	end

	if iter_0_1.server_damage_taken_function then
		local function var_0_43(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
			var_0_16(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
			iter_0_1.server_damage_taken_function(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
		end

		iter_0_1.server.damage_taken_function = var_0_43
	else
		iter_0_1.server.damage_taken_function = var_0_16
	end

	if iter_0_1.server_ai_spawned_function then
		local function var_0_44(arg_43_0, arg_43_1, arg_43_2)
			var_0_17(arg_43_0, arg_43_1, arg_43_2)
			iter_0_1.server_ai_spawned_function(arg_43_0, arg_43_1, arg_43_2)
		end

		iter_0_1.server.ai_spawned_function = var_0_44
	else
		iter_0_1.server.ai_spawned_function = var_0_17
	end

	if iter_0_1.pre_ai_spawned_function then
		local function var_0_45(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
			var_0_18(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
			iter_0_1.pre_ai_spawned_function(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
		end

		iter_0_1.server.pre_ai_spawned_function = var_0_45
	else
		iter_0_1.server.pre_ai_spawned_function = var_0_18
	end

	if iter_0_1.post_ai_spawned_function then
		local function var_0_46(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
			var_0_19(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
			iter_0_1.post_ai_spawned_function(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
		end

		iter_0_1.server.post_ai_spawned_function = var_0_46
	else
		iter_0_1.server.post_ai_spawned_function = var_0_19
	end

	if iter_0_1.server_players_left_safe_zone then
		local function var_0_47(arg_46_0, arg_46_1)
			var_0_30(arg_46_0, arg_46_1)
			iter_0_1.server_players_left_safe_zone(arg_46_0, arg_46_1)
		end

		iter_0_1.server.server_players_left_safe_zone = var_0_47
	else
		iter_0_1.server.server_players_left_safe_zone = var_0_30
	end

	if iter_0_1.client_start_function then
		local function var_0_48(arg_47_0, arg_47_1)
			var_0_20(arg_47_0, arg_47_1)
			iter_0_1.client_start_function(arg_47_0, arg_47_1)
		end

		iter_0_1.client.start_function = var_0_48
	else
		iter_0_1.client.start_function = var_0_20
	end

	if iter_0_1.client_stop_function then
		local function var_0_49(arg_48_0, arg_48_1, arg_48_2)
			var_0_21(arg_48_0, arg_48_1)
			iter_0_1.client_stop_function(arg_48_0, arg_48_1, arg_48_2)
		end

		iter_0_1.client.stop_function = var_0_49
	else
		iter_0_1.client.stop_function = var_0_21
	end

	if iter_0_1.client_hot_join_sync then
		local function var_0_50(arg_49_0, arg_49_1, arg_49_2)
			var_0_22(arg_49_0, arg_49_1, arg_49_2)
			iter_0_1.client_hot_join_sync(arg_49_0, arg_49_1, arg_49_2)
		end

		iter_0_1.client.hot_join_sync_function = var_0_50
	else
		iter_0_1.client.hot_join_sync_function = var_0_22
	end

	if iter_0_1.client_ai_killed_function then
		local function var_0_51(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
			var_0_23(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
			iter_0_1.client_ai_killed_function(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
		end

		iter_0_1.client.ai_killed_function = var_0_51
	else
		iter_0_1.client.ai_killed_function = var_0_23
	end

	if iter_0_1.client_level_object_killed_function then
		local function var_0_52(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
			var_0_24(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
			iter_0_1.client_level_object_killed_function(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
		end

		iter_0_1.client.level_object_killed_function = var_0_52
	else
		iter_0_1.client.level_object_killed_function = var_0_24
	end

	if iter_0_1.client_ai_hit_by_player_function then
		local function var_0_53(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
			var_0_25(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
			iter_0_1.client_ai_hit_by_player_function(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
		end

		iter_0_1.client.ai_hit_by_player_function = var_0_53
	else
		iter_0_1.client.ai_hit_by_player_function = var_0_25
	end

	if iter_0_1.client_player_hit_function then
		local function var_0_54(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
			var_0_26(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
			iter_0_1.client_player_hit_function(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
		end

		iter_0_1.client.player_hit_function = var_0_54
	else
		iter_0_1.client.player_hit_function = var_0_26
	end

	if iter_0_1.client_player_respawned_function then
		local function var_0_55(arg_54_0, arg_54_1, arg_54_2)
			var_0_27(arg_54_0, arg_54_1, arg_54_2)
			iter_0_1.client_player_respawned_function(arg_54_0, arg_54_1, arg_54_2)
		end

		iter_0_1.client.player_respawned_function = var_0_55
	else
		iter_0_1.client.player_respawned_function = var_0_27
	end

	if iter_0_1.client_damage_taken_function then
		local function var_0_56(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6)
			var_0_28(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6)
			iter_0_1.client_damage_taken_function(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6)
		end

		iter_0_1.client.damage_taken_function = var_0_56
	else
		iter_0_1.client.damage_taken_function = var_0_28
	end

	if iter_0_1.client_ai_spawned_function then
		local function var_0_57(arg_56_0, arg_56_1, arg_56_2)
			var_0_29(arg_56_0, arg_56_1, arg_56_2)
			iter_0_1.client_ai_spawned_function(arg_56_0, arg_56_1, arg_56_2)
		end

		iter_0_1.client.ai_spawned_function = var_0_57
	else
		iter_0_1.client.ai_spawned_function = var_0_29
	end

	if iter_0_1.server_pre_update_function then
		iter_0_1.server.pre_update = iter_0_1.server_pre_update_function
	end

	if iter_0_1.client_pre_update_function then
		iter_0_1.client.pre_update = iter_0_1.client_pre_update_function
	end

	if iter_0_1.server_update_function then
		iter_0_1.server.update = iter_0_1.server_update_function
	end

	if iter_0_1.client_update_function then
		iter_0_1.client.update = iter_0_1.client_update_function
	end

	if MutatorTemplates[iter_0_0] then
		MutatorTemplates[iter_0_0] = table.create_copy(MutatorTemplates[iter_0_0], iter_0_1)
	else
		MutatorTemplates[iter_0_0] = iter_0_1
	end
end
