
training_set = [['A', 'B', 'C'], ['A', 'B'], ['A', 'B', 'D'], ['B', 'C'], ['B', 'D', 'E']]

cpt = Cpt(max_level=2)
cpt.train(training_set)

target_sequence = ['A', 'B', 'C']

print(cpt.predict(target_sequence))
