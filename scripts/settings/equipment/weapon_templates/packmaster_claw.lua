-- chunkname: @scripts/settings/equipment/weapon_templates/packmaster_claw.lua

local var_0_0 = {
	actions = {}
}

var_0_0.right_hand_unit = "units/weapons/player/wpn_packmaster_claw/wpn_packmaster_claw"
var_0_0.right_hand_attachment_node_linking = AttachmentNodeLinking.packmaster_claw
var_0_0.wield_anim = "to_packmaster_claw"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/common"
var_0_0.load_state_machine = false
var_0_0.mechanism_overrides = {
	versus = {
		right_hand_unit = "units/weapons/player/wpn_packmaster_claw_combo/wpn_packmaster_claw_combo"
	}
}

return {
	packmaster_claw = table.clone(var_0_0)
}
