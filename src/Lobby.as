package
{
    import starling.display.Sprite;
    import starling.display.Button;
    import starling.text.TextField;
    import starling.events.Event;
    import starling.core.Starling;
    import feathers.layout.AnchorLayout;
    import feathers.controls.LayoutGroup;
    import feathers.layout.VerticalLayout;
    import starling.animation.Transitions;
    import starling.events.TouchEvent;
    import starling.events.Touch;
    import starling.events.TouchPhase;
    import starling.display.DisplayObject;
    import feathers.core.PopUpManager;
    import flash.utils.Dictionary;

    public class Lobby extends Sprite implements iState
    {
        private var _main_sprite:Sprite;
        public var _start_button:Button;
        public var _best_score_text:TextField;

        public var _bgm_sprite:ButtonSprite;
        public var _sfx_sprite:ButtonSprite;
        public var _info_button:Button;
        public var _leaderboard_button:Button;
        public var _language_button:Button;
        public var _settings_drop_down:Sprite;
        public var _settings_button:Button;
        private var info_popup:InfoPopup;
        private var leaderboard_popup:LeaderboardPopup;
        private var language_popup:LanguagePopup;
        private var _params:Dictionary;
        public static const linkers:Array = [AnchorLayout, LayoutGroup, VerticalLayout];

        public function Lobby()
        {
            trace("Lobby Constructor");
            _main_sprite = new Sprite();
            var data:Object = Game.current_instance._ui_builder.load(ParsedLayouts.lobby_ui, false, this);
            _main_sprite = data.object as Sprite;
            addChild(_main_sprite);

            _params = data.params;

            _settings_drop_down.y = -250;
            _settings_drop_down.visible = false;

            _best_score_text.text = _best_score_text.text + Game.current_instance.topScore;

            _start_button.addEventListener(Event.TRIGGERED, onStartButtonTrigger);
            _settings_button.addEventListener(Event.TRIGGERED, onSettingsTrigger);
            _leaderboard_button.addEventListener(Event.TRIGGERED, onLeaderboardTrigger);
            _language_button.addEventListener(Event.TRIGGERED, onLanguageTrigger);

            _bgm_sprite.disabled = Game.current_instance.bgm_muted;
            _sfx_sprite.disabled = Game.current_instance.sfx_muted;
        }

        public function update():void
        {
            Game.current_instance._ui_builder.localizeTexts(_main_sprite, _params);

            _best_score_text.text = Game.current_instance._ui_builder.localization.getLocalizedText("text_02") + Game.current_instance.topScore;
        }

        public function destroy():void
        {
            _main_sprite.removeFromParent(true);
            _start_button.removeEventListener(Event.TRIGGERED, onStartButtonTrigger);
            trace("Lobby Destroyed");
        }

        private function onStartButtonTrigger(event:Event):void
        {
            Game.current_instance._sfxPlayer.playFx("button_click");
            Game.current_instance.changeState(1);
        }

        private function onSettingsTrigger(event:Event):void
        {
            Game.current_instance._sfxPlayer.playFx("button_click");

            if (_settings_drop_down.visible == false)
            {
                _settings_drop_down.visible = true;
                Starling.juggler.tween(_settings_drop_down, 0.2, {
                            y: 50,
                            transition: Transitions.EASE_OUT_BACK,
                            onComplete: this.addEventListener,
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
                trace("user touched ", targetObject.name);

                if (targetObject.name == "_bgm_sprite")
                {
                    Game.current_instance._sfxPlayer.playFx("button_click");
                    _bgm_sprite.disabled = !_bgm_sprite.disabled;
                    Game.current_instance.bgm_muted = !Game.current_instance.bgm_muted;
                }
                else if (targetObject.name == "_sfx_sprite")
                {
                    Game.current_instance._sfxPlayer.playFx("button_click");
                    _sfx_sprite.disabled = !_sfx_sprite.disabled;
                    Game.current_instance.sfx_muted = !Game.current_instance.sfx_muted;
                }
                else if (targetObject.name == "_info_button")
                {
                    info_popup = new InfoPopup();
                    info_popup.addEventListener(Event.REMOVED_FROM_STAGE, onInfoPopupRemoved);
                    PopUpManager.addPopUp(info_popup);
                    hideDroDown();
                }
                else
                {
                    hideDroDown();
                }
            }
        }

        public function hideDroDown():void
        {
            this.removeEventListener(TouchEvent.TOUCH, onTouchStage);

            Starling.juggler.tween(_settings_drop_down, 0.2, {
                        y: -250,
                        transition: Transitions.EASE_IN_OUT_BACK,
                        onComplete: function():void
                        {
                            _settings_drop_down.visible = false;
                        }
                    });
        }

        private function onInfoPopupRemoved(event:Event):void
        {
            info_popup.removeEventListener(Event.REMOVED_FROM_STAGE, onInfoPopupRemoved);
            info_popup = null;
        }

        private function onLeaderboardTrigger(event:Event):void
        {
            Game.current_instance._sfxPlayer.playFx("button_click");
            leaderboard_popup = new LeaderboardPopup();
            leaderboard_popup.addEventListener(Event.REMOVED_FROM_STAGE, onLeaderboardPopupRemoved);
            PopUpManager.addPopUp(leaderboard_popup);
        }

        private function onLeaderboardPopupRemoved(event:Event):void
        {
            leaderboard_popup.removeEventListener(Event.REMOVED_FROM_STAGE, onLeaderboardPopupRemoved);
            leaderboard_popup.destroy();
            leaderboard_popup = null;
        }

        private function onLanguageTrigger(event:Event):void
        {
            Game.current_instance._sfxPlayer.playFx("button_click");
            language_popup = new LanguagePopup();
            language_popup.addEventListener(Event.REMOVED_FROM_STAGE, onLanguagePopupRemoved);
            PopUpManager.addPopUp(language_popup);
        }

        private function onLanguagePopupRemoved(event:Event):void
        {
            language_popup.removeEventListener(Event.REMOVED_FROM_STAGE, onLanguagePopupRemoved);
            language_popup.destroy();
            language_popup = null;
        }
    }
}