import concurrent.futures
import json
import os
import time
import zipfile
import shutil
from PIL import Image

total_files_processed = 0
json_files_compressed = 0
png_files_compressed = 0


def path_without_pack_name(pack_name, path):
    return path[len(pack_name) + 1:]


def get_pack_names():
    pack_names = []

    for root, dirs, files in os.walk("."):
        if root == ".":
            for dir_name in dirs:
                if os.path.exists(os.path.join(dir_name, "pack.mcmeta")):
                    pack_names.append(dir_name)

    return pack_names


def compress_json(pack_name, json_path, destination_archive):
    print(f"Compressing JSON: {json_path}")

    destination_archive.writestr(
        path_without_pack_name(
            pack_name,
            json_path
        ),
        json.dumps(
            json.load(
                open(json_path, "r", encoding="utf-8")
            ),
            separators=(",", ":"),
            ensure_ascii=False
        ).encode("utf-8")
    )


def compress_png(pack_name, path, destination_archive):
    print(f"Compressing PNG: {path}")

    temp_png_path = f"{pack_name}/temp.png"

    Image.open(path).save(temp_png_path, optimize=True)
    destination_archive.write(
        temp_png_path,
        path_without_pack_name(pack_name, path)
    )


def process_file(pack_name, path, destination_archive):
    global total_files_processed, json_files_compressed, png_files_compressed

    total_files_processed += 1

    if path.endswith((".json", ".mcmeta")):
        json_files_compressed += 1
        compress_json(pack_name, path, destination_archive)
    elif path.endswith(".png"):
        png_files_compressed += 1
        compress_png(pack_name, path, destination_archive)
    else:
        destination_archive.write(path, path_without_pack_name(pack_name, path))


def process_pack(pack_name):
    with zipfile.ZipFile(f"{pack_name}.zip", "w", zipfile.ZIP_DEFLATED) as zip_file:
        for root, dirs, files in os.walk(pack_name):
            for file_path in files:
                process_file(
                    pack_name,
                    os.path.join(root, file_path),
                    zip_file
                )

    # Remove temp png file

    temp_png_path = f"{pack_name}/temp.png"

    if os.path.exists(temp_png_path):
        os.remove(temp_png_path)


def process_packs(pack_names):
    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = {executor.submit(process_pack, pack_name): pack_name for pack_name in pack_names}

        for future in concurrent.futures.as_completed(futures):
            pack_name = futures[future]

            try:
                future.result()
            except Exception as e:
                print(f"Error compressing {pack_name}: {e}")


def main():
    start_time = time.time()
    pack_names = get_pack_names()

    process_packs(pack_names)

    end_time = round(time.time() - start_time, 2)
    console_width = shutil.get_terminal_size().columns
    decorative_line = "• ------------------------------ •".center(console_width)

    print(decorative_line)
    print("Process completed successfully".center(console_width))
    print(decorative_line)
    print(f"Time taken: {end_time} seconds".center(console_width))
    print(f"Total files processed : {total_files_processed}".center(console_width))
    print(f"JSON files compressed : {json_files_compressed}".center(console_width))
    print(f"PNG files compressed : {png_files_compressed}".center(console_width))
    print("Size of the archives :".center(console_width))
    for pack_name in pack_names:
        zip_file_name = f"{pack_name}.zip"
        archive_size = round(os.path.getsize(zip_file_name) / 1024, 2)

        print(f"{zip_file_name} : {archive_size} KB".center(console_width))
    print(decorative_line)


if __name__ == "__main__":
    main()
