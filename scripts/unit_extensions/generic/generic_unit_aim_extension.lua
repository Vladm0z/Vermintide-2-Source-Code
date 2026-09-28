-- chunkname: @scripts/unit_extensions/generic/generic_unit_aim_extension.lua

require("scripts/unit_extensions/generic/aim_templates")

GenericUnitAimExtension = class(GenericUnitAimExtension)

GenericUnitAimExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.unit = unit

	local AimTemplates = AimTemplates
	local template = extension_init_data.template

	template = not not template or not not Unit.get_data(unit, "aim_template")
	self.template = AimTemplates[template]

	local flag

	flag = (not extension_init_data.is_husk or not "husk") and not not "owner"
	self.network_type = flag
	self.data = {}
	self.enabled = false
end

GenericUnitAimExtension.extensions_ready = function (self)
	-- function 2
	local template = self.template

	template[self.network_type].init(self.unit, self.data)

	local breed = Unit.get_data(self.unit, "breed")
	local DEDICATED_SERVER = DEDICATED_SERVER

	if not DEDICATED_SERVER then
		if breed then
			DEDICATED_SERVER = breed.always_look_at_target

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
	local template = self.template

	template[self.network_type].leave(self.unit, self.data)

	self.template = nil
	self.data = nil
end

GenericUnitAimExtension.reset = function (self)
	-- function 4
	return
end

GenericUnitAimExtension.set_enabled = function (self, enable)
	-- function 5
	self.enabled = enable
end

GenericUnitAimExtension.update = function (self, unit, input, dt, context, t)
	-- function 6
	local data = self.data
	local template = self.template
	local is_player = DamageUtils.is_player_unit(unit)
	local enabled = self.enabled

	if not enabled then
		-- Nothing
	end

	enabled = self.always_aim

	if not enabled then
		-- Nothing
	end

	enabled = is_player

	local should_aim = enabled

	::label_6_0::

	if should_aim then
		template[self.network_type].update(unit, t, dt, data)
	else
		template[self.network_type].leave(unit, data)
	end
end
