---@class PlayState
PlayState = Class {__includes = BaseState}

PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT = 800, 500
PLAYER_1_PLAYZONE_X = 21

function PlayState:init()
end

function PlayState:render()
    love.graphics.draw(gTextures["background-large"])

    self._player1:render()
    if (self._numOfPlayers == 2) then
        self._player2:render()
    end
end

function PlayState:update(dt)
    self._player1:update(dt)
    if (self._numOfPlayers == 2) then
        self._player2:update(dt)
    end

    if (love.keyboard.wasPressed("escape")) then
        gStateMachine:change("pause", {pausedPlayState = self})
    end
end

function PlayState:enter(params)
    love.window.setMode(PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT)

    self._numOfPlayers = params.numOfPlayers

    if (self._numOfPlayers == 1) then
        self._player1 =
            Player(
            PLAYSTATE_WINDOW_WIDTH / 2 - (PLAYZONE_WIDTH + 50 + PREVIEW_FRAME_WIDTH) / 2,
            PLAYER_1_PLAYZONE_X + 4,
            {rotate = "space", left = "a", right = "d", accelerate = "s"}
        )
    elseif (self._numOfPlayers == 2) then
        self._player1 =
            Player(
            PLAYSTATE_WINDOW_WIDTH / 4 - PLAYZONE_WIDTH / 2,
            PLAYER_1_PLAYZONE_X + 4,
            {rotate = "space", left = "a", right = "d", accelerate = "s"}
        )
        self._player2 =
            Player(
            3 * PLAYSTATE_WINDOW_WIDTH / 4 - (PLAYZONE_WIDTH + 50 + PREVIEW_FRAME_WIDTH) / 2,
            PLAYER_1_PLAYZONE_X + 4,
            {rotate = "up", left = "left", right = "right", accelerate = "down"}
        )
    end
end
