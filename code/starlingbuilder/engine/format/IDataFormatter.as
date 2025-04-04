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
package starlingbuilder.engine.format
{
    /**
     * @private
     */
    public interface IDataFormatter
    {
        function read(data:Object):Object;
        function write(data:Object):Object;

        function get prettyData():Boolean;
        function set prettyData(value:Boolean):void;
    }
}
