-- chunkname: @scripts/unit_extensions/weaves/weave_item_extension.lua

WeaveItemExtension = class(WeaveItemExtension, BaseObjectiveExtension)
WeaveItemExtension.NAME = "WeaveItemExtension"

WeaveItemExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	WeaveItemExtension.super.init(self, extension_init_context, unit, extension_init_data)
end

WeaveItemExtension.initial_sync_data = function (self, game_object_data_table)
	-- function 2
	game_object_data_table.value = 1
end

WeaveItemExtension._set_objective_data = function (self, objective_data)
	-- function 3
	return
end

WeaveItemExtension._server_update = function (self)
	-- function 4
	return
end

WeaveItemExtension._client_update = function (self)
	-- function 5
	return
end

WeaveItemExtension._activate = function (self)
	-- function 6
	return
end

WeaveItemExtension._deactivate = function (self)
	-- function 7
	return
end

WeaveItemExtension.get_percentage_done = function (self)
	-- function 8
	return 1
end
