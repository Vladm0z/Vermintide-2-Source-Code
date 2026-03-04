-- chunkname: @scripts/settings/equipment/attachments.lua

require("scripts/settings/attachment_node_linking")

FirstPersonAttachments = {}
FirstPersonAttachments.witch_hunter = {
	unit = "units/beings/player/witch_hunter/first_person_base/chr_first_person_mesh",
	attachment_node_linking = AttachmentNodeLinking.first_person_attachment
}
FirstPersonAttachments.bright_wizard = {
	unit = "units/beings/player/bright_wizard/first_person_base/chr_first_person_mesh",
	attachment_node_linking = AttachmentNodeLinking.first_person_attachment
}
FirstPersonAttachments.wood_elf = {
	unit = "units/beings/player/way_watcher/first_person_base/chr_first_person_mesh",
	attachment_node_linking = AttachmentNodeLinking.first_person_attachment
}
FirstPersonAttachments.dwarf_ranger = {
	unit = "units/beings/player/dwarf_ranger_upgraded/first_person_base/chr_first_person_mesh",
	attachment_node_linking = AttachmentNodeLinking.first_person_attachment
}
FirstPersonAttachments.empire_soldier = {
	unit = "units/beings/player/empire_soldier/first_person_base/chr_first_person_mesh",
	attachment_node_linking = AttachmentNodeLinking.first_person_attachment
}
Attachments = {}

local var_0_0 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_trophy",
	attachment_node_linking = AttachmentNodeLinking.trophies.hanging,
	slots = {
		"slot_trinket_1",
		"slot_trinket_2",
		"slot_trinket_3"
	},
	buffs = {}
}
local var_0_1 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_trophy",
	attachment_node_linking = AttachmentNodeLinking.trophies.flat,
	slots = {
		"slot_trinket_1",
		"slot_trinket_2",
		"slot_trinket_3"
	},
	buffs = {}
}

Attachments.hanging_trophy = table.clone(var_0_0)
Attachments.flat_trophy = table.clone(var_0_1)

local var_0_2 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats = table.clone(var_0_2)

local var_0_3 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_skinned = table.clone(var_0_3)

local var_0_4 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.wh_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_face = table.clone(var_0_4)

local var_0_5 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.wh_face,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00"
		}
	}
}

Attachments.wh_face_no_hair = table.clone(var_0_5)

local var_0_6 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_no_ears = table.clone(var_0_6)

local var_0_7 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_no_ears_skinned = table.clone(var_0_7)

local var_0_8 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_lock_jaw",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_no_ears_skinned_lock_jaw = table.clone(var_0_8)

local var_0_9 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_face_skinned = table.clone(var_0_9)

local var_0_10 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_no_ears_face_skinned = table.clone(var_0_10)

local var_0_11 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00"
		}
	}
}

Attachments.wh_z_hats_tattoo_00 = table.clone(var_0_11)

local var_0_12 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00"
		}
	}
}

Attachments.wh_z_hats_tattoo_00_face_skinned = table.clone(var_0_12)

local var_0_13 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_01",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_01"
		}
	}
}

Attachments.wh_z_hats_tattoo_01 = table.clone(var_0_13)

local var_0_14 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_02",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_02"
		}
	}
}

Attachments.wh_z_hats_tattoo_02 = table.clone(var_0_14)

local var_0_15 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_03",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_03"
		}
	}
}

Attachments.wh_z_hats_tattoo_03 = table.clone(var_0_15)

local var_0_16 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_04",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_04"
		}
	}
}

Attachments.wh_z_hats_tattoo_04 = table.clone(var_0_16)

local var_0_17 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_05",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_05"
		}
	}
}

Attachments.wh_z_hats_tattoo_05 = table.clone(var_0_17)

local var_0_18 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_06",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_06"
		}
	}
}

Attachments.wh_z_hats_tattoo_06 = table.clone(var_0_18)

local var_0_19 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_hat_10_face",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_hat_10_face"
		}
	}
}

Attachments.wh_z_hat_10 = table.clone(var_0_19)

local var_0_20 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hoods = table.clone(var_0_20)

local var_0_21 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hoods_jaw = table.clone(var_0_21)

local var_0_22 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_balaclava",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_balaclava_wide = table.clone(var_0_22)

local var_0_23 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_head_default",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_full_face = table.clone(var_0_23)

local var_0_24 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_half_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_half_masks = table.clone(var_0_24)

local var_0_25 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_masks = table.clone(var_0_25)

local var_0_26 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_head_default",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hat = table.clone(var_0_26)

local var_0_27 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_head_no_hood",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hat_no_hood = table.clone(var_0_27)

local var_0_28 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_head_default_no_face",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hat_no_face = table.clone(var_0_28)

local var_0_29 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet = table.clone(var_0_29)

local var_0_30 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_ears = table.clone(var_0_30)

local var_0_31 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_ears_skinned = table.clone(var_0_31)

local var_0_32 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_skinned = table.clone(var_0_32)

local var_0_33 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_mask = table.clone(var_0_33)

local var_0_34 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_mask_jaw = table.clone(var_0_34)

local var_0_35 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_jaw = table.clone(var_0_35)

local var_0_36 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_head_default",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_half_mask_full_face = table.clone(var_0_36)

local var_0_37 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_eyes_hair_hood_down",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hide_eyes_hair_hood_down = table.clone(var_0_37)

local var_0_38 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats = table.clone(var_0_38)

local var_0_39 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_jaw = table.clone(var_0_39)

local var_0_40 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ear = table.clone(var_0_40)

local var_0_41 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_lock_neck",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ear_lock_neck = table.clone(var_0_41)

local var_0_42 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_moustache",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_moustache = table.clone(var_0_42)

local var_0_43 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_moustache",
	attachment_node_linking = AttachmentNodeLinking.es_hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_moustache_skinned = table.clone(var_0_43)

local var_0_44 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_moustache",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ear_moustache = table.clone(var_0_44)

local var_0_45 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_moustache",
	attachment_node_linking = AttachmentNodeLinking.es_hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ear_moustache_skinned = table.clone(var_0_45)

local var_0_46 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_nose_moustache",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_beard_ear_nose_moustache = table.clone(var_0_46)

local var_0_47 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_beard",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_beard = table.clone(var_0_47)

local var_0_48 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_beard",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ears_beard = table.clone(var_0_48)

local var_0_49 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_es_hood",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.es_hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_skinned = table.clone(var_0_49)

local var_0_50 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_es_hood",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.es_hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ears_skinned = table.clone(var_0_50)

local var_0_51 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_es_hood",
	show_attachments_event = "lua_hide_beard",
	attachment_node_linking = AttachmentNodeLinking.es_hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_beard_skinned = table.clone(var_0_51)

local var_0_52 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_beard",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_beard = table.clone(var_0_52)

local var_0_53 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_es_hood",
	show_attachments_event = "lua_hide_beard",
	attachment_node_linking = AttachmentNodeLinking.es_beard,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_beard_skinned = table.clone(var_0_53)

local var_0_54 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets = table.clone(var_0_54)

local var_0_55 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_dr_hood",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide_arms,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_skinned_long = table.clone(var_0_55)

local var_0_56 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_dr_hood",
	show_attachments_event = "lua_hide_head",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide_arms,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_skinned_long_no_head = table.clone(var_0_56)

local var_0_57 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_no_ear = table.clone(var_0_57)

local var_0_58 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_hide_ears_skin_jaw = table.clone(var_0_58)

local var_0_59 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_beard",
	attachment_node_linking = AttachmentNodeLinking.dr_beard,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_hide_beard = table.clone(var_0_59)

local var_0_60 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_head_beard",
	attachment_node_linking = AttachmentNodeLinking.player_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_hide_head_beard = table.clone(var_0_60)

local var_0_61 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_beard_ears",
	attachment_node_linking = AttachmentNodeLinking.dr_beard,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_beard_ears = table.clone(var_0_61)

local var_0_62 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_face_show_ears",
	attachment_node_linking = AttachmentNodeLinking.player_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_beard_face = table.clone(var_0_62)

local var_0_63 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_face_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.player_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_beard_face_ears = table.clone(var_0_63)

local var_0_64 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_default_beard_ears",
	attachment_node_linking = AttachmentNodeLinking.dr_beard,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_hide_beard_ears_default_only = table.clone(var_0_64)

local var_0_65 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00"
		}
	}
}

Attachments.dr_hair_tattoo_00 = table.clone(var_0_65)

local var_0_66 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00"
		}
	}
}

Attachments.dr_hair_tattoo_00_hide_ears_skin_jaw = table.clone(var_0_66)

local var_0_67 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_01",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_01"
		}
	}
}

Attachments.dr_hair_tattoo_01 = table.clone(var_0_67)

local var_0_68 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_02",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_02"
		}
	}
}

Attachments.dr_hair_tattoo_02 = table.clone(var_0_68)

local var_0_69 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_03",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_03"
		}
	}
}

Attachments.dr_hair_tattoo_03 = table.clone(var_0_69)

local var_0_70 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_04",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_04"
		}
	}
}

Attachments.dr_hair_tattoo_04 = table.clone(var_0_70)

local var_0_71 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_05",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_05"
		}
	}
}

Attachments.dr_hair_tattoo_05 = table.clone(var_0_71)

local var_0_72 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_00 = table.clone(var_0_72)

local var_0_73 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_01",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_01"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_01 = table.clone(var_0_73)

local var_0_74 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_02",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_02"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_02 = table.clone(var_0_74)

local var_0_75 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_03",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_03"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_03 = table.clone(var_0_75)

local var_0_76 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_04",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_04"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_04 = table.clone(var_0_76)

local var_0_77 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_05",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_05"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_05 = table.clone(var_0_77)

local var_0_78 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.dr_beard,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_hat_14_face",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_hat_14_face"
		}
	}
}

Attachments.dr_s_hat_14 = table.clone(var_0_78)

local var_0_79 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_beard",
	attachment_node_linking = AttachmentNodeLinking.dr_beard,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_hat_15_face",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_hat_15_face"
		}
	}
}

Attachments.dr_s_hat_15 = table.clone(var_0_79)

local var_0_80 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.bw_gate,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_gates = table.clone(var_0_80)

local var_0_81 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears_lock_neck",
	attachment_node_linking = AttachmentNodeLinking.bw_gate,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_gates_lock_neck = table.clone(var_0_81)

local var_0_82 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat = table.clone(var_0_82)

local var_0_83 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears_lock_neck",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_lock_neck = table.clone(var_0_83)

local var_0_84 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_hair",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_no_hair = table.clone(var_0_84)

local var_0_85 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_hair",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_skinned_wide_no_hair = table.clone(var_0_85)

local var_0_86 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_hair_lock_neck",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_no_hair_lock_neck = table.clone(var_0_86)

local var_0_87 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_hair",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_jaw_no_hair = table.clone(var_0_87)

local var_0_88 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_no_ears = table.clone(var_0_88)

local var_0_89 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_hair",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_no_ears_hair = table.clone(var_0_89)

local var_0_90 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.bw_gate_facemask,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_gates_facemask = table.clone(var_0_90)

local var_0_91 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_breastplate",
	attachment_node_linking = AttachmentNodeLinking.bw_gate,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_gates_no_breastplate = table.clone(var_0_91)

local var_0_92 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_breastplate",
	attachment_node_linking = AttachmentNodeLinking.bw_gate_facemask,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_gates_facemask_no_breastplate = table.clone(var_0_92)

local var_0_93 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_skinned_wide = table.clone(var_0_93)

local var_0_94 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_face",
	attachment_node_linking = AttachmentNodeLinking.player_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_face = table.clone(var_0_94)

local var_0_95 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	link_to_skin = true,
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_cloak,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_cloak = table.clone(var_0_95)

local var_0_96 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_hair",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_hair,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hair = table.clone(var_0_96)

local var_0_97 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_dr_hood",
	show_attachments_event = "lua_hide_head_eyes",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide_arms,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_skinned_wide_no_head = table.clone(var_0_97)

local var_0_98 = {
	display_unit = "",
	attachment_node_linking = AttachmentNodeLinking.non_visual_attachment,
	slots = {
		"slot_necklace"
	}
}

Attachments.necklace_template = table.clone(var_0_98)

local var_0_99 = {
	display_unit = "",
	attachment_node_linking = AttachmentNodeLinking.non_visual_attachment,
	slots = {
		"slot_ring"
	}
}

Attachments.ring_template = table.clone(var_0_99)

local var_0_100 = {
	display_unit = "",
	attachment_node_linking = AttachmentNodeLinking.non_visual_attachment,
	slots = {
		"slot_trinket"
	}
}

Attachments.trinket_template = table.clone(var_0_100)

for iter_0_0, iter_0_1 in pairs(Attachments) do
	iter_0_1.name = iter_0_0

	assert(iter_0_1.units ~= "", "Name is empty")
	assert(iter_0_1.attachment_node_linking)
	assert(iter_0_1.slots)
end
