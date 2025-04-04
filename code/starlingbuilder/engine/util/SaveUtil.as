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
package starlingbuilder.engine.util
{
    /**
     * @private
     */
    public class SaveUtil
    {
        public static function willSave(object:Object, param:Object, item:Object):Boolean
        {
            if (object.hasOwnProperty("text") && param.name == "text" && item && item.customParams && item.customParams.localizeKey)
            {
                return false;
            }

            if (param.name == "width" && object.hasOwnProperty("explicitWidth") && isNaN(object.explicitWidth))
            {
                return false;
            }

            if (param.name == "height" && object.hasOwnProperty("explicitHeight") && isNaN(object.explicitHeight))
            {
                return false;
            }

            return true;
        }
    }
}
