-- chunkname: @scripts/unit_extensions/generic/generic_unit_aim_extension.lua

require("scripts/unit_extensions/generic/aim_templates")

GenericUnitAimExtension = class(GenericUnitAimExtension)

GenericUnitAimExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2

	local AimTemplates = AimTemplates
	local template = arg_1_3.template

	template = template or Unit.get_data(arg_1_2, "aim_template")
	self.template = AimTemplates[template]

	local flag

	flag = not arg_1_3.is_husk and "husk" and "owner"
	self.network_type = flag
	self.data = {}
	self.enabled = false
end

GenericUnitAimExtension.extensions_ready = function (self)
	-- function 2
	self.template[self.network_type].init(self.unit, self.data)

	local get_data = Unit.get_data(self.unit, "breed")
	local DEDICATED_SERVER = DEDICATED_SERVER

	if not DEDICATED_SERVER then
		if not get_data then
			DEDICATED_SERVER = get_data.always_look_at_target

			if not DEDICATED_SERVER then
				-- Nothing
			end
		end

		DEDICATED_SERVER = self.template == "innkeeper"
	end

	::label_2_0::

	self.always_aim = DEDICATED_SERVER
end

GenericUnitAimExtension.destroy = function (self)
	-- function 3
	self.template[self.network_type].leave(self.unit, self.data)

	self.template = nil
	self.data = nil
end

GenericUnitAimExtension.reset = function (arg_4_0)
	-- function 4
	return
end

GenericUnitAimExtension.set_enabled = function (self, arg_5_1)
	-- function 5
	self.enabled = arg_5_1
end

GenericUnitAimExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local data = self.data
	local template = self.template
	local is_player_unit = DamageUtils.is_player_unit(arg_6_1)
	local enabled = self.enabled

	if not enabled then
		enabled = self.always_aim
		enabled = enabled or is_player_unit
	end

	if not enabled then
		template[self.network_type].update(arg_6_1, arg_6_5, arg_6_3, data)
	else
		template[self.network_type].leave(arg_6_1, data)
	end
end
