package
{
    import starling.display.Sprite;
    import starling.assets.AssetManager;
    import starlingbuilder.engine.UIBuilder;
    import starlingbuilder.engine.DefaultAssetMediator;
    import feathers.controls.LayoutGroup;
    import feathers.layout.AnchorLayout;
    import starling.display.Button;
    import starling.events.Event;
    import starling.events.EnterFrameEvent;
    import flash.net.SharedObject;
    import feathers.layout.VerticalLayout;
    import feathers.layout.HorizontalLayout;
    import treefortress.sound.SoundManager;
    import flash.system.Capabilities;
    import starlingbuilder.engine.localization.ILocalization;
    import starlingbuilder.engine.localization.DefaultLocalization;

    public class Game extends Sprite
    {
        public static var linkers:Array = [AnchorLayout, VerticalLayout, HorizontalLayout];
        private var _asset_manager:AssetManager;

        public function get asset_manager():AssetManager
        {
            return _asset_manager;
        }
        private var _curent_state:iState;

        public function get curent_state():iState
        {
            return _curent_state;
        }
        private var _ui_builder:UIBuilder;

        public function get ui_builder():UIBuilder
        {
            return _ui_builder;
        }
        private var _asset_mediator:DefaultAssetMediator;
        private var _best_score:uint;

        public function get best_score():uint
        {
            if (_shared_object.data.bestScore == null)
            {
                return 0;
            }
            else
            {
                return int(_shared_object.data.bestScore);
            }
        }

        public function set best_score(value:uint):void
        {
            _shared_object.setProperty("bestScore", value);
            _shared_object.flush();
        }
        private var _shared_object:SharedObject;
        private var _bgm_player:SoundManager;

        public function get bgm_player():SoundManager
        {
            return _bgm_player;
        }
        private var _sfx_player:SoundManager;

        public function get sfx_player():SoundManager
        {
            return _sfx_player;
        }

        private var _bgm_muted:Boolean;

        public function get bgm_muted():Boolean
        {
            if (_shared_object.data.bgm_muted == null)
            {
                return false;
            }
            else
            {
                return _shared_object.data.bgm_muted;
            }
        }

        public function set bgm_muted(value:Boolean):void
        {
            _bgm_player.mute = value;
            _shared_object.setProperty("bgm_muted", value);
            _shared_object.flush();

        }
        private var _sfx_muted:Boolean;

        public function get sfx_muted():Boolean
        {
            if (_shared_object.data.sfx_muted == null)
            {
                return false;
            }
            else
            {
                return _shared_object.data.sfx_muted;
            }
        }

        public function set sfx_muted(value:Boolean):void
        {
            _sfx_player.mute = value;
            _shared_object.setProperty("sfx_muted", value);
            _shared_object.flush();
        }
        private var _locale:String;

        public function get locale():String
        {
            if (SUPPORTED_LOCALES.indexOf(Capabilities.language) != -1)
            {
                return Capabilities.language;
            }
            else
            {
                return "en";
            }

        }

        public function set locale(value:String):void
        {
            _localization.locale = _locale = value;
            if (_curent_state != null)
            {
                (_curent_state as Lobby).localize();
            }

        }
        private var _localization:ILocalization;
        private const SUPPORTED_LOCALES:Array = ["en", "fr", "de"];
        public function Game()
        {
            trace("Root game instance created");
            Animations.registerTransitions();
            _shared_object = SharedObject.getLocal("turbo-shift-gamedata-test");
            _bgm_player = new SoundManager();
            _sfx_player = new SoundManager();
            _asset_manager = new AssetManager();
            _asset_manager.enqueue([
                        "assets/backgrounds/road_tile.png",
                        "assets/textures/texture.png",
                        "assets/textures/texture.xml",
                        "assets/textures/LilitaOne.fnt",
                        "assets/layouts/lobby_ui.json",
                        "assets/layouts/road_ui.json",
                        "assets/layouts/race_ui.json",
                        "assets/layouts/round_over_ui.json",
                        "assets/layouts/leaderboard_ui.json",
                        "assets/layouts/leaderboard_item_ui.json",
                        "assets/layouts/languages_ui.json",
                        "assets/particles/bigExplosion.sde",
                        "assets/particles/blazingFire.sde",
                        "assets/particles/smoke.sde",
                        "assets/localization/strings.json"
                    ]);

            _asset_manager.loadQueue(onComplete, onError, onProgress);

            bgm_player.loadSound("assets/sounds/game_loop.mp3", "game_loop");
            sfx_player.loadSound("assets/sounds/button_click.mp3", "button_click");
        }

        private function onComplete():void
        {
            trace("assets loading complete");
            _localization = new DefaultLocalization(asset_manager.getObject("strings"), locale);
            _asset_mediator = new DefaultAssetMediator(_asset_manager);
            _ui_builder = new UIBuilder(_asset_mediator, false, null, _localization);
            bgm_player.mute = bgm_muted;
            sfx_player.mute = sfx_muted;
            changeState(0);
        }

        private function onError(error:Error):void
        {
            trace("assets loading failed " + error);
        }

        private function onProgress(ratio:Number):void
        {
            trace("assets loading : " + ratio + "%");
        }

        public function changeState(state:int):void
        {
            if (curent_state != null)
            {
                removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                curent_state.destroy();
                _curent_state = null;
            }

            switch (state)
            {
                case 0:
                    bgm_player.playLoop("game_loop", 0);
                    bgm_player.getSound("game_loop").fadeFrom(0, 1, 3000);
                    _curent_state = new Lobby();

                    break;

                case 1:
                    _curent_state = new Race();

                    break;
            }

            addChild(_curent_state as Sprite);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:EnterFrameEvent):void
        {
            curent_state.update(event.passedTime);
        }
    }
}