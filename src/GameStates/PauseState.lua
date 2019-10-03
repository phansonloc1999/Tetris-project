---@class PauseState
PauseState = Class {__includes = BaseState}

function PauseState:init()
    self._name = "Pause State"
end

function PauseState:render()
    love.graphics.draw(gTextures["pause-background"])

    for key, button in pairs(self._buttons) do
        button:render()
    end
end

function PauseState:update(dt)
    for key, button in pairs(self._buttons) do
        if (button:collidesWithMouse()) then
            button:onSelect()

            if (love.mouse.wasPressed(1)) then
                button:onClick(self)
            end
        elseif (button._selected) then
            button:onDeselect()
        end
    end
end

function PauseState:enter(params)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    self._pausedPlayState = params.pausedPlayState

    local SPACING_BETWEEN_BUTTONS = 17

    self._buttons = {}
    self._buttons.back =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.back.deselected:getWidth() / 2,
        WINDOW_HEIGHT / 2 - (SPACING_BETWEEN_BUTTONS * 3 + gTextures.buttons.back.deselected:getHeight() * 4) / 2 + 50,
        function(pauseState)
            love.window.setMode(PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT)
            gStateMachine.current = pauseState._pausedPlayState
        end,
        gTextures.buttons.back,
        "deselected"
    )

    self._buttons.reset =
        RectButton(
        self._buttons.back:getX(),
        self._buttons.back:getY() + self._buttons.back:getHeight() + SPACING_BETWEEN_BUTTONS,
        function(pauseState)
            gStateMachine:change("play", {numOfPlayers = pauseState._pausedPlayState._numOfPlayers})
        end,
        gTextures.buttons.reset,
        "deselected"
    )

    self._buttons.option =
        RectButton(
        self._buttons.reset:getX(),
        self._buttons.reset:getY() + self._buttons.reset:getHeight() + SPACING_BETWEEN_BUTTONS,
        function()
        end,
        gTextures.buttons.option,
        "deselected"
    )

    self._buttons.quit =
        RectButton(
        self._buttons.option:getX(),
        self._buttons.option:getY() + self._buttons.option:getHeight() + SPACING_BETWEEN_BUTTONS,
        function()
            gStateMachine:change("menu")
        end,
        gTextures.buttons.menu_quit,
        "deselected"
    )
end