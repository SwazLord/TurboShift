package
{
    import starling.display.Sprite;
    import starling.display.Image;
    import starlingbuilder.engine.ICustomComponent;

    public class ButtonSprite extends Sprite implements ICustomComponent
    {
        private var _ban_icon:Image;
        private var _disabled:Boolean;

        public function get disabled():Boolean
        {
            return _disabled;
        }

        public function set disabled(value:Boolean):void
        {
            _ban_icon.visible = _disabled = value;
        }
    

        public function initComponent():void
        {
        	this.touchGroup = true;
            _ban_icon = getChildByName("ban_icon") as Image;
        }
    }
}