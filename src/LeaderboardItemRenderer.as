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
            var ui_object:Object = TurboShift.root.asset_manager.getObject("leaderboard_item_ui");
            _main_sprite = TurboShift.root.ui_builder.create(ui_object, true, this) as Sprite;
            addChild(_main_sprite);
        }

        override protected function commitData():void
        {
            if (this.data != null)
            {
                _rank_text.text = this.data.rank;
                _name_text.text = this.data.name;
                _score_text.text = this.data.score;

                if (this.data.name == "YOU")
                {
                    _name_text.text = TurboShift.root.ui_builder.localization.getLocalizedText("text_15");
                    _name_text.format.color = Color.RED;
                    _score_text.format.color = Color.LIME;
                }
                else
                {
                    _name_text.format.color = 0x49f0fc;
                    _score_text.format.color = 0xfff902;
                }
            }
        }
    }
}