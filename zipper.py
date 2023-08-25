import json
import os
import time
import zipfile
import shutil

total_files_processed = 0
json_files_compressed = 0


def compress_json(file_data):
    return json.dumps(file_data, separators=(",", ":"), ensure_ascii=False).encode("utf-8")


def process_file(path, destination_archive):
    global total_files_processed, json_files_compressed

    total_files_processed += 1

    if path.endswith(".json") or path.endswith(".mcmeta"):
        json_files_compressed += 1
        print("Compressing JSON : " + path)

        with open(path, "r", encoding="utf-8") as json_file:
            data = json.load(json_file)

        destination_archive.writestr(path, compress_json(data))
    else:
        destination_archive.write(path)


def main():
    start_time = time.time()

    pack_mcmeta_filename = "pack.mcmeta"
    white_list_filename = "white_list.txt"
    black_list_filename = "lite_black_list.txt"
    full_archive_name = "FULL_WMTextures-v%s.zip"
    lite_archive_name = "LITE_WMTextures-v%s.zip"

    # Check if required files exist

    for required_file in [pack_mcmeta_filename, white_list_filename, black_list_filename]:
        if not os.path.exists(required_file):
            print("Missing file : " + required_file)
            exit(1)

    # Get pack version

    with open(pack_mcmeta_filename, "r") as file:
        pack_mcmeta = file.read()

    if '"version": "' not in pack_mcmeta:
        print("Missing \"version\" in " + pack_mcmeta_filename)
        exit(1)

    pack_version = pack_mcmeta.split('"version": "')[1].split('"')[0]
    full_archive_name = full_archive_name % pack_version
    lite_archive_name = lite_archive_name % pack_version

    # Get white and black lists

    with open(white_list_filename, "r") as file:
        white_list = file.read().splitlines()

    with open(black_list_filename, "r") as file:
        black_list = file.read().splitlines()

    # Remove old archives

    if os.path.exists(full_archive_name):
        os.remove(full_archive_name)

    if os.path.exists(lite_archive_name):
        os.remove(lite_archive_name)

    # Create full archive with compressed JSON files

    with zipfile.ZipFile(full_archive_name, "w", zipfile.ZIP_DEFLATED) as zip_file_full:
        for white_path in white_list:
            if white_path.endswith('/') or white_path.endswith('\\'):
                for root, dirs, files in os.walk(white_path):
                    for file_path in files:
                        dest_path = os.path.join(root, file_path)
                        process_file(dest_path, zip_file_full)
            else:
                process_file(white_path, zip_file_full)

    # Create lite archive with compressed JSON files

    with zipfile.ZipFile(full_archive_name, "r") as zip_file_full:
        with zipfile.ZipFile(lite_archive_name, "w", zipfile.ZIP_DEFLATED) as zip_file_lite:
            for file in zip_file_full.infolist():
                if not any([file.filename.startswith(black_list_path) for black_list_path in black_list]):
                    zip_file_lite.writestr(file, zip_file_full.read(file))

    # Print summary

    console_width = shutil.get_terminal_size().columns
    decorative_line = "• ------------------------------ •".center(console_width)

    print(decorative_line)
    print("Process completed successfully".center(console_width))
    print(decorative_line)
    print(f"Time taken: {round(time.time() - start_time, 2)} seconds".center(console_width))
    print(f"Total files processed : {total_files_processed}".center(console_width))
    print(f"JSON files compressed : {json_files_compressed}".center(console_width))
    print("Size of the archives :".center(console_width))
    print(f"- Full : {round(os.path.getsize(full_archive_name) / 1024, 2)} KB".center(console_width))
    print(f"- Lite : {round(os.path.getsize(lite_archive_name) / 1024, 2)} KB".center(console_width))
    print(decorative_line)


if __name__ == "__main__":
    main()
