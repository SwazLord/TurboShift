package
{
    import feathers.controls.renderers.LayoutGroupListItemRenderer;
    import starling.text.TextField;
    import starling.display.Sprite;
    import starling.utils.Color;

    public class LeaderboardItemRenderer extends LayoutGroupListItemRenderer
    {

        public var _rank_text:TextField;
        public var _name_text:TextField;
        public var _score_text:TextField;
        private var _main_sprite:Sprite;

        override protected function initialize():void
        {
            super.initialize();
            _main_sprite = Game.current_instance._ui_builder.create(ParsedLayouts.leaderboard_item_ui, true, this) as Sprite;
            addChild(_main_sprite);
        }

        override protected function commitData():void
        {
            if (this._data)
            {
                _rank_text.text = this.data.rank;
                _name_text.text = this.data.name;
                _score_text.text = this.data.score;

                if (this.data.name == "YOU")
                {
                    _name_text.format.color = Color.RED;
                    _score_text.format.color = Color.LIME;
                }
                else
                {
                    _name_text.format.color = 0x49f0ff;
                    _score_text.format.color = 0xfffa39;
                }
            }
        }

    }
}