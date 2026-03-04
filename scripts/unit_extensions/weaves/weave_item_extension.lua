-- chunkname: @scripts/unit_extensions/weaves/weave_item_extension.lua

WeaveItemExtension = class(WeaveItemExtension, BaseObjectiveExtension)
WeaveItemExtension.NAME = "WeaveItemExtension"

WeaveItemExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	WeaveItemExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
end

WeaveItemExtension.initial_sync_data = function (arg_2_0, arg_2_1)
	arg_2_1.value = 1
end

WeaveItemExtension._set_objective_data = function (arg_3_0, arg_3_1)
	return
end

WeaveItemExtension._server_update = function (arg_4_0)
	return
end

WeaveItemExtension._client_update = function (arg_5_0)
	return
end

WeaveItemExtension._activate = function (arg_6_0)
	return
end

WeaveItemExtension._deactivate = function (arg_7_0)
	return
end

WeaveItemExtension.get_percentage_done = function (arg_8_0)
	return 1
end
