-- chunkname: @scripts/imgui/imgui_deus_weapons.lua

ImguiDeusWeapons = class(ImguiDeusWeapons)

local tbl = {
	"plentiful",
	"common",
	"rare",
	"exotic",
	"unique"
}
local tbl_2 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	arg_1_1 = Imgui.combo("Select weapon group", arg_1_1, arg_1_0)
	arg_1_3 = Imgui.combo("Select rarity", arg_1_3, arg_1_2)
	arg_1_5 = Imgui.combo("Select difficulty (affects powerlevel)", arg_1_5, arg_1_4)
	arg_1_6 = Imgui.slider_float("Run progress (affects powerlevel)", arg_1_6, 0, 0.999)

	return arg_1_1, arg_1_3, arg_1_5, arg_1_6
end

local function fn_2(self, arg_2_1, arg_2_2)
	-- function 2
	local get_interface = Managers.backend:get_interface("deus")

	get_interface:grant_deus_weapon(self)
	get_interface:refresh_deus_weapons_in_items_backend()

	local backend_id = self.backend_id
	local slot_type = self.data.slot_type
	local var_2_3
	local slots_by_slot_index = InventorySettings.slots_by_slot_index

	for k, v in pairs(slots_by_slot_index) do
		if slot_type == v.type then
			var_2_3 = v.name
		end
	end

	BackendUtils.set_loadout_item(backend_id, arg_2_1, var_2_3)
	arg_2_2:create_equipment_in_slot(var_2_3, backend_id)
end

local function fn_3(self)
	-- function 3
	local get_ui_information_from_item, var_3_1, var_3_2, var_3_3 = UIUtils.get_ui_information_from_item(self)
	local get_table = Colors.get_table(self.rarity)

	Imgui.text_colored(" === " .. Localize(var_3_1) .. " === ", get_table[2], get_table[3], get_table[4], get_table[1])
	Imgui.spacing()
	Imgui.text("type: " .. Localize(self.data.item_type))
	Imgui.text("slot: " .. self.data.slot_type)
	Imgui.text("rarity: " .. self.rarity)
	Imgui.text("power_level: " .. self.power_level)

	if not self.traits then
		Imgui.text("traits:")

		for i, v in ipairs(self.traits) do
			Imgui.text("  - " .. v)
		end
	end

	if not self.properties then
		Imgui.text("props:")

		for k, v_2 in pairs(self.properties) do
			Imgui.text("  - " .. k .. ": " .. v_2)
		end
	end

	if not self.skin then
		Imgui.text("skin: " .. self.skin)
	end
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	for i, v in ipairs(arg_4_0) do
		if not arg_4_2[v] then
			arg_4_2[v] = 0.75
		end

		if arg_4_1 == "unique" then
			arg_4_2[v] = 1
		else
			local slider_float = Imgui.slider_float("Set Property " .. v .. " power", arg_4_2[v], 0, 1)

			arg_4_2[v] = math.round_with_precision(slider_float, 3)
		end
	end

	return arg_4_2
end

local function fn_5(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local get_weapon_pool = self:get_weapon_pool()
	local get_slot_chances, var_5_2 = self:get_slot_chances()
	local random_seed = math.random_seed()
	local generate_weapon = DeusWeaponGeneration.generate_weapon(arg_5_4, arg_5_3, arg_5_2, random_seed, get_weapon_pool, get_slot_chances, var_5_2)

	self:remove_weapon_from_pool(arg_5_2, generate_weapon.deus_item_key)
	fn_2(generate_weapon, arg_5_5, arg_5_1)
end

ImguiDeusWeapons.init = function (self)
	-- function 6
	self._next_weapon_time = 0
end

ImguiDeusWeapons.update = function (self)
	-- function 7
	local local_human_player = Managers.player:local_human_player()

	if not local_human_player then
		return
	end

	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism then
		-- Nothing
	end

	::label_7_0::

	local get_deus_run_controller = game_mechanism.get_deus_run_controller

	get_deus_run_controller = not get_deus_run_controller and game_mechanism:get_deus_run_controller()

	::label_7_1::

	if not get_deus_run_controller then
		return
	end

	local profile_index = local_human_player:profile_index()
	local career_index = local_human_player:career_index()

	if not career_index then
		return
	end

	if not (self._career_index ~= career_index or self._profile_index == profile_index) then
		local name = SPProfiles[profile_index].careers[career_index].name

		self._available_weapon_groups = {}

		for k, v in pairs(DeusWeaponGroups) do
			local var_7_6 = DeusWeaponGroups[k]

			if not var_7_6 and not table.contains(var_7_6.can_wield, name) then
				self._available_weapon_groups[#self._available_weapon_groups + 1] = k
			end
		end

		self._career_index = career_index
		self._profile_index = profile_index
		self._career_name = name

		self:_reset_base_weapon_selection_data()
	end

	if not self._equip_random_weapon then
		local time = Managers.time:time("game")

		if time > self._next_weapon_time then
			local _get_inventory_extension = self:_get_inventory_extension()

			if not (not _get_inventory_extension and _get_inventory_extension:resyncing_loadout()) then
				local var_7_9 = fn_5
				local var_7_10 = get_deus_run_controller
				local var_7_11 = _get_inventory_extension
				local var_7_12 = tbl
				local _selected_rarity_index = self._selected_rarity_index

				_selected_rarity_index = _selected_rarity_index or 1

				local var_7_14 = var_7_12[_selected_rarity_index]
				local _run_progress = self._run_progress

				_run_progress = _run_progress or 0

				local var_7_16 = tbl_2
				local _difficulty_index = self._difficulty_index

				_difficulty_index = _difficulty_index or 1

				var_7_9(var_7_10, var_7_11, var_7_14, _run_progress, var_7_16[_difficulty_index], self._career_name)
			end

			self._next_weapon_time = time + 2
		end
	end
end

ImguiDeusWeapons.on_round_end = function (self, ...)
	-- function 8
	self._equip_random_weapon = false
end

ImguiDeusWeapons.on_venture_end = function (self, ...)
	-- function 9
	self._equip_random_weapon = false
end

ImguiDeusWeapons.is_persistent = function (arg_10_0)
	-- function 10
	return false
end

ImguiDeusWeapons.draw = function (self, arg_11_1)
	-- function 11
	if not (not Managers.state and not Managers.state.game_mode and Managers.state.game_mode:game_mode_key() == "deus") then
		local begin_window = Imgui.begin_window("DeusWeapons", "always_auto_resize")

		Imgui.text("This UI only works when playing a deus level.")
		Imgui.end_window()

		return begin_window
	end

	local begin_window_2 = Imgui.begin_window("DeusWeapons", "always_auto_resize")

	Imgui.spacing()
	Imgui.text("Select Weapon Group:")

	self._selected_weapon_group_index, self._selected_rarity_index, self._difficulty_index, self._run_progress = fn(self._available_weapon_groups, self._selected_weapon_group_index, tbl, self._selected_rarity_index, tbl_2, self._difficulty_index, self._run_progress)

	local var_11_2 = DeusWeaponGroups[self._available_weapon_groups[self._selected_weapon_group_index]]
	local var_11_3 = tbl_2[self._difficulty_index]
	local var_11_4 = tbl[self._selected_rarity_index]
	local var_11_5 = var_11_2.items_per_rarity[var_11_4]
	local flag = not var_11_5 and #var_11_5 > 0 and var_11_5 and {
		var_11_2.default
	}

	Imgui.spacing()
	Imgui.text("Select Item From Group:")

	self._selected_item_key_index = Imgui.combo("Select item key", self._selected_item_key_index, flag)

	local var_11_7 = flag[self._selected_item_key_index]

	if not (self._prev_item_key ~= var_11_7 or self._prev_difficulty_index ~= self._difficulty_index or self._prev_rarity ~= var_11_4 or self._prev_run_progress == self._run_progress) then
		self:_reset_weapon_setting_data(var_11_7, var_11_3, self._run_progress, var_11_4)

		self._prev_item_key = var_11_7
		self._prev_difficulty_index = self._difficulty_index
		self._prev_rarity = var_11_4
		self._prev_run_progress = self._run_progress
	end

	local _available_archetypes = self._available_archetypes

	_available_archetypes = not _available_archetypes and #self._available_archetypes > 0

	local _available_property_combinations = self._available_property_combinations

	_available_property_combinations = not _available_property_combinations and #self._available_property_combinations > 0

	local _available_trait_combinations = self._available_trait_combinations

	_available_trait_combinations = not _available_trait_combinations and #self._available_trait_combinations > 0

	local _available_skins = self._available_skins

	_available_skins = not _available_skins and #self._available_skins > 0

	if _available_archetypes or _available_property_combinations or _available_trait_combinations or not _available_skins then
		Imgui.spacing()
		Imgui.text("Select Properties, Traits and/or Skins:")
	end

	if not _available_archetypes then
		self._selected_archetype_index = Imgui.combo("Select archetype", self._selected_archetype_index, self._available_archetypes)

		local var_11_12 = DeusWeaponArchetypes[self._available_archetypes[self._selected_archetype_index]]

		self._properties = var_11_12.properties
		self._traits = var_11_12.traits
	end

	if not _available_property_combinations then
		self._selected_property_index = Imgui.combo("Select property combination", self._selected_property_index, self._available_property_combinations_string)

		if self._prev_selected_property_index ~= self._selected_property_index then
			self._properties = {}
		end

		self._prev_selected_property_index = self._selected_property_index

		local var_11_13 = self._available_property_combinations[self._selected_property_index]

		self._properties = fn_4(var_11_13, var_11_4, self._properties)
	end

	if not _available_trait_combinations then
		self._selected_trait_index = Imgui.combo("Select trait", self._selected_trait_index, self._available_trait_combinations_string)
		self._traits = self._available_trait_combinations[self._selected_trait_index]
	end

	if not _available_skins then
		self._selected_skin_index = Imgui.combo("Select skin", self._selected_skin_index, self._available_skins)
		self._skin = self._available_skins[self._selected_skin_index]
	end

	Imgui.spacing()

	local flag_2 = not self._weapon

	flag_2 = flag_2 or self._weapon.deus_item_key ~= var_11_7

	for k, v in pairs(self._properties) do
		flag_2 = flag_2 or self._weapon.properties[k] ~= self._properties[k]
	end

	flag_2 = flag_2 or not table.compare(self._weapon.traits, self._traits)
	flag_2 = flag_2 or self._weapon.skin ~= self._skin
	flag_2 = flag_2 or self._weapon.rarity ~= var_11_4
	flag_2 = flag_2 or self._weapon.power_level ~= self._powerlevel

	if not flag_2 then
		local create_weapon = DeusWeaponGeneration.create_weapon
		local var_11_16 = var_11_7
		local _properties = self._properties

		_properties = not _properties and table.clone(self._properties)

		local _traits = self._traits

		_traits = not _traits and table.clone(self._traits)
		self._weapon = create_weapon(var_11_16, _properties, _traits, self._skin, self._powerlevel, var_11_4)
	end

	if not self._weapon then
		Imgui.text("Weapon:")
		fn_3(self._weapon)
	end

	Imgui.spacing()

	if not self._weapon and not Imgui.button("Equip") then
		local _get_inventory_extension = self:_get_inventory_extension()

		if not (not _get_inventory_extension and _get_inventory_extension:resyncing_loadout()) then
			fn_2(self._weapon, self._career_name, _get_inventory_extension)

			local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
			local slot_type = self._weapon.data.slot_type
			local var_11_22
			local slots_by_slot_index = InventorySettings.slots_by_slot_index

			for k_2, v_2 in pairs(slots_by_slot_index) do
				if slot_type == v_2.type then
					var_11_22 = v_2.name
				end
			end

			get_deus_run_controller:save_loadout(self._weapon, var_11_22)
		end
	end

	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()

	local checkbox = Imgui.checkbox
	local str = "equip random weapons automatically"
	local _equip_random_weapon = self._equip_random_weapon

	_equip_random_weapon = _equip_random_weapon or false
	self._equip_random_weapon = checkbox(str, _equip_random_weapon)

	Imgui.end_window()

	return begin_window_2
end

ImguiDeusWeapons._reset_base_weapon_selection_data = function (self)
	-- function 12
	self._selected_weapon_group_index = 1
	self._selected_rarity_index = 1
	self._selected_item_key_index = 1
	self._difficulty_index = 1
	self._run_progress = 0
	self._weapon = nil
end

ImguiDeusWeapons._reset_weapon_setting_data = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	self._powerlevel, self._available_archetypes, self._available_property_combinations, self._available_trait_combinations, self._available_skins = DeusWeaponGeneration.get_possibilities_for_item_key(arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	self._run_progress = arg_13_3
	self._available_property_combinations_string = {}

	if not self._available_property_combinations then
		for i, v in ipairs(self._available_property_combinations) do
			self._available_property_combinations_string[#self._available_property_combinations_string + 1] = table.concat(v, ", ")
		end
	end

	self._available_trait_combinations_string = {}

	if not self._available_trait_combinations then
		for i_2, v_2 in ipairs(self._available_trait_combinations) do
			self._available_trait_combinations_string[#self._available_trait_combinations_string + 1] = table.concat(v_2, ", ")
		end
	end

	self._selected_archetype_index = 1
	self._selected_property_index = 1
	self._selected_trait_index = 1
	self._selected_skin_index = 1
	self._properties = {}
	self._traits = {}
	self._skin = nil
end

ImguiDeusWeapons._get_inventory_extension = function (arg_14_0)
	-- function 14
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local player_unit = local_player.player_unit

	if not player_unit then
		return
	end

	return (ScriptUnit.extension(player_unit, "inventory_system"))
end
