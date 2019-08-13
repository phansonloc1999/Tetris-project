---@class SelectModeState
SelectModeState = Class {__includes = BaseState}

function SelectModeState:init()
    self._1playerMode = RectButton(0, 0, 80, 80)
    self._1playerMode:setPos(
        WINDOW_WIDTH / 4 - self._1playerMode:getWidth() / 2,
        WINDOW_HEIGHT / 2 - self._1playerMode:getHeight() / 2
    )

    self._2playerMode = RectButton(0, 0, 80, 80)
    self._2playerMode:setPos(
        3 * WINDOW_WIDTH / 4 - self._2playerMode:getWidth() / 2,
        WINDOW_HEIGHT / 2 - self._2playerMode:getHeight() / 2
    )
end

function SelectModeState:render()
    self._1playerMode:render()
    self._2playerMode:render()
end

function SelectModeState:update(dt)
    if (love.mouse.wasPressed(1)) then
        if (self._1playerMode:collidesWithMouse()) then
            gStateMachine:change("play", {numOfPlayers = 1})
        end
        if (self._2playerMode:collidesWithMouse()) then
            gStateMachine:change("play", {numOfPlayers = 2})
        end
    end
end
