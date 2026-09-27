-- chunkname: @scripts/unit_extensions/level/crawl_space_extension.lua

CrawlSpaceExtension = class(CrawlSpaceExtension)

CrawlSpaceExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.partner_unit = nil
	self.entrance_type = Unit.get_data(arg_1_2, "entrance_type")

	local local_position = Unit.local_position(arg_1_2, 0)
	local local_rotation = Unit.local_rotation(arg_1_2, 0)

	if not (self.entrance_type == "manhole" or self.entrance_type ~= "well") then
		local_rotation = Quaternion.multiply(local_rotation, Quaternion.from_euler_angles_xyz(90, 0, 0))
	end

	local flat = Vector3.flat(Quaternion.forward(local_rotation))

	self.enter_rot = Vector3Box(flat)
	self.enter_pos = Vector3Box(local_position - flat + Vector3.down())
	self.entrance_type = Unit.get_data(arg_1_2, "entrance_type")
	self.id = Unit.get_data(arg_1_2, "crawl_space_id")

	local flag

	flag = self.id ~= 0 or not "spawner" or "tunnel"
	self.type = flag
end

CrawlSpaceExtension.extensions_ready = function (self)
	-- function 2
	if self.entrance_type == "chimney" then
		ScriptUnit.extension(self.unit, "interactable_system"):set_enabled(false)
	end
end

CrawlSpaceExtension.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

CrawlSpaceExtension.hot_join_sync = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

CrawlSpaceExtension.destroy = function (self)
	-- function 5
	self.unit = nil
	self.partner_unit = nil
end
