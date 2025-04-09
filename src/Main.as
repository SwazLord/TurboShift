package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import starling.core.Starling;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display.StageDisplayState;
    import starling.utils.Color;
    import starling.events.Event;
    import flash.geom.Rectangle;
    import starlingbuilder.engine.util.StageUtil;
    import flash.geom.Point;

    [SWF(width="640", height="960", frameRate="60", backgroundColor="#000000")]
    public class Main extends Sprite
    {
        private var _starling:Starling;
        private var _stage_util:StageUtil;
        private var _root_class:Game;
        public function Main()
        {
            addEventListener(flash.events.Event.ADDED_TO_STAGE, addedToStage);
            stage.align = StageAlign.LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.displayState = StageDisplayState.NORMAL;
            stage.color = Color.BLACK;
        }

        private function addedToStage(event:flash.events.Event):void
        {
            removeEventListener(flash.events.Event.ADDED_TO_STAGE, addedToStage);
            trace("added to stage");
            _starling = new Starling(Game, stage, null, null, "auto", ["baselineExtended", "baseline"]);
            _starling.stage3D.addEventListener(starling.events.Event.CONTEXT3D_CREATE, startStarling);
            _starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
        }

        private function startStarling(event:flash.events.Event):void
        {
            _starling.stage3D.removeEventListener(starling.events.Event.CONTEXT3D_CREATE, startStarling);
            _starling.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            _stage_util = new StageUtil(stage);
            var size:Point = _stage_util.getScaledStageSize(_stage_util.stageWidth, _stage_util.stageHeight);
            _starling.stage.stageWidth = size.x;
            _starling.stage.stageHeight = size.y;
            _starling.supportHighResolutions = true;
            _starling.antiAliasing = 1;
            _starling.showStats = true;
            _starling.start();

        }

        private function onRootCreated(event:starling.events.Event, root:Game):void
        {
            _starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
            trace("root created");
            _root_class = root;
            _root_class.startGame();
        }
    }
}