import os

directory = 'C:/Users/mrjs/Documents/godot_projects/ptbasedgame/cleanup_import/GLB'
# iterate over files in
# that directory
for filename in os.listdir(directory):
    f = os.path.join(directory, filename)
    # checking if it is a file
    if os.path.isfile(f):
        if f.endswith("glb.import"):
            file = open(f)
            lines = []
            for line in file.readlines():

                if line.startswith("import_script"):
                    line = 'import_script/path="uid://dlsbfb0agyfwi"\n'
                lines.append(line)
            
            file = open(f, "w")
            file.writelines(lines)
