#version 150

#define HAND_ALPHA 254 / 255.0
#define GUI_ALPHA  253 / 255.0

bool is_hand(
        float alpha,
        float z
) {
    return alpha == HAND_ALPHA && z > 100.0;
}

bool is_gui(
        float alpha,
        float z
) {
    return alpha == GUI_ALPHA && z < 100.0;
}
