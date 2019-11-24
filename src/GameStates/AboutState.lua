---@class AboutState
AboutState = Class {__includes = BaseState}

function AboutState:init()
    self._okButton =
        RectButton(
        PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.buttons.ok.deselected:getWidth() / 2,
        420,
        function()
            gStateMachine:change("menu")
        end,
        {
            deselected = gTextures.buttons.ok.deselected,
            selected = gTextures.buttons.ok.selected
        },
        "deselected"
    )
end

function AboutState:render()
    love.graphics.draw(gTextures.titles.about, PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.titles.about:getWidth() / 2)

    self._okButton:render()
end

function AboutState:update(dt)
    if (self._okButton:collidesWithMouse()) then
        self._okButton:onSelect()

        if (love.mouse.wasPressed(1)) then
            self._okButton:onClick(self)
        end
    elseif (self._okButton._selected) then
        self._okButton:onDeselect()
    end
end
