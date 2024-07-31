#version 150

#define BLANK        Armor(vec3(0.0),                        true,  true)
#define HAZMAT_COLOR Armor(vec3(239.0, 193.0, 66.0) / 255.0, false, false)

#define ARMOR_TYPES      Armor[] (BLANK, HAZMAT_COLOR)
#define ARMOR_TYPE_COUNT ARMOR_TYPES.length()

struct Armor {
    vec3 color;
    bool tintVertex;
    bool tintDiffuse;
};
