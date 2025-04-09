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
            _main_sprite = new Sprite();
            _main_sprite = Game.current_instance._ui_builder.create(ParsedLayouts.road_ui, false, this) as Sprite;
            _road_2.y = -960;
            addChild(_main_sprite);
        }

        public function update(speed:Number):void
        {
            _road_1.y += speed * _road_1.height / 20;
            _road_2.y += speed * _road_1.height / 20;
            if (_road_1.y >= _road_1.height)
            {
                _road_1.y = -_road_1.height;
            }

            if (_road_2.y >= _road_1.height)
            {
                _road_2.y = -_road_1.height;
            }
        }

        public function destroy():void
        {
            _road_1.removeFromParent(true);
            _road_1 = null;

            _road_2.removeFromParent(true);
            _road_2 = null;

            _main_sprite.removeFromParent(true);
            _main_sprite = null;
        }

    }
}