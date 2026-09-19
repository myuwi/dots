import definePlugin from "@utils/types";

export default definePlugin({
    name: "SquareNotificationAvatars",
    description: "Show full square avatars in desktop notifications instead of circle-cropped ones",
    authors: [{ name: "myuwi", id: 0n }],
    patches: [{
        find: "isUserAvatar&&null!=",
        replacement: {
            match: /isUserAvatar(?=&&null!=\i&&\(\i=await)/,
            replace: "false"
        }
    }]
});
