-- chunkname: @scripts/unit_extensions/props/event_upsell_prop_extension.lua

EventUpsellPropExtension = class(EventUpsellPropExtension)

EventUpsellPropExtension.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._unit = arg_1_2
	self._has_active_event = false

	self:_set_highlight(false)
	self:_evaluate_highlight_status()
end

EventUpsellPropExtension.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	return
end

EventUpsellPropExtension._evaluate_highlight_status = function (self)
	-- function 3
	local flag = false
	local get_interface = Managers.backend:get_interface("live_events")

	if not get_interface and not get_interface.get_active_events then
		local get_active_events = get_interface:get_active_events()

		if not (not get_active_events and #get_active_events == 0) then
			flag = true
			self._active_event_name = get_active_events[1]
		end
	end

	local var_3_3 = flag

	if not (var_3_3 ~= self._highlighted) then
		self:_set_highlight(var_3_3)
	end
end

EventUpsellPropExtension._set_highlight = function (self, arg_4_1)
	-- function 4
	if arg_4_1 == true then
		Unit.flow_event(self._unit, "enable_vfx")

		if not self._active_event_name then
			local var_4_0 = UISettings.event_global_shader_flags_override_lookup[self._active_event_name]

			if not var_4_0 then
				GlobalShaderFlags.set_global_shader_flag(var_4_0, true)
			end
		end
	else
		Unit.flow_event(self._unit, "disable_vfx")
	end

	self._highlighted = arg_4_1
end
