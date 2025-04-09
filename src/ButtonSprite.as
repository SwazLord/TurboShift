package
{
    import starling.display.Sprite;
    import starlingbuilder.engine.ICustomComponent;
    import starling.display.Image;

    public class ButtonSprite extends Sprite implements ICustomComponent
    {
        private var ban_icon:Image;
        private var _disabled:Boolean;

        public function initComponent():void
        {
            this.touchGroup = true;
            ban_icon = getChildByName("ban_icon") as Image;
            ban_icon.visible = disabled;
        }

        public function get disabled():Boolean
        {
            return _disabled;
        }

        public function set disabled(value:Boolean):void
        {

            ban_icon.visible = _disabled = value;
        }
    }
}