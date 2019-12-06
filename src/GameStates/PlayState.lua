---@class PlayState
PlayState = Class {__includes = BaseState}

PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT = 800, 500
PLAYER_1_PLAYZONE_X = 21

function PlayState:init()
    GENERATED_TETROMINOES_HISTORY = {}

    self._pauseButton =
        RectButton(
        62,
        320,
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
    if (self._numOfPlayers == 1) then
        love.graphics.draw(gTextures["background"])
    else
        love.graphics.draw(gTextures["background-large"])
    end

    if (self._numOfPlayers == 2) then
        self._player2:render()
    end
    love.graphics.setColor(1, 1, 1)

    self._player1:render()
    if (self._numOfPlayers == 2) then
        self._player2._nextTetromino:render()
    end

    love.graphics.setColor(1, 1, 1)
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
    if
        (self._timer < 0 or (self._player1._isGameOver and self._numOfPlayers == 1) or
            (self._player1._isGameOver and self._player2._isGameOver))
     then
        if (self._numOfPlayers == 1) then
            gStateMachine:change(
                "game_over",
                {numOfPlayers = 1, animal = self._player1._animal, score = self._player1._scoreBoard._scoreValue}
            )
        else
            gStateMachine:change(
                "game_over",
                {
                    numOfPlayers = 2,
                    player1Animal = self._player1._animal,
                    player2Animal = self._player2._animal,
                    player1Score = self._player1._scoreBoard._scoreValue,
                    player2Score = self._player2._scoreBoard._scoreValue
                }
            )
        end
    end
end

function PlayState:enter(params)
    self._numOfPlayers = params.numOfPlayers

    if (self._numOfPlayers == 2) then
        love.window.setMode(PLAYSTATE_WINDOW_WIDTH, PLAYSTATE_WINDOW_HEIGHT)
    end

    if (self._numOfPlayers == 1) then
        self._player1 =
            Player(
            WINDOW_WIDTH - PLAYZONE_WIDTH - 20,
            30,
            WINDOW_WIDTH - PLAYZONE_WIDTH - 70 - gTextures["preview-board"]:getWidth(),
            130,
            gTextures["preview-board"],
            PREVIEW_FRAME_WIDTH / 4,
            gKeySettings.player1,
            params.animal,
            -50 - gTextures.score_boards.one_player:getWidth(),
            -10,
            gTextures.score_boards.one_player
        )

        self._timer = gTimeLimit
        self._timerBoard = {x = 45, y = 250}

        self._player1._foodEffect:setPos(75 + PLAYSTATE_WINDOW_WIDTH / 2 - WINDOW_WIDTH / 2, 410)
    elseif (self._numOfPlayers == 2) then
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
            gKeySettings.player1,
            params.player1Animal,
            PREVIEW_FRAME_WIDTH / 2 + PLAYZONE_TO_PREVIEW_SPACING + PLAYZONE_WIDTH -
                gTextures.score_boards.p1:getWidth(),
            0,
            gTextures.score_boards.p1
        )
        self._player1._foodEffect:setPos(
            PLAYSTATE_WINDOW_WIDTH / 2 - 30 - gTextures.small_avatar_inmatch.cat_normal:getWidth(),
            400
        )

        self._player2 =
            Player(
            PLAYSTATE_WINDOW_WIDTH / 2 + PREVIEW_FRAME_WIDTH / 2 + PLAYZONE_TO_PREVIEW_SPACING,
            PLAYER_1_PLAYZONE_X + 4,
            PLAYSTATE_WINDOW_WIDTH / 2 - PREVIEW_FRAME_WIDTH / 2,
            130,
            nil,
            PREVIEW_FRAME_WIDTH / 2,
            gKeySettings.player2,
            params.player2Animal,
            -PREVIEW_FRAME_WIDTH / 2 - PLAYZONE_TO_PREVIEW_SPACING,
            0,
            gTextures.score_boards.p2
        )
        self._player2._foodEffect:setPos(PLAYSTATE_WINDOW_WIDTH / 2 + 30, 400)

        self._timer = gTimeLimit
        self._timerBoard = {x = PLAYSTATE_WINDOW_WIDTH / 2 - gTextures.time_board:getWidth() / 2, y = 230}
    end

    self:resetAudioSettingButtonsPos()
end

function PlayState:exit()
    gSettingsButtons.sound.x = 0
    gSettingsButtons.sound.y = WINDOW_HEIGHT - gTextures.buttons.music.on:getWidth()
    gSettingsButtons.music.x = gSettingsButtons.sound.x + gTextures.buttons.sound.on:getWidth() + 5
    gSettingsButtons.music.y = gSettingsButtons.sound.y
end

function PlayState:resetAudioSettingButtonsPos()
    gSettingsButtons.sound.x = self._pauseButton:getX() + self._pauseButton:getWidth() + 26
    gSettingsButtons.sound.y =
        math.floor(
        self._pauseButton:getY() + self._pauseButton:getHeight() / 2 - gTextures.buttons.sound.on:getHeight() / 2 - 20
    )
    gSettingsButtons.music.x = self._timerBoard.x + gTextures.time_board:getWidth() + 10
    gSettingsButtons.music.y =
        math.floor(
        self._timerBoard.y + gTextures.time_board:getHeight() / 2 - gTextures.buttons.music.on:getHeight() / 2 + 7
    )
end
