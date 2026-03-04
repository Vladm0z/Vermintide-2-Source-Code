-- chunkname: @scripts/imgui/imgui_boons_debug.lua

ImguiBoonsDebug = class(ImguiBoonsDebug)

local var_0_0 = true

function ImguiBoonsDebug.init(arg_1_0)
	arg_1_0._selected_boon_id = 1
	arg_1_0._filter_text = ""
	arg_1_0._boon_list = {}
	arg_1_0._filtered_boon_list = {}

	arg_1_0:_get_boons()

	arg_1_0._filtered_boon_list = arg_1_0:_apply_boon_filter(arg_1_0._filter_text, arg_1_0._boon_list)
end

function ImguiBoonsDebug._get_boons(arg_2_0)
	table.clear(arg_2_0._boon_list)

	for iter_2_0, iter_2_1 in pairs(DeusPowerUpTemplates) do
		table.insert(arg_2_0._boon_list, iter_2_0)
	end

	table.sort(arg_2_0._boon_list)
end

function ImguiBoonsDebug._apply_boon_filter(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 == "" then
		return arg_3_2
	end

	local var_3_0 = {}
	local var_3_1 = string.gsub(arg_3_1, "[_ ]", "")

	for iter_3_0 = 1, #arg_3_2 do
		local var_3_2 = arg_3_2[iter_3_0]

		if string.gsub(var_3_2, "[_ ]", ""):find(var_3_1, 1, true) then
			table.insert(var_3_0, var_3_2)
		end
	end

	return var_3_0
end

function ImguiBoonsDebug.update(arg_4_0)
	if var_0_0 then
		arg_4_0:init()

		var_0_0 = false
	end
end

function ImguiBoonsDebug.on_round_start(arg_5_0)
	return
end

function ImguiBoonsDebug.is_persistent(arg_6_0)
	return true
end

function ImguiBoonsDebug.draw(arg_7_0, arg_7_1)
	local var_7_0 = Imgui.begin_window("Boons Debug", "always_auto_resize")

	arg_7_0:_update_controls()
	Imgui.end_window()

	return var_7_0
end

function ImguiBoonsDebug._update_controls(arg_8_0)
	if Managers.mechanism:current_mechanism_name() ~= "deus" then
		Imgui.text("This UI only works when playing with the deus mechanism.")

		return
	end

	local var_8_0 = arg_8_0:_fetch_aliases(arg_8_0._boon_list)

	arg_8_0._selected_boon_id, arg_8_0._filtered_boon_list, arg_8_0._filter_text = ImguiX.combo_search(arg_8_0._selected_boon_id, arg_8_0._filtered_boon_list, arg_8_0._filter_text, arg_8_0._boon_list, var_8_0)

	if Imgui.button("Add", 100, 20) then
		local var_8_1 = Managers.player and Managers.player:local_player()

		if not var_8_1 then
			return
		end

		local var_8_2 = arg_8_0._filtered_boon_list[arg_8_0._selected_boon_id]

		if not var_8_2 then
			return
		end

		local var_8_3

		for iter_8_0, iter_8_1 in pairs(DeusPowerUpRarityPool) do
			for iter_8_2 = 1, #iter_8_1 do
				if iter_8_1[iter_8_2][1] == var_8_2 then
					var_8_3 = iter_8_0

					break
				end
			end

			if var_8_3 then
				break
			end
		end

		if not var_8_3 then
			return
		end

		local var_8_4 = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local var_8_5 = DeusPowerUpUtils.generate_specific_power_up(var_8_2, var_8_3)
		local var_8_6 = var_8_1:local_player_id()

		var_8_4:add_power_ups({
			var_8_5
		}, var_8_6, true)
	end
end

function ImguiBoonsDebug._fetch_aliases(arg_9_0, arg_9_1)
	local var_9_0 = {}
	local var_9_1 = {}
	local var_9_2
	local var_9_3
	local var_9_4 = Managers.player:local_player()

	if var_9_4 then
		local var_9_5 = var_9_4:profile_index()
		local var_9_6 = var_9_4:career_index()

		if (var_9_5 or 0) * (var_9_6 or 0) > 0 then
			var_9_3 = SPProfiles[var_9_5].display_name
			var_9_2 = TalentTrees[var_9_3][var_9_6]
		end
	end

	for iter_9_0, iter_9_1 in ipairs(arg_9_1) do
		local var_9_7 = DeusPowerUpTemplates[iter_9_1]

		if var_9_2 and string.gmatch(iter_9_1, "%a+_%d+_%d+")() then
			local var_9_8 = string.split(iter_9_1, "_")
			local var_9_9 = tonumber(var_9_8[2])
			local var_9_10 = tonumber(var_9_8[3])
			local var_9_11 = var_9_2[var_9_9][var_9_10]
			local var_9_12 = TalentUtils.get_talent(var_9_3, var_9_11)

			var_9_0[iter_9_0] = var_9_12.display_name and Localize(var_9_12.display_name) or Localize(var_9_12.name)
			var_9_1[iter_9_0] = UIUtils.get_talent_description(var_9_12)
		else
			var_9_0[iter_9_0] = var_9_7.display_name and Localize(var_9_7.display_name) or ""
			var_9_1[iter_9_0] = var_9_7.advanced_description and UIUtils.get_trait_description(nil, var_9_7) or ""
		end
	end

	return {
		var_9_0,
		var_9_1
	}
end
