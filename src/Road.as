package
{
    import starling.display.Sprite;
    import starling.display.Image;

    public class Road extends Sprite
    {
        private var _main_sprite:Sprite;
        public var _road_1:Image;
        public var _road_2:Image;
        public function Road()
        {
            var ui_object:Object = TurboShift.root.asset_manager.getObject("road_ui");
            _main_sprite = TurboShift.root.ui_builder.create(ui_object, false, this) as Sprite;
            addChild(_main_sprite);
            _road_2.y = -960;
        }

        public function update(speed:Number):void
        {
            _road_1.y += speed * _road_1.height / 20;
            _road_2.y += speed * _road_1.height / 20;

            if (_road_1.y >= _road_1.height)
            {
                _road_1.y = -_road_1.height;
            }

            if (_road_2.y >= _road_2.height)
            {
                _road_2.y = -_road_1.height;
            }
        }

        public function destroy():void
        {
            _main_sprite.removeFromParent(true);
            _main_sprite = null;
        }
    }
}