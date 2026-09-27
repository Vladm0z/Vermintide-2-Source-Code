-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_map_deus.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/ui/views/deus_menu/deus_map_decision_view")

local require = require
local flag

flag = not script_data.FEATURE_old_map_ui and "scripts/ui/views/deus_menu/deus_shop_view" and "scripts/ui/views/deus_menu/deus_shop_view_v2"

require(flag)

local tbl = {
	"material",
	"materials/ui/ui_1080p_hud_atlas_textures",
	"material",
	"materials/ui/ui_1080p_hud_single_textures",
	"material",
	"materials/ui/ui_1080p_menu_atlas_textures",
	"material",
	"materials/ui/ui_1080p_menu_single_textures",
	"material",
	"materials/ui/ui_1080p_common",
	"material",
	"materials/ui/ui_1080p_versus_available_common",
	"material",
	"materials/fonts/gw_fonts",
	"material",
	"materials/ui/ui_1080p_morris_single_textures",
	"material",
	"materials/ui/ui_1080p_belakor_atlas",
	"material",
	"materials/ui/ui_1080p_versus_rewards_atlas"
}

for k, v in pairs(DLCSettings) do
	local portrait_materials = v.portrait_materials

	if not portrait_materials then
		for i, v_2 in ipairs(portrait_materials) do
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = v_2
		end
	end
end

local flag_2 = false
local flag_3 = false
local num = 1
local tbl_2 = {
	WAITING_FOR_PLAYERS_AFTER_SHOP = 4,
	MAP_DECISION = 1,
	SHOP = 3,
	FINISHING = 5,
	WAITING_FOR_PLAYERS_AFTER_MAP_DECISION = 2
}
local tbl_3 = {
	server = {
		state = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		}
	},
	peer = {
		state = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		}
	}
}

SharedState.validate_spec(tbl_3)

GameModeMapDeus = class(GameModeMapDeus, GameModeBase)

GameModeMapDeus.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	GameModeMapDeus.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	fassert(arg_1_8.deus_run_controller, "GameModeMapDeus is missing initialization data, see DeusMechanism.")

	self._deus_run_controller = arg_1_8.deus_run_controller
	self._own_peer_id = self._deus_run_controller:get_own_peer_id()

	local get_server_peer_id = self._deus_run_controller:get_server_peer_id()

	self._shared_state = SharedState:new("deus_game_mode_map_" .. self._deus_run_controller:get_run_id(), tbl_3, arg_1_4, not arg_1_4 and arg_1_3 and nil, get_server_peer_id, self._own_peer_id)
	self._is_server = arg_1_4
	self._ui_done = true
	self._adventure_profile_rules = AdventureProfileRules:new(self._profile_synchronizer, self._network_server)

	local var_1_1 = UIRenderer.create(self._world, unpack(tbl))
	local world = Managers.world:world("top_ingame_view")
	local var_1_3 = UIRenderer.create(world, unpack(tbl))
	local tbl_2 = {
		ui_renderer = var_1_1,
		ui_top_renderer = var_1_3,
		is_server = self._is_server,
		server_peer_id = get_server_peer_id,
		input_manager = Managers.input,
		deus_run_controller = self._deus_run_controller,
		wwise_world = Managers.world:wwise_world(arg_1_2),
		network_server = not arg_1_4 and arg_1_3 and nil,
		own_peer_id = self._own_peer_id,
		world = arg_1_2
	}

	self._map_decision_view = DeusMapDecisionView:new(tbl_2)
	self._shop_view = DeusShopView:new(tbl_2)
end

GameModeMapDeus.register_rpcs = function (self, arg_2_1, arg_2_2)
	-- function 2
	GameModeMapDeus.super.register_rpcs(self, arg_2_1, arg_2_2)
	self._shared_state:register_rpcs(self._network_event_delegate)
	self._map_decision_view:register_rpcs(arg_2_1, arg_2_2)
	self._shop_view:register_rpcs(arg_2_1, arg_2_2)
end

GameModeMapDeus.unregister_rpcs = function (self)
	-- function 3
	self._shared_state:unregister_rpcs()

	if not self._map_decision_view then
		self._map_decision_view:unregister_rpcs()
	end

	if not self._shop_view then
		self._shop_view:unregister_rpcs()
	end
end

GameModeMapDeus.ended = function (self, arg_4_1)
	-- function 4
	if not self._network_server:are_all_peers_ingame() then
		self._network_server:disconnect_joining_peers()
	end
end

GameModeMapDeus.local_player_ready_to_start = function (arg_5_0, arg_5_1)
	-- function 5
	local profile_index = arg_5_1:profile_index()
	local career_index = arg_5_1:career_index()

	if not (profile_index == 0 or career_index == 0 or profile_index == nil or career_index ~= nil) then
		return false
	end

	return true
end

GameModeMapDeus.local_player_game_starts = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._game_started = true

	if not self._is_server then
		self._node_decided = nil

		self._shared_state:set_server(self._shared_state:get_key("state"), tbl_2.MAP_DECISION)
	end

	self._shared_state:full_sync()

	local profile_index = arg_6_1:profile_index()
	local career_index = arg_6_1:career_index()

	CosmeticUtils.sync_local_player_cosmetics(arg_6_1, profile_index, career_index)
end

GameModeMapDeus.profile_changed = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if arg_7_1 == self._own_peer_id then
		local player = Managers.player:player(arg_7_1, arg_7_2)

		CosmeticUtils.sync_local_player_cosmetics(player, arg_7_3, arg_7_4)
	end
end

GameModeMapDeus.mutators = function (self)
	-- function 8
	local tbl = {}

	self:append_live_event_mutators(tbl)

	local get_event_mutators = self._deus_run_controller:get_event_mutators()

	if not get_event_mutators then
		local set = table.set(tbl)

		for i = 1, #get_event_mutators do
			local var_8_3 = get_event_mutators[i]

			if not set[var_8_3] then
				tbl[#tbl + 1] = var_8_3
			end
		end
	end

	return tbl
end

GameModeMapDeus.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	local get_server = self._shared_state:get_server(self._shared_state:get_key("state"))
	local get_own = self._shared_state:get_own(self._shared_state:get_key("state"))

	if get_server == 0 then
		return
	end

	if get_own == tbl_2.MAP_DECISION then
		local _map_decision_view = self._map_decision_view

		if not _map_decision_view then
			_map_decision_view:update(arg_9_2, arg_9_1)
		end
	end

	if get_own == tbl_2.SHOP then
		local _shop_view = self._shop_view

		if not _shop_view then
			_shop_view:update(arg_9_2, arg_9_1)
		end
	end

	if not self._ui_done then
		return
	end

	if get_own ~= get_server then
		if get_server == tbl_2.MAP_DECISION then
			self._ui_done = false

			Managers.ui:handle_transition("close_active", {
				use_fade = true,
				fade_in_speed = num,
				fade_out_speed = num
			})

			local tbl = {
				finish_cb = function (arg_10_0)
					-- function 10
					if not self._is_server then
						self._node_decided = arg_10_0
					end

					Managers.transition:fade_in(num, function ()
						-- function 11
						self._ui_done = true
					end)
				end
			}

			self._map_decision_view:start(tbl)
			Wwise.set_state("level_morris_map", "map")
		elseif get_server == tbl_2.WAITING_FOR_PLAYERS_AFTER_MAP_DECISION then
			-- Nothing
		elseif get_server == tbl_2.SHOP then
			self._ui_done = false

			Managers.ui:handle_transition("close_active", {
				use_fade = true,
				fade_in_speed = num,
				fade_out_speed = num
			})

			local tbl_3 = {
				finish_cb = function ()
					-- function 12
					if not self._is_server then
						self._shop_view_finished = true
					end

					Managers.transition:fade_in(num, function ()
						-- function 13
						self._shop_view:destroy_idol()

						self._ui_done = true
					end)
				end
			}

			self._shop_view:start(tbl_3)
			Wwise.set_state("level_morris_map", "shrine")
		elseif get_server == tbl_2.WAITING_FOR_PLAYERS_AFTER_SHOP then
			-- Nothing
		elseif get_server == tbl_2.FINISHING then
			-- Nothing
		end

		self._shared_state:set_own(self._shared_state:get_key("state"), get_server)
	end
end

GameModeMapDeus.post_update = function (self, arg_14_1, arg_14_2)
	-- function 14
	local get_own = self._shared_state:get_own(self._shared_state:get_key("state"))

	if get_own == tbl_2.MAP_DECISION then
		local _map_decision_view = self._map_decision_view

		if not _map_decision_view then
			_map_decision_view:post_update(arg_14_1, arg_14_2)
		end
	end

	if get_own == tbl_2.SHOP then
		local _shop_view = self._shop_view

		if not _shop_view then
			_shop_view:post_update(arg_14_1, arg_14_2)
		end
	end
end

GameModeMapDeus.destroy = function (self)
	-- function 15
	if not self._map_decision_view then
		self._map_decision_view:destroy()

		self._map_decision_view = nil
	end

	if not self._shop_view then
		self._shop_view:destroy()

		self._shop_view = nil
	end

	self._shared_state:destroy()

	self._shared_state = nil
end

GameModeMapDeus.server_update = function (self, arg_16_1, arg_16_2)
	-- function 16
	GameModeMapDeus.super.server_update(self, arg_16_1, arg_16_2)

	local get_server = self._shared_state:get_server(self._shared_state:get_key("state"))

	if get_server == tbl_2.MAP_DECISION then
		if not self._node_decided then
			self._shared_state:set_server(self._shared_state:get_key("state"), tbl_2.WAITING_FOR_PLAYERS_AFTER_MAP_DECISION)
		end
	elseif get_server == tbl_2.WAITING_FOR_PLAYERS_AFTER_MAP_DECISION then
		if not self:_are_all_peers_in_same_state() then
			if self._deus_run_controller:get_graph_data()[self._node_decided].node_type == "shop" then
				self._shop_view_finished = nil

				self._deus_run_controller:handle_shrine_entered(self._node_decided)
				self._shared_state:set_server(self._shared_state:get_key("state"), tbl_2.SHOP)
			else
				self._shared_state:set_server(self._shared_state:get_key("state"), tbl_2.FINISHING)
			end
		end
	elseif get_server == tbl_2.SHOP then
		if not self._shop_view_finished then
			self._shared_state:set_server(self._shared_state:get_key("state"), tbl_2.WAITING_FOR_PLAYERS_AFTER_SHOP)
		end
	elseif get_server == tbl_2.WAITING_FOR_PLAYERS_AFTER_SHOP then
		if not self:_are_all_peers_in_same_state() then
			self._node_decided = nil

			self._shared_state:set_server(self._shared_state:get_key("state"), tbl_2.MAP_DECISION)
		end
	elseif get_server ~= tbl_2.FINISHING or not self:_are_all_peers_in_same_state() then
		self._final_node_selected = self._node_decided
	end
end

GameModeMapDeus._are_all_peers_in_same_state = function (self)
	-- function 17
	local get_server = self._shared_state:get_server(self._shared_state:get_key("state"))

	for i, v in ipairs(self._deus_run_controller:get_peers()) do
		if self._shared_state:get_peer(v, self._shared_state:get_key("state")) ~= get_server then
			return false
		end
	end

	return true
end

GameModeMapDeus.player_entered_game_session = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	GameModeMapDeus.super.player_entered_game_session(self, arg_18_1, arg_18_2, arg_18_3)

	if Managers.party:get_player_status(arg_18_1, arg_18_2).party_id ~= 1 then
		local num = 1

		Managers.party:assign_peer_to_party(arg_18_1, arg_18_2, num)
	end

	self._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_18_1, arg_18_2)
end

GameModeMapDeus.evaluate_end_conditions = function (self, arg_19_1)
	-- function 19
	if not flag_2 then
		flag_2 = false

		return true, "won"
	end

	if not self:_is_time_up() then
		return true, "reload"
	end

	if not flag_3 then
		flag_3 = false

		return true, "lost"
	end

	if not self._level_completed then
		return true, "won"
	end

	if not self._final_node_selected then
		self._deus_run_controller:handle_map_exited()

		return true, "won", self._final_node_selected
	end
end
