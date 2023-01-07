import sys
import random

flower_types = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "g_1",
    "g_2",
    "g_3",
    "g_4",
    "g_5",
    "g_6",
    "g_7",
    "g_8",
    "g_9"
]
placement_limit = 30

output_file = sys.argv[1]

flowers_variety = random.randint(1, 4)
if len(sys.argv) > 2:
    flowers_variety = int(sys.argv[2])

flowers_count = random.randint(5, 15)
if len(sys.argv) > 3:
    flowers_count = int(sys.argv[3])

print("Generating " + output_file)
print("Will generate " + str(flowers_count) + " flowers using " + str(flowers_variety) + " types")

# Select which flower types will be used
selected_flower_types = random.sample(flower_types, flowers_variety)


# Generate flowers spread
spread = []
for fi in range(flowers_count):
    position = (random.randint(-placement_limit, placement_limit), random.randint(-placement_limit, placement_limit))
    ftype = random.randint(0, flowers_variety-1)

    spread.append((position, ftype))

# Serialise this into a file
fp = open(output_file, "w")

fp.write("[gd_scene load_steps=" + str(flowers_variety+2) + " format=2]\n")
fp.write("\n")
fp.write('[ext_resource path="res://scenes/tiles/tile.tscn" type="PackedScene" id=2]\n')

for vi in range(flowers_variety):
    fp.write('[ext_resource path="res://assets/terrain/grasslands/plants_small/flower_' + selected_flower_types[vi] + '.tscn" type="PackedScene" id=' + str(3+vi) + ']\n')

fp.write("\n")
fp.write('[node name="flowers" instance=ExtResource( 2 )]\n')
fp.write('main_tile_view_cam_modifier = -10\n')
fp.write('side_tile_view_cam_modifier = -25\n')
fp.write("\n")
fp.write('[node name="mesh" parent="." index="0"]\n')
fp.write('cast_shadow = 0\n')
fp.write("\n")

for pi in range(flowers_count):
    fp.write('[node name="flower_' + selected_flower_types[spread[pi][1]] + '_' + str(pi+1) + '" parent="mesh" index="0" instance=ExtResource( ' + str(3+spread[pi][1]) + ' )]\n')
    fp.write('transform = Transform( 1, 0, 0, 0, 1, 0, 0, 0, 1, ' + str(spread[pi][0][0]/10.0) + ', 0, ' + str(spread[pi][0][1]/10.0) + ' )\n')

fp.close()
