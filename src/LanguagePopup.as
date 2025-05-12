package
{
    import starling.display.Sprite;
    import starling.display.Button;
    import starling.events.Event;
    import feathers.controls.LayoutGroup;
    import feathers.core.PopUpManager;
    import starling.events.TouchEvent;
    import starling.events.Touch;
    import starling.events.TouchPhase;

    public class LanguagePopup extends Sprite
    {
        private var _main_sprite:Sprite;
        public var _close_button:Button;
        public var _main_layout:LayoutGroup;
        public function LanguagePopup()
        {
            var ui_object:Object = TurboShift.root.asset_manager.getObject("languages_ui");
            _main_sprite = TurboShift.root.ui_builder.create(ui_object, false, this) as Sprite;
            addChild(_main_sprite);

            _close_button.addEventListener(Event.TRIGGERED, onClose);
            _main_layout.addEventListener(TouchEvent.TOUCH, onTouchLayout);
        }

        private function onClose(event:Event):void
        {
            PopUpManager.removePopUp(this);
            _close_button.removeEventListener(Event.TRIGGERED, onClose);
        }

        private function onTouchLayout(event:TouchEvent):void
        {
            var touch_ended:Touch = event.getTouch(stage, TouchPhase.ENDED);
            var button:Button = event.target as Button;
            if (touch_ended != null)
            {
                trace("button name = " + button.name);
                TurboShift.root.locale = button.name;
                _close_button.dispatchEventWith(Event.TRIGGERED, true);
            }
        }
    }
}