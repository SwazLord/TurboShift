package
{
    import starling.display.Sprite;
    import starling.display.Button;
    import starling.events.Event;
    import feathers.core.PopUpManager;
    import feathers.layout.AnchorLayout;
    import feathers.layout.VerticalLayout;
    import feathers.controls.LayoutGroup;
    import starling.events.TouchEvent;
    import starling.events.Touch;
    import starling.events.TouchPhase;

    public class LanguagePopup extends Sprite
    {
        private var _main_sprite:Sprite;
        public var _close_button:Button;
        public var _main_layout:LayoutGroup;
        public static const linkers:Array = [AnchorLayout, VerticalLayout];
        public function LanguagePopup()
        {
            _main_sprite = new Sprite();
            _main_sprite = Game.current_instance._ui_builder.create(ParsedLayouts.language_popup_ui, false, this) as Sprite;
            addChild(_main_sprite);

            _close_button.addEventListener(Event.TRIGGERED, onClose);
            _main_layout.addEventListener(TouchEvent.TOUCH, onTouch);
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch_ended:Touch = event.getTouch(stage, TouchPhase.ENDED);
            var button:Button = event.target as Button;
            if (touch_ended != null && button)
            {
                trace("button.name = ", button.name);
                Game.current_instance.locale = button.name;
                _close_button.dispatchEventWith(Event.TRIGGERED, true);
            }
        }

        private function onClose(event:Event):void
        {
            _close_button.removeEventListener(Event.TRIGGERED, onClose);
            PopUpManager.removePopUp(this, true);
        }

        public function destroy():void
        {
            _main_sprite.removeFromParent(true);
            _main_sprite = null;

        }
    }
}