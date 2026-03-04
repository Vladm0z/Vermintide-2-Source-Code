-- chunkname: @scripts/unit_extensions/weapons/actions/action_cancel.lua

ActionCancel = class(ActionCancel, ActionBase)

function ActionCancel.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCancel.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

function ActionCancel.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionCancel.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
end

function ActionCancel.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

function ActionCancel.finish(arg_4_0, arg_4_1)
	return
end
