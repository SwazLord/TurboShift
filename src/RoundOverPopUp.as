package
{
    import starling.display.Sprite;
    import starling.display.Button;
    import starling.events.Event;
    import feathers.core.PopUpManager;

    public class RoundOverPopUp extends Sprite
    {
        private var _main_sprite:Sprite;
        public var _play_again_button:Button;
        public var _quit_button:Button;
        public function RoundOverPopUp()
        {
            trace("Roun Over Popup Constructor");
            _main_sprite = new Sprite();
            _main_sprite = Game.current_instance._ui_builder.create(ParsedLayouts.round_over_ui, false, this) as Sprite;
            addChild(_main_sprite);

            _play_again_button.addEventListener(Event.TRIGGERED, onPlayAgain);
            _quit_button.addEventListener(Event.TRIGGERED, onQuit);
        }

        private function onQuit(event:Event):void
        {
            Game.current_instance._sfxPlayer.playFx("button_click");
            (Game.current_instance._current_state as RaceGame).quitRaceGame();
        }

        public function destroy():void
        {
            _main_sprite.removeFromParent(true);
            _main_sprite = null;

            _quit_button.removeEventListener(Event.TRIGGERED, onQuit);
            _play_again_button.removeEventListener(Event.TRIGGERED, onPlayAgain);
        }

        private function onPlayAgain(event:Event):void
        {
            Game.current_instance._sfxPlayer.playFx("button_click");
            (Game.current_instance._current_state as RaceGame).resetRace();
        }
    }
}