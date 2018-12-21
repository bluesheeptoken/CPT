import json


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
        sum_length_sequence += len(sequence)
        number_sequences += 1
        for symbol in sequence:
            alphabet.add(symbol)
    return {"alphabet_length": len(alphabet),
            "sequence_avg_length": sum_length_sequence / number_sequences,
            "number_sequences": number_sequences}


def main():
    with open('partial_santander_product_recommandation.json') as file:
        partial_santander = json.load(file)

    with open('full_santander_product_recommandation.json') as file:
        full_santander = json.load(file)

    partial_fifa = load_dat_file('FIFA.dat')

    full_fifa = load_dat_file('FIFA_large.dat')

    metadata = {"partial_santander":
                generate_metadata(partial_santander.values()),
                "full_santander":
                generate_metadata(full_santander.values()),
                "partial_fifa":
                generate_metadata(partial_fifa),
                "full_fifa":
                generate_metadata(full_fifa)}

    with open('metadata.json', 'w') as file:
        file.write(json.dumps(metadata, indent=2, sort_keys=True))


if __name__ == '__main__':
    main()
