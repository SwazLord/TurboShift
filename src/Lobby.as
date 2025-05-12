package
{
    import starling.display.Sprite;
    import starling.display.Button;
    import starling.events.Event;
    import feathers.controls.LayoutGroup;
    import starling.display.Image;
    import flash.geom.Rectangle;
    import starling.text.TextField;
    import feathers.core.PopUpManager;
    import starling.core.Starling;
    import starling.events.TouchEvent;
    import starling.events.Touch;
    import starling.display.DisplayObject;
    import starling.events.TouchPhase;
    import flash.utils.Dictionary;
    import starling.display.MovieClip;

    public class Lobby extends Sprite implements iState
    {
        private var _main_sprite:Sprite;
        public var _start_button:Button;
        public var _root_layout:LayoutGroup;
        private var _tile_image:Image;
        private var _scroll_rect:Rectangle;
        public var _best_score_text:TextField;
        public var _leaderboard_button:Button;
        public var _settings_button:Button;
        public var _info_button:Button;
        public var _settings_drop_down:Sprite;
        public var _bgm_sprite:ButtonSprite;
        public var _sfx_sprite:ButtonSprite;
        private var _leaderboard_popup:LeaderboardPopup;
        private var _languages_popup:LanguagePopup;
        private var _ui_params:Dictionary;
        public var _bird_mc:MovieClip;
        public function Lobby()
        {
            trace("lobby state initiated");
            var ui_object:Object = TurboShift.root.asset_manager.getObject("lobby_ui");
            var ui_data:Object = TurboShift.root.ui_builder.load(ui_object, false, this);
            _ui_params = ui_data.params;
            _main_sprite = ui_data.object as Sprite;
            // _main_sprite = TurboShift.root.ui_builder.create(ui_object, false, this) as Sprite;
            addChild(_main_sprite);
            _start_button.addEventListener(Event.TRIGGERED, onStartButtonTriggered);
            _leaderboard_button.addEventListener(Event.TRIGGERED, onLeaderboardTriggered);
            _settings_button.addEventListener(Event.TRIGGERED, onSettingsTriggered);
            _info_button.addEventListener(Event.TRIGGERED, onInfoButtonTriggered);
            _tile_image = _root_layout.backgroundSkin as Image;
            _scroll_rect = _tile_image.tileGrid;
            _best_score_text.text = _best_score_text.text + TurboShift.root.best_score.toString();
            _settings_drop_down.y = -270;
            _settings_drop_down.visible = false;
            _bgm_sprite.disabled = TurboShift.root.bgm_muted;
            _sfx_sprite.disabled = TurboShift.root.sfx_muted;
            TurboShift.root.asset_manager.playSound("game_loop", 0, 999);
            Starling.juggler.add(_bird_mc);
        }

        public function update(timePassed:Number):void
        {
            _scroll_rect.y += 2;
            _tile_image.tileGrid = _scroll_rect;
        }

        public function destroy():void
        {
            _main_sprite.removeFromParent(true);
            _main_sprite = null;
            _start_button.removeEventListener(Event.TRIGGERED, onStartButtonTriggered);
            this.removeFromParent(true);
            trace("lobby state destroyed");

        }

        private function onStartButtonTriggered(event:Event):void
        {
            TurboShift.root.sfx_player.playFx("button_click");
            TurboShift.root.changeState(1);
        }

        private function onLeaderboardTriggered(event:Event):void
        {
            TurboShift.root.sfx_player.playFx("button_click");
            _leaderboard_popup = new LeaderboardPopup();
            PopUpManager.addPopUp(_leaderboard_popup);
        }

        private function onSettingsTriggered(event:Event):void
        {
            TurboShift.root.sfx_player.playFx("button_click");
            if (_settings_drop_down.visible == false)
            {
                _settings_drop_down.visible = true;
                Starling.juggler.tween(_settings_drop_down, 0.2, {

                            y: 50,
                            onComplete: addEventListener,
                            onCompleteArgs: [TouchEvent.TOUCH, onTouchStage]
                        });
            }

        }

        private function onTouchStage(event:TouchEvent):void
        {
            var touch_ended:Touch = event.getTouch(stage, TouchPhase.ENDED);
            if (touch_ended != null)
            {
                var targetObject:DisplayObject = event.target as DisplayObject;
                trace("user touched - " + targetObject.name);

                if (targetObject.name == "_bgm_sprite")
                {
                    _bgm_sprite.disabled = !_bgm_sprite.disabled;
                    TurboShift.root.bgm_muted = !TurboShift.root.bgm_muted;
                }
                else if (targetObject.name == "_sfx_sprite")
                {
                    _sfx_sprite.disabled = !_sfx_sprite.disabled;
                    TurboShift.root.sfx_muted = !TurboShift.root.sfx_muted;
                }
                else
                {
                    removeSettingsDropDown();
                }
            }
        }

        private function removeSettingsDropDown():void
        {
            removeEventListener(TouchEvent.TOUCH, onTouchStage);

            Starling.juggler.tween(_settings_drop_down, 0.1, {

                        y: -250,
                        onComplete: function():void
                        {
                            _settings_drop_down.visible = false;
                        }
                    });
        }

        private function onInfoButtonTriggered(event:Event):void
        {
            TurboShift.root.sfx_player.playFx("button_click");
            _languages_popup = new LanguagePopup();
            PopUpManager.addPopUp(_languages_popup);
        }

        public function localize():void
        {
            TurboShift.root.ui_builder.localizeTexts(_main_sprite, _ui_params);
            _best_score_text.text = TurboShift.root.ui_builder.localization.getLocalizedText("text_02") + TurboShift.root.best_score.toString();
        }
    }
}