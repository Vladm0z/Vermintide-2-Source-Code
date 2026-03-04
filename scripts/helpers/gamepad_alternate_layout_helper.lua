-- chunkname: @scripts/helpers/gamepad_alternate_layout_helper.lua

local var_0_0 = PLATFORM
local var_0_1 = rawget(_G, GamepadLayoutKeymapsTableName)
local var_0_2 = var_0_0 ~= "ps4" and "xb1" or var_0_0

DefaultPlayerControllerKeymaps = PlayerControllerKeymaps[var_0_2]
DefaultPlayerControllerKeymapsPSPad = PlayerControllerKeymaps.ps_pad
DefaultGamepadLayoutKeymaps = {
	PlayerControllerKeymaps = {
		[var_0_2] = DefaultPlayerControllerKeymaps,
		ps_pad = IS_WINDOWS and PlayerControllerKeymaps.ps_pad or nil
	}
}

if IS_WINDOWS then
	local var_0_3 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_3.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_3.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_3.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_3.action_two = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_3.action_two_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_3.action_two_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_3.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	var_0_3.ping = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_3.ping_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_3.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_3.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_3.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_3.jump_1 = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_3.jump_2 = {}
	var_0_3.dodge_1 = {
		"gamepad",
		"a",
		"held"
	}
	var_0_3.dodge_2 = {}
	var_0_3.action_three = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_3.action_three_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_3.action_three_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	KeymapOverride1 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_3
		}
	}

	local var_0_4 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_4.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_4.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_4.jump_1 = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_4.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_4.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_4.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride2 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_4
		}
	}

	local var_0_5 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_5.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_5.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_5.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_5.action_two = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_5.action_two_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_5.action_two_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_5.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	var_0_5.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_5.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_5.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_5.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_5.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_5.jump_1 = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_5.dodge_1 = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_5.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_5.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride3 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_5
		}
	}

	local var_0_6 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_6.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_6.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_6.jump_1 = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_6.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_6.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_6.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_6.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_6.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_6.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	KeymapOverride7 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_6
		}
	}

	local var_0_7 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_7.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_7.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_7.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_7.action_two = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_7.action_two_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_7.action_two_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_7.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	var_0_7.action_inspect = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_7.action_inspect_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_7.action_inspect_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	var_0_7.action_three = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_7.action_three_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_7.action_three_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	var_0_7.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_7.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_7.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_7.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_7.crouch = {
		"gamepad",
		"b",
		"pressed"
	}
	var_0_7.crouching = {
		"gamepad",
		"b",
		"held"
	}
	var_0_7.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_7.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride9 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_7
		}
	}

	local var_0_8 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_8.look_raw_controller = {
		"gamepad",
		"left",
		"axis"
	}
	var_0_8.move_controller = {
		"gamepad",
		"right",
		"axis"
	}
	var_0_8.action_inspect = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_8.action_inspect_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_8.action_inspect_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	var_0_8.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_8.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_8.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_8.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_8.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_8.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_8.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_8.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_8.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_8.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	var_0_8.ping = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_8.ping_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_8.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_8.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_8.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverrideLeft = {
		PlayerControllerKeymaps = {
			xb1 = var_0_8
		}
	}

	local var_0_9 = table.clone(var_0_8)

	var_0_9.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_9.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_9.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_9.action_two = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_9.action_two_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_9.action_two_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_9.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	var_0_9.ping = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_9.ping_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_9.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_9.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_9.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_9.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_9.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_9.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride4 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_9
		}
	}

	local var_0_10 = table.clone(var_0_8)

	var_0_10.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_10.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_10.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_10.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_10.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_10.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_10.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	var_0_10.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_10.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_10.jump_1 = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_10.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_10.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_10.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_10.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_10.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_10.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_10.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_10.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_10.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride5 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_10
		}
	}

	local var_0_11 = table.clone(var_0_8)

	var_0_11.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_11.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_11.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_11.action_two = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_11.action_two_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_11.action_two_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_11.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	var_0_11.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_11.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_11.jump_1 = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_11.dodge_1 = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_11.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_11.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_11.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_11.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_11.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_11.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_11.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_11.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride6 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_11
		}
	}

	local var_0_12 = table.clone(var_0_8)

	var_0_12.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_12.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_12.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_12.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_12.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_12.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_12.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	var_0_12.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_12.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_12.jump_1 = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_12.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_12.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_12.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_12.ability = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_12.ability_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_12.ability_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	KeymapOverride8 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_12
		}
	}

	local var_0_13 = table.clone(var_0_8)

	var_0_13.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_13.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_13.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_13.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_13.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_13.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_13.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	var_0_13.action_inspect = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_13.action_inspect_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_13.action_inspect_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	var_0_13.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_13.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_13.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	var_0_13.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_13.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_13.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_13.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_13.crouch = {
		"gamepad",
		"b",
		"pressed"
	}
	var_0_13.crouching = {
		"gamepad",
		"b",
		"held"
	}
	var_0_13.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_13.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	KeymapOverride10 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_13
		}
	}

	local var_0_14 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	var_0_14.action_one = {
		"ps_pad",
		"r1",
		"pressed"
	}
	var_0_14.action_one_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_14.action_one_release = {
		"ps_pad",
		"r1",
		"released"
	}
	var_0_14.action_two = {
		"ps_pad",
		"l1",
		"pressed"
	}
	var_0_14.action_two_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	var_0_14.action_two_release = {
		"ps_pad",
		"l1",
		"released"
	}
	var_0_14.action_one_softbutton_gamepad = {
		"ps_pad",
		"r1",
		"soft_button"
	}
	var_0_14.ping = {
		"ps_pad",
		"r2",
		"pressed"
	}
	var_0_14.ping_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	var_0_14.ability = {
		"ps_pad",
		"l2",
		"pressed"
	}
	var_0_14.ability_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	var_0_14.ability_release = {
		"ps_pad",
		"l2",
		"released"
	}
	var_0_14.action_three = {
		"ps_pad",
		"r3",
		"pressed"
	}
	var_0_14.action_three_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	var_0_14.action_three_release = {
		"ps_pad",
		"r3",
		"released"
	}
	KeymapOverride1.PlayerControllerKeymaps.ps_pad = var_0_14

	local var_0_15 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	var_0_15.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	var_0_15.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	var_0_15.jump_1 = {
		"ps_pad",
		"r1",
		"pressed"
	}
	var_0_15.dodge_1 = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_15.ping = {
		"ps_pad",
		"l3",
		"pressed"
	}
	var_0_15.ping_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	KeymapOverride2.PlayerControllerKeymaps.ps_pad = var_0_15

	local var_0_16 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	var_0_16.action_one = {
		"ps_pad",
		"r1",
		"pressed"
	}
	var_0_16.action_one_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_16.action_one_release = {
		"ps_pad",
		"r1",
		"released"
	}
	var_0_16.action_two = {
		"ps_pad",
		"l1",
		"pressed"
	}
	var_0_16.action_two_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	var_0_16.action_two_release = {
		"ps_pad",
		"l1",
		"released"
	}
	var_0_16.action_one_softbutton_gamepad = {
		"ps_pad",
		"r1",
		"soft_button"
	}
	var_0_16.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	var_0_16.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	var_0_16.ability = {
		"ps_pad",
		"l2",
		"pressed"
	}
	var_0_16.ability_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	var_0_16.ability_release = {
		"ps_pad",
		"l2",
		"released"
	}
	var_0_16.jump_1 = {
		"ps_pad",
		"r2",
		"pressed"
	}
	var_0_16.dodge_1 = {
		"ps_pad",
		"r2",
		"held"
	}
	var_0_16.ping = {
		"ps_pad",
		"l3",
		"pressed"
	}
	var_0_16.ping_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	KeymapOverride3.PlayerControllerKeymaps.ps_pad = var_0_16

	local var_0_17 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	var_0_17.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	var_0_17.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	var_0_17.jump_1 = {
		"ps_pad",
		"l1",
		"pressed"
	}
	var_0_17.dodge_1 = {
		"ps_pad",
		"l1",
		"held"
	}
	var_0_17.ping = {
		"ps_pad",
		"l3",
		"pressed"
	}
	var_0_17.ping_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	var_0_17.ability = {
		"ps_pad",
		"r1",
		"pressed"
	}
	var_0_17.ability_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_17.ability_release = {
		"ps_pad",
		"r1",
		"released"
	}
	KeymapOverride7.PlayerControllerKeymaps.ps_pad = var_0_17

	local var_0_18 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	var_0_18.action_one = {
		"ps_pad",
		"r1",
		"pressed"
	}
	var_0_18.action_one_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_18.action_one_release = {
		"ps_pad",
		"r1",
		"released"
	}
	var_0_18.action_two = {
		"ps_pad",
		"l2",
		"pressed"
	}
	var_0_18.action_two_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	var_0_18.action_two_release = {
		"ps_pad",
		"l2",
		"released"
	}
	var_0_18.action_one_softbutton_gamepad = {
		"ps_pad",
		"r1",
		"soft_button"
	}
	var_0_18.action_inspect = {
		"ps_pad",
		"r3",
		"pressed"
	}
	var_0_18.action_inspect_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	var_0_18.action_inspect_release = {
		"ps_pad",
		"r3",
		"released"
	}
	var_0_18.action_three = {
		"ps_pad",
		"r3",
		"pressed"
	}
	var_0_18.action_three_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	var_0_18.action_three_release = {
		"ps_pad",
		"r3",
		"released"
	}
	var_0_18.ability = {
		"ps_pad",
		"r2",
		"pressed"
	}
	var_0_18.ability_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	var_0_18.ability_release = {
		"ps_pad",
		"r2",
		"released"
	}
	var_0_18.dodge_1 = {
		"ps_pad",
		"l1",
		"held"
	}
	var_0_18.crouch = {
		"ps_pad",
		"circle",
		"pressed"
	}
	var_0_18.crouching = {
		"ps_pad",
		"circle",
		"held"
	}
	var_0_18.ping = {
		"ps_pad",
		"l3",
		"pressed"
	}
	var_0_18.ping_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	KeymapOverride9.PlayerControllerKeymaps.ps_pad = var_0_18

	local var_0_19 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	var_0_19.look_raw_controller = {
		"ps_pad",
		"left",
		"axis"
	}
	var_0_19.move_controller = {
		"ps_pad",
		"right",
		"axis"
	}
	var_0_19.action_inspect = {
		"ps_pad",
		"r3",
		"pressed"
	}
	var_0_19.action_inspect_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	var_0_19.action_inspect_release = {
		"ps_pad",
		"r3",
		"released"
	}
	var_0_19.ability = {
		"ps_pad",
		"r1",
		"pressed"
	}
	var_0_19.ability_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_19.ability_release = {
		"ps_pad",
		"r1",
		"released"
	}
	var_0_19.action_one = {
		"ps_pad",
		"l2",
		"pressed"
	}
	var_0_19.action_one_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	var_0_19.action_one_release = {
		"ps_pad",
		"l2",
		"released"
	}
	var_0_19.action_two = {
		"ps_pad",
		"r2",
		"pressed"
	}
	var_0_19.action_two_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	var_0_19.action_two_release = {
		"ps_pad",
		"r2",
		"released"
	}
	var_0_19.action_one_softbutton_gamepad = {
		"ps_pad",
		"l2",
		"soft_button"
	}
	var_0_19.ping = {
		"ps_pad",
		"l1",
		"pressed"
	}
	var_0_19.ping_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	var_0_19.action_three = {
		"ps_pad",
		"l3",
		"pressed"
	}
	var_0_19.action_three_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	var_0_19.action_three_release = {
		"ps_pad",
		"l3",
		"released"
	}
	KeymapOverrideLeft.PlayerControllerKeymaps.ps_pad = var_0_19

	local var_0_20 = table.clone(var_0_19)

	var_0_20.action_one = {
		"ps_pad",
		"l1",
		"pressed"
	}
	var_0_20.action_one_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	var_0_20.action_one_release = {
		"ps_pad",
		"l1",
		"released"
	}
	var_0_20.action_two = {
		"ps_pad",
		"r1",
		"pressed"
	}
	var_0_20.action_two_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_20.action_two_release = {
		"ps_pad",
		"r1",
		"released"
	}
	var_0_20.action_one_softbutton_gamepad = {
		"ps_pad",
		"l1",
		"soft_button"
	}
	var_0_20.ping = {
		"ps_pad",
		"l2",
		"pressed"
	}
	var_0_20.ping_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	var_0_20.ability = {
		"ps_pad",
		"r2",
		"pressed"
	}
	var_0_20.ability_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	var_0_20.ability_release = {
		"ps_pad",
		"r2",
		"released"
	}
	var_0_20.action_three = {
		"ps_pad",
		"l3",
		"pressed"
	}
	var_0_20.action_three_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	var_0_20.action_three_release = {
		"ps_pad",
		"l3",
		"released"
	}
	KeymapOverride4.PlayerControllerKeymaps.ps_pad = var_0_20

	local var_0_21 = table.clone(var_0_19)

	var_0_21.action_one = {
		"ps_pad",
		"l2",
		"pressed"
	}
	var_0_21.action_one_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	var_0_21.action_one_release = {
		"ps_pad",
		"l2",
		"released"
	}
	var_0_21.action_two = {
		"ps_pad",
		"r2",
		"pressed"
	}
	var_0_21.action_two_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	var_0_21.action_two_release = {
		"ps_pad",
		"r2",
		"released"
	}
	var_0_21.action_one_softbutton_gamepad = {
		"ps_pad",
		"l2",
		"soft_button"
	}
	var_0_21.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	var_0_21.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	var_0_21.jump_1 = {
		"ps_pad",
		"l1",
		"pressed"
	}
	var_0_21.dodge_1 = {
		"ps_pad",
		"l1",
		"held"
	}
	var_0_21.ping = {
		"ps_pad",
		"r3",
		"pressed"
	}
	var_0_21.ping_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	var_0_21.ability = {
		"ps_pad",
		"r1",
		"pressed"
	}
	var_0_21.ability_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_21.ability_release = {
		"ps_pad",
		"r1",
		"released"
	}
	var_0_21.action_three = {
		"ps_pad",
		"l3",
		"pressed"
	}
	var_0_21.action_three_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	var_0_21.action_three_release = {
		"ps_pad",
		"l3",
		"released"
	}
	KeymapOverride5.PlayerControllerKeymaps.ps_pad = var_0_21

	local var_0_22 = table.clone(var_0_19)

	var_0_22.action_one = {
		"ps_pad",
		"l1",
		"pressed"
	}
	var_0_22.action_one_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	var_0_22.action_one_release = {
		"ps_pad",
		"l1",
		"released"
	}
	var_0_22.action_two = {
		"ps_pad",
		"r1",
		"pressed"
	}
	var_0_22.action_two_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_22.action_two_release = {
		"ps_pad",
		"r1",
		"released"
	}
	var_0_22.action_one_softbutton_gamepad = {
		"ps_pad",
		"l1",
		"soft_button"
	}
	var_0_22.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	var_0_22.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	var_0_22.jump_1 = {
		"ps_pad",
		"l2",
		"pressed"
	}
	var_0_22.dodge_1 = {
		"ps_pad",
		"l2",
		"held"
	}
	var_0_22.ping = {
		"ps_pad",
		"r3",
		"pressed"
	}
	var_0_22.ping_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	var_0_22.ability = {
		"ps_pad",
		"r2",
		"pressed"
	}
	var_0_22.ability_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	var_0_22.ability_release = {
		"ps_pad",
		"r2",
		"released"
	}
	var_0_22.action_three = {
		"ps_pad",
		"l3",
		"pressed"
	}
	var_0_22.action_three_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	var_0_22.action_three_release = {
		"ps_pad",
		"l3",
		"released"
	}
	KeymapOverride6.PlayerControllerKeymaps.ps_pad = var_0_22

	local var_0_23 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	var_0_23.action_one = {
		"ps_pad",
		"l2",
		"pressed"
	}
	var_0_23.action_one_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	var_0_23.action_one_release = {
		"ps_pad",
		"l2",
		"released"
	}
	var_0_23.action_two = {
		"ps_pad",
		"r2",
		"pressed"
	}
	var_0_23.action_two_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	var_0_23.action_two_release = {
		"ps_pad",
		"r2",
		"released"
	}
	var_0_23.action_one_softbutton_gamepad = {
		"ps_pad",
		"l2",
		"soft_button"
	}
	var_0_23.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	var_0_23.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	var_0_23.jump_1 = {
		"ps_pad",
		"r1",
		"pressed"
	}
	var_0_23.dodge_1 = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_23.ping = {
		"ps_pad",
		"r3",
		"pressed"
	}
	var_0_23.ping_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	var_0_23.ability = {
		"ps_pad",
		"l1",
		"pressed"
	}
	var_0_23.ability_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	var_0_23.ability_release = {
		"ps_pad",
		"l1",
		"released"
	}
	KeymapOverride8.PlayerControllerKeymaps.ps_pad = var_0_23

	local var_0_24 = table.clone(var_0_19)

	var_0_24.action_one = {
		"ps_pad",
		"l1",
		"pressed"
	}
	var_0_24.action_one_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	var_0_24.action_one_release = {
		"ps_pad",
		"l1",
		"released"
	}
	var_0_24.action_two = {
		"ps_pad",
		"r2",
		"pressed"
	}
	var_0_24.action_two_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	var_0_24.action_two_release = {
		"ps_pad",
		"r2",
		"released"
	}
	var_0_24.action_one_softbutton_gamepad = {
		"ps_pad",
		"l1",
		"soft_button"
	}
	var_0_24.action_inspect = {
		"ps_pad",
		"l3",
		"pressed"
	}
	var_0_24.action_inspect_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	var_0_24.action_inspect_release = {
		"ps_pad",
		"l3",
		"released"
	}
	var_0_24.action_three = {
		"ps_pad",
		"l3",
		"pressed"
	}
	var_0_24.action_three_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	var_0_24.action_three_release = {
		"ps_pad",
		"l3",
		"released"
	}
	var_0_24.ability = {
		"ps_pad",
		"l2",
		"pressed"
	}
	var_0_24.ability_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	var_0_24.ability_release = {
		"ps_pad",
		"l2",
		"released"
	}
	var_0_24.dodge_1 = {
		"ps_pad",
		"r1",
		"held"
	}
	var_0_24.crouch = {
		"ps_pad",
		"circle",
		"pressed"
	}
	var_0_24.crouching = {
		"ps_pad",
		"circle",
		"held"
	}
	var_0_24.ping = {
		"ps_pad",
		"r3",
		"pressed"
	}
	var_0_24.ping_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	KeymapOverride10.PlayerControllerKeymaps.ps_pad = var_0_24
elseif IS_XB1 then
	local var_0_25 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_25.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_25.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_25.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_25.action_two = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_25.action_two_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_25.action_two_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_25.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	var_0_25.ping = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_25.ping_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_25.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_25.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_25.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_25.action_three = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_25.action_three_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_25.action_three_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	KeymapOverride1 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_25
		}
	}

	local var_0_26 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_26.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_26.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_26.jump_1 = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_26.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_26.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_26.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride2 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_26
		}
	}

	local var_0_27 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_27.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_27.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_27.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_27.action_two = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_27.action_two_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_27.action_two_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_27.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	var_0_27.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_27.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_27.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_27.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_27.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_27.jump_1 = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_27.dodge_1 = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_27.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_27.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride3 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_27
		}
	}

	local var_0_28 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_28.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_28.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_28.jump_1 = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_28.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_28.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_28.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_28.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_28.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_28.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	KeymapOverride7 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_28
		}
	}

	local var_0_29 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_29.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_29.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_29.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_29.action_two = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_29.action_two_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_29.action_two_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_29.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	var_0_29.action_inspect = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_29.action_inspect_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_29.action_inspect_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	var_0_29.action_three = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_29.action_three_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_29.action_three_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	var_0_29.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_29.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_29.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_29.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_29.crouch = {
		"gamepad",
		"b",
		"pressed"
	}
	var_0_29.crouching = {
		"gamepad",
		"b",
		"held"
	}
	var_0_29.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_29.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride9 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_29
		}
	}

	local var_0_30 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_30.look_raw_controller = {
		"gamepad",
		"left",
		"axis"
	}
	var_0_30.move_controller = {
		"gamepad",
		"right",
		"axis"
	}
	var_0_30.action_inspect = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_30.action_inspect_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_30.action_inspect_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	var_0_30.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_30.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_30.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_30.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_30.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_30.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_30.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_30.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_30.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_30.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	var_0_30.ping = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_30.ping_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_30.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_30.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_30.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverrideLeft = {
		PlayerControllerKeymaps = {
			xb1 = var_0_30
		}
	}

	local var_0_31 = table.clone(var_0_30)

	var_0_31.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_31.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_31.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_31.action_two = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_31.action_two_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_31.action_two_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_31.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	var_0_31.ping = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_31.ping_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_31.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_31.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_31.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_31.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_31.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_31.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride4 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_31
		}
	}

	local var_0_32 = table.clone(var_0_30)

	var_0_32.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_32.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_32.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_32.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_32.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_32.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_32.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	var_0_32.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_32.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_32.jump_1 = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_32.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_32.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_32.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_32.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_32.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_32.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_32.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_32.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_32.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride5 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_32
		}
	}

	local var_0_33 = table.clone(var_0_30)

	var_0_33.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_33.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_33.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_33.action_two = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_33.action_two_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_33.action_two_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	var_0_33.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	var_0_33.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_33.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_33.jump_1 = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_33.dodge_1 = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_33.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_33.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_33.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_33.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_33.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_33.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_33.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_33.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride6 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_33
		}
	}

	local var_0_34 = table.clone(var_0_30)

	var_0_34.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_34.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_34.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_34.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_34.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_34.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_34.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	var_0_34.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	var_0_34.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	var_0_34.jump_1 = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	var_0_34.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_34.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_34.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	var_0_34.ability = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_34.ability_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_34.ability_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_34.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_34.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_34.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride8 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_34
		}
	}

	local var_0_35 = table.clone(var_0_30)

	var_0_35.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	var_0_35.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	var_0_35.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	var_0_35.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	var_0_35.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	var_0_35.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	var_0_35.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	var_0_35.action_inspect = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_35.action_inspect_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_35.action_inspect_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	var_0_35.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	var_0_35.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	var_0_35.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	var_0_35.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	var_0_35.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	var_0_35.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	var_0_35.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	var_0_35.crouch = {
		"gamepad",
		"b",
		"pressed"
	}
	var_0_35.crouching = {
		"gamepad",
		"b",
		"held"
	}
	var_0_35.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	var_0_35.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	KeymapOverride10 = {
		PlayerControllerKeymaps = {
			xb1 = var_0_35
		}
	}
elseif IS_PS4 then
	local var_0_36 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_36.action_one = {
		"gamepad",
		"r1",
		"pressed"
	}
	var_0_36.action_one_hold = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_36.action_one_release = {
		"gamepad",
		"r1",
		"released"
	}
	var_0_36.action_two = {
		"gamepad",
		"l1",
		"pressed"
	}
	var_0_36.action_two_hold = {
		"gamepad",
		"l1",
		"held"
	}
	var_0_36.action_two_release = {
		"gamepad",
		"l1",
		"released"
	}
	var_0_36.action_one_softbutton_gamepad = {
		"gamepad",
		"r1",
		"soft_button"
	}
	var_0_36.ping = {
		"gamepad",
		"r2",
		"pressed"
	}
	var_0_36.ping_hold = {
		"gamepad",
		"r2",
		"held"
	}
	var_0_36.ability = {
		"gamepad",
		"l2",
		"pressed"
	}
	var_0_36.ability_hold = {
		"gamepad",
		"l2",
		"held"
	}
	var_0_36.ability_release = {
		"gamepad",
		"l2",
		"released"
	}
	var_0_36.action_three = {
		"gamepad",
		"r3",
		"pressed"
	}
	var_0_36.action_three_hold = {
		"gamepad",
		"r3",
		"held"
	}
	var_0_36.action_three_release = {
		"gamepad",
		"r3",
		"released"
	}
	KeymapOverride1 = {
		PlayerControllerKeymaps = {
			ps4 = var_0_36
		}
	}

	local var_0_37 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_37.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	var_0_37.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	var_0_37.jump_1 = {
		"gamepad",
		"r1",
		"pressed"
	}
	var_0_37.dodge_1 = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_37.ping = {
		"gamepad",
		"l3",
		"pressed"
	}
	var_0_37.ping_hold = {
		"gamepad",
		"l3",
		"held"
	}
	KeymapOverride2 = {
		PlayerControllerKeymaps = {
			ps4 = var_0_37
		}
	}

	local var_0_38 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_38.action_one = {
		"gamepad",
		"r1",
		"pressed"
	}
	var_0_38.action_one_hold = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_38.action_one_release = {
		"gamepad",
		"r1",
		"released"
	}
	var_0_38.action_two = {
		"gamepad",
		"l1",
		"pressed"
	}
	var_0_38.action_two_hold = {
		"gamepad",
		"l1",
		"held"
	}
	var_0_38.action_two_release = {
		"gamepad",
		"l1",
		"released"
	}
	var_0_38.action_one_softbutton_gamepad = {
		"gamepad",
		"r1",
		"soft_button"
	}
	var_0_38.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	var_0_38.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	var_0_38.ability = {
		"gamepad",
		"l2",
		"pressed"
	}
	var_0_38.ability_hold = {
		"gamepad",
		"l2",
		"held"
	}
	var_0_38.ability_release = {
		"gamepad",
		"l2",
		"released"
	}
	var_0_38.jump_1 = {
		"gamepad",
		"r2",
		"pressed"
	}
	var_0_38.dodge_1 = {
		"gamepad",
		"r2",
		"held"
	}
	var_0_38.ping = {
		"gamepad",
		"l3",
		"pressed"
	}
	var_0_38.ping_hold = {
		"gamepad",
		"l3",
		"held"
	}
	KeymapOverride3 = {
		PlayerControllerKeymaps = {
			ps4 = var_0_38
		}
	}

	local var_0_39 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_39.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	var_0_39.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	var_0_39.jump_1 = {
		"gamepad",
		"l1",
		"pressed"
	}
	var_0_39.dodge_1 = {
		"gamepad",
		"l1",
		"held"
	}
	var_0_39.ping = {
		"gamepad",
		"l3",
		"pressed"
	}
	var_0_39.ping_hold = {
		"gamepad",
		"l3",
		"held"
	}
	var_0_39.ability = {
		"gamepad",
		"r1",
		"pressed"
	}
	var_0_39.ability_hold = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_39.ability_release = {
		"gamepad",
		"r1",
		"released"
	}
	KeymapOverride7 = {
		PlayerControllerKeymaps = {
			ps4 = var_0_39
		}
	}

	local var_0_40 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_40.action_one = {
		"gamepad",
		"r1",
		"pressed"
	}
	var_0_40.action_one_hold = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_40.action_one_release = {
		"gamepad",
		"r1",
		"released"
	}
	var_0_40.action_two = {
		"gamepad",
		"l2",
		"pressed"
	}
	var_0_40.action_two_hold = {
		"gamepad",
		"l2",
		"held"
	}
	var_0_40.action_two_release = {
		"gamepad",
		"l2",
		"released"
	}
	var_0_40.action_one_softbutton_gamepad = {
		"gamepad",
		"r1",
		"soft_button"
	}
	var_0_40.action_inspect = {
		"gamepad",
		"r3",
		"pressed"
	}
	var_0_40.action_inspect_hold = {
		"gamepad",
		"r3",
		"held"
	}
	var_0_40.action_inspect_release = {
		"gamepad",
		"r3",
		"released"
	}
	var_0_40.action_three = {
		"gamepad",
		"r3",
		"pressed"
	}
	var_0_40.action_three_hold = {
		"gamepad",
		"r3",
		"held"
	}
	var_0_40.action_three_release = {
		"gamepad",
		"r3",
		"released"
	}
	var_0_40.ability = {
		"gamepad",
		"r2",
		"pressed"
	}
	var_0_40.ability_hold = {
		"gamepad",
		"r2",
		"held"
	}
	var_0_40.ability_release = {
		"gamepad",
		"r2",
		"released"
	}
	var_0_40.dodge_1 = {
		"gamepad",
		"l1",
		"held"
	}
	var_0_40.crouch = {
		"gamepad",
		"circle",
		"pressed"
	}
	var_0_40.crouching = {
		"gamepad",
		"circle",
		"held"
	}
	var_0_40.ping = {
		"gamepad",
		"l3",
		"pressed"
	}
	var_0_40.ping_hold = {
		"gamepad",
		"l3",
		"held"
	}
	KeymapOverride9 = {
		PlayerControllerKeymaps = {
			ps4 = var_0_40
		}
	}

	local var_0_41 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_41.look_raw_controller = {
		"gamepad",
		"left",
		"axis"
	}
	var_0_41.move_controller = {
		"gamepad",
		"right",
		"axis"
	}
	var_0_41.action_inspect = {
		"gamepad",
		"r3",
		"pressed"
	}
	var_0_41.action_inspect_hold = {
		"gamepad",
		"r3",
		"held"
	}
	var_0_41.action_inspect_release = {
		"gamepad",
		"r3",
		"released"
	}
	var_0_41.ability = {
		"gamepad",
		"r1",
		"pressed"
	}
	var_0_41.ability_hold = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_41.ability_release = {
		"gamepad",
		"r1",
		"released"
	}
	var_0_41.action_one = {
		"gamepad",
		"l2",
		"pressed"
	}
	var_0_41.action_one_hold = {
		"gamepad",
		"l2",
		"held"
	}
	var_0_41.action_one_release = {
		"gamepad",
		"l2",
		"released"
	}
	var_0_41.action_two = {
		"gamepad",
		"r2",
		"pressed"
	}
	var_0_41.action_two_hold = {
		"gamepad",
		"r2",
		"held"
	}
	var_0_41.action_two_release = {
		"gamepad",
		"r2",
		"released"
	}
	var_0_41.action_one_softbutton_gamepad = {
		"gamepad",
		"l2",
		"soft_button"
	}
	var_0_41.ping = {
		"gamepad",
		"l1",
		"pressed"
	}
	var_0_41.ping_hold = {
		"gamepad",
		"l1",
		"held"
	}
	var_0_41.action_three = {
		"gamepad",
		"l3",
		"pressed"
	}
	var_0_41.action_three_hold = {
		"gamepad",
		"l3",
		"held"
	}
	var_0_41.action_three_release = {
		"gamepad",
		"l3",
		"released"
	}
	KeymapOverrideLeft = {
		PlayerControllerKeymaps = {
			ps4 = var_0_41
		}
	}

	local var_0_42 = table.clone(var_0_41)

	var_0_42.action_one = {
		"gamepad",
		"l1",
		"pressed"
	}
	var_0_42.action_one_hold = {
		"gamepad",
		"l1",
		"held"
	}
	var_0_42.action_one_release = {
		"gamepad",
		"l1",
		"released"
	}
	var_0_42.action_two = {
		"gamepad",
		"r1",
		"pressed"
	}
	var_0_42.action_two_hold = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_42.action_two_release = {
		"gamepad",
		"r1",
		"released"
	}
	var_0_42.action_one_softbutton_gamepad = {
		"gamepad",
		"l1",
		"soft_button"
	}
	var_0_42.ping = {
		"gamepad",
		"l2",
		"pressed"
	}
	var_0_42.ping_hold = {
		"gamepad",
		"l2",
		"held"
	}
	var_0_42.ability = {
		"gamepad",
		"r2",
		"pressed"
	}
	var_0_42.ability_hold = {
		"gamepad",
		"r2",
		"held"
	}
	var_0_42.ability_release = {
		"gamepad",
		"r2",
		"released"
	}
	var_0_42.action_three = {
		"gamepad",
		"l3",
		"pressed"
	}
	var_0_42.action_three_hold = {
		"gamepad",
		"l3",
		"held"
	}
	var_0_42.action_three_release = {
		"gamepad",
		"l3",
		"released"
	}
	KeymapOverride4 = {
		PlayerControllerKeymaps = {
			ps4 = var_0_42
		}
	}

	local var_0_43 = table.clone(var_0_41)

	var_0_43.action_one = {
		"gamepad",
		"l2",
		"pressed"
	}
	var_0_43.action_one_hold = {
		"gamepad",
		"l2",
		"held"
	}
	var_0_43.action_one_release = {
		"gamepad",
		"l2",
		"released"
	}
	var_0_43.action_two = {
		"gamepad",
		"r2",
		"pressed"
	}
	var_0_43.action_two_hold = {
		"gamepad",
		"r2",
		"held"
	}
	var_0_43.action_two_release = {
		"gamepad",
		"r2",
		"released"
	}
	var_0_43.action_one_softbutton_gamepad = {
		"gamepad",
		"l2",
		"soft_button"
	}
	var_0_43.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	var_0_43.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	var_0_43.jump_1 = {
		"gamepad",
		"l1",
		"pressed"
	}
	var_0_43.dodge_1 = {
		"gamepad",
		"l1",
		"held"
	}
	var_0_43.ping = {
		"gamepad",
		"r3",
		"pressed"
	}
	var_0_43.ping_hold = {
		"gamepad",
		"r3",
		"held"
	}
	var_0_43.ability = {
		"gamepad",
		"r1",
		"pressed"
	}
	var_0_43.ability_hold = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_43.ability_release = {
		"gamepad",
		"r1",
		"released"
	}
	var_0_43.action_three = {
		"gamepad",
		"l3",
		"pressed"
	}
	var_0_43.action_three_hold = {
		"gamepad",
		"l3",
		"held"
	}
	var_0_43.action_three_release = {
		"gamepad",
		"l3",
		"released"
	}
	KeymapOverride5 = {
		PlayerControllerKeymaps = {
			ps4 = var_0_43
		}
	}

	local var_0_44 = table.clone(var_0_41)

	var_0_44.action_one = {
		"gamepad",
		"l1",
		"pressed"
	}
	var_0_44.action_one_hold = {
		"gamepad",
		"l1",
		"held"
	}
	var_0_44.action_one_release = {
		"gamepad",
		"l1",
		"released"
	}
	var_0_44.action_two = {
		"gamepad",
		"r1",
		"pressed"
	}
	var_0_44.action_two_hold = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_44.action_two_release = {
		"gamepad",
		"r1",
		"released"
	}
	var_0_44.action_one_softbutton_gamepad = {
		"gamepad",
		"l1",
		"soft_button"
	}
	var_0_44.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	var_0_44.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	var_0_44.jump_1 = {
		"gamepad",
		"l2",
		"pressed"
	}
	var_0_44.dodge_1 = {
		"gamepad",
		"l2",
		"held"
	}
	var_0_44.ping = {
		"gamepad",
		"r3",
		"pressed"
	}
	var_0_44.ping_hold = {
		"gamepad",
		"r3",
		"held"
	}
	var_0_44.ability = {
		"gamepad",
		"r2",
		"pressed"
	}
	var_0_44.ability_hold = {
		"gamepad",
		"r2",
		"held"
	}
	var_0_44.ability_release = {
		"gamepad",
		"r2",
		"released"
	}
	var_0_44.action_three = {
		"gamepad",
		"l3",
		"pressed"
	}
	var_0_44.action_three_hold = {
		"gamepad",
		"l3",
		"held"
	}
	var_0_44.action_three_release = {
		"gamepad",
		"l3",
		"released"
	}
	KeymapOverride6 = {
		PlayerControllerKeymaps = {
			ps4 = var_0_44
		}
	}

	local var_0_45 = table.clone(DefaultPlayerControllerKeymaps)

	var_0_45.action_one = {
		"gamepad",
		"l2",
		"pressed"
	}
	var_0_45.action_one_hold = {
		"gamepad",
		"l2",
		"held"
	}
	var_0_45.action_one_release = {
		"gamepad",
		"l2",
		"released"
	}
	var_0_45.action_two = {
		"gamepad",
		"r2",
		"pressed"
	}
	var_0_45.action_two_hold = {
		"gamepad",
		"r2",
		"held"
	}
	var_0_45.action_two_release = {
		"gamepad",
		"r2",
		"released"
	}
	var_0_45.action_one_softbutton_gamepad = {
		"gamepad",
		"l2",
		"soft_button"
	}
	var_0_45.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	var_0_45.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	var_0_45.jump_1 = {
		"gamepad",
		"r1",
		"pressed"
	}
	var_0_45.dodge_1 = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_45.ping = {
		"gamepad",
		"r3",
		"pressed"
	}
	var_0_45.ping_hold = {
		"gamepad",
		"r3",
		"held"
	}
	var_0_45.ability = {
		"gamepad",
		"l1",
		"pressed"
	}
	var_0_45.ability_hold = {
		"gamepad",
		"l1",
		"held"
	}
	var_0_45.ability_release = {
		"gamepad",
		"l1",
		"released"
	}
	KeymapOverride8 = {
		PlayerControllerKeymaps = {
			ps4 = var_0_45
		}
	}

	local var_0_46 = table.clone(var_0_41)

	var_0_46.action_one = {
		"gamepad",
		"l1",
		"pressed"
	}
	var_0_46.action_one_hold = {
		"gamepad",
		"l1",
		"held"
	}
	var_0_46.action_one_release = {
		"gamepad",
		"l1",
		"released"
	}
	var_0_46.action_two = {
		"gamepad",
		"r2",
		"pressed"
	}
	var_0_46.action_two_hold = {
		"gamepad",
		"r2",
		"held"
	}
	var_0_46.action_two_release = {
		"gamepad",
		"r2",
		"released"
	}
	var_0_46.action_one_softbutton_gamepad = {
		"gamepad",
		"l1",
		"soft_button"
	}
	var_0_46.action_inspect = {
		"gamepad",
		"l3",
		"pressed"
	}
	var_0_46.action_inspect_hold = {
		"gamepad",
		"l3",
		"held"
	}
	var_0_46.action_inspect_release = {
		"gamepad",
		"l3",
		"released"
	}
	var_0_46.action_three = {
		"gamepad",
		"l3",
		"pressed"
	}
	var_0_46.action_three_hold = {
		"gamepad",
		"l3",
		"held"
	}
	var_0_46.action_three_release = {
		"gamepad",
		"l3",
		"released"
	}
	var_0_46.ability = {
		"gamepad",
		"l2",
		"pressed"
	}
	var_0_46.ability_hold = {
		"gamepad",
		"l2",
		"held"
	}
	var_0_46.ability_release = {
		"gamepad",
		"l2",
		"released"
	}
	var_0_46.dodge_1 = {
		"gamepad",
		"r1",
		"held"
	}
	var_0_46.crouch = {
		"gamepad",
		"circle",
		"pressed"
	}
	var_0_46.crouching = {
		"gamepad",
		"circle",
		"held"
	}
	var_0_46.ping = {
		"gamepad",
		"r3",
		"pressed"
	}
	var_0_46.ping_hold = {
		"gamepad",
		"r3",
		"held"
	}
	KeymapOverride10 = {
		PlayerControllerKeymaps = {
			ps4 = var_0_46
		}
	}
end

AlternatateGamepadKeymapsOptionsMenu = {
	{
		text = "layout_default",
		value = "default"
	},
	{
		text = "layout_alternate_1",
		value = "alternate_1"
	},
	{
		text = "layout_alternate_2",
		value = "alternate_2"
	},
	{
		text = "layout_alternate_3",
		value = "alternate_3"
	},
	{
		text = "layout_alternate_4",
		value = "alternate_4"
	},
	{
		text = "layout_alternate_5",
		value = "alternate_5"
	}
}
AlternatateGamepadKeymapsLayouts = {
	default = DefaultGamepadLayoutKeymaps,
	alternate_1 = KeymapOverride1,
	alternate_2 = KeymapOverride2,
	alternate_3 = KeymapOverride3,
	alternate_4 = KeymapOverride7,
	alternate_5 = KeymapOverride9
}
AlternatateGamepadKeymapsLayoutsLeftHanded = {
	default = KeymapOverrideLeft,
	alternate_1 = KeymapOverride4,
	alternate_2 = KeymapOverride5,
	alternate_3 = KeymapOverride6,
	alternate_4 = KeymapOverride8,
	alternate_5 = KeymapOverride10
}

if IS_WINDOWS then
	AlternatateGamepadSettings = {
		default = {
			ignore_gamepad_action_names = {
				dark_pact_reload_hold = true,
				dodge_2 = true,
				dark_pact_action_one_release = true,
				active_ability_right_pressed = true,
				action_one_release = true,
				active_ability_right_held = true,
				wield_switch_1 = true,
				interacting = true,
				dark_pact_reload = true,
				action_three_release = true,
				previous_observer_target = true,
				ghost_mode_exit = true,
				crouching = true,
				move_left_pressed = true,
				ability_release = true,
				action_two_hold = true,
				emote_toggle_hud_visibility = true,
				social_wheel_page = true,
				action_one_mouse = true,
				emote_camera_zoom_in = true,
				ghost_mode_enter = true,
				action_two_release = true,
				dark_pact_interact = true,
				next_observer_target = true,
				dark_pact_action_two_hold = true,
				dark_pact_action_two_release = true,
				action_three_hold = true,
				action_inspect_release = true,
				dark_pact_action_one_hold = true,
				emote_camera_zoom = true,
				dark_pact_interacting = true,
				wield_switch = true,
				active_ability_left_release = true,
				weapon_reload_hold_input = true,
				dark_pact_climb_point = true,
				dark_pact_action_one = true,
				wield_switch_2 = true,
				active_ability_right_release = true,
				dark_pact_action_two = true,
				action_inspect_hold = true,
				active_ability_left_pressed = true,
				active_ability_left_held = true,
				action_one_hold = true,
				emote_camera_zoom_out = true,
				ping_release = true,
				ping_hold = true,
				versus_horde_ability = true,
				action_one_softbutton_gamepad = true,
				ability_hold = true,
				weapon_reload_hold_input_input = true
			},
			replace_gamepad_action_names = {
				dodge_1 = "mission_objective_prologue_dodge",
				jump_1 = "mission_objective_prologue_jumping",
				ping = "lb_ping"
			},
			default_gamepad_actions_by_key = {
				ls = "move_controller",
				start = "toggle_menu",
				y = "wield_switch",
				back = "ingame_player_list_toggle",
				rs = "look_raw_controller"
			}
		},
		left_handed = {
			ignore_gamepad_action_names = {
				dark_pact_reload_hold = true,
				emote_toggle_hud_visibility = true,
				dark_pact_action_one_release = true,
				next_observer_target = true,
				dodge_2 = true,
				active_ability_right_held = true,
				wield_switch_1 = true,
				action_one_release = true,
				dark_pact_reload = true,
				action_three_release = true,
				action_three_hold = true,
				ghost_mode_exit = true,
				crouching = true,
				move_left_pressed = true,
				ability_release = true,
				action_two_hold = true,
				social_wheel_page = true,
				emote_camera_zoom_in = true,
				action_one_mouse = true,
				ghost_mode_enter = true,
				action_two_release = true,
				dark_pact_action_one_hold = true,
				dark_pact_interact = true,
				dark_pact_action_two_hold = true,
				dark_pact_action_two_release = true,
				interacting = true,
				emote_camera_zoom = true,
				active_ability_right_pressed = true,
				dark_pact_interacting = true,
				action_inspect_release = true,
				dark_pact_climb_point = true,
				wield_switch = true,
				active_ability_left_release = true,
				weapon_reload_hold_input = true,
				dark_pact_action_one = true,
				wield_switch_2 = true,
				active_ability_right_release = true,
				dark_pact_action_two = true,
				action_inspect_hold = true,
				active_ability_left_pressed = true,
				active_ability_left_held = true,
				action_one_hold = true,
				emote_camera_zoom_out = true,
				ping_release = true,
				ping_hold = true,
				versus_horde_ability = true,
				action_one_softbutton_gamepad = true,
				ability_hold = true,
				previous_observer_target = true
			},
			replace_gamepad_action_names = {
				dodge_1 = "mission_objective_prologue_dodge",
				jump_1 = "mission_objective_prologue_jumping",
				ping = "lb_ping"
			},
			default_gamepad_actions_by_key = {
				ls = "look_raw_controller",
				start = "toggle_menu",
				y = "wield_switch",
				back = "ingame_player_list_toggle",
				rs = "move_controller"
			}
		}
	}
elseif IS_XB1 then
	AlternatateGamepadSettings = {
		default = {
			ignore_gamepad_action_names = {
				dark_pact_reload_hold = true,
				emote_toggle_hud_visibility = true,
				dark_pact_action_one_release = true,
				next_observer_target = true,
				wield_switch_2 = true,
				social_wheel_page = true,
				wield_switch_1 = true,
				active_ability_right_pressed = true,
				dark_pact_reload = true,
				action_three_release = true,
				dodge_2 = true,
				ghost_mode_exit = true,
				crouching = true,
				move_left_pressed = true,
				ability_release = true,
				action_two_hold = true,
				action_three_hold = true,
				action_two_release = true,
				action_one_mouse = true,
				ghost_mode_enter = true,
				interacting = true,
				dark_pact_action_one_hold = true,
				dark_pact_interact = true,
				dark_pact_action_two_hold = true,
				dark_pact_action_two_release = true,
				action_one_release = true,
				emote_camera_zoom = true,
				active_ability_right_held = true,
				dark_pact_interacting = true,
				action_inspect_release = true,
				dark_pact_climb_point = true,
				active_ability_left_release = true,
				weapon_reload_hold_input = true,
				dark_pact_action_one = true,
				emote_camera_zoom_in = true,
				active_ability_right_release = true,
				dark_pact_action_two = true,
				action_inspect_hold = true,
				active_ability_left_pressed = true,
				active_ability_left_held = true,
				action_one_hold = true,
				emote_camera_zoom_out = true,
				ping_release = true,
				versus_horde_ability = true,
				action_one_softbutton_gamepad = true,
				ability_hold = true,
				previous_observer_target = true
			},
			replace_gamepad_action_names = {
				dodge_1 = "mission_objective_prologue_dodge",
				jump_1 = "mission_objective_prologue_jumping",
				ping = "lb_ping"
			},
			default_gamepad_actions_by_key = {
				ls = "move_controller",
				start = "toggle_menu",
				y = "wield_switch",
				back = "ingame_player_list_toggle",
				rs = "look_raw_controller"
			}
		},
		left_handed = {
			ignore_gamepad_action_names = {
				dark_pact_reload_hold = true,
				emote_toggle_hud_visibility = true,
				dark_pact_action_one_release = true,
				active_ability_right_pressed = true,
				next_observer_target = true,
				social_wheel_page = true,
				wield_switch_1 = true,
				dodge_2 = true,
				dark_pact_reload = true,
				action_three_release = true,
				interacting = true,
				ghost_mode_exit = true,
				crouching = true,
				move_left_pressed = true,
				ability_release = true,
				action_two_hold = true,
				action_two_release = true,
				emote_camera_zoom_in = true,
				action_one_mouse = true,
				ghost_mode_enter = true,
				action_three_hold = true,
				dark_pact_action_one_hold = true,
				dark_pact_interact = true,
				dark_pact_action_two_hold = true,
				dark_pact_action_two_release = true,
				action_one_release = true,
				emote_camera_zoom = true,
				active_ability_right_held = true,
				dark_pact_interacting = true,
				action_inspect_release = true,
				dark_pact_climb_point = true,
				wield_switch = true,
				active_ability_left_release = true,
				weapon_reload_hold_input = true,
				dark_pact_action_one = true,
				wield_switch_2 = true,
				active_ability_right_release = true,
				dark_pact_action_two = true,
				action_inspect_hold = true,
				active_ability_left_pressed = true,
				active_ability_left_held = true,
				action_one_hold = true,
				emote_camera_zoom_out = true,
				ping_release = true,
				versus_horde_ability = true,
				action_one_softbutton_gamepad = true,
				ability_hold = true,
				previous_observer_target = true
			},
			replace_gamepad_action_names = {
				dodge_1 = "mission_objective_prologue_dodge",
				jump_1 = "mission_objective_prologue_jumping",
				ping = "lb_ping"
			},
			default_gamepad_actions_by_key = {
				ls = "look_raw_controller",
				start = "toggle_menu",
				y = "wield_switch",
				back = "ingame_player_list_toggle",
				rs = "move_controller"
			}
		}
	}
elseif IS_PS4 then
	AlternatateGamepadSettings = {
		default = {
			ignore_gamepad_action_names = {
				dark_pact_reload_hold = true,
				emote_toggle_hud_visibility = true,
				dark_pact_action_one_release = true,
				next_observer_target = true,
				wield_switch_2 = true,
				social_wheel_page = true,
				wield_switch_1 = true,
				active_ability_right_pressed = true,
				dark_pact_reload = true,
				action_three_release = true,
				dodge_2 = true,
				ghost_mode_exit = true,
				crouching = true,
				move_left_pressed = true,
				ability_release = true,
				action_two_hold = true,
				action_three_hold = true,
				action_two_release = true,
				action_one_mouse = true,
				ghost_mode_enter = true,
				interacting = true,
				dark_pact_action_one_hold = true,
				dark_pact_interact = true,
				dark_pact_action_two_hold = true,
				dark_pact_action_two_release = true,
				action_one_release = true,
				emote_camera_zoom = true,
				active_ability_right_held = true,
				dark_pact_interacting = true,
				action_inspect_release = true,
				dark_pact_climb_point = true,
				active_ability_left_release = true,
				weapon_reload_hold_input = true,
				dark_pact_action_one = true,
				emote_camera_zoom_in = true,
				active_ability_right_release = true,
				dark_pact_action_two = true,
				action_inspect_hold = true,
				active_ability_left_pressed = true,
				active_ability_left_held = true,
				action_one_hold = true,
				emote_camera_zoom_out = true,
				ping_release = true,
				versus_horde_ability = true,
				action_one_softbutton_gamepad = true,
				ability_hold = true,
				previous_observer_target = true
			},
			replace_gamepad_action_names = {
				dodge_1 = "mission_objective_prologue_dodge",
				jump_1 = "mission_objective_prologue_jumping",
				ping = "lb_ping"
			},
			default_gamepad_actions_by_key = {
				ls = "move_controller",
				triangle = "wield_switch",
				options = "toggle_menu",
				touch = "ingame_player_list_toggle",
				rs = "look_raw_controller"
			}
		},
		left_handed = {
			ignore_gamepad_action_names = {
				dark_pact_reload_hold = true,
				emote_toggle_hud_visibility = true,
				dark_pact_action_one_release = true,
				active_ability_right_pressed = true,
				next_observer_target = true,
				social_wheel_page = true,
				wield_switch_1 = true,
				dodge_2 = true,
				dark_pact_reload = true,
				action_three_release = true,
				interacting = true,
				ghost_mode_exit = true,
				crouching = true,
				move_left_pressed = true,
				ability_release = true,
				action_two_hold = true,
				action_two_release = true,
				emote_camera_zoom_in = true,
				action_one_mouse = true,
				ghost_mode_enter = true,
				action_three_hold = true,
				dark_pact_action_one_hold = true,
				dark_pact_interact = true,
				dark_pact_action_two_hold = true,
				dark_pact_action_two_release = true,
				action_one_release = true,
				emote_camera_zoom = true,
				active_ability_right_held = true,
				dark_pact_interacting = true,
				action_inspect_release = true,
				dark_pact_climb_point = true,
				wield_switch = true,
				active_ability_left_release = true,
				weapon_reload_hold_input = true,
				dark_pact_action_one = true,
				wield_switch_2 = true,
				active_ability_right_release = true,
				dark_pact_action_two = true,
				action_inspect_hold = true,
				active_ability_left_pressed = true,
				active_ability_left_held = true,
				action_one_hold = true,
				emote_camera_zoom_out = true,
				ping_release = true,
				versus_horde_ability = true,
				action_one_softbutton_gamepad = true,
				ability_hold = true,
				previous_observer_target = true
			},
			replace_gamepad_action_names = {
				dodge_1 = "mission_objective_prologue_dodge",
				jump_1 = "mission_objective_prologue_jumping",
				ping = "lb_ping"
			},
			default_gamepad_actions_by_key = {
				ls = "look_raw_controller",
				triangle = "wield_switch",
				options = "toggle_menu",
				touch = "ingame_player_list_toggle",
				rs = "move_controller"
			}
		}
	}
end
