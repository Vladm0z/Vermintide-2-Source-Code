-- chunkname: @scripts/imgui/imgui_deus_weapon_pool.lua

ImguiDeusWeaponPool = class(ImguiDeusWeaponPool)

ImguiDeusWeaponPool.init = function (arg_1_0)
	-- function 1
	return
end

ImguiDeusWeaponPool.update = function (arg_2_0)
	-- function 2
	return
end

ImguiDeusWeaponPool.is_persistent = function (arg_3_0)
	-- function 3
	return true
end

ImguiDeusWeaponPool.draw = function (arg_4_0, arg_4_1)
	-- function 4
	local begin_window = Imgui.begin_window("DeusWeaponPool", "always_auto_resize")
	local DeusWeaponGroups = DeusWeaponGroups
	local state = Managers.state
	local flag = not state and state.game_mode

	if (not flag and flag:game_mode_key()) ~= "deus" then
		Imgui.text("This UI only works when playing in the deus game mode.")
	else
		local game_mechanism = Managers.mechanism:game_mechanism()
		local RaritySettings = RaritySettings
		local get_deus_run_controller = game_mechanism:get_deus_run_controller()
		local get_weapon_pool = get_deus_run_controller:get_weapon_pool()
		local get_base_weapon_pool = get_deus_run_controller:get_base_weapon_pool()
		local num = 0

		for k, v in pairs(get_base_weapon_pool) do
			local size = table.size(v)

			if num < size then
				num = size
			end
		end

		local keys = table.keys(get_base_weapon_pool)

		table.sort(keys, function (arg_5_0, arg_5_1)
			-- function 5
			return RaritySettings[arg_5_0].order < RaritySettings[arg_5_1].order
		end)

		for i, v_2 in ipairs(keys) do
			local num_2 = 120 + num * 25

			Imgui.begin_child_window("Panel_" .. v_2, 300, num_2, true)

			local get_table = Colors.get_table(v_2)

			Imgui.text_colored(string.upper(v_2), get_table[2], get_table[3], get_table[4], get_table[1])

			local tbl = {}

			for k_2, v_3 in pairs(get_base_weapon_pool[v_2]) do
				local var_4_15 = get_weapon_pool[v_2][k_2]
				local flag_2

				flag_2 = not var_4_15 and "-" and "+"

				local get_table_2

				if not var_4_15 then
					get_table_2 = Colors.get_table("white")

					if not get_table_2 then
						-- Nothing
					end
				end

				get_table_2 = Colors.get_table("gray")

				::label_4_0::

				local slot_type = DeusWeaponGroups[k_2].slot_type
				local flag_3

				flag_3 = slot_type ~= "melee" or not 1 or 0

				local tbl_2 = {
					weapon_key = v_3,
					button_text = flag_2,
					in_pool = var_4_15,
					text_color = get_table_2,
					slot_type = slot_type,
					order = flag_3
				}

				table.insert(tbl, tbl_2)
			end

			table.sort(tbl, function (self, arg_6_1)
				-- function 6
				return self.order > arg_6_1.order
			end)

			local flag_4 = false
			local flag_5 = false

			for i_2, v_4 in ipairs(tbl) do
				local weapon_key = v_4.weapon_key

				if not (v_4.slot_type ~= "melee" or flag_4) then
					flag_4 = true

					Imgui.text("MELEE")
				elseif not (v_4.slot_type ~= "ranged" or flag_5) then
					flag_5 = true

					Imgui.text("RANGED")
				end

				Imgui.tree_push(weapon_key)

				if not Imgui.button(v_4.button_text, 20, 20) then
					if not v_4.in_pool then
						get_deus_run_controller:debug_remove_weapon_from_pool(v_2, weapon_key)
					else
						get_deus_run_controller:debug_add_weapon_to_pool(v_2, weapon_key)
					end
				end

				Imgui.same_line()

				local text_color = v_4.text_color

				Imgui.text_colored(weapon_key, text_color[2], text_color[3], text_color[4], text_color[1])
				Imgui.tree_pop()
			end

			Imgui.end_child_window()
			Imgui.same_line()
		end
	end

	Imgui.end_window()

	return begin_window
end
