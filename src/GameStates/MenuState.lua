---@class MenuState
MenuState = Class {__includes = BaseState}

local BUTTON_WIDTH, BUTTON_HEIGHT = 100, 30

function MenuState:init()
    self._buttons = {} ---@type RectButton[]
    self._buttons.playButton =
        RectButton(
        0,
        0,
        BUTTON_WIDTH,
        BUTTON_HEIGHT,
        function()
            gStateMachine:change("play")
        end,
        nil,
        nil
    )
    self._buttons.playButton:setPos(
        getCenterX(0, love.graphics.getWidth(), self._buttons.playButton._hitbox._width),
        250
    )

    self._buttons.aboutButton =
        RectButton(
        0,
        0,
        BUTTON_WIDTH,
        BUTTON_HEIGHT,
        function()
        end
    )
    self._buttons.aboutButton:setPos(
        getPositionsWithOffsets(
            self._buttons.playButton._hitbox._pos._x,
            self._buttons.playButton._hitbox._pos._y,
            0,
            80
        )
    )

    self._buttons.quitButton =
        RectButton(
        0,
        0,
        BUTTON_WIDTH,
        BUTTON_HEIGHT,
        function()
            love.event.quit()
        end
    )
    self._buttons.quitButton:setPos(
        getPositionsWithOffsets(
            self._buttons.aboutButton._hitbox._pos._x,
            self._buttons.aboutButton._hitbox._pos._y,
            0,
            80
        )
    )
end

function MenuState:render()
    for key, button in pairs(self._buttons) do
        button:render()
    end
end

function MenuState:update(dt)
    if (love.mouse.wasPressed(1)) then
        for key, button in pairs(self._buttons) do
            if (button:collidesWithMouse()) then
                button:onClick()
                return
            end
        end
    end
end
