package
{
    import starling.display.Sprite;
    import starling.text.TextField;
    import feathers.controls.LayoutGroup;
    import starling.events.Event;
    import starling.events.EnterFrameEvent;
    import starling.core.Starling;
    import starling.events.TouchEvent;
    import starling.events.Touch;
    import starling.events.TouchPhase;
    import starling.animation.Tween;
    import flash.geom.Rectangle;
    import starling.display.MovieClip;
    import starling.animation.DelayedCall;
    import feathers.core.PopUpManager;
    import flash.geom.Point;
    import treefortress.sound.SoundManager;
    import treefortress.sound.SoundInstance;

    public class RaceGame extends Sprite implements iState
    {
        private var _main_sprite:Sprite;
        public var _player_car:PlayerCar;
        public var _score_label:TextField;
        public var _score_text:TextField;
        public var _main_layout:LayoutGroup;
        private var road:Road;
        private var _enemyPool:StarlingPool;
        private var current_enemy:EnemyCar;
        // Lane positions
        private var _lanePositions:Array;
        private var _activeEnemies:Array = [];
        // Speed variables
        private var _currentSpeed:Number = 10; // Starting speed
        private var _maxSpeed:Number = 100; // Maximum speed cap
        private var _speedIncreaseRate:Number = 0.5; // How much to increase per
        private var _playerLane:uint;
        private var player_lane_tween:Tween;
        private var _score:uint;
        private var _speedIncreaseCall:DelayedCall;
        private var round_over_popup:RoundOverPopUp;
        private var big_explosion:BigExplosion;
        private var pink_smoke:PinkSmoke;
        private var _audioPlayer:SoundManager = new SoundManager();
        private var new_high_score:Boolean;
        public function RaceGame()
        {
            trace("Race Game Constructor");

            road = new Road();
            addChild(road);

            _main_sprite = new Sprite();
            _main_sprite = Game.current_instance._ui_builder.create(ParsedLayouts.race_game_ui, false, this) as Sprite;
            addChild(_main_sprite);

            // Create delayed call for speed increases
            _speedIncreaseCall = new DelayedCall(updateSpeed, 1); // Increase speed every second
            _speedIncreaseCall.repeatCount = 0; // Repeat indefinitely

            // Calculate lane positions (center of each lane)
            var laneWidth:Number = _main_layout.width / 2;
            _lanePositions = [laneWidth / 2, laneWidth + laneWidth / 2];

            _enemyPool = new StarlingPool(EnemyCar, 4);

            big_explosion = new BigExplosion();

            _audioPlayer.mute = Game.current_instance.sfx_muted;
            _audioPlayer.loadSound("assets/sounds/car_loop.mp3", "car_loop");
            _audioPlayer.loadSound("assets/sounds/big_explosion.mp3", "big_explosion");
            _audioPlayer.loadSound("assets/sounds/change_lane.mp3", "change_lane");
            _audioPlayer.loadSound("assets/sounds/new_high_score.mp3", "new_high_score");

            startRace();

        }

        public function resetRace():void
        {
            for each (var enemy:EnemyCar in _activeEnemies)
            {
                enemy.y = -enemy.height;
                enemy.reset();

                _enemyPool.returnSprite(enemy);
            }

            _activeEnemies = [];

            removeRoundOverPopup();

            _player_car.reset();

            startRace();
        }

        private function startRace():void
        {
            _audioPlayer.playLoop("car_loop", 0);
            _audioPlayer.getSound("car_loop").fadeFrom(0, 1, 3000);
            Game.current_instance._bgmPlayer.getSound("game_loop").fadeTo(0.5);

            Starling.juggler.add(_speedIncreaseCall);
            Starling.juggler.delayCall(spawnEnemy, 2);

            _score = 0;

            updateScore(0);

            _currentSpeed = 5;

            _player_car.x = _lanePositions[_playerLane];

            pink_smoke = new PinkSmoke();
            _main_layout.addChildAt(pink_smoke, 0);

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(TouchEvent.TOUCH, onTouchGameSp);
        }

        private function updateSpeed():void
        {
            // Increase the current speed, but cap at maximum
            _currentSpeed = Math.min(_currentSpeed + _speedIncreaseRate, _maxSpeed);
            // trace("_currentSpeed = " + _currentSpeed);
        }

        private function spawnEnemy():void
        {
            current_enemy = _enemyPool.getSprite() as EnemyCar;
            current_enemy.alignPivot();

            // Randomly select a lane
            var lane:int = Math.floor(Math.random() * 2); // 0 or 1

            current_enemy.x = _lanePositions[lane];
            current_enemy.y = current_enemy.height * -(Math.floor(Math.random() * 4) + 1);
            current_enemy.reset();
            _main_layout.addChildAt(current_enemy, 0);
            _activeEnemies.push(current_enemy);
        }

        public function update():void
        {
            throw new Error("Method not implemented.");
        }

        public function destroy():void
        {
            _main_sprite.removeFromParent(true);
            _main_sprite = null;

            road.destroy();
            road.removeFromParent(true);
            road = null;

            big_explosion.destroy();
            big_explosion.removeFromParent(true);
            big_explosion = null;

            _player_car.destroy();
            _player_car.removeFromParent(true);
            _player_car = null;

            _audioPlayer.removeAll();
            _audioPlayer = null;

        }

        private function onEnterFrame(event:EnterFrameEvent):void
        {
            // Get the time passed since last frame (in seconds)
            var deltaTime:Number = event.passedTime;
            road.update(deltaTime * _currentSpeed);

            pink_smoke.x = _player_car.x + _player_car.width / 8;
            pink_smoke.y = _player_car.y + _player_car.height / 3;

            var len:uint = _activeEnemies.length;
            // Move all active enemies downward
            var i:int = len - 1;
            while (i >= 0)
            {
                var enemy:EnemyCar = _activeEnemies[i];
                enemy.y += _currentSpeed * deltaTime * 60; // Multiply by 60 to normalize for 60 FPS
                i--;

                // Check if enemy has moved off-screen
                if (enemy.y > _main_layout.height + enemy.height)
                {
                    updateScore(10);
                    // Remove from active enemies
                    _activeEnemies.splice(i, 1);

                    _main_layout.removeChild(enemy);

                    // Return to pool
                    _enemyPool.returnSprite(enemy);

                    spawnEnemy();
                }

                // Check for collision with player
                if (checkCollision(_player_car, enemy))
                {
                    trace("Collision Detected - Game Over!");

                    _player_car.crashed();
                    enemy.crashed();

                    pink_smoke.destroy();
                    pink_smoke.removeFromParent(true);
                    pink_smoke = null;

                    _audioPlayer.getSound("car_loop").fadeTo(0).soundCompleted.add(function(si:SoundInstance):void
                        {
                            _audioPlayer.pause("car_loop");
                        });

                    Starling.juggler.tween(this, 0.3, {x: this.x + 10, transition: Animations.SHAKE_3X});

                    Starling.juggler.delayCall(displayRoundOverPopup, 3);

                    if (_score > Game.current_instance.topScore)
                    {
                        Game.current_instance.topScore = _score;
                    }
                }
            }
        }

        private function displayRoundOverPopup():void
        {
            Game.current_instance._bgmPlayer.fadeFrom("game_loop", 0.5, 1, 3000);
            round_over_popup = new RoundOverPopUp();
            PopUpManager.addPopUp(round_over_popup);
        }

        public function quitRaceGame():void
        {
            removeRoundOverPopup();
            Game.current_instance.changeState(0);
        }

        private function removeRoundOverPopup():void
        {
            round_over_popup.destroy();
            PopUpManager.removePopUp(round_over_popup);
            round_over_popup = null;
        }

        private function updateScore(points:int):void
        {
            _score += points;
            _score_text.text = _score.toString();

            if (new_high_score == false && (_score > Game.current_instance.topScore))
            {
                new_high_score = true;
                _audioPlayer.playFx("new_high_score");
            }
        }

        private function checkCollision(player_car:Sprite, enemy_car:MovieClip):Boolean
        {
            var boundsA:Rectangle = player_car.bounds;
            var boundsB:Rectangle = enemy_car.bounds;

            if (boundsA.intersects(boundsB))
            {
                var collisionArea:Rectangle = boundsA.intersection(boundsB);
                var collisionPoint:Point = new Point(collisionArea.x + collisionArea.width / 2, collisionArea.y + collisionArea.height / 2);

                big_explosion.x = collisionPoint.x;
                big_explosion.y = collisionPoint.y;
                _main_layout.addChild(big_explosion);
                big_explosion.play();
                _audioPlayer.playFx("big_explosion");

                removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                this.removeEventListener(TouchEvent.TOUCH, onTouchGameSp);
                Starling.juggler.remove(player_lane_tween);
                Starling.juggler.remove(_speedIncreaseCall);
                return true;
            }

            return false;
        }

        private function onTouchGameSp(event:TouchEvent):void
        {
            var touch_ended:Touch = event.getTouch(stage, TouchPhase.ENDED);
            if (touch_ended != null)
            {
                _playerLane = _playerLane == 0 ? 1 : 0; // Switch to opposite lane

                // Determine rotation direction based on lane change
                var rotationDirection:Number = _playerLane == 1 ? 0.2 : -0.2;
                // Rotate +1 when going right, -1 when going left

                // Create tweens for smooth lane transition and rotation
                player_lane_tween = new Tween(_player_car, 0.1);
                player_lane_tween.animate("x", _lanePositions[_playerLane]);
                player_lane_tween.animate("rotation", rotationDirection); // Add rotation animation

                // After the lane change completes, reset the rotation
                player_lane_tween.onComplete = function():void
                {
                    // Create a small delay before resetting rotation (optional)
                    var resetTween:Tween = new Tween(_player_car, 0.05);
                    resetTween.animate("rotation", 0); // Reset rotation to normal
                    Starling.juggler.add(resetTween);
                };

                Starling.juggler.add(player_lane_tween);
                _audioPlayer.playFx("change_lane");
            }

        }
    }
}