package
{
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.textures.Texture;
    import starling.filters.SineWaveFilter;

    public class EnemyCar extends Sprite
    {
        private var _car_image:Image;
        public function EnemyCar()
        {
            _car_image = new Image(getCarTexture());
            addChild(_car_image);
            trace("enemy added");
        }

        public function reset():void
        {
            _car_image.texture = getCarTexture();
            this.filter = null;
        }

        private function getCarTexture():Texture
        {
            return TurboShift.root.asset_manager.getTexture("enemy_car_0" + (Math.floor(Math.random() * 5) + 1));
        }

        public function crashed():void
        {
            this.filter = new SineWaveFilter(10, 30);
        }

        public function destroy():void
        {
            this.filter = null;
            _car_image.removeFromParent(true);
            _car_image = null;
        }
    }
}