local mod = get_mod("aggro_indicator")

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local AggroDetection = mod:io_dofile("aggro_indicator/scripts/mods/aggro_indicator/aggro_detection")

local scenegraph_definition = {
    screen = UIWorkspaceSettings.screen,
    aggro_indicator_anchor = {
        parent = "screen",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = { 0, 0 },
        position = { 0, 0, 100 },
    },
}

local widget_definitions = {
    indicator = UIWidget.create_definition({
        {
            pass_type = "circle",
            style_id = "circle_indicator",
            style = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, 0, 0 },
                size = { 10, 10 },
                color = { 0, 255, 255, 255 }, -- Invisible by default
            }
        },
    }, "aggro_indicator_anchor"),
}

local HudElementAggroIndicator = class("HudElementAggroIndicator", "HudElementBase")

HudElementAggroIndicator.init = function(self, parent, draw_layer, start_scale)
    HudElementAggroIndicator.super.init(self, parent, draw_layer, start_scale, {
        widget_definitions = widget_definitions,
        scenegraph_definition = scenegraph_definition
    })
    self._indicator_widget = self._widgets_by_name.indicator
    
    local offset_x = mod:get("indicator_offset_x") or -30
    local offset_y = mod:get("indicator_offset_y") or 0
    local horiz_align = mod:get("indicator_horizontal_alignment") or "center"
    local vert_align = mod:get("indicator_vertical_alignment") or "center"
    
    self:set_scenegraph_position("aggro_indicator_anchor", offset_x, offset_y, 100, horiz_align, vert_align)
end

HudElementAggroIndicator.update = function(self, dt, t, ui_renderer, render_settings, input_service)
    HudElementAggroIndicator.super.update(self, dt, t, ui_renderer, render_settings, input_service)
    
    local is_enabled = mod:get("is_enabled")
    if is_enabled == false then
        self._indicator_widget.style.circle_indicator.color[1] = 0
        return
    end

    -- Run aggro scan
    AggroDetection.scan(dt)
    
    local local_player = Managers.player and Managers.player:local_player(1)
    if not local_player or not local_player.player_unit then
        self._indicator_widget.style.circle_indicator.color[1] = 0
        return
    end

    local aggro_type = AggroDetection.get_aggro_for_unit(local_player.player_unit)
    
    if aggro_type then
        local r = mod:get("aggro_" .. aggro_type .. "_r") or 255
        local g = mod:get("aggro_" .. aggro_type .. "_g") or 0
        local b = mod:get("aggro_" .. aggro_type .. "_b") or 0
        
        self._indicator_widget.style.circle_indicator.color[1] = 255
        self._indicator_widget.style.circle_indicator.color[2] = r
        self._indicator_widget.style.circle_indicator.color[3] = g
        self._indicator_widget.style.circle_indicator.color[4] = b
    else
        if mod:get("always_on") then
            self._indicator_widget.style.circle_indicator.color[1] = 128
            self._indicator_widget.style.circle_indicator.color[2] = 128
            self._indicator_widget.style.circle_indicator.color[3] = 128
            self._indicator_widget.style.circle_indicator.color[4] = 128
        else
            self._indicator_widget.style.circle_indicator.color[1] = 0
        end
    end
    
    -- Update position and size based on settings
    local size = mod:get("indicator_size") or 15
    self._indicator_widget.style.circle_indicator.size[1] = size
    self._indicator_widget.style.circle_indicator.size[2] = size
    
end

return HudElementAggroIndicator
