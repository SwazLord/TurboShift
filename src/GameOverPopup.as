package
{
    import starling.display.Sprite;
    import starling.display.Button;
    import starling.events.Event;
    import starling.text.TextField;

    public class GameOverPopup extends Sprite
    {
        private var _main_sprite:Sprite;
        public var _play_again_button:Button;
        public var _quit_button:Button;
        public var _player_score_text:TextField;
        public function GameOverPopup(score:uint)
        {
            var ui_object:Object = TurboShift.root.asset_manager.getObject("round_over_ui");
            _main_sprite = TurboShift.root.ui_builder.create(ui_object, false, this) as Sprite;
            addChild(_main_sprite);

            _play_again_button.addEventListener(Event.TRIGGERED, onPlayAgain);
            _quit_button.addEventListener(Event.TRIGGERED, onQuit);

            _player_score_text.text = score.toString();
        }

        private function onPlayAgain(event:Event):void
        {
            TurboShift.root.sfx_player.playFx("button_click");
            (TurboShift.root.curent_state as Race).resetRace();
        }

        private function onQuit(event:Event):void
        {
            TurboShift.root.sfx_player.playFx("button_click");
            (TurboShift.root.curent_state as Race).quitRace();
        }
    }
}