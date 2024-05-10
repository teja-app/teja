import os


def find_dart_files(directory):
    dart_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart') and not file.endswith('.g.dart'):
                dart_files.append(os.path.join(root, file))
    return dart_files


def read_big_lines(file_path, line_length_threshold):
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    line_count = len(lines)
    if line_count > line_length_threshold:
        return [(1, line_count)]  # Return a single tuple with the line count
    else:
        return []


# Example usage
current_dir = os.getcwd()
libs_directory = os.path.join(current_dir, 'lib')
# print(libs_directory)
line_length_threshold = 300

dart_files = find_dart_files(libs_directory)
# print(dart_files)

for dart_file in dart_files:
    big_lines = read_big_lines(dart_file, line_length_threshold)
    if big_lines:
        print(f"\nFile: {dart_file}")
        print(f"Lines exceeding {line_length_threshold} characters:")
        for line_number, line_length in big_lines:
            print(f"Line {line_number}: {line_length} characters")
