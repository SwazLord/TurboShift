package
{
    import starling.display.MovieClip;
    import starling.filters.SineWaveFilter;

    public class EnemyCar extends MovieClip
    {
        public function EnemyCar()
        {
            super(Game.current_instance._asst_manager.getTextures("enemy_car_"), 1);
        }

        public function reset():void
        {
            currentFrame = Math.floor(Math.random() * 5);
            this.filter = null;
        }

        public function crashed():void
        {
            this.filter = new SineWaveFilter(10, 30);
        }
    }
}