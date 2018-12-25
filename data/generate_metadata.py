import json
import sys


def load_dat_file(path):
    with open(path, 'r') as file:
        sequences = [map(int, l.rstrip().split())
                     for l in file.readlines()]
    return sequences


def generate_metadata(data):
    sum_length_sequence = 0
    number_sequences = 0
    alphabet = set()
    for sequence in data:
        number_sequences += 1
        for symbol in sequence:
            alphabet.add(symbol)
            sum_length_sequence += 1
    return {"alphabet_length": len(alphabet),
            "sequence_avg_length": sum_length_sequence / number_sequences,
            "number_sequences": number_sequences}


def main():
    data_path, dataset_name = sys.argv[1:]  # pylint: disable=unbalanced-tuple-unpacking

    with open(data_path) as file:
        if data_path.endswith('.json'):
            data = list(json.load(file).values())
        else:
            data = [[int(x) for x in l.rstrip().split()]
                    for l in file.readlines()]

    with open('metadata.json') as file:
        try:
            metadata = json.load(file)
        except ValueError:  # Handle empty file
            metadata = {}

    metadata[dataset_name] = generate_metadata(data)

    with open('metadata.json', 'w+') as file:
        file.write(json.dumps(metadata, indent=2, sort_keys=True))


if __name__ == '__main__':
    main()
