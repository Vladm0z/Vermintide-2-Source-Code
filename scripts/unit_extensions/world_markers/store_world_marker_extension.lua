-- chunkname: @scripts/unit_extensions/world_markers/store_world_marker_extension.lua

require("scripts/unit_extensions/world_markers/world_marker_extension")

StoreWorldMarkerExtension = class(StoreWorldMarkerExtension, WorldMarkerExtension)

StoreWorldMarkerExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	StoreWorldMarkerExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._marker_type = "store"
	arg_1_0._add_event_name = "add_world_marker_unit"
	arg_1_0._remove_event_name = "remove_world_marker"
	arg_1_0._initialized = false
	arg_1_0._unseen_shop_items = false

	Managers.state.event:register(arg_1_0, "set_all_shop_item_seen", "event_set_all_shop_item_seen")
end

StoreWorldMarkerExtension._destroy = function (arg_2_0)
	Managers.state.event:unregister("set_all_shop_item_seen", arg_2_0)
end

StoreWorldMarkerExtension.event_set_all_shop_item_seen = function (arg_3_0)
	arg_3_0._unseen_shop_items = false
end

StoreWorldMarkerExtension._extensions_ready = function (arg_4_0)
	if DEDICATED_SERVER then
		return
	end

	arg_4_0._local_player = Managers.player:local_player()
	arg_4_0._backend_store = Managers.backend:get_interface("peddler")
	arg_4_0._unseen_shop_items = ItemHelper.has_unseen_shop_items()
	arg_4_0._initialized = true
end

StoreWorldMarkerExtension._add_marker = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._unit
	local var_5_1 = arg_5_0._add_event_name
	local var_5_2 = arg_5_0._event_manager
	local var_5_3 = arg_5_0._marker_type

	var_5_2:trigger(var_5_1, var_5_3, var_5_0, arg_5_1)
end

StoreWorldMarkerExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if not arg_6_0._initialized then
		return
	end

	local var_6_0 = arg_6_0._local_player.player_unit

	if not ALIVE[var_6_0] then
		return
	end

	local var_6_1 = false
	local var_6_2 = arg_6_0._backend_store:get_login_rewards()

	if var_6_2 and var_6_2.next_claim_timestamp < os.time() then
		var_6_1 = true
	end

	if var_6_1 == not arg_6_0._id then
		if var_6_1 then
			arg_6_0:add_marker()
		else
			arg_6_0:remove_marker()
		end
	end
end
