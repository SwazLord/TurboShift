/**
 *  Starling Builder
 *  Copyright
 *  2015-2016 SGN Inc.
 *  2016-2017 Johann Huang
 *  All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine
{
    import flash.utils.Dictionary;

    import starling.display.DisplayObject;

    /**
     * Interface of callback when the display object is created in UIBuilder.
     * It's called internally by UIBuilder.load() or UIBuilder.create().
     *
     * @see starlingbuilder.engine.UIBuilder
     */
    public interface IDisplayObjectHandler
    {
        function onCreate(obj:DisplayObject, paramsDict:Dictionary):void
    }
}
