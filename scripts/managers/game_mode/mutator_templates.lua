-- chunkname: @scripts/managers/game_mode/mutator_templates.lua

local var_0_0 = local_require("scripts/settings/mutator_settings")

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local template = arg_1_1.template
	local modify_health_breeds = template.modify_health_breeds

	if not modify_health_breeds then
		local health_modifier = template.health_modifier
		local tbl = {}

		for i, v in ipairs(modify_health_breeds) do
			local max_health = Breeds[v].max_health

			tbl[v] = table.clone(max_health)

			for i_2, v_2 in ipairs(max_health) do
				max_health[i_2] = v_2 * health_modifier
			end
		end

		arg_1_1.vanilla_breed_health = tbl
	end
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	if not arg_2_1.vanilla_breed_health then
		for k, v in pairs(arg_2_1.vanilla_breed_health) do
			Breeds[k].max_health = v
		end
	end
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local template = arg_3_1.template
	local modify_primary_armor_category_breeds = template.modify_primary_armor_category_breeds

	if not modify_primary_armor_category_breeds then
		local primary_armor_category = template.primary_armor_category
		local tbl = {}

		for i, v in ipairs(modify_primary_armor_category_breeds) do
			local var_3_4 = Breeds[v]
			local primary_armor_category_2 = var_3_4.primary_armor_category

			if not primary_armor_category_2 then
				tbl[v] = primary_armor_category_2
			else
				tbl[v] = false
			end

			var_3_4.primary_armor_category = primary_armor_category
		end

		if not arg_3_1.vanilla_breed_primary_armor_category then
			arg_3_1.vanilla_breed_primary_armor_category = tbl
		end
	end
end

local function fn_4(arg_4_0, arg_4_1)
	-- function 4
	if not arg_4_1.vanilla_breed_primary_armor_category then
		for k, v in pairs(arg_4_1.vanilla_breed_primary_armor_category) do
			if not v then
				Breeds[k].primary_armor_category = v
			else
				Breeds[k].primary_armor_category = nil
			end
		end
	end
end

local function fn_5(arg_5_0, arg_5_1)
	-- function 5
	local template = arg_5_1.template
	local modify_armor_category_breeds = template.modify_armor_category_breeds

	if not modify_armor_category_breeds then
		local armor_category = template.armor_category
		local tbl = {}

		for i, v in ipairs(modify_armor_category_breeds) do
			local var_5_4 = Breeds[v]
			local armor_category_2 = var_5_4.armor_category

			if not armor_category_2 then
				tbl[v] = armor_category_2
				var_5_4.armor_category = armor_category
			end
		end

		if not arg_5_1.vanilla_breed_armor_category then
			arg_5_1.vanilla_breed_armor_category = tbl
		end
	end
end

local function fn_6(arg_6_0, arg_6_1)
	-- function 6
	if not arg_6_1.vanilla_breed_armor_category then
		for k, v in pairs(arg_6_1.vanilla_breed_armor_category) do
			Breeds[k].armor_category = v
		end
	end
end

local function fn_7(arg_7_0, arg_7_1)
	-- function 7
	local template = arg_7_1.template
	local remove_pickups = template.remove_pickups

	if not remove_pickups then
		local tbl = {}

		for i = 1, #remove_pickups do
			tbl[remove_pickups[i]] = true
		end

		local excluded_pickup_item_names = template.excluded_pickup_item_names
		local get_entities = Managers.state.entity:get_entities("PickupUnitExtension")

		for k, v in pairs(get_entities) do
			local get_pickup_settings = v:get_pickup_settings()

			if (not excluded_pickup_item_names and excluded_pickup_item_names[get_pickup_settings.item_name] or not tbl.all) and not tbl[get_pickup_settings.type] then
				Managers.state.unit_spawner:mark_for_deletion(k)
			end
		end
	end
end

local function fn_8(arg_8_0, arg_8_1)
	-- function 8
	fn_2(arg_8_0, arg_8_1)
	fn_4(arg_8_0, arg_8_1)
	fn_6(arg_8_0, arg_8_1)
end

local function fn_9(arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

local function fn_10(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	return
end

local function fn_11(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	return
end

local function fn_12(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	return
end

local function fn_13(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	return
end

local function fn_14(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	return
end

local function fn_15(arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	return
end

local function fn_16(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
	-- function 16
	return
end

local function fn_17(arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	return
end

local function fn_18(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	return
end

local function fn_19(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	return
end

local function fn_20(arg_20_0, arg_20_1)
	-- function 20
	fn_3(arg_20_0, arg_20_1)
	fn_5(arg_20_0, arg_20_1)
end

local function fn_21(arg_21_0, arg_21_1)
	-- function 21
	fn_4(arg_21_0, arg_21_1)
	fn_6(arg_21_0, arg_21_1)
end

local function fn_22(arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	return
end

local function fn_23(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	return
end

local function fn_24(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	return
end

local function fn_25(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	return
end

local function fn_26(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	return
end

local function fn_27(arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	return
end

local function fn_28(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	-- function 28
	return
end

local function fn_29(arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	return
end

local function fn_30(arg_30_0, arg_30_1)
	-- function 30
	return
end

local function fn_31(arg_31_0, arg_31_1)
	-- function 31
	fn(arg_31_0, arg_31_1)
	fn_3(arg_31_0, arg_31_1)
	fn_5(arg_31_0, arg_31_1)
end

local MutatorTemplates = MutatorTemplates

MutatorTemplates = MutatorTemplates or {}
MutatorTemplates = MutatorTemplates

for k, v in pairs(var_0_0) do
	v.name = k
	v.server = {}
	v.client = {}

	if not v.check_dependencies then
		local check_dependencies = v.check_dependencies()

		fassert(check_dependencies, "Mutator (%s) failed dependency check! :(", k)
	end

	if not v.server_initialize_function then
		local function fn_32(arg_32_0, arg_32_1)
			-- function 32
			fn_31(arg_32_0, arg_32_1)
			v.server_initialize_function(arg_32_0, arg_32_1)
		end

		v.server.initialize_function = fn_32
	else
		v.server.initialize_function = fn_31
	end

	if not v.server_start_function then
		local function fn_33(arg_33_0, arg_33_1)
			-- function 33
			fn_7(arg_33_0, arg_33_1)
			v.server_start_function(arg_33_0, arg_33_1)
		end

		v.server.start_function = fn_33
	else
		v.server.start_function = fn_7
	end

	if not v.server_stop_function then
		local function fn_34(arg_34_0, arg_34_1, arg_34_2)
			-- function 34
			fn_8(arg_34_0, arg_34_1)
			v.server_stop_function(arg_34_0, arg_34_1, arg_34_2)
		end

		v.server.stop_function = fn_34
	else
		v.server.stop_function = fn_8
	end

	if not v.server_hot_join_sync then
		local function fn_35(arg_35_0, arg_35_1, arg_35_2)
			-- function 35
			fn_9(arg_35_0, arg_35_1, arg_35_2)
			v.server_hot_join_sync(arg_35_0, arg_35_1, arg_35_2)
		end

		v.server.hot_join_sync_function = fn_35
	else
		v.server.hot_join_sync_function = fn_9
	end

	if not v.server_player_disabled_function then
		local function fn_36(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
			-- function 36
			fn_10(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
			v.server_player_disabled_function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
		end

		v.server.player_disabled_function = fn_36
	else
		v.server.player_disabled_function = fn_10
	end

	if not v.server_ai_killed_function then
		local function fn_37(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
			-- function 37
			fn_11(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
			v.server_ai_killed_function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
		end

		v.server.ai_killed_function = fn_37
	else
		v.server.ai_killed_function = fn_11
	end

	if not v.server_level_object_killed_function then
		local function fn_38(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
			-- function 38
			fn_12(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
			v.server_level_object_killed_function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
		end

		v.server.level_object_killed_function = fn_38
	else
		v.server.level_object_killed_function = fn_12
	end

	if not v.server_ai_hit_by_player_function then
		local function fn_39(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
			-- function 39
			fn_13(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
			v.server_ai_hit_by_player_function(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
		end

		v.server.ai_hit_by_player_function = fn_39
	else
		v.server.ai_hit_by_player_function = fn_13
	end

	if not v.server_player_hit_function then
		local function fn_40(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
			-- function 40
			fn_14(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
			v.server_player_hit_function(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
		end

		v.server.player_hit_function = fn_40
	else
		v.server.player_hit_function = fn_14
	end

	if not v.server_player_respawned_function then
		local function fn_41(arg_41_0, arg_41_1, arg_41_2)
			-- function 41
			fn_15(arg_41_0, arg_41_1, arg_41_2)
			v.server_player_respawned_function(arg_41_0, arg_41_1, arg_41_2)
		end

		v.server.player_respawned_function = fn_41
	else
		v.server.player_respawned_function = fn_15
	end

	if not v.server_damage_taken_function then
		local function fn_42(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
			-- function 42
			fn_16(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
			v.server_damage_taken_function(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
		end

		v.server.damage_taken_function = fn_42
	else
		v.server.damage_taken_function = fn_16
	end

	if not v.server_ai_spawned_function then
		local function fn_43(arg_43_0, arg_43_1, arg_43_2)
			-- function 43
			fn_17(arg_43_0, arg_43_1, arg_43_2)
			v.server_ai_spawned_function(arg_43_0, arg_43_1, arg_43_2)
		end

		v.server.ai_spawned_function = fn_43
	else
		v.server.ai_spawned_function = fn_17
	end

	if not v.pre_ai_spawned_function then
		local function fn_44(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
			-- function 44
			fn_18(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
			v.pre_ai_spawned_function(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
		end

		v.server.pre_ai_spawned_function = fn_44
	else
		v.server.pre_ai_spawned_function = fn_18
	end

	if not v.post_ai_spawned_function then
		local function fn_45(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
			-- function 45
			fn_19(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
			v.post_ai_spawned_function(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
		end

		v.server.post_ai_spawned_function = fn_45
	else
		v.server.post_ai_spawned_function = fn_19
	end

	if not v.server_players_left_safe_zone then
		local function fn_46(arg_46_0, arg_46_1)
			-- function 46
			fn_30(arg_46_0, arg_46_1)
			v.server_players_left_safe_zone(arg_46_0, arg_46_1)
		end

		v.server.server_players_left_safe_zone = fn_46
	else
		v.server.server_players_left_safe_zone = fn_30
	end

	if not v.client_start_function then
		local function fn_47(arg_47_0, arg_47_1)
			-- function 47
			fn_20(arg_47_0, arg_47_1)
			v.client_start_function(arg_47_0, arg_47_1)
		end

		v.client.start_function = fn_47
	else
		v.client.start_function = fn_20
	end

	if not v.client_stop_function then
		local function fn_48(arg_48_0, arg_48_1, arg_48_2)
			-- function 48
			fn_21(arg_48_0, arg_48_1)
			v.client_stop_function(arg_48_0, arg_48_1, arg_48_2)
		end

		v.client.stop_function = fn_48
	else
		v.client.stop_function = fn_21
	end

	if not v.client_hot_join_sync then
		local function fn_49(arg_49_0, arg_49_1, arg_49_2)
			-- function 49
			fn_22(arg_49_0, arg_49_1, arg_49_2)
			v.client_hot_join_sync(arg_49_0, arg_49_1, arg_49_2)
		end

		v.client.hot_join_sync_function = fn_49
	else
		v.client.hot_join_sync_function = fn_22
	end

	if not v.client_ai_killed_function then
		local function fn_50(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
			-- function 50
			fn_23(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
			v.client_ai_killed_function(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
		end

		v.client.ai_killed_function = fn_50
	else
		v.client.ai_killed_function = fn_23
	end

	if not v.client_level_object_killed_function then
		local function fn_51(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
			-- function 51
			fn_24(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
			v.client_level_object_killed_function(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
		end

		v.client.level_object_killed_function = fn_51
	else
		v.client.level_object_killed_function = fn_24
	end

	if not v.client_ai_hit_by_player_function then
		local function fn_52(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
			-- function 52
			fn_25(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
			v.client_ai_hit_by_player_function(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
		end

		v.client.ai_hit_by_player_function = fn_52
	else
		v.client.ai_hit_by_player_function = fn_25
	end

	if not v.client_player_hit_function then
		local function fn_53(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
			-- function 53
			fn_26(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
			v.client_player_hit_function(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
		end

		v.client.player_hit_function = fn_53
	else
		v.client.player_hit_function = fn_26
	end

	if not v.client_player_respawned_function then
		local function fn_54(arg_54_0, arg_54_1, arg_54_2)
			-- function 54
			fn_27(arg_54_0, arg_54_1, arg_54_2)
			v.client_player_respawned_function(arg_54_0, arg_54_1, arg_54_2)
		end

		v.client.player_respawned_function = fn_54
	else
		v.client.player_respawned_function = fn_27
	end

	if not v.client_damage_taken_function then
		local function fn_55(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6)
			-- function 55
			fn_28(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6)
			v.client_damage_taken_function(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6)
		end

		v.client.damage_taken_function = fn_55
	else
		v.client.damage_taken_function = fn_28
	end

	if not v.client_ai_spawned_function then
		local function fn_56(arg_56_0, arg_56_1, arg_56_2)
			-- function 56
			fn_29(arg_56_0, arg_56_1, arg_56_2)
			v.client_ai_spawned_function(arg_56_0, arg_56_1, arg_56_2)
		end

		v.client.ai_spawned_function = fn_56
	else
		v.client.ai_spawned_function = fn_29
	end

	if not v.server_pre_update_function then
		v.server.pre_update = v.server_pre_update_function
	end

	if not v.client_pre_update_function then
		v.client.pre_update = v.client_pre_update_function
	end

	if not v.server_update_function then
		v.server.update = v.server_update_function
	end

	if not v.client_update_function then
		v.client.update = v.client_update_function
	end

	if not MutatorTemplates[k] then
		MutatorTemplates[k] = table.create_copy(MutatorTemplates[k], v)
	else
		MutatorTemplates[k] = v
	end
end
