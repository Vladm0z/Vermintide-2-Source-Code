-- chunkname: @scripts/managers/backend_playfab/backend_interface_keep_decorations_playfab.lua

local var_0_0 = require("PlayFab.PlayFabClientApi")

BackendInterfaceKeepDecorationsPlayFab = class(BackendInterfaceKeepDecorationsPlayFab)

BackendInterfaceKeepDecorationsPlayFab.init = function (arg_1_0, arg_1_1)
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._keep_decorations = {}

	local var_1_0 = arg_1_1:get_read_only_data("keep_decorations") or "{}"

	arg_1_0._keep_decorations = cjson.decode(var_1_0)

	arg_1_0:_refresh()

	for iter_1_0, iter_1_1 in pairs(arg_1_0._keep_decorations) do
		if iter_1_1 ~= "hidden" and iter_1_1 ~= "hor_none" and not table.contains(arg_1_0._unlocked_keep_decorations, iter_1_1) then
			arg_1_0._keep_decorations[iter_1_0] = "hor_none"
		end
	end
end

BackendInterfaceKeepDecorationsPlayFab.dirtify = function (arg_2_0)
	arg_2_0._dirty = true
end

BackendInterfaceKeepDecorationsPlayFab.ready = function (arg_3_0)
	return true
end

BackendInterfaceKeepDecorationsPlayFab._refresh = function (arg_4_0)
	local var_4_0 = arg_4_0._backend_mirror:get_unlocked_keep_decorations()

	arg_4_0._unlocked_keep_decorations = var_4_0

	local var_4_1 = ItemHelper.get_new_keep_decoration_ids()

	if var_4_1 then
		for iter_4_0, iter_4_1 in pairs(var_4_1) do
			if not var_4_0[iter_4_0] then
				ItemHelper.unmark_keep_decoration_as_new(iter_4_0)
			end
		end
	end
end

BackendInterfaceKeepDecorationsPlayFab.update = function (arg_5_0, arg_5_1)
	return
end

BackendInterfaceKeepDecorationsPlayFab.get_decoration = function (arg_6_0, arg_6_1)
	return arg_6_0._keep_decorations[arg_6_1]
end

BackendInterfaceKeepDecorationsPlayFab.set_decoration = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._keep_decorations[arg_7_1] = arg_7_2
end

BackendInterfaceKeepDecorationsPlayFab.get_keep_decorations_json = function (arg_8_0)
	return cjson.encode(arg_8_0._keep_decorations)
end

BackendInterfaceKeepDecorationsPlayFab.get_unlocked_keep_decorations = function (arg_9_0)
	if arg_9_0._dirty then
		arg_9_0:_refresh()
	end

	return arg_9_0._unlocked_keep_decorations
end
