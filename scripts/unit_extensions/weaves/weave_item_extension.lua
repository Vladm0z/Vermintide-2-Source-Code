-- chunkname: @scripts/unit_extensions/weaves/weave_item_extension.lua

WeaveItemExtension = class(WeaveItemExtension, BaseObjectiveExtension)
WeaveItemExtension.NAME = "WeaveItemExtension"

function WeaveItemExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	WeaveItemExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
end

function WeaveItemExtension.initial_sync_data(arg_2_0, arg_2_1)
	arg_2_1.value = 1
end

function WeaveItemExtension._set_objective_data(arg_3_0, arg_3_1)
	return
end

function WeaveItemExtension._server_update(arg_4_0)
	return
end

function WeaveItemExtension._client_update(arg_5_0)
	return
end

function WeaveItemExtension._activate(arg_6_0)
	return
end

function WeaveItemExtension._deactivate(arg_7_0)
	return
end

function WeaveItemExtension.get_percentage_done(arg_8_0)
	return 1
end
