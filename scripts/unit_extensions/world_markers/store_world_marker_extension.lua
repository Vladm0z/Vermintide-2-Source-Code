-- chunkname: @scripts/unit_extensions/world_markers/store_world_marker_extension.lua

require("scripts/unit_extensions/world_markers/world_marker_extension")

StoreWorldMarkerExtension = class(StoreWorldMarkerExtension, WorldMarkerExtension)

StoreWorldMarkerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	StoreWorldMarkerExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._marker_type = "store"
	self._add_event_name = "add_world_marker_unit"
	self._remove_event_name = "remove_world_marker"
	self._initialized = false
	self._unseen_shop_items = false

	Managers.state.event:register(self, "set_all_shop_item_seen", "event_set_all_shop_item_seen")
end

StoreWorldMarkerExtension._destroy = function (arg_2_0)
	-- function 2
	Managers.state.event:unregister("set_all_shop_item_seen", arg_2_0)
end

StoreWorldMarkerExtension.event_set_all_shop_item_seen = function (self)
	-- function 3
	self._unseen_shop_items = false
end

StoreWorldMarkerExtension._extensions_ready = function (self)
	-- function 4
	if not DEDICATED_SERVER then
		return
	end

	self._local_player = Managers.player:local_player()
	self._backend_store = Managers.backend:get_interface("peddler")
	self._unseen_shop_items = ItemHelper.has_unseen_shop_items()
	self._initialized = true
end

StoreWorldMarkerExtension._add_marker = function (self, arg_5_1)
	-- function 5
	local _unit = self._unit
	local _add_event_name = self._add_event_name
	local _event_manager = self._event_manager
	local _marker_type = self._marker_type

	_event_manager:trigger(_add_event_name, _marker_type, _unit, arg_5_1)
end

StoreWorldMarkerExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	if not self._initialized then
		return
	end

	local player_unit = self._local_player.player_unit

	if not ALIVE[player_unit] then
		return
	end

	local flag = false
	local get_login_rewards = self._backend_store:get_login_rewards()

	if not (not get_login_rewards and not (get_login_rewards.next_claim_timestamp < os.time())) then
		flag = true
	end

	if flag == not self._id then
		if not flag then
			self:add_marker()
		else
			self:remove_marker()
		end
	end
end
