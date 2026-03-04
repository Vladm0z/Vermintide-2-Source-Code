-- chunkname: @scripts/unit_extensions/wizards/ward_extension.lua

WardExtension = class(WardExtension)

local var_0_0 = 49
local var_0_1 = 8
local var_0_2 = var_0_1
local var_0_3 = 0.5
local var_0_4 = 14
local var_0_5 = 196
local var_0_6 = Breeds.skaven_clan_rat
local var_0_7 = "horde_rat_defend_destructible"
local var_0_8 = "destructible_defenders"
local var_0_9 = "ward"
local var_0_10 = QuaternionBox(Quaternion.identity())
local var_0_11 = {
	idle = 0,
	aggressive = 1
}
local var_0_12 = {
	"rpc_client_ward_hot_join_sync"
}

function WardExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._player_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._network_event_delegate = arg_1_1.network_transmit.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_12))

	arg_1_0._defenders = {}
	arg_1_0._nearby_enemies = {}
	arg_1_0._next_check = 0
	arg_1_0._num_spawned = 0
	arg_1_0._spawned = false
	arg_1_0._state = var_0_11.idle
	arg_1_0._ward_pos = Vector3Box(Unit.local_position(arg_1_2, 0))
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._event_manager = Managers.state.event

	Managers.state.event:register(arg_1_0, "spawn_defenders", "spawn_defenders")
	Managers.state.event:register(arg_1_0, "player_party_changed", "player_party_changed")
end

function WardExtension.destroy(arg_2_0)
	if var_0_11 ~= var_0_11.aggressive then
		arg_2_0:set_defenders_aggressive()
	end

	arg_2_0._network_event_delegate:unregister(arg_2_0)
	Managers.state.event:unregister("spawn_defenders", arg_2_0)
	Managers.state.event:trigger("tutorial_event_remove_health_bar", arg_2_0._unit)
	Managers.state.event:unregister("player_party_changed", arg_2_0)
end

function WardExtension.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_0._spawned then
		arg_3_0:toggle_health_bar_by_proximity(arg_3_1)
	end

	if not arg_3_0._is_server and arg_3_0._state == var_0_11.aggressive then
		return
	end

	local var_3_0 = arg_3_0._ward_pos:unbox()

	if arg_3_5 > arg_3_0._next_check then
		arg_3_0._closest_player = arg_3_0:get_closest_player(var_3_0)
		arg_3_0._next_check = arg_3_5 + var_0_3
	end

	if arg_3_0._closest_player and var_3_0 then
		arg_3_0:update_state(var_3_0, arg_3_0._closest_player)
	end
end

local var_0_13 = {}

function WardExtension.get_closest_player(arg_4_0, arg_4_1)
	local var_4_0 = Broadphase.query(arg_4_0._player_broadphase, arg_4_1, var_0_4, var_0_13)

	if var_4_0 == 0 then
		return
	end

	if var_4_0 == 1 then
		return var_0_13[1]
	end

	local var_4_1 = math.huge
	local var_4_2
	local var_4_3
	local var_4_4

	for iter_4_0 = 1, var_4_0 do
		local var_4_5 = var_0_13[iter_4_0]
		local var_4_6 = POSITION_LOOKUP[var_4_5]
		local var_4_7 = Vector3.distance_squared(arg_4_1, var_4_6)

		if var_4_7 < var_4_1 then
			var_4_2 = var_4_5
			var_4_1 = var_4_7
		end
	end

	return var_4_2
end

function WardExtension.update_state(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_1 then
		return
	end

	local var_5_0 = POSITION_LOOKUP[arg_5_2]

	if not var_5_0 then
		return
	end

	if Vector3.distance_squared(arg_5_1, var_5_0) < var_0_0 then
		arg_5_0:set_defenders_aggressive(arg_5_2)

		arg_5_0._state = var_0_11.aggressive

		return
	end

	arg_5_0._state = var_0_11.idle
end

function WardExtension.set_defenders_aggressive(arg_6_0, arg_6_1)
	local var_6_0 = Managers.state.entity:system("ai_group_system"):get_ai_group(arg_6_0._defender_group_id)

	if var_6_0 then
		AIGroupTemplates.destructible_defenders.set_group_aggressive(var_6_0, arg_6_1)
	end
end

function WardExtension.spawn_defenders(arg_7_0, arg_7_1)
	arg_7_0._spawned = true

	if not arg_7_0._is_server then
		return
	end

	arg_7_1 = arg_7_1 or var_0_1
	arg_7_0._defender_group_id = Managers.state.entity:system("ai_group_system"):generate_group_id()

	local var_7_0 = {
		behavior = var_0_7,
		ward_pos = arg_7_0._ward_pos,
		spawned_func = function(arg_8_0, arg_8_1, arg_8_2)
			local var_8_0 = BLACKBOARDS[arg_8_0]

			var_8_0.defend = true
			var_8_0.defend_get_in_position = true
			var_8_0.destructible_pos = arg_8_2.ward_pos
		end
	}
	local var_7_1 = {
		id = arg_7_0._defender_group_id,
		size = arg_7_1,
		template = var_0_8
	}

	for iter_7_0 = 1, arg_7_1 do
		Managers.state.conflict:spawn_queued_unit(var_0_6, arg_7_0._ward_pos, var_0_10, var_0_9, nil, nil, var_7_0, var_7_1)
	end
end

function WardExtension.toggle_health_bar_by_proximity(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._local_player_unit_unit

	if not var_9_0 then
		arg_9_0._local_player_unit_unit = Managers.player:local_player().player_unit
	end

	if not Unit.alive(var_9_0) then
		if arg_9_0._health_bar_on then
			arg_9_0._health_bar_on = false

			arg_9_0._event_manager:trigger("tutorial_event_show_health_bar", arg_9_1, false)
		end

		return
	end

	local var_9_1 = arg_9_0._ward_pos:unbox()
	local var_9_2 = Unit.world_position(var_9_0, 0)
	local var_9_3 = var_0_5 > Vector3.distance_squared(var_9_1, var_9_2)

	if var_9_3 and not arg_9_0._health_bar_on then
		arg_9_0._health_bar_on = true

		arg_9_0._event_manager:trigger("tutorial_event_show_health_bar", arg_9_1, true)
	elseif not var_9_3 and arg_9_0._health_bar_on then
		arg_9_0._health_bar_on = false

		arg_9_0._event_manager:trigger("tutorial_event_show_health_bar", arg_9_1, false)
	end
end

function WardExtension.player_party_changed(arg_10_0)
	if arg_10_0._is_server and arg_10_0._spawned then
		arg_10_0._network_transmit:send_rpc_clients("rpc_client_ward_hot_join_sync", arg_10_0._spawned)
	end
end

function WardExtension.rpc_client_ward_hot_join_sync(arg_11_0, arg_11_1)
	arg_11_0._spawned = arg_11_1
end
