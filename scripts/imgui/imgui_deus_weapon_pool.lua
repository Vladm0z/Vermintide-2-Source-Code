-- chunkname: @scripts/imgui/imgui_deus_weapon_pool.lua

ImguiDeusWeaponPool = class(ImguiDeusWeaponPool)

function ImguiDeusWeaponPool.init(arg_1_0)
	return
end

function ImguiDeusWeaponPool.update(arg_2_0)
	return
end

function ImguiDeusWeaponPool.is_persistent(arg_3_0)
	return true
end

function ImguiDeusWeaponPool.draw(arg_4_0, arg_4_1)
	local var_4_0 = Imgui.begin_window("DeusWeaponPool", "always_auto_resize")
	local var_4_1 = DeusWeaponGroups
	local var_4_2 = Managers.state
	local var_4_3 = var_4_2 and var_4_2.game_mode

	if (var_4_3 and var_4_3:game_mode_key()) ~= "deus" then
		Imgui.text("This UI only works when playing in the deus game mode.")
	else
		local var_4_4 = Managers.mechanism:game_mechanism()
		local var_4_5 = RaritySettings
		local var_4_6 = var_4_4:get_deus_run_controller()
		local var_4_7 = var_4_6:get_weapon_pool()
		local var_4_8 = var_4_6:get_base_weapon_pool()
		local var_4_9 = 0

		for iter_4_0, iter_4_1 in pairs(var_4_8) do
			local var_4_10 = table.size(iter_4_1)

			if var_4_9 < var_4_10 then
				var_4_9 = var_4_10
			end
		end

		local var_4_11 = table.keys(var_4_8)

		table.sort(var_4_11, function(arg_5_0, arg_5_1)
			return var_4_5[arg_5_0].order < var_4_5[arg_5_1].order
		end)

		for iter_4_2, iter_4_3 in ipairs(var_4_11) do
			local var_4_12 = 120 + var_4_9 * 25

			Imgui.begin_child_window("Panel_" .. iter_4_3, 300, var_4_12, true)

			local var_4_13 = Colors.get_table(iter_4_3)

			Imgui.text_colored(string.upper(iter_4_3), var_4_13[2], var_4_13[3], var_4_13[4], var_4_13[1])

			local var_4_14 = {}

			for iter_4_4, iter_4_5 in pairs(var_4_8[iter_4_3]) do
				local var_4_15 = var_4_7[iter_4_3][iter_4_4]
				local var_4_16 = var_4_15 and "-" or "+"
				local var_4_17 = var_4_15 and Colors.get_table("white") or Colors.get_table("gray")
				local var_4_18 = var_4_1[iter_4_4].slot_type
				local var_4_19 = var_4_18 == "melee" and 1 or 0
				local var_4_20 = {
					weapon_key = iter_4_5,
					button_text = var_4_16,
					in_pool = var_4_15,
					text_color = var_4_17,
					slot_type = var_4_18,
					order = var_4_19
				}

				table.insert(var_4_14, var_4_20)
			end

			table.sort(var_4_14, function(arg_6_0, arg_6_1)
				return arg_6_0.order > arg_6_1.order
			end)

			local var_4_21 = false
			local var_4_22 = false

			for iter_4_6, iter_4_7 in ipairs(var_4_14) do
				local var_4_23 = iter_4_7.weapon_key

				if iter_4_7.slot_type == "melee" and not var_4_21 then
					var_4_21 = true

					Imgui.text("MELEE")
				elseif iter_4_7.slot_type == "ranged" and not var_4_22 then
					var_4_22 = true

					Imgui.text("RANGED")
				end

				Imgui.tree_push(var_4_23)

				if Imgui.button(iter_4_7.button_text, 20, 20) then
					if iter_4_7.in_pool then
						var_4_6:debug_remove_weapon_from_pool(iter_4_3, var_4_23)
					else
						var_4_6:debug_add_weapon_to_pool(iter_4_3, var_4_23)
					end
				end

				Imgui.same_line()

				local var_4_24 = iter_4_7.text_color

				Imgui.text_colored(var_4_23, var_4_24[2], var_4_24[3], var_4_24[4], var_4_24[1])
				Imgui.tree_pop()
			end

			Imgui.end_child_window()
			Imgui.same_line()
		end
	end

	Imgui.end_window()

	return var_4_0
end
