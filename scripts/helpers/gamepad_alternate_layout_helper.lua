-- chunkname: @scripts/helpers/gamepad_alternate_layout_helper.lua

local PLATFORM = PLATFORM
local var_0_1 = rawget(_G, GamepadLayoutKeymapsTableName)
local flag

flag = PLATFORM == "ps4" or not "xb1" or PLATFORM
DefaultPlayerControllerKeymaps = PlayerControllerKeymaps[flag]
DefaultPlayerControllerKeymapsPSPad = PlayerControllerKeymaps.ps_pad

local tbl = {}
local tbl_2 = {
	[flag] = DefaultPlayerControllerKeymaps
}
local ps_pad

if not IS_WINDOWS then
	ps_pad = PlayerControllerKeymaps.ps_pad

	if not ps_pad then
		-- Nothing
	end
end

ps_pad = nil

::label_0_0::

tbl_2.ps_pad = ps_pad
tbl.PlayerControllerKeymaps = tbl_2
DefaultGamepadLayoutKeymaps = tbl

if not IS_WINDOWS then
	local clone = table.clone(DefaultPlayerControllerKeymaps)

	clone.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone.action_two = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone.action_two_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone.action_two_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	clone.ping = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone.ping_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone.jump_1 = {
		"gamepad",
		"a",
		"pressed"
	}
	clone.jump_2 = {}
	clone.dodge_1 = {
		"gamepad",
		"a",
		"held"
	}
	clone.dodge_2 = {}
	clone.action_three = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone.action_three_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone.action_three_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	KeymapOverride1 = {
		PlayerControllerKeymaps = {
			xb1 = clone
		}
	}

	local clone_2 = table.clone(DefaultPlayerControllerKeymaps)

	clone_2.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_2.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_2.jump_1 = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_2.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_2.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_2.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride2 = {
		PlayerControllerKeymaps = {
			xb1 = clone_2
		}
	}

	local clone_3 = table.clone(DefaultPlayerControllerKeymaps)

	clone_3.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_3.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_3.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_3.action_two = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_3.action_two_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_3.action_two_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone_3.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	clone_3.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_3.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_3.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_3.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_3.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_3.jump_1 = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_3.dodge_1 = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_3.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_3.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride3 = {
		PlayerControllerKeymaps = {
			xb1 = clone_3
		}
	}

	local clone_4 = table.clone(DefaultPlayerControllerKeymaps)

	clone_4.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_4.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_4.jump_1 = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_4.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_4.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_4.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_4.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_4.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_4.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	KeymapOverride7 = {
		PlayerControllerKeymaps = {
			xb1 = clone_4
		}
	}

	local clone_5 = table.clone(DefaultPlayerControllerKeymaps)

	clone_5.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_5.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_5.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_5.action_two = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_5.action_two_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_5.action_two_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_5.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	clone_5.action_inspect = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_5.action_inspect_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_5.action_inspect_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	clone_5.action_three = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_5.action_three_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_5.action_three_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	clone_5.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_5.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_5.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_5.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_5.crouch = {
		"gamepad",
		"b",
		"pressed"
	}
	clone_5.crouching = {
		"gamepad",
		"b",
		"held"
	}
	clone_5.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_5.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride9 = {
		PlayerControllerKeymaps = {
			xb1 = clone_5
		}
	}

	local clone_6 = table.clone(DefaultPlayerControllerKeymaps)

	clone_6.look_raw_controller = {
		"gamepad",
		"left",
		"axis"
	}
	clone_6.move_controller = {
		"gamepad",
		"right",
		"axis"
	}
	clone_6.action_inspect = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_6.action_inspect_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_6.action_inspect_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	clone_6.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_6.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_6.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_6.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_6.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_6.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_6.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_6.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_6.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_6.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	clone_6.ping = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_6.ping_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_6.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_6.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_6.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverrideLeft = {
		PlayerControllerKeymaps = {
			xb1 = clone_6
		}
	}

	local clone_7 = table.clone(clone_6)

	clone_7.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_7.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_7.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone_7.action_two = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_7.action_two_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_7.action_two_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_7.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	clone_7.ping = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_7.ping_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_7.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_7.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_7.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_7.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_7.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_7.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride4 = {
		PlayerControllerKeymaps = {
			xb1 = clone_7
		}
	}

	local clone_8 = table.clone(clone_6)

	clone_8.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_8.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_8.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_8.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_8.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_8.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_8.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	clone_8.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_8.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_8.jump_1 = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_8.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_8.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_8.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_8.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_8.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_8.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_8.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_8.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_8.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride5 = {
		PlayerControllerKeymaps = {
			xb1 = clone_8
		}
	}

	local clone_9 = table.clone(clone_6)

	clone_9.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_9.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_9.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone_9.action_two = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_9.action_two_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_9.action_two_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_9.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	clone_9.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_9.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_9.jump_1 = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_9.dodge_1 = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_9.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_9.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_9.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_9.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_9.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_9.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_9.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_9.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride6 = {
		PlayerControllerKeymaps = {
			xb1 = clone_9
		}
	}

	local clone_10 = table.clone(clone_6)

	clone_10.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_10.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_10.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_10.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_10.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_10.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_10.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	clone_10.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_10.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_10.jump_1 = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_10.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_10.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_10.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_10.ability = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_10.ability_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_10.ability_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	KeymapOverride8 = {
		PlayerControllerKeymaps = {
			xb1 = clone_10
		}
	}

	local clone_11 = table.clone(clone_6)

	clone_11.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_11.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_11.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone_11.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_11.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_11.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_11.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	clone_11.action_inspect = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_11.action_inspect_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_11.action_inspect_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	clone_11.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_11.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_11.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	clone_11.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_11.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_11.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_11.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_11.crouch = {
		"gamepad",
		"b",
		"pressed"
	}
	clone_11.crouching = {
		"gamepad",
		"b",
		"held"
	}
	clone_11.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_11.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	KeymapOverride10 = {
		PlayerControllerKeymaps = {
			xb1 = clone_11
		}
	}

	local clone_12 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	clone_12.action_one = {
		"ps_pad",
		"r1",
		"pressed"
	}
	clone_12.action_one_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_12.action_one_release = {
		"ps_pad",
		"r1",
		"released"
	}
	clone_12.action_two = {
		"ps_pad",
		"l1",
		"pressed"
	}
	clone_12.action_two_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	clone_12.action_two_release = {
		"ps_pad",
		"l1",
		"released"
	}
	clone_12.action_one_softbutton_gamepad = {
		"ps_pad",
		"r1",
		"soft_button"
	}
	clone_12.ping = {
		"ps_pad",
		"r2",
		"pressed"
	}
	clone_12.ping_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	clone_12.ability = {
		"ps_pad",
		"l2",
		"pressed"
	}
	clone_12.ability_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	clone_12.ability_release = {
		"ps_pad",
		"l2",
		"released"
	}
	clone_12.action_three = {
		"ps_pad",
		"r3",
		"pressed"
	}
	clone_12.action_three_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	clone_12.action_three_release = {
		"ps_pad",
		"r3",
		"released"
	}
	KeymapOverride1.PlayerControllerKeymaps.ps_pad = clone_12

	local clone_13 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	clone_13.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	clone_13.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	clone_13.jump_1 = {
		"ps_pad",
		"r1",
		"pressed"
	}
	clone_13.dodge_1 = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_13.ping = {
		"ps_pad",
		"l3",
		"pressed"
	}
	clone_13.ping_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	KeymapOverride2.PlayerControllerKeymaps.ps_pad = clone_13

	local clone_14 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	clone_14.action_one = {
		"ps_pad",
		"r1",
		"pressed"
	}
	clone_14.action_one_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_14.action_one_release = {
		"ps_pad",
		"r1",
		"released"
	}
	clone_14.action_two = {
		"ps_pad",
		"l1",
		"pressed"
	}
	clone_14.action_two_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	clone_14.action_two_release = {
		"ps_pad",
		"l1",
		"released"
	}
	clone_14.action_one_softbutton_gamepad = {
		"ps_pad",
		"r1",
		"soft_button"
	}
	clone_14.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	clone_14.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	clone_14.ability = {
		"ps_pad",
		"l2",
		"pressed"
	}
	clone_14.ability_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	clone_14.ability_release = {
		"ps_pad",
		"l2",
		"released"
	}
	clone_14.jump_1 = {
		"ps_pad",
		"r2",
		"pressed"
	}
	clone_14.dodge_1 = {
		"ps_pad",
		"r2",
		"held"
	}
	clone_14.ping = {
		"ps_pad",
		"l3",
		"pressed"
	}
	clone_14.ping_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	KeymapOverride3.PlayerControllerKeymaps.ps_pad = clone_14

	local clone_15 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	clone_15.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	clone_15.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	clone_15.jump_1 = {
		"ps_pad",
		"l1",
		"pressed"
	}
	clone_15.dodge_1 = {
		"ps_pad",
		"l1",
		"held"
	}
	clone_15.ping = {
		"ps_pad",
		"l3",
		"pressed"
	}
	clone_15.ping_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	clone_15.ability = {
		"ps_pad",
		"r1",
		"pressed"
	}
	clone_15.ability_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_15.ability_release = {
		"ps_pad",
		"r1",
		"released"
	}
	KeymapOverride7.PlayerControllerKeymaps.ps_pad = clone_15

	local clone_16 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	clone_16.action_one = {
		"ps_pad",
		"r1",
		"pressed"
	}
	clone_16.action_one_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_16.action_one_release = {
		"ps_pad",
		"r1",
		"released"
	}
	clone_16.action_two = {
		"ps_pad",
		"l2",
		"pressed"
	}
	clone_16.action_two_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	clone_16.action_two_release = {
		"ps_pad",
		"l2",
		"released"
	}
	clone_16.action_one_softbutton_gamepad = {
		"ps_pad",
		"r1",
		"soft_button"
	}
	clone_16.action_inspect = {
		"ps_pad",
		"r3",
		"pressed"
	}
	clone_16.action_inspect_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	clone_16.action_inspect_release = {
		"ps_pad",
		"r3",
		"released"
	}
	clone_16.action_three = {
		"ps_pad",
		"r3",
		"pressed"
	}
	clone_16.action_three_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	clone_16.action_three_release = {
		"ps_pad",
		"r3",
		"released"
	}
	clone_16.ability = {
		"ps_pad",
		"r2",
		"pressed"
	}
	clone_16.ability_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	clone_16.ability_release = {
		"ps_pad",
		"r2",
		"released"
	}
	clone_16.dodge_1 = {
		"ps_pad",
		"l1",
		"held"
	}
	clone_16.crouch = {
		"ps_pad",
		"circle",
		"pressed"
	}
	clone_16.crouching = {
		"ps_pad",
		"circle",
		"held"
	}
	clone_16.ping = {
		"ps_pad",
		"l3",
		"pressed"
	}
	clone_16.ping_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	KeymapOverride9.PlayerControllerKeymaps.ps_pad = clone_16

	local clone_17 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	clone_17.look_raw_controller = {
		"ps_pad",
		"left",
		"axis"
	}
	clone_17.move_controller = {
		"ps_pad",
		"right",
		"axis"
	}
	clone_17.action_inspect = {
		"ps_pad",
		"r3",
		"pressed"
	}
	clone_17.action_inspect_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	clone_17.action_inspect_release = {
		"ps_pad",
		"r3",
		"released"
	}
	clone_17.ability = {
		"ps_pad",
		"r1",
		"pressed"
	}
	clone_17.ability_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_17.ability_release = {
		"ps_pad",
		"r1",
		"released"
	}
	clone_17.action_one = {
		"ps_pad",
		"l2",
		"pressed"
	}
	clone_17.action_one_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	clone_17.action_one_release = {
		"ps_pad",
		"l2",
		"released"
	}
	clone_17.action_two = {
		"ps_pad",
		"r2",
		"pressed"
	}
	clone_17.action_two_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	clone_17.action_two_release = {
		"ps_pad",
		"r2",
		"released"
	}
	clone_17.action_one_softbutton_gamepad = {
		"ps_pad",
		"l2",
		"soft_button"
	}
	clone_17.ping = {
		"ps_pad",
		"l1",
		"pressed"
	}
	clone_17.ping_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	clone_17.action_three = {
		"ps_pad",
		"l3",
		"pressed"
	}
	clone_17.action_three_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	clone_17.action_three_release = {
		"ps_pad",
		"l3",
		"released"
	}
	KeymapOverrideLeft.PlayerControllerKeymaps.ps_pad = clone_17

	local clone_18 = table.clone(clone_17)

	clone_18.action_one = {
		"ps_pad",
		"l1",
		"pressed"
	}
	clone_18.action_one_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	clone_18.action_one_release = {
		"ps_pad",
		"l1",
		"released"
	}
	clone_18.action_two = {
		"ps_pad",
		"r1",
		"pressed"
	}
	clone_18.action_two_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_18.action_two_release = {
		"ps_pad",
		"r1",
		"released"
	}
	clone_18.action_one_softbutton_gamepad = {
		"ps_pad",
		"l1",
		"soft_button"
	}
	clone_18.ping = {
		"ps_pad",
		"l2",
		"pressed"
	}
	clone_18.ping_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	clone_18.ability = {
		"ps_pad",
		"r2",
		"pressed"
	}
	clone_18.ability_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	clone_18.ability_release = {
		"ps_pad",
		"r2",
		"released"
	}
	clone_18.action_three = {
		"ps_pad",
		"l3",
		"pressed"
	}
	clone_18.action_three_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	clone_18.action_three_release = {
		"ps_pad",
		"l3",
		"released"
	}
	KeymapOverride4.PlayerControllerKeymaps.ps_pad = clone_18

	local clone_19 = table.clone(clone_17)

	clone_19.action_one = {
		"ps_pad",
		"l2",
		"pressed"
	}
	clone_19.action_one_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	clone_19.action_one_release = {
		"ps_pad",
		"l2",
		"released"
	}
	clone_19.action_two = {
		"ps_pad",
		"r2",
		"pressed"
	}
	clone_19.action_two_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	clone_19.action_two_release = {
		"ps_pad",
		"r2",
		"released"
	}
	clone_19.action_one_softbutton_gamepad = {
		"ps_pad",
		"l2",
		"soft_button"
	}
	clone_19.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	clone_19.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	clone_19.jump_1 = {
		"ps_pad",
		"l1",
		"pressed"
	}
	clone_19.dodge_1 = {
		"ps_pad",
		"l1",
		"held"
	}
	clone_19.ping = {
		"ps_pad",
		"r3",
		"pressed"
	}
	clone_19.ping_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	clone_19.ability = {
		"ps_pad",
		"r1",
		"pressed"
	}
	clone_19.ability_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_19.ability_release = {
		"ps_pad",
		"r1",
		"released"
	}
	clone_19.action_three = {
		"ps_pad",
		"l3",
		"pressed"
	}
	clone_19.action_three_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	clone_19.action_three_release = {
		"ps_pad",
		"l3",
		"released"
	}
	KeymapOverride5.PlayerControllerKeymaps.ps_pad = clone_19

	local clone_20 = table.clone(clone_17)

	clone_20.action_one = {
		"ps_pad",
		"l1",
		"pressed"
	}
	clone_20.action_one_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	clone_20.action_one_release = {
		"ps_pad",
		"l1",
		"released"
	}
	clone_20.action_two = {
		"ps_pad",
		"r1",
		"pressed"
	}
	clone_20.action_two_hold = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_20.action_two_release = {
		"ps_pad",
		"r1",
		"released"
	}
	clone_20.action_one_softbutton_gamepad = {
		"ps_pad",
		"l1",
		"soft_button"
	}
	clone_20.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	clone_20.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	clone_20.jump_1 = {
		"ps_pad",
		"l2",
		"pressed"
	}
	clone_20.dodge_1 = {
		"ps_pad",
		"l2",
		"held"
	}
	clone_20.ping = {
		"ps_pad",
		"r3",
		"pressed"
	}
	clone_20.ping_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	clone_20.ability = {
		"ps_pad",
		"r2",
		"pressed"
	}
	clone_20.ability_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	clone_20.ability_release = {
		"ps_pad",
		"r2",
		"released"
	}
	clone_20.action_three = {
		"ps_pad",
		"l3",
		"pressed"
	}
	clone_20.action_three_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	clone_20.action_three_release = {
		"ps_pad",
		"l3",
		"released"
	}
	KeymapOverride6.PlayerControllerKeymaps.ps_pad = clone_20

	local clone_21 = table.clone(DefaultPlayerControllerKeymapsPSPad)

	clone_21.action_one = {
		"ps_pad",
		"l2",
		"pressed"
	}
	clone_21.action_one_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	clone_21.action_one_release = {
		"ps_pad",
		"l2",
		"released"
	}
	clone_21.action_two = {
		"ps_pad",
		"r2",
		"pressed"
	}
	clone_21.action_two_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	clone_21.action_two_release = {
		"ps_pad",
		"r2",
		"released"
	}
	clone_21.action_one_softbutton_gamepad = {
		"ps_pad",
		"l2",
		"soft_button"
	}
	clone_21.weapon_reload_input = {
		"ps_pad",
		"cross",
		"pressed"
	}
	clone_21.weapon_reload_hold_input = {
		"ps_pad",
		"cross",
		"held"
	}
	clone_21.jump_1 = {
		"ps_pad",
		"r1",
		"pressed"
	}
	clone_21.dodge_1 = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_21.ping = {
		"ps_pad",
		"r3",
		"pressed"
	}
	clone_21.ping_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	clone_21.ability = {
		"ps_pad",
		"l1",
		"pressed"
	}
	clone_21.ability_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	clone_21.ability_release = {
		"ps_pad",
		"l1",
		"released"
	}
	KeymapOverride8.PlayerControllerKeymaps.ps_pad = clone_21

	local clone_22 = table.clone(clone_17)

	clone_22.action_one = {
		"ps_pad",
		"l1",
		"pressed"
	}
	clone_22.action_one_hold = {
		"ps_pad",
		"l1",
		"held"
	}
	clone_22.action_one_release = {
		"ps_pad",
		"l1",
		"released"
	}
	clone_22.action_two = {
		"ps_pad",
		"r2",
		"pressed"
	}
	clone_22.action_two_hold = {
		"ps_pad",
		"r2",
		"held"
	}
	clone_22.action_two_release = {
		"ps_pad",
		"r2",
		"released"
	}
	clone_22.action_one_softbutton_gamepad = {
		"ps_pad",
		"l1",
		"soft_button"
	}
	clone_22.action_inspect = {
		"ps_pad",
		"l3",
		"pressed"
	}
	clone_22.action_inspect_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	clone_22.action_inspect_release = {
		"ps_pad",
		"l3",
		"released"
	}
	clone_22.action_three = {
		"ps_pad",
		"l3",
		"pressed"
	}
	clone_22.action_three_hold = {
		"ps_pad",
		"l3",
		"held"
	}
	clone_22.action_three_release = {
		"ps_pad",
		"l3",
		"released"
	}
	clone_22.ability = {
		"ps_pad",
		"l2",
		"pressed"
	}
	clone_22.ability_hold = {
		"ps_pad",
		"l2",
		"held"
	}
	clone_22.ability_release = {
		"ps_pad",
		"l2",
		"released"
	}
	clone_22.dodge_1 = {
		"ps_pad",
		"r1",
		"held"
	}
	clone_22.crouch = {
		"ps_pad",
		"circle",
		"pressed"
	}
	clone_22.crouching = {
		"ps_pad",
		"circle",
		"held"
	}
	clone_22.ping = {
		"ps_pad",
		"r3",
		"pressed"
	}
	clone_22.ping_hold = {
		"ps_pad",
		"r3",
		"held"
	}
	KeymapOverride10.PlayerControllerKeymaps.ps_pad = clone_22
elseif not IS_XB1 then
	local clone_23 = table.clone(DefaultPlayerControllerKeymaps)

	clone_23.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_23.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_23.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_23.action_two = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_23.action_two_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_23.action_two_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone_23.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	clone_23.ping = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_23.ping_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_23.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_23.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_23.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_23.action_three = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_23.action_three_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_23.action_three_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	KeymapOverride1 = {
		PlayerControllerKeymaps = {
			xb1 = clone_23
		}
	}

	local clone_24 = table.clone(DefaultPlayerControllerKeymaps)

	clone_24.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_24.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_24.jump_1 = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_24.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_24.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_24.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride2 = {
		PlayerControllerKeymaps = {
			xb1 = clone_24
		}
	}

	local clone_25 = table.clone(DefaultPlayerControllerKeymaps)

	clone_25.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_25.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_25.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_25.action_two = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_25.action_two_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_25.action_two_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone_25.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	clone_25.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_25.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_25.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_25.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_25.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_25.jump_1 = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_25.dodge_1 = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_25.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_25.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride3 = {
		PlayerControllerKeymaps = {
			xb1 = clone_25
		}
	}

	local clone_26 = table.clone(DefaultPlayerControllerKeymaps)

	clone_26.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_26.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_26.jump_1 = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_26.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_26.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_26.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_26.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_26.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_26.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	KeymapOverride7 = {
		PlayerControllerKeymaps = {
			xb1 = clone_26
		}
	}

	local clone_27 = table.clone(DefaultPlayerControllerKeymaps)

	clone_27.action_one = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_27.action_one_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_27.action_one_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_27.action_two = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_27.action_two_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_27.action_two_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_27.action_one_softbutton_gamepad = {
		"gamepad",
		"right_shoulder",
		"soft_button"
	}
	clone_27.action_inspect = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_27.action_inspect_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_27.action_inspect_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	clone_27.action_three = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_27.action_three_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_27.action_three_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	clone_27.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_27.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_27.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_27.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_27.crouch = {
		"gamepad",
		"b",
		"pressed"
	}
	clone_27.crouching = {
		"gamepad",
		"b",
		"held"
	}
	clone_27.ping = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_27.ping_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	KeymapOverride9 = {
		PlayerControllerKeymaps = {
			xb1 = clone_27
		}
	}

	local clone_28 = table.clone(DefaultPlayerControllerKeymaps)

	clone_28.look_raw_controller = {
		"gamepad",
		"left",
		"axis"
	}
	clone_28.move_controller = {
		"gamepad",
		"right",
		"axis"
	}
	clone_28.action_inspect = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_28.action_inspect_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_28.action_inspect_release = {
		"gamepad",
		"right_thumb",
		"released"
	}
	clone_28.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_28.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_28.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_28.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_28.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_28.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_28.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_28.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_28.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_28.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	clone_28.ping = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_28.ping_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_28.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_28.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_28.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverrideLeft = {
		PlayerControllerKeymaps = {
			xb1 = clone_28
		}
	}

	local clone_29 = table.clone(clone_28)

	clone_29.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_29.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_29.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone_29.action_two = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_29.action_two_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_29.action_two_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_29.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	clone_29.ping = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_29.ping_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_29.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_29.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_29.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_29.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_29.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_29.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride4 = {
		PlayerControllerKeymaps = {
			xb1 = clone_29
		}
	}

	local clone_30 = table.clone(clone_28)

	clone_30.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_30.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_30.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_30.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_30.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_30.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_30.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	clone_30.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_30.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_30.jump_1 = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_30.dodge_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_30.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_30.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_30.ability = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_30.ability_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_30.ability_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_30.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_30.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_30.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride5 = {
		PlayerControllerKeymaps = {
			xb1 = clone_30
		}
	}

	local clone_31 = table.clone(clone_28)

	clone_31.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_31.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_31.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone_31.action_two = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_31.action_two_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_31.action_two_release = {
		"gamepad",
		"right_shoulder",
		"released"
	}
	clone_31.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	clone_31.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_31.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_31.jump_1 = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_31.dodge_1 = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_31.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_31.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_31.ability = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_31.ability_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_31.ability_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_31.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_31.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_31.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride6 = {
		PlayerControllerKeymaps = {
			xb1 = clone_31
		}
	}

	local clone_32 = table.clone(clone_28)

	clone_32.action_one = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_32.action_one_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_32.action_one_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_32.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_32.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_32.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_32.action_one_softbutton_gamepad = {
		"gamepad",
		"left_trigger",
		"soft_button"
	}
	clone_32.weapon_reload_input = {
		"gamepad",
		"a",
		"pressed"
	}
	clone_32.weapon_reload_hold_input = {
		"gamepad",
		"a",
		"held"
	}
	clone_32.jump_1 = {
		"gamepad",
		"right_shoulder",
		"pressed"
	}
	clone_32.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_32.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_32.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	clone_32.ability = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_32.ability_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_32.ability_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone_32.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_32.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_32.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	KeymapOverride8 = {
		PlayerControllerKeymaps = {
			xb1 = clone_32
		}
	}

	local clone_33 = table.clone(clone_28)

	clone_33.action_one = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
	clone_33.action_one_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	}
	clone_33.action_one_release = {
		"gamepad",
		"left_shoulder",
		"released"
	}
	clone_33.action_two = {
		"gamepad",
		"right_trigger",
		"pressed"
	}
	clone_33.action_two_hold = {
		"gamepad",
		"right_trigger",
		"held"
	}
	clone_33.action_two_release = {
		"gamepad",
		"right_trigger",
		"released"
	}
	clone_33.action_one_softbutton_gamepad = {
		"gamepad",
		"left_shoulder",
		"soft_button"
	}
	clone_33.action_inspect = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_33.action_inspect_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_33.action_inspect_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	clone_33.action_three = {
		"gamepad",
		"left_thumb",
		"pressed"
	}
	clone_33.action_three_hold = {
		"gamepad",
		"left_thumb",
		"held"
	}
	clone_33.action_three_release = {
		"gamepad",
		"left_thumb",
		"released"
	}
	clone_33.ability = {
		"gamepad",
		"left_trigger",
		"pressed"
	}
	clone_33.ability_hold = {
		"gamepad",
		"left_trigger",
		"held"
	}
	clone_33.ability_release = {
		"gamepad",
		"left_trigger",
		"released"
	}
	clone_33.dodge_1 = {
		"gamepad",
		"right_shoulder",
		"held"
	}
	clone_33.crouch = {
		"gamepad",
		"b",
		"pressed"
	}
	clone_33.crouching = {
		"gamepad",
		"b",
		"held"
	}
	clone_33.ping = {
		"gamepad",
		"right_thumb",
		"pressed"
	}
	clone_33.ping_hold = {
		"gamepad",
		"right_thumb",
		"held"
	}
	KeymapOverride10 = {
		PlayerControllerKeymaps = {
			xb1 = clone_33
		}
	}
elseif not IS_PS4 then
	local clone_34 = table.clone(DefaultPlayerControllerKeymaps)

	clone_34.action_one = {
		"gamepad",
		"r1",
		"pressed"
	}
	clone_34.action_one_hold = {
		"gamepad",
		"r1",
		"held"
	}
	clone_34.action_one_release = {
		"gamepad",
		"r1",
		"released"
	}
	clone_34.action_two = {
		"gamepad",
		"l1",
		"pressed"
	}
	clone_34.action_two_hold = {
		"gamepad",
		"l1",
		"held"
	}
	clone_34.action_two_release = {
		"gamepad",
		"l1",
		"released"
	}
	clone_34.action_one_softbutton_gamepad = {
		"gamepad",
		"r1",
		"soft_button"
	}
	clone_34.ping = {
		"gamepad",
		"r2",
		"pressed"
	}
	clone_34.ping_hold = {
		"gamepad",
		"r2",
		"held"
	}
	clone_34.ability = {
		"gamepad",
		"l2",
		"pressed"
	}
	clone_34.ability_hold = {
		"gamepad",
		"l2",
		"held"
	}
	clone_34.ability_release = {
		"gamepad",
		"l2",
		"released"
	}
	clone_34.action_three = {
		"gamepad",
		"r3",
		"pressed"
	}
	clone_34.action_three_hold = {
		"gamepad",
		"r3",
		"held"
	}
	clone_34.action_three_release = {
		"gamepad",
		"r3",
		"released"
	}
	KeymapOverride1 = {
		PlayerControllerKeymaps = {
			ps4 = clone_34
		}
	}

	local clone_35 = table.clone(DefaultPlayerControllerKeymaps)

	clone_35.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	clone_35.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	clone_35.jump_1 = {
		"gamepad",
		"r1",
		"pressed"
	}
	clone_35.dodge_1 = {
		"gamepad",
		"r1",
		"held"
	}
	clone_35.ping = {
		"gamepad",
		"l3",
		"pressed"
	}
	clone_35.ping_hold = {
		"gamepad",
		"l3",
		"held"
	}
	KeymapOverride2 = {
		PlayerControllerKeymaps = {
			ps4 = clone_35
		}
	}

	local clone_36 = table.clone(DefaultPlayerControllerKeymaps)

	clone_36.action_one = {
		"gamepad",
		"r1",
		"pressed"
	}
	clone_36.action_one_hold = {
		"gamepad",
		"r1",
		"held"
	}
	clone_36.action_one_release = {
		"gamepad",
		"r1",
		"released"
	}
	clone_36.action_two = {
		"gamepad",
		"l1",
		"pressed"
	}
	clone_36.action_two_hold = {
		"gamepad",
		"l1",
		"held"
	}
	clone_36.action_two_release = {
		"gamepad",
		"l1",
		"released"
	}
	clone_36.action_one_softbutton_gamepad = {
		"gamepad",
		"r1",
		"soft_button"
	}
	clone_36.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	clone_36.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	clone_36.ability = {
		"gamepad",
		"l2",
		"pressed"
	}
	clone_36.ability_hold = {
		"gamepad",
		"l2",
		"held"
	}
	clone_36.ability_release = {
		"gamepad",
		"l2",
		"released"
	}
	clone_36.jump_1 = {
		"gamepad",
		"r2",
		"pressed"
	}
	clone_36.dodge_1 = {
		"gamepad",
		"r2",
		"held"
	}
	clone_36.ping = {
		"gamepad",
		"l3",
		"pressed"
	}
	clone_36.ping_hold = {
		"gamepad",
		"l3",
		"held"
	}
	KeymapOverride3 = {
		PlayerControllerKeymaps = {
			ps4 = clone_36
		}
	}

	local clone_37 = table.clone(DefaultPlayerControllerKeymaps)

	clone_37.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	clone_37.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	clone_37.jump_1 = {
		"gamepad",
		"l1",
		"pressed"
	}
	clone_37.dodge_1 = {
		"gamepad",
		"l1",
		"held"
	}
	clone_37.ping = {
		"gamepad",
		"l3",
		"pressed"
	}
	clone_37.ping_hold = {
		"gamepad",
		"l3",
		"held"
	}
	clone_37.ability = {
		"gamepad",
		"r1",
		"pressed"
	}
	clone_37.ability_hold = {
		"gamepad",
		"r1",
		"held"
	}
	clone_37.ability_release = {
		"gamepad",
		"r1",
		"released"
	}
	KeymapOverride7 = {
		PlayerControllerKeymaps = {
			ps4 = clone_37
		}
	}

	local clone_38 = table.clone(DefaultPlayerControllerKeymaps)

	clone_38.action_one = {
		"gamepad",
		"r1",
		"pressed"
	}
	clone_38.action_one_hold = {
		"gamepad",
		"r1",
		"held"
	}
	clone_38.action_one_release = {
		"gamepad",
		"r1",
		"released"
	}
	clone_38.action_two = {
		"gamepad",
		"l2",
		"pressed"
	}
	clone_38.action_two_hold = {
		"gamepad",
		"l2",
		"held"
	}
	clone_38.action_two_release = {
		"gamepad",
		"l2",
		"released"
	}
	clone_38.action_one_softbutton_gamepad = {
		"gamepad",
		"r1",
		"soft_button"
	}
	clone_38.action_inspect = {
		"gamepad",
		"r3",
		"pressed"
	}
	clone_38.action_inspect_hold = {
		"gamepad",
		"r3",
		"held"
	}
	clone_38.action_inspect_release = {
		"gamepad",
		"r3",
		"released"
	}
	clone_38.action_three = {
		"gamepad",
		"r3",
		"pressed"
	}
	clone_38.action_three_hold = {
		"gamepad",
		"r3",
		"held"
	}
	clone_38.action_three_release = {
		"gamepad",
		"r3",
		"released"
	}
	clone_38.ability = {
		"gamepad",
		"r2",
		"pressed"
	}
	clone_38.ability_hold = {
		"gamepad",
		"r2",
		"held"
	}
	clone_38.ability_release = {
		"gamepad",
		"r2",
		"released"
	}
	clone_38.dodge_1 = {
		"gamepad",
		"l1",
		"held"
	}
	clone_38.crouch = {
		"gamepad",
		"circle",
		"pressed"
	}
	clone_38.crouching = {
		"gamepad",
		"circle",
		"held"
	}
	clone_38.ping = {
		"gamepad",
		"l3",
		"pressed"
	}
	clone_38.ping_hold = {
		"gamepad",
		"l3",
		"held"
	}
	KeymapOverride9 = {
		PlayerControllerKeymaps = {
			ps4 = clone_38
		}
	}

	local clone_39 = table.clone(DefaultPlayerControllerKeymaps)

	clone_39.look_raw_controller = {
		"gamepad",
		"left",
		"axis"
	}
	clone_39.move_controller = {
		"gamepad",
		"right",
		"axis"
	}
	clone_39.action_inspect = {
		"gamepad",
		"r3",
		"pressed"
	}
	clone_39.action_inspect_hold = {
		"gamepad",
		"r3",
		"held"
	}
	clone_39.action_inspect_release = {
		"gamepad",
		"r3",
		"released"
	}
	clone_39.ability = {
		"gamepad",
		"r1",
		"pressed"
	}
	clone_39.ability_hold = {
		"gamepad",
		"r1",
		"held"
	}
	clone_39.ability_release = {
		"gamepad",
		"r1",
		"released"
	}
	clone_39.action_one = {
		"gamepad",
		"l2",
		"pressed"
	}
	clone_39.action_one_hold = {
		"gamepad",
		"l2",
		"held"
	}
	clone_39.action_one_release = {
		"gamepad",
		"l2",
		"released"
	}
	clone_39.action_two = {
		"gamepad",
		"r2",
		"pressed"
	}
	clone_39.action_two_hold = {
		"gamepad",
		"r2",
		"held"
	}
	clone_39.action_two_release = {
		"gamepad",
		"r2",
		"released"
	}
	clone_39.action_one_softbutton_gamepad = {
		"gamepad",
		"l2",
		"soft_button"
	}
	clone_39.ping = {
		"gamepad",
		"l1",
		"pressed"
	}
	clone_39.ping_hold = {
		"gamepad",
		"l1",
		"held"
	}
	clone_39.action_three = {
		"gamepad",
		"l3",
		"pressed"
	}
	clone_39.action_three_hold = {
		"gamepad",
		"l3",
		"held"
	}
	clone_39.action_three_release = {
		"gamepad",
		"l3",
		"released"
	}
	KeymapOverrideLeft = {
		PlayerControllerKeymaps = {
			ps4 = clone_39
		}
	}

	local clone_40 = table.clone(clone_39)

	clone_40.action_one = {
		"gamepad",
		"l1",
		"pressed"
	}
	clone_40.action_one_hold = {
		"gamepad",
		"l1",
		"held"
	}
	clone_40.action_one_release = {
		"gamepad",
		"l1",
		"released"
	}
	clone_40.action_two = {
		"gamepad",
		"r1",
		"pressed"
	}
	clone_40.action_two_hold = {
		"gamepad",
		"r1",
		"held"
	}
	clone_40.action_two_release = {
		"gamepad",
		"r1",
		"released"
	}
	clone_40.action_one_softbutton_gamepad = {
		"gamepad",
		"l1",
		"soft_button"
	}
	clone_40.ping = {
		"gamepad",
		"l2",
		"pressed"
	}
	clone_40.ping_hold = {
		"gamepad",
		"l2",
		"held"
	}
	clone_40.ability = {
		"gamepad",
		"r2",
		"pressed"
	}
	clone_40.ability_hold = {
		"gamepad",
		"r2",
		"held"
	}
	clone_40.ability_release = {
		"gamepad",
		"r2",
		"released"
	}
	clone_40.action_three = {
		"gamepad",
		"l3",
		"pressed"
	}
	clone_40.action_three_hold = {
		"gamepad",
		"l3",
		"held"
	}
	clone_40.action_three_release = {
		"gamepad",
		"l3",
		"released"
	}
	KeymapOverride4 = {
		PlayerControllerKeymaps = {
			ps4 = clone_40
		}
	}

	local clone_41 = table.clone(clone_39)

	clone_41.action_one = {
		"gamepad",
		"l2",
		"pressed"
	}
	clone_41.action_one_hold = {
		"gamepad",
		"l2",
		"held"
	}
	clone_41.action_one_release = {
		"gamepad",
		"l2",
		"released"
	}
	clone_41.action_two = {
		"gamepad",
		"r2",
		"pressed"
	}
	clone_41.action_two_hold = {
		"gamepad",
		"r2",
		"held"
	}
	clone_41.action_two_release = {
		"gamepad",
		"r2",
		"released"
	}
	clone_41.action_one_softbutton_gamepad = {
		"gamepad",
		"l2",
		"soft_button"
	}
	clone_41.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	clone_41.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	clone_41.jump_1 = {
		"gamepad",
		"l1",
		"pressed"
	}
	clone_41.dodge_1 = {
		"gamepad",
		"l1",
		"held"
	}
	clone_41.ping = {
		"gamepad",
		"r3",
		"pressed"
	}
	clone_41.ping_hold = {
		"gamepad",
		"r3",
		"held"
	}
	clone_41.ability = {
		"gamepad",
		"r1",
		"pressed"
	}
	clone_41.ability_hold = {
		"gamepad",
		"r1",
		"held"
	}
	clone_41.ability_release = {
		"gamepad",
		"r1",
		"released"
	}
	clone_41.action_three = {
		"gamepad",
		"l3",
		"pressed"
	}
	clone_41.action_three_hold = {
		"gamepad",
		"l3",
		"held"
	}
	clone_41.action_three_release = {
		"gamepad",
		"l3",
		"released"
	}
	KeymapOverride5 = {
		PlayerControllerKeymaps = {
			ps4 = clone_41
		}
	}

	local clone_42 = table.clone(clone_39)

	clone_42.action_one = {
		"gamepad",
		"l1",
		"pressed"
	}
	clone_42.action_one_hold = {
		"gamepad",
		"l1",
		"held"
	}
	clone_42.action_one_release = {
		"gamepad",
		"l1",
		"released"
	}
	clone_42.action_two = {
		"gamepad",
		"r1",
		"pressed"
	}
	clone_42.action_two_hold = {
		"gamepad",
		"r1",
		"held"
	}
	clone_42.action_two_release = {
		"gamepad",
		"r1",
		"released"
	}
	clone_42.action_one_softbutton_gamepad = {
		"gamepad",
		"l1",
		"soft_button"
	}
	clone_42.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	clone_42.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	clone_42.jump_1 = {
		"gamepad",
		"l2",
		"pressed"
	}
	clone_42.dodge_1 = {
		"gamepad",
		"l2",
		"held"
	}
	clone_42.ping = {
		"gamepad",
		"r3",
		"pressed"
	}
	clone_42.ping_hold = {
		"gamepad",
		"r3",
		"held"
	}
	clone_42.ability = {
		"gamepad",
		"r2",
		"pressed"
	}
	clone_42.ability_hold = {
		"gamepad",
		"r2",
		"held"
	}
	clone_42.ability_release = {
		"gamepad",
		"r2",
		"released"
	}
	clone_42.action_three = {
		"gamepad",
		"l3",
		"pressed"
	}
	clone_42.action_three_hold = {
		"gamepad",
		"l3",
		"held"
	}
	clone_42.action_three_release = {
		"gamepad",
		"l3",
		"released"
	}
	KeymapOverride6 = {
		PlayerControllerKeymaps = {
			ps4 = clone_42
		}
	}

	local clone_43 = table.clone(DefaultPlayerControllerKeymaps)

	clone_43.action_one = {
		"gamepad",
		"l2",
		"pressed"
	}
	clone_43.action_one_hold = {
		"gamepad",
		"l2",
		"held"
	}
	clone_43.action_one_release = {
		"gamepad",
		"l2",
		"released"
	}
	clone_43.action_two = {
		"gamepad",
		"r2",
		"pressed"
	}
	clone_43.action_two_hold = {
		"gamepad",
		"r2",
		"held"
	}
	clone_43.action_two_release = {
		"gamepad",
		"r2",
		"released"
	}
	clone_43.action_one_softbutton_gamepad = {
		"gamepad",
		"l2",
		"soft_button"
	}
	clone_43.weapon_reload_input = {
		"gamepad",
		"cross",
		"pressed"
	}
	clone_43.weapon_reload_hold_input = {
		"gamepad",
		"cross",
		"held"
	}
	clone_43.jump_1 = {
		"gamepad",
		"r1",
		"pressed"
	}
	clone_43.dodge_1 = {
		"gamepad",
		"r1",
		"held"
	}
	clone_43.ping = {
		"gamepad",
		"r3",
		"pressed"
	}
	clone_43.ping_hold = {
		"gamepad",
		"r3",
		"held"
	}
	clone_43.ability = {
		"gamepad",
		"l1",
		"pressed"
	}
	clone_43.ability_hold = {
		"gamepad",
		"l1",
		"held"
	}
	clone_43.ability_release = {
		"gamepad",
		"l1",
		"released"
	}
	KeymapOverride8 = {
		PlayerControllerKeymaps = {
			ps4 = clone_43
		}
	}

	local clone_44 = table.clone(clone_39)

	clone_44.action_one = {
		"gamepad",
		"l1",
		"pressed"
	}
	clone_44.action_one_hold = {
		"gamepad",
		"l1",
		"held"
	}
	clone_44.action_one_release = {
		"gamepad",
		"l1",
		"released"
	}
	clone_44.action_two = {
		"gamepad",
		"r2",
		"pressed"
	}
	clone_44.action_two_hold = {
		"gamepad",
		"r2",
		"held"
	}
	clone_44.action_two_release = {
		"gamepad",
		"r2",
		"released"
	}
	clone_44.action_one_softbutton_gamepad = {
		"gamepad",
		"l1",
		"soft_button"
	}
	clone_44.action_inspect = {
		"gamepad",
		"l3",
		"pressed"
	}
	clone_44.action_inspect_hold = {
		"gamepad",
		"l3",
		"held"
	}
	clone_44.action_inspect_release = {
		"gamepad",
		"l3",
		"released"
	}
	clone_44.action_three = {
		"gamepad",
		"l3",
		"pressed"
	}
	clone_44.action_three_hold = {
		"gamepad",
		"l3",
		"held"
	}
	clone_44.action_three_release = {
		"gamepad",
		"l3",
		"released"
	}
	clone_44.ability = {
		"gamepad",
		"l2",
		"pressed"
	}
	clone_44.ability_hold = {
		"gamepad",
		"l2",
		"held"
	}
	clone_44.ability_release = {
		"gamepad",
		"l2",
		"released"
	}
	clone_44.dodge_1 = {
		"gamepad",
		"r1",
		"held"
	}
	clone_44.crouch = {
		"gamepad",
		"circle",
		"pressed"
	}
	clone_44.crouching = {
		"gamepad",
		"circle",
		"held"
	}
	clone_44.ping = {
		"gamepad",
		"r3",
		"pressed"
	}
	clone_44.ping_hold = {
		"gamepad",
		"r3",
		"held"
	}
	KeymapOverride10 = {
		PlayerControllerKeymaps = {
			ps4 = clone_44
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

if not IS_WINDOWS then
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
elseif not IS_XB1 then
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
elseif not IS_PS4 then
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
