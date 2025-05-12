package
{
    import starling.display.Sprite;
    import starling.filters.SineWaveFilter;
    import starlingbuilder.engine.ICustomComponent;
    import starling.display.Image;
    import starling.core.Starling;

    public class PlayerCar extends Sprite implements ICustomComponent
    {
        private var _damaged_filter:SineWaveFilter;
        private var _blazing_fire:BlazingFire;
        private var player_car:Image;
        public function PlayerCar();

        public function initComponent():void
        {
            player_car = getChildByName("player_car") as Image;
            _damaged_filter = player_car.filter as SineWaveFilter;
            player_car.filter = null;
        }

        public function reset():void
        {
            this.rotation = 0;
            player_car.filter = null;
            removeBlazingFire();
        }

        public function crashed():void
        {
            player_car.filter = _damaged_filter;
            Starling.juggler.delayCall(addBlazingFire, 1);
        }

        private function addBlazingFire():void
        {
            _blazing_fire = new BlazingFire();
            addChild(_blazing_fire);
            _blazing_fire.x = 50;
        }

        private function removeBlazingFire():void
        {
            _blazing_fire.destroy();
            _blazing_fire.removeFromParent(true);
            _blazing_fire = null;
        }

        public function destroy():void
        {
            removeBlazingFire();
            _damaged_filter = null;
            player_car.filter = null;

        }
    }
}