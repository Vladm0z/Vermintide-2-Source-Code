-- chunkname: @scripts/unit_extensions/default_player_unit/weaves/player_unit_weave_loadout_extension.lua

PlayerUnitWeaveLoadoutExtension = class(PlayerUnitWeaveLoadoutExtension)

PlayerUnitWeaveLoadoutExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._is_server = arg_1_1.is_server
	self._buffs = {}
	self._synced_buff_params = nil
end

PlayerUnitWeaveLoadoutExtension.destroy = function (self)
	-- function 2
	self._unit = nil
	self._buffs = nil
	self._synced_buff_params = nil
	self._buff_extension = nil
	self._career_extension = nil
end

PlayerUnitWeaveLoadoutExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
	self._career_extension = ScriptUnit.extension(arg_3_2, "career_system")

	if not self:_is_in_weave() then
		local _get_weave_buffs = self:_get_weave_buffs()

		self._buffs = _get_weave_buffs

		self:_apply_buffs(_get_weave_buffs)

		local get_interface = Managers.backend:get_interface("weaves")
		local career_name = self._career_extension:career_name()

		get_interface:apply_career_item_loadouts(career_name)
	end
end

PlayerUnitWeaveLoadoutExtension.game_object_initialized = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_sync_buffs(arg_4_2)
end

PlayerUnitWeaveLoadoutExtension.hot_join_sync = function (self, arg_5_1)
	-- function 5
	local _synced_buff_params = self._synced_buff_params

	if not _synced_buff_params then
		local go_id = Managers.state.unit_storage:go_id(self._unit)
		local var_5_2 = PEER_ID_TO_CHANNEL[arg_5_1]

		RPC.rpc_add_weave_buffs(var_5_2, go_id, unpack(_synced_buff_params))
	end
end

PlayerUnitWeaveLoadoutExtension._is_in_weave = function (arg_6_0)
	-- function 6
	return Managers.mechanism:game_mechanism():get_state() == "weave"
end

PlayerUnitWeaveLoadoutExtension._get_weave_buffs = function (self)
	-- function 7
	local tbl = {
		client = {},
		server = {},
		both = {}
	}
	local get_interface = Managers.backend:get_interface("weaves")
	local career_name = self._career_extension:career_name()
	local get_loadout_properties = get_interface:get_loadout_properties(career_name)

	for k, v in pairs(get_loadout_properties) do
		local count = #v
		local var_7_5 = WeaveProperties.properties[k]
		local buff_name = var_7_5.buff_name

		fassert(BuffUtils.get_buff_template(buff_name), "Weave buff %q does not exist", buff_name)

		local num = count / #get_interface:get_property_mastery_costs(k)
		local buffer = var_7_5.buffer

		buffer = buffer or "client"
		tbl[buffer][buff_name] = {
			variable_value = num
		}
	end

	local get_loadout_traits = get_interface:get_loadout_traits(career_name)

	for k_2, v_2 in pairs(get_loadout_traits) do
		local var_7_10 = WeaveTraits.traits[k_2]
		local buff_name_2 = var_7_10.buff_name

		fassert(BuffUtils.get_buff_template(buff_name_2), "Weave buff %q does not exist", buff_name_2)

		local buffer_2 = var_7_10.buffer

		buffer_2 = buffer_2 or "client"
		tbl[buffer_2][buff_name_2] = {
			variable_value = 1
		}
	end

	return tbl
end

PlayerUnitWeaveLoadoutExtension._apply_buffs = function (self, arg_8_1)
	-- function 8
	local _buff_extension = self._buff_extension

	for k, v in pairs(arg_8_1) do
		if not (self._is_server or k == "client" or k ~= "both") then
			for k_2, v_2 in pairs(v) do
				local get_buff_template = BuffUtils.get_buff_template(k_2)
				local tbl = {}

				for k_3, v_3 in pairs(v_2) do
					tbl[k_3] = v_3
				end

				_buff_extension:add_buff(k_2, tbl)
			end
		end
	end
end

PlayerUnitWeaveLoadoutExtension._sync_buffs = function (self, arg_9_1)
	-- function 9
	local _buffs = self._buffs

	if table.size(_buffs) == 0 then
		return
	end

	local tbl = {}

	table.merge(tbl, _buffs.server)
	table.merge(tbl, _buffs.both)

	if table.size(tbl) == 0 then
		return
	end

	local buffs_to_rpc_params = BuffUtils.buffs_to_rpc_params(tbl)
	local network_transmit = Managers.state.network.network_transmit

	if not self._is_server then
		network_transmit:send_rpc_clients("rpc_add_weave_buffs", arg_9_1, unpack(buffs_to_rpc_params))
	else
		network_transmit:send_rpc_server("rpc_add_weave_buffs", arg_9_1, unpack(buffs_to_rpc_params))
	end

	self._synced_buff_params = buffs_to_rpc_params
end
