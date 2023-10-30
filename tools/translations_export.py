"""Translations export script."""

import json
import csv
from os import listdir
from os.path import isdir, join

campaigns_folder = "assets/campaigns/"
translations_folder = "assets/translations/"
desitnation_folder = "/tmp/tof_translations/"

languages = ["en", "pl"]

translations_data = {
    "core": {},
    "common": {},
}

# Load core translations
print("Loading from " + translations_folder)

for filename in translations_data.keys():
    print("  Loading " + filename)
    for language in languages:
        with open(translations_folder + filename + "." + language + ".csv") as csvfile:
            csvreader = csv.reader(csvfile)
            for row in csvreader:
                if row[0] == "keys":
                    continue
                if row[0] not in translations_data[filename]:
                    translations_data[filename][row[0]] = {}
                translations_data[filename][row[0]][language] = row[1]
        csvfile.close()

# Load campaign translations
print("Loading from " + campaigns_folder)

campaigns = [f for f in listdir(campaigns_folder) if isdir(join(campaigns_folder, f))]

for campaign in campaigns:
    print("  Loading " + campaign)
    with open(campaigns_folder + campaign + "/translations.json", "r") as campaign_translation_data:
        campaign_translation = json.load(campaign_translation_data)
    campaign_translation_data.close()

    translations_data[campaign] = {}

    for translation_key in campaign_translation["en"]:
        if translation_key not in translations_data[campaign]:
            translations_data[campaign][translation_key] = {}
        for language in languages:
            translations_data[campaign][translation_key][language] = campaign_translation[language][translation_key]

# Dump collected translations into separate files
print("Dumping output files")
translation_row = []
header_row = ["key"]
for language in languages:
    header_row.append(language)
for filename in translations_data.keys():
    print("  Dumping " + filename)
    with open(desitnation_folder + filename + ".csv", 'w') as destination_file:
        writer = csv.writer(destination_file)
        writer.writerow(header_row)
        for translation_key in translations_data[filename].keys():
            translation_row.clear()
            translation_row.append(translation_key)
            for language in languages:
                translation_row.append(translations_data[filename][translation_key][language])
            writer.writerow(translation_row)
        destination_file.close()
