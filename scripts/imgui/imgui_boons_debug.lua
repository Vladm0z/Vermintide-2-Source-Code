-- chunkname: @scripts/imgui/imgui_boons_debug.lua

ImguiBoonsDebug = class(ImguiBoonsDebug)

local flag = true

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

	for k, v in pairs(DeusPowerUpTemplates) do
		table.insert(self._boon_list, k)
	end

	table.sort(self._boon_list)
end

ImguiBoonsDebug._apply_boon_filter = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	if arg_3_1 == "" then
		return arg_3_2
	end

	local tbl = {}
	local gsub = string.gsub(arg_3_1, "[_ ]", "")

	for i = 1, #arg_3_2 do
		local var_3_2 = arg_3_2[i]

		if not string.gsub(var_3_2, "[_ ]", ""):find(gsub, 1, true) then
			table.insert(tbl, var_3_2)
		end
	end

	return tbl
end

ImguiBoonsDebug.update = function (self)
	-- function 4
	if not flag then
		self:init()

		flag = false
	end
end

ImguiBoonsDebug.on_round_start = function (arg_5_0)
	-- function 5
	return
end

ImguiBoonsDebug.is_persistent = function (arg_6_0)
	-- function 6
	return true
end

ImguiBoonsDebug.draw = function (self, arg_7_1)
	-- function 7
	local begin_window = Imgui.begin_window("Boons Debug", "always_auto_resize")

	self:_update_controls()
	Imgui.end_window()

	return begin_window
end

ImguiBoonsDebug._update_controls = function (self)
	-- function 8
	if Managers.mechanism:current_mechanism_name() ~= "deus" then
		Imgui.text("This UI only works when playing with the deus mechanism.")

		return
	end

	local _fetch_aliases = self:_fetch_aliases(self._boon_list)

	self._selected_boon_id, self._filtered_boon_list, self._filter_text = ImguiX.combo_search(self._selected_boon_id, self._filtered_boon_list, self._filter_text, self._boon_list, _fetch_aliases)

	if not Imgui.button("Add", 100, 20) then
		local player = Managers.player

		player = not player and Managers.player:local_player()

		if not player then
			return
		end

		local var_8_2 = self._filtered_boon_list[self._selected_boon_id]

		if not var_8_2 then
			return
		end

		local var_8_3

		for k, v in pairs(DeusPowerUpRarityPool) do
			for k_2 = 1, #v do
				if v[k_2][1] == var_8_2 then
					var_8_3 = k

					break
				end
			end

			if not var_8_3 then
				break
			end
		end

		if not var_8_3 then
			return
		end

		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local generate_specific_power_up = DeusPowerUpUtils.generate_specific_power_up(var_8_2, var_8_3)
		local local_player_id = player:local_player_id()

		get_deus_run_controller:add_power_ups({
			generate_specific_power_up
		}, local_player_id, true)
	end
end

ImguiBoonsDebug._fetch_aliases = function (arg_9_0, arg_9_1)
	-- function 9
	local tbl = {}
	local tbl_2 = {}
	local var_9_2
	local var_9_3
	local local_player = Managers.player:local_player()

	if not local_player then
		local profile_index = local_player:profile_index()
		local career_index = local_player:career_index()

		if (profile_index or 0) * (career_index or 0) > 0 then
			var_9_3 = SPProfiles[profile_index].display_name
			var_9_2 = TalentTrees[var_9_3][career_index]
		end
	end

	for i, v in ipairs(arg_9_1) do
		local var_9_7 = DeusPowerUpTemplates[v]

		if not var_9_2 and not string.gmatch(v, "%a+_%d+_%d+")() then
			local split = string.split(v, "_")
			local var_9_9 = tonumber(split[2])
			local var_9_10 = tonumber(split[3])
			local var_9_11 = var_9_2[var_9_9][var_9_10]
			local get_talent = TalentUtils.get_talent(var_9_3, var_9_11)
			local var_9_13

			if not get_talent.display_name then
				var_9_13 = Localize(get_talent.display_name)

				if not var_9_13 then
					-- Nothing
				end
			end

			var_9_13 = Localize(get_talent.name)

			::label_9_0::

			tbl[i] = var_9_13
			tbl_2[i] = UIUtils.get_talent_description(get_talent)
		else
			local var_9_14

			if not var_9_7.display_name then
				var_9_14 = Localize(var_9_7.display_name)

				if not var_9_14 then
					-- Nothing
				end
			end

			var_9_14 = ""

			::label_9_1::

			tbl[i] = var_9_14

			local get_trait_description

			if not var_9_7.advanced_description then
				get_trait_description = UIUtils.get_trait_description(nil, var_9_7)

				if not get_trait_description then
					-- Nothing
				end
			end

			get_trait_description = ""

			::label_9_2::

			tbl_2[i] = get_trait_description
		end
	end

	return {
		tbl,
		tbl_2
	}
end
