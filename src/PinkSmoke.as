package
{
    import starling.display.Sprite;

    import com.funkypandagame.stardustplayer.SimLoader;
    import com.funkypandagame.stardustplayer.SimPlayer;

    import flash.events.Event;

    import com.funkypandagame.stardustplayer.project.ProjectValueObject;

    import starling.events.EnterFrameEvent;

    public class PinkSmoke extends Sprite
    {
        private var simContainer:Sprite;
        private var player:SimPlayer;
        private var loader:SimLoader;
        private var project:ProjectValueObject;

        public function PinkSmoke()
        {
            simContainer = new Sprite();
            simContainer.touchable = false;
            addChild(simContainer);

            player = new SimPlayer();
            loader = new SimLoader();
            loader.addEventListener(flash.events.Event.COMPLETE, onSimLoaded);
            loader.loadSim(Game.current_instance._asst_manager.getByteArray("pinkSmoke"));
        }

        private function onSimLoaded(event:Event):void
        {
            loader.removeEventListener(flash.events.Event.COMPLETE, onSimLoaded);
            project = loader.createProjectInstance();
            player.setProject(project);
            player.setRenderTarget(simContainer);

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            project.resetSimulation();

        }

        private function onEnterFrame(event:EnterFrameEvent):void
        {
            player.stepSimulation(event.passedTime);
        }

        public function destroy():void
        {
            removeEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
            player = null;
            project.destroy();
            project = null;
            loader.dispose();
            loader = null;
            simContainer.removeFromParent(true);
            simContainer = null;
            this.removeFromParent(true);
        }
    }
}