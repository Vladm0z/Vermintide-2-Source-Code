-- chunkname: @scripts/imgui/imgui_boons_debug.lua

ImguiBoonsDebug = class(ImguiBoonsDebug)

local SHOULD_RELOAD = true

ImguiBoonsDebug.init = function (self)
	-- function 1
	self._selected_boon_id = 1
	self._filter_text = ""
	self._boon_list = {}
	self._filtered_boon_list = {}

	self:_get_boons()

	self._filtered_boon_list = self:_apply_boon_filter(self._filter_text, self._boon_list)
end

ImguiBoonsDebug._get_boons = function (self)
	-- function 2
	table.clear(self._boon_list)

	for name, template in pairs(DeusPowerUpTemplates) do
		table.insert(self._boon_list, name)
	end

	table.sort(self._boon_list)
end

ImguiBoonsDebug._apply_boon_filter = function (self, filter_text, boon_list)
	-- function 3
	if filter_text == "" then
		return boon_list
	end

	local filtered_list = {}
	local search_string = string.gsub(filter_text, "[_ ]", "")

	for i = 1, #boon_list do
		local boon = boon_list[i]
		local search_boon_name = string.gsub(boon, "[_ ]", "")

		if search_boon_name:find(search_string, 1, true) then
			table.insert(filtered_list, boon)
		end
	end

	return filtered_list
end

ImguiBoonsDebug.update = function (self)
	-- function 4
	if SHOULD_RELOAD then
		self:init()

		SHOULD_RELOAD = false
	end
end

ImguiBoonsDebug.on_round_start = function (self)
	-- function 5
	return
end

ImguiBoonsDebug.is_persistent = function (self)
	-- function 6
	return true
end

ImguiBoonsDebug.draw = function (self, is_open)
	-- function 7
	local do_close = Imgui.begin_window("Boons Debug", "always_auto_resize")

	self:_update_controls()
	Imgui.end_window()

	return do_close
end

ImguiBoonsDebug._update_controls = function (self)
	-- function 8
	local mechanism_name = Managers.mechanism:current_mechanism_name()

	if mechanism_name ~= "deus" then
		Imgui.text("This UI only works when playing with the deus mechanism.")

		return
	end

	local aliases = self:_fetch_aliases(self._boon_list)

	self._selected_boon_id, self._filtered_boon_list, self._filter_text = ImguiX.combo_search(self._selected_boon_id, self._filtered_boon_list, self._filter_text, self._boon_list, aliases)

	if Imgui.button("Add", 100, 20) then
		local player = Managers.player

		if player then
			-- Nothing
		end

		player = Managers.player:local_player()

		local local_player = player

		::label_8_0::

		if not local_player then
			return
		end

		local power_up_name = self._filtered_boon_list[self._selected_boon_id]

		if not power_up_name then
			return
		end

		local power_up_rarity

		for rarity, boon_definitions in pairs(DeusPowerUpRarityPool) do
			for i = 1, #boon_definitions do
				if boon_definitions[i][1] == power_up_name then
					power_up_rarity = rarity

					break
				end
			end

			if power_up_rarity then
				break
			end
		end

		if not power_up_rarity then
			return
		end

		local deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local power_up = DeusPowerUpUtils.generate_specific_power_up(power_up_name, power_up_rarity)
		local local_player_id = local_player:local_player_id()

		deus_run_controller:add_power_ups({
			power_up
		}, local_player_id, true)
	end
end

ImguiBoonsDebug._fetch_aliases = function (self, boons)
	-- function 9
	local name_aliases = {}
	local description_aliases = {}
	local talent_tree, profile_name
	local local_player = Managers.player:local_player()

	if local_player then
		local profile_index = local_player:profile_index()
		local career_index = local_player:career_index()

		if (not not profile_index or not not 0) * (not not career_index or not not 0) > 0 then
			profile_name = SPProfiles[profile_index].display_name
			talent_tree = TalentTrees[profile_name][career_index]
		end
	end

	for i, boon_name in ipairs(boons) do
		local boon = DeusPowerUpTemplates[boon_name]

		if talent_tree and string.gmatch(boon_name, "%a+_%d+_%d+")() then
			local talent_parts = string.split(boon_name, "_")
			local talent_row = tonumber(talent_parts[2])
			local talent_col = tonumber(talent_parts[3])
			local talent_name = talent_tree[talent_row][talent_col]
			local talent = TalentUtils.get_talent(profile_name, talent_name)
			local var_9_0

			if talent.display_name then
				var_9_0 = Localize(talent.display_name)

				if not var_9_0 then
					-- Nothing
				end
			end

			var_9_0 = Localize(talent.name)

			::label_9_0::

			name_aliases[i] = var_9_0
			description_aliases[i] = UIUtils.get_talent_description(talent)
		else
			local var_9_1

			if boon.display_name then
				var_9_1 = Localize(boon.display_name)

				if not var_9_1 then
					-- Nothing
				end
			end

			var_9_1 = ""

			::label_9_1::

			name_aliases[i] = var_9_1

			local get_trait_description

			if boon.advanced_description then
				get_trait_description = UIUtils.get_trait_description(nil, boon)

				if not get_trait_description then
					-- Nothing
				end
			end

			get_trait_description = ""

			::label_9_2::

			description_aliases[i] = get_trait_description
		end
	end

	return {
		name_aliases,
		description_aliases
	}
end
