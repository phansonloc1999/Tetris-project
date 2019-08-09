---@class PlayState
PlayState = Class {__includes = BaseState}

local PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT = 800, 500

function PlayState:init()
    self._player1 = Player(0, 0)
end

function PlayState:render()
    self._player1:render()
end

function PlayState:update(dt)
    self._player1:update(dt)
end

function PlayState:enter(params)
    love.window.setMode(PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT)
end