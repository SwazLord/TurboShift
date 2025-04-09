package
{
    public class EmbeddedLayouts
    {
        [Embed(source="/../assets/layouts/lobby_ui.json", mimeType="application/octet-stream")]
        public static const lobby_ui:Class;

        [Embed(source="/../assets/layouts/race_game_ui.json", mimeType="application/octet-stream")]
        public static const race_game_ui:Class;

        [Embed(source="/../assets/layouts/road_ui.json", mimeType="application/octet-stream")]
        public static const road_ui:Class;

        [Embed(source="/../assets/layouts/round_over_ui.json", mimeType="application/octet-stream")]
        public static const round_over_ui:Class;

        [Embed(source="/../assets/layouts/info_popup_ui.json", mimeType="application/octet-stream")]
        public static const info_popup_ui:Class;

        [Embed(source="/../assets/layouts/leaderboard_popup_ui.json", mimeType="application/octet-stream")]
        public static const leaderboard_popup_ui:Class;

        [Embed(source="/../assets/layouts/leaderboard_item_ui.json", mimeType="application/octet-stream")]
        public static const leaderboard_item_ui:Class;

        [Embed(source="/../assets/layouts/language_popup_ui.json", mimeType="application/octet-stream")]
        public static const language_popup_ui:Class;
    }
}