---@class TitleScreenState
TitleScreenState = Class {__includes = BaseState}

function TitleScreenState:init()
    self._goText = love.graphics.newText(gFonts.large, "GO!")
    self._anyKeyText = love.graphics.newText(gFonts.small, "PRESS ANY KEY TO CONTINUE")
end

function TitleScreenState:render()
    love.graphics.draw(
        self._goText,
        WINDOW_WIDTH / 2 - self._goText:getWidth() / 2,
        WINDOW_HEIGHT / 2 - self._goText:getHeight() / 2 + 40
    )
    love.graphics.draw(
        self._anyKeyText,
        WINDOW_WIDTH / 2 - self._anyKeyText:getWidth() / 2,
        WINDOW_HEIGHT / 2 - self._goText:getHeight() / 2 + 40 + self._goText:getHeight() + 10
    )
end

function TitleScreenState:update(dt)
    local keysPressedCounter = 0
    for key, keyPressed in pairs(love.keyboard.keysPressed) do
        keysPressedCounter = keysPressedCounter + 1
    end
    if (keysPressedCounter > 0) then
        gStateMachine:change("menu")
    end
end
