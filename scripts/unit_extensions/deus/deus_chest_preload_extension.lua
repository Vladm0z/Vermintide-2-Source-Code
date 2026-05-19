-- chunkname: @scripts/unit_extensions/deus/deus_chest_preload_extension.lua

DeusChestPreloadExtension = class(DeusChestPreloadExtension)

local var_0_0 = 1

local function var_0_1(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.data
	local var_1_1 = arg_1_0.backend_id
	local var_1_2 = arg_1_0.skin
	local var_1_3 = BackendUtils.get_item_template(var_1_0, var_1_1)
	local var_1_4 = BackendUtils.get_item_units(var_1_0, var_1_1, var_1_2, arg_1_1)

	return WeaponUtils.get_weapon_packages(var_1_3, var_1_4, false, arg_1_1)
end

function DeusChestPreloadExtension.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = ScriptUnit.has_extension(arg_2_2, "pickup_system")

	fassert(var_2_0, "DeusChestPreloadExtension requires unit to also have DeusChestExtension")

	arg_2_0._pickup_extension = var_2_0
	arg_2_0._weapon_preload_packages = {}
end

function DeusChestPreloadExtension.extensions_ready(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	fassert(arg_3_0._deus_run_controller, "deus pickup unit can only be used in a deus run")
end

function DeusChestPreloadExtension.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._go_id or Managers.state.unit_storage:go_id(arg_4_1)
	local var_4_1 = arg_4_0._deus_run_controller
	local var_4_2 = var_4_1:get_own_peer_id()
	local var_4_3, var_4_4 = var_4_1:get_player_profile(var_4_2, var_0_0)
	local var_4_5 = var_4_3 ~= arg_4_0._profile_index or var_4_4 ~= arg_4_0._career_index
	local var_4_6 = arg_4_0:_get_server_chest_type(arg_4_1)

	if var_4_0 and var_4_6 then
		local var_4_7 = var_4_6 == DEUS_CHEST_TYPES.swap_ranged or var_4_6 == DEUS_CHEST_TYPES.swap_melee

		if var_4_5 and var_4_7 then
			local var_4_8 = SPProfiles[var_4_3].careers[var_4_4].name

			arg_4_0:_generate_stored_weapon_packages(var_4_8)
		end

		if var_4_6 == DEUS_CHEST_TYPES.upgrade then
			arg_4_0:_generate_upgraded_weapon_packages()
		end

		arg_4_0._profile_index = var_4_3
		arg_4_0._career_index = var_4_4
		arg_4_0._go_id = var_4_0
		arg_4_0._chest_type = var_4_6
	end
end

function DeusChestPreloadExtension.get_weapon_preload_packages(arg_5_0)
	return arg_5_0._weapon_preload_packages
end

function DeusChestPreloadExtension.get_chest_type(arg_6_0)
	return arg_6_0._chest_type
end

function DeusChestPreloadExtension._generate_stored_weapon_packages(arg_7_0, arg_7_1)
	table.clear(arg_7_0._weapon_preload_packages)

	local var_7_0 = arg_7_0._pickup_extension:get_stored_purchase()
	local var_7_1 = var_0_1(var_7_0, arg_7_1)

	table.append(arg_7_0._weapon_preload_packages, var_7_1)
end

function DeusChestPreloadExtension._generate_upgraded_weapon_packages(arg_8_0)
	local var_8_0 = arg_8_0._deus_run_controller
	local var_8_1 = var_8_0:get_own_peer_id()
	local var_8_2, var_8_3 = var_8_0:get_player_profile(var_8_1, var_0_0)
	local var_8_4, var_8_5 = var_8_0:get_own_loadout_serialized()
	local var_8_6 = var_8_4 ~= arg_8_0._previous_melee_weapon
	local var_8_7 = var_8_5 ~= arg_8_0._previous_ranged_weapon

	if var_8_6 or var_8_7 then
		local var_8_8, var_8_9 = var_8_0:get_own_loadout()
		local var_8_10 = arg_8_0._pickup_extension:get_rarity()

		if var_8_6 then
			arg_8_0._stored_melee_upgrade = arg_8_0:_generate_upgraded_weapon(var_8_8, var_8_10, arg_8_0._go_id, var_8_2, var_8_3)
			arg_8_0._previous_melee_weapon = var_8_4
		end

		if var_8_7 then
			arg_8_0._stored_ranged_upgrade = arg_8_0:_generate_upgraded_weapon(var_8_9, var_8_10, arg_8_0._go_id, var_8_2, var_8_3)
			arg_8_0._previous_ranged_weapon = var_8_5
		end

		local var_8_11 = arg_8_0._weapon_preload_packages

		table.clear(var_8_11)
		table.append(var_8_11, var_0_1(arg_8_0._stored_melee_upgrade))
		table.append(var_8_11, var_0_1(arg_8_0._stored_ranged_upgrade))
	end
end

function DeusChestPreloadExtension._generate_upgraded_weapon(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_0._deus_run_controller
	local var_9_1 = var_9_0:get_current_node()
	local var_9_2 = var_9_1.run_progress
	local var_9_3 = var_9_0:get_run_difficulty()
	local var_9_4 = HashUtils.fnv32_hash(string.format("%s_%s_%s_%s_%s", arg_9_4, arg_9_5, var_9_1.weapon_pickup_seed, arg_9_3, 1))

	return (DeusWeaponGeneration.upgrade_item(arg_9_1, var_9_3, var_9_2, arg_9_2, var_9_4))
end

function DeusChestPreloadExtension._get_server_chest_type(arg_10_0, arg_10_1)
	local var_10_0 = Managers.state.network:game()
	local var_10_1 = Managers.state.unit_storage:go_id(arg_10_1)

	if not var_10_0 or not var_10_1 then
		return nil
	end

	local var_10_2 = GameSession.game_object_field(var_10_0, var_10_1, "server_chest_type")

	return var_10_2 ~= 0 and NetworkLookup.deus_chest_types[var_10_2] or nil
end
