package
{
    import starling.display.Sprite;
    import com.funkypandagame.stardustplayer.SimPlayer;
    import com.funkypandagame.stardustplayer.SimLoader;
    import com.funkypandagame.stardustplayer.project.ProjectValueObject;
    import flash.events.Event;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;

    public class BigExplosion extends Sprite
    {
        private var simContainer:Sprite;
        private var player:SimPlayer;
        private var loader:SimLoader;
        private var project:ProjectValueObject;
        public function BigExplosion()
        {
            simContainer = new Sprite();
            simContainer.touchable = false;
            addChild(simContainer);

            loader = new SimLoader();
            loader.addEventListener(flash.events.Event.COMPLETE, onSimLoaded);
            loader.loadSim(Game.current_instance._asst_manager.getByteArray("bigExplosion"));

            player = new SimPlayer();
        }

        private function onSimLoaded(event:Object):void
        {
            loader.removeEventListener(flash.events.Event.COMPLETE, onSimLoaded);
            project = loader.createProjectInstance();
            player.setProject(project);
            player.setRenderTarget(simContainer);
        }

        public function play():void
        {
            addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
            project.resetSimulation();

        }

        private function onEnterFrame(event:EnterFrameEvent):void
        {
            player.stepSimulation(event.passedTime);
            if (project.numberOfParticles == 0)
            {
                removeEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);

            }
        }

        public function destroy():void
        {
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