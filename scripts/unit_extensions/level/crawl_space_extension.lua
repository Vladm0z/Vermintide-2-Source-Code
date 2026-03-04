-- chunkname: @scripts/unit_extensions/level/crawl_space_extension.lua

CrawlSpaceExtension = class(CrawlSpaceExtension)

function CrawlSpaceExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.partner_unit = nil
	arg_1_0.entrance_type = Unit.get_data(arg_1_2, "entrance_type")

	local var_1_0 = Unit.local_position(arg_1_2, 0)
	local var_1_1 = Unit.local_rotation(arg_1_2, 0)

	if arg_1_0.entrance_type == "manhole" or arg_1_0.entrance_type == "well" then
		var_1_1 = Quaternion.multiply(var_1_1, Quaternion.from_euler_angles_xyz(90, 0, 0))
	end

	local var_1_2 = Vector3.flat(Quaternion.forward(var_1_1))

	arg_1_0.enter_rot = Vector3Box(var_1_2)
	arg_1_0.enter_pos = Vector3Box(var_1_0 - var_1_2 + Vector3.down())
	arg_1_0.entrance_type = Unit.get_data(arg_1_2, "entrance_type")
	arg_1_0.id = Unit.get_data(arg_1_2, "crawl_space_id")
	arg_1_0.type = arg_1_0.id == 0 and "spawner" or "tunnel"
end

function CrawlSpaceExtension.extensions_ready(arg_2_0)
	if arg_2_0.entrance_type == "chimney" then
		ScriptUnit.extension(arg_2_0.unit, "interactable_system"):set_enabled(false)
	end
end

function CrawlSpaceExtension.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

function CrawlSpaceExtension.hot_join_sync(arg_4_0, arg_4_1)
	return
end

function CrawlSpaceExtension.destroy(arg_5_0)
	arg_5_0.unit = nil
	arg_5_0.partner_unit = nil
end
