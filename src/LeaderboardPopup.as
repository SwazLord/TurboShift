package
{
    import starling.display.Sprite;
    import starling.display.Button;
    import starling.events.Event;
    import feathers.core.PopUpManager;
    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ArrayCollection;

    public class LeaderboardPopup extends Sprite
    {
        private var _main_sprite:Sprite;
        public var _close_button:Button;
        public var _list:List;
        private var _leaderboard:Array = [
                {name: "JACK", score: 500},
                {name: "MAX", score: 450},
                {name: "ADAM", score: 390},
                {name: "BILL", score: 420},
                {name: "SAM", score: 350},
                {name: "TIM", score: 250},
                {name: "BEN", score: 120},
                {name: "PAT", score: 90},
                {name: "JEFF", score: 50},
                {name: "PEG", score: 40}
            ];
        public function LeaderboardPopup()
        {
            var ui_object:Object = TurboShift.root.asset_manager.getObject("leaderboard_ui");
            _main_sprite = TurboShift.root.ui_builder.create(ui_object, false, this) as Sprite;
            addChild(_main_sprite);

            _close_button.addEventListener(Event.TRIGGERED, onClose);

            _list.itemRendererFactory = function():IListItemRenderer
            {
                return new LeaderboardItemRenderer();
            };

            _list.dataProvider = new ArrayCollection();

            _leaderboard.push({name: "YOU", score: TurboShift.root.best_score});

            // Sort the array by score in descending order
            _leaderboard.sort(function(a:Object, b:Object):int
                {
                    if (a.score > b.score)
                        return -1;
                    if (a.score < b.score)
                        return 1;
                    return 0;
                });

            var len:uint = _leaderboard.length;
            for (var i:int = 0; i < len; i++)
            {
                var player:Object = _leaderboard[i];
                _list.dataProvider.addItem({
                            rank: i + 1,
                            name: player.name,
                            score: player.score
                        });
            }
        }

        private function onClose(event:Event):void
        {
            TurboShift.root.sfx_player.playFx("button_click");
            _close_button.removeEventListener(Event.TRIGGERED, onClose);
            PopUpManager.removePopUp(this);
        }
    }
}