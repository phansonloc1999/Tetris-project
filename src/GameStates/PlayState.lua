---@class PlayState
PlayState = Class {__includes = BaseState}

local PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT = 800, 500

function PlayState:init()
end

function PlayState:render()
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
end

function PlayState:enter(params)
    love.window.setMode(PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT)

    self._numOfPlayers = params.numOfPlayers

    if (self._numOfPlayers == 1) then
        self._player1 = Player(PLAYSTATE_WINDOW_WIDTH / 2 - (PLAYZONE_WIDTH + 50 + PREVIEW_FRAME_WIDTH) / 2, 0)
    elseif (self._numOfPlayers == 2) then
        self._player1 = Player(PLAYSTATE_WINDOW_WIDTH / 4 - (PLAYZONE_WIDTH + 50 + PREVIEW_FRAME_WIDTH) / 2, 0)
        self._player2 = Player(3 * PLAYSTATE_WINDOW_WIDTH / 4 - (PLAYZONE_WIDTH + 50 + PREVIEW_FRAME_WIDTH) / 2, 0)
    end
end
