-- chunkname: @scripts/unit_extensions/default_player_unit/weaves/player_unit_weave_loadout_extension.lua

PlayerUnitWeaveLoadoutExtension = class(PlayerUnitWeaveLoadoutExtension)

PlayerUnitWeaveLoadoutExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._buffs = {}
	arg_1_0._synced_buff_params = nil
end

PlayerUnitWeaveLoadoutExtension.destroy = function (arg_2_0)
	arg_2_0._unit = nil
	arg_2_0._buffs = nil
	arg_2_0._synced_buff_params = nil
	arg_2_0._buff_extension = nil
	arg_2_0._career_extension = nil
end

PlayerUnitWeaveLoadoutExtension.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
	arg_3_0._career_extension = ScriptUnit.extension(arg_3_2, "career_system")

	if arg_3_0:_is_in_weave() then
		local var_3_0 = arg_3_0:_get_weave_buffs()

		arg_3_0._buffs = var_3_0

		arg_3_0:_apply_buffs(var_3_0)

		local var_3_1 = Managers.backend:get_interface("weaves")
		local var_3_2 = arg_3_0._career_extension:career_name()

		var_3_1:apply_career_item_loadouts(var_3_2)
	end
end

PlayerUnitWeaveLoadoutExtension.game_object_initialized = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_sync_buffs(arg_4_2)
end

PlayerUnitWeaveLoadoutExtension.hot_join_sync = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._synced_buff_params

	if var_5_0 then
		local var_5_1 = Managers.state.unit_storage:go_id(arg_5_0._unit)
		local var_5_2 = PEER_ID_TO_CHANNEL[arg_5_1]

		RPC.rpc_add_weave_buffs(var_5_2, var_5_1, unpack(var_5_0))
	end
end

PlayerUnitWeaveLoadoutExtension._is_in_weave = function (arg_6_0)
	return Managers.mechanism:game_mechanism():get_state() == "weave"
end

PlayerUnitWeaveLoadoutExtension._get_weave_buffs = function (arg_7_0)
	local var_7_0 = {
		client = {},
		server = {},
		both = {}
	}
	local var_7_1 = Managers.backend:get_interface("weaves")
	local var_7_2 = arg_7_0._career_extension:career_name()
	local var_7_3 = var_7_1:get_loadout_properties(var_7_2)

	for iter_7_0, iter_7_1 in pairs(var_7_3) do
		local var_7_4 = #iter_7_1
		local var_7_5 = WeaveProperties.properties[iter_7_0]
		local var_7_6 = var_7_5.buff_name

		fassert(BuffUtils.get_buff_template(var_7_6), "Weave buff %q does not exist", var_7_6)

		local var_7_7 = var_7_4 / #var_7_1:get_property_mastery_costs(iter_7_0)

		var_7_0[var_7_5.buffer or "client"][var_7_6] = {
			variable_value = var_7_7
		}
	end

	local var_7_8 = var_7_1:get_loadout_traits(var_7_2)

	for iter_7_2, iter_7_3 in pairs(var_7_8) do
		local var_7_9 = WeaveTraits.traits[iter_7_2]
		local var_7_10 = var_7_9.buff_name

		fassert(BuffUtils.get_buff_template(var_7_10), "Weave buff %q does not exist", var_7_10)

		var_7_0[var_7_9.buffer or "client"][var_7_10] = {
			variable_value = 1
		}
	end

	return var_7_0
end

PlayerUnitWeaveLoadoutExtension._apply_buffs = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._buff_extension

	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		if arg_8_0._is_server or iter_8_0 == "client" or iter_8_0 == "both" then
			for iter_8_2, iter_8_3 in pairs(iter_8_1) do
				local var_8_1 = BuffUtils.get_buff_template(iter_8_2)
				local var_8_2 = {}

				for iter_8_4, iter_8_5 in pairs(iter_8_3) do
					var_8_2[iter_8_4] = iter_8_5
				end

				var_8_0:add_buff(iter_8_2, var_8_2)
			end
		end
	end
end

PlayerUnitWeaveLoadoutExtension._sync_buffs = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._buffs

	if table.size(var_9_0) == 0 then
		return
	end

	local var_9_1 = {}

	table.merge(var_9_1, var_9_0.server)
	table.merge(var_9_1, var_9_0.both)

	if table.size(var_9_1) == 0 then
		return
	end

	local var_9_2 = BuffUtils.buffs_to_rpc_params(var_9_1)
	local var_9_3 = Managers.state.network.network_transmit

	if arg_9_0._is_server then
		var_9_3:send_rpc_clients("rpc_add_weave_buffs", arg_9_1, unpack(var_9_2))
	else
		var_9_3:send_rpc_server("rpc_add_weave_buffs", arg_9_1, unpack(var_9_2))
	end

	arg_9_0._synced_buff_params = var_9_2
end
