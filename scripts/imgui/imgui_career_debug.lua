-- chunkname: @scripts/imgui/imgui_career_debug.lua

ImguiCareerDebug = class(ImguiCareerDebug)

local flag = true
local num = 820
local num_2 = 500
local num_3 = 8
local tbl = {}

for i = 0, num_3 do
	tbl[i + 1] = tostring(i)
end

ImguiCareerDebug.init = function (self)
	-- function 1
	self._first_run = true
	self._is_persistent = false
	self._indent_counter = 0
	self._players = {}
	self._profiles = {}
	self._careers = {}

	self:register_events()

	flag = false
end

ImguiCareerDebug._get_profile_requester = function (self)
	-- function 2
	if not self._profile_requester then
		return self._profile_requester
	end

	local network = Managers.state.network

	if not network then
		local network_server = network.network_server

		network_server = network_server or network.network_client
		self._profile_requester = not network_server and network_server:profile_requester()
	end

	return self._profile_requester
end

ImguiCareerDebug._get_profile_synchronizer = function (self)
	-- function 3
	if not self._profile_synchronizer then
		return self._profile_synchronizer
	end

	local network = Managers.state.network

	if not network then
		local network_server = network.network_server

		network_server = network_server or network.network_client
		self._profile_synchronizer = not network_server and network_server.profile_synchronizer
	end

	return self._profile_synchronizer
end

ImguiCareerDebug.destroy = function (self)
	-- function 4
	self:unregister_events()
end

ImguiCareerDebug.register_events = function (arg_5_0)
	-- function 5
	if not Managers.state.event then
		-- Nothing
	end
end

ImguiCareerDebug.unregister_events = function (arg_6_0)
	-- function 6
	if not Managers.state.event then
		-- Nothing
	end
end

ImguiCareerDebug.is_persistent = function (self)
	-- function 7
	return self._is_persistent
end

ImguiCareerDebug.update = function (self)
	-- function 8
	if not flag then
		self:unregister_events()
		self:init()
	end

	self:_update_profiles_and_careers()
	self:_update_players()
end

ImguiCareerDebug._update_profiles_and_careers = function (self)
	-- function 9
	self._profiles = {}
	self._careers = {}

	for k, v in pairs(SPProfiles) do
		self._profiles[k] = v.display_name
		self._careers[k] = {}

		for k_2, v_2 in pairs(v.careers) do
			self._careers[k][k_2] = v_2.display_name
		end
	end
end

ImguiCareerDebug._update_players = function (self)
	-- function 10
	self._players = Managers.player:players()
end

ImguiCareerDebug.draw = function (self)
	-- function 11
	if not self._first_run then
		Imgui.set_next_window_size(num, num_2)

		self._first_run = false
	end

	local begin_window = Imgui.begin_window("Career Debug")

	self._is_persistent = Imgui.checkbox("Keep Window Open", self._is_persistent)

	Imgui.same_line()
	Imgui.push_item_width(100)

	local script_data = script_data
	local combo = Imgui.combo
	local str = "Num bots"
	local cap_num_bots = script_data.cap_num_bots

	cap_num_bots = cap_num_bots or num_3
	script_data.cap_num_bots = combo(str, cap_num_bots + 1, tbl) - 1

	Imgui.pop_item_width()
	Imgui.separator()
	self:_draw_players()
	self:_verify_indent()
	Imgui.end_window()

	return begin_window
end

local tbl_2 = {
	"Name",
	"Profile",
	"Career",
	"Is Bot",
	"Is Server"
}

ImguiCareerDebug._draw_players = function (self)
	-- function 12
	self:_set_columns(5, true, 164)

	for k, v in pairs(tbl_2) do
		Imgui.text(v)
		Imgui.next_column()
	end

	local server_peer_id = Managers.mechanism:server_peer_id()

	for k_2, v_2 in pairs(self._players) do
		local flag = v_2.peer_id == server_peer_id

		Imgui.tree_push(k_2)
		Imgui.text(v_2:name())
		Imgui.next_column()
		self:_draw_profile_combo(v_2)
		Imgui.next_column()
		self:_draw_career_combo(v_2)
		Imgui.next_column()

		local text = Imgui.text
		local tostring = tostring
		local bot_player = v_2.bot_player

		bot_player = (bot_player or not v_2:is_player_controlled()) and false

		text(tostring(bot_player))
		Imgui.next_column()
		Imgui.text(tostring(flag))
		Imgui.next_column()
		Imgui.tree_pop()
	end

	self:_reset_columns()
end

ImguiCareerDebug._draw_profile_combo = function (self, arg_13_1)
	-- function 13
	local profile_index = arg_13_1:profile_index()

	Imgui.tree_push("profile")

	local combo = Imgui.combo("", profile_index, self._profiles)

	Imgui.tree_pop()

	if combo ~= profile_index then
		local _get_profile_requester = self:_get_profile_requester()
		local var_13_3, var_13_4 = hero_and_career_name_from_index(combo, 1)
		local peer_id = Network.peer_id()
		local reserved_party_id_by_peer = Managers.mechanism:reserved_party_id_by_peer(peer_id)

		if not Managers.mechanism:profile_available_for_peer(reserved_party_id_by_peer, peer_id, combo) then
			local _find_who_uses_profile = self:_find_who_uses_profile(combo)
			local _get_profile_synchronizer = self:_get_profile_synchronizer()
			local num = 1
			local get_first_free_profile, var_13_11 = _get_profile_synchronizer:get_first_free_profile(num)
			local var_13_12, var_13_13 = hero_and_career_name_from_index(get_first_free_profile, var_13_11)

			_get_profile_requester:request_profile(_find_who_uses_profile.peer_id, _find_who_uses_profile:local_player_id(), var_13_12, var_13_13, true)

			if not _find_who_uses_profile.bot_player then
				_find_who_uses_profile.character_name = Localize(var_13_12)
			end
		end

		_get_profile_requester:request_profile(arg_13_1.peer_id, arg_13_1:local_player_id(), var_13_3, var_13_4, true)

		if not arg_13_1.bot_player then
			arg_13_1.character_name = Localize(var_13_3)
		end
	end
end

ImguiCareerDebug._draw_career_combo = function (self, arg_14_1)
	-- function 14
	local profile_index = arg_14_1:profile_index()
	local career_index = arg_14_1:career_index()
	local var_14_2 = self._careers[profile_index]

	Imgui.tree_push("career")

	local combo = Imgui.combo("", career_index, var_14_2)

	Imgui.tree_pop()

	if combo ~= career_index then
		local _get_profile_requester = self:_get_profile_requester()
		local var_14_5, var_14_6 = hero_and_career_name_from_index(profile_index, combo)

		_get_profile_requester:request_profile(arg_14_1.peer_id, arg_14_1:local_player_id(), var_14_5, var_14_6, true)
	end
end

ImguiCareerDebug._find_who_uses_profile = function (arg_15_0, arg_15_1)
	-- function 15
	local parties = Managers.party:parties()

	for k, v in pairs(parties) do
		local occupied_slots = v.occupied_slots

		for k_2 = 1, #occupied_slots do
			local var_15_2 = occupied_slots[k_2]

			if arg_15_1 == var_15_2.profile_index then
				return var_15_2.player
			end
		end
	end
end

ImguiCareerDebug._set_columns = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	arg_16_2 = arg_16_2 or false

	Imgui.columns(arg_16_1, arg_16_2)

	if not arg_16_3 then
		return
	end

	if type(arg_16_3) == "table" then
		for i, v in ipairs(arg_16_3) do
			Imgui.set_column_width(v, i - 1)
		end
	else
		for k = 0, arg_16_1 - 1 do
			Imgui.set_column_width(arg_16_3, k)
		end
	end
end

ImguiCareerDebug._reset_columns = function (self)
	-- function 17
	self:_set_columns(1)
end

local num_4 = 8

ImguiCareerDebug._indent = function (self)
	-- function 18
	self._indent_counter = self._indent_counter + 1

	Imgui.indent(num_4)
end

ImguiCareerDebug._unindent = function (self)
	-- function 19
	self._indent_counter = self._indent_counter - 1

	Imgui.unindent(num_4)
end

ImguiCareerDebug._verify_indent = function (self)
	-- function 20
	fassert(self._indent_counter == 0, tostring(self._indent_counter))
end
