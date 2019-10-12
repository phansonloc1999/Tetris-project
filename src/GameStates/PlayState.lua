---@class PlayState
PlayState = Class {__includes = BaseState}

PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT = 800, 500
PLAYER_1_PLAYZONE_X = 21

function PlayState:init()
    GENERATED_TETROMINOES_HISTORY = {}
end

function PlayState:render()
    love.graphics.draw(gTextures["background-large"])

    if (self._numOfPlayers == 2) then
        self._player2:render()
    end
    love.graphics.setColor(1, 1, 1)

    self._player1:render()
    if (self._numOfPlayers == 2) then
        self._player2._nextTetromino:render()
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
    self._numOfPlayers = params.numOfPlayers

    if (self._numOfPlayers == 1) then
        self._player1 =
            Player(
            WINDOW_WIDTH - PLAYZONE_WIDTH - 20,
            30,
            WINDOW_WIDTH - PLAYZONE_WIDTH - 70 - gTextures["preview-board"]:getWidth(),
            120,
            gTextures["preview-board"],
            PREVIEW_FRAME_WIDTH / 4,
            {rotate = "space", left = "a", right = "d", accelerate = "s"},
            params.animal,
            -50 - gTextures.score_boards.one_player:getWidth(),
            -10,
            gTextures.score_boards.one_player
        )
    elseif (self._numOfPlayers == 2) then
        love.window.setMode(PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT)
        PREVIEW_FRAME_WIDTH, PREVIEW_FRAME_HEIGHT = 146, 91

        self._player1 =
            Player(
            PLAYSTATE_WINDOW_WIDTH / 2 - PREVIEW_FRAME_WIDTH / 2 - PLAYZONE_TO_PREVIEW_SPACING - PLAYZONE_WIDTH,
            PLAYER_1_PLAYZONE_X + 4,
            PLAYSTATE_WINDOW_WIDTH / 2 - PREVIEW_FRAME_WIDTH / 2,
            130,
            gTextures["preview-board-2-players"],
            0,
            {rotate = "space", left = "a", right = "d", accelerate = "s"},
            params.player1Animal,
            PREVIEW_FRAME_WIDTH / 2 + PLAYZONE_TO_PREVIEW_SPACING + PLAYZONE_WIDTH -
                gTextures.score_boards.p1:getWidth() +
                15,
            0,
            gTextures.score_boards.p1
        )
        self._player2 =
            Player(
            PLAYSTATE_WINDOW_WIDTH / 2 + PREVIEW_FRAME_WIDTH / 2 + PLAYZONE_TO_PREVIEW_SPACING,
            PLAYER_1_PLAYZONE_X + 4,
            PLAYSTATE_WINDOW_WIDTH / 2 - PREVIEW_FRAME_WIDTH / 2,
            130,
            nil,
            PREVIEW_FRAME_WIDTH / 2,
            {rotate = "up", left = "left", right = "right", accelerate = "down"},
            params.player2Animal,
            -PREVIEW_FRAME_WIDTH / 2 - PLAYZONE_TO_PREVIEW_SPACING - 10,
            0,
            gTextures.score_boards.p2
        )
    end
end
