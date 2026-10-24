namespace PCLCS;

public static class MinecraftOwnership {
    public static bool HasJavaEntitlement(JObject response) {
        return response["items"]!.Any(item => item.Value<string>("name") is "game_minecraft" or "product_minecraft");
    }
}
