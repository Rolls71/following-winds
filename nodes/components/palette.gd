class_name Palette extends Resource

static var ocean_water: Color = Color.from_rgba8(0, 19, 52)
static var coastal_water: Color = Color.from_rgba8(16, 84, 83)
static var sand: Color = Color.from_rgba8(255, 251, 147)
static var grass: Color = Color.from_rgba8(130, 152, 25)
static var mountain: Color = Color.from_rgba8(165, 161, 123)

static var elevations_to_colour = [ocean_water, coastal_water, sand, grass, mountain]


static var gradients_to_colour = [Color.WHITE, Color(0.9, 0.9, 0.9), Color(0.8,0.8,0.8)]
