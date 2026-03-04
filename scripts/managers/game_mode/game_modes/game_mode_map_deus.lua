-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_map_deus.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/ui/views/deus_menu/deus_map_decision_view")
require(script_data.FEATURE_old_map_ui and "scripts/ui/views/deus_menu/deus_shop_view" or "scripts/ui/views/deus_menu/deus_shop_view_v2")

local var_0_0 = {
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

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_1 = iter_0_1.portrait_materials

	if var_0_1 then
		for iter_0_2, iter_0_3 in ipairs(var_0_1) do
			var_0_0[#var_0_0 + 1] = "material"
			var_0_0[#var_0_0 + 1] = iter_0_3
		end
	end
end

local var_0_2 = false
local var_0_3 = false
local var_0_4 = 1
local var_0_5 = {
	WAITING_FOR_PLAYERS_AFTER_SHOP = 4,
	MAP_DECISION = 1,
	SHOP = 3,
	FINISHING = 5,
	WAITING_FOR_PLAYERS_AFTER_MAP_DECISION = 2
}
local var_0_6 = {
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

SharedState.validate_spec(var_0_6)

GameModeMapDeus = class(GameModeMapDeus, GameModeBase)

function GameModeMapDeus.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	GameModeMapDeus.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	fassert(arg_1_8.deus_run_controller, "GameModeMapDeus is missing initialization data, see DeusMechanism.")

	arg_1_0._deus_run_controller = arg_1_8.deus_run_controller
	arg_1_0._own_peer_id = arg_1_0._deus_run_controller:get_own_peer_id()

	local var_1_0 = arg_1_0._deus_run_controller:get_server_peer_id()

	arg_1_0._shared_state = SharedState:new("deus_game_mode_map_" .. arg_1_0._deus_run_controller:get_run_id(), var_0_6, arg_1_4, arg_1_4 and arg_1_3 or nil, var_1_0, arg_1_0._own_peer_id)
	arg_1_0._is_server = arg_1_4
	arg_1_0._ui_done = true
	arg_1_0._adventure_profile_rules = AdventureProfileRules:new(arg_1_0._profile_synchronizer, arg_1_0._network_server)

	local var_1_1 = UIRenderer.create(arg_1_0._world, unpack(var_0_0))
	local var_1_2 = Managers.world:world("top_ingame_view")
	local var_1_3 = UIRenderer.create(var_1_2, unpack(var_0_0))
	local var_1_4 = {
		ui_renderer = var_1_1,
		ui_top_renderer = var_1_3,
		is_server = arg_1_0._is_server,
		server_peer_id = var_1_0,
		input_manager = Managers.input,
		deus_run_controller = arg_1_0._deus_run_controller,
		wwise_world = Managers.world:wwise_world(arg_1_2),
		network_server = arg_1_4 and arg_1_3 or nil,
		own_peer_id = arg_1_0._own_peer_id,
		world = arg_1_2
	}

	arg_1_0._map_decision_view = DeusMapDecisionView:new(var_1_4)
	arg_1_0._shop_view = DeusShopView:new(var_1_4)
end

function GameModeMapDeus.register_rpcs(arg_2_0, arg_2_1, arg_2_2)
	GameModeMapDeus.super.register_rpcs(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._shared_state:register_rpcs(arg_2_0._network_event_delegate)
	arg_2_0._map_decision_view:register_rpcs(arg_2_1, arg_2_2)
	arg_2_0._shop_view:register_rpcs(arg_2_1, arg_2_2)
end

function GameModeMapDeus.unregister_rpcs(arg_3_0)
	arg_3_0._shared_state:unregister_rpcs()

	if arg_3_0._map_decision_view then
		arg_3_0._map_decision_view:unregister_rpcs()
	end

	if arg_3_0._shop_view then
		arg_3_0._shop_view:unregister_rpcs()
	end
end

function GameModeMapDeus.ended(arg_4_0, arg_4_1)
	if not arg_4_0._network_server:are_all_peers_ingame() then
		arg_4_0._network_server:disconnect_joining_peers()
	end
end

function GameModeMapDeus.local_player_ready_to_start(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1:profile_index()
	local var_5_1 = arg_5_1:career_index()

	if var_5_0 == 0 or var_5_1 == 0 or var_5_0 == nil or var_5_1 == nil then
		return false
	end

	return true
end

function GameModeMapDeus.local_player_game_starts(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._game_started = true

	if arg_6_0._is_server then
		arg_6_0._node_decided = nil

		arg_6_0._shared_state:set_server(arg_6_0._shared_state:get_key("state"), var_0_5.MAP_DECISION)
	end

	arg_6_0._shared_state:full_sync()

	local var_6_0 = arg_6_1:profile_index()
	local var_6_1 = arg_6_1:career_index()

	CosmeticUtils.sync_local_player_cosmetics(arg_6_1, var_6_0, var_6_1)
end

function GameModeMapDeus.profile_changed(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_1 == arg_7_0._own_peer_id then
		local var_7_0 = Managers.player:player(arg_7_1, arg_7_2)

		CosmeticUtils.sync_local_player_cosmetics(var_7_0, arg_7_3, arg_7_4)
	end
end

function GameModeMapDeus.mutators(arg_8_0)
	local var_8_0 = {}

	arg_8_0:append_live_event_mutators(var_8_0)

	local var_8_1 = arg_8_0._deus_run_controller:get_event_mutators()

	if var_8_1 then
		local var_8_2 = table.set(var_8_0)

		for iter_8_0 = 1, #var_8_1 do
			local var_8_3 = var_8_1[iter_8_0]

			if not var_8_2[var_8_3] then
				var_8_0[#var_8_0 + 1] = var_8_3
			end
		end
	end

	return var_8_0
end

function GameModeMapDeus.update(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._shared_state:get_server(arg_9_0._shared_state:get_key("state"))
	local var_9_1 = arg_9_0._shared_state:get_own(arg_9_0._shared_state:get_key("state"))

	if var_9_0 == 0 then
		return
	end

	if var_9_1 == var_0_5.MAP_DECISION then
		local var_9_2 = arg_9_0._map_decision_view

		if var_9_2 then
			var_9_2:update(arg_9_2, arg_9_1)
		end
	end

	if var_9_1 == var_0_5.SHOP then
		local var_9_3 = arg_9_0._shop_view

		if var_9_3 then
			var_9_3:update(arg_9_2, arg_9_1)
		end
	end

	if not arg_9_0._ui_done then
		return
	end

	if var_9_1 ~= var_9_0 then
		if var_9_0 == var_0_5.MAP_DECISION then
			arg_9_0._ui_done = false

			Managers.ui:handle_transition("close_active", {
				use_fade = true,
				fade_in_speed = var_0_4,
				fade_out_speed = var_0_4
			})

			local var_9_4 = {
				finish_cb = function(arg_10_0)
					if arg_9_0._is_server then
						arg_9_0._node_decided = arg_10_0
					end

					Managers.transition:fade_in(var_0_4, function()
						arg_9_0._ui_done = true
					end)
				end
			}

			arg_9_0._map_decision_view:start(var_9_4)
			Wwise.set_state("level_morris_map", "map")
		elseif var_9_0 == var_0_5.WAITING_FOR_PLAYERS_AFTER_MAP_DECISION then
			-- block empty
		elseif var_9_0 == var_0_5.SHOP then
			arg_9_0._ui_done = false

			Managers.ui:handle_transition("close_active", {
				use_fade = true,
				fade_in_speed = var_0_4,
				fade_out_speed = var_0_4
			})

			local var_9_5 = {
				finish_cb = function()
					if arg_9_0._is_server then
						arg_9_0._shop_view_finished = true
					end

					Managers.transition:fade_in(var_0_4, function()
						arg_9_0._shop_view:destroy_idol()

						arg_9_0._ui_done = true
					end)
				end
			}

			arg_9_0._shop_view:start(var_9_5)
			Wwise.set_state("level_morris_map", "shrine")
		elseif var_9_0 == var_0_5.WAITING_FOR_PLAYERS_AFTER_SHOP then
			-- block empty
		elseif var_9_0 == var_0_5.FINISHING then
			-- block empty
		end

		arg_9_0._shared_state:set_own(arg_9_0._shared_state:get_key("state"), var_9_0)
	end
end

function GameModeMapDeus.post_update(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._shared_state:get_own(arg_14_0._shared_state:get_key("state"))

	if var_14_0 == var_0_5.MAP_DECISION then
		local var_14_1 = arg_14_0._map_decision_view

		if var_14_1 then
			var_14_1:post_update(arg_14_1, arg_14_2)
		end
	end

	if var_14_0 == var_0_5.SHOP then
		local var_14_2 = arg_14_0._shop_view

		if var_14_2 then
			var_14_2:post_update(arg_14_1, arg_14_2)
		end
	end
end

function GameModeMapDeus.destroy(arg_15_0)
	if arg_15_0._map_decision_view then
		arg_15_0._map_decision_view:destroy()

		arg_15_0._map_decision_view = nil
	end

	if arg_15_0._shop_view then
		arg_15_0._shop_view:destroy()

		arg_15_0._shop_view = nil
	end

	arg_15_0._shared_state:destroy()

	arg_15_0._shared_state = nil
end

function GameModeMapDeus.server_update(arg_16_0, arg_16_1, arg_16_2)
	GameModeMapDeus.super.server_update(arg_16_0, arg_16_1, arg_16_2)

	local var_16_0 = arg_16_0._shared_state:get_server(arg_16_0._shared_state:get_key("state"))

	if var_16_0 == var_0_5.MAP_DECISION then
		if arg_16_0._node_decided then
			arg_16_0._shared_state:set_server(arg_16_0._shared_state:get_key("state"), var_0_5.WAITING_FOR_PLAYERS_AFTER_MAP_DECISION)
		end
	elseif var_16_0 == var_0_5.WAITING_FOR_PLAYERS_AFTER_MAP_DECISION then
		if arg_16_0:_are_all_peers_in_same_state() then
			if arg_16_0._deus_run_controller:get_graph_data()[arg_16_0._node_decided].node_type == "shop" then
				arg_16_0._shop_view_finished = nil

				arg_16_0._deus_run_controller:handle_shrine_entered(arg_16_0._node_decided)
				arg_16_0._shared_state:set_server(arg_16_0._shared_state:get_key("state"), var_0_5.SHOP)
			else
				arg_16_0._shared_state:set_server(arg_16_0._shared_state:get_key("state"), var_0_5.FINISHING)
			end
		end
	elseif var_16_0 == var_0_5.SHOP then
		if arg_16_0._shop_view_finished then
			arg_16_0._shared_state:set_server(arg_16_0._shared_state:get_key("state"), var_0_5.WAITING_FOR_PLAYERS_AFTER_SHOP)
		end
	elseif var_16_0 == var_0_5.WAITING_FOR_PLAYERS_AFTER_SHOP then
		if arg_16_0:_are_all_peers_in_same_state() then
			arg_16_0._node_decided = nil

			arg_16_0._shared_state:set_server(arg_16_0._shared_state:get_key("state"), var_0_5.MAP_DECISION)
		end
	elseif var_16_0 == var_0_5.FINISHING and arg_16_0:_are_all_peers_in_same_state() then
		arg_16_0._final_node_selected = arg_16_0._node_decided
	end
end

function GameModeMapDeus._are_all_peers_in_same_state(arg_17_0)
	local var_17_0 = arg_17_0._shared_state:get_server(arg_17_0._shared_state:get_key("state"))

	for iter_17_0, iter_17_1 in ipairs(arg_17_0._deus_run_controller:get_peers()) do
		if arg_17_0._shared_state:get_peer(iter_17_1, arg_17_0._shared_state:get_key("state")) ~= var_17_0 then
			return false
		end
	end

	return true
end

function GameModeMapDeus.player_entered_game_session(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	GameModeMapDeus.super.player_entered_game_session(arg_18_0, arg_18_1, arg_18_2, arg_18_3)

	if Managers.party:get_player_status(arg_18_1, arg_18_2).party_id ~= 1 then
		local var_18_0 = 1

		Managers.party:assign_peer_to_party(arg_18_1, arg_18_2, var_18_0)
	end

	arg_18_0._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_18_1, arg_18_2)
end

function GameModeMapDeus.evaluate_end_conditions(arg_19_0, arg_19_1)
	if var_0_2 then
		var_0_2 = false

		return true, "won"
	end

	if arg_19_0:_is_time_up() then
		return true, "reload"
	end

	if var_0_3 then
		var_0_3 = false

		return true, "lost"
	end

	if arg_19_0._level_completed then
		return true, "won"
	end

	if arg_19_0._final_node_selected then
		arg_19_0._deus_run_controller:handle_map_exited()

		return true, "won", arg_19_0._final_node_selected
	end
end
