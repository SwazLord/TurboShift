package
{
    import starling.display.Sprite;
    import feathers.controls.LayoutGroup;
    import starling.display.Image;
    import starling.display.MovieClip;
    import feathers.controls.ImageLoader;
    import starling.display.Button;
    import starling.events.Event;
    import feathers.core.PopUpManager;
    import feathers.layout.AnchorLayout;
    import feathers.layout.HorizontalLayout;
    import starling.core.Starling;
    import starling.animation.DelayedCall;
    import starling.animation.Transitions;
    import feathers.motion.Wipe;
    import feathers.motion.Iris;
    import feathers.motion.Fade;

    public class InfoPopup extends Sprite
    {
        private var _main_sprite:Sprite;
        public var _main_layout:LayoutGroup;
        public var _air_icon:Image;
        public var _bird_mc:MovieClip;
        public var _feathers_img_loader:ImageLoader;
        public var _awesome_button:Button;
        private var air_rotate_animation:DelayedCall;
        public static const linkers:Array = [AnchorLayout, HorizontalLayout];
        public function InfoPopup()
        {
            _main_sprite = new Sprite();
            _main_sprite = Game.current_instance._ui_builder.create(ParsedLayouts.info_popup_ui, false, this) as Sprite;
            addChild(_main_sprite);

            _feathers_img_loader.showEffect = Iris.createIrisOpenEffect();
            _feathers_img_loader.hideEffect = Iris.createIrisCloseEffect();

            _feathers_img_loader.addEventListener(Event.COMPLETE, loader_completeHandler);

            _awesome_button.addEventListener(Event.TRIGGERED, onAwesomeButtonTrigger);

            air_rotate_animation = new DelayedCall(animate, 1);
            air_rotate_animation.repeatCount = 0;
        }

        private function animate():void
        {
            _feathers_img_loader.visible = !_feathers_img_loader.visible;

            Starling.juggler.tween(_air_icon, 1, {
                        rotation: _air_icon.rotation += 1,
                        transition: Transitions.EASE_IN_OUT_BACK
                    });
        }

        private function onAwesomeButtonTrigger(event:Event):void
        {
            _awesome_button.removeEventListener(Event.TRIGGERED, onAwesomeButtonTrigger);
            _main_sprite.removeFromParent(true);
            _main_sprite = null;

            PopUpManager.removePopUp(this, true);
        }

        private function loader_completeHandler(event:Event):void
        {
            _feathers_img_loader.removeEventListener(Event.COMPLETE, loader_completeHandler);

            _feathers_img_loader.validate();

            _main_layout.validate();

            Starling.juggler.add(air_rotate_animation);
            Starling.juggler.add(_bird_mc);

        }
    }
}