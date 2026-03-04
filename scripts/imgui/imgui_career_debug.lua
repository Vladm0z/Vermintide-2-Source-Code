-- chunkname: @scripts/imgui/imgui_career_debug.lua

ImguiCareerDebug = class(ImguiCareerDebug)

local var_0_0 = true
local var_0_1 = 820
local var_0_2 = 500
local var_0_3 = 8
local var_0_4 = {}

for iter_0_0 = 0, var_0_3 do
	var_0_4[iter_0_0 + 1] = tostring(iter_0_0)
end

ImguiCareerDebug.init = function (arg_1_0)
	arg_1_0._first_run = true
	arg_1_0._is_persistent = false
	arg_1_0._indent_counter = 0
	arg_1_0._players = {}
	arg_1_0._profiles = {}
	arg_1_0._careers = {}

	arg_1_0:register_events()

	var_0_0 = false
end

ImguiCareerDebug._get_profile_requester = function (arg_2_0)
	if arg_2_0._profile_requester then
		return arg_2_0._profile_requester
	end

	local var_2_0 = Managers.state.network

	if var_2_0 then
		local var_2_1 = var_2_0.network_server or var_2_0.network_client

		arg_2_0._profile_requester = var_2_1 and var_2_1:profile_requester()
	end

	return arg_2_0._profile_requester
end

ImguiCareerDebug._get_profile_synchronizer = function (arg_3_0)
	if arg_3_0._profile_synchronizer then
		return arg_3_0._profile_synchronizer
	end

	local var_3_0 = Managers.state.network

	if var_3_0 then
		local var_3_1 = var_3_0.network_server or var_3_0.network_client

		arg_3_0._profile_synchronizer = var_3_1 and var_3_1.profile_synchronizer
	end

	return arg_3_0._profile_synchronizer
end

ImguiCareerDebug.destroy = function (arg_4_0)
	arg_4_0:unregister_events()
end

ImguiCareerDebug.register_events = function (arg_5_0)
	if Managers.state.event then
		-- Nothing
	end
end

ImguiCareerDebug.unregister_events = function (arg_6_0)
	if Managers.state.event then
		-- Nothing
	end
end

ImguiCareerDebug.is_persistent = function (arg_7_0)
	return arg_7_0._is_persistent
end

ImguiCareerDebug.update = function (arg_8_0)
	if var_0_0 then
		arg_8_0:unregister_events()
		arg_8_0:init()
	end

	arg_8_0:_update_profiles_and_careers()
	arg_8_0:_update_players()
end

ImguiCareerDebug._update_profiles_and_careers = function (arg_9_0)
	arg_9_0._profiles = {}
	arg_9_0._careers = {}

	for iter_9_0, iter_9_1 in pairs(SPProfiles) do
		arg_9_0._profiles[iter_9_0] = iter_9_1.display_name
		arg_9_0._careers[iter_9_0] = {}

		for iter_9_2, iter_9_3 in pairs(iter_9_1.careers) do
			arg_9_0._careers[iter_9_0][iter_9_2] = iter_9_3.display_name
		end
	end
end

ImguiCareerDebug._update_players = function (arg_10_0)
	arg_10_0._players = Managers.player:players()
end

ImguiCareerDebug.draw = function (arg_11_0)
	if arg_11_0._first_run then
		Imgui.set_next_window_size(var_0_1, var_0_2)

		arg_11_0._first_run = false
	end

	local var_11_0 = Imgui.begin_window("Career Debug")

	arg_11_0._is_persistent = Imgui.checkbox("Keep Window Open", arg_11_0._is_persistent)

	Imgui.same_line()
	Imgui.push_item_width(100)

	script_data.cap_num_bots = Imgui.combo("Num bots", (script_data.cap_num_bots or var_0_3) + 1, var_0_4) - 1

	Imgui.pop_item_width()
	Imgui.separator()
	arg_11_0:_draw_players()
	arg_11_0:_verify_indent()
	Imgui.end_window()

	return var_11_0
end

local var_0_5 = {
	"Name",
	"Profile",
	"Career",
	"Is Bot",
	"Is Server"
}

ImguiCareerDebug._draw_players = function (arg_12_0)
	arg_12_0:_set_columns(5, true, 164)

	for iter_12_0, iter_12_1 in pairs(var_0_5) do
		Imgui.text(iter_12_1)
		Imgui.next_column()
	end

	local var_12_0 = Managers.mechanism:server_peer_id()

	for iter_12_2, iter_12_3 in pairs(arg_12_0._players) do
		local var_12_1 = iter_12_3.peer_id == var_12_0

		Imgui.tree_push(iter_12_2)
		Imgui.text(iter_12_3:name())
		Imgui.next_column()
		arg_12_0:_draw_profile_combo(iter_12_3)
		Imgui.next_column()
		arg_12_0:_draw_career_combo(iter_12_3)
		Imgui.next_column()
		Imgui.text(tostring(iter_12_3.bot_player or not iter_12_3:is_player_controlled() or false))
		Imgui.next_column()
		Imgui.text(tostring(var_12_1))
		Imgui.next_column()
		Imgui.tree_pop()
	end

	arg_12_0:_reset_columns()
end

ImguiCareerDebug._draw_profile_combo = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1:profile_index()

	Imgui.tree_push("profile")

	local var_13_1 = Imgui.combo("", var_13_0, arg_13_0._profiles)

	Imgui.tree_pop()

	if var_13_1 ~= var_13_0 then
		local var_13_2 = arg_13_0:_get_profile_requester()
		local var_13_3, var_13_4 = hero_and_career_name_from_index(var_13_1, 1)
		local var_13_5 = Network.peer_id()
		local var_13_6 = Managers.mechanism:reserved_party_id_by_peer(var_13_5)

		if not Managers.mechanism:profile_available_for_peer(var_13_6, var_13_5, var_13_1) then
			local var_13_7 = arg_13_0:_find_who_uses_profile(var_13_1)
			local var_13_8 = arg_13_0:_get_profile_synchronizer()
			local var_13_9 = 1
			local var_13_10, var_13_11 = var_13_8:get_first_free_profile(var_13_9)
			local var_13_12, var_13_13 = hero_and_career_name_from_index(var_13_10, var_13_11)

			var_13_2:request_profile(var_13_7.peer_id, var_13_7:local_player_id(), var_13_12, var_13_13, true)

			if var_13_7.bot_player then
				var_13_7.character_name = Localize(var_13_12)
			end
		end

		var_13_2:request_profile(arg_13_1.peer_id, arg_13_1:local_player_id(), var_13_3, var_13_4, true)

		if arg_13_1.bot_player then
			arg_13_1.character_name = Localize(var_13_3)
		end
	end
end

ImguiCareerDebug._draw_career_combo = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1:profile_index()
	local var_14_1 = arg_14_1:career_index()
	local var_14_2 = arg_14_0._careers[var_14_0]

	Imgui.tree_push("career")

	local var_14_3 = Imgui.combo("", var_14_1, var_14_2)

	Imgui.tree_pop()

	if var_14_3 ~= var_14_1 then
		local var_14_4 = arg_14_0:_get_profile_requester()
		local var_14_5, var_14_6 = hero_and_career_name_from_index(var_14_0, var_14_3)

		var_14_4:request_profile(arg_14_1.peer_id, arg_14_1:local_player_id(), var_14_5, var_14_6, true)
	end
end

ImguiCareerDebug._find_who_uses_profile = function (arg_15_0, arg_15_1)
	local var_15_0 = Managers.party:parties()

	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		local var_15_1 = iter_15_1.occupied_slots

		for iter_15_2 = 1, #var_15_1 do
			local var_15_2 = var_15_1[iter_15_2]

			if arg_15_1 == var_15_2.profile_index then
				return var_15_2.player
			end
		end
	end
end

ImguiCareerDebug._set_columns = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_2 = arg_16_2 or false

	Imgui.columns(arg_16_1, arg_16_2)

	if not arg_16_3 then
		return
	end

	if type(arg_16_3) == "table" then
		for iter_16_0, iter_16_1 in ipairs(arg_16_3) do
			Imgui.set_column_width(iter_16_1, iter_16_0 - 1)
		end
	else
		for iter_16_2 = 0, arg_16_1 - 1 do
			Imgui.set_column_width(arg_16_3, iter_16_2)
		end
	end
end

ImguiCareerDebug._reset_columns = function (arg_17_0)
	arg_17_0:_set_columns(1)
end

local var_0_6 = 8

ImguiCareerDebug._indent = function (arg_18_0)
	arg_18_0._indent_counter = arg_18_0._indent_counter + 1

	Imgui.indent(var_0_6)
end

ImguiCareerDebug._unindent = function (arg_19_0)
	arg_19_0._indent_counter = arg_19_0._indent_counter - 1

	Imgui.unindent(var_0_6)
end

ImguiCareerDebug._verify_indent = function (arg_20_0)
	fassert(arg_20_0._indent_counter == 0, tostring(arg_20_0._indent_counter))
end
