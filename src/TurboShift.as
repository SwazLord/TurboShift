package
{
    import flash.display.Sprite;
    import starling.core.Starling;
    import starling.events.Event;
    import starling.events.ResizeEvent;
    import starling.utils.RectangleUtil;
    import flash.geom.Rectangle;
    import starling.utils.ScaleMode;
    [SWF(width="640", height="960", frameRate="60", backgroundColor="#009934")]
    public class TurboShift extends Sprite
    {
        private var _starling:Starling;
        private static var _root:Game;

        public static function get root():Game
        {
            return _root;
        }
        public function TurboShift()
        {
            trace("Hello Turbo Shift");
            _starling = new Starling(Game, stage);
            _starling.addEventListener(Event.ROOT_CREATED, onRootCreated);
            // _starling.showStats = true;
            _starling.supportHighResolutions = true;
            _starling.start();
            _starling.stage.addEventListener(Event.RESIZE, onStageResize);
        }

        private function onRootCreated(event:Event, root_instance:Game):void
        {
            _starling.removeEventListener(Event.ROOT_CREATED, onRootCreated);
            _root = root_instance;
        }

        private function onStageResize(event:ResizeEvent):void
        {
            _starling.viewPort = RectangleUtil.fit(
                    new Rectangle(0, 0, 640, 960),
                    new Rectangle(0, 0, event.width, event.height)
                );
        }
    }
}