import json
import sys
import csv

tr_name_base = ""
translations_data = {
    "en": {},
    "pl": {},
}
translations_cache = {}
map_files_cache = {}

campaign_folder = sys.argv[1]

translations_folder = "assets/translations/"
if len(sys.argv) > 2:
    translations_folder = sys.argv[2]


def add_translation(key, message):
    key = tr_name_base + key
    translations_data["en"][key] = message
    translations_data["pl"][key] = message
    translations_cache[message] = key

    return key


# Load core translations into cache
print("Loading cache from " + translations_folder)
core_files = ["core", "common"]
for filename in core_files:
    with open(translations_folder + filename + ".en.csv") as csvfile:
        csvreader = csv.reader(csvfile)
        for row in csvreader:
            if row[0] == "keys":
                continue
            translations_cache[row[1]] = row[0]
    csvfile.close()


# Process campaign manifest
with open(campaign_folder + "campaign.json", "r") as manifest:
    md = json.load(manifest)
    tr_name_base = "tr_" + md["name"] + "_"
manifest.close()

print("Processing " + md["title"])
md["title"] = add_translation("campaign_title", md["title"])

mn = 0
an = 1
for mission_data in md["missions"]:
    md["missions"][mn]["title"] = add_translation("m" + str(mn+1) + "_name", mission_data["title"])
    md["missions"][mn]["description"] = add_translation("m" + str(mn+1) + "_desc", mission_data["description"])

    # Process mission data
    print("Processing " + campaign_folder + "maps/" + mission_data["map"])
    with open(campaign_folder + "maps/" + mission_data["map"], "r") as map_data:
        mapd = json.load(map_data)
    map_data.close()

    tn = 1
    on = 1
    for story in mapd["scripts"]["stories"]:
        sn = 0
        for step in mapd["scripts"]["stories"][story]:
            if step["action"] == "message":
                if step["details"]["name"] != "???":
                    if step["details"]["name"] in translations_cache:
                        mapd["scripts"]["stories"][story][sn]["details"]["name"] = translations_cache[step["details"]["name"]]
                    else:
                        mapd["scripts"]["stories"][story][sn]["details"]["name"] = add_translation("a" + str(an), step["details"]["name"])
                        an += 1

                if step["details"]["text"] in translations_cache:
                    mapd["scripts"]["stories"][story][sn]["details"]["text"] = translations_cache[step["details"]["text"]]
                else:
                    mapd["scripts"]["stories"][story][sn]["details"]["text"] = add_translation("m" + str(mn+1) + "_t" + str(tn), step["details"]["text"])
                    tn += 1

            if step["action"] == "objective" and "text" in step["details"]:
                if step["details"]["text"] in translations_cache:
                    mapd["scripts"]["stories"][story][sn]["details"]["text"] = translations_cache[step["details"]["text"]]
                else:
                    mapd["scripts"]["stories"][story][sn]["details"]["text"] = add_translation("m" + str(mn+1) + "_o" + str(on), step["details"]["text"])
                    on += 1
            sn += 1

    map_files_cache[campaign_folder + "maps/" + mission_data["map"]] = mapd
    mn += 1



# Dump modified files
fp = open(campaign_folder + "translations.json", "w")
json.dump(translations_data, fp, indent=4)

fp = open(campaign_folder + "campaign.json", "w")
json.dump(md, fp, indent=4)

for map_path in map_files_cache:
    fp = open(map_path, "w")
    json.dump(map_files_cache[map_path], fp, indent=4)
