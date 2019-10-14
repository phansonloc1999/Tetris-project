---@class PlayState
PlayState = Class {__includes = BaseState}

PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT = 800, 500
PLAYER_1_PLAYZONE_X = 21

function PlayState:init()
    GENERATED_TETROMINOES_HISTORY = {}

    self._pauseButton =
        RectButton(
        60,
        300,
        function()
            gStateMachine:change("pause", {pausedPlayState = self})
        end,
        {
            deselected = gTextures.buttons.pause.deselected,
            selected = gTextures.buttons.pause.selected
        },
        "deselected"
    )
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

    self._pauseButton:render()

    love.graphics.draw(gTextures.time_board, self._timerBoard.x, self._timerBoard.y)
    local timerText = love.graphics.newText(love.graphics.getFont(), tostring(math.floor(self._timer)))
    love.graphics.draw(
        timerText,
        math.floor(self._timerBoard.x + gTextures.time_board:getWidth() / 2 - timerText:getWidth() / 2),
        math.floor(self._timerBoard.y + gTextures.time_board:getHeight() / 2 - timerText:getHeight() / 2 + 6)
    )
end

function PlayState:update(dt)
    self._player1:update(dt)
    if (self._numOfPlayers == 2) then
        self._player2:update(dt)
    end

    if (self._pauseButton:collidesWithMouse()) then
        self._pauseButton:onSelect()

        if (love.mouse.wasPressed(1)) then
            self._pauseButton:onClick()
        end
    elseif (self._pauseButton._selected) then
        self._pauseButton:onDeselect()
    end

    self._timer = self._timer - dt
    if (self._timer < 0) then
    -- gStateMachine:change("end")
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

        self._timer = params.timer
        self._timerBoard = {x = 35, y = 230}
    elseif (self._numOfPlayers == 2) then
        love.window.setMode(PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT)
        PREVIEW_FRAME_WIDTH, PREVIEW_FRAME_HEIGHT = 146, 91

        self._pauseButton:setPos(
            PLAYSTATE_WINDOW_WIDTH / 2 - self._pauseButton._textures[self._pauseButton._currentTexture]:getWidth() / 2,
            300
        )

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

        self._timer = params.timer
        self._timerBoard = {x = PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.time_board:getWidth() / 2, y = 230}
    end
end
