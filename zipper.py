import json
import os
import time
import zipfile


def compress_json(file_data):
    return json.dumps(file_data, separators=(",", ":"), ensure_ascii=False).encode("utf-8")


def process_file(path, archive):
    if path.endswith(".json") | path.endswith(".mcmeta"):
        print("Compressing JSON : " + path)

        with open(path, "r", encoding="utf-8") as json_file:
            data = json.load(json_file)

        compressed_data = compress_json(data)
        archive.writestr(path, compressed_data)
    else:
        archive.write(path)


start_time = time.time()

# Get pack version

if not os.path.exists("pack.mcmeta"):
    print("Missing file : pack.mcmeta")
    exit(1)

with open("pack.mcmeta", "r") as file:
    pack_mcmeta = file.read()

if '"version": "' not in pack_mcmeta:
    print("Missing \"version\" in pack.mcmeta")
    exit(1)

pack_version = pack_mcmeta.split('"version": "')[1].split('"')[0]

# Get white and black lists

white_list_archive_name = "FULL_WMTextures-v%s.zip" % pack_version
black_list_archive_name = "LITE_WMTextures-v%s.zip" % pack_version

white_list_filename = "white_list.txt"
black_list_filename = "black_list.txt"

if not os.path.exists(white_list_filename):
    print("Missing file : " + white_list_filename)
    exit(1)

if not os.path.exists(black_list_filename):
    print("Missing file : " + black_list_filename)
    exit(1)

with open(white_list_filename, "r") as file:
    white_list = file.read().splitlines()

with open(black_list_filename, "r") as file:
    black_list = file.read().splitlines()

# Remove old archives

if os.path.exists(white_list_archive_name):
    os.remove(white_list_archive_name)

if os.path.exists(black_list_archive_name):
    os.remove(black_list_archive_name)

# Create full archive with compressed JSON files

with zipfile.ZipFile(white_list_archive_name, "w", zipfile.ZIP_DEFLATED) as zip_file:
    for file_path in white_list:
        if file_path.endswith('/'):
            folder_name = os.path.basename(os.path.normpath(file_path))

            for root, dirs, files in os.walk(file_path):
                for file_name in files:
                    dest_path = os.path.join(
                        folder_name,
                        os.path.relpath(os.path.join(root, file_name), start=file_path)
                    )

                    print("Processing : " + dest_path)
                    process_file(os.path.join(root, file_name), zip_file)
        else:
            print("Processing : " + file_path)
            process_file(file_path, zip_file)

# Create lite archive with compressed JSON files

with zipfile.ZipFile(white_list_archive_name, "r") as zip_file_full:
    with zipfile.ZipFile(black_list_archive_name, "w", zipfile.ZIP_DEFLATED) as zip_file_lite:
        for file in zip_file_full.infolist():
            file_path = file.filename

            if not any([file_path.startswith(black_list_path) for black_list_path in black_list]):
                zip_file_lite.writestr(file, zip_file_full.read(file))

print("Done in %s seconds" % round(time.time() - start_time, 2))
