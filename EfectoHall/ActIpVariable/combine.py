import os
files = [x.replace(".csv", "") for x in os.listdir() if "germanio" in x and ".csv" in x]
print(files)
content = []
for file in files:
    identifiers = file.split("-")
    tipo = identifiers[1]
    num = identifiers[2].replace("_", "")
    with open(f"{file}.csv", "r") as file:
        content += [f"{x.replace("\n", "")},0.0{num}, Germanio {tipo}\n" for x in file.readlines()[1:]]
print("".join(content))
