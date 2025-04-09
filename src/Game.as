package
{
    import starling.display.Sprite;
    import starling.assets.AssetManager;
    import starlingbuilder.engine.UIBuilder;
    import starlingbuilder.engine.DefaultAssetMediator;
    import feathers.controls.LayoutGroup;
    import starling.display.Image;
    import feathers.layout.AnchorLayout;
    import starlingbuilder.engine.LayoutLoader;
    import flash.net.SharedObject;
    import treefortress.sound.SoundManager;
    import starlingbuilder.engine.localization.ILocalization;
    import flash.system.Capabilities;
    import starlingbuilder.engine.localization.DefaultLocalization;

    public class Game extends Sprite
    {
        public var _asst_manager:AssetManager;
        public var _ui_builder:UIBuilder;
        private var _asst_mediator:DefaultAssetMediator;
        public static const linkers:Array = [LayoutGroup, Image, AnchorLayout];
        public var _current_state:iState;
        public static var current_instance:Game;
        private var _layout_loader:LayoutLoader;
        private var _sharedObject:SharedObject;
        private var _topScore:uint;
        public var _bgmPlayer:SoundManager = new SoundManager();
        public var _sfxPlayer:SoundManager = new SoundManager();
        private var _bgm_muted:Boolean;
        private var _sfx_muted:Boolean;
        private var _localization:ILocalization;
        private var _locale:String;
        private const SUPPORTED_LOCALES:Array = ["en", "fr", "de"];
        public function Game()
        {
            trace("game class contructor");
            _sharedObject = SharedObject.getLocal("turbo-shift-data");
            current_instance = this;
            Animations.registerTransitions();
        }

        public function startGame():void
        {
            trace("start Game");
            _asst_manager = new AssetManager();
            _asst_manager.enqueue([
                        "assets/textures/texture.png",
                        "assets/textures/texture.xml",
                        "assets/textures/lilita_one.fnt",
                        "assets/backgrounds/road_tile.png",
                        "assets/particles/bigExplosion.sde",
                        "assets/particles/blazingFire.sde",
                        "assets/particles/pinkSmoke.sde",
                        "assets/localization/strings.json"
                    ]);
            _asst_manager.loadQueue(onComplete, onError, onProgress);

            _bgmPlayer.loadSound("assets/sounds/game_loop.mp3", "game_loop");
            _sfxPlayer.loadSound("assets/sounds/button_click.mp3", "button_click");
        }

        private function onComplete():void
        {
            trace("ASSET LOADED");
            _localization = new DefaultLocalization(_asst_manager.getObject("strings"), locale);
            _layout_loader = new LayoutLoader(EmbeddedLayouts, ParsedLayouts);
            _asst_mediator = new DefaultAssetMediator(_asst_manager);
            _ui_builder = new UIBuilder(_asst_mediator, false, null, _localization);
            _bgmPlayer.mute = bgm_muted;
            _sfxPlayer.mute = sfx_muted;
            changeState(0);
        }

        private function onError(error:String):void
        {
            trace("ERROR : " + error);
        }

        private function onProgress(ratio:Number):void
        {
            trace("PROGRESS : " + ratio);
        }

        public function changeState(state:uint):void
        {
            if (_current_state != null)
            {
                _current_state.destroy();
                _current_state = null;
            }

            switch (state)
            {
                case 0:
                    _bgmPlayer.playLoop("game_loop", 0);
                    _bgmPlayer.getSound("game_loop").fadeFrom(0, 1, 3000);
                    _current_state = new Lobby();
                    break;
                case 1:
                    _current_state = new RaceGame();
                    break;
            }

            addChild(_current_state as Sprite);

        }

        public function get topScore():uint
        {
            if (_sharedObject.data.topScore == null)
            {
                return 0;
            }
            else
            {
                return int(_sharedObject.data.topScore);
            }
        }

        public function set topScore(value:uint):void
        {
            _sharedObject.setProperty("topScore", value);
            _sharedObject.flush();
        }

        public function get bgm_muted():Boolean
        {
            if (_sharedObject.data.bgm_muted == null)
            {
                return false;
            }
            else
            {
                return _sharedObject.data.bgm_muted;
            }
        }

        public function set bgm_muted(value:Boolean):void
        {
            _bgmPlayer.mute = value;
            _sharedObject.setProperty("bgm_muted", value);
            _sharedObject.flush();
        }

        public function get sfx_muted():Boolean
        {
            if (_sharedObject.data.sfx_muted == null)
            {
                return false;
            }
            else
            {
                return _sharedObject.data.sfx_muted;
            }
        }

        public function set sfx_muted(value:Boolean):void
        {
            _sfxPlayer.mute = value;
            _sharedObject.setProperty("sfx_muted", value);
            _sharedObject.flush();
        }

        public function get locale():String
        {
            if (SUPPORTED_LOCALES.indexOf(Capabilities.language) != -1)
            {
                return Capabilities.language; // return set device language
            }
            else
            {
                return "en"; // return english
            }
        }

        public function set locale(value:String):void
        {

            _localization.locale = _locale = value;
            _current_state.update();
        }
    }
}