#version 150

#define BLANK        Armor(vec3(0),                  true,  true)
#define HAZMAT_COLOR Armor(vec3(239, 193, 66) / 255, false, false)

#define ARMOR_TYPES Armor[] (BLANK, HAZMAT_COLOR)
#define TYPE_COUNT  ARMOR_TYPES.length()
#define N           (1. / TYPE_COUNT)

struct Armor {
    vec3 color;
    bool tintVertex;
    bool tintDiffuse;
};
