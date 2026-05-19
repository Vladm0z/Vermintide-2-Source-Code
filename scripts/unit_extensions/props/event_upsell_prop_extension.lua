-- chunkname: @scripts/unit_extensions/props/event_upsell_prop_extension.lua

EventUpsellPropExtension = class(EventUpsellPropExtension)

function EventUpsellPropExtension.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._unit = arg_1_2
	arg_1_0._has_active_event = false

	arg_1_0:_set_highlight(false)
	arg_1_0:_evaluate_highlight_status()
end

function EventUpsellPropExtension.update(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	return
end

function EventUpsellPropExtension._evaluate_highlight_status(arg_3_0)
	local var_3_0 = false
	local var_3_1 = Managers.backend:get_interface("live_events")

	if var_3_1 and var_3_1.get_active_events then
		local var_3_2 = var_3_1:get_active_events()

		if var_3_2 and #var_3_2 ~= 0 then
			var_3_0 = true
			arg_3_0._active_event_name = var_3_2[1]
		end
	end

	local var_3_3 = var_3_0

	if var_3_3 ~= arg_3_0._highlighted then
		arg_3_0:_set_highlight(var_3_3)
	end
end

function EventUpsellPropExtension._set_highlight(arg_4_0, arg_4_1)
	if arg_4_1 == true then
		Unit.flow_event(arg_4_0._unit, "enable_vfx")

		if arg_4_0._active_event_name then
			local var_4_0 = UISettings.event_global_shader_flags_override_lookup[arg_4_0._active_event_name]

			if var_4_0 then
				GlobalShaderFlags.set_global_shader_flag(var_4_0, true)
			end
		end
	else
		Unit.flow_event(arg_4_0._unit, "disable_vfx")
	end

	arg_4_0._highlighted = arg_4_1
end
