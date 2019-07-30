---@class PlayState
PlayState = Class {__includes = BaseState}

function PlayState:init()
    self._player1 = Player(0, 0)
end

function PlayState:render()
    self._player1:render()
end

function PlayState:update(dt)
    self._player1:update(dt)
end
