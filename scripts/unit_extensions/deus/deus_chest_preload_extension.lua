-- chunkname: @scripts/unit_extensions/deus/deus_chest_preload_extension.lua

DeusChestPreloadExtension = class(DeusChestPreloadExtension)

local num = 1

local function fn(self, arg_1_1)
	-- function 1
	local data = self.data
	local backend_id = self.backend_id
	local skin = self.skin
	local get_item_template = BackendUtils.get_item_template(data, backend_id)
	local get_item_units = BackendUtils.get_item_units(data, backend_id, skin, arg_1_1)

	return WeaponUtils.get_weapon_packages(get_item_template, get_item_units, false, arg_1_1)
end

DeusChestPreloadExtension.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local has_extension = ScriptUnit.has_extension(arg_2_2, "pickup_system")

	fassert(has_extension, "DeusChestPreloadExtension requires unit to also have DeusChestExtension")

	self._pickup_extension = has_extension
	self._weapon_preload_packages = {}
end

DeusChestPreloadExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	fassert(self._deus_run_controller, "deus pickup unit can only be used in a deus run")
end

DeusChestPreloadExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _go_id = self._go_id

	_go_id = _go_id or Managers.state.unit_storage:go_id(arg_4_1)

	local _deus_run_controller = self._deus_run_controller
	local get_own_peer_id = _deus_run_controller:get_own_peer_id()
	local get_player_profile, var_4_4 = _deus_run_controller:get_player_profile(get_own_peer_id, num)
	local flag = get_player_profile ~= self._profile_index or var_4_4 ~= self._career_index
	local _get_server_chest_type = self:_get_server_chest_type(arg_4_1)

	if not _go_id and not _get_server_chest_type then
		local flag_2 = _get_server_chest_type == DEUS_CHEST_TYPES.swap_ranged or _get_server_chest_type == DEUS_CHEST_TYPES.swap_melee

		if not flag and not flag_2 then
			local name = SPProfiles[get_player_profile].careers[var_4_4].name

			self:_generate_stored_weapon_packages(name)
		end

		if _get_server_chest_type == DEUS_CHEST_TYPES.upgrade then
			self:_generate_upgraded_weapon_packages()
		end

		self._profile_index = get_player_profile
		self._career_index = var_4_4
		self._go_id = _go_id
		self._chest_type = _get_server_chest_type
	end
end

DeusChestPreloadExtension.get_weapon_preload_packages = function (self)
	-- function 5
	return self._weapon_preload_packages
end

DeusChestPreloadExtension.get_chest_type = function (self)
	-- function 6
	return self._chest_type
end

DeusChestPreloadExtension._generate_stored_weapon_packages = function (self, arg_7_1)
	-- function 7
	table.clear(self._weapon_preload_packages)

	local get_stored_purchase = self._pickup_extension:get_stored_purchase()
	local var_7_1 = fn(get_stored_purchase, arg_7_1)

	table.append(self._weapon_preload_packages, var_7_1)
end

DeusChestPreloadExtension._generate_upgraded_weapon_packages = function (self)
	-- function 8
	local _deus_run_controller = self._deus_run_controller
	local get_own_peer_id = _deus_run_controller:get_own_peer_id()
	local get_player_profile, var_8_3 = _deus_run_controller:get_player_profile(get_own_peer_id, num)
	local get_own_loadout_serialized, var_8_5 = _deus_run_controller:get_own_loadout_serialized()
	local flag = get_own_loadout_serialized ~= self._previous_melee_weapon
	local flag_2 = var_8_5 ~= self._previous_ranged_weapon

	if flag or not flag_2 then
		local get_own_loadout, var_8_9 = _deus_run_controller:get_own_loadout()
		local get_rarity = self._pickup_extension:get_rarity()

		if not flag then
			self._stored_melee_upgrade = self:_generate_upgraded_weapon(get_own_loadout, get_rarity, self._go_id, get_player_profile, var_8_3)
			self._previous_melee_weapon = get_own_loadout_serialized
		end

		if not flag_2 then
			self._stored_ranged_upgrade = self:_generate_upgraded_weapon(var_8_9, get_rarity, self._go_id, get_player_profile, var_8_3)
			self._previous_ranged_weapon = var_8_5
		end

		local _weapon_preload_packages = self._weapon_preload_packages

		table.clear(_weapon_preload_packages)
		table.append(_weapon_preload_packages, fn(self._stored_melee_upgrade))
		table.append(_weapon_preload_packages, fn(self._stored_ranged_upgrade))
	end
end

DeusChestPreloadExtension._generate_upgraded_weapon = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local _deus_run_controller = self._deus_run_controller
	local get_current_node = _deus_run_controller:get_current_node()
	local run_progress = get_current_node.run_progress
	local get_run_difficulty = _deus_run_controller:get_run_difficulty()
	local fnv32_hash = HashUtils.fnv32_hash(string.format("%s_%s_%s_%s_%s", arg_9_4, arg_9_5, get_current_node.weapon_pickup_seed, arg_9_3, 1))

	return (DeusWeaponGeneration.upgrade_item(arg_9_1, get_run_difficulty, run_progress, arg_9_2, fnv32_hash))
end

DeusChestPreloadExtension._get_server_chest_type = function (arg_10_0, arg_10_1)
	-- function 10
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_10_1)

	if not (not game and go_id) then
		return nil
	end

	local game_object_field = GameSession.game_object_field(game, go_id, "server_chest_type")
	local var_10_3

	if game_object_field ~= 0 then
		var_10_3 = NetworkLookup.deus_chest_types[game_object_field]

		if not var_10_3 then
			-- Nothing
		end
	end

	var_10_3 = nil

	::label_10_0::

	return var_10_3
end
