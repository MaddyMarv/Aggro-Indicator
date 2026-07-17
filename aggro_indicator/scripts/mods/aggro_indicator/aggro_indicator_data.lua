local mod = get_mod("aggro_indicator")

local widgets = {
    {
        setting_id = "group_general",
        type = "group",
        tab = mod:localize("tab_general"),
        sub_widgets = {
            {
                setting_id = "indicator_offset_x",
                type = "numeric",
                range = { -1000, 1000 },
                default_value = -30,
            },
            {
                setting_id = "indicator_offset_y",
                type = "numeric",
                range = { -1000, 1000 },
                default_value = 0,
            },
            {
                setting_id = "indicator_horizontal_alignment",
                type = "dropdown",
                default_value = "center",
                options = {
                    { text = "align_left", value = "left" },
                    { text = "align_center", value = "center" },
                    { text = "align_right", value = "right" },
                },
            },
            {
                setting_id = "indicator_vertical_alignment",
                type = "dropdown",
                default_value = "center",
                options = {
                    { text = "align_top", value = "top" },
                    { text = "align_center", value = "center" },
                    { text = "align_bottom", value = "bottom" },
                },
            },
            {
                setting_id = "indicator_size",
                type = "numeric",
                range = { 1, 100 },
                default_value = 15,
            },
            {
                setting_id = "always_on",
                type = "checkbox",
                default_value = false,
            },
        },
    },
    {
        setting_id = "aggro_header",
        type = "group",
        tab = mod:localize("tab_aggro"),
        sub_widgets = {
            { setting_id = "aggro_pox_burster_enabled", type = "checkbox", default_value = true },
            { setting_id = "aggro_disabler_enabled", type = "checkbox", default_value = true },
            { setting_id = "aggro_sniper_enabled", type = "checkbox", default_value = true },
            { setting_id = "aggro_captain_enabled", type = "checkbox", default_value = true },
            { setting_id = "aggro_monstrosity_enabled", type = "checkbox", default_value = true },
            { setting_id = "aggro_daemonhost_enabled", type = "checkbox", default_value = true },
            { setting_id = "aggro_grenadier_enabled", type = "checkbox", default_value = true },
            { setting_id = "aggro_crusher_enabled", type = "checkbox", default_value = true },
            { setting_id = "aggro_flamer_enabled", type = "checkbox", default_value = true },
            { setting_id = "aggro_rager_enabled", type = "checkbox", default_value = true },
        },
    },
}

local aggro_types = {
    { "aggro_pox_burster", { 255, 255, 0 } },
    { "aggro_disabler", { 77, 0, 255 } },
    { "aggro_sniper", { 0, 255, 255 } },
    { "aggro_captain", { 255, 96, 0 } },
    { "aggro_monstrosity", { 255, 0, 0 } },
    { "aggro_daemonhost", { 0, 255, 0 } },
    { "aggro_grenadier", { 34, 100, 34 } },
    { "aggro_crusher", { 0, 0, 255 } },
    { "aggro_flamer", { 86, 10, 40 } },
    { "aggro_rager", { 255, 43, 96 } },
}

local aggro_color_widgets = {}

for _, aggro_data in ipairs(aggro_types) do
    local aggro_name = aggro_data[1]
    local default_color = aggro_data[2]

    table.insert(aggro_color_widgets, {
        setting_id = aggro_name .. "_header",
        type = "group",
        sub_widgets = {
            {
                setting_id = aggro_name .. "_r",
                type = "numeric",
                range = { 0, 255 },
                default_value = default_color[1],
            },
            {
                setting_id = aggro_name .. "_g",
                type = "numeric",
                range = { 0, 255 },
                default_value = default_color[2],
            },
            {
                setting_id = aggro_name .. "_b",
                type = "numeric",
                range = { 0, 255 },
                default_value = default_color[3],
            },
        },
    })
end

table.insert(widgets, {
    setting_id = "group_aggro_colors",
    type = "group",
    tab = mod:localize("tab_aggro_colors"),
    sub_widgets = aggro_color_widgets,
})

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = widgets,
    },
}
