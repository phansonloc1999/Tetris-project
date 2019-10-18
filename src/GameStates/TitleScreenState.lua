---@class TitleScreenState
TitleScreenState = Class {__includes = BaseState}

function TitleScreenState:init()
    self._buttons = {}
    self._buttons.go =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.go.deselected:getWidth() / 2 + PLAYSTATE_WINDOW_WIDTH / 2 -
            WINDOW_WIDTH / 2,
        300,
        function()
            gStateMachine:change("menu")
        end,
        {
            selected = gTextures.buttons.go.selected,
            deselected = gTextures.buttons.go.deselected
        },
        "deselected"
    )

    self._buttons.quit =
        RectButton(
        self._buttons.go:getX(),
        self._buttons.go:getY() + self._buttons.go:getHeight() + 20,
        function()
            love.event.quit()
        end,
        {
            selected = gTextures.buttons.quit.selected,
            deselected = gTextures.buttons.quit.deselected
        },
        "deselected"
    )
end

function TitleScreenState:render()
    love.graphics.draw(gTextures["title-screen"], PLAYSTATE_WINDOW_WIDTH / 2 - WINDOW_WIDTH / 2)

    for key, button in pairs(self._buttons) do
        button:render()
    end
end

function TitleScreenState:update(dt)
    for key, button in pairs(self._buttons) do
        if (button:collidesWithMouse()) then
            button:onSelect()
            if (love.mouse.wasPressed(1)) then
                button:onClick()
            end
        elseif (button._selected) then
            button:onDeselect()
        end
    end
end
