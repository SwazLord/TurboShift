package
{
    import starling.animation.Transitions;

    public class Animations
    {
        public static const JUMP:String = "jump";
        public static const SHAKE_3X:String = "shake3x";

        public function Animations()
        {
        }

        // call this in the project's startup code
        public static function registerTransitions():void
        {
            Transitions.register(JUMP, jump);
            Transitions.register(SHAKE_3X, shake3x);
        }

        private static function jump(ratio:Number):Number
        {
            return Math.sin(ratio * Math.PI);
        }

        private static function shake3x(ratio:Number):Number
        {
            return Math.sin(ratio * Math.PI * 3);
        }
    }
}