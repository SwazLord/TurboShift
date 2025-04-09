package
{
    import starling.display.Sprite;
    import starlingbuilder.engine.ICustomComponent;
    import starling.display.Image;
    import starling.core.Starling;
    import starling.filters.SineWaveFilter;

    public class PlayerCar extends Sprite implements ICustomComponent
    {
        private var car_image:Image;
        private var blazing_fire:BlazingFire;
        private var damaged_filter:SineWaveFilter;

        public function initComponent():void
        {
            car_image = getChildByName("player_car") as Image;
            damaged_filter = car_image.filter as SineWaveFilter;
            car_image.filter = null;
        }

        public function reset():void
        {
            this.rotation = 0;

            car_image.filter = null;

            if (blazing_fire)
            {
                blazing_fire.destroy();
                blazing_fire.removeFromParent(true);
                blazing_fire = null;
            }
        }

        public function crashed():void
        {
            car_image.filter = damaged_filter;

            Starling.juggler.delayCall(function():void
                {
                    blazing_fire = new BlazingFire();
                    addChild(blazing_fire);
                    blazing_fire.x = 50;
                }, 1);
        }

        public function destroy():void
        {
            blazing_fire.destroy();
            blazing_fire.removeFromParent(true);
            blazing_fire = null;

            car_image.filter = null;
            damaged_filter = null;
        }
    }
}