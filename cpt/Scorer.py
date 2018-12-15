class Scorer():
    def __init__(self, alphabet_length):
        self.alphabet_length = alphabet_length
        self.scoring = [0] * alphabet_length

    def predictable(self):
        return any(self.scoring)

    def update(self, consequent_sequences):
        for sequence in consequent_sequences:
            for element in sequence:
                self.scoring[element] += 1

    def best_n_predictions(self, number_predictions):
        return sorted(
            range(self.alphabet_length),
            key=lambda i: (self.scoring[i], i),
            reverse=True
        )[:number_predictions]
